# RISC-V-Digital-Alarm-Clock

# RISC-V GNU Tool Chain

  RISC-V GNU Tool Chain is a  C and C++ cross-compiler. It supports two build modes: a generic ELF/Newlib toolchain and a more sophisticated Linux-ELF/glibc toolchain.


# Digital Alarm Clock

Alarm Clocks are very useful devices in today’s busy life. They are designed to make a signal / alarm at a specific time. The use of digital alarm clocks has increased over years with development in electronics.

The advantage of digital alarm clocks over analogue alarm clocks is that they require less power, the time can be set or reset easily and displays the time in digits. Design of a simple digital alarm clock is explained here.

Digital clocks are also known as LED clocks or liquid crystal displays (LCDs).

# Block Diagram

<img width="1420" alt="DIgital Alarm Clock" src="https://github.com/IswaryaIlanchezhiyan/RISC-V-Digital-Alarm-Clock/assets/140998760/9a8b702d-02a6-43ce-b6dd-aed45767c82b">



# C Code

```

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
    
   asm volatile(
        "andi %0, x30, 0x01\n\t"
        :"=r"(alarmHours)
        :
        :
        );

    asm volatile(
        "andi %0, x30, 0x02\n\t"
        :"=r"(alarmMinutes)
        :
        :
        );

    //for (j=0;j<100;j++)
    while(1)
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
        	
            //printf("ALARM! ALARM! ALARM!\a\n");
            int i;
       	    for(i=0;i<100;i++);
        	/*NULL STATEMENT*/;
           return i;
           
            
            // ------------------------------- add buzzer code here -----------------------------
            buzzer = 1;
            buzzer_reg = buzzer * 2;
            int mask = 0xFFFFFFFF;
            asm volatile(
            "or x30, x30, %0\n\t"
	    :
            :"r"(buzzer_reg), "r"(mask)
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
        for(i=0;i<100;i++);
        	/*NULL STATEMENT*/;
        
    }

    return 0;
}

// Function to display the current time
void displayTime(int hours, int minutes, int seconds)
{
     int mask = 0xFFFFFFFF;
     //printf("Current Time: %02d:%02d:%02d\n", hours, minutes, seconds);
    // -------------------------------add print asm over here -----------------------------------
    asm volatile(
        "or x30, x30, %0\n\t"
        "or x30, x30, %1\n\t"
        "or x30, x30, %2\n\t"
        :
        :"r"(hours), "r"(minutes), "r"(seconds), "r"(mask)
        :"x30"
        );
        

}

// Function to display the alarm time
void displayAlarm(int hours, int minutes)
{
    int mask = 0xFFFFFFFF;	
    //printf("Alarm Time: %02d:%02d\n", hours, minutes);
    asm volatile(
        "or x30, x30, %0\n\t"
        "or x30, x30, %1\n\t"
        :
        :"r"(hours), "r"(minutes), "r"(mask)
        :"x30"
        );
       

         
}


int isAlarmTime(int currentHours, int currentMinutes, int alarmHours, int alarmMinutes) {
	
    return (currentHours == alarmHours && currentMinutes == alarmMinutes);
   

}







```
# Compile the C Code

```

gcc onlyccode.c
./a.out

```

