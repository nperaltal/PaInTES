//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
`timescale 1 ns / 100 ps

module system_tb;

//----------------------------------------------------------------------------
// Parameter (may differ for physical synthesis)
//----------------------------------------------------------------------------
parameter tck              = 20;       // clock period in ns
parameter uart_baud_rate   = 1152000;  // uart baud rate for simulation 

parameter clk_freq = 1000000000 / tck; // Frequenzy in HZ
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
reg        clk;
reg        rst;
wire       led;

wire uart_rxd;
wire uart_txd;

//----------------------------------------------------------------------------
// UART STUFF (testbench uart, simulating a comm. partner)
//----------------------------------------------------------------------------


//----------------------------------------------------------------------------
// Device Under Test 
//----------------------------------------------------------------------------
system #(
	.clk_freq(           clk_freq         ),
	.uart_baud_rate(     uart_baud_rate   )
) dut  (
	.clk(          clk    ),
	// Debug
	.rst(          rst    ),
	.led(          led    ),
	// ps2
	.ps2_data(  ps2_data  ),
	.ps2_clk(  ps2_clk  ),
        //Uart
  	.uart_rxd(  uart_rxd  ),
	.uart_txd(  uart_txd  )
);



        reg ps2_clk$inout$reg = 1'bZ;
   	wire ps2_clk = ps2_clk$inout$reg;

	reg  ps2_data$inout$reg = 1'bZ;
   	wire ps2_data = ps2_data$inout$reg;

/* Clocking device */
initial         clk <= 0;
always #(tck/2) clk <= ~clk;

initial 
begin
#68000
		ps2_clk$inout$reg=1;
#10000
		ps2_clk$inout$reg=0;
#10000
		ps2_clk$inout$reg=1;
#10000
		ps2_clk$inout$reg=0;
#10000
		ps2_clk$inout$reg=1;
#10000
		ps2_clk$inout$reg=0;
#10000
		ps2_clk$inout$reg=1;
#10000
		ps2_clk$inout$reg=0;
#10000
		ps2_clk$inout$reg=1;
#10000
		ps2_clk$inout$reg=0;
#10000
		ps2_clk$inout$reg=1;
#10000
		ps2_clk$inout$reg=0;
#10000
		ps2_clk$inout$reg=1;
#10000
		ps2_clk$inout$reg=0;
#10000
		ps2_clk$inout$reg=1;
#10000
		ps2_clk$inout$reg=0;
#10000
		ps2_clk$inout$reg=1;
#10000
		ps2_clk$inout$reg=0;
#10000
		ps2_clk$inout$reg=1;
#10000
		ps2_clk$inout$reg=0;
#10000
		ps2_clk$inout$reg=1;
#10000
		ps2_clk$inout$reg=0;
#10000
		ps2_clk$inout$reg=1;
#10000
		ps2_clk$inout$reg=0;
#10000
		ps2_clk$inout$reg=1;
#10000
		ps2_clk$inout$reg=0;
#10000
		ps2_clk$inout$reg=1;
#10000
		ps2_clk$inout$reg=0;
#10000
		ps2_clk$inout$reg=1;
#10000
		ps2_clk$inout$reg=0;

	
	
end

/*
initial 
begin
#380740
		ps2_data$inout$reg =0;
#19520
		ps2_data$inout$reg=1;
#19520
		ps2_data$inout$reg=1;
#19520
		ps2_data$inout$reg=1;
#19520
		ps2_data$inout$reg=0;
#19520
		ps2_data$inout$reg=1;
#19520
		ps2_data$inout$reg=1;
#19520
		ps2_data$inout$reg=1;


	
end/*




/* Simulation setup */
initial begin
	$dumpfile("system_tb.vcd");
	$dumpvars(-1, dut);

	// reset
	#0  rst <= 0;
	#80 rst <= 1;

		
	#(tck*20000) $finish;
end



endmodule


