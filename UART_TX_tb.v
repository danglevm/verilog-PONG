`timescale 1ns/1ps

module UART_TX_tb();

//50 MHz clock
parameter c_CYCLES_PER_SECOND = 50000000;
//baud rate or in this case 1-bit bit rate
parameter c_BAUD_RATE = 115200;
//434 cycles/bit currently
parameter c_CYCLES_PER_BIT = c_CYCLES_PER_SECOND/c_BAUD_RATE;

parameter c_HIGH = 1'b1;
parameter c_LOW = 1'b0;
parameter c_BIT_LENGTH = 1'd8;
//parameter c_PARALLEL_DATA = 8'b11001011;

reg r_CLK = 1'b0;
reg r_DATA_VALID = 1'b0;
reg [7:0] r_PARALLEL_INPUT = 0;
reg [7:0] r_PARALLEL_OUTPUT = 0;

wire w_OUTPUT_SERIAL;
wire w_TX_ACTIVE;

UART_TX  #( .c_CYCLES_PER_BIT (c_CYCLES_PER_BIT) ) UUT_TX 
(
	.i_CLK (r_CLK),
	.i_TX_DV (r_DATA_VALID),
	.i_PARALLEL_DATA (r_PARALLEL_DATA),
	.o_SERIAL_DATA (w_OUTPUT_SERIAL),
	.o_TX_ACTIVE (w_TX_ACTIVE),
	.o_TX_DONE ()
);

UART_RX #( .c_CYCLES_PER_BIT (c_CYCLES_PER_BIT) ) UUT_RX
(
	.i_CLK (r_CLK),
	.i_RESET (r_RESET),
	.i_SERIAL_DATA(r_RX_SERIAL_INPUT),
	.o_DATA_RX(w_DATA_DRIVEN),
	.o_RX_DATA_VALID(w_VALID)
);
//
//or is at logic high, which is default for idle state of UART_RX
assign  = w_TX_ACTIVE ? w_OUTPUT_SERIAL : c_HIGH;

initial
	begin
		forever # (c_CYCLES_PER_BIT/2) r_CLK = !r_CLK;
		
		
	end

endmodule

