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

void displayTime(int hours, int minutes, int seconds);
void displayAlarm(int hours, int minutes);
unsigned char read_keypad(void);
int isAlarmTime(int currentHours, int currentMinutes, int alarmHours, int alarmMinutes);


int main()
{
    int currentHours = 0, currentMinutes = 0, currentSeconds = 0;
    int alarmHours , alarmMinutes ;
    int alarmOffFlag = 0;
    int buzzer;
    int buzzer_reg = buzzer * 2;

    int h1 = read_keypad() - '0';
    int h2 = read_keypad() - '0';
    int m1 = read_keypad() - '0';
    int m2 = read_keypad() - '0';

    alarmHours = h1*10 + h2;
    alarmMinutes = m1*10 + m2;

    asm(
        "andi %0, x30, 1\n\t"
        :"=r"(alarmHours)
        :
        :
        );

    asm(
        "andi %0, x30, 1\n\t"
        :"=r"(alarmMinutes)
        :
        :
        );

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
            //printf("ALARM! ALARM! ALARM!\a\n");
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
    }

    return 0;
}





// Function to display the current time
void displayTime(int hours, int minutes, int seconds)
{
    // printf("Current Time: %02d:%02d:%02d\n", hours, minutes, seconds);
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
    // printf("Alarm Time: %02d:%02d\n", hours, minutes);
    asm (
        "or x30, x30, %0\n\t"
        "or x30, x30, %1\n\t"
        :
        :"r"(hours), "r"(minutes)
        :"x30"
        );
}

unsigned char read_keypad(void)
{
    unsigned char keypad;
    unsigned char row[5] = {14, 13, 11, 7, 0};
    unsigned char i = 0;
    // for(unsigned char i=14;i<9;i=i*2)
    while (row[i] > 0)
    {
        asm(
            "or x30, x30, %0\n\t"
            :
            :"r"(row[i])
            :"x30"
            );

        asm(
            "andi %0, x30, 240\n\t"
            :"=r"(keypad)
            :
            :
            );
        if (keypad != 240)
        {
            // unsigned char pressed=1;
            break;
        }
        i++;
    }
    if (row[i] == 0) // no button pressed
    {
        return -1;
    }
    else
    {
        if (row[i] == 14) // row=1
        {
            if (keypad == 224)
                keypad = 96; // 1
            else if (keypad == 208)
                keypad = 109; // 2
            else if (keypad == 176)
                keypad = 121; // 3
            else if (keypad == 112)
                keypad = 119; // A
        }
        else if (row[i] == 13) // row=2
        {
            if (keypad == 224)
                keypad = 51; // 4
            else if (keypad == 208)
                keypad = 91; // 5
            else if (keypad == 176)
                keypad = 94; // 6
            else if (keypad == 112)
                keypad = 15; // B
        }
        else if (row[i] == 11) // row=3
        {
            if (keypad == 224)
                keypad = 112; // 7
            else if (keypad == 208)
                keypad = 127; // 8
            else if (keypad == 176)
                keypad = 115; // 9
            else if (keypad == 112)
                keypad = 78; // C
        }
        else if (row[i] == 7) // row=4
        {
            if (keypad == 224)
                keypad = 1; //-
            else if (keypad == 208)
                keypad = 127; // 0
            else if (keypad == 176)
                keypad = 1; //-
            else if (keypad == 112)
                keypad = 125; // D
        }
    }

    return keypad;
}

// Function to check if the current time matches the alarm time
int isAlarmTime(int currentHours, int currentMinutes, int alarmHours, int alarmMinutes)
{
    return (currentHours == alarmHours && currentMinutes == alarmMinutes);
}



```

# Assembly Code

```
gcc clock.c
./a.out
/home/iswarya/riscv32-toolchain/bin riscv32-unknown-elf-gcc -mabi=ilp32 -march=rv32im -ffreestanding -nostdlib -o ./clock clock.c
riscv32-unknown-elf-objdump -d -r clock

```

```

