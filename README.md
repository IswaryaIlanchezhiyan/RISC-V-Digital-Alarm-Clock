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
/home/iswarya/riscv32-toolchain/bin riscv32-unknown-elf-gcc -c -mabi=ilp32 -march=rv32im -ffreestanding -nostdlib -o ./clock clock.c
riscv32-unknown-elf-objdump -d -r clock

```

```

clock:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <main>:
   0:	fc010113          	add	sp,sp,-64
   4:	02112e23          	sw	ra,60(sp)
   8:	02812c23          	sw	s0,56(sp)
   c:	04010413          	add	s0,sp,64
  10:	fe042623          	sw	zero,-20(s0)
  14:	fe042423          	sw	zero,-24(s0)
  18:	fe042223          	sw	zero,-28(s0)
  1c:	fe042023          	sw	zero,-32(s0)
  20:	fdc42783          	lw	a5,-36(s0)
  24:	00179793          	sll	a5,a5,0x1
  28:	fcf42c23          	sw	a5,-40(s0)
  2c:	00000097          	auipc	ra,0x0
			2c: R_RISCV_CALL_PLT	read_keypad
			2c: R_RISCV_RELAX	*ABS*
  30:	000080e7          	jalr	ra # 2c <main+0x2c>
  34:	00050793          	mv	a5,a0
  38:	fd078793          	add	a5,a5,-48
  3c:	fcf42a23          	sw	a5,-44(s0)
  40:	00000097          	auipc	ra,0x0
			40: R_RISCV_CALL_PLT	read_keypad
			40: R_RISCV_RELAX	*ABS*
  44:	000080e7          	jalr	ra # 40 <main+0x40>
  48:	00050793          	mv	a5,a0
  4c:	fd078793          	add	a5,a5,-48
  50:	fcf42823          	sw	a5,-48(s0)
  54:	00000097          	auipc	ra,0x0
			54: R_RISCV_CALL_PLT	read_keypad
			54: R_RISCV_RELAX	*ABS*
  58:	000080e7          	jalr	ra # 54 <main+0x54>
  5c:	00050793          	mv	a5,a0
  60:	fd078793          	add	a5,a5,-48
  64:	fcf42623          	sw	a5,-52(s0)
  68:	00000097          	auipc	ra,0x0
			68: R_RISCV_CALL_PLT	read_keypad
			68: R_RISCV_RELAX	*ABS*
  6c:	000080e7          	jalr	ra # 68 <main+0x68>
  70:	00050793          	mv	a5,a0
  74:	fd078793          	add	a5,a5,-48
  78:	fcf42423          	sw	a5,-56(s0)
  7c:	fd442703          	lw	a4,-44(s0)
  80:	00070793          	mv	a5,a4
  84:	00279793          	sll	a5,a5,0x2
  88:	00e787b3          	add	a5,a5,a4
  8c:	00179793          	sll	a5,a5,0x1
  90:	00078713          	mv	a4,a5
  94:	fd042783          	lw	a5,-48(s0)
  98:	00e787b3          	add	a5,a5,a4
  9c:	fcf42223          	sw	a5,-60(s0)
  a0:	fcc42703          	lw	a4,-52(s0)
  a4:	00070793          	mv	a5,a4
  a8:	00279793          	sll	a5,a5,0x2
  ac:	00e787b3          	add	a5,a5,a4
  b0:	00179793          	sll	a5,a5,0x1
  b4:	00078713          	mv	a4,a5
  b8:	fc842783          	lw	a5,-56(s0)
  bc:	00e787b3          	add	a5,a5,a4
  c0:	fcf42023          	sw	a5,-64(s0)
  c4:	001f7793          	and	a5,t5,1
  c8:	fcf42223          	sw	a5,-60(s0)
  cc:	001f7793          	and	a5,t5,1
  d0:	fcf42023          	sw	a5,-64(s0)

