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

iswarya.o:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <displayTime>:
   0:	fe010113          	add	sp,sp,-32
   4:	00812e23          	sw	s0,28(sp)
   8:	02010413          	add	s0,sp,32
   c:	fea42623          	sw	a0,-20(s0)
  10:	feb42423          	sw	a1,-24(s0)
  14:	fec42223          	sw	a2,-28(s0)
  18:	00df6f33          	or	t5,t5,a3
  1c:	00ef6f33          	or	t5,t5,a4
  20:	00ff6f33          	or	t5,t5,a5
  24:	fed42623          	sw	a3,-20(s0)
  28:	fee42423          	sw	a4,-24(s0)
  2c:	fef42223          	sw	a5,-28(s0)
  30:	00000013          	nop
  34:	01c12403          	lw	s0,28(sp)
  38:	02010113          	add	sp,sp,32
  3c:	00008067          	ret

00000040 <displayAlarm>:
  40:	fe010113          	add	sp,sp,-32
  44:	00812e23          	sw	s0,28(sp)
  48:	02010413          	add	s0,sp,32
  4c:	fea42623          	sw	a0,-20(s0)
  50:	feb42423          	sw	a1,-24(s0)
  54:	00ef6f33          	or	t5,t5,a4
  58:	00ff6f33          	or	t5,t5,a5
  5c:	fee42623          	sw	a4,-20(s0)
  60:	fef42423          	sw	a5,-24(s0)
  64:	00000013          	nop
  68:	01c12403          	lw	s0,28(sp)
  6c:	02010113          	add	sp,sp,32
  70:	00008067          	ret

00000074 <isAlarmTime>:
  74:	fe010113          	add	sp,sp,-32
  78:	00812e23          	sw	s0,28(sp)
  7c:	02010413          	add	s0,sp,32
  80:	fea42623          	sw	a0,-20(s0)
  84:	feb42423          	sw	a1,-24(s0)
  88:	fec42223          	sw	a2,-28(s0)
  8c:	fed42023          	sw	a3,-32(s0)
  90:	fec42703          	lw	a4,-20(s0)
  94:	fe442783          	lw	a5,-28(s0)
  98:	00f71c63          	bne	a4,a5,b0 <.L4>
  9c:	fe842703          	lw	a4,-24(s0)
  a0:	fe042783          	lw	a5,-32(s0)
  a4:	00f71663          	bne	a4,a5,b0 <.L4>
  a8:	00100793          	li	a5,1
  ac:	0080006f          	j	b4 <.L6>

000000b0 <.L4>:
  b0:	00000793          	li	a5,0

000000b4 <.L6>:
  b4:	00078513          	mv	a0,a5
  b8:	01c12403          	lw	s0,28(sp)
  bc:	02010113          	add	sp,sp,32
  c0:	00008067          	ret

000000c4 <main>:
  c4:	fb010113          	add	sp,sp,-80
  c8:	04112623          	sw	ra,76(sp)
  cc:	04812423          	sw	s0,72(sp)
  d0:	05010413          	add	s0,sp,80
  d4:	fe042423          	sw	zero,-24(s0)
  d8:	fe042223          	sw	zero,-28(s0)
  dc:	fe042023          	sw	zero,-32(s0)
  e0:	00000513          	li	a0,0
  e4:	00000097          	auipc	ra,0x0
  e8:	000080e7          	jalr	ra # e4 <main+0x20>
  ec:	00050713          	mv	a4,a0
  f0:	00058793          	mv	a5,a1
  f4:	fce42023          	sw	a4,-64(s0)
  f8:	fcf42223          	sw	a5,-60(s0)
  fc:	fc040793          	add	a5,s0,-64
 100:	00078513          	mv	a0,a5
 104:	00000097          	auipc	ra,0x0
 108:	000080e7          	jalr	ra # 104 <main+0x40>
 10c:	fc040793          	add	a5,s0,-64
 110:	00078513          	mv	a0,a5
 114:	00000097          	auipc	ra,0x0
 118:	000080e7          	jalr	ra # 114 <main+0x50>
 11c:	00050793          	mv	a5,a0
 120:	00078593          	mv	a1,a5
 124:	000007b7          	lui	a5,0x0
 128:	00078513          	mv	a0,a5
 12c:	00000097          	auipc	ra,0x0
 130:	000080e7          	jalr	ra # 12c <main+0x68>
 134:	fe042623          	sw	zero,-20(s0)
 138:	fdc42783          	lw	a5,-36(s0)
 13c:	00179793          	sll	a5,a5,0x1
 140:	fcf42c23          	sw	a5,-40(s0)

