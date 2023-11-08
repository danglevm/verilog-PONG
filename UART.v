module UART (
	//50 MHz clock
	input i_CLK,
	
	//serial input data
	input i_SERIAL_DATA,
	
	//A is right seg7, B is left seg7
	output o_SEGA_0,
	output o_SEGA_1,
	output o_SEGA_2,
	output o_SEGA_3,
	output o_SEGA_4,
	output o_SEGA_5,
	output o_SEGA_6,
	
	output o_SEGB_0,
	output o_SEGB_1,
	output o_SEGB_2,
	output o_SEGB_3,
	output o_SEGB_4,
	output o_SEGB_5,
	output o_SEGB_6
);

//Constants
//50 MHz clock
parameter c_CYCLES_PER_SECOND = 50000000;
//baud rate or in this case 1-bit bit rate
parameter c_BAUD_RATE = 115200;
//434 cycles/bit currently
parameter c_CYCLES_PER_BIT = c_CYCLES_PER_SECOND/c_BAUD_RATE;

wire w_SEGA_0, w_SEGB_0;
wire w_SEGA_1, w_SEGB_1;
wire w_SEGA_2, w_SEGB_2;
wire w_SEGA_3, w_SEGB_3;
wire w_SEGA_4, w_SEGB_4;
wire w_SEGA_5, w_SEGB_5;
wire w_SEGA_6, w_SEGB_6;

reg [7:0] BYTE_DATA;


BINARY_TO_7SEG_DISPLAY SEG7_A (
	.i_CLK (i_CLK),
	.i_BINARY (BYTE_DATA[3:0]),
	.o_SEG_0 (w_SEGA_0),
	.o_SEG_1 (w_SEGA_1),
	.o_SEG_2 (w_SEGA_2),
	.o_SEG_3 (w_SEGA_3),
	.o_SEG_4 (w_SEGA_4),
	.o_SEG_5 (w_SEGA_5),
	.o_SEG_6 (w_SEGA_6)
);

assign o_SEGA_0 = w_SEGA_0;
assign o_SEGA_1 = w_SEGA_1;
assign o_SEGA_2 = w_SEGA_2;
assign o_SEGA_3 = w_SEGA_3;
assign o_SEGA_4 = w_SEGA_4;
assign o_SEGA_5 = w_SEGA_5;
assign o_SEGA_6 = w_SEGA_6;

BINARY_TO_7SEG_DISPLAY SEG7_B (
	.i_CLK (i_CLK),
	.i_BINARY (BYTE_DATA[7:4]),
	.o_SEG_0 (w_SEGB_0),
	.o_SEG_1 (w_SEGB_1),
	.o_SEG_2 (w_SEGB_2),
	.o_SEG_3 (w_SEGB_3),
	.o_SEG_4 (w_SEGB_4),
	.o_SEG_5 (w_SEGB_5),
	.o_SEG_6 (w_SEGB_6)
);

assign o_SEGB_0 = w_SEGB_0;
assign o_SEGB_1 = w_SEGB_1;
assign o_SEGB_2 = w_SEGB_2;
assign o_SEGB_3 = w_SEGB_3;
assign o_SEGB_4 = w_SEGB_4;
assign o_SEGB_5 = w_SEGB_5;
assign o_SEGB_6 = w_SEGB_6;

endmodule
