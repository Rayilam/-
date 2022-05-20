`timescale 10 ns / 1 ns

`define DATA_WIDTH 32

module shifter (
	input [`DATA_WIDTH - 1:0] A,
	input [`DATA_WIDTH - 1:0] B,
	input [1:0] Shiftop,
	output [`DATA_WIDTH - 1:0] Result
);

	// TODO: Please add your logic code here

parameter sl  = 2'b00;
parameter srl = 2'b10;
parameter sr  = 2'b11;

assign Result = ({ 32{ Shiftop == sl  } } & A<<B[4:0] ) |
                ({ 32{ Shiftop == srl } } & A>>B[4:0] ) |
                ({ 32{ Shiftop == sr  } } & ({{32{A[31]}},A}>>B[4:0]) );

endmodule
