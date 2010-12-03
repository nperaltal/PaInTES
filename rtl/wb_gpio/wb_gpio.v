//-----------------------------------------------------------------
// Wishbone BlockRAM
//-----------------------------------------------------------------

module wb_gpio(
	input             clk_i, 
	input             rst_i,
	//
	input             wb_stb_i,
	input             wb_cyc_i,
	input             wb_we_i,
	output            wb_ack_o,
	input      [31:0] wb_adr_i,
	output reg [31:0] wb_dat_o,
	input      [31:0] wb_dat_i,
	input      [ 3:0] wb_sel_i
);

//-----------------------------------------------------------------
// Storage depth in 32 bit words
//-----------------------------------------------------------------

//-----------------------------------------------------------------t
// 
//-----------------------------------------------------------------
reg            [31:0] ram [0:8191];    // actual RAM
reg                   ack;
wire 		[12:0] adr;


assign adr        = wb_adr_i[14:2];      // 
assign wb_ack_o   = wb_stb_i & ack;

always @(posedge clk_i)
begin
	if (wb_stb_i && wb_cyc_i) // if CS enable and cycle valid 
	begin
		if (wb_we_i) 				// write cycle
			ram[ adr ] <= wb_dat_i;		// El dato de entrada, from WB se ubica en el espacio de memoria indicado por add
		
		wb_dat_o <= ram[ adr ];
		ack <= ~ack;
	end else
		ack <= 0;
    
end



endmodule

