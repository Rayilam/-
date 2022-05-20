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

parameter AND  =3'b000;
parameter OR   =3'b001;
parameter ADD  =3'b010;
parameter SUB  =3'b110;
parameter SLT  =3'b111;
parameter SLTU =3'b011;
parameter XOR  =3'b100;
parameter NOR  =3'b101;

wire [`DATA_WIDTH - 1:0] and_res;
wire [`DATA_WIDTH - 1:0] or_res;
wire [`DATA_WIDTH - 1:0] add_sub_res;
wire [`DATA_WIDTH - 1:0] slt_res;
wire [`DATA_WIDTH - 1:0] xor_res;
wire [`DATA_WIDTH - 1:0] nor_res;
wire [`DATA_WIDTH - 1:0] sltu_res;

assign and_res =A&B;
assign or_res  =A|B;
assign xor_res =A^B;
assign nor_res =~or_res;

wire [`DATA_WIDTH - 1:0] add_r;
wire [`DATA_WIDTH - 1:0] a;
wire [`DATA_WIDTH - 1:0] b;
wire s;
wire carry;
//ADD:a+b+0; SUB:a+~b+1
assign a = A;
assign b = (ALUop ==ADD)? B : ~B;
assign s = (ALUop ==ADD)? 0 : 1;
assign {carry,add_r} = {0,a} + {0,b} + s;
assign add_sub_res = add_r; 
//Overflow: A(+)+B(+)=R(-); A(-)+B(-)=R(+);
assign Overflow = ((a[31]==0 && b[31]==0 && add_r[31]==1) || (a[31]==1 && b[31]==1 && add_r[31]==0))?1:0;
assign CarryOut = carry ^ s;
//A<B--->slt(u)=1
assign slt_res  = add_r[31] ^ Overflow;
assign sltu_res = CarryOut;
assign Result = ({ 32{ ALUop == ADD  || ALUop == SUB} } & add_sub_res ) |
                ({ 32{ ALUop == AND  } } & and_res ) |
                ({ 32{ ALUop == OR   } } & or_res  ) |
                ({ 32{ ALUop == XOR  } } & xor_res ) |
                ({ 32{ ALUop == NOR  } } & nor_res ) |
                ({ 32{ ALUop == SLT  } } & slt_res ) |
                ({ 32{ ALUop == SLTU } } & sltu_res) ;
assign Zero = Result? 0 : 1;

endmodule
