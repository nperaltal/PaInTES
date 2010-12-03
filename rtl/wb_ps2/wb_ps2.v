//---------------------------------------------------------------------------
// Wishbone PS_2 
//
// Register Description:
//
//    	0x00 UCR      [ 0 | 0 | rx_avail | irq  | 0 | 0 | 0 | tx_busy |  ]
//    	0x04 RX  Se crearán más registros de transmisión en caso de tener que enviarle más datos al mouse (resolución, inicializacion o modo de operación, etc)  
//    	0x08 TX  
//	  
//	tx_busy : RD
//	irq    : RD
//
//	tx  : WR
//	rx  : RD
//---------------------------------------------------------------------------


module wb_ps2 (
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

	inout ps2_data,
	inout ps2_clk,
	output irq,
	output [4:0]rx_bitcount
);
//---------------------------------------------------------------------------
// Actual PS/2 engine
//---------------------------------------------------------------------------
wire       sys_rst;
wire       sys_clk;
reg [7:0]  csr_di;
reg 	   csr_we;

wire       tx_busy;
wire       rx_avail;
wire [7:0] kcode;

parameter  clk_freq=50000000; 

TopmodulePS2 #(
	.clk_freq(  clk_freq )
     )TopmodulePS2(
	.sys_rst(sys_rst),
	.sys_clk(sys_clk),

	.csr_di(csr_di), 
	.csr_we(csr_we), 
	
	.irq(irq),
	.rx_avail(rx_avail),
	.tx_busy(tx_busy),
	.kcode(kcode),
	.rx_bitcount(rx_bitcount),

	.ps2_clk(ps2_clk),
	.ps2_data(ps2_data) 
	);



wire [7:0] ucr = { 2'b0, rx_avail, irq, 3'b0, tx_busy };

wire wb_rd = wb_stb_i & wb_cyc_i & ~wb_we_i;
wire wb_wr = wb_stb_i & wb_cyc_i &  wb_we_i & wb_sel_i[0];

reg  ack;

assign wb_ack_o  = wb_stb_i & wb_cyc_i & ack;


assign sys_rst=~reset;
assign sys_clk=clk;

always @(posedge clk)
begin
	if (~reset) begin
		wb_dat_o[31:8] <= 24'b0;
		csr_we <= 0;
		ack    <= 0;
	end else begin
		wb_dat_o[31:8] <= 24'b0;
		csr_we  <= 0;
		ack    <= 0;

		if (wb_rd & ~ack) begin    	//CYCLE READ
			ack <= 1;
			case (wb_adr_i[3:2])
			2'b00: begin
				wb_dat_o[7:0] <= ucr;
			end
			2'b01: begin
				wb_dat_o[7:0] <= kcode;
			end
			2'b11: begin
				wb_dat_o[7:0] <= {3'b0,rx_bitcount [4:0]};
			end
			default: begin
				wb_dat_o[7:0] <= 8'b0;
			end
			endcase
		end else if (wb_wr & ~ack ) begin // CYCLE WRITE
			ack <= 1;
			if ((wb_adr_i[3:2] == 2'b10) && ~tx_busy) begin
				csr_we <= 1;
				csr_di <= wb_dat_i[7:0];
			end
		end
	end
end


endmodule
