%{
#include <stdio.h>
#include <stdlib.h>

// Function prototype for error handling
void yyerror(const char *s);
int yylex();
%}

// Token declarations from Flex file
%token tSTARTMEETING tENDMEETING
%token tSTARTSUBMEETINGS tENDSUBMEETINGS
%token tMEETINGNUMBER tDESCRIPTION tSTARTDATE tSTARTTIME tENDDATE tENDTIME
%token tLOCATIONS tISRECURRING tFREQUENCY tREPETITIONCOUNT
%token tDAILY tWEEKLY tMONTHLY tYEARLY
%token tYES tNO
%token tASSIGN tCOMMA
%token tIDENTIFIER tSTRING tINTEGER tDATE tTIME

// Precedence rules (not strictly required but useful)
%right tASSIGN
%left tCOMMA

%%  /* Grammar rules start here */

ms_program
    : meeting_list { printf("OK\n"); }
    ;

meeting_list
    : meeting_block
    | meeting_list meeting_block
    ;

meeting_block
    : tSTARTMEETING tSTRING meeting_body tENDMEETING
    ;

meeting_body
    : meetingNumber description startDate startTime endDate endTime locations isRecurring optional_fields
    ;

meetingNumber
    : tMEETINGNUMBER tASSIGN tINTEGER
    ;

description
    : tDESCRIPTION tASSIGN tSTRING
    ;

startDate
    : tSTARTDATE tASSIGN tDATE
    ;

startTime
    : tSTARTTIME tASSIGN tTIME
    ;

endDate
    : tENDDATE tASSIGN tDATE
    ;

endTime
    : tENDTIME tASSIGN tTIME
    ;

locations
    : tLOCATIONS tASSIGN location_list
    ;

location_list
    : tIDENTIFIER
    | location_list tCOMMA tIDENTIFIER
    ;

isRecurring
    : tISRECURRING tASSIGN tYES
    | tISRECURRING tASSIGN tNO
    ;

optional_fields
    : frequency repetitionCount optional_subMeetings
    | frequency optional_subMeetings
    | repetitionCount optional_subMeetings
    | optional_subMeetings
    ;

frequency
    : tFREQUENCY tASSIGN recurrence_type
    ;

recurrence_type
    : tDAILY
    | tWEEKLY
    | tMONTHLY
    | tYEARLY
    ;

repetitionCount
    : tREPETITIONCOUNT tASSIGN tINTEGER
    ;

optional_subMeetings
    : /* empty */
    | tSTARTSUBMEETINGS meeting_list tENDSUBMEETINGS
    ;

%%  /* End of grammar rules */

void yyerror(const char *s) {
    printf("ERROR\n");
    exit(1);
}

int main() {
    if (yyparse()) {
        printf("ERROR\n");
        return 1;
    } else {
        return 0;
    }
}
