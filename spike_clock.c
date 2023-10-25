#include <stdio.h>


void displayTime(int hours, int minutes, int seconds);
void displayAlarm(int hours, int minutes);
int isAlarmTime(int currentHours, int currentMinutes, int alarmHours, int alarmMinutes);



int main()
{
    
    int currentHours = 0, currentMinutes = 0, currentSeconds = 0;
    int alarmHours = 0 , alarmMinutes = 1 ;
    int alarmOffFlag = 0;
    int buzzer;
    int buzzer_reg = buzzer * 2;
    int j;

   
 

    while (1)
    {
        // Get the current time (in a real-world scenario, you'd use a library)
        // For simplicity, we increment the time every second in this example
        currentSeconds++;
        if (currentSeconds == 60)
        {
            currentSeconds = 0;
            currentMinutes++;
            if (currentMinutes == 60)
            {
                currentMinutes = 0;
                currentHours++;
                if (currentHours == 24)
                {
                    currentHours = 0;
                }
            }
        }
        
        // Display the current time
        displayTime(currentHours, currentMinutes, currentSeconds);

       

        // Check if it's alarm time
        if (isAlarmTime(currentHours, currentMinutes, alarmHours, alarmMinutes) && alarmOffFlag == 0)
        {
        	
            printf("ALARM! ALARM! ALARM!\a\n");
            int i;
        for(i=0;i<1000000000;i++);
        	/*NULL STATEMENT*/;
        return i;
           
            
            // ------------------------------- add buzzer code here -----------------------------
            buzzer = 1;
            buzzer_reg = buzzer * 2;
            asm(
            "or x30, x30, %0\n\t"
	    :
            :"r"(buzzer_reg)
            :"x30"
            );
        }

        if (!isAlarmTime(currentHours, currentMinutes, alarmHours, alarmMinutes))
        {
        
            alarmOffFlag = 0;
        }

        // Display the alarm time
        displayAlarm(alarmHours, alarmMinutes);

        // Sleep for one second (in a real-world scenario, you'd use a timer interrupt)
        // sleep(1);
        int i;
        for(i=0;i<10000000;i++);
        	/*NULL STATEMENT*/;
        
    }

    return 0;
}

// Function to display the current time
void displayTime(int hours, int minutes, int seconds)
{
     printf("Current Time: %02d:%02d:%02d\n", hours, minutes, seconds);
    // -------------------------------add print asm over here -----------------------------------
    asm(
        "or x30, x30, %0\n\t"
        "or x30, x30, %1\n\t"
        "or x30, x30, %2\n\t"
        :
        :"r"(hours), "r"(minutes), "r"(seconds)
        :"x30"
        );
        

}

// Function to display the alarm time
void displayAlarm(int hours, int minutes)
{	
    printf("Alarm Time: %02d:%02d\n", hours, minutes);
    asm (
        "or x30, x30, %0\n\t"
        "or x30, x30, %1\n\t"
        :
        :"r"(hours), "r"(minutes)
        :"x30"
        );
       

         
}


int isAlarmTime(int currentHours, int currentMinutes, int alarmHours, int alarmMinutes) {
	
    return (currentHours == alarmHours && currentMinutes == alarmMinutes);
   

}




