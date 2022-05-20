`timescale 10ns / 1ns

module custom_cpu(
	input  rst,
	input  clk,

	//Instruction request channel
	output [31:0] PC,
	output Inst_Req_Valid,
	input Inst_Req_Ready,

	//Instruction response channel
	input  [31:0] Instruction,
	input Inst_Valid,
	output Inst_Ready,

	//Memory request channel
	output [31:0] Address,
	output MemWrite,
	output [31:0] Write_data,
	output [3:0] Write_strb,
	output MemRead,
	input Mem_Req_Ready,

	//Memory data response channel
	input  [31:0] Read_data,
	input Read_data_Valid,
	output Read_data_Ready, 

    output [31:0]	cpu_perf_cnt_0,
    output [31:0]	cpu_perf_cnt_1,
    output [31:0]	cpu_perf_cnt_2,
    output [31:0]	cpu_perf_cnt_3,
    output [31:0]	cpu_perf_cnt_4,
    output [31:0]	cpu_perf_cnt_5,
    output [31:0]	cpu_perf_cnt_6,
    output [31:0]	cpu_perf_cnt_7,
    output [31:0]	cpu_perf_cnt_8,
    output [31:0]	cpu_perf_cnt_9,
    output [31:0]	cpu_perf_cnt_10,
    output [31:0]	cpu_perf_cnt_11,
    output [31:0]	cpu_perf_cnt_12,
    output [31:0]	cpu_perf_cnt_13,
    output [31:0]	cpu_perf_cnt_14,
    output [31:0]	cpu_perf_cnt_15

);

  //TODO: Please add your RISC-V CPU code here


	wire			RF_wen;
	wire [4:0]		RF_waddr;
	wire [31:0]		RF_wdata;

  wire [31:0] RF_rdata1;
  wire [31:0] RF_rdata2;
  wire [31:0] alu_A;
  wire [31:0] alu_B;
  wire [31:0] alu_result;
  wire [3:0]  aluop;
  wire zero;

wire [6:0] opcode;
wire [4:0] rd;
wire [2:0] funct3;
wire [4:0] rs1;
wire [4:0] rs2;
wire [6:0] funct7;

wire lui;
wire auipc;
wire jal;
wire B_Type; //beq,bne,blt,bge,bltu,bgeu
wire jalr;
wire I_Type; //I_Type except Load : addi,slti,sltiu,xori,ori,andi,slli,srli,srai
wire Store;  //sb,sh,sw
wire Load;   //lb,lh,lw,lbu,lhu
wire R_Type; //add,aub,slt,sltu,xor,or,and,sll,srl,sra
wire R_C;    //add,aub,slt,sltu,xor,or,and
wire R_S;    //sll,srl,sra
wire Shift;  //sll,srl,sra,slli,srli,srai
wire U_Type; //lui,auipc
wire I_C;    //addi,slti,sltiu,xori,ori,andi
wire I_S;    //slli,srli,srai

wire B1;
wire B2;
wire B_c1;
wire B_c2;

wire [31:0] extend;
wire [31:0] lb_data;
wire [31:0] lbu_data;
wire [31:0] lh_data;
wire [31:0] lhu_data;
wire [31:0] wdata_res;
wire sb;
wire sh;
wire [31:0] sb_data;
wire [31:0] sh_data;

wire [31:0] PC_4;
wire [31:0] PC_B;
wire [31:0] PC_jalr;
wire [31:0] PC_result;
wire [31:0] PC_next;

wire [31:0] shift_A;
wire [31:0] shift_B;
wire [1:0] shiftop;
wire [31:0] Shift_result;
//the number of clock cycle
reg [31:0] cycle_cnt;
always @(posedge clk) begin
       if(rst)
         cycle_cnt <=32'b0;
       else
         cycle_cnt <= cycle_cnt + 32'b1;
end
assign cpu_perf_cnt_0 = cycle_cnt;


//use one-hote code
localparam IF  = 9'b000000001;
localparam IW  = 9'b000000010;
localparam ID  = 9'b000000100;
localparam EX  = 9'b000001000;
localparam LD  = 9'b000010000;
localparam ST  = 9'b000100000;
localparam WB  = 9'b001000000;
localparam RDW = 9'b010000000;
localparam RST = 9'b100000000;
reg [31:0] PC_r;
reg [31:0] Read_data_r;
reg [31:0] Instruction_r;
reg [8:0] current_state;
reg [8:0] next_state;
//PC
always @(posedge clk) begin
       if(rst)
          PC_r <=32'b0;
       else if (current_state == EX)
          PC_r <=PC_next;
       else
          PC_r <= PC_r;
end

assign PC = (current_state == IF)?PC_r:PC;
//INSTRUCTION
always @(posedge clk) begin
       if (current_state == IW && (Inst_Valid && Inst_Ready))
          Instruction_r <= Instruction;
       else
          Instruction_r <= Instruction_r;
end

//Read_data
always @(posedge clk) begin
       if (current_state == RDW && (Read_data_Valid && Read_data_Ready))
          Read_data_r <= Read_data;
       else
          Read_data_r <= Read_data_r;
end

//DEFINE STATE MACHINE

//describe the current_state
always @ (posedge clk) begin
       if (rst) begin
           current_state <= RST;
       end
       else begin
           current_state <= next_state;
       end
end
//describe the next_state
always @ (*) begin
       case (current_state)
           RST:begin
              next_state = IF;
           end
           IF:begin
             if(Inst_Req_Ready)
                next_state = IW;
             else
                next_state = IF;
           end
           IW:begin
             if(Inst_Valid)
                next_state = ID;
             else
                next_state = IW;
           end
           ID:begin
                next_state = EX;
           end
           EX:begin
             if(B_Type)
                next_state = IF;
             else if(Store)
                next_state = ST;
             else if(Load)
                next_state = LD;
             else 
                next_state = WB;
           end
           LD:begin
             if(Mem_Req_Ready)
                next_state = RDW;
             else
                next_state = LD;
           end
           ST:begin
             if(Mem_Req_Ready)
                next_state = IF;
             else
                next_state = ST;
           end
           RDW:begin
             if(Read_data_Valid)
                next_state = WB;
             else
                next_state = RDW;
           end
           WB:begin
              next_state = IF;
           end
           default:
              next_state = current_state;
           
       endcase
end
//describe synchronous changes in different registers
assign Inst_Ready     =((current_state == IW) || (current_state == RST))?1:0;
assign Inst_Req_Valid =(current_state == IF)?1:0;
assign Read_data_Ready=((current_state == RDW) || (current_state == RST))?1:0;
assign MemRead        =(current_state == LD)?1:0;
assign MemWrite       =(current_state == ST)?1:0;



assign opcode = Instruction_r [6:0];
assign rd     = Instruction_r [11:7];
assign funct3 = Instruction_r [14:12];
assign rs1    = Instruction_r [19:15];
assign rs2    = Instruction_r [24:20];
assign funct7 = Instruction_r [31:25];
assign Address[31:0] = {alu_result [31:2],2'b0};
//type of operation
assign lui    = (opcode == 7'b0110111)?1:0;
assign auipc  = (opcode == 7'b0010111)?1:0;
assign jal    = (opcode == 7'b1101111)?1:0;
assign B_Type = (opcode == 7'b1100011)?1:0;
assign jalr   = (opcode == 7'b1100111)?1:0;
assign I_Type = (opcode == 7'b0010011)?1:0;
assign Store  = (opcode == 7'b0100011)?1:0;
assign Load   = (opcode == 7'b0000011)?1:0;
assign R_Type = (opcode == 7'b0110011)?1:0;
assign R_S    = R_Type && (funct3[0] && !funct3[1]);
assign R_C    = R_Type && !R_S;
assign U_Type = lui || auipc;
assign I_S    = I_Type && (funct3[0] && !funct3[1]);
assign I_C    = I_Type && !I_S;
assign Shift  = R_S || I_S;

//extend
assign extend = jal?{{12{Instruction_r[31]}},Instruction_r[19:12],Instruction_r[20],Instruction_r[30:21],1'b0}:
                (jalr|I_C|Load)?{{20{Instruction_r[31]}},Instruction_r[31:20]}:
                B_Type?{{20{Instruction_r[31]}},Instruction_r[7],Instruction_r[30:25],Instruction_r[11:8],1'b0}:
                Store?{{20{Instruction_r[31]}},Instruction_r[31:25],Instruction_r[11:7]}:
                {Instruction_r [31:12],12'b0};//U_Type

//B_Type

//(2)funct3[2]=1:blt,bge,bltu,bgeu;(1)funct3[2]=0:beq,bne;
assign B1 = (B_Type && (funct3[2] == 0))?1:0;
assign B2 = (B_Type && (funct3[2] == 1))?1:0;
//beq:funct3[0]=0;bne:funct3[0]=1;
assign B_c1 = B1? funct3[0]^zero:0;
//blt,bltu:funct3[0]=0;bge,bgeu:funct3[0]=1;
assign B_c2 = B2? funct3[0]^alu_result:0;
//Load

//lb_data=8bit lh_data=16bit
//lb_data:11-[31:24];10-[23:16];01-[15:8];00-[7:0];
assign lb_data = (Load&alu_result[1]&&alu_result[0])?{{24{Read_data_r[31]}},Read_data_r[31:24]}:
                 (Load&alu_result[1]&&!alu_result[0])?{{24{Read_data_r[23]}},Read_data_r[23:16]}:
                 (Load&!alu_result[1]&&alu_result[0])?{{24{Read_data_r[15]}},Read_data_r[15:8]}:
                 {{24{Read_data_r[7]}},Read_data_r[7:0]};
assign lbu_data = (Load&alu_result[1]&&alu_result[0])?{24'b0,Read_data_r[31:24]}:
                 (Load&alu_result[1]&&!alu_result[0])?{24'b0,Read_data_r[23:16]}:
                 (Load&!alu_result[1]&&alu_result[0])?{24'b0,Read_data_r[15:8]}:
                 {24'b0,Read_data_r[7:0]};

//lh_data:00-[15:0];
assign lh_data = (Load&&!alu_result[1]&&!alu_result[0])?{{16{Read_data_r[15]}},Read_data_r[15:0]}:{{16{Read_data_r[31]}},Read_data_r[31:16]};
assign lhu_data = (Load&&!alu_result[1]&&!alu_result[0])?{16'b0,Read_data_r[15:0]}:{16'b0,Read_data_r[31:16]};

//lb(000),lbu(100);lh(001),lhu(101);lw(010)
assign wdata_res = (Load&(funct3[2:0]==3'b000))?lb_data:
                   (Load&(funct3[2:0]==3'b100))?lbu_data:
		   (Load&(funct3[2:0]==3'b001))?lh_data:
                   (Load&(funct3[2:0]==3'b101))?lhu_data: 
                   Read_data_r[31:0];
//Store
assign sb  = (Store & (funct3[2:0]==3'b000))?1:0;
assign sh  = (Store & (funct3[2:0]==3'b001))?1:0;

//sb_data
assign sb_data =  (Store &(!alu_result[1]&&!alu_result[0]))?{24'b0,RF_rdata2[7:0]}:
                  (Store &(!alu_result[1]&& alu_result[0]))?{16'b0,RF_rdata2[7:0], 8'b0}:
                  (Store &( alu_result[1]&&!alu_result[0]))?{ 8'b0,RF_rdata2[7:0],16'b0}:
                  (Store &( alu_result[1]&& alu_result[0]))?{RF_rdata2[7:0],24'b0}:0;
//sh_data
assign sh_data = (Store &( alu_result[1]))?{RF_rdata2[15:0],16'b0}:
                 (Store &(!alu_result[1]))?{16'b0,RF_rdata2[15:0]}:0;
//Write_data
assign Write_data = sb?sb_data:sh?sh_data:RF_rdata2;
//Write_strb[0]:sb?00;sh?0x; sw:111
assign Write_strb[0]=Store?(sb?(!alu_result[1]&&!alu_result[0]):
                     sh?(!alu_result[1]):
                     1):0;
//Write_strb[1]:sb?01;sh?0x;
assign Write_strb[1]=Store?(sb?(!alu_result[1]&& alu_result[0]):
                     sh?(!alu_result[1]):
                     1):0;
//Write_strb[2]:sb?10;sh?1x;
assign Write_strb[2]=Store?(sb?( alu_result[1]&&!alu_result[0]):
                     sh?( alu_result[1]):
                     1):0;
//Write_strb[3]:sb?11;sh?1x;
assign Write_strb[3]=Store?(sb?( alu_result[1]& alu_result[0]):
                     sh?( alu_result[1]):
                     1):0;

//module instance-reg_file
assign RF_wen = (current_state==WB)?1:0;
assign RF_waddr = rd;                       
assign RF_wdata = Load? wdata_res:
                  lui?  extend:
                  auipc?PC_B:
                  jal|jalr?PC+4:
                  Shift?Shift_result:
                  alu_result;
reg_file RF(
.clk(clk), 
.rst(rst), 
.waddr(RF_waddr), 
.raddr1(rs1), 
.raddr2(rs2), 
.wen(RF_wen), 
.wdata(RF_wdata),
.rdata1(RF_rdata1), 
.rdata2(RF_rdata2)
);

//alu
localparam AND  =3'b000;
localparam OR   =3'b001;
localparam ADD  =3'b010;
localparam SUB  =3'b110;
localparam SLT  =3'b111;
localparam SLTU =3'b011;
localparam XOR  =3'b100;
localparam NOR  =3'b101;

assign alu_A = jal?PC_r:RF_rdata1;
assign alu_B = B_Type|R_C?RF_rdata2:extend;
//aluop
wire [2:0]  aluop_RI;
assign aluop_RI = ((R_C||I_C)&&(funct3[2:0]==3'b100))?XOR:
                  ((R_C||I_C)&&(funct3[2:0]==3'b110))? OR:
                  ((R_C||I_C)&&(funct3[2:0]==3'b111))?AND:             
                  ((R_C||I_C)&&(funct3[2:0]==3'b010))?SLT:
                  ((R_C||I_C)&&(funct3[2:0]==3'b011))?SLTU:
                  (R_C&&(funct3[2:0]==3'b000)&&funct7[5])?SUB:
                  ADD;
assign aluop = B1?SUB:
               (B2&&(!funct3[1]))?SLT:
               (B2&&funct3[1])?SLTU:
               R_C||I_C?aluop_RI:
               ADD;
               
//module instance-alu
alu ALU(
.A(alu_A), 
.B(alu_B), 
.ALUop(aluop), 
.Overflow(), 
.CarryOut(), 
.Zero(zero), 
.Result(alu_result)
);


//PC

assign PC_4 = PC_r + 4;
assign PC_B = PC+extend;
assign PC_jalr = alu_result & 32'hfffffffe;//(RF_rdata1 + extend)&~1;
assign PC_next = (jal|B_c1|B_c2)?PC_B:
                 jalr?PC_jalr:
		 PC_4;

//Shifte
assign shift_A = RF_rdata1;
assign shift_B = I_S?{27'b0,rs2[4:0]}:RF_rdata2;
assign shiftop = funct3[2]?{funct3[0],funct7[5]}:{funct3[2:1]};
//module instance-shifter
shifter Shifter(
.A(shift_A), 
.B(shift_B), 
.Shiftop(shiftop),
.Result(Shift_result)
);
endmodule
