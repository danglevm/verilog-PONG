module UART_RX 
//relate clock frequency with bit rate
//how many clock pulses are generated per bit transmitted
# (parameter c_CYCLES_PER_BIT)
(
	input i_CLK,
	input i_SERIAL_DATA,
	output [7:0] o_DATA_RX,
	//tells the module upstream that the data inside of the byte is actually valid
	//the upstream module will not look at the byte until it has seen a pulse from here
	output o_RX_DATA_VALID
);

reg r_STATE = 5'b00000;
reg r_TRANSMISSION = 1'b1;
//counter goes up to 434 cycles/second
reg [31:0] r_COUNTER = 0;
reg r_BIT_INDEX = 0;
reg r_RX_DV = 1'b0;
reg [7:0] r_DATA;

//variables for avoiding metastability
//RX_DATA_I - intermediate
//RX_DATA_S - synchronized
reg r_RX_DATA_I, r_RX_DATA_S;

parameter s_IDLE = 5'b00001;
parameter s_START = 5'b00010;
parameter s_DATA = 5'b00100;
parameter s_END = 5'b01000;
parameter s_TRANSITION = 5'b10000;


//double register to synchronize inputs and avoid metastability
always @ (posedge i_CLK)
	begin
		r_RX_DATA_I <= i_SERIAL_DATA;
		r_RX_DATA_S <= r_RX_DATA_I;
	end
	
	
	
//FSM
always @(posedge i_CLK) 
	begin
		case (r_STATE) 
		s_IDLE:
			begin
				r_TRANSMISSION <= 1'b1;
				r_RX_DV <= 1'b0;
				r_COUNTER <= 0;
				r_BIT_INDEX <= 0;
				
				if (r_RX_DATA_S == 1'b0) begin
					r_STATE <= s_START;
				end else begin
					r_STATE <= s_IDLE;
				end
					
			end
		s_START:
			begin
				if (r_COUNTER == ((c_CYCLES_PER_BIT - 1)/2) ) begin
					//in the middle of the bit
					if (r_RX_DATA_S == 1'b0) begin
						r_STATE <= s_DATA;
						r_COUNTER <= 0;
					end else begin
						r_STATE <= s_IDLE;
					end
				end else begin
					r_COUNTER <= r_COUNTER + 1'd1;
					r_STATE <= s_IDLE;
				end
			end
			
		s_DATA:
			begin
				if (r_COUNTER == (c_CYCLES_PER_BIT - 1)) begin
					r_DATA [r_BIT_INDEX] <= r_RX_DATA_S;
					r_COUNTER <= 0;
					
					if (r_BIT_INDEX < 7) begin
						r_BIT_INDEX <= r_BIT_INDEX + 1'd1;
						r_STATE <=  s_DATA;
					end else begin
						r_COUNTER <= 0;
						r_BIT_INDEX <= 0;
						r_STATE <= s_END;
					end						
				end else begin
					r_COUNTER = r_COUNTER + 1;
					r_STATE <= s_DATA;
					
				end
			end
		s_END:
			begin
				//wait out the whole bit cycle for the stop bit to finish
				if (r_COUNTER == (c_CYCLES_PER_BIT - 1)) begin
					r_RX_DV <= 1'b1;
					r_COUNTER <= 0;
					r_STATE <= s_TRANSITION;
				end else begin
					r_COUNTER <= r_COUNTER + 1'd1;
					r_STATE <= s_END;
				end
			end
			
		s_TRANSITION:
			begin
				//wait for one clock cycle before continuing
				r_TRANSMISSION <= 1'b1;
				r_RX_DV <= 1'b0;
				r_STATE <= s_IDLE;
			end
			
		default : r_STATE <= s_IDLE;
			
		
		endcase
	end
	
assign o_DATA_RX = r_DATA;
assign o_RX_DATA_VALID = r_RX_DV;

endmodule