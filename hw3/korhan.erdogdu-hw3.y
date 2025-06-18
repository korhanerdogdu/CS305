%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylineno;
int yylex();
void yyerror(const char *s);

// Struct definitions (moved here BEFORE %union)
typedef struct {
    int day, month, year;
    char raw[11];
    int line;
} Date;

typedef struct {
    int hour, minute;
    char raw[6];
    int line;
} Time;

typedef struct Meeting {
    int meetingLine;
    int number;
    char *description;
    Date startDate, endDate;
    Time startTime, endTime;
    char **locations;
    int locationCount;
    int isRecurring;
    int hasFreq;
    char freq[10];
    int hasRep;
    int repetitionCount;
    struct Meeting **subMeetings;
    int subMeetingCount;
    struct Meeting *parent;
} Meeting;

typedef struct MeetingList {
    Meeting **meetings;
    int count;
} MeetingList;

// Function prototypes
Meeting *createMeeting();
MeetingList *createMeetingList();
void addMeeting(MeetingList *list, Meeting *m);
void semantic_checks();
void generate_report();

// Globals
MeetingList *allMeetings = NULL;
%}

// Union block
%union {
    int num;
    char *str;
    Meeting *meetingPtr;
    MeetingList *meetingListPtr;
}

// Tokens
%token <str> tSTRING tIDENTIFIER tDATE tTIME
%token <num> tINTEGER
%token tSTARTMEETING tENDMEETING tSTARTSUBMEETINGS tENDSUBMEETINGS
%token tMEETINGNUMBER tDESCRIPTION tSTARTDATE tSTARTTIME tENDDATE tENDTIME
%token tLOCATIONS tISRECURRING tFREQUENCY tREPETITIONCOUNT
%token tDAILY tWEEKLY tMONTHLY tYEARLY tYES tNO
%token tASSIGN tCOMMA

%type <meetingPtr> meeting_block meeting_body
%type <meetingListPtr> meeting_list location_list optional_subs
%type <str> recurrence_type optional_frequency
%type <num> recurring_choice optional_repetitionCount

%%

program:
    meeting_list {
        semantic_checks();
        generate_report();
        exit(0);
    }
;

meeting_list:
    meeting_block {
        allMeetings = createMeetingList();
        addMeeting(allMeetings, $1);
    }
  | meeting_list meeting_block {
        addMeeting(allMeetings, $2);
    }
;

meeting_block:
    tSTARTMEETING tSTRING meeting_body tENDMEETING {
        $$ = $3;
        $$->description = $2;
        $$->meetingLine = yylineno;
    }
;

meeting_body:
    tMEETINGNUMBER tASSIGN tINTEGER
    tDESCRIPTION tASSIGN tSTRING
    tSTARTDATE tASSIGN tDATE
    tSTARTTIME tASSIGN tTIME
    tENDDATE tASSIGN tDATE
    tENDTIME tASSIGN tTIME
    tLOCATIONS tASSIGN location_list
    tISRECURRING tASSIGN recurring_choice
    optional_frequency
    optional_repetitionCount
    optional_subs
    {
        Meeting *m = createMeeting();
        m->number = $3;
        m->description = $6;

        sscanf($9, "%d.%d.%d", &m->startDate.day, &m->startDate.month, &m->startDate.year);
        strcpy(m->startDate.raw, $9);
        m->startDate.line = yylineno;

        sscanf($12, "%d.%d", &m->startTime.hour, &m->startTime.minute);
        strcpy(m->startTime.raw, $12);
        m->startTime.line = yylineno;

        sscanf($15, "%d.%d.%d", &m->endDate.day, &m->endDate.month, &m->endDate.year);
        strcpy(m->endDate.raw, $15);
        m->endDate.line = yylineno;

        sscanf($18, "%d.%d", &m->endTime.hour, &m->endTime.minute);
        strcpy(m->endTime.raw, $18);
        m->endTime.line = yylineno;

        m->locations = malloc(sizeof(char*) * $21->count);
        for (int i = 0; i < $21->count; i++)
            m->locations[i] = strdup($21->meetings[i]->description);
        m->locationCount = $21->count;

        m->isRecurring = $24;

        if ($25) {
            m->hasFreq = 1;
            strcpy(m->freq, $25);
        }

        if ($26) {
            m->hasRep = 1;
            m->repetitionCount = $26;
        }

        if ($27) {
            m->subMeetings = $27->meetings;
            m->subMeetingCount = $27->count;
            for (int i = 0; i < m->subMeetingCount; i++)
                m->subMeetings[i]->parent = m;
        }

        $$ = m;
    }
;

location_list:
    tIDENTIFIER {
        MeetingList *ml = createMeetingList();
        Meeting *m = createMeeting();
        m->description = strdup($1);
        addMeeting(ml, m);
        $$ = ml;
    }
  | location_list tCOMMA tIDENTIFIER {
        Meeting *m = createMeeting();
        m->description = strdup($3);
        addMeeting($1, m);
        $$ = $1;
    }
;

recurring_choice:
    tYES { $$ = 1; }
  | tNO  { $$ = 0; }
;

optional_frequency:
    /* empty */ { $$ = NULL; }
  | tFREQUENCY tASSIGN recurrence_type { $$ = $3; }
;

recurrence_type:
    tDAILY   { $$ = strdup("daily"); }
  | tWEEKLY  { $$ = strdup("weekly"); }
  | tMONTHLY { $$ = strdup("monthly"); }
  | tYEARLY  { $$ = strdup("yearly"); }
;

optional_repetitionCount:
    /* empty */ { $$ = 0; }
  | tREPETITIONCOUNT tASSIGN tINTEGER { $$ = $3; }
;

optional_subs:
    /* empty */ { $$ = NULL; }
  | tSTARTSUBMEETINGS meeting_list tENDSUBMEETINGS { $$ = $2; }
;

%%

void yyerror(const char *s) {
    printf("ERROR\n");
    exit(1);
}
