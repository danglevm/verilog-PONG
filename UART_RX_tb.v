`timescale 1ns/1ps

module UART_RX_tb ();

//50 MHz clock
parameter c_CYCLES_PER_SECOND = 50000000;
//baud rate or in this case 1-bit bit rate
parameter c_BAUD_RATE = 115200;
//434 cycles/bit currently
parameter c_CYCLES_PER_BIT = c_CYCLES_PER_SECOND/c_BAUD_RATE;

parameter c_HIGH = 1'b1;
parameter c_LOW = 1'b0;
parameter c_BIT_LENGTH = 1'd8;
parameter c_EXPECTED_VALUE = 8'h26;

reg r_CLK = 1'b0;
reg r_SERIAL_DATA = 1'b0;
reg r_RESET = 1'b0;


//Received data is driven to a wire but that value is
//only read when a valid data pulse is emitted
wire [7:0] w_DATA_DRIVEN;

wire w_VALID;

UART_RX #( .c_CYCLES_PER_BIT (c_CYCLES_PER_BIT) ) UUT 
(
	.i_CLK (r_CLK),
	.i_RESET (r_RESET),
	.i_SERIAL_DATA(r_SERIAL_DATA),
	.o_DATA_RX(w_DATA_DRIVEN),
	.o_RX_DATA_VALID(w_VALID)
);

task WRITE_TO_RX (input [7:0] p_BYTE, integer p_count);
	
	begin
		//send start bit and wait for one bit cycle
		r_SERIAL_DATA <= c_LOW;
		#(c_CYCLES_PER_BIT);
		
		//send data bit
		for (p_count = 0; p_count < c_BIT_LENGTH; p_count = p_count + 1) begin
			r_SERIAL_DATA <= p_BYTE [p_count];
			#(c_CYCLES_PER_BIT);
		end
		
		//send stop bit and wait for one bit cycle
		r_SERIAL_DATA <= c_HIGH;
		#(c_CYCLES_PER_BIT);
		
	end

endtask
 


initial 
	begin
		forever # (c_CYCLES_PER_BIT/2) r_CLK = !r_CLK;
		
		@(posedge r_CLK);
		WRITE_TO_RX(c_EXPECTED_VALUE);
		@(posedge r_CLK);
		
		if (w_VALID == c_HIGH) begin
			if (w_DATA_DRIVEN == c_EXPECTED_VALUE) begin
				$display ("Correct value received");
			end else begin
				$display ("Incorrect value received");
			end
		end
		
	$finish();
		
	end
	

endmodule