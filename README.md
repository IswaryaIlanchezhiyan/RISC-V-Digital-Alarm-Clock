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
riscv64-unknown-elf-gcc -c -mabi=lp64 -march=rv64i -o sample.o sample.c
riscv64-unknown-elf-objdump -d sample.o

```

```

sample.o:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <displayTime>:
   0:	fe010113          	addi	sp,sp,-32
   4:	00113c23          	sd	ra,24(sp)
   8:	00813823          	sd	s0,16(sp)
   c:	02010413          	addi	s0,sp,32
  10:	00050793          	mv	a5,a0
  14:	00058693          	mv	a3,a1
  18:	00060713          	mv	a4,a2
  1c:	fef42623          	sw	a5,-20(s0)
  20:	00068793          	mv	a5,a3
  24:	fef42423          	sw	a5,-24(s0)
  28:	00070793          	mv	a5,a4
  2c:	fef42223          	sw	a5,-28(s0)
  30:	fe442683          	lw	a3,-28(s0)
  34:	fe842703          	lw	a4,-24(s0)
  38:	fec42783          	lw	a5,-20(s0)
  3c:	00070613          	mv	a2,a4
  40:	00078593          	mv	a1,a5
  44:	000007b7          	lui	a5,0x0
  48:	00078513          	mv	a0,a5
  4c:	00000097          	auipc	ra,0x0
  50:	000080e7          	jalr	ra # 4c <displayTime+0x4c>
  54:	00000013          	nop
  58:	01813083          	ld	ra,24(sp)
  5c:	01013403          	ld	s0,16(sp)
  60:	02010113          	addi	sp,sp,32
  64:	00008067          	ret

0000000000000068 <displayAlarm>:
  68:	fe010113          	addi	sp,sp,-32
  6c:	00113c23          	sd	ra,24(sp)
  70:	00813823          	sd	s0,16(sp)
  74:	02010413          	addi	s0,sp,32
  78:	00050793          	mv	a5,a0
  7c:	00058713          	mv	a4,a1
  80:	fef42623          	sw	a5,-20(s0)
  84:	00070793          	mv	a5,a4
  88:	fef42423          	sw	a5,-24(s0)
  8c:	fe842703          	lw	a4,-24(s0)
  90:	fec42783          	lw	a5,-20(s0)
  94:	00070613          	mv	a2,a4
  98:	00078593          	mv	a1,a5
  9c:	000007b7          	lui	a5,0x0
  a0:	00078513          	mv	a0,a5
  a4:	00000097          	auipc	ra,0x0
  a8:	000080e7          	jalr	ra # a4 <displayAlarm+0x3c>
  ac:	00000013          	nop
  b0:	01813083          	ld	ra,24(sp)
  b4:	01013403          	ld	s0,16(sp)
  b8:	02010113          	addi	sp,sp,32
  bc:	00008067          	ret

00000000000000c0 <isAlarmTime>:
  c0:	fe010113          	addi	sp,sp,-32
  c4:	00813c23          	sd	s0,24(sp)
  c8:	02010413          	addi	s0,sp,32
  cc:	00050793          	mv	a5,a0
  d0:	00068713          	mv	a4,a3
  d4:	fef42623          	sw	a5,-20(s0)
  d8:	00058793          	mv	a5,a1
  dc:	fef42423          	sw	a5,-24(s0)
  e0:	00060793          	mv	a5,a2
  e4:	fef42223          	sw	a5,-28(s0)
  e8:	00070793          	mv	a5,a4
  ec:	fef42023          	sw	a5,-32(s0)
  f0:	fec42703          	lw	a4,-20(s0)
  f4:	fe442783          	lw	a5,-28(s0)
  f8:	0007071b          	sext.w	a4,a4
  fc:	0007879b          	sext.w	a5,a5
 100:	02f71063          	bne	a4,a5,120 <.L4>
 104:	fe842703          	lw	a4,-24(s0)
 108:	fe042783          	lw	a5,-32(s0)
 10c:	0007071b          	sext.w	a4,a4
 110:	0007879b          	sext.w	a5,a5
 114:	00f71663          	bne	a4,a5,120 <.L4>
 118:	00100793          	li	a5,1
 11c:	0080006f          	j	124 <.L5>

0000000000000120 <.L4>:
 120:	00000793          	li	a5,0

0000000000000124 <.L5>:
 124:	00078513          	mv	a0,a5
 128:	01813403          	ld	s0,24(sp)
 12c:	02010113          	addi	sp,sp,32
 130:	00008067          	ret

