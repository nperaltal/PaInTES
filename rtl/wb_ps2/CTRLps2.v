module CTRLps2 #(
        parameter  clk_freq = 50000000
	)(
	input sys_rst,
	input sys_clk,
	
	input we_reg, //datainput
	input [4:0] rx_bitcount,//recordar activar e igualar el chip select desde el wishbone
	
	output reg ps2_clk_out,
	output reg ps2_data_out1,
	output reg tx_busy,
	output state_receive,
	output state_transmit,
	input ps2_clk_2
	
);

/* FSM */
reg [2:0] state;
reg [2:0] next_state;
reg receive;
reg transmit;

parameter RECEIVE		= 3'd0;
parameter WAIT_READY		= 3'd1;
parameter CLOCK_LOW		= 3'd2;
parameter CLOCK_HIGH		= 3'd3;
parameter CLOCK_HIGH1		= 3'd4;
parameter CLOCK_HIGH2		= 3'd5;
parameter WAIT_CLOCK_LOW	= 3'd6;
parameter TRANSMIT		= 3'd7;

initial 
begin
//rx_avail=0;
//irq=0;
end

assign state_receive = state == RECEIVE;
assign state_transmit = state == TRANSMIT;

always @(posedge sys_clk) begin
	if(sys_rst ) 
		state = RECEIVE; 
	else begin
		state = next_state;
	end
end

//parameter divisor_100us = 1;
parameter divisor_100us = 10000;
reg [16:0] watchdog_timer;
wire watchdog_timer_done;
assign watchdog_timer_done = (watchdog_timer == 17'd0);
always @(sys_clk) begin
	if(sys_rst||ps2_clk_out)
		watchdog_timer <= divisor_100us - 1;
	else if(~watchdog_timer_done)
			watchdog_timer <= watchdog_timer - 1;
end

always @(*) begin
	ps2_clk_out = 1'b1;
	ps2_data_out1 = 1'b1;
	tx_busy = 1'b0;
	next_state = state;

	case(state)
		RECEIVE:begin
			tx_busy = 1'b0;
			if(we_reg) begin
				next_state = WAIT_READY;
			end
		end
		WAIT_READY: begin
			if(rx_bitcount == 5'd0) begin
				ps2_clk_out = 1'b0;
				next_state = CLOCK_LOW;
			end
		end
		CLOCK_LOW: begin
			ps2_clk_out = 1'b0;
			if(watchdog_timer_done) begin
				next_state = CLOCK_HIGH;
			end
		end
		CLOCK_HIGH: begin
			next_state = CLOCK_HIGH1;
		end
		CLOCK_HIGH1: begin
			next_state = CLOCK_HIGH2;
		end
		CLOCK_HIGH2: begin
			ps2_data_out1 = 1'b0;
			next_state = WAIT_CLOCK_LOW;
		end
		WAIT_CLOCK_LOW: begin
			ps2_data_out1 = 1'b0;
			if(ps2_clk_2 == 1'b0) begin
				next_state = TRANSMIT;
			end
		end
		TRANSMIT: begin
			tx_busy = 1'b1;
			if(rx_bitcount == 5'd10) begin
				next_state = RECEIVE;
			end
		end
		default :next_state = state;
	endcase
end
endmodule
