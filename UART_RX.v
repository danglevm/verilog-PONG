module UART_RX 
//relate clock frequency with bit rate
//how many clock pulses are generated per bit transmitted
# (parameter c_CYCLES_PER_BIT)
(
	input i_CLK,
	input i_SERIAL_DATA,
	input i_PARITY,
	output o_DATA_RX [7:0]
);

reg r_STATE = 5'b00000;
reg r_TRANSMISSION = 1'b1;
//counter goes up to 434 cycles/second
reg r_COUNTER [31:0] = 0;
reg r_BIT_INDEX = 0;

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
				r_COUNTER <= 0;
				r_BIT_INDEX <= 0;
				
				if (r_RX_DATA_S == 1'b1) begin
					r_STATE <= s_START
				end
				else if
					r_STATE <= s_IDLE;
				end
					
			end
		s_START:
		s_DATA:
		s_END:
		s_TRANSITION:
		
		default : 
			begin
				r_STATE <= s_IDLE;
			end
		endcase
	end


endmodule