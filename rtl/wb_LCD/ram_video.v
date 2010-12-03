`timescale 1ns / 1ps
module ram_video#(

parameter boot0 ="none",//Para inicializaciones de las memorias desde archivos externos .ram
parameter boot1 ="none",
parameter boot2 ="none",
parameter boot3 ="none",
parameter boot4 ="none"
) (

  input   sys_clk,
  input   sys_rst,
 	
  input   we0,
  input   we1,
  input   we2,
  input   we3,
  input   we4,

  input   rd,	
  input   CLKIN,

  input   [13:0]      addr0,
  input   [13:0]      addr1,
  input   [13:0]      addr2,
  input   [13:0]      addr3,
  input   [13:0]      addr4,

  input    dataIn,//Datos que se escriben SW
  output   reg dataOut_ram//Datos de lectura 
 
);

//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
wire  din0;
wire  din1;
wire  din2;
wire  din3;
wire  din4;

reg [13:0] addr=-1;
reg [13:0] addr0b=14'd0;
reg [13:0] addr1b=14'd0;
reg [13:0] addr2b=14'd0;
reg [13:0] addr3b=14'd0;
reg [13:0] addr4b=14'd0;

wire  dout0;
wire  dout1;
wire  dout2;
wire  dout3;
wire  dout4;

reg en0;
reg en1;
reg en2;
reg en3;
reg en4;


initial 
begin
en0=1;
en1=0;
en2=0;	
en3=0;	
en4=0;	
dataOut_ram=0;
end

assign din0=dataIn;
assign din1=dataIn;
assign din2=dataIn;
assign din3=dataIn;
assign din4=dataIn;

assign clkrd= (rd==1) ? CLKIN : 0;

wire [4:0]enable;
assign enable={en4,en3,en2,en1,en0};
//LECTURA
always@(negedge clkrd)begin
if(sys_rst)begin
	en0=1'b1;
	en1=1'b0;
	en2=1'b0;
	en3=1'b0;
	en4=1'b0;
	addr=-1;
        end 

else if(rd) begin
		 begin
					addr=addr+1;
					if(addr==14'd16383 && en0==1 )begin en0=0;en1=1;en2=0; en3=0; en4=0;		addr=14'd0;end
					if(addr==14'd16383 && en1==1 )begin en0=0;en1=0;en2=1; en3=0; en4=0;		addr=14'd0;end
					if(addr==14'd16383 && en2==1 )begin en0=0;en1=0;en2=0; en3=1; en4=0;		addr=14'd0;end
					if(addr==14'd16383 && en3==1 )begin en0=0;en1=0;en2=0; en3=0; en4=1;		addr=14'd0;end
					if(addr==14'd11268 && en4==1 )begin en0=1;en1=0;en2=0; en3=0; en4=0;		addr=14'b0;end
		 end
	   end 
end


always@(*)
			case (enable)
				5'b00001:begin
					addr0b=addr;
					dataOut_ram=dout0;
					end
				5'b00010:begin
					addr1b=addr;
					dataOut_ram=dout1;
					end
				5'b00100:begin
					addr2b=addr;
					dataOut_ram=dout2;
					end
				5'b01000:begin
					addr3b=addr;
					dataOut_ram=dout3;
					end
				5'b10000:begin
					addr4b=addr;
					dataOut_ram=dout4;
					end
				default:begin
					dataOut_ram=0;
					end
			endcase




// PUERTOS A PARA ESCRITURAS Y PUERTOS B PARA LECTURAS

bloque0#(
.mem_file_name(boot0)

) bloque0(
.clkA(~sys_clk),
.clkB(~clkrd),
.we(we0),
.addr_a(addr0), // Escritura
.din_a(din0),
.addr_b(addr0b), //lectura
.dout_b(dout0),
.enB(en0)
);

bloque1 
#(
.mem_file_name(boot1)
) 
bloque1(

.clkA(~sys_clk),
.clkB(~clkrd),
.we(we1),
.addr_a(addr1), // Escritura
.din_a(din1),
.addr_b(addr1b), //lectura
.dout_b(dout1),
.enB(en1)
);
bloque2#(
.mem_file_name(boot2)
) 
 bloque2(

.clkA(~sys_clk),
.clkB(~clkrd),
.we(we2),
.addr_a(addr2), // Escritura
.din_a(din2),
.addr_b(addr2b), //lectura
.dout_b(dout2),
.enB(en2)
);
bloque3#(
.mem_file_name(boot3)
) 
 bloque3(

.clkA(~sys_clk),
.clkB(~clkrd),
.we(we3),
.addr_a(addr3), // Escritura
.din_a(din3),
.addr_b(addr3b), //lectura
.dout_b(dout3),
.enB(en3)
);
bloque4#(
.mem_file_name(boot4)
) 
 bloque4(

.clkA(~sys_clk),
.clkB(~clkrd),
.we(we4),
.addr_a(addr4), // Escritura
.din_a(din4),
.addr_b(addr4b), //lectura
.dout_b(dout4),
.enB(en4)
);

endmodule