clock:     file format elf32-littleriscv


Disassembly of section .text:

00010074 <main>:
   10074:	fc010113          	add	sp,sp,-64
   10078:	02112e23          	sw	ra,60(sp)
   1007c:	02812c23          	sw	s0,56(sp)
   10080:	04010413          	add	s0,sp,64
   10084:	fe042623          	sw	zero,-20(s0)
   10088:	fe042423          	sw	zero,-24(s0)
   1008c:	fe042223          	sw	zero,-28(s0)
   10090:	fe042023          	sw	zero,-32(s0)
   10094:	fdc42783          	lw	a5,-36(s0)
   10098:	00179793          	sll	a5,a5,0x1
   1009c:	fcf42c23          	sw	a5,-40(s0)
   100a0:	1e0000ef          	jal	10280 <read_keypad>
   100a4:	00050793          	mv	a5,a0
   100a8:	fd078793          	add	a5,a5,-48
   100ac:	fcf42a23          	sw	a5,-44(s0)
   100b0:	1d0000ef          	jal	10280 <read_keypad>
   100b4:	00050793          	mv	a5,a0
   100b8:	fd078793          	add	a5,a5,-48
   100bc:	fcf42823          	sw	a5,-48(s0)
   100c0:	1c0000ef          	jal	10280 <read_keypad>
   100c4:	00050793          	mv	a5,a0
   100c8:	fd078793          	add	a5,a5,-48
   100cc:	fcf42623          	sw	a5,-52(s0)
   100d0:	1b0000ef          	jal	10280 <read_keypad>
   100d4:	00050793          	mv	a5,a0
   100d8:	fd078793          	add	a5,a5,-48
   100dc:	fcf42423          	sw	a5,-56(s0)
   100e0:	fd442703          	lw	a4,-44(s0)
   100e4:	00070793          	mv	a5,a4
   100e8:	00279793          	sll	a5,a5,0x2
   100ec:	00e787b3          	add	a5,a5,a4
   100f0:	00179793          	sll	a5,a5,0x1
   100f4:	00078713          	mv	a4,a5
   100f8:	fd042783          	lw	a5,-48(s0)
   100fc:	00e787b3          	add	a5,a5,a4
   10100:	fcf42223          	sw	a5,-60(s0)
   10104:	fcc42703          	lw	a4,-52(s0)
   10108:	00070793          	mv	a5,a4
   1010c:	00279793          	sll	a5,a5,0x2
   10110:	00e787b3          	add	a5,a5,a4
   10114:	00179793          	sll	a5,a5,0x1
   10118:	00078713          	mv	a4,a5
   1011c:	fc842783          	lw	a5,-56(s0)
   10120:	00e787b3          	add	a5,a5,a4
   10124:	fcf42023          	sw	a5,-64(s0)
   10128:	001f7793          	and	a5,t5,1
   1012c:	fcf42223          	sw	a5,-60(s0)
   10130:	001f7793          	and	a5,t5,1
   10134:	fcf42023          	sw	a5,-64(s0)
   10138:	fe442783          	lw	a5,-28(s0)
   1013c:	00178793          	add	a5,a5,1
   10140:	fef42223          	sw	a5,-28(s0)
   10144:	fe442703          	lw	a4,-28(s0)
   10148:	03c00793          	li	a5,60
   1014c:	04f71063          	bne	a4,a5,1018c <main+0x118>
   10150:	fe042223          	sw	zero,-28(s0)
   10154:	fe842783          	lw	a5,-24(s0)
   10158:	00178793          	add	a5,a5,1
   1015c:	fef42423          	sw	a5,-24(s0)
   10160:	fe842703          	lw	a4,-24(s0)
   10164:	03c00793          	li	a5,60
   10168:	02f71263          	bne	a4,a5,1018c <main+0x118>
   1016c:	fe042423          	sw	zero,-24(s0)
   10170:	fec42783          	lw	a5,-20(s0)
   10174:	00178793          	add	a5,a5,1
   10178:	fef42623          	sw	a5,-20(s0)
   1017c:	fec42703          	lw	a4,-20(s0)
   10180:	01800793          	li	a5,24
   10184:	00f71463          	bne	a4,a5,1018c <main+0x118>
   10188:	fe042623          	sw	zero,-20(s0)
   1018c:	fe442603          	lw	a2,-28(s0)
   10190:	fe842583          	lw	a1,-24(s0)
   10194:	fec42503          	lw	a0,-20(s0)
   10198:	074000ef          	jal	1020c <displayTime>
   1019c:	fc042683          	lw	a3,-64(s0)
   101a0:	fc442603          	lw	a2,-60(s0)
   101a4:	fe842583          	lw	a1,-24(s0)
   101a8:	fec42503          	lw	a0,-20(s0)
   101ac:	354000ef          	jal	10500 <isAlarmTime>
   101b0:	00050793          	mv	a5,a0
   101b4:	02078463          	beqz	a5,101dc <main+0x168>
   101b8:	fe042783          	lw	a5,-32(s0)
   101bc:	02079063          	bnez	a5,101dc <main+0x168>
   101c0:	00100793          	li	a5,1
   101c4:	fcf42e23          	sw	a5,-36(s0)
   101c8:	fdc42783          	lw	a5,-36(s0)
   101cc:	00179793          	sll	a5,a5,0x1
   101d0:	fcf42c23          	sw	a5,-40(s0)
   101d4:	fd842783          	lw	a5,-40(s0)
   101d8:	00ff6f33          	or	t5,t5,a5
   101dc:	fc042683          	lw	a3,-64(s0)
   101e0:	fc442603          	lw	a2,-60(s0)
   101e4:	fe842583          	lw	a1,-24(s0)
   101e8:	fec42503          	lw	a0,-20(s0)
   101ec:	314000ef          	jal	10500 <isAlarmTime>
   101f0:	00050793          	mv	a5,a0
   101f4:	00079463          	bnez	a5,101fc <main+0x188>
   101f8:	fe042023          	sw	zero,-32(s0)
   101fc:	fc042583          	lw	a1,-64(s0)
   10200:	fc442503          	lw	a0,-60(s0)
   10204:	048000ef          	jal	1024c <displayAlarm>
   10208:	f31ff06f          	j	10138 <main+0xc4>

