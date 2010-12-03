//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
`timescale 1 ns / 100 ps

module system_tb;

//----------------------------------------------------------------------------
// Parameter (may differ for physical synthesis)
//----------------------------------------------------------------------------
parameter tck              = 20;       // clock period in ns
//parameter uart_baud_rate   = 1152000;  // uart baud rate for simulation 

parameter clk_freq = 1000000000 / tck; // Frequenzy in HZ
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
// Inputs
	reg sys_rst;
	reg sys_clk;
	reg [13:0] csr_a;
	reg csr_we;
	reg [31:0] csr_di;

	// Outputs
	wire [31:0] csr_do;
	wire irq;

	// Bidirs
	wire ps2_clk;
	wire ps2_data;

	// Instantiate the Unit Under Test (UUT)
	ps2 dut (
		.sys_rst(sys_rst), 
		.sys_clk(sys_clk), 
		.csr_a(csr_a), 
		.csr_we(csr_we), 
		.csr_di(csr_di), 
		.csr_do(csr_do), 
		.ps2_clk(ps2_clk), 
		.ps2_data(ps2_data), 
		.irq(irq)
	);

//----------------------------------------------------------------------------
// Device Under Test 
//----------------------------------------------------------------------------
/*system #(
	.clk_freq(           clk_freq         ),
	.uart_baud_rate(     uart_baud_rate   )
) dut  (
	.clk(          clk    ),
	// Debug
	.rst(          rst    ),
	.led(          led    ),
	// Uart
	.uart_rxd(  uart_rxd  ),
	.uart_txd(  uart_txd  )
);*/

/* Clocking device */
initial         sys_clk <= 0;
always #(tck/2) sys_clk <= ~sys_clk;

/* Simulation setup */
initial begin
	$dumpfile("system_tb.vcd");
	$dumpvars(-1, dut);

		
		
		// Initialize Inputs
		csr_a [13:0]= 14'b00001000100010;
		sys_rst = 0;
		sys_clk = 0;
		csr_we = 0;
		csr_di = 0;

      		#10 sys_rst = 1;	
		// Wait 100 ns for global reset to finish
		#100;
		 sys_rst <= 0;
		csr_we = 1;
        	#200
		csr_di [31:0] = 32'hABCDEF78;
		// Add stimulus here


	#(tck*10000) $finish;
end



endmodule
