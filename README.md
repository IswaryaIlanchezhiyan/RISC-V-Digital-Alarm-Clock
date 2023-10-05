# RISC-V-Digital-Alarm-Clock

# RISC-V GNU Tool Chain

  RISC-V GNU Tool Chain is a  C and C++ cross-compiler. It supports two build modes: a generic ELF/Newlib toolchain and a more sophisticated Linux-ELF/glibc toolchain.


# Digital Alarm Clock

Alarm Clocks are very useful devices in today’s busy life. They are designed to make a signal / alarm at a specific time. The use of digital alarm clocks has increased over years with development in electronics.

The advantage of digital alarm clocks over analogue alarm clocks is that they require less power, the time can be set or reset easily and displays the time in digits. Design of a simple digital alarm clock is explained here.

Digital clocks are also known as LED clocks or liquid crystal displays (LCDs).

# Block Diagram

![Digital Alarm Clock Block Diagram](https://github.com/IswaryaIlanchezhiyan/RISC-V-Digital-Alarm-Clock/assets/140998760/c282028d-482d-447f-bdba-ac5032e157b8)

# C Code

```

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

// Function to display the current time
void displayTime(int hours, int minutes, int seconds) {
    printf("Current Time: %02d:%02d:%02d\n", hours, minutes, seconds);
}

// Function to display the alarm time
void displayAlarm(int hours, int minutes) {
    printf("Alarm Time: %02d:%02d\n", hours, minutes);
}

// Function to check if the current time matches the alarm time
int isAlarmTime(int currentHours, int currentMinutes, int alarmHours, int alarmMinutes) {
    return (currentHours == alarmHours && currentMinutes == alarmMinutes);
}

int main() {
    int currentHours = 0, currentMinutes = 0, currentSeconds = 0;
    int alarmHours = 0, alarmMinutes = 0;

    // Set the alarm time (you can modify these values)
    alarmHours = 7;
    alarmMinutes = 30;

    while (1) {
        // Get the current time (in a real-world scenario, you'd use a library)
        // For simplicity, we increment the time every second in this example
        currentSeconds++;
        if (currentSeconds == 60) {
            currentSeconds = 0;
            currentMinutes++;
            if (currentMinutes == 60) {
                currentMinutes = 0;
                currentHours++;
                if (currentHours == 24) {
                    currentHours = 0;
                }
            }
        }

        // Display the current time
        displayTime(currentHours, currentMinutes, currentSeconds);

        // Check if it's alarm time
        if (isAlarmTime(currentHours, currentMinutes, alarmHours, alarmMinutes)) {
            printf("ALARM! ALARM! ALARM!\n");

            // In a real-world scenario, you'd probably want to play a sound here
            // For simplicity, we'll just wait for a few seconds before stopping the alarm
            sleep(5);
            printf("Alarm Stopped.\n");
        }

        // Display the alarm time
        displayAlarm(alarmHours, alarmMinutes);

        // Sleep for one second (in a real-world scenario, you'd use a timer interrupt)
        sleep(1);
        // Clear the console (in a real-world scenario, you'd update the display differently)
        system("clear");
    }

    return 0;
}

```

# Assembly Code

```
gcc sample.c
./a.out
riscv64-unknown-elf-gcc -c -mabi=lp32 -march=rv32i -o sample.o sample.c
riscv64-unknown-elf-objdump -d sample.o

```

```

iswarya.o:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <displayTime>:
   0:	fe010113          	add	sp,sp,-32
   4:	00112e23          	sw	ra,28(sp)
   8:	00812c23          	sw	s0,24(sp)
   c:	02010413          	add	s0,sp,32
  10:	fea42623          	sw	a0,-20(s0)
  14:	feb42423          	sw	a1,-24(s0)
  18:	fec42223          	sw	a2,-28(s0)
  1c:	fe442683          	lw	a3,-28(s0)
  20:	fe842603          	lw	a2,-24(s0)
  24:	fec42583          	lw	a1,-20(s0)
  28:	000007b7          	lui	a5,0x0
  2c:	00078513          	mv	a0,a5
  30:	00000097          	auipc	ra,0x0
  34:	000080e7          	jalr	ra # 30 <displayTime+0x30>
  38:	00000013          	nop
  3c:	01c12083          	lw	ra,28(sp)
  40:	01812403          	lw	s0,24(sp)
  44:	02010113          	add	sp,sp,32
  48:	00008067          	ret

0000004c <displayAlarm>:
  4c:	fe010113          	add	sp,sp,-32
  50:	00112e23          	sw	ra,28(sp)
  54:	00812c23          	sw	s0,24(sp)
  58:	02010413          	add	s0,sp,32
  5c:	fea42623          	sw	a0,-20(s0)
  60:	feb42423          	sw	a1,-24(s0)
  64:	fe842603          	lw	a2,-24(s0)
  68:	fec42583          	lw	a1,-20(s0)
  6c:	000007b7          	lui	a5,0x0
  70:	00078513          	mv	a0,a5
  74:	00000097          	auipc	ra,0x0
  78:	000080e7          	jalr	ra # 74 <displayAlarm+0x28>
  7c:	00000013          	nop
  80:	01c12083          	lw	ra,28(sp)
  84:	01812403          	lw	s0,24(sp)
  88:	02010113          	add	sp,sp,32
  8c:	00008067          	ret

00000090 <isAlarmTime>:
  90:	fe010113          	add	sp,sp,-32
  94:	00812e23          	sw	s0,28(sp)
  98:	02010413          	add	s0,sp,32
  9c:	fea42623          	sw	a0,-20(s0)
  a0:	feb42423          	sw	a1,-24(s0)
  a4:	fec42223          	sw	a2,-28(s0)
  a8:	fed42023          	sw	a3,-32(s0)
  ac:	fec42703          	lw	a4,-20(s0)
  b0:	fe442783          	lw	a5,-28(s0)
  b4:	00f71c63          	bne	a4,a5,cc <.L4>
  b8:	fe842703          	lw	a4,-24(s0)
  bc:	fe042783          	lw	a5,-32(s0)
  c0:	00f71663          	bne	a4,a5,cc <.L4>
  c4:	00100793          	li	a5,1
  c8:	0080006f          	j	d0 <.L6>

000000cc <.L4>:
  cc:	00000793          	li	a5,0

000000d0 <.L6>:
  d0:	00078513          	mv	a0,a5
  d4:	01c12403          	lw	s0,28(sp)
  d8:	02010113          	add	sp,sp,32
  dc:	00008067          	ret

000000e0 <main>:
  e0:	fd010113          	add	sp,sp,-48
  e4:	02112623          	sw	ra,44(sp)
  e8:	02812423          	sw	s0,40(sp)
  ec:	03010413          	add	s0,sp,48
  f0:	fe042623          	sw	zero,-20(s0)
  f4:	fe042423          	sw	zero,-24(s0)
  f8:	fe042223          	sw	zero,-28(s0)
  fc:	fe042023          	sw	zero,-32(s0)
 100:	fc042e23          	sw	zero,-36(s0)
 104:	fe042023          	sw	zero,-32(s0)
 108:	01e00793          	li	a5,30
 10c:	fcf42e23          	sw	a5,-36(s0)

00000110 <.L10>:
 110:	fe442783          	lw	a5,-28(s0)
 114:	00178793          	add	a5,a5,1 # 1 <displayTime+0x1>
 118:	fef42223          	sw	a5,-28(s0)
 11c:	fe442703          	lw	a4,-28(s0)
 120:	03c00793          	li	a5,60
 124:	04f71063          	bne	a4,a5,164 <.L8>
 128:	fe042223          	sw	zero,-28(s0)
 12c:	fe842783          	lw	a5,-24(s0)
 130:	00178793          	add	a5,a5,1
 134:	fef42423          	sw	a5,-24(s0)
 138:	fe842703          	lw	a4,-24(s0)
 13c:	03c00793          	li	a5,60
 140:	02f71263          	bne	a4,a5,164 <.L8>
 144:	fe042423          	sw	zero,-24(s0)
 148:	fec42783          	lw	a5,-20(s0)
 14c:	00178793          	add	a5,a5,1
 150:	fef42623          	sw	a5,-20(s0)
 154:	fec42703          	lw	a4,-20(s0)
 158:	01800793          	li	a5,24
 15c:	00f71463          	bne	a4,a5,164 <.L8>
 160:	fe042623          	sw	zero,-20(s0)

00000164 <.L8>:
 164:	fe442603          	lw	a2,-28(s0)
 168:	fe842583          	lw	a1,-24(s0)
 16c:	fec42503          	lw	a0,-20(s0)
 170:	00000097          	auipc	ra,0x0
 174:	000080e7          	jalr	ra # 170 <.L8+0xc>
 178:	fdc42683          	lw	a3,-36(s0)
 17c:	fe042603          	lw	a2,-32(s0)
 180:	fe842583          	lw	a1,-24(s0)
 184:	fec42503          	lw	a0,-20(s0)
 188:	00000097          	auipc	ra,0x0
 18c:	000080e7          	jalr	ra # 188 <.L8+0x24>
 190:	00050793          	mv	a5,a0
 194:	02078863          	beqz	a5,1c4 <.L9>
 198:	000007b7          	lui	a5,0x0
 19c:	00078513          	mv	a0,a5
 1a0:	00000097          	auipc	ra,0x0
 1a4:	000080e7          	jalr	ra # 1a0 <.L8+0x3c>
 1a8:	00500513          	li	a0,5
 1ac:	00000097          	auipc	ra,0x0
 1b0:	000080e7          	jalr	ra # 1ac <.L8+0x48>
 1b4:	000007b7          	lui	a5,0x0
 1b8:	00078513          	mv	a0,a5
 1bc:	00000097          	auipc	ra,0x0
 1c0:	000080e7          	jalr	ra # 1bc <.L8+0x58>

000001c4 <.L9>:
 1c4:	fdc42583          	lw	a1,-36(s0)
 1c8:	fe042503          	lw	a0,-32(s0)
 1cc:	00000097          	auipc	ra,0x0
 1d0:	000080e7          	jalr	ra # 1cc <.L9+0x8>
 1d4:	00100513          	li	a0,1
 1d8:	00000097          	auipc	ra,0x0
 1dc:	000080e7          	jalr	ra # 1d8 <.L9+0x14>
 1e0:	000007b7          	lui	a5,0x0
 1e4:	00078513          	mv	a0,a5
 1e8:	00000097          	auipc	ra,0x0
 1ec:	000080e7          	jalr	ra # 1e8 <.L9+0x24>
 1f0:	f21ff06f          	j	110 <.L10>

```

# Unique Instructions

Create a sample_assembly.txt file and dump the assembly code into this file.Now,run the instruction_counter.py file.

```

cd home/Documents/ASIC$ python3 instruction_counter.py

```

```



```