0001020c <displayTime>:
   1020c:	fe010113          	add	sp,sp,-32
   10210:	00812e23          	sw	s0,28(sp)
   10214:	02010413          	add	s0,sp,32
   10218:	fea42623          	sw	a0,-20(s0)
   1021c:	feb42423          	sw	a1,-24(s0)
   10220:	fec42223          	sw	a2,-28(s0)
   10224:	fec42783          	lw	a5,-20(s0)
   10228:	fe842703          	lw	a4,-24(s0)
   1022c:	fe442683          	lw	a3,-28(s0)
   10230:	00ff6f33          	or	t5,t5,a5
   10234:	00ef6f33          	or	t5,t5,a4
   10238:	00df6f33          	or	t5,t5,a3
   1023c:	00000013          	nop
   10240:	01c12403          	lw	s0,28(sp)
   10244:	02010113          	add	sp,sp,32
   10248:	00008067          	ret

0001024c <displayAlarm>:
   1024c:	fe010113          	add	sp,sp,-32
   10250:	00812e23          	sw	s0,28(sp)
   10254:	02010413          	add	s0,sp,32
   10258:	fea42623          	sw	a0,-20(s0)
   1025c:	feb42423          	sw	a1,-24(s0)
   10260:	fec42783          	lw	a5,-20(s0)
   10264:	fe842703          	lw	a4,-24(s0)
   10268:	00ff6f33          	or	t5,t5,a5
   1026c:	00ef6f33          	or	t5,t5,a4
   10270:	00000013          	nop
   10274:	01c12403          	lw	s0,28(sp)
   10278:	02010113          	add	sp,sp,32
   1027c:	00008067          	ret

