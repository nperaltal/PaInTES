`timescale 1ns / 1ps

module TopmodulePS2  # (
	parameter  clk_freq = 50000000
       )(
	input sys_rst,
	input sys_clk,
	
	input [7:0] csr_di, //datainput
	input csr_we, //control status register write enable

	inout ps2_clk,
	inout ps2_data,

	output irq,
	output rx_avail,
	output [7:0] kcode,
	output  tx_busy,
	output [4:0]rx_bitcount
);

wire state_transmit;
wire state_receive;
wire ps2_clk_out;
wire ps2_data_out1;
wire ps2_clk_2;
wire we_reg;

ps2 ps2(
        .sys_rst(sys_rst),
	.sys_clk(sys_clk),
	.csr_di(csr_di), //datainpu
	.csr_we(csr_we), //control status register write enable
	.ps2_clk_out(ps2_clk_out),
	.ps2_data_out1(ps2_data_out1),
	.ps2_clk_2(ps2_clk_2),
	.state_receive(state_receive),
	.state_transmit(state_transmit),
	.ps2_clk(ps2_clk),
	.ps2_data(ps2_data),
	.we_reg(we_reg), 
	.kcode(kcode),
	.rx_avail(rx_avail),
 	.irq(irq),
	.rx_bitcount(rx_bitcount)
);


CTRLps2 # (
	 .clk_freq(clk_freq) 
	)CTRLps2(
	.sys_rst(sys_rst),
	.sys_clk(sys_clk),
	.we_reg(we_reg), 
	.rx_bitcount(rx_bitcount),
	.ps2_clk_out(ps2_clk_out),
	.ps2_clk_2(ps2_clk_2),
	.ps2_data_out1(ps2_data_out1),
	.tx_busy(tx_busy),
	.state_receive(state_receive),
	.state_transmit(state_transmit)
);



endmodule
