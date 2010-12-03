`timescale 1ns / 1ps
//---------------------------------------------------------------------------
// Wishbone LCD 
//
// Register Description:
//
//    	0x00 ADDR0 	
//
//    	0x04 ADDR1
//
//    	0x08 ADDR2
//
//    	0x0C ADDR3
//
//	0X10 ADDR4 
//	
//	0X14 DATA
//--------------------------------------------------------------------------
module wb_LCD #(
parameter bootram0 ="none",
parameter bootram1 ="none",
parameter bootram2 ="none",
parameter bootram3 ="none",
parameter bootram4 ="none"
)
(
	input              clk,
	input              reset,
	// Wishbone interface
	input              wb_stb_i,
	input              wb_cyc_i,
	output             wb_ack_o,
	input              wb_we_i,
	input       [31:0] wb_adr_i,
	input        [3:0] wb_sel_i,
	input       [31:0] wb_dat_i,
	output reg  [31:0] wb_dat_o,
//signals UCF LCD
	output  [7:0] dataLCD,
	output   V_SYNC,
	output  H_SYNC,
	output  CLKIN,
	output SPDA,
	output SPENB,
	output SPCLK

);
//---------------------------------------------------------------------------
// Actual LCD_BRAM engine
//---------------------------------------------------------------------------
reg dataIn;

reg [13:0] addr0;
reg [13:0] addr1;
reg [13:0] addr2;
reg [13:0] addr3;
reg [13:0] addr4;

reg we0;
reg we1;
reg we2;
reg we3;
reg we4;

wire wb_rd = wb_stb_i & wb_cyc_i & ~wb_we_i;
wire wb_wr = wb_stb_i & wb_cyc_i &  wb_we_i & wb_sel_i[0];

reg  ack;

wire    sys_rst;
wire    sys_clk;
wire 	dataOut_ram;
wire 	rd;
wire 	H_DONE;
wire 	V_DONE;


assign sys_rst=~reset;
assign sys_clk=clk;


ram_video # (
.boot0(bootram0),
.boot1(bootram1),
.boot2(bootram2),
.boot3(bootram3),
.boot4(bootram4)
)ram_video(
	.sys_clk(sys_clk),
	.sys_rst(sys_rst),

	.we0(we0),
	.we1(we1),
	.we2(we2),
	.we3(we3),
	.we4(we4),

	.addr0(addr0),
	.addr1(addr1),
	.addr2(addr2),
	.addr3(addr3),
	.addr4(addr4),

	.rd(rd),
	.CLKIN(CLKIN),

	.dataIn(dataIn), 
	.dataOut_ram(dataOut_ram)
	);

CTRL_RAM CTRL_RAM(
	.sys_clk(sys_clk),
	.sys_rst(sys_rst),
//RAM
	.dataram(dataOut_ram),
	.dataLCD(dataLCD),
	.rd(rd),
//SYNC 
	.H_DONE(H_DONE),
	.V_DONE(V_DONE),
	.CLKIN(CLKIN)
	);

SYNC SYNC(
	.sys_clk(sys_clk),
	.rst(sys_rst),
//RAM
	.H_DONE(H_DONE), 
	.V_DONE(V_DONE),
	.CLKIN(CLKIN),
	.H_SYNC(H_SYNC),
	.V_SYNC (V_SYNC)
	);

SerCom_LCD SerCom_LCD(
	.sys_clk(sys_clk),
	.rst(~sys_rst),
	.SPDA(SPDA),
	.SPENB(SPENB),
	.SPCLK(SPCLK)
);



assign wb_ack_o  = wb_stb_i & wb_cyc_i & ack;

always @(posedge clk)
begin
	if (~reset) begin
		wb_dat_o[31:0] <= 32'b0;
		ack    <= 0;
	end else begin
		wb_dat_o[31:0] <= 32'b0;
		ack    <= 0;
	if (wb_wr & ~ack )
			begin
			ack <= 1;
			case (wb_adr_i[5:2])
				4'b0000: begin
					addr0[13:0] <= wb_dat_i [13:0];
					we0=1; we1=0; we2=0; we3=0; we4=0;
				end
				4'b0001: begin
					addr1[13:0] <= wb_dat_i [13:0];  
					we0=0; we1=1; we2=0; we3=0; we4=0;
				end
				4'b0010: begin
					addr2[13:0] <= wb_dat_i [13:0];  
					we0=0; we1=0; we2=1; we3=0; we4=0;
				end
				4'b0011: begin
					addr3[13:0] <= wb_dat_i [13:0];  
					we0=0; we1=0; we2=0; we3=1; we4=0;
				end
				4'b0100: begin
					addr4[13:0] <= wb_dat_i [13:0];  
					we0=0; we1=0; we2=0; we3=0; we4=1;
				end
				4'b0101: begin
					dataIn<= wb_dat_i[0];  
				end
				default :begin
					addr0 <= 0;
					addr1 <= 0;
					addr2 <= 0;
					addr3 <= 0;
					addr4 <= 0;
					dataIn<=0;	
					we0=0;we1=0;we2=0;we3=0;we4=0;
				end
			endcase
			end
			end
end
endmodule