00010280 <read_keypad>:
   10280:	fe010113          	add	sp,sp,-32
   10284:	00812e23          	sw	s0,28(sp)
   10288:	02010413          	add	s0,sp,32
   1028c:	070b17b7          	lui	a5,0x70b1
   10290:	d0e78793          	add	a5,a5,-754 # 70b0d0e <__global_pointer$+0x709efbe>
   10294:	fef42423          	sw	a5,-24(s0)
   10298:	fe040623          	sb	zero,-20(s0)
   1029c:	fe040723          	sb	zero,-18(s0)
   102a0:	0380006f          	j	102d8 <read_keypad+0x58>
   102a4:	fee44783          	lbu	a5,-18(s0)
   102a8:	ff078793          	add	a5,a5,-16
   102ac:	008787b3          	add	a5,a5,s0
   102b0:	ff87c783          	lbu	a5,-8(a5)
   102b4:	00ff6f33          	or	t5,t5,a5
   102b8:	0f0f7793          	and	a5,t5,240
   102bc:	fef407a3          	sb	a5,-17(s0)
   102c0:	fef44703          	lbu	a4,-17(s0)
   102c4:	0f000793          	li	a5,240
   102c8:	02f71463          	bne	a4,a5,102f0 <read_keypad+0x70>
   102cc:	fee44783          	lbu	a5,-18(s0)
   102d0:	00178793          	add	a5,a5,1
   102d4:	fef40723          	sb	a5,-18(s0)
   102d8:	fee44783          	lbu	a5,-18(s0)
   102dc:	ff078793          	add	a5,a5,-16
   102e0:	008787b3          	add	a5,a5,s0
   102e4:	ff87c783          	lbu	a5,-8(a5)
   102e8:	fa079ee3          	bnez	a5,102a4 <read_keypad+0x24>
   102ec:	0080006f          	j	102f4 <read_keypad+0x74>
   102f0:	00000013          	nop
   102f4:	fee44783          	lbu	a5,-18(s0)
   102f8:	ff078793          	add	a5,a5,-16
   102fc:	008787b3          	add	a5,a5,s0
   10300:	ff87c783          	lbu	a5,-8(a5)
   10304:	00079663          	bnez	a5,10310 <read_keypad+0x90>
   10308:	0ff00793          	li	a5,255
   1030c:	1e40006f          	j	104f0 <read_keypad+0x270>
   10310:	fee44783          	lbu	a5,-18(s0)
   10314:	ff078793          	add	a5,a5,-16
   10318:	008787b3          	add	a5,a5,s0
   1031c:	ff87c703          	lbu	a4,-8(a5)
   10320:	00e00793          	li	a5,14
   10324:	06f71263          	bne	a4,a5,10388 <read_keypad+0x108>
   10328:	fef44703          	lbu	a4,-17(s0)
   1032c:	0e000793          	li	a5,224
   10330:	00f71863          	bne	a4,a5,10340 <read_keypad+0xc0>
   10334:	06000793          	li	a5,96
   10338:	fef407a3          	sb	a5,-17(s0)
   1033c:	1b00006f          	j	104ec <read_keypad+0x26c>
   10340:	fef44703          	lbu	a4,-17(s0)
   10344:	0d000793          	li	a5,208
   10348:	00f71863          	bne	a4,a5,10358 <read_keypad+0xd8>
   1034c:	06d00793          	li	a5,109
   10350:	fef407a3          	sb	a5,-17(s0)
   10354:	1980006f          	j	104ec <read_keypad+0x26c>
   10358:	fef44703          	lbu	a4,-17(s0)
   1035c:	0b000793          	li	a5,176
   10360:	00f71863          	bne	a4,a5,10370 <read_keypad+0xf0>
   10364:	07900793          	li	a5,121
   10368:	fef407a3          	sb	a5,-17(s0)
   1036c:	1800006f          	j	104ec <read_keypad+0x26c>
   10370:	fef44703          	lbu	a4,-17(s0)
   10374:	07000793          	li	a5,112
   10378:	16f71a63          	bne	a4,a5,104ec <read_keypad+0x26c>
   1037c:	07700793          	li	a5,119
   10380:	fef407a3          	sb	a5,-17(s0)
   10384:	1680006f          	j	104ec <read_keypad+0x26c>
   10388:	fee44783          	lbu	a5,-18(s0)
   1038c:	ff078793          	add	a5,a5,-16
   10390:	008787b3          	add	a5,a5,s0
   10394:	ff87c703          	lbu	a4,-8(a5)
   10398:	00d00793          	li	a5,13
   1039c:	06f71263          	bne	a4,a5,10400 <read_keypad+0x180>
   103a0:	fef44703          	lbu	a4,-17(s0)
   103a4:	0e000793          	li	a5,224
   103a8:	00f71863          	bne	a4,a5,103b8 <read_keypad+0x138>
   103ac:	03300793          	li	a5,51
   103b0:	fef407a3          	sb	a5,-17(s0)
   103b4:	1380006f          	j	104ec <read_keypad+0x26c>
   103b8:	fef44703          	lbu	a4,-17(s0)
   103bc:	0d000793          	li	a5,208
   103c0:	00f71863          	bne	a4,a5,103d0 <read_keypad+0x150>
   103c4:	05b00793          	li	a5,91
   103c8:	fef407a3          	sb	a5,-17(s0)
   103cc:	1200006f          	j	104ec <read_keypad+0x26c>
   103d0:	fef44703          	lbu	a4,-17(s0)
   103d4:	0b000793          	li	a5,176
   103d8:	00f71863          	bne	a4,a5,103e8 <read_keypad+0x168>
   103dc:	05e00793          	li	a5,94
   103e0:	fef407a3          	sb	a5,-17(s0)
   103e4:	1080006f          	j	104ec <read_keypad+0x26c>
   103e8:	fef44703          	lbu	a4,-17(s0)
   103ec:	07000793          	li	a5,112
   103f0:	0ef71e63          	bne	a4,a5,104ec <read_keypad+0x26c>
   103f4:	00f00793          	li	a5,15
   103f8:	fef407a3          	sb	a5,-17(s0)
   103fc:	0f00006f          	j	104ec <read_keypad+0x26c>
   10400:	fee44783          	lbu	a5,-18(s0)
   10404:	ff078793          	add	a5,a5,-16
   10408:	008787b3          	add	a5,a5,s0
   1040c:	ff87c703          	lbu	a4,-8(a5)
   10410:	00b00793          	li	a5,11
   10414:	06f71263          	bne	a4,a5,10478 <read_keypad+0x1f8>
   10418:	fef44703          	lbu	a4,-17(s0)
   1041c:	0e000793          	li	a5,224
   10420:	00f71863          	bne	a4,a5,10430 <read_keypad+0x1b0>
   10424:	07000793          	li	a5,112
   10428:	fef407a3          	sb	a5,-17(s0)
   1042c:	0c00006f          	j	104ec <read_keypad+0x26c>
   10430:	fef44703          	lbu	a4,-17(s0)
   10434:	0d000793          	li	a5,208
   10438:	00f71863          	bne	a4,a5,10448 <read_keypad+0x1c8>
   1043c:	07f00793          	li	a5,127
   10440:	fef407a3          	sb	a5,-17(s0)
   10444:	0a80006f          	j	104ec <read_keypad+0x26c>
   10448:	fef44703          	lbu	a4,-17(s0)
   1044c:	0b000793          	li	a5,176
   10450:	00f71863          	bne	a4,a5,10460 <read_keypad+0x1e0>
   10454:	07300793          	li	a5,115
   10458:	fef407a3          	sb	a5,-17(s0)
   1045c:	0900006f          	j	104ec <read_keypad+0x26c>
   10460:	fef44703          	lbu	a4,-17(s0)
   10464:	07000793          	li	a5,112
   10468:	08f71263          	bne	a4,a5,104ec <read_keypad+0x26c>
   1046c:	04e00793          	li	a5,78
   10470:	fef407a3          	sb	a5,-17(s0)
   10474:	0780006f          	j	104ec <read_keypad+0x26c>
   10478:	fee44783          	lbu	a5,-18(s0)
   1047c:	ff078793          	add	a5,a5,-16
   10480:	008787b3          	add	a5,a5,s0
   10484:	ff87c703          	lbu	a4,-8(a5)
   10488:	00700793          	li	a5,7
   1048c:	06f71063          	bne	a4,a5,104ec <read_keypad+0x26c>
   10490:	fef44703          	lbu	a4,-17(s0)
   10494:	0e000793          	li	a5,224
   10498:	00f71863          	bne	a4,a5,104a8 <read_keypad+0x228>
   1049c:	00100793          	li	a5,1
   104a0:	fef407a3          	sb	a5,-17(s0)
   104a4:	0480006f          	j	104ec <read_keypad+0x26c>
   104a8:	fef44703          	lbu	a4,-17(s0)
   104ac:	0d000793          	li	a5,208
   104b0:	00f71863          	bne	a4,a5,104c0 <read_keypad+0x240>
   104b4:	07f00793          	li	a5,127
   104b8:	fef407a3          	sb	a5,-17(s0)
   104bc:	0300006f          	j	104ec <read_keypad+0x26c>
   104c0:	fef44703          	lbu	a4,-17(s0)
   104c4:	0b000793          	li	a5,176
   104c8:	00f71863          	bne	a4,a5,104d8 <read_keypad+0x258>
   104cc:	00100793          	li	a5,1
   104d0:	fef407a3          	sb	a5,-17(s0)
   104d4:	0180006f          	j	104ec <read_keypad+0x26c>
   104d8:	fef44703          	lbu	a4,-17(s0)
   104dc:	07000793          	li	a5,112
   104e0:	00f71663          	bne	a4,a5,104ec <read_keypad+0x26c>
   104e4:	07d00793          	li	a5,125
   104e8:	fef407a3          	sb	a5,-17(s0)
   104ec:	fef44783          	lbu	a5,-17(s0)
   104f0:	00078513          	mv	a0,a5
   104f4:	01c12403          	lw	s0,28(sp)
   104f8:	02010113          	add	sp,sp,32
   104fc:	00008067          	ret

