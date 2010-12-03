
module bloque2 # (
parameter mem_file_name ="none"
) (
input wire clkA,
input wire clkB,
input wire we,
input enB,
input wire [13:0] addr_a,
input wire [13:0] addr_b,
input wire din_a,
output reg dout_b);

// signal declaration
reg  ram [0:16383];
assign enA =1;

initial 
begin 
if (mem_file_name != "none")
	begin
		$readmemb(mem_file_name, ram);
	end 
end


//body
always @(posedge clkA)
if (enA) begin
if (we)
ram[addr_a] <= din_a; 
end

always @(posedge clkB)
begin
if (enB)
dout_b<= ram[addr_b];
end


endmodule