00000144 <.L10>:
 144:	00000513          	li	a0,0
 148:	00000097          	auipc	ra,0x0
 14c:	000080e7          	jalr	ra # 148 <.L10+0x4>
 150:	00050713          	mv	a4,a0
 154:	00058793          	mv	a5,a1
 158:	fae42c23          	sw	a4,-72(s0)
 15c:	faf42e23          	sw	a5,-68(s0)
 160:	fb840793          	add	a5,s0,-72
 164:	00078513          	mv	a0,a5
 168:	00000097          	auipc	ra,0x0
 16c:	000080e7          	jalr	ra # 168 <.L10+0x24>
 170:	fca42a23          	sw	a0,-44(s0)
 174:	fd442783          	lw	a5,-44(s0)
 178:	0087a783          	lw	a5,8(a5) # 8 <displayTime+0x8>
 17c:	fef42423          	sw	a5,-24(s0)
 180:	fd442783          	lw	a5,-44(s0)
 184:	0047a783          	lw	a5,4(a5)
 188:	fef42223          	sw	a5,-28(s0)
 18c:	fd442783          	lw	a5,-44(s0)
 190:	0007a783          	lw	a5,0(a5)
 194:	fef42023          	sw	a5,-32(s0)
 198:	fe042603          	lw	a2,-32(s0)
 19c:	fe442583          	lw	a1,-28(s0)
 1a0:	fe842503          	lw	a0,-24(s0)
 1a4:	00000097          	auipc	ra,0x0
 1a8:	000080e7          	jalr	ra # 1a4 <.L10+0x60>
 1ac:	fcc42683          	lw	a3,-52(s0)
 1b0:	fd042603          	lw	a2,-48(s0)
 1b4:	fe442583          	lw	a1,-28(s0)
 1b8:	fe842503          	lw	a0,-24(s0)
 1bc:	00000097          	auipc	ra,0x0
 1c0:	000080e7          	jalr	ra # 1bc <.L10+0x78>
 1c4:	00050793          	mv	a5,a0
 1c8:	02078463          	beqz	a5,1f0 <.L8>
 1cc:	fec42783          	lw	a5,-20(s0)
 1d0:	02079063          	bnez	a5,1f0 <.L8>
 1d4:	00100793          	li	a5,1
 1d8:	fcf42e23          	sw	a5,-36(s0)
 1dc:	fdc42783          	lw	a5,-36(s0)
 1e0:	00179793          	sll	a5,a5,0x1
 1e4:	fcf42c23          	sw	a5,-40(s0)
 1e8:	00ff6f33          	or	t5,t5,a5
 1ec:	fcf42c23          	sw	a5,-40(s0)

000001f0 <.L8>:
 1f0:	fcc42683          	lw	a3,-52(s0)
 1f4:	fd042603          	lw	a2,-48(s0)
 1f8:	fe442583          	lw	a1,-28(s0)
 1fc:	fe842503          	lw	a0,-24(s0)
 200:	00000097          	auipc	ra,0x0
 204:	000080e7          	jalr	ra # 200 <.L8+0x10>
 208:	00050793          	mv	a5,a0
 20c:	00079463          	bnez	a5,214 <.L9>
 210:	fe042623          	sw	zero,-20(s0)

00000214 <.L9>:
 214:	00100513          	li	a0,1
 218:	00000097          	auipc	ra,0x0
 21c:	000080e7          	jalr	ra # 218 <.L9+0x4>
 220:	f25ff06f          	j	144 <.L10>


```

# Unique Instructions

Create a sample_assembly.txt file and dump the assembly code into this file.Now,run the instruction_counter.py file.

```

cd home/Documents/ASIC$ python3 instruction_counter.py

```

```

Number of different instructions: 16
List of unique instructions:
lw
j
mv
bnez
sll
sw
add
bne
or
auipc
lui
beqz
jalr
ret
li
nop

```