000000d4 <.L5>:
  d4:	fe442783          	lw	a5,-28(s0)
  d8:	00178793          	add	a5,a5,1
  dc:	fef42223          	sw	a5,-28(s0)
  e0:	fe442703          	lw	a4,-28(s0)
  e4:	03c00793          	li	a5,60
  e8:	04f71063          	bne	a4,a5,128 <.L2>
			e8: R_RISCV_BRANCH	.L2
  ec:	fe042223          	sw	zero,-28(s0)
  f0:	fe842783          	lw	a5,-24(s0)
  f4:	00178793          	add	a5,a5,1
  f8:	fef42423          	sw	a5,-24(s0)
  fc:	fe842703          	lw	a4,-24(s0)
 100:	03c00793          	li	a5,60
 104:	02f71263          	bne	a4,a5,128 <.L2>
			104: R_RISCV_BRANCH	.L2
 108:	fe042423          	sw	zero,-24(s0)
 10c:	fec42783          	lw	a5,-20(s0)
 110:	00178793          	add	a5,a5,1
 114:	fef42623          	sw	a5,-20(s0)
 118:	fec42703          	lw	a4,-20(s0)
 11c:	01800793          	li	a5,24
 120:	00f71463          	bne	a4,a5,128 <.L2>
			120: R_RISCV_BRANCH	.L2
 124:	fe042623          	sw	zero,-20(s0)

00000128 <.L2>:
 128:	fe442603          	lw	a2,-28(s0)
 12c:	fe842583          	lw	a1,-24(s0)
 130:	fec42503          	lw	a0,-20(s0)
 134:	00000097          	auipc	ra,0x0
			134: R_RISCV_CALL_PLT	displayTime
			134: R_RISCV_RELAX	*ABS*
 138:	000080e7          	jalr	ra # 134 <.L2+0xc>
 13c:	fc042683          	lw	a3,-64(s0)
 140:	fc442603          	lw	a2,-60(s0)
 144:	fe842583          	lw	a1,-24(s0)
 148:	fec42503          	lw	a0,-20(s0)
 14c:	00000097          	auipc	ra,0x0
			14c: R_RISCV_CALL_PLT	isAlarmTime
			14c: R_RISCV_RELAX	*ABS*
 150:	000080e7          	jalr	ra # 14c <.L2+0x24>
 154:	00050793          	mv	a5,a0
 158:	02078463          	beqz	a5,180 <.L3>
			158: R_RISCV_BRANCH	.L3
 15c:	fe042783          	lw	a5,-32(s0)
 160:	02079063          	bnez	a5,180 <.L3>
			160: R_RISCV_BRANCH	.L3
 164:	00100793          	li	a5,1
 168:	fcf42e23          	sw	a5,-36(s0)
 16c:	fdc42783          	lw	a5,-36(s0)
 170:	00179793          	sll	a5,a5,0x1
 174:	fcf42c23          	sw	a5,-40(s0)
 178:	fd842783          	lw	a5,-40(s0)
 17c:	00ff6f33          	or	t5,t5,a5

00000180 <.L3>:
 180:	fc042683          	lw	a3,-64(s0)
 184:	fc442603          	lw	a2,-60(s0)
 188:	fe842583          	lw	a1,-24(s0)
 18c:	fec42503          	lw	a0,-20(s0)
 190:	00000097          	auipc	ra,0x0
			190: R_RISCV_CALL_PLT	isAlarmTime
			190: R_RISCV_RELAX	*ABS*
 194:	000080e7          	jalr	ra # 190 <.L3+0x10>
 198:	00050793          	mv	a5,a0
 19c:	00079463          	bnez	a5,1a4 <.L4>
			19c: R_RISCV_BRANCH	.L4
 1a0:	fe042023          	sw	zero,-32(s0)

