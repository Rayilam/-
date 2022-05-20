`timescale 10 ns / 1 ns

`define DATA_WIDTH 32

module alu(
	input [`DATA_WIDTH - 1:0] A,
	input [`DATA_WIDTH - 1:0] B,
	input [2:0] ALUop,
	output Overflow,
	output CarryOut,
	output Zero,
	output [`DATA_WIDTH - 1:0] Result
);

	// TODO: Please add your logic code here
parameter AND =3'b000;
parameter OR  =3'b001;
parameter ADD =3'b010;
parameter SUB =3'b110;
parameter SLT =3'b111;

wire [`DATA_WIDTH - 1:0] and_res;
wire [`DATA_WIDTH - 1:0] or_res;
wire [`DATA_WIDTH - 1:0] add_sub_res;
wire [`DATA_WIDTH - 1:0] slt_res;

assign and_res =A&B;
assign or_res  =A|B;

wire [`DATA_WIDTH - 1:0] add_r;
wire [`DATA_WIDTH - 1:0] a;
wire [`DATA_WIDTH - 1:0] b;
wire s;
wire carry;
//ADD:a+b+0; SUB:a+~b+1
assign a = A;
//assign b = (ALUop ==ADD)? B : ((ALUop ==SUB || ALUop == SLT)?(~B):B);
assign b = (ALUop ==ADD)? B : ~B;
//assign s = (ALUop ==ADD)? 0 : ((ALUop ==SUB || ALUop == SLT)?1:0);
assign s = ALUop[2];
assign {carry,add_r} = {0,a} + {0,b} + s;
assign add_sub_res = add_r; 
//Overflow: A(+)+B(+)=R(-); A(-)+B(-)=R(+);
assign Overflow = ((a[31]==0 && b[31]==0 && add_r[31]==1) || (a[31]==1 && b[31]==1 && add_r[31]==0))?1:0;
//assign CarryOut = (ALUop == ADD) ? ((carry==1)?1:0) : ((ALUop ==SUB)?((carry==0)?1:0):0);
assign CarryOut = carry ^ s;
//A-B-->(-)--->slt=1
//assign slt_res  = (ALUop == SLT)?add_r[31] ^ Overflow:0;
assign slt_res = add_r[31] ^ Overflow;
assign Result = ({ 32{ ALUop == ADD || ALUop == SUB} } & add_sub_res ) |
                ({ 32{ ALUop == AND } } & and_res) |
                ({ 32{ ALUop == OR  } } & or_res)  |
                ({ 32{ ALUop == SLT } } & slt_res) ;
assign Zero = Result? 0 : 1;


endmodule
