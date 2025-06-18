Meeting "Meeting with the boss"
        meetingNumber = 12057
        description = "My monthly meetings with the boss.
                         We discuss the general monthly plans."
        startDate = 17.04.2025
        endDate = 17.04.2025
        startTime = 14.40
        endTime = 16.30
        locations = FENSG032
        isRecurring = yes
        frequency = monthly
        repetitionCount = 12
endMeeting

Meeting "Important project"
        meetingNumber = 13204
        description = "The meetings for our important project"
        startDate = 19.04.2025
        startTime = 09.00
        endDate = 26.04.2025
        endTime = 17.00
        locations = FENSG032,FASSG018,Company_Lounge
        isRecurring = no
        subMeetings
           Meeting "Design Meetings"
              meetingNumber = 13217
              description = "The meetings for the design"
              startDate = 19.04.2025
              startTime = 09.00
              endDate = 19.04.2025
              endTime = 16.00
              locations = FASSG018
              isRecurring = yes
              frequency = daily
              repetitionCount = 3
           endMeeting
           
           Meeting "Implementation Meetings"
              meetingNumber = 14935
              description = "The meetings for the implementation"
              startDate = 22.04.2025
              startTime = 10.00
              endDate = 22.04.2025
              endTime = 16.00
              locations = FENSG032
              isRecurring = yes
              frequency = daily
              repetitionCount = 4
           endMeeting
           
           Meeting "Presentation"
              meetingNumber = 23734
              description = "The presentation of the 
                               results of the project"
              startDate = 26.04.2025
              startTime = 13.00
              endDate = 26.04.2025
              endTime = 17.00
              locations = Company_Lounge
              isRecurring = no
           endMeeting
        endSubMeetings
endMeeting