000001a4 <.L4>:
 1a4:	fc042583          	lw	a1,-64(s0)
 1a8:	fc442503          	lw	a0,-60(s0)
 1ac:	00000097          	auipc	ra,0x0
			1ac: R_RISCV_CALL_PLT	displayAlarm
			1ac: R_RISCV_RELAX	*ABS*
 1b0:	000080e7          	jalr	ra # 1ac <.L4+0x8>
 1b4:	f21ff06f          	j	d4 <.L5>
			1b4: R_RISCV_JAL	.L5

000001b8 <displayTime>:
 1b8:	fe010113          	add	sp,sp,-32
 1bc:	00812e23          	sw	s0,28(sp)
 1c0:	02010413          	add	s0,sp,32
 1c4:	fea42623          	sw	a0,-20(s0)
 1c8:	feb42423          	sw	a1,-24(s0)
 1cc:	fec42223          	sw	a2,-28(s0)
 1d0:	fec42783          	lw	a5,-20(s0)
 1d4:	fe842703          	lw	a4,-24(s0)
 1d8:	fe442683          	lw	a3,-28(s0)
 1dc:	00ff6f33          	or	t5,t5,a5
 1e0:	00ef6f33          	or	t5,t5,a4
 1e4:	00df6f33          	or	t5,t5,a3
 1e8:	00000013          	nop
 1ec:	01c12403          	lw	s0,28(sp)
 1f0:	02010113          	add	sp,sp,32
 1f4:	00008067          	ret

000001f8 <displayAlarm>:
 1f8:	fe010113          	add	sp,sp,-32
 1fc:	00812e23          	sw	s0,28(sp)
 200:	02010413          	add	s0,sp,32
 204:	fea42623          	sw	a0,-20(s0)
 208:	feb42423          	sw	a1,-24(s0)
 20c:	fec42783          	lw	a5,-20(s0)
 210:	fe842703          	lw	a4,-24(s0)
 214:	00ff6f33          	or	t5,t5,a5
 218:	00ef6f33          	or	t5,t5,a4
 21c:	00000013          	nop
 220:	01c12403          	lw	s0,28(sp)
 224:	02010113          	add	sp,sp,32
 228:	00008067          	ret

0000022c <read_keypad>:
 22c:	fe010113          	add	sp,sp,-32
 230:	00812e23          	sw	s0,28(sp)
 234:	02010413          	add	s0,sp,32
 238:	070b17b7          	lui	a5,0x70b1
 23c:	d0e78793          	add	a5,a5,-754 # 70b0d0e <.L36+0x70b0822>
 240:	fef42423          	sw	a5,-24(s0)
 244:	fe040623          	sb	zero,-20(s0)
 248:	fe040723          	sb	zero,-18(s0)
 24c:	0380006f          	j	284 <.L9>
			24c: R_RISCV_JAL	.L9

00000250 <.L12>:
 250:	fee44783          	lbu	a5,-18(s0)
 254:	ff078793          	add	a5,a5,-16
 258:	008787b3          	add	a5,a5,s0
 25c:	ff87c783          	lbu	a5,-8(a5)
 260:	00ff6f33          	or	t5,t5,a5
 264:	0f0f7793          	and	a5,t5,240
 268:	fef407a3          	sb	a5,-17(s0)
 26c:	fef44703          	lbu	a4,-17(s0)
 270:	0f000793          	li	a5,240
 274:	02f71463          	bne	a4,a5,29c <.L32>
			274: R_RISCV_BRANCH	.L32
 278:	fee44783          	lbu	a5,-18(s0)
 27c:	00178793          	add	a5,a5,1
 280:	fef40723          	sb	a5,-18(s0)

00000284 <.L9>:
 284:	fee44783          	lbu	a5,-18(s0)
 288:	ff078793          	add	a5,a5,-16
 28c:	008787b3          	add	a5,a5,s0
 290:	ff87c783          	lbu	a5,-8(a5)
 294:	fa079ee3          	bnez	a5,250 <.L12>
			294: R_RISCV_BRANCH	.L12
 298:	0080006f          	j	2a0 <.L11>
			298: R_RISCV_JAL	.L11

