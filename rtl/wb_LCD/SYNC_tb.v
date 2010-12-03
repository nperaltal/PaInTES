//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
`timescale 1 ns / 100 ps

module SYNC_tb;

//----------------------------------------------------------------------------
// Parameter (may differ for physical synthesis)
//----------------------------------------------------------------------------
parameter tck              = 20;       // clock period in ns
//parameter uart_baud_rate   = 1152000;  // uart baud rate for simulation 
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
// Inputs
	
	reg sys_clk;
	reg sys_rst;
	
	wire H_SYNC;
	wire V_SYNC;
	wire SPDA;
	wire SPCLK;
	wire SPENB;
	wire [7:0] dataLCD;
	wire led;

	// Instantiate the Unit Under Test (UUT)
	TopSerial dut (
			.sys_clk(sys_clk),
			.sys_rst(sys_rst),
			.CLKIN(CLKIN),
			.H_SYNC(H_SYNC),
			.V_SYNC(V_SYNC),	
			.SPDA(SPDA),
			.SPCLK(SPCLK),
			.SPENB(SPENB),
			.dataLCD(dataLCD),
			.led(led)
	);


//----------------------------------------------------------------------------
// Device Under Test 
//-------------------------------------------------------------------------

initial         sys_clk <= 0;
always #(tck/2) sys_clk <= ~sys_clk ;


/* Simulation setup */
initial begin
	$dumpfile("SYNC_tb.vcd");
	$dumpvars(-1, dut);
 	
	#0		
	sys_rst = 1'b1;
	#100
	sys_rst = 1'b0;
	#100
	sys_rst = 1'b1;

	#(tck*3000000) $finish;
end



endmodule
