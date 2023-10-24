

// 
// Module: tb
// 
// Notes:
// - Top level simulation testbench.
//

//`timescale 1ns/1ns
//`define WAVES_FILE "./work/waves-rx.vcd"

module tb();
    
reg        clk          ; // Top level system clock input.
reg rst;
reg neg_clk; 
reg neg_rst ; 
reg        resetn       ;
reg        uart_rxd     ; // UART Recieve pin.

reg        uart_rx_en   ; // Recieve enable
//wire [8:0] res;
wire       uart_rx_break; // Did we get a BREAK message?
wire       uart_rx_valid; // Valid data recieved and available.
wire [7:0] uart_rx_data ; // The recieved data.
wire [31:0] inst ; 
wire [31:0] inst_mem ; 

reg rst_pin ; 
wire write_done ; 


// Bit rate of the UART line we are testing.
localparam BIT_RATE = 9600;
localparam BIT_P    = (1000000000/BIT_RATE);


// Period and frequency of the system clock.
localparam CLK_HZ   = 50000000;
localparam CLK_P    = 1000000000/ CLK_HZ;

reg slow_clk = 0;


// Make the clock tick.
always begin #(CLK_P/2) clk  = ~clk; end   
always begin #(CLK_P/2) neg_clk  = ~neg_clk; end     
always begin #(CLK_P*2) slow_clk <= !slow_clk;end



task write_instruction;
    input [31:0] instruction;
    begin
            @(posedge clk);
            send_byte(instruction[7:0]);
            check_byte(instruction[7:0]);
            @(posedge clk);
            send_byte(instruction[15:8]);
            check_byte(instruction[15:8]);
            
            @(posedge clk);
            send_byte(instruction[23:16]);
            check_byte(instruction[23:16]);
            
            @(posedge clk);
            send_byte(instruction[31:24]);
            check_byte(instruction[31:24]);
    end
    endtask

task send_byte;
    input [7:0] to_send;
    integer i;
    begin


        #BIT_P;  uart_rxd = 1'b0;
        for(i=0; i < 8; i = i+1) begin
            #BIT_P;  uart_rxd = to_send[i];
        end
        #BIT_P;  uart_rxd = 1'b1;
        #1000;
    end
endtask


// Checks that the output of the UART is the value we expect.
integer passes = 0;
integer fails  = 0;
task check_byte;
    input [7:0] expected_value;
    begin
        if(uart_rx_data == expected_value) begin
            passes = passes + 1;
            $display("%d/%d/%d [PASS] Expected %b and got %b", 
                     passes,fails,passes+fails,
                     expected_value, uart_rx_data);
        end else begin
            fails  = fails  + 1;
            $display("%d/%d/%d [FAIL] Expected %b and got %b", 
                     passes,fails,passes+fails,
                     expected_value, uart_rx_data);
        end
    end
endtask


initial 
begin 
    $dumpfile("waveform.vcd");
    $dumpvars(0,tb);
end 

reg [3:0] input_wires; 
wire [3:0] output_wires ; 
wire [2:0] pc ; 