0000000000000134 <main>:
 134:	fd010113          	addi	sp,sp,-48
 138:	02113423          	sd	ra,40(sp)
 13c:	02813023          	sd	s0,32(sp)
 140:	03010413          	addi	s0,sp,48
 144:	fe042623          	sw	zero,-20(s0)
 148:	fe042423          	sw	zero,-24(s0)
 14c:	fe042223          	sw	zero,-28(s0)
 150:	fe042023          	sw	zero,-32(s0)
 154:	fc042e23          	sw	zero,-36(s0)
 158:	00700793          	li	a5,7
 15c:	fef42023          	sw	a5,-32(s0)
 160:	01e00793          	li	a5,30
 164:	fcf42e23          	sw	a5,-36(s0)

0000000000000168 <.L10>:
 168:	fe442783          	lw	a5,-28(s0)
 16c:	0017879b          	addiw	a5,a5,1
 170:	fef42223          	sw	a5,-28(s0)
 174:	fe442783          	lw	a5,-28(s0)
 178:	0007871b          	sext.w	a4,a5
 17c:	03c00793          	li	a5,60
 180:	04f71463          	bne	a4,a5,1c8 <.L8>
 184:	fe042223          	sw	zero,-28(s0)
 188:	fe842783          	lw	a5,-24(s0)
 18c:	0017879b          	addiw	a5,a5,1
 190:	fef42423          	sw	a5,-24(s0)
 194:	fe842783          	lw	a5,-24(s0)
 198:	0007871b          	sext.w	a4,a5
 19c:	03c00793          	li	a5,60
 1a0:	02f71463          	bne	a4,a5,1c8 <.L8>
 1a4:	fe042423          	sw	zero,-24(s0)
 1a8:	fec42783          	lw	a5,-20(s0)
 1ac:	0017879b          	addiw	a5,a5,1
 1b0:	fef42623          	sw	a5,-20(s0)
 1b4:	fec42783          	lw	a5,-20(s0)
 1b8:	0007871b          	sext.w	a4,a5
 1bc:	01800793          	li	a5,24
 1c0:	00f71463          	bne	a4,a5,1c8 <.L8>
 1c4:	fe042623          	sw	zero,-20(s0)

00000000000001c8 <.L8>:
 1c8:	fe442683          	lw	a3,-28(s0)
 1cc:	fe842703          	lw	a4,-24(s0)
 1d0:	fec42783          	lw	a5,-20(s0)
 1d4:	00068613          	mv	a2,a3
 1d8:	00070593          	mv	a1,a4
 1dc:	00078513          	mv	a0,a5
 1e0:	00000097          	auipc	ra,0x0
 1e4:	000080e7          	jalr	ra # 1e0 <.L8+0x18>
 1e8:	fdc42683          	lw	a3,-36(s0)
 1ec:	fe042603          	lw	a2,-32(s0)
 1f0:	fe842703          	lw	a4,-24(s0)
 1f4:	fec42783          	lw	a5,-20(s0)
 1f8:	00070593          	mv	a1,a4
 1fc:	00078513          	mv	a0,a5
 200:	00000097          	auipc	ra,0x0
 204:	000080e7          	jalr	ra # 200 <.L8+0x38>
 208:	00050793          	mv	a5,a0
 20c:	02078863          	beqz	a5,23c <.L9>
 210:	000007b7          	lui	a5,0x0
 214:	00078513          	mv	a0,a5
 218:	00000097          	auipc	ra,0x0
 21c:	000080e7          	jalr	ra # 218 <.L8+0x50>
 220:	00500513          	li	a0,5
 224:	00000097          	auipc	ra,0x0
 228:	000080e7          	jalr	ra # 224 <.L8+0x5c>
 22c:	000007b7          	lui	a5,0x0
 230:	00078513          	mv	a0,a5
 234:	00000097          	auipc	ra,0x0
 238:	000080e7          	jalr	ra # 234 <.L8+0x6c>

000000000000023c <.L9>:
 23c:	fdc42703          	lw	a4,-36(s0)
 240:	fe042783          	lw	a5,-32(s0)
 244:	00070593          	mv	a1,a4
 248:	00078513          	mv	a0,a5
 24c:	00000097          	auipc	ra,0x0
 250:	000080e7          	jalr	ra # 24c <.L9+0x10>
 254:	00100513          	li	a0,1
 258:	00000097          	auipc	ra,0x0
 25c:	000080e7          	jalr	ra # 258 <.L9+0x1c>
 260:	000007b7          	lui	a5,0x0
 264:	00078513          	mv	a0,a5
 268:	00000097          	auipc	ra,0x0
 26c:	000080e7          	jalr	ra # 268 <.L9+0x2c>
 270:	ef9ff06f          	j	168 <.L10>


```

# Unique Instructions

Create a sample_assembly.txt file and dump the assembly code into this file.Now,run the instruction_counter.py file.

```

cd home/Documents/ASIC$ python3 instruction_counter.py

```

```

Number of different instructions: 17
List of unique instructions:
addiw
sd
mv
j
li
nop
bne
jalr
ld
beqz
addi
sw
lui
auipc
lw
ret
sext.w

```