0000029c <.L32>:
 29c:	00000013          	nop

000002a0 <.L11>:
 2a0:	fee44783          	lbu	a5,-18(s0)
 2a4:	ff078793          	add	a5,a5,-16
 2a8:	008787b3          	add	a5,a5,s0
 2ac:	ff87c783          	lbu	a5,-8(a5)
 2b0:	00079663          	bnez	a5,2bc <.L13>
			2b0: R_RISCV_BRANCH	.L13
 2b4:	0ff00793          	li	a5,255
 2b8:	1e40006f          	j	49c <.L31>
			2b8: R_RISCV_JAL	.L31

000002bc <.L13>:
 2bc:	fee44783          	lbu	a5,-18(s0)
 2c0:	ff078793          	add	a5,a5,-16
 2c4:	008787b3          	add	a5,a5,s0
 2c8:	ff87c703          	lbu	a4,-8(a5)
 2cc:	00e00793          	li	a5,14
 2d0:	06f71263          	bne	a4,a5,334 <.L15>
			2d0: R_RISCV_BRANCH	.L15
 2d4:	fef44703          	lbu	a4,-17(s0)
 2d8:	0e000793          	li	a5,224
 2dc:	00f71863          	bne	a4,a5,2ec <.L16>
			2dc: R_RISCV_BRANCH	.L16
 2e0:	06000793          	li	a5,96
 2e4:	fef407a3          	sb	a5,-17(s0)
 2e8:	1b00006f          	j	498 <.L17>
			2e8: R_RISCV_JAL	.L17

000002ec <.L16>:
 2ec:	fef44703          	lbu	a4,-17(s0)
 2f0:	0d000793          	li	a5,208
 2f4:	00f71863          	bne	a4,a5,304 <.L18>
			2f4: R_RISCV_BRANCH	.L18
 2f8:	06d00793          	li	a5,109
 2fc:	fef407a3          	sb	a5,-17(s0)
 300:	1980006f          	j	498 <.L17>
			300: R_RISCV_JAL	.L17

00000304 <.L18>:
 304:	fef44703          	lbu	a4,-17(s0)
 308:	0b000793          	li	a5,176
 30c:	00f71863          	bne	a4,a5,31c <.L19>
			30c: R_RISCV_BRANCH	.L19
 310:	07900793          	li	a5,121
 314:	fef407a3          	sb	a5,-17(s0)
 318:	1800006f          	j	498 <.L17>
			318: R_RISCV_JAL	.L17

0000031c <.L19>:
 31c:	fef44703          	lbu	a4,-17(s0)
 320:	07000793          	li	a5,112
 324:	16f71a63          	bne	a4,a5,498 <.L17>
			324: R_RISCV_BRANCH	.L17
 328:	07700793          	li	a5,119
 32c:	fef407a3          	sb	a5,-17(s0)
 330:	1680006f          	j	498 <.L17>
			330: R_RISCV_JAL	.L17

00000334 <.L15>:
 334:	fee44783          	lbu	a5,-18(s0)
 338:	ff078793          	add	a5,a5,-16
 33c:	008787b3          	add	a5,a5,s0
 340:	ff87c703          	lbu	a4,-8(a5)
 344:	00d00793          	li	a5,13
 348:	06f71263          	bne	a4,a5,3ac <.L20>
			348: R_RISCV_BRANCH	.L20
 34c:	fef44703          	lbu	a4,-17(s0)
 350:	0e000793          	li	a5,224
 354:	00f71863          	bne	a4,a5,364 <.L21>
			354: R_RISCV_BRANCH	.L21
 358:	03300793          	li	a5,51
 35c:	fef407a3          	sb	a5,-17(s0)
 360:	1380006f          	j	498 <.L17>
			360: R_RISCV_JAL	.L17

