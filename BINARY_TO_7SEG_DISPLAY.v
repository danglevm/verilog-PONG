module BINARY_TO_7SEG_DISPLAY (
	input i_CLK,
	input i_BINARY[3:0],
	output o_SEG_0,
	output o_SEG_1,
	output o_SEG_2,
	output o_SEG_3,
	output o_SEG_4,
	output o_SEG_5,
	output o_SEG_6
);

reg SEVEN_SEG [6:0] = 7'b0000000;


always @ (posedge i_CLK) begin
	case (i_BINARY){
	4'b0000 : SEVEN_SEG <= 7b'0111111;
	4'b0001 :;
	4'b0010 :;
	4'b0011 :;
	4'b0100 :;
	4'b0101 :;
	4'b0110 :;
	4'b0111 :;
	4'b1000 :;
	4'b1001 :;
	4'b1010 :;
	4'b1011 :;
	4'b1100 :;
	4'b1101 :;
	4'b1110 :;
	4'b1111 :;
	
	
	}
	endcase
end

assign o_SEG_6 = SEVEN_SEG[6];
assign o_SEG_5 = SEVEN_SEG[5];
assign o_SEG_4 = SEVEN_SEG[4];
assign o_SEG_3 = SEVEN_SEG[3];
assign o_SEG_2 = SEVEN_SEG[2];
assign o_SEG_1 = SEVEN_SEG[1];
assign o_SEG_0 = SEVEN_SEG[0];

endmodule
