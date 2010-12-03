

module ps2 (
	input sys_rst,
	input sys_clk,
	
	input [7:0] csr_di, //datainput

	input csr_we, //control status register write enable
	input ps2_clk_out,
	input ps2_data_out1,
	input state_receive,
	input state_transmit,
	
	inout ps2_clk,
	inout ps2_data,

	output reg [7:0] kcode,
	output reg [4:0] rx_bitcount,
	output reg we_reg,
	output reg rx_avail,
	output reg irq,
	output reg ps2_clk_2
);

/* CSR interface */
//reg tx_busy;

//assign irq = (rx_bitcount == 5'd11) ? 1'b1 : 1'b0;
//assign rx_avail = (rx_bitcount == 5'd11) ? 1'b1 : 1'b0;

//-----------------------------------------------------------------
// divisor
//-----------------------------------------------------------------
reg [9:0] enable_counter;
wire enable;
assign enable = (enable_counter == 10'd0);

parameter divisor = 50000000/12800/18;

always @(posedge sys_clk) begin
	if(sys_rst)
		enable_counter <= divisor - 10'd1;
	else begin
		enable_counter <= enable_counter - 10'd1;
		if(enable)
			enable_counter <= divisor - 10'd1;
	end
end

//-----------------------------------------------------------------
// Synchronize ps2 clock and data
//-----------------------------------------------------------------
reg ps2_clk_1;
reg ps2_data_1;
reg ps2_data_2;
reg ps2_data_out2;

always @(posedge sys_clk) begin // 	 q chevere como acomodan señales desfasadas 
	ps2_clk_1 <= ps2_clk;
	ps2_data_1 <= ps2_data;
	ps2_clk_2 <= ps2_clk_1;
	ps2_data_2 <= ps2_data_1;
end

/* PS2 */
reg rx_clk_data;
reg [5:0] rx_clk_count;
reg [10:0] rx_data; 
reg [10:0] tx_data;

//-----------------------------------------------------------------
// PS2 RX/TX Logic
//-----------------------------------------------------------------
always @(posedge sys_clk) begin
	if(sys_rst) begin
		rx_clk_data <= 1'd1;
		rx_clk_count <= 5'd0;
		rx_bitcount <= 5'd0;
		rx_data <= 11'b11111111111;
		we_reg <= 1'b0;
		ps2_data_out2 <= 1'b1;
		irq <= 1'b0;
	end else begin
		rx_avail <= 1'b0;
		irq <= 1'b0;
		we_reg <= 1'b0;

			if(csr_we) begin
				tx_data <= {2'b11, ~(^csr_di[7:0]), csr_di[7:0]}; // STOP+PARITY+DATA
				we_reg <= 1'b1;
			end
		end
		if(enable) begin
			if(rx_clk_data == ps2_clk_2) begin
				rx_clk_count <= rx_clk_count + 5'd1;
			end else begin
				rx_clk_count <= 5'd0;
				rx_clk_data <= ps2_clk_2;// como es el mouse el q pone el clock tanto para trasnmitir como para recibir 
			end
			if(state_receive && rx_clk_data == 1'b0 && rx_clk_count == 5'd4) begin //para ejecutar la lectura el clk del mouse debe estar en cero 
				rx_data <= {ps2_data_2, rx_data[10:1]};
				rx_bitcount <= rx_bitcount + 5'd1;
				if(rx_bitcount == 5'd10) begin// Complete de word received
					kcode [7:0] = rx_data[9:2]; // lectura
					irq <= 1'b1;	
					rx_avail <= 1'b1;		
				end
			end
			if(state_transmit && rx_clk_data == 1'b0 && rx_clk_count == 5'd0) begin
				ps2_data_out2 <= tx_data[rx_bitcount];
				rx_bitcount <= rx_bitcount + 5'd1;
				if(rx_bitcount == 5'd10) begin
					ps2_data_out2 <= 1'b1;
				end
			end
			if(rx_clk_count == 5'd16) begin
				rx_bitcount <= 5'd0;
				rx_data <= 11'b11111111111;
			end
		end
	end



assign ps2_clk = ps2_clk_out ? 1'hz : 1'b0;
assign ps2_data = ps2_data_out1 & ps2_data_out2 ? 1'hz : 1'b0;

endmodule