00000364 <.L21>:
 364:	fef44703          	lbu	a4,-17(s0)
 368:	0d000793          	li	a5,208
 36c:	00f71863          	bne	a4,a5,37c <.L22>
			36c: R_RISCV_BRANCH	.L22
 370:	05b00793          	li	a5,91
 374:	fef407a3          	sb	a5,-17(s0)
 378:	1200006f          	j	498 <.L17>
			378: R_RISCV_JAL	.L17

0000037c <.L22>:
 37c:	fef44703          	lbu	a4,-17(s0)
 380:	0b000793          	li	a5,176
 384:	00f71863          	bne	a4,a5,394 <.L23>
			384: R_RISCV_BRANCH	.L23
 388:	05e00793          	li	a5,94
 38c:	fef407a3          	sb	a5,-17(s0)
 390:	1080006f          	j	498 <.L17>
			390: R_RISCV_JAL	.L17

00000394 <.L23>:
 394:	fef44703          	lbu	a4,-17(s0)
 398:	07000793          	li	a5,112
 39c:	0ef71e63          	bne	a4,a5,498 <.L17>
			39c: R_RISCV_BRANCH	.L17
 3a0:	00f00793          	li	a5,15
 3a4:	fef407a3          	sb	a5,-17(s0)
 3a8:	0f00006f          	j	498 <.L17>
			3a8: R_RISCV_JAL	.L17

000003ac <.L20>:
 3ac:	fee44783          	lbu	a5,-18(s0)
 3b0:	ff078793          	add	a5,a5,-16
 3b4:	008787b3          	add	a5,a5,s0
 3b8:	ff87c703          	lbu	a4,-8(a5)
 3bc:	00b00793          	li	a5,11
 3c0:	06f71263          	bne	a4,a5,424 <.L24>
			3c0: R_RISCV_BRANCH	.L24
 3c4:	fef44703          	lbu	a4,-17(s0)
 3c8:	0e000793          	li	a5,224
 3cc:	00f71863          	bne	a4,a5,3dc <.L25>
			3cc: R_RISCV_BRANCH	.L25
 3d0:	07000793          	li	a5,112
 3d4:	fef407a3          	sb	a5,-17(s0)
 3d8:	0c00006f          	j	498 <.L17>
			3d8: R_RISCV_JAL	.L17

000003dc <.L25>:
 3dc:	fef44703          	lbu	a4,-17(s0)
 3e0:	0d000793          	li	a5,208
 3e4:	00f71863          	bne	a4,a5,3f4 <.L26>
			3e4: R_RISCV_BRANCH	.L26
 3e8:	07f00793          	li	a5,127
 3ec:	fef407a3          	sb	a5,-17(s0)
 3f0:	0a80006f          	j	498 <.L17>
			3f0: R_RISCV_JAL	.L17

000003f4 <.L26>:
 3f4:	fef44703          	lbu	a4,-17(s0)
 3f8:	0b000793          	li	a5,176
 3fc:	00f71863          	bne	a4,a5,40c <.L27>
			3fc: R_RISCV_BRANCH	.L27
 400:	07300793          	li	a5,115
 404:	fef407a3          	sb	a5,-17(s0)
 408:	0900006f          	j	498 <.L17>
			408: R_RISCV_JAL	.L17

0000040c <.L27>:
 40c:	fef44703          	lbu	a4,-17(s0)
 410:	07000793          	li	a5,112
 414:	08f71263          	bne	a4,a5,498 <.L17>
			414: R_RISCV_BRANCH	.L17
 418:	04e00793          	li	a5,78
 41c:	fef407a3          	sb	a5,-17(s0)
 420:	0780006f          	j	498 <.L17>
			420: R_RISCV_JAL	.L17