00010500 <isAlarmTime>:
   10500:	fe010113          	add	sp,sp,-32
   10504:	00812e23          	sw	s0,28(sp)
   10508:	02010413          	add	s0,sp,32
   1050c:	fea42623          	sw	a0,-20(s0)
   10510:	feb42423          	sw	a1,-24(s0)
   10514:	fec42223          	sw	a2,-28(s0)
   10518:	fed42023          	sw	a3,-32(s0)
   1051c:	fec42703          	lw	a4,-20(s0)
   10520:	fe442783          	lw	a5,-28(s0)
   10524:	00f71c63          	bne	a4,a5,1053c <isAlarmTime+0x3c>
   10528:	fe842703          	lw	a4,-24(s0)
   1052c:	fe042783          	lw	a5,-32(s0)
   10530:	00f71663          	bne	a4,a5,1053c <isAlarmTime+0x3c>
   10534:	00100793          	li	a5,1
   10538:	0080006f          	j	10540 <isAlarmTime+0x40>
   1053c:	00000793          	li	a5,0
   10540:	00078513          	mv	a0,a5
   10544:	01c12403          	lw	s0,28(sp)
   10548:	02010113          	add	sp,sp,32
   1054c:	00008067          	ret

```

# Unique Instructions

Create a sample_assembly.txt file and dump the assembly code into this file.Now,run the instruction_counter.py file.

```

 python3 instruction_counter.py

```

```

Number of different instructions: 18
List of unique instructions:
add
mv
lw
beqz
jal
or
lui
lbu
bne
and
sw
sll
j
ret
sb
nop
bnez
li



```





