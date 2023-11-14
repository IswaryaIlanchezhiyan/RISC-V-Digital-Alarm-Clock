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
       	    for(i=0;i<1000000000;i++);
        	/*NULL STATEMENT*/;
           return i;
           
            
            // ------------------------------- add buzzer code here -----------------------------
            buzzer = 1;
            buzzer_reg = buzzer * 2;
            int mask = 0xFFFFFFF3;
            asm volatile(
            "or x30, x30, %0\n\t"
            "or x30, x30, %1\n\t"
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
        for(i=0;i<1000000000;i++);
        	/*NULL STATEMENT*/;
        
    }

    return 0;
}

// Function to display the current time
void displayTime(int hours, int minutes, int seconds)
{
     int mask = 0xFFFFFFF3;
     //printf("Current Time: %02d:%02d:%02d\n", hours, minutes, seconds);
    // -------------------------------add print asm over here -----------------------------------
    asm volatile(
        "or x30, x30, %0\n\t"
        "or x30, x30, %1\n\t"
        "or x30, x30, %2\n\t"
        "or x30, x30, %3\n\t"
        :
        :"r"(hours), "r"(minutes), "r"(seconds), "r"(mask)
        :"x30"
        );
        

}

// Function to display the alarm time
void displayAlarm(int hours, int minutes)
{
    int mask = 0xFFFFFFF3;	
    //printf("Alarm Time: %02d:%02d\n", hours, minutes);
    asm volatile(
        "or x30, x30, %0\n\t"
        "or x30, x30, %1\n\t"
        "or x30, x30, %2\n\t"
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
   10070:	fc042a23          	sw	zero,-44(s0)
   10074:	00100793          	li	a5,1
   10078:	fcf42823          	sw	a5,-48(s0)
   1007c:	fe042023          	sw	zero,-32(s0)
   10080:	fcc42783          	lw	a5,-52(s0)
   10084:	00179793          	slli	a5,a5,0x1
   10088:	fcf42423          	sw	a5,-56(s0)
   1008c:	001f7793          	andi	a5,t5,1
   10090:	fcf42a23          	sw	a5,-44(s0)
   10094:	002f7793          	andi	a5,t5,2
   10098:	fcf42823          	sw	a5,-48(s0)
   1009c:	fe442783          	lw	a5,-28(s0)
   100a0:	00178793          	addi	a5,a5,1
   100a4:	fef42223          	sw	a5,-28(s0)
   100a8:	fe442703          	lw	a4,-28(s0)
   100ac:	03c00793          	li	a5,60
   100b0:	04f71063          	bne	a4,a5,100f0 <main+0x9c>
   100b4:	fe042223          	sw	zero,-28(s0)
   100b8:	fe842783          	lw	a5,-24(s0)
   100bc:	00178793          	addi	a5,a5,1
   100c0:	fef42423          	sw	a5,-24(s0)
   100c4:	fe842703          	lw	a4,-24(s0)
   100c8:	03c00793          	li	a5,60
   100cc:	02f71263          	bne	a4,a5,100f0 <main+0x9c>
   100d0:	fe042423          	sw	zero,-24(s0)
   100d4:	fec42783          	lw	a5,-20(s0)
   100d8:	00178793          	addi	a5,a5,1
   100dc:	fef42623          	sw	a5,-20(s0)
   100e0:	fec42703          	lw	a4,-20(s0)
   100e4:	01800793          	li	a5,24
   100e8:	00f71463          	bne	a4,a5,100f0 <main+0x9c>
   100ec:	fe042623          	sw	zero,-20(s0)
   100f0:	fe442603          	lw	a2,-28(s0)
   100f4:	fe842583          	lw	a1,-24(s0)
   100f8:	fec42503          	lw	a0,-20(s0)
   100fc:	0bc000ef          	jal	ra,101b8 <displayTime>
   10100:	fd042683          	lw	a3,-48(s0)
   10104:	fd442603          	lw	a2,-44(s0)
   10108:	fe842583          	lw	a1,-24(s0)
   1010c:	fec42503          	lw	a0,-20(s0)
   10110:	13c000ef          	jal	ra,1024c <isAlarmTime>
   10114:	00050793          	mv	a5,a0
   10118:	02078c63          	beqz	a5,10150 <main+0xfc>
   1011c:	fe042783          	lw	a5,-32(s0)
   10120:	02079863          	bnez	a5,10150 <main+0xfc>
   10124:	fc042e23          	sw	zero,-36(s0)
   10128:	0100006f          	j	10138 <main+0xe4>
   1012c:	fdc42783          	lw	a5,-36(s0)
   10130:	00178793          	addi	a5,a5,1
   10134:	fcf42e23          	sw	a5,-36(s0)
   10138:	fdc42703          	lw	a4,-36(s0)
   1013c:	3b9ad7b7          	lui	a5,0x3b9ad
   10140:	9ff78793          	addi	a5,a5,-1537 # 3b9ac9ff <__global_pointer$+0x3b99af63>
   10144:	fee7d4e3          	bge	a5,a4,1012c <main+0xd8>
   10148:	fdc42783          	lw	a5,-36(s0)
   1014c:	0580006f          	j	101a4 <main+0x150>
   10150:	fd042683          	lw	a3,-48(s0)
   10154:	fd442603          	lw	a2,-44(s0)
   10158:	fe842583          	lw	a1,-24(s0)
   1015c:	fec42503          	lw	a0,-20(s0)
   10160:	0ec000ef          	jal	ra,1024c <isAlarmTime>
   10164:	00050793          	mv	a5,a0
   10168:	00079463          	bnez	a5,10170 <main+0x11c>
   1016c:	fe042023          	sw	zero,-32(s0)
   10170:	fd042583          	lw	a1,-48(s0)
   10174:	fd442503          	lw	a0,-44(s0)
   10178:	090000ef          	jal	ra,10208 <displayAlarm>
   1017c:	fc042c23          	sw	zero,-40(s0)
   10180:	0100006f          	j	10190 <main+0x13c>
   10184:	fd842783          	lw	a5,-40(s0)
   10188:	00178793          	addi	a5,a5,1
   1018c:	fcf42c23          	sw	a5,-40(s0)
   10190:	fd842703          	lw	a4,-40(s0)
   10194:	3b9ad7b7          	lui	a5,0x3b9ad
   10198:	9ff78793          	addi	a5,a5,-1537 # 3b9ac9ff <__global_pointer$+0x3b99af63>
   1019c:	fee7d4e3          	bge	a5,a4,10184 <main+0x130>
   101a0:	efdff06f          	j	1009c <main+0x48>
   101a4:	00078513          	mv	a0,a5
   101a8:	03c12083          	lw	ra,60(sp)
   101ac:	03812403          	lw	s0,56(sp)
   101b0:	04010113          	addi	sp,sp,64
   101b4:	00008067          	ret

000101b8 <displayTime>:
   101b8:	fd010113          	addi	sp,sp,-48
   101bc:	02812623          	sw	s0,44(sp)
   101c0:	03010413          	addi	s0,sp,48
   101c4:	fca42e23          	sw	a0,-36(s0)
   101c8:	fcb42c23          	sw	a1,-40(s0)
   101cc:	fcc42a23          	sw	a2,-44(s0)
   101d0:	ff300793          	li	a5,-13
   101d4:	fef42623          	sw	a5,-20(s0)
   101d8:	fdc42783          	lw	a5,-36(s0)
   101dc:	fd842703          	lw	a4,-40(s0)
   101e0:	fd442683          	lw	a3,-44(s0)
   101e4:	fec42603          	lw	a2,-20(s0)
   101e8:	00ff6f33          	or	t5,t5,a5
   101ec:	00ef6f33          	or	t5,t5,a4
   101f0:	00df6f33          	or	t5,t5,a3
   101f4:	00cf6f33          	or	t5,t5,a2
   101f8:	00000013          	nop
   101fc:	02c12403          	lw	s0,44(sp)
   10200:	03010113          	addi	sp,sp,48
   10204:	00008067          	ret

00010208 <displayAlarm>:
   10208:	fd010113          	addi	sp,sp,-48
   1020c:	02812623          	sw	s0,44(sp)
   10210:	03010413          	addi	s0,sp,48
   10214:	fca42e23          	sw	a0,-36(s0)
   10218:	fcb42c23          	sw	a1,-40(s0)
   1021c:	ff300793          	li	a5,-13
   10220:	fef42623          	sw	a5,-20(s0)
   10224:	fdc42783          	lw	a5,-36(s0)
   10228:	fd842703          	lw	a4,-40(s0)
   1022c:	fec42683          	lw	a3,-20(s0)
   10230:	00ff6f33          	or	t5,t5,a5
   10234:	00ef6f33          	or	t5,t5,a4
   10238:	00df6f33          	or	t5,t5,a3
   1023c:	00000013          	nop
   10240:	02c12403          	lw	s0,44(sp)
   10244:	03010113          	addi	sp,sp,48
   10248:	00008067          	ret

0001024c <isAlarmTime>:
   1024c:	fe010113          	addi	sp,sp,-32
   10250:	00812e23          	sw	s0,28(sp)
   10254:	02010413          	addi	s0,sp,32
   10258:	fea42623          	sw	a0,-20(s0)
   1025c:	feb42423          	sw	a1,-24(s0)
   10260:	fec42223          	sw	a2,-28(s0)
   10264:	fed42023          	sw	a3,-32(s0)
   10268:	fec42703          	lw	a4,-20(s0)
   1026c:	fe442783          	lw	a5,-28(s0)
   10270:	00f71c63          	bne	a4,a5,10288 <isAlarmTime+0x3c>
   10274:	fe842703          	lw	a4,-24(s0)
   10278:	fe042783          	lw	a5,-32(s0)
   1027c:	00f71663          	bne	a4,a5,10288 <isAlarmTime+0x3c>
   10280:	00100793          	li	a5,1
   10284:	0080006f          	j	1028c <isAlarmTime+0x40>
   10288:	00000793          	li	a5,0
   1028c:	00078513          	mv	a0,a5
   10290:	01c12403          	lw	s0,28(sp)
   10294:	02010113          	addi	sp,sp,32
   10298:	00008067          	ret





```

# Unique Instructions

Create a sample_assembly.txt file and dump the assembly code into this file.Now,run the instruction_counter.py file.

```

 python3 instruction_counter.py

```

```
Number of different instructions: 17
List of unique instructions:
mv
addi
or
lui
beqz
jal
bne
ret
nop
andi
lw
sw
bnez
bge
slli
li
j


```

# Spike Simulation

Modified C code for Spike Simulation

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
    

    for (j=0;j<100;j++)
    //while (1)
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
       	    for(i=0;i<100;i++);
        	/*NULL STATEMENT*/;
           return i;
           
            
            // ------------------------------- add buzzer code here -----------------------------
            buzzer = 1;
            buzzer_reg = buzzer * 2;
            int mask = 0xFFFFFFF3;
            asm volatile(
            "or x30, x30, %0\n\t"
            "or x30, x30, %1\n\t"
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
     int mask = 0xFFFFFFF3;
     printf("Current Time: %02d:%02d:%02d\n", hours, minutes, seconds);
    // -------------------------------add print asm over here -----------------------------------
    asm volatile(
        "or x30, x30, %0\n\t"
        "or x30, x30, %1\n\t"
        "or x30, x30, %2\n\t"
        "or x30, x30, %3\n\t"
        :
        :"r"(hours), "r"(minutes), "r"(seconds), "r"(mask)
        :"x30"
        );
        

}

// Function to display the alarm time
void displayAlarm(int hours, int minutes)
{
    int mask = 0xFFFFFFF3;	
    printf("Alarm Time: %02d:%02d\n", hours, minutes);
    asm volatile(
        "or x30, x30, %0\n\t"
        "or x30, x30, %1\n\t"
        "or x30, x30, %2\n\t"
        :
        :"r"(hours), "r"(minutes), "r"(mask)
        :"x30"
        );
       

         
}


int isAlarmTime(int currentHours, int currentMinutes, int alarmHours, int alarmMinutes) {
	
    return (currentHours == alarmHours && currentMinutes == alarmMinutes);
   

}


```

```

riscv64-unknown-elf-gcc -march=rv64i -mabi=lp64 -ffreestanding -o out assemblyccode.c
spike pk out

```
![Screenshot from 2023-10-25 13-55-04](https://github.com/IswaryaIlanchezhiyan/RISC-V-Digital-Alarm-Clock/assets/140998760/b23bdcdf-941b-4f08-ab31-e0be3304934d)

![Screenshot from 2023-10-25 13-55-13](https://github.com/IswaryaIlanchezhiyan/RISC-V-Digital-Alarm-Clock/assets/140998760/e858cc25-4323-4336-a5e9-86b10e7e7e35)

# Functional Simulation

Functional Simulation is done using GTKWave and the waveform is shown below.Commands used for generating waveform.vcd :

```

iverilog -o test testbench.v processor.v
./test

```
The Instruction at which my output changing is

```

1023c:	00000013          	nop

```

 At this instruction my output is changing from low to high which means that my buzzer is on.Buzzer on refers to Alarm Time is reached and it is getting displayed.


![output_waveform](https://github.com/IswaryaIlanchezhiyan/RISC-V-Digital-Alarm-Clock/assets/140998760/de3606c0-567c-43b5-8bc2-dee06540404b)


# Instructions Verification



```

10054:	fc010113          	addi	sp,sp,-64

```

![Screenshot from 2023-10-27 22-23-31](https://github.com/IswaryaIlanchezhiyan/RISC-V-Digital-Alarm-Clock/assets/140998760/393f231a-90a2-4774-b515-147310656053)

```

 101e8:	00ff6f33          	or	t5,t5,a5

```

![or](https://github.com/IswaryaIlanchezhiyan/RISC-V-Digital-Alarm-Clock/assets/140998760/5d52498a-66c7-4335-a574-355c7d628403)


# Gate Level Simulation

The term "gate level" refers to the netlist view of a circuit, usually produced by logic synthesis. So while RTL simulation is pre-synthesis, GLS is post-synthesis. The netlist view is a complete connection list consisting of gates and IP models with full functional and timing behavior. RTL simulation is a zero delay environment and events generally occur on the active clock edge. GLS can be zero delay also, but is more often used in unit delay or full timing mode. 

**UART Functionality Test**

```

yosys
read_liberty -lib sky130_fd_sc_hd__tt_025C_1v80_512.lib
read_verilog processor1.v
synth -top wrapper
dfflibmap -liberty sky130_fd_sc_hd__tt_025C_1v80_512.lib
abc -liberty sky130_fd_sc_hd__tt_025C_1v80_512.lib
write_verilog synth_test_asic.v

```


**Performing GLS**
 ```

yosys
read_liberty -lib sky130_fd_sc_hd__tt_025C_1v80_512.lib
read_verilog processor5.v
synth -top wrapper
dfflibmap -liberty sky130_fd_sc_hd__tt_025C_1v80_512.lib
abc -liberty sky130_fd_sc_hd__tt_025C_1v80_512.lib
write_verilog synth_test_processor.v

```

For generating output waveform:

```

iverilog -o test testbench.v synth_test_processor.v sky130_sram_1kbyte_1rw1r_32x512_8.v sky130_fd_sc_hd.v primitives.v
./test

```

![Screenshot from 2023-10-31 21-38-38](https://github.com/IswaryaIlanchezhiyan/RISC-V-Digital-Alarm-Clock/assets/140998760/294ea373-2800-4d08-9aed-355796c9a3a7)



**Graphical Version of Logic realized**

```

show wrapper

```

![Screenshot from 2023-10-31 17-09-24](https://github.com/IswaryaIlanchezhiyan/RISC-V-Digital-Alarm-Clock/assets/140998760/310f0275-87bb-4619-8354-14a9b227727f)

# Physical Design

**Place and Route (PnR)**

PNR (Place and Route) is a backend process in the ASIC (Application Specific Integrated Circuit) flow. It is the physical design process of transforming a netlist into a layout that can be manufactured.

The PNR flow includes the following stages: 

+ Synthesis
+ Floorplanning
+ Placement
+ Clock tree synthesis
+ Routing
+ Post route ECO and tape out

The PNR flow involves: 

+ Placing and routing all the instances in a netlist in a defined core area
+ Meeting design rules and timing requirements
+ Laying out analog macros, SRAMs, and digital areas
+ Routing power and signals between them
+ Setting up automatic placement and routing of the digital areas

**Preparing the Design**

Create a project folder in OpenLane designs folder and add all the lib files,lef files,gds files,max-min lef files,min-max lib files,config.json and processor.v .

```

cd OpenLane
make mount
./flow.tcl -interactive
package require openlane 0.9
prep -design project_name

```

![make_mount](https://github.com/IswaryaIlanchezhiyan/RISC-V-Digital-Alarm-Clock/assets/140998760/3627be86-40a4-42fe-a250-19a69907da94)


**Synthesis**

Synthesis in ASIC is the process of converting a behavioral description of a circuit, in the form of RTL, into an equivalent netlist made of cells from the standard cell library. The netlist can then be implemented as a physical silicon structure. 

Synthesis is an important step in chip designing flow as it allows us to visualize the design as it will appear after manufacturing.

```

run_synthesis

```

![run_synthesis](https://github.com/IswaryaIlanchezhiyan/RISC-V-Digital-Alarm-Clock/assets/140998760/c16047a1-747b-4be3-b270-c8345d69e65e)


![synth_report](https://github.com/IswaryaIlanchezhiyan/RISC-V-Digital-Alarm-Clock/assets/140998760/92889177-70d4-4b35-ab69-c976067a3a11)

**Floorplan**

Floorplanning is the process of placing blocks or macros in the chip or core area. It is the first step in RTL-to-GDSII design. 

Floorplanning includes: 

+ Block placement
+ Design portioning
+ Pin placement
+ Power optimization
+ Creating the boundary and core area
+ Creating wire tracks for placement of standard cells

A well-designed floorplan can lead to an ASIC design with higher performance and optimum area. 

Floorplanning can be challenging because it deals with: 

+ The placement of I/O pads and macros
+ Power and ground structure
+ Purchased intellectual property blocks (IP-blocks), such as a processor core, come in predefined area blocks
+ Some IP-blocks come with legal limitations such as permitting no routing of signals directly above the block


```

run_floorplan

```

![run-floorplan](https://github.com/IswaryaIlanchezhiyan/RISC-V-Digital-Alarm-Clock/assets/140998760/15ef1580-fbf1-408e-b608-8e6fb50b38f8)


To see the Layout ,go to runs --> results --> floorplan and open the terminal and type the following command.

```

magic -T /home/iswarya/OpenLane/open_pdks/sky130/sky130A/libs.tech/magic/sky130A.tech lef read ../../tmp/merged.nom.lef def read wrapper.def &

```

![floorplan_layout](https://github.com/IswaryaIlanchezhiyan/RISC-V-Digital-Alarm-Clock/assets/140998760/8c07d530-1f75-4f87-a9aa-221d8c6b14cc)

Core Area:

![core_area](https://github.com/IswaryaIlanchezhiyan/RISC-V-Digital-Alarm-Clock/assets/140998760/d0ed446c-1776-41c7-afac-2ecea7377ee8)

Die Area:

![die_area](https://github.com/IswaryaIlanchezhiyan/RISC-V-Digital-Alarm-Clock/assets/140998760/f1675cce-6f58-4584-911f-13b67192825a)

**Placement**

 It refers to the process of determining the physical locations or positions of individual logic elements, such as standard cells (gates, flip-flops, etc.), macros, or other functional blocks, within the semiconductor die or chip.

The placement stage is a crucial step in the overall ASIC design flow, occurring after logic synthesis and before routing. It involves mapping the synthesized logic onto the physical chip layout, with the aim of optimizing various factors including:

+ Timing
+ Area
+ Power
+ Signal Integrity

Placement algorithms in ASIC design tools aim to optimize these aspects by considering the logical relationships between the components, the physical constraints of the chip, and any user-defined constraints or goals specified by the designer.

Some common considerations during placement include:

+ Grouping related logic elements together to minimize signal delay.
+ Balancing the placement to avoid congested areas and achieve a more uniform distribution of logic elements.
+ Considering clock trees and special high-speed paths to maintain synchronous operation.
+ Accommodating I/O (input/output) interfaces in favorable locations to ease connectivity with external components.

```

run_placement

```

![run_placement](https://github.com/IswaryaIlanchezhiyan/RISC-V-Digital-Alarm-Clock/assets/140998760/5b68c388-753e-4175-908a-65364f442e76)

To view the Layout,go to runs --> results --> placement and open the terminal and type the following command.

```

magic -T /home/iswarya/OpenLane/open_pdks/sky130/sky130A/libs.tech/magic/sky130A.tech lef read ../../tmp/merged.nom.lef def read wrapper.def &

```

![placement_layout](https://github.com/IswaryaIlanchezhiyan/RISC-V-Digital-Alarm-Clock/assets/140998760/bd5cac63-d151-431a-b6d8-b0488f8e7cfb)

**CTS**

Clock Tree Synthesis (CTS) is the technique of balancing the clock delay to all clock inputs by inserting buffers/inverters along the clock routes of an ASIC design. As a result, CTS is used to balance the skew and reduce insertion latency.

```

run_cts

```

![run_cts](https://github.com/IswaryaIlanchezhiyan/RISC-V-Digital-Alarm-Clock/assets/140998760/8f009e8d-54cd-49ea-a822-075c41600565)

Timing Report:

![Screenshot from 2023-11-14 23-16-02](https://github.com/IswaryaIlanchezhiyan/RISC-V-Digital-Alarm-Clock/assets/140998760/6d4df51e-c75d-4f11-b751-7c4bb60af4f8)



Area Report:

![Screenshot from 2023-11-14 23-16-15](https://github.com/IswaryaIlanchezhiyan/RISC-V-Digital-Alarm-Clock/assets/140998760/257b9b24-356a-4181-bf81-989ea5a1c36b)

Skew Report:

![Screenshot from 2023-11-14 23-15-52](https://github.com/IswaryaIlanchezhiyan/RISC-V-Digital-Alarm-Clock/assets/140998760/57ca341d-63b8-4d0c-92e5-c4a85801addc)


Power Report:

![Screenshot from 2023-11-14 23-15-36](https://github.com/IswaryaIlanchezhiyan/RISC-V-Digital-Alarm-Clock/assets/140998760/731a6b00-5256-4fa1-9c8a-2ecfa31225ba)

**Routing**

In ASIC design, routing is the process of creating physical connections based on logical connectivity. Routing is the stage after CTS and optimization where exact paths for the interconnection of standard cells and macros and I/O pins are determined.

Routing creates physical connections to all clock and the signal pins through metal interconnects. Routed metal paths must meet timing, clock skew, max trans/cap requirements and also physical DRC requirements. 

The routing mechanism establishes the specific pathways for interconnections. This contains the regular cell and macro pins, block boundary pins, and chip boundary pads.

```

run_routing

```

![run_routing](https://github.com/IswaryaIlanchezhiyan/RISC-V-Digital-Alarm-Clock/assets/140998760/5e0f95d0-3e46-4384-a28f-37a051c8e4df)

To view the Layout,go to runs --> results --> routing and open the terminal and type the following command.

```

magic -T /home/iswarya/OpenLane/open_pdks/sky130/sky130A/libs.tech/magic/sky130A.tech lef read ../../tmp/merged.nom.lef def read wrapper.def &

```

![routing_layout](https://github.com/IswaryaIlanchezhiyan/RISC-V-Digital-Alarm-Clock/assets/140998760/9b3a277b-9ff9-4390-8f30-87fa05a72e00)


# OpenLane Interactive Flow

```

cd OpenLane
./flow.tcl -interactive
package require openlane 0.9
prep -design project_name
run_synthesis
run_floorplan
run_placement
run_cts
gen_pdn
run_routing
run_magic
run_magic_spice_export
run_magic_drc
run_antenna_check

```

# OpenLane Non-Interactive Flow

```

cd OpenLane 
make mount
./flow.tcl -design project_name

```

























# Acknowledgement

1.Kunal Ghosh, VSD Corp. Pvt. Ltd.

2.Mayank Kabra, Chipcron. Pvt. Ltd.