reg [7:0] to_send;
initial begin
    rst=1;
    rst_pin=1; 
    neg_rst = 1; 
    resetn  = 1'b0;
    clk     = 1'b0;
    neg_clk = 1; 
    neg_rst = ~clk ;
    uart_rxd = 1'b1;
    neg_clk = 1'b1; 
    input_wires = 4'b0111;
    #4000
    resetn = 1'b1;
    rst=0;
    neg_rst = 0; 
    rst_pin = 0 ; 
  

    uart_rx_en = 1'b1;
    @(posedge slow_clk);write_instruction(32'h00000000); 
    @(posedge slow_clk);write_instruction(32'h00000000); 
    @(posedge slow_clk);write_instruction(32'hfc010113); 
    @(posedge slow_clk);write_instruction(32'h02112e23); 
    @(posedge slow_clk);write_instruction(32'h02812c23); 
    @(posedge slow_clk);write_instruction(32'h04010413); 
    @(posedge slow_clk);write_instruction(32'hfe042623); 
    @(posedge slow_clk);write_instruction(32'hfe042423); 
    @(posedge slow_clk);write_instruction(32'hfe042223); 
    @(posedge slow_clk);write_instruction(32'hfe042023); 
    @(posedge slow_clk);write_instruction(32'hfdc42783); 
    @(posedge slow_clk);write_instruction(32'h00179793); 
    @(posedge slow_clk);write_instruction(32'hfcf42c23); 
    @(posedge slow_clk);write_instruction(32'h1e0000ef); 
    @(posedge slow_clk);write_instruction(32'h00050793); 
    @(posedge slow_clk);write_instruction(32'hfd078793); 
    @(posedge slow_clk);write_instruction(32'hfcf42a23); 
    @(posedge slow_clk);write_instruction(32'h1d0000ef); 
    @(posedge slow_clk);write_instruction(32'h00050793); 
    @(posedge slow_clk);write_instruction(32'hfd078793); 
    @(posedge slow_clk);write_instruction(32'hfcf42823); 
    @(posedge slow_clk);write_instruction(32'h1c0000ef); 
    @(posedge slow_clk);write_instruction(32'h00050793); 
    @(posedge slow_clk);write_instruction(32'hfd078793); 
    @(posedge slow_clk);write_instruction(32'hfcf42623); 
    @(posedge slow_clk);write_instruction(32'h1b0000ef); 
    @(posedge slow_clk);write_instruction(32'h00050793); 
    @(posedge slow_clk);write_instruction(32'hfd078793); 
    @(posedge slow_clk);write_instruction(32'hfcf42423); 
    @(posedge slow_clk);write_instruction(32'hfd442703); 
    @(posedge slow_clk);write_instruction(32'h00070793); 
    @(posedge slow_clk);write_instruction(32'h00279793); 
    @(posedge slow_clk);write_instruction(32'h00e787b3); 
    @(posedge slow_clk);write_instruction(32'h00179793); 
    @(posedge slow_clk);write_instruction(32'h00078713); 
    @(posedge slow_clk);write_instruction(32'hfd042783); 
    @(posedge slow_clk);write_instruction(32'h00e787b3); 
    @(posedge slow_clk);write_instruction(32'hfcf42223); 
    @(posedge slow_clk);write_instruction(32'hfcc42703); 
    @(posedge slow_clk);write_instruction(32'h00070793); 
    @(posedge slow_clk);write_instruction(32'h00279793); 
    @(posedge slow_clk);write_instruction(32'h00e787b3); 
    @(posedge slow_clk);write_instruction(32'h00179793); 
    @(posedge slow_clk);write_instruction(32'h00078713); 
    @(posedge slow_clk);write_instruction(32'hfc842783); 
    @(posedge slow_clk);write_instruction(32'h00e787b3); 
    @(posedge slow_clk);write_instruction(32'hfcf42023); 
    @(posedge slow_clk);write_instruction(32'h001f7793); 
    @(posedge slow_clk);write_instruction(32'hfcf42223); 
    @(posedge slow_clk);write_instruction(32'h001f7793); 
    @(posedge slow_clk);write_instruction(32'hfcf42023); 
    @(posedge slow_clk);write_instruction(32'hfe442783); 
    @(posedge slow_clk);write_instruction(32'h00178793); 
    @(posedge slow_clk);write_instruction(32'hfef42223); 
    @(posedge slow_clk);write_instruction(32'hfe442703); 
    @(posedge slow_clk);write_instruction(32'h03c00793); 
    @(posedge slow_clk);write_instruction(32'h04f71063); 
    @(posedge slow_clk);write_instruction(32'hfe042223); 
    @(posedge slow_clk);write_instruction(32'hfe842783); 
    @(posedge slow_clk);write_instruction(32'h00178793); 
    @(posedge slow_clk);write_instruction(32'hfef42423); 
    @(posedge slow_clk);write_instruction(32'hfe842703); 
    @(posedge slow_clk);write_instruction(32'h03c00793); 
    @(posedge slow_clk);write_instruction(32'h02f71263); 
    @(posedge slow_clk);write_instruction(32'hfe042423); 
    @(posedge slow_clk);write_instruction(32'hfec42783); 
    @(posedge slow_clk);write_instruction(32'h00178793); 
    @(posedge slow_clk);write_instruction(32'hfef42623); 
    @(posedge slow_clk);write_instruction(32'hfec42703); 
    @(posedge slow_clk);write_instruction(32'h01800793); 
    @(posedge slow_clk);write_instruction(32'h00f71463); 
    @(posedge slow_clk);write_instruction(32'hfe042623); 
    @(posedge slow_clk);write_instruction(32'hfe442603); 
    @(posedge slow_clk);write_instruction(32'hfe842583); 
    @(posedge slow_clk);write_instruction(32'hfec42503); 
    @(posedge slow_clk);write_instruction(32'h074000ef); 
    @(posedge slow_clk);write_instruction(32'hfc042683); 
    @(posedge slow_clk);write_instruction(32'hfc442603); 
    @(posedge slow_clk);write_instruction(32'hfe842583); 
    @(posedge slow_clk);write_instruction(32'hfec42503); 
    @(posedge slow_clk);write_instruction(32'h36c000ef); 
    @(posedge slow_clk);write_instruction(32'h00050793); 
    @(posedge slow_clk);write_instruction(32'h02078463); 
    @(posedge slow_clk);write_instruction(32'hfe042783); 
    @(posedge slow_clk);write_instruction(32'h02079063); 
    @(posedge slow_clk);write_instruction(32'h00100793); 
    @(posedge slow_clk);write_instruction(32'hfcf42e23); 
    @(posedge slow_clk);write_instruction(32'hfdc42783); 
    @(posedge slow_clk);write_instruction(32'h00179793); 
    @(posedge slow_clk);write_instruction(32'hfcf42c23); 
    @(posedge slow_clk);write_instruction(32'hfd842783); 
    @(posedge slow_clk);write_instruction(32'h00ff6f33); 
    @(posedge slow_clk);write_instruction(32'hfc042683); 
    @(posedge slow_clk);write_instruction(32'hfc442603); 
    @(posedge slow_clk);write_instruction(32'hfe842583); 
    @(posedge slow_clk);write_instruction(32'hfec42503); 
    @(posedge slow_clk);write_instruction(32'h32c000ef); 
    @(posedge slow_clk);write_instruction(32'h00050793); 
    @(posedge slow_clk);write_instruction(32'h00079463); 
    @(posedge slow_clk);write_instruction(32'hfe042023); 
    @(posedge slow_clk);write_instruction(32'hfc042583); 
    @(posedge slow_clk);write_instruction(32'hfc442503); 
    @(posedge slow_clk);write_instruction(32'h048000ef); 
    @(posedge slow_clk);write_instruction(32'hf31ff06f); 
    @(posedge slow_clk);write_instruction(32'hfe010113); 
    @(posedge slow_clk);write_instruction(32'h00812e23); 
    @(posedge slow_clk);write_instruction(32'h02010413); 
    @(posedge slow_clk);write_instruction(32'hfea42623); 
    @(posedge slow_clk);write_instruction(32'hfeb42423); 
    @(posedge slow_clk);write_instruction(32'hfec42223); 
    @(posedge slow_clk);write_instruction(32'hfec42783); 
    @(posedge slow_clk);write_instruction(32'hfe842703); 
    @(posedge slow_clk);write_instruction(32'hfe442683); 
    @(posedge slow_clk);write_instruction(32'h00ff6f33); 
    @(posedge slow_clk);write_instruction(32'h00ef6f33); 
    @(posedge slow_clk);write_instruction(32'h00df6f33); 
    @(posedge slow_clk);write_instruction(32'h00000013); 
    @(posedge slow_clk);write_instruction(32'h01c12403); 
    @(posedge slow_clk);write_instruction(32'h02010113); 
    @(posedge slow_clk);write_instruction(32'h00008067); 
    @(posedge slow_clk);write_instruction(32'hfe010113); 
    @(posedge slow_clk);write_instruction(32'h00812e23); 
    @(posedge slow_clk);write_instruction(32'h02010413); 
    @(posedge slow_clk);write_instruction(32'hfea42623); 
    @(posedge slow_clk);write_instruction(32'hfeb42423); 
    @(posedge slow_clk);write_instruction(32'hfec42783); 
    @(posedge slow_clk);write_instruction(32'hfe842703); 
    @(posedge slow_clk);write_instruction(32'h00ff6f33); 
    @(posedge slow_clk);write_instruction(32'h00ef6f33); 
    @(posedge slow_clk);write_instruction(32'h00000013); 
    @(posedge slow_clk);write_instruction(32'h01c12403); 
    @(posedge slow_clk);write_instruction(32'h02010113); 
    @(posedge slow_clk);write_instruction(32'h00008067); 
    @(posedge slow_clk);write_instruction(32'hfe010113); 
    @(posedge slow_clk);write_instruction(32'h00812e23); 
    @(posedge slow_clk);write_instruction(32'h02010413); 
    @(posedge slow_clk);write_instruction(32'h000117b7); 
    @(posedge slow_clk);write_instruction(32'h54878793); 
    @(posedge slow_clk);write_instruction(32'h0007a703); 
    @(posedge slow_clk);write_instruction(32'hfee42023); 
    @(posedge slow_clk);write_instruction(32'h0047c783); 
    @(posedge slow_clk);write_instruction(32'hfef40223); 
    @(posedge slow_clk);write_instruction(32'hfe040723); 
    @(posedge slow_clk);write_instruction(32'hf0000793); 
    @(posedge slow_clk);write_instruction(32'hfef42423); 
    @(posedge slow_clk);write_instruction(32'h0400006f); 
    @(posedge slow_clk);write_instruction(32'hfee44783); 
    @(posedge slow_clk);write_instruction(32'hff040713); 
    @(posedge slow_clk);write_instruction(32'h00f707b3); 
    @(posedge slow_clk);write_instruction(32'hff07c783); 
    @(posedge slow_clk);write_instruction(32'hfe842703); 
    @(posedge slow_clk);write_instruction(32'h00ef7f33); 
    @(posedge slow_clk);write_instruction(32'h00ff6f33); 
    @(posedge slow_clk);write_instruction(32'h0f0f7793); 
    @(posedge slow_clk);write_instruction(32'hfef407a3); 
    @(posedge slow_clk);write_instruction(32'hfef44703); 
    @(posedge slow_clk);write_instruction(32'h0f000793); 
    @(posedge slow_clk);write_instruction(32'h02f71463); 
    @(posedge slow_clk);write_instruction(32'hfee44783); 
    @(posedge slow_clk);write_instruction(32'h00178793); 
    @(posedge slow_clk);write_instruction(32'hfef40723); 
    @(posedge slow_clk);write_instruction(32'hfee44783); 
    @(posedge slow_clk);write_instruction(32'hff040713); 
    @(posedge slow_clk);write_instruction(32'h00f707b3); 
    @(posedge slow_clk);write_instruction(32'hff07c783); 
    @(posedge slow_clk);write_instruction(32'hfa079ae3); 
    @(posedge slow_clk);write_instruction(32'h0080006f); 
    @(posedge slow_clk);write_instruction(32'h00000013); 
    @(posedge slow_clk);write_instruction(32'hfee44783); 
    @(posedge slow_clk);write_instruction(32'hff040713); 
    @(posedge slow_clk);write_instruction(32'h00f707b3); 
    @(posedge slow_clk);write_instruction(32'hff07c783); 
    @(posedge slow_clk);write_instruction(32'h00079663); 
    @(posedge slow_clk);write_instruction(32'h0ff00793); 
    @(posedge slow_clk);write_instruction(32'h1e40006f); 
    @(posedge slow_clk);write_instruction(32'hfee44783); 
    @(posedge slow_clk);write_instruction(32'hff040713); 
    @(posedge slow_clk);write_instruction(32'h00f707b3); 
    @(posedge slow_clk);write_instruction(32'hff07c703); 
    @(posedge slow_clk);write_instruction(32'h00e00793); 
    @(posedge slow_clk);write_instruction(32'h06f71263); 
    @(posedge slow_clk);write_instruction(32'hfef44703); 
    @(posedge slow_clk);write_instruction(32'h0e000793); 
    @(posedge slow_clk);write_instruction(32'h00f71863); 
    @(posedge slow_clk);write_instruction(32'h03000793); 
    @(posedge slow_clk);write_instruction(32'hfef407a3); 
    @(posedge slow_clk);write_instruction(32'h1b00006f); 
    @(posedge slow_clk);write_instruction(32'hfef44703); 
    @(posedge slow_clk);write_instruction(32'h0d000793); 
    @(posedge slow_clk);write_instruction(32'h00f71863); 
    @(posedge slow_clk);write_instruction(32'h06d00793); 
    @(posedge slow_clk);write_instruction(32'hfef407a3); 
    @(posedge slow_clk);write_instruction(32'h1980006f); 
    @(posedge slow_clk);write_instruction(32'hfef44703); 
    @(posedge slow_clk);write_instruction(32'h0b000793); 
    @(posedge slow_clk);write_instruction(32'h00f71863); 
    @(posedge slow_clk);write_instruction(32'h07900793); 
    @(posedge slow_clk);write_instruction(32'hfef407a3); 
    @(posedge slow_clk);write_instruction(32'h1800006f); 
    @(posedge slow_clk);write_instruction(32'hfef44703); 
    @(posedge slow_clk);write_instruction(32'h07000793); 
    @(posedge slow_clk);write_instruction(32'h16f71a63); 
    @(posedge slow_clk);write_instruction(32'h07700793); 
    @(posedge slow_clk);write_instruction(32'hfef407a3); 
    @(posedge slow_clk);write_instruction(32'h1680006f); 
    @(posedge slow_clk);write_instruction(32'hfee44783); 
    @(posedge slow_clk);write_instruction(32'hff040713); 
    @(posedge slow_clk);write_instruction(32'h00f707b3); 
    @(posedge slow_clk);write_instruction(32'hff07c703); 
    @(posedge slow_clk);write_instruction(32'h00d00793); 
    @(posedge slow_clk);write_instruction(32'h06f71263); 
    @(posedge slow_clk);write_instruction(32'hfef44703); 
    @(posedge slow_clk);write_instruction(32'h0e000793); 
    @(posedge slow_clk);write_instruction(32'h00f71863); 
    @(posedge slow_clk);write_instruction(32'h03300793); 
    @(posedge slow_clk);write_instruction(32'hfef407a3); 
    @(posedge slow_clk);write_instruction(32'h1380006f); 
    @(posedge slow_clk);write_instruction(32'hfef44703); 
    @(posedge slow_clk);write_instruction(32'h0d000793); 
    @(posedge slow_clk);write_instruction(32'h00f71863); 
    @(posedge slow_clk);write_instruction(32'h05b00793); 
    @(posedge slow_clk);write_instruction(32'hfef407a3); 
    @(posedge slow_clk);write_instruction(32'h1200006f); 
    @(posedge slow_clk);write_instruction(32'hfef44703); 
    @(posedge slow_clk);write_instruction(32'h0b000793); 
    @(posedge slow_clk);write_instruction(32'h00f71863); 
    @(posedge slow_clk);write_instruction(32'h05e00793); 
    @(posedge slow_clk);write_instruction(32'hfef407a3); 
    @(posedge slow_clk);write_instruction(32'h1080006f); 
    @(posedge slow_clk);write_instruction(32'hfef44703); 
    @(posedge slow_clk);write_instruction(32'h07000793); 
    @(posedge slow_clk);write_instruction(32'h0ef71e63); 
    @(posedge slow_clk);write_instruction(32'h01f00793); 
    @(posedge slow_clk);write_instruction(32'hfef407a3); 
    @(posedge slow_clk);write_instruction(32'h0f00006f); 
    @(posedge slow_clk);write_instruction(32'hfee44783); 
    @(posedge slow_clk);write_instruction(32'hff040713); 
    @(posedge slow_clk);write_instruction(32'h00f707b3); 
    @(posedge slow_clk);write_instruction(32'hff07c703); 
    @(posedge slow_clk);write_instruction(32'h00b00793); 
    @(posedge slow_clk);write_instruction(32'h06f71263); 
    @(posedge slow_clk);write_instruction(32'hfef44703); 
    @(posedge slow_clk);write_instruction(32'h0e000793); 
    @(posedge slow_clk);write_instruction(32'h00f71863); 
    @(posedge slow_clk);write_instruction(32'h07000793); 
    @(posedge slow_clk);write_instruction(32'hfef407a3); 
    @(posedge slow_clk);write_instruction(32'h0c00006f); 
    @(posedge slow_clk);write_instruction(32'hfef44703); 
    @(posedge slow_clk);write_instruction(32'h0d000793); 
    @(posedge slow_clk);write_instruction(32'h00f71863); 
    @(posedge slow_clk);write_instruction(32'h07f00793); 
    @(posedge slow_clk);write_instruction(32'hfef407a3); 
    @(posedge slow_clk);write_instruction(32'h0a80006f); 
    @(posedge slow_clk);write_instruction(32'hfef44703); 
    @(posedge slow_clk);write_instruction(32'h0b000793); 
    @(posedge slow_clk);write_instruction(32'h00f71863); 
    @(posedge slow_clk);write_instruction(32'h07300793); 
    @(posedge slow_clk);write_instruction(32'hfef407a3); 
    @(posedge slow_clk);write_instruction(32'h0900006f); 
    @(posedge slow_clk);write_instruction(32'hfef44703); 
    @(posedge slow_clk);write_instruction(32'h07000793); 
    @(posedge slow_clk);write_instruction(32'h08f71263); 
    @(posedge slow_clk);write_instruction(32'h04e00793); 
    @(posedge slow_clk);write_instruction(32'hfef407a3); 
    @(posedge slow_clk);write_instruction(32'h0780006f); 
    @(posedge slow_clk);write_instruction(32'hfee44783); 
    @(posedge slow_clk);write_instruction(32'hff040713); 
    @(posedge slow_clk);write_instruction(32'h00f707b3); 
    @(posedge slow_clk);write_instruction(32'hff07c703); 
    @(posedge slow_clk);write_instruction(32'h00700793); 
    @(posedge slow_clk);write_instruction(32'h06f71063); 
    @(posedge slow_clk);write_instruction(32'hfef44703); 
    @(posedge slow_clk);write_instruction(32'h0e000793); 
    @(posedge slow_clk);write_instruction(32'h00f71863); 
    @(posedge slow_clk);write_instruction(32'h00100793); 
    @(posedge slow_clk);write_instruction(32'hfef407a3); 
    @(posedge slow_clk);write_instruction(32'h0480006f); 
    @(posedge slow_clk);write_instruction(32'hfef44703); 
    @(posedge slow_clk);write_instruction(32'h0d000793); 
    @(posedge slow_clk);write_instruction(32'h00f71863); 
    @(posedge slow_clk);write_instruction(32'h07e00793); 
    @(posedge slow_clk);write_instruction(32'hfef407a3); 
    @(posedge slow_clk);write_instruction(32'h0300006f); 
    @(posedge slow_clk);write_instruction(32'hfef44703); 
    @(posedge slow_clk);write_instruction(32'h0b000793); 
    @(posedge slow_clk);write_instruction(32'h00f71863); 
    @(posedge slow_clk);write_instruction(32'h00100793); 
    @(posedge slow_clk);write_instruction(32'hfef407a3); 
    @(posedge slow_clk);write_instruction(32'h0180006f); 
    @(posedge slow_clk);write_instruction(32'hfef44703); 
    @(posedge slow_clk);write_instruction(32'h07000793); 
    @(posedge slow_clk);write_instruction(32'h00f71663); 
    @(posedge slow_clk);write_instruction(32'h03d00793); 
    @(posedge slow_clk);write_instruction(32'hfef407a3); 
    @(posedge slow_clk);write_instruction(32'hfef44783); 
    @(posedge slow_clk);write_instruction(32'h00078513); 
    @(posedge slow_clk);write_instruction(32'h01c12403); 
    @(posedge slow_clk);write_instruction(32'h02010113); 
    @(posedge slow_clk);write_instruction(32'h00008067); 
    @(posedge slow_clk);write_instruction(32'hfe010113); 
    @(posedge slow_clk);write_instruction(32'h00812e23); 
    @(posedge slow_clk);write_instruction(32'h02010413); 
    @(posedge slow_clk);write_instruction(32'hfea42623); 
    @(posedge slow_clk);write_instruction(32'hfeb42423); 
    @(posedge slow_clk);write_instruction(32'hfec42223); 
    @(posedge slow_clk);write_instruction(32'hfed42023); 
    @(posedge slow_clk);write_instruction(32'hfec42703); 
    @(posedge slow_clk);write_instruction(32'hfe442783); 
    @(posedge slow_clk);write_instruction(32'h00f71c63); 
    @(posedge slow_clk);write_instruction(32'hfe842703); 
    @(posedge slow_clk);write_instruction(32'hfe042783); 
    @(posedge slow_clk);write_instruction(32'h00f71663); 
    @(posedge slow_clk);write_instruction(32'h00100793); 
    @(posedge slow_clk);write_instruction(32'h0080006f); 
    @(posedge slow_clk);write_instruction(32'h00000793); 
    @(posedge slow_clk);write_instruction(32'h00078513); 
    @(posedge slow_clk);write_instruction(32'h01c12403); 
    @(posedge slow_clk);write_instruction(32'h02010113); 
    @(posedge slow_clk);write_instruction(32'h00008067); 
    @(posedge slow_clk);write_instruction(32'hffffffff); 
    @(posedge slow_clk);write_instruction(32'hffffffff); 

     $display("Test Results:");
     $display("    PASSES: %d", passes);
     $display("    FAILS : %d", fails);
    #100000
    $display("Finish simulation at time %d", $time);
    $finish;
end

 wrapper dut (
.clk        (clk          ), // Top level system clock input.
.resetn       (resetn       ), // Asynchronous active low reset.
.uart_rxd     (uart_rxd     ), // UART Recieve pin.
.uart_rx_en   (uart_rx_en   ), // Recieve enable
.uart_rx_break(uart_rx_break), // Did we get a BREAK message?
.uart_rx_valid(uart_rx_valid), // Valid data recieved and available.
.uart_rx_data (uart_rx_data ), 
.input_gpio_pins(input_wires), 
.output_gpio_pins(output_wires), 
.write_done(write_done)
); 



endmodule