00000424 <.L24>:
 424:	fee44783          	lbu	a5,-18(s0)
 428:	ff078793          	add	a5,a5,-16
 42c:	008787b3          	add	a5,a5,s0
 430:	ff87c703          	lbu	a4,-8(a5)
 434:	00700793          	li	a5,7
 438:	06f71063          	bne	a4,a5,498 <.L17>
			438: R_RISCV_BRANCH	.L17
 43c:	fef44703          	lbu	a4,-17(s0)
 440:	0e000793          	li	a5,224
 444:	00f71863          	bne	a4,a5,454 <.L28>
			444: R_RISCV_BRANCH	.L28
 448:	00100793          	li	a5,1
 44c:	fef407a3          	sb	a5,-17(s0)
 450:	0480006f          	j	498 <.L17>
			450: R_RISCV_JAL	.L17

00000454 <.L28>:
 454:	fef44703          	lbu	a4,-17(s0)
 458:	0d000793          	li	a5,208
 45c:	00f71863          	bne	a4,a5,46c <.L29>
			45c: R_RISCV_BRANCH	.L29
 460:	07f00793          	li	a5,127
 464:	fef407a3          	sb	a5,-17(s0)
 468:	0300006f          	j	498 <.L17>
			468: R_RISCV_JAL	.L17

0000046c <.L29>:
 46c:	fef44703          	lbu	a4,-17(s0)
 470:	0b000793          	li	a5,176
 474:	00f71863          	bne	a4,a5,484 <.L30>
			474: R_RISCV_BRANCH	.L30
 478:	00100793          	li	a5,1
 47c:	fef407a3          	sb	a5,-17(s0)
 480:	0180006f          	j	498 <.L17>
			480: R_RISCV_JAL	.L17

00000484 <.L30>:
 484:	fef44703          	lbu	a4,-17(s0)
 488:	07000793          	li	a5,112
 48c:	00f71663          	bne	a4,a5,498 <.L17>
			48c: R_RISCV_BRANCH	.L17
 490:	07d00793          	li	a5,125
 494:	fef407a3          	sb	a5,-17(s0)

00000498 <.L17>:
 498:	fef44783          	lbu	a5,-17(s0)

0000049c <.L31>:
 49c:	00078513          	mv	a0,a5
 4a0:	01c12403          	lw	s0,28(sp)
 4a4:	02010113          	add	sp,sp,32
 4a8:	00008067          	ret

000004ac <isAlarmTime>:
 4ac:	fe010113          	add	sp,sp,-32
 4b0:	00812e23          	sw	s0,28(sp)
 4b4:	02010413          	add	s0,sp,32
 4b8:	fea42623          	sw	a0,-20(s0)
 4bc:	feb42423          	sw	a1,-24(s0)
 4c0:	fec42223          	sw	a2,-28(s0)
 4c4:	fed42023          	sw	a3,-32(s0)
 4c8:	fec42703          	lw	a4,-20(s0)
 4cc:	fe442783          	lw	a5,-28(s0)
 4d0:	00f71c63          	bne	a4,a5,4e8 <.L34>
			4d0: R_RISCV_BRANCH	.L34
 4d4:	fe842703          	lw	a4,-24(s0)
 4d8:	fe042783          	lw	a5,-32(s0)
 4dc:	00f71663          	bne	a4,a5,4e8 <.L34>
			4dc: R_RISCV_BRANCH	.L34
 4e0:	00100793          	li	a5,1
 4e4:	0080006f          	j	4ec <.L36>
			4e4: R_RISCV_JAL	.L36

000004e8 <.L34>:
 4e8:	00000793          	li	a5,0

000004ec <.L36>:
 4ec:	00078513          	mv	a0,a5
 4f0:	01c12403          	lw	s0,28(sp)
 4f4:	02010113          	add	sp,sp,32
 4f8:	00008067          	ret


```

# Unique Instructions

Create a sample_assembly.txt file and dump the assembly code into this file.Now,run the instruction_counter.py file.

```

 python3 instruction_counter.py

```

```

Number of different instructions: 19
List of unique instructions:
beqz
lbu
jalr
add
or
sw
and
nop
lw
mv
bne
lui
ret
sll
sb
auipc
li
j
bnez


```





