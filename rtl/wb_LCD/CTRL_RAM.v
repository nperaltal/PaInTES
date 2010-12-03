module CTRL_RAM (

	input sys_clk,
	input sys_rst,
// Signals RAM
	input dataram,
	output reg [7:0] dataLCD,
	output reg rd,
//Signals SYNC
	input H_DONE,
	input V_DONE,
	input CLKIN
	
);

/* FSM */
reg [1:0] state;
reg [1:0] next_state;
reg [1:0] countp;

parameter WAIT_RD		= 3'd0;                                                     
parameter DATA0			= 3'd1;
parameter DATA1			= 3'd2;
parameter DATA2			= 3'd3;

initial 
begin
rd=0;
end

always @(negedge CLKIN)begin
	if(sys_rst) begin countp=0; end
	else begin 
		countp=countp+1'b1;
		if(countp==2'h3) begin countp=0;end
		end
	
		
end

always @(posedge sys_clk) begin
	if(sys_rst ) begin
		state = WAIT_RD; 
		end
	else begin
		state = next_state;
	end
end

always @(*) begin
if(sys_rst)begin
rd=0; 
end
	next_state = state;
	case(state)
		WAIT_RD:begin	
				rd=0;
				if(V_DONE && H_DONE) next_state=DATA0;
			end
		DATA0:begin
				rd=1;
				if(!(V_DONE && H_DONE)) next_state=WAIT_RD;
				else begin
					if(countp==2'h0)begin
						if(dataram) dataLCD=8'hFF;	
						if(~dataram) dataLCD=8'h00;
						next_state=DATA1;
						end
				     end
			end
		DATA1: begin
				rd=0;
				if(!(V_DONE && H_DONE)) next_state=WAIT_RD;
				else begin
					if(countp==2'h1)next_state=DATA2; 
				     end
			end
		DATA2: begin	
				if(!(V_DONE && H_DONE)) next_state=WAIT_RD;
				else begin
					if(countp==2'h2)next_state=DATA0;
				     end
			end
		default :next_state = state;
	endcase
end
endmodule