![Screenshot from 2023-10-25 13-43-44](https://github.com/IswaryaIlanchezhiyan/RISC-V-Digital-Alarm-Clock/assets/140998760/b2c5deaa-04b4-4697-90e1-9198e0aa17dd)

![Screenshot from 2023-10-25 13-43-58](https://github.com/IswaryaIlanchezhiyan/RISC-V-Digital-Alarm-Clock/assets/140998760/a7152c43-1e03-4f32-a638-eb901b3f7b01)

# Spike Simulation

Modified C code for Spike Simulation

```




```

```

riscv64-unknown-elf-gcc -march=rv64i -mabi=lp64 -ffreestanding -o out spike1.c
spike pk out

```
![Screenshot from 2023-10-25 13-55-04](https://github.com/IswaryaIlanchezhiyan/RISC-V-Digital-Alarm-Clock/assets/140998760/b23bdcdf-941b-4f08-ab31-e0be3304934d)

![Screenshot from 2023-10-25 13-55-13](https://github.com/IswaryaIlanchezhiyan/RISC-V-Digital-Alarm-Clock/assets/140998760/e858cc25-4323-4336-a5e9-86b10e7e7e35)


# Assembly Code

```

/home/iswarya/riscv_toolchain/riscv64-unknown-elf-gcc-8.3.0-2019.08.0-x86_64-linux-ubuntu14/bin riscv64-unkown-elf-gcc -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -o ./out spike_clock.c
riscv64-unknown-elf-objdump -d -r out > clock_assembly.txt

```

```




out:     file format elf32-littleriscv


Disassembly of section .text:

00010054 <main>:
   10054:	fc010113          	addi	sp,sp,-64
   10058:	02112e23          	sw	ra,60(sp)
   1005c:	02812c23          	sw	s0,56(sp)
   10060:	04010413          	addi	s0,sp,64
   10064:	fe042623          	sw	zero,-20(s0)
   10068:	fe042423          	sw	zero,-24(s0)
   1006c:	fe042223          	sw	zero,-28(s0)
   10070:	fc042823          	sw	zero,-48(s0)
   10074:	00100793          	li	a5,1
   10078:	fcf42623          	sw	a5,-52(s0)
   1007c:	fe042023          	sw	zero,-32(s0)
   10080:	fc842783          	lw	a5,-56(s0)
   10084:	00179793          	slli	a5,a5,0x1
   10088:	fcf42223          	sw	a5,-60(s0)
   1008c:	001f7793          	andi	a5,t5,1
   10090:	fcf42823          	sw	a5,-48(s0)
   10094:	002f7793          	andi	a5,t5,2
   10098:	fcf42623          	sw	a5,-52(s0)
   1009c:	fc042e23          	sw	zero,-36(s0)
   100a0:	1140006f          	j	101b4 <main+0x160>
   100a4:	fe442783          	lw	a5,-28(s0)
   100a8:	00178793          	addi	a5,a5,1
   100ac:	fef42223          	sw	a5,-28(s0)
   100b0:	fe442703          	lw	a4,-28(s0)
   100b4:	03c00793          	li	a5,60
   100b8:	04f71063          	bne	a4,a5,100f8 <main+0xa4>
   100bc:	fe042223          	sw	zero,-28(s0)
   100c0:	fe842783          	lw	a5,-24(s0)
   100c4:	00178793          	addi	a5,a5,1
   100c8:	fef42423          	sw	a5,-24(s0)
   100cc:	fe842703          	lw	a4,-24(s0)
   100d0:	03c00793          	li	a5,60
   100d4:	02f71263          	bne	a4,a5,100f8 <main+0xa4>
   100d8:	fe042423          	sw	zero,-24(s0)
   100dc:	fec42783          	lw	a5,-20(s0)
   100e0:	00178793          	addi	a5,a5,1
   100e4:	fef42623          	sw	a5,-20(s0)
   100e8:	fec42703          	lw	a4,-20(s0)
   100ec:	01800793          	li	a5,24
   100f0:	00f71463          	bne	a4,a5,100f8 <main+0xa4>
   100f4:	fe042623          	sw	zero,-20(s0)
   100f8:	fe442603          	lw	a2,-28(s0)
   100fc:	fe842583          	lw	a1,-24(s0)
   10100:	fec42503          	lw	a0,-20(s0)
   10104:	0d4000ef          	jal	ra,101d8 <displayTime>
   10108:	fcc42683          	lw	a3,-52(s0)
   1010c:	fd042603          	lw	a2,-48(s0)
   10110:	fe842583          	lw	a1,-24(s0)
   10114:	fec42503          	lw	a0,-20(s0)
   10118:	14c000ef          	jal	ra,10264 <isAlarmTime>
   1011c:	00050793          	mv	a5,a0
   10120:	02078c63          	beqz	a5,10158 <main+0x104>
   10124:	fe042783          	lw	a5,-32(s0)
   10128:	02079863          	bnez	a5,10158 <main+0x104>
   1012c:	fc042c23          	sw	zero,-40(s0)
   10130:	0100006f          	j	10140 <main+0xec>
   10134:	fd842783          	lw	a5,-40(s0)
   10138:	00178793          	addi	a5,a5,1
   1013c:	fcf42c23          	sw	a5,-40(s0)
   10140:	fd842703          	lw	a4,-40(s0)
   10144:	3b9ad7b7          	lui	a5,0x3b9ad
   10148:	9ff78793          	addi	a5,a5,-1537 # 3b9ac9ff <__global_pointer$+0x3b99af4b>
   1014c:	fee7d4e3          	bge	a5,a4,10134 <main+0xe0>
   10150:	fd842783          	lw	a5,-40(s0)
   10154:	0700006f          	j	101c4 <main+0x170>
   10158:	fcc42683          	lw	a3,-52(s0)
   1015c:	fd042603          	lw	a2,-48(s0)
   10160:	fe842583          	lw	a1,-24(s0)
   10164:	fec42503          	lw	a0,-20(s0)
   10168:	0fc000ef          	jal	ra,10264 <isAlarmTime>
   1016c:	00050793          	mv	a5,a0
   10170:	00079463          	bnez	a5,10178 <main+0x124>
   10174:	fe042023          	sw	zero,-32(s0)
   10178:	fcc42583          	lw	a1,-52(s0)
   1017c:	fd042503          	lw	a0,-48(s0)
   10180:	0a4000ef          	jal	ra,10224 <displayAlarm>
   10184:	fc042a23          	sw	zero,-44(s0)
   10188:	0100006f          	j	10198 <main+0x144>
   1018c:	fd442783          	lw	a5,-44(s0)
   10190:	00178793          	addi	a5,a5,1
   10194:	fcf42a23          	sw	a5,-44(s0)
   10198:	fd442703          	lw	a4,-44(s0)
   1019c:	009897b7          	lui	a5,0x989
   101a0:	67f78793          	addi	a5,a5,1663 # 98967f <__global_pointer$+0x977bcb>
   101a4:	fee7d4e3          	bge	a5,a4,1018c <main+0x138>
   101a8:	fdc42783          	lw	a5,-36(s0)
   101ac:	00178793          	addi	a5,a5,1
   101b0:	fcf42e23          	sw	a5,-36(s0)
   101b4:	fdc42703          	lw	a4,-36(s0)
   101b8:	06300793          	li	a5,99
   101bc:	eee7d4e3          	bge	a5,a4,100a4 <main+0x50>
   101c0:	00000793          	li	a5,0
   101c4:	00078513          	mv	a0,a5
   101c8:	03c12083          	lw	ra,60(sp)
   101cc:	03812403          	lw	s0,56(sp)
   101d0:	04010113          	addi	sp,sp,64
   101d4:	00008067          	ret

000101d8 <displayTime>:
   101d8:	fd010113          	addi	sp,sp,-48
   101dc:	02812623          	sw	s0,44(sp)
   101e0:	03010413          	addi	s0,sp,48
   101e4:	fca42e23          	sw	a0,-36(s0)
   101e8:	fcb42c23          	sw	a1,-40(s0)
   101ec:	fcc42a23          	sw	a2,-44(s0)
   101f0:	fff00793          	li	a5,-1
   101f4:	fef42623          	sw	a5,-20(s0)
   101f8:	fdc42783          	lw	a5,-36(s0)
   101fc:	fd842703          	lw	a4,-40(s0)
   10200:	fd442683          	lw	a3,-44(s0)
   10204:	fec42603          	lw	a2,-20(s0)
   10208:	00ff6f33          	or	t5,t5,a5
   1020c:	00ef6f33          	or	t5,t5,a4
   10210:	00df6f33          	or	t5,t5,a3
   10214:	00000013          	nop
   10218:	02c12403          	lw	s0,44(sp)
   1021c:	03010113          	addi	sp,sp,48
   10220:	00008067          	ret

00010224 <displayAlarm>:
   10224:	fd010113          	addi	sp,sp,-48
   10228:	02812623          	sw	s0,44(sp)
   1022c:	03010413          	addi	s0,sp,48
   10230:	fca42e23          	sw	a0,-36(s0)
   10234:	fcb42c23          	sw	a1,-40(s0)
   10238:	fff00793          	li	a5,-1
   1023c:	fef42623          	sw	a5,-20(s0)
   10240:	fdc42783          	lw	a5,-36(s0)
   10244:	fd842703          	lw	a4,-40(s0)
   10248:	fec42683          	lw	a3,-20(s0)
   1024c:	00ff6f33          	or	t5,t5,a5
   10250:	00ef6f33          	or	t5,t5,a4
   10254:	00000013          	nop
   10258:	02c12403          	lw	s0,44(sp)
   1025c:	03010113          	addi	sp,sp,48
   10260:	00008067          	ret

00010264 <isAlarmTime>:
   10264:	fe010113          	addi	sp,sp,-32
   10268:	00812e23          	sw	s0,28(sp)
   1026c:	02010413          	addi	s0,sp,32
   10270:	fea42623          	sw	a0,-20(s0)
   10274:	feb42423          	sw	a1,-24(s0)
   10278:	fec42223          	sw	a2,-28(s0)
   1027c:	fed42023          	sw	a3,-32(s0)
   10280:	fec42703          	lw	a4,-20(s0)
   10284:	fe442783          	lw	a5,-28(s0)
   10288:	00f71c63          	bne	a4,a5,102a0 <isAlarmTime+0x3c>
   1028c:	fe842703          	lw	a4,-24(s0)
   10290:	fe042783          	lw	a5,-32(s0)
   10294:	00f71663          	bne	a4,a5,102a0 <isAlarmTime+0x3c>
   10298:	00100793          	li	a5,1
   1029c:	0080006f          	j	102a4 <isAlarmTime+0x40>
   102a0:	00000793          	li	a5,0
   102a4:	00078513          	mv	a0,a5
   102a8:	01c12403          	lw	s0,28(sp)
   102ac:	02010113          	addi	sp,sp,32
   102b0:	00008067          	ret


```

# Unique Instructions

Create a sample_assembly.txt file and dump the assembly code into this file.Now,run the instruction_counter.py file.

```

 python3 instruction_counter.py

```

```
Number of different instructions: 17
List of unique instructions:
lw
jal
or
lui
bge
andi
beqz
bne
nop
li
sw
addi
slli
bnez
mv
ret
j


```





