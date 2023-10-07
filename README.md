# RISC-V-Digital-Alarm-Clock

# RISC-V GNU Tool Chain

  RISC-V GNU Tool Chain is a  C and C++ cross-compiler. It supports two build modes: a generic ELF/Newlib toolchain and a more sophisticated Linux-ELF/glibc toolchain.


# Digital Alarm Clock

Alarm Clocks are very useful devices in today’s busy life. They are designed to make a signal / alarm at a specific time. The use of digital alarm clocks has increased over years with development in electronics.

The advantage of digital alarm clocks over analogue alarm clocks is that they require less power, the time can be set or reset easily and displays the time in digits. Design of a simple digital alarm clock is explained here.

Digital clocks are also known as LED clocks or liquid crystal displays (LCDs).

# Block Diagram

![Digital Alarm Clock Block Diagram](https://github.com/IswaryaIlanchezhiyan/RISC-V-Digital-Alarm-Clock/assets/140998760/1fb9e8f4-2d43-42dd-b61f-b315de72da25)


# C Code

```

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include <signal.h>

// Function to display the current time
void displayTime(int hours, int minutes, int seconds)
{
    // printf("Current Time: %02d:%02d:%02d\n", hours, minutes, seconds);
    // -------------------------------add print asm over here -----------------------------------
    asm(
    "or x30, x30, %0\n\t"
    "or x30, x30, %1\n\t"
    "or x30, x30, %2\n\t"
    :"=r"(hours),"=r"(minutes),"=r"(seconds));
}

// Function to display the alarm time
void displayAlarm(int hours, int minutes)
{
    //printf("Alarm Time: %02d:%02d\n", hours, minutes);
    asm(
     "or x30, x30, %0\n\t"
     "or x30, x30, %1\n\t"
     :"=r"(hours),"=r"(minutes));
      
    
}


unsigned char read_keypad(void)
{
	unsigned char keypad;
	unsigned char row[5]={14,13,11,7,0};
	unsigned char i=0;
	//for(unsigned char i=14;i<9;i=i*2)
	while(row[i]>0)
	{
		asm(
	    	"or x30, x30, %0\n\t"
	    	:"=r"(row[i]));
	    	
	    	asm(
	    	"and %0, x30, 240\n\t"
	    	:"=r"(keypad));
	    	if(keypad!=240)
	    	{
	    		//unsigned char pressed=1;
	    		break;
		}
		i++;
		
	}
	if(row[i]==0)//no button pressed
	{
		return -1;
	}
	else
	{
		if(row[i]==14)//row=1
		{
			if(keypad==224) keypad=96;//1
			else if(keypad==208) keypad=109;//2
			else if(keypad==176) keypad=121;//3
			else if(keypad==112) keypad=119;//A
		}
		else if(row[i]==13)//row=2
		{
			if(keypad==224) keypad=51;//4
			else if(keypad==208) keypad=91;//5
			else if(keypad==176) keypad=94;//6
			else if(keypad==112) keypad=15;//B
		}
		else if(row[i]==11)//row=3
		{
			if(keypad==224) keypad=112;//7
			else if(keypad==208) keypad=127;//8
			else if(keypad==176) keypad=115;//9
			else if(keypad==112) keypad=78;//C
		}
		else if(row[i]==7)//row=4
		{
			if(keypad==224) keypad=1;//-
			else if(keypad==208) keypad=127;//0
			else if(keypad==176) keypad=1;//-
			else if(keypad==112) keypad=125;//D
		}
	}
	
        
        return keypad;
}

// Function to check if the current time matches the alarm time
int isAlarmTime(int currentHours, int currentMinutes, int alarmHours, int alarmMinutes)
{
    return (currentHours == alarmHours && currentMinutes == alarmMinutes);
}

// void alarmOffHandler(int sig_num)
// {
//     printf("%d", sig_num);
//     printf("Alarm Stopped.\n");
//     // alarmOffFlag = 1;
// }

int main()
{
    int currentHours = 0, currentMinutes = 0, currentSeconds = 0;
    int alarmHours, alarmMinutes;
    

    // Set the alarm time (you can modify these values)
     //printf("Enter alarm hour time: ");
     //scanf("%d", &alarmHours);

     //printf("Enter alarm minute time: ");
     //scanf("%d", &alarmMinutes);
     char h1 = read_keypad();
     char h2 = read_keypad();
     char m1 = read_keypad();
     char m2 = read_keypad();

    // ------------------- Add the scanf code here ----------------------------
    asm(
    "andi %0, x30, 1\n\t"
    :"=r"(alarmHours));
    
     asm(
    "andi %0, x30, 1\n\t"
    :"=r"(alarmMinutes));
    
    

    time_t t = time(0);
    time(&t);
    printf("%s", ctime(&t));

    // alarmHours = 7;
    // alarmMinutes = 30;

    int alarmOffFlag = 0;
    int buzzer;
    int buzzer_reg = buzzer * 2;

    while (1)
    {
        // Get the current time (in a real-world scenario, you'd use a library)
        // For simplicity, we increment the time every second in this example

        time_t now = time(NULL);
        struct tm *tm_struct = localtime(&now);

        currentHours = tm_struct->tm_hour;
        currentMinutes = tm_struct->tm_min;
        currentSeconds = tm_struct->tm_sec;

        // Display the current time
        displayTime(currentHours, currentMinutes, currentSeconds);

        // Check if it's alarm time
        if (isAlarmTime(currentHours, currentMinutes, alarmHours, alarmMinutes) && alarmOffFlag == 0)
        {
            //printf("ALARM! ALARM! ALARM!\a\n");
            // ------------------------------- add buzzer code here -----------------------------
            buzzer = 1;
            buzzer_reg = buzzer * 2;
            asm(
            "or x30, x30,%0 \n\t"
            :"=r"(buzzer_reg));
        }

        if (!isAlarmTime(currentHours, currentMinutes, alarmHours, alarmMinutes))
        {
            alarmOffFlag = 0;
        }

        // Display the alarm time
        displayAlarm(alarmHours, alarmMinutes);

        // Sleep for one second (in a real-world scenario, you'd use a timer interrupt)
        sleep(1);
        
    }

    return 0;
}

```

# Assembly Code

```
gcc sample.c
./a.out
riscv32-unknown-elf-gcc -c -mabi=ilp32 -march=rv32im -ffreestanding -o ./sample sample.c
riscv32-unknown-elf-objdump -d sample

```

```


```

# Unique Instructions

Create a sample_assembly.txt file and dump the assembly code into this file.Now,run the instruction_counter.py file.

```

cd home/Documents/ASIC$ python3 instruction_counter.py

```

```

Number of different instructions: 16
List of unique instructions:
li
j
jalr
bne
add
lw
lui
nop
beqz
or
sw
mv
auipc
bnez
sll
ret



```



