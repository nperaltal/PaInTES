
//Modulo de envio de comandos seriales para la activación del backlight

module SerCom_LCD(
	
	input sys_clk,
	input rst,

	output reg SPDA,
	output reg SPCLK,
	output reg SPENB
);

reg [4:0] counter2=0;
reg [11:0] counter1=0;
reg [19:0] counterFLAG=0;
reg FLAG;
reg FLAG2;
reg FLAG3;

initial begin 
SPCLK = 0;
SPENB = 1;
SPDA  = 0;
FLAG3 = 1;
FLAG2 = 1;
FLAG  = 0;
end



parameter A6=0;
parameter RW=0;
parameter A5=0;
parameter A4=0;
parameter A3=0;
parameter A2=1;	
parameter A1=0;	
parameter A0=1;
parameter D7=0;
parameter D6=1;
parameter D5=0;
parameter D4=1;
parameter D3=1;
parameter D2=1;
parameter D1=1;
parameter D0=1;
	
/// div for ~23Khz

always@(posedge sys_clk ) begin
if(~rst) begin counter1=0; SPCLK=0; end
else begin
	if(counter1==1100)begin counter1=0; SPCLK=SPCLK+1;end
	else begin counter1=counter1+1;end
		end
end

// counter to delay 16ms
always@(posedge sys_clk)begin
if(~rst)begin counterFLAG=0; FLAG2=1; FLAG=0; end
	else begin
		if(counterFLAG==800000 && FLAG2)begin 
			FLAG=1;
			FLAG2=0;			
			end
		else counterFLAG=counterFLAG+1;
	end
end
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//logic -> send command serial to device
always @(negedge SPCLK)begin
if(~rst) begin SPDA=0;FLAG3=1; SPENB = 1; end
else begin
if(FLAG && FLAG3) begin SPENB = 0; FLAG3=0;end
end
if(~SPENB)begin
	counter2=counter2+1;
	if(counter2==17) begin SPENB=1; counter2=0; end
		case (counter2)
			5'd1:	SPDA=0;
			5'd2:	SPDA=0;
			5'd3:	SPDA=0;
			5'd4:	SPDA=0;
			5'd5:	SPDA=0;
			5'd6:	SPDA=1;	
			5'd7:	SPDA=0;	
			5'd8:	SPDA=1;
			5'd9:	SPDA=0;
			5'd10:	SPDA=1;
			5'd11:	SPDA=0;
			5'd12:	SPDA=1;
			5'd13:	SPDA=1;
			5'd14:	SPDA=1;
			5'd15:	SPDA=1;
			5'd16:	SPDA=1;
			default : SPDA=D0;		
		endcase
	end
end
/////////////////////////////



endmodule



