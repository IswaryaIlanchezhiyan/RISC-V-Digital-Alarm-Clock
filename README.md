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
# Compile the C Code

```

gcc clock.c
./a.out

```

![Screenshot from 2023-10-25 13-43-58](https://github.com/IswaryaIlanchezhiyan/RISC-V-Digital-Alarm-Clock/assets/140998760/6d6b95e6-469e-43fe-ac37-07c8e296e2fe)

![Screenshot from 2023-10-25 13-43-44](https://github.com/IswaryaIlanchezhiyan/RISC-V-Digital-Alarm-Clock/assets/140998760/2d7d3f0d-6f8b-4d29-bc52-162d578a61ef)


# Assembly Code

```

/home/iswarya/riscv_toolchain/riscv64-unknown-elf-gcc-8.3.0-2019.08.0-x86_64-linux-ubuntu14/bin riscv64-unkown-elf-gcc -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -o ./out clock.c
riscv64-unknown-elf-objdump -d -r out > sample_assembly.txt

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
   10070:	fe042023          	sw	zero,-32(s0)
   10074:	fdc42783          	lw	a5,-36(s0)
   10078:	00179793          	slli	a5,a5,0x1
   1007c:	fcf42c23          	sw	a5,-40(s0)
   10080:	1e0000ef          	jal	ra,10260 <read_keypad>
   10084:	00050793          	mv	a5,a0
   10088:	fd078793          	addi	a5,a5,-48
   1008c:	fcf42a23          	sw	a5,-44(s0)
   10090:	1d0000ef          	jal	ra,10260 <read_keypad>
   10094:	00050793          	mv	a5,a0
   10098:	fd078793          	addi	a5,a5,-48
   1009c:	fcf42823          	sw	a5,-48(s0)
   100a0:	1c0000ef          	jal	ra,10260 <read_keypad>
   100a4:	00050793          	mv	a5,a0
   100a8:	fd078793          	addi	a5,a5,-48
   100ac:	fcf42623          	sw	a5,-52(s0)
   100b0:	1b0000ef          	jal	ra,10260 <read_keypad>
   100b4:	00050793          	mv	a5,a0
   100b8:	fd078793          	addi	a5,a5,-48
   100bc:	fcf42423          	sw	a5,-56(s0)
   100c0:	fd442703          	lw	a4,-44(s0)
   100c4:	00070793          	mv	a5,a4
   100c8:	00279793          	slli	a5,a5,0x2
   100cc:	00e787b3          	add	a5,a5,a4
   100d0:	00179793          	slli	a5,a5,0x1
   100d4:	00078713          	mv	a4,a5
   100d8:	fd042783          	lw	a5,-48(s0)
   100dc:	00e787b3          	add	a5,a5,a4
   100e0:	fcf42223          	sw	a5,-60(s0)
   100e4:	fcc42703          	lw	a4,-52(s0)
   100e8:	00070793          	mv	a5,a4
   100ec:	00279793          	slli	a5,a5,0x2
   100f0:	00e787b3          	add	a5,a5,a4
   100f4:	00179793          	slli	a5,a5,0x1
   100f8:	00078713          	mv	a4,a5
   100fc:	fc842783          	lw	a5,-56(s0)
   10100:	00e787b3          	add	a5,a5,a4
   10104:	fcf42023          	sw	a5,-64(s0)
   10108:	001f7793          	andi	a5,t5,1
   1010c:	fcf42223          	sw	a5,-60(s0)
   10110:	001f7793          	andi	a5,t5,1
   10114:	fcf42023          	sw	a5,-64(s0)
   10118:	fe442783          	lw	a5,-28(s0)
   1011c:	00178793          	addi	a5,a5,1
   10120:	fef42223          	sw	a5,-28(s0)
   10124:	fe442703          	lw	a4,-28(s0)
   10128:	03c00793          	li	a5,60
   1012c:	04f71063          	bne	a4,a5,1016c <main+0x118>
   10130:	fe042223          	sw	zero,-28(s0)
   10134:	fe842783          	lw	a5,-24(s0)
   10138:	00178793          	addi	a5,a5,1
   1013c:	fef42423          	sw	a5,-24(s0)
   10140:	fe842703          	lw	a4,-24(s0)
   10144:	03c00793          	li	a5,60
   10148:	02f71263          	bne	a4,a5,1016c <main+0x118>
   1014c:	fe042423          	sw	zero,-24(s0)
   10150:	fec42783          	lw	a5,-20(s0)
   10154:	00178793          	addi	a5,a5,1
   10158:	fef42623          	sw	a5,-20(s0)
   1015c:	fec42703          	lw	a4,-20(s0)
   10160:	01800793          	li	a5,24
   10164:	00f71463          	bne	a4,a5,1016c <main+0x118>
   10168:	fe042623          	sw	zero,-20(s0)
   1016c:	fe442603          	lw	a2,-28(s0)
   10170:	fe842583          	lw	a1,-24(s0)
   10174:	fec42503          	lw	a0,-20(s0)
   10178:	074000ef          	jal	ra,101ec <displayTime>
   1017c:	fc042683          	lw	a3,-64(s0)
   10180:	fc442603          	lw	a2,-60(s0)
   10184:	fe842583          	lw	a1,-24(s0)
   10188:	fec42503          	lw	a0,-20(s0)
   1018c:	36c000ef          	jal	ra,104f8 <isAlarmTime>
   10190:	00050793          	mv	a5,a0
   10194:	02078463          	beqz	a5,101bc <main+0x168>
   10198:	fe042783          	lw	a5,-32(s0)
   1019c:	02079063          	bnez	a5,101bc <main+0x168>
   101a0:	00100793          	li	a5,1
   101a4:	fcf42e23          	sw	a5,-36(s0)
   101a8:	fdc42783          	lw	a5,-36(s0)
   101ac:	00179793          	slli	a5,a5,0x1
   101b0:	fcf42c23          	sw	a5,-40(s0)
   101b4:	fd842783          	lw	a5,-40(s0)
   101b8:	00ff6f33          	or	t5,t5,a5
   101bc:	fc042683          	lw	a3,-64(s0)
   101c0:	fc442603          	lw	a2,-60(s0)
   101c4:	fe842583          	lw	a1,-24(s0)
   101c8:	fec42503          	lw	a0,-20(s0)
   101cc:	32c000ef          	jal	ra,104f8 <isAlarmTime>
   101d0:	00050793          	mv	a5,a0
   101d4:	00079463          	bnez	a5,101dc <main+0x188>
   101d8:	fe042023          	sw	zero,-32(s0)
   101dc:	fc042583          	lw	a1,-64(s0)
   101e0:	fc442503          	lw	a0,-60(s0)
   101e4:	048000ef          	jal	ra,1022c <displayAlarm>
   101e8:	f31ff06f          	j	10118 <main+0xc4>

000101ec <displayTime>:
   101ec:	fe010113          	addi	sp,sp,-32
   101f0:	00812e23          	sw	s0,28(sp)
   101f4:	02010413          	addi	s0,sp,32
   101f8:	fea42623          	sw	a0,-20(s0)
   101fc:	feb42423          	sw	a1,-24(s0)
   10200:	fec42223          	sw	a2,-28(s0)
   10204:	fec42783          	lw	a5,-20(s0)
   10208:	fe842703          	lw	a4,-24(s0)
   1020c:	fe442683          	lw	a3,-28(s0)
   10210:	00ff6f33          	or	t5,t5,a5
   10214:	00ef6f33          	or	t5,t5,a4
   10218:	00df6f33          	or	t5,t5,a3
   1021c:	00000013          	nop
   10220:	01c12403          	lw	s0,28(sp)
   10224:	02010113          	addi	sp,sp,32
   10228:	00008067          	ret

0001022c <displayAlarm>:
   1022c:	fe010113          	addi	sp,sp,-32
   10230:	00812e23          	sw	s0,28(sp)
   10234:	02010413          	addi	s0,sp,32
   10238:	fea42623          	sw	a0,-20(s0)
   1023c:	feb42423          	sw	a1,-24(s0)
   10240:	fec42783          	lw	a5,-20(s0)
   10244:	fe842703          	lw	a4,-24(s0)
   10248:	00ff6f33          	or	t5,t5,a5
   1024c:	00ef6f33          	or	t5,t5,a4
   10250:	00000013          	nop
   10254:	01c12403          	lw	s0,28(sp)
   10258:	02010113          	addi	sp,sp,32
   1025c:	00008067          	ret

00010260 <read_keypad>:
   10260:	fe010113          	addi	sp,sp,-32
   10264:	00812e23          	sw	s0,28(sp)
   10268:	02010413          	addi	s0,sp,32
   1026c:	000117b7          	lui	a5,0x11
   10270:	54878793          	addi	a5,a5,1352 # 11548 <__DATA_BEGIN__>
   10274:	0007a703          	lw	a4,0(a5)
   10278:	fee42023          	sw	a4,-32(s0)
   1027c:	0047c783          	lbu	a5,4(a5)
   10280:	fef40223          	sb	a5,-28(s0)
   10284:	fe040723          	sb	zero,-18(s0)
   10288:	f0000793          	li	a5,-256
   1028c:	fef42423          	sw	a5,-24(s0)
   10290:	0400006f          	j	102d0 <read_keypad+0x70>
   10294:	fee44783          	lbu	a5,-18(s0)
   10298:	ff040713          	addi	a4,s0,-16
   1029c:	00f707b3          	add	a5,a4,a5
   102a0:	ff07c783          	lbu	a5,-16(a5)
   102a4:	fe842703          	lw	a4,-24(s0)
   102a8:	00ef7f33          	and	t5,t5,a4
   102ac:	00ff6f33          	or	t5,t5,a5
   102b0:	0f0f7793          	andi	a5,t5,240
   102b4:	fef407a3          	sb	a5,-17(s0)
   102b8:	fef44703          	lbu	a4,-17(s0)
   102bc:	0f000793          	li	a5,240
   102c0:	02f71463          	bne	a4,a5,102e8 <read_keypad+0x88>
   102c4:	fee44783          	lbu	a5,-18(s0)
   102c8:	00178793          	addi	a5,a5,1
   102cc:	fef40723          	sb	a5,-18(s0)
   102d0:	fee44783          	lbu	a5,-18(s0)
   102d4:	ff040713          	addi	a4,s0,-16
   102d8:	00f707b3          	add	a5,a4,a5
   102dc:	ff07c783          	lbu	a5,-16(a5)
   102e0:	fa079ae3          	bnez	a5,10294 <read_keypad+0x34>
   102e4:	0080006f          	j	102ec <read_keypad+0x8c>
   102e8:	00000013          	nop
   102ec:	fee44783          	lbu	a5,-18(s0)
   102f0:	ff040713          	addi	a4,s0,-16
   102f4:	00f707b3          	add	a5,a4,a5
   102f8:	ff07c783          	lbu	a5,-16(a5)
   102fc:	00079663          	bnez	a5,10308 <read_keypad+0xa8>
   10300:	0ff00793          	li	a5,255
   10304:	1e40006f          	j	104e8 <read_keypad+0x288>
   10308:	fee44783          	lbu	a5,-18(s0)
   1030c:	ff040713          	addi	a4,s0,-16
   10310:	00f707b3          	add	a5,a4,a5
   10314:	ff07c703          	lbu	a4,-16(a5)
   10318:	00e00793          	li	a5,14
   1031c:	06f71263          	bne	a4,a5,10380 <read_keypad+0x120>
   10320:	fef44703          	lbu	a4,-17(s0)
   10324:	0e000793          	li	a5,224
   10328:	00f71863          	bne	a4,a5,10338 <read_keypad+0xd8>
   1032c:	03000793          	li	a5,48
   10330:	fef407a3          	sb	a5,-17(s0)
   10334:	1b00006f          	j	104e4 <read_keypad+0x284>
   10338:	fef44703          	lbu	a4,-17(s0)
   1033c:	0d000793          	li	a5,208
   10340:	00f71863          	bne	a4,a5,10350 <read_keypad+0xf0>
   10344:	06d00793          	li	a5,109
   10348:	fef407a3          	sb	a5,-17(s0)
   1034c:	1980006f          	j	104e4 <read_keypad+0x284>
   10350:	fef44703          	lbu	a4,-17(s0)
   10354:	0b000793          	li	a5,176
   10358:	00f71863          	bne	a4,a5,10368 <read_keypad+0x108>
   1035c:	07900793          	li	a5,121
   10360:	fef407a3          	sb	a5,-17(s0)
   10364:	1800006f          	j	104e4 <read_keypad+0x284>
   10368:	fef44703          	lbu	a4,-17(s0)
   1036c:	07000793          	li	a5,112
   10370:	16f71a63          	bne	a4,a5,104e4 <read_keypad+0x284>
   10374:	07700793          	li	a5,119
   10378:	fef407a3          	sb	a5,-17(s0)
   1037c:	1680006f          	j	104e4 <read_keypad+0x284>
   10380:	fee44783          	lbu	a5,-18(s0)
   10384:	ff040713          	addi	a4,s0,-16
   10388:	00f707b3          	add	a5,a4,a5
   1038c:	ff07c703          	lbu	a4,-16(a5)
   10390:	00d00793          	li	a5,13
   10394:	06f71263          	bne	a4,a5,103f8 <read_keypad+0x198>
   10398:	fef44703          	lbu	a4,-17(s0)
   1039c:	0e000793          	li	a5,224
   103a0:	00f71863          	bne	a4,a5,103b0 <read_keypad+0x150>
   103a4:	03300793          	li	a5,51
   103a8:	fef407a3          	sb	a5,-17(s0)
   103ac:	1380006f          	j	104e4 <read_keypad+0x284>
   103b0:	fef44703          	lbu	a4,-17(s0)
   103b4:	0d000793          	li	a5,208
   103b8:	00f71863          	bne	a4,a5,103c8 <read_keypad+0x168>
   103bc:	05b00793          	li	a5,91
   103c0:	fef407a3          	sb	a5,-17(s0)
   103c4:	1200006f          	j	104e4 <read_keypad+0x284>
   103c8:	fef44703          	lbu	a4,-17(s0)
   103cc:	0b000793          	li	a5,176
   103d0:	00f71863          	bne	a4,a5,103e0 <read_keypad+0x180>
   103d4:	05e00793          	li	a5,94
   103d8:	fef407a3          	sb	a5,-17(s0)
   103dc:	1080006f          	j	104e4 <read_keypad+0x284>
   103e0:	fef44703          	lbu	a4,-17(s0)
   103e4:	07000793          	li	a5,112
   103e8:	0ef71e63          	bne	a4,a5,104e4 <read_keypad+0x284>
   103ec:	01f00793          	li	a5,31
   103f0:	fef407a3          	sb	a5,-17(s0)
   103f4:	0f00006f          	j	104e4 <read_keypad+0x284>
   103f8:	fee44783          	lbu	a5,-18(s0)
   103fc:	ff040713          	addi	a4,s0,-16
   10400:	00f707b3          	add	a5,a4,a5
   10404:	ff07c703          	lbu	a4,-16(a5)
   10408:	00b00793          	li	a5,11
   1040c:	06f71263          	bne	a4,a5,10470 <read_keypad+0x210>
   10410:	fef44703          	lbu	a4,-17(s0)
   10414:	0e000793          	li	a5,224
   10418:	00f71863          	bne	a4,a5,10428 <read_keypad+0x1c8>
   1041c:	07000793          	li	a5,112
   10420:	fef407a3          	sb	a5,-17(s0)
   10424:	0c00006f          	j	104e4 <read_keypad+0x284>
   10428:	fef44703          	lbu	a4,-17(s0)
   1042c:	0d000793          	li	a5,208
   10430:	00f71863          	bne	a4,a5,10440 <read_keypad+0x1e0>
   10434:	07f00793          	li	a5,127
   10438:	fef407a3          	sb	a5,-17(s0)
   1043c:	0a80006f          	j	104e4 <read_keypad+0x284>
   10440:	fef44703          	lbu	a4,-17(s0)
   10444:	0b000793          	li	a5,176
   10448:	00f71863          	bne	a4,a5,10458 <read_keypad+0x1f8>
   1044c:	07300793          	li	a5,115
   10450:	fef407a3          	sb	a5,-17(s0)
   10454:	0900006f          	j	104e4 <read_keypad+0x284>
   10458:	fef44703          	lbu	a4,-17(s0)
   1045c:	07000793          	li	a5,112
   10460:	08f71263          	bne	a4,a5,104e4 <read_keypad+0x284>
   10464:	04e00793          	li	a5,78
   10468:	fef407a3          	sb	a5,-17(s0)
   1046c:	0780006f          	j	104e4 <read_keypad+0x284>
   10470:	fee44783          	lbu	a5,-18(s0)
   10474:	ff040713          	addi	a4,s0,-16
   10478:	00f707b3          	add	a5,a4,a5
   1047c:	ff07c703          	lbu	a4,-16(a5)
   10480:	00700793          	li	a5,7
   10484:	06f71063          	bne	a4,a5,104e4 <read_keypad+0x284>
   10488:	fef44703          	lbu	a4,-17(s0)
   1048c:	0e000793          	li	a5,224
   10490:	00f71863          	bne	a4,a5,104a0 <read_keypad+0x240>
   10494:	00100793          	li	a5,1
   10498:	fef407a3          	sb	a5,-17(s0)
   1049c:	0480006f          	j	104e4 <read_keypad+0x284>
   104a0:	fef44703          	lbu	a4,-17(s0)
   104a4:	0d000793          	li	a5,208
   104a8:	00f71863          	bne	a4,a5,104b8 <read_keypad+0x258>
   104ac:	07e00793          	li	a5,126
   104b0:	fef407a3          	sb	a5,-17(s0)
   104b4:	0300006f          	j	104e4 <read_keypad+0x284>
   104b8:	fef44703          	lbu	a4,-17(s0)
   104bc:	0b000793          	li	a5,176
   104c0:	00f71863          	bne	a4,a5,104d0 <read_keypad+0x270>
   104c4:	00100793          	li	a5,1
   104c8:	fef407a3          	sb	a5,-17(s0)
   104cc:	0180006f          	j	104e4 <read_keypad+0x284>
   104d0:	fef44703          	lbu	a4,-17(s0)
   104d4:	07000793          	li	a5,112
   104d8:	00f71663          	bne	a4,a5,104e4 <read_keypad+0x284>
   104dc:	03d00793          	li	a5,61
   104e0:	fef407a3          	sb	a5,-17(s0)
   104e4:	fef44783          	lbu	a5,-17(s0)
   104e8:	00078513          	mv	a0,a5
   104ec:	01c12403          	lw	s0,28(sp)
   104f0:	02010113          	addi	sp,sp,32
   104f4:	00008067          	ret

000104f8 <isAlarmTime>:
   104f8:	fe010113          	addi	sp,sp,-32
   104fc:	00812e23          	sw	s0,28(sp)
   10500:	02010413          	addi	s0,sp,32
   10504:	fea42623          	sw	a0,-20(s0)
   10508:	feb42423          	sw	a1,-24(s0)
   1050c:	fec42223          	sw	a2,-28(s0)
   10510:	fed42023          	sw	a3,-32(s0)
   10514:	fec42703          	lw	a4,-20(s0)
   10518:	fe442783          	lw	a5,-28(s0)
   1051c:	00f71c63          	bne	a4,a5,10534 <isAlarmTime+0x3c>
   10520:	fe842703          	lw	a4,-24(s0)
   10524:	fe042783          	lw	a5,-32(s0)
   10528:	00f71663          	bne	a4,a5,10534 <isAlarmTime+0x3c>
   1052c:	00100793          	li	a5,1
   10530:	0080006f          	j	10538 <isAlarmTime+0x40>
   10534:	00000793          	li	a5,0
   10538:	00078513          	mv	a0,a5
   1053c:	01c12403          	lw	s0,28(sp)
   10540:	02010113          	addi	sp,sp,32
   10544:	00008067          	ret



```

# Unique Instructions

Create a sample_assembly.txt file and dump the assembly code into this file.Now,run the instruction_counter.py file.

```

 python3 instruction_counter.py

```

```
Number of different instructions: 20
List of unique instructions:
and
ret
j
or
sb
andi
addi
li
beqz
lw
bnez
lbu
add
bne
mv
sw
lui
nop
jal
slli





```





