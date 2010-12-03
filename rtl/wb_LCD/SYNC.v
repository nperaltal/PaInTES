module SYNC (
		
		input sys_clk,
		input rst,
		output reg CLKIN,
		output reg H_SYNC,
		output reg H_DONE,
		output reg V_SYNC,
		output reg V_DONE
		//output reg [7:0] dataLCD
	
);

reg div_25;
reg [10:0] counterH;
reg [18:0] counterV;
reg counteraux;

//reg H_DONE;
//reg V_DONE;

initial begin
//dataLCD=8'h00;
div_25=1'b0;
CLKIN=1'b0;
H_DONE=1'b0;
H_SYNC=1'b0;
V_SYNC=1'b0;
counterH=11'b0;
counterV=19'b0;
counteraux =1'b1;
end

always @(posedge sys_clk)begin
//if(rst) begin CLKIN=0; div_25=0; endcounterH=0;
//else begin
	if(div_25)begin
		div_25=0;
		CLKIN =1;
		end
	else begin
	div_25=div_25+1;//Se obtiene un clock 25 MHz para CLKIN del LCD
	CLKIN=0;
	end
  //   end	
end

// Horizontal signals
always@(negedge CLKIN or posedge rst)begin
if(rst) begin counterH=0; H_SYNC=0; end
else  begin
	if(counterH==1)begin H_SYNC=0;	counterH=counterH+1;end
	else begin
			if(counterH==1716)begin 
				counterH=0;
				H_SYNC=0;	
			end 
			counterH=counterH+1;
			H_SYNC=1;

	     end
	end
end
// back porch front porch  70-------------------------------686
always@(negedge CLKIN)begin
if(rst) begin H_DONE=0; end
else begin
	if(counterH > 70 && counterH <1031)begin
		H_DONE=1'b1;//Indica cuando comienza el ciclo válido para envio de datos (espacio observable)
	end
	else H_DONE=1'b0;
     end

end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Vertical Signals
always@(negedge CLKIN or posedge rst)begin
if(rst) begin counteraux=1; counterV=0; V_SYNC=0;end
else begin
	if(counterV==1)begin V_SYNC=0;	counterV=counterV+1;end
	else begin
		if(counterV==450450)begin//Contad, de 262.5*1716, para sincronización vertical
		counterV=0;
		V_SYNC=0;
		counteraux=counteraux+1;
		end
			counterV=counterV+1;
			V_SYNC=1;
	    end
     end
end
// logical f, odd , even line
//assign V_DONE = (counteraux) ? ((counterV > 36036 && counterV < 447878) ? 1:0) : ((counterV > 36895 && counterV < 448734) ? 1: 0) ;

always @(negedge CLKIN or posedge rst) begin
if(rst) begin V_DONE=0; end
else begin
	if(counteraux)begin //Si es impar la línea
		if(counterV > 36037 && counterV < 447878)begin//>21 Counts BP y 1.5 de FP
		V_DONE=1'b1; 
		end
		else V_DONE=1'b0;	
	end else begin//Si es par la línea
		if(counterV > 36894 && counterV < 448734)begin//21.5 counts de BP y 1 de FP
		V_DONE=1'b1;
		end
		else V_DONE=1'b0;	
	end
end
end
/*always @(negedge CLKIN ) begin
		if(counterH > 71 && counterH <166 )begin//>21 Counts BP y 1.5 de FP
		dataLCD=8'hFF; //BLANCO
		end
//		else dataLCD=8'b0;
		if(counterH > 165 && counterH < 262)begin//>21 Counts BP y 1.5 de FP
		dataLCD=8'h00; 
		end  
//		else dataLCD=8'b1;
		if(counterH > 261 && counterH < 358)begin//>21 Counts BP y 1.5 de FP
		dataLCD=8'hFF; 
		end  
//		else dataLCD=8'b0;
		if(counterH > 357 && counterH < 454)begin//>21 Counts BP y 1.5 de FP
		dataLCD=8'h00;
		end  
//		else dataLCD=8'b1;
		if(counterH > 453 && counterH < 550)begin//>21 Counts BP y 1.5 de FP
		dataLCD=8'hFF; 
		end  
		if(counterH > 549 && counterH < 646)begin//>21 Counts BP y 1.5 de FP
		dataLCD=8'h00; 
		end  
		if(counterH > 645 && counterH < 742)begin//>21 Counts BP y 1.5 de FP
		dataLCD=8'hFF; 
		end  
		if(counterH >  741 && counterH < 838)begin//>21 Counts BP y 1.5 de FP
		dataLCD=8'h00; 
		end  
		if(counterH > 837 && counterH < 934)begin//>21 Counts BP y 1.5 de FP
		dataLCD=8'hFF; 
		end  
		if(counterH > 933 && counterH < 1030)begin//>21 Counts BP y 1.5 de FP
		dataLCD=8'h00; 
		end
  
end*/
endmodule

