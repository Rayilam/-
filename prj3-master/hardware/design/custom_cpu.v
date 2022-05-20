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
       else if (current_state == EX || ((current_state == ID) && NOP))
          PC_r <=PC_next;
       else
          PC_r <= PC_r;
end
assign PC = (current_state == IF)?PC_r:PC;
//INSTRUCTION
always @(posedge clk) begin
       if(rst)
          Instruction_r <=32'b0;
       else if (current_state == IW && (Inst_Valid && Inst_Ready))
          Instruction_r <= Instruction;
       else
          Instruction_r <= Instruction_r;
end

//Read_data
always @(posedge clk) begin
       if(rst)
          Read_data_r <=32'b0;
       else if (current_state == RDW && (Read_data_Valid && Read_data_Ready))
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
             if (NOP)
                next_state = IF;
             else
                next_state = EX;
           end
           EX:begin
             if(Regimm || I_B || (Jump && !Jal))
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

localparam AND  =3'b000;
localparam OR   =3'b001;
localparam ADD  =3'b010;
localparam SUB  =3'b110;
localparam SLT  =3'b111;
localparam SLTU =3'b011;
localparam XOR  =3'b100;
localparam NOR  =3'b101;

	wire			RF_wen;
	wire [4:0]		RF_waddr;
	wire [31:0]		RF_wdata;

	wire [5:0] opcode;
	wire [4:0] rs;
	wire [4:0] rt;
	wire [4:0] rd;
	wire [4:0] shamt;
	wire [5:0] func;
	wire [15:0] immediate;
	wire [25:0] instr_index;

	assign opcode = Instruction_r [31:26];
	assign rs     = Instruction_r [25:21];
	assign rt   = Instruction_r [20:16];
	assign rd     = Instruction_r [15:11];
	assign shamt  = Instruction_r [10:6];
	assign func   = Instruction_r [5:0];
	assign immediate  = Instruction_r [15:0];
	assign instr_index = Instruction_r [25:0];

  wire [31:0] rdata1;
  wire [31:0] rdata2;
  wire [4:0]  raddr1;
  wire [4:0]  raddr2;
  wire [31:0] alu_A;
  wire [31:0] alu_B;
  wire [31:0] alu_result;
  wire [3:0]  aluop;
  wire zero;
  wire overflow;
  wire carryout;

//type of operation
wire R_Type;
wire R_C; //R-Caculation:addu|subu|and|nor|or|xor|slt|sltu
wire Shift; //R-Shift:sll sra srl sllv srav srlv
wire R_J; //R-Jump:jr jalr
wire Move; //movz movn
wire Regimm; //REGIMM:bltz bgez
wire Jump; //J-Type:j jal
wire I_B; //I-Branch:beq bne blez bgtz
wire I_C; //I-Caculation:addiu andi ori xori slti sltiu (except Lui)
wire Load;//lb lh lw lbu lhu lwl lwr
wire Store;//sb sh sw swl swr
wire Jalr;
wire Jal;
wire Lui;
wire NOP;
assign NOP = (Instruction_r[31:0]  == 32'b0 )?1:0;
assign R_Type = (opcode[5:0] == 6'b000000)?1:0;
assign R_C = (R_Type && (func[5] ==1'b1))?1:0;
assign Shift = (R_Type && (func[5:3] == 3'b000))?1:0;
assign R_J = (R_Type && ( {func[5:3],func[1]} == 4'b0010))?1:0;
assign Move = (R_Type && ( {func[5:3],func[1]} == 4'b0011))?1:0;
assign Regimm = (opcode [5:0] == 6'b000001)?1:0;
assign Jump = (opcode[5:1] == 5'b00001)?1:0;
assign I_B = (opcode [5:2] == 4'b0001)?1:0;
assign Lui = (opcode [5:0] == 6'b001111)?1:0;
assign I_C = (!Lui && (opcode [5:3] == 3'b001))?1:0;
assign Load = opcode[5]&(~opcode[3]);
assign Store = opcode[5]&opcode[3];
assign Jalr = (R_J && func[0])?1:0; 
assign Jal = (Jump && opcode[0])?1:0;
assign Address[31:0] = {alu_result [31:2],2'b0};
//extend
wire [31:0] extend;
wire [31:0] lui_extend;
wire [31:0] zero_extend;
wire [31:0] sign_extend;
assign lui_extend = {immediate[15:0],16'b0};
assign zero_extend = {16'b0,immediate[15:0]};
assign sign_extend = {{16{immediate[15]}},immediate[15:0]};
assign extend = (!Lui && (opcode[5:2] == 4'b0011))?zero_extend:(Lui?lui_extend:sign_extend);
//Move
wire move_c;
//movz:func[0]=0;movn:func[0]=1;
assign move_c = Move? func[0]^(rdata2 == 0):0;
//Regimm
wire regimm_c;
//Instruction[16]=0:BLTZ;Instruction[16]=1:BGEZ;
assign regimm_c = Regimm? Instruction_r[16]^alu_result:0;
//I_B
wire Ib1;
wire Ib2;
wire Ib_c1;
wire Ib_c2;
//beq,bne:opcode[1]=0(1);;blez,bgtz:opcode[1]=1(2);
assign Ib1 = (I_B && (opcode[1] == 0))?1:0;
assign Ib2 = (I_B && (opcode[1] == 1))?1:0;
//beq:opcode[0]=0;bne:opcode[1]=1;
assign Ib_c1 = Ib1? opcode[0]^zero:0;
//blez:opcode[0]=0;bgtz:opcode[0]=1;
assign Ib_c2 = Ib2? (opcode[0]? (rdata1 !=32'd0 & ~alu_result):(rdata1==32'd0 | alu_result)):0;

//Branch
wire Branch;
assign Branch = Regimm? regimm_c:
                Ib1?Ib_c1:
                Ib2?Ib_c2:0;
//Load
wire [7:0] lb_data;
wire [31:0] lh_data;
wire [31:0] lhu_data;
//lb_data=8bit lh_data=16bit
//lb_data:11-[31:24];10-[23:16];01-[15:8];00-[7:0];
assign lb_data = (Load&alu_result[1]&&alu_result[0])?Read_data_r[31:24]:
                 (Load&alu_result[1]&&!alu_result[0])?Read_data_r[23:16]:
                 (Load&!alu_result[1]&&alu_result[0])?Read_data_r[15:8]:
                 Read_data_r[7:0];
//lh_data:00-[0:15];
assign lh_data = (Load&&!alu_result[1]&&!alu_result[0])?{{16{Read_data_r[15]}},Read_data_r[15:0]}:{{16{Read_data_r[31]}},Read_data_r[31:16]};
assign lhu_data = (Load&&!alu_result[1]&&!alu_result[0])?{16'b0,Read_data_r[15:0]}:{16'b0,Read_data_r[31:16]};
wire [31:0] lwl_data;
wire [31:0] lwr_data;
//lwl_data:00-{[7:0],rt[23:0]};01:{[15:0],rt[15:0]};10:{[23:0],rt[7:0]};11:[31:0];
assign lwl_data = (Load&&!alu_result[1]&&!alu_result[0])?{Read_data_r[7:0],rdata2[23:0]}:
                  (Load&&!alu_result[1]&&alu_result[0])?{Read_data_r[15:0],rdata2[15:0]}:
                  (Load&&alu_result[1]&&!alu_result[0])?{Read_data_r[23:0],rdata2[7:0]}:
                  Read_data_r[31:0];
//lwr_data:00:[31:0];01{rt[31:24],[31:8]}..
assign lwr_data = (Load&&!alu_result[1]&&!alu_result[0])?Read_data_r[31:0]:
                  (Load&&!alu_result[1]&&alu_result[0])?{rdata2[31:24],Read_data_r[31:8]}:
                  (Load&&alu_result[1]&&!alu_result[0])?{rdata2[31:16],Read_data_r[31:16]}:
                  {rdata2[31:8],Read_data_r[31:24]};

wire [31:0] wdata_res;
//lb:lb(000),lbu(100);lh:lh(001),lhu(101);lwl(010);lwr(110)
assign wdata_res = (opcode == 6'b100000 )?{{24{lb_data[7]}},lb_data[7:0]}:
                    ( opcode == 6'b100100) ? {24'b0,lb_data[7:0]}:
		    (opcode == 6'b100001 ) ?lh_data:
                    (opcode == 6'b100101)?lhu_data: 
                    (opcode[2:0] == 3'b010)?lwl_data:
                    (opcode[2:0] == 3'b110)?lwr_data:
                     Read_data_r[31:0];
//Store
wire swl;
wire swr;
wire sb;
wire sh;
assign swl = (Store & (opcode[2:0]==3'b010))?1:0;
assign swr = (Store & (opcode[2:0]==3'b110))?1:0;
assign sb  = (Store & (opcode[2:0]==3'b000))?1:0;
assign sh  = (Store & (opcode[2:0]==3'b001))?1:0;
wire [31:0] swl_data;
wire [31:0] swr_data;
wire [31:0] sb_data;
wire [31:0] sh_data;
//swl_data
assign swl_data = (!alu_result[1]&&!alu_result[0])?{24'b0,rdata2[31:24]}:
                  (!alu_result[1]&& alu_result[0])?{16'b0,rdata2[31:16]}:
                  ( alu_result[1]&&!alu_result[0])?{ 8'b0,rdata2[31: 8]}:
                  ( alu_result[1]&& alu_result[0])?rdata2[31: 0]:0;
//swr_data
assign swr_data = (!alu_result[1]&&!alu_result[0])?rdata2[31:0]:
                  (!alu_result[1]&& alu_result[0])?{rdata2[23:0], 8'b0}:
                  ( alu_result[1]&&!alu_result[0])?{rdata2[15:0],16'b0}:
                  ( alu_result[1]&& alu_result[0])?{rdata2[ 7:0],24'b0}:0;
//sb_data
assign sb_data =  (!alu_result[1]&&!alu_result[0])?{24'b0,rdata2[7:0]}:
                  (!alu_result[1]&& alu_result[0])?{16'b0,rdata2[7:0], 8'b0}:
                  ( alu_result[1]&&!alu_result[0])?{ 8'b0,rdata2[7:0],16'b0}:
                  ( alu_result[1]&& alu_result[0])?{rdata2[7:0],24'b0}:0;
//sh_data
assign sh_data = alu_result[1]?{rdata2[15:0],16'b0}:
                 !alu_result[1]?{16'b0,rdata2[15:0]}:0;
//Write_data
assign Write_data = sb?sb_data:sh?sh_data:swl?swl_data:swr?swr_data:rdata2;
//Write_strb[0]:sb?00;sh?0x;swl?xx;swr?00
assign Write_strb[0]=sb?(!alu_result[1]&&!alu_result[0]):
                     sh?(!alu_result[1]):
                     swr?(!alu_result[1]&&!alu_result[0]):
                     swl?((!alu_result[1]&&!alu_result[0])|
                          (!alu_result[1]&& alu_result[0])|
                          ( alu_result[1]&&!alu_result[0])|
                          ( alu_result[1]&& alu_result[0])):1;
//Write_strb[1]:sb?01;sh?0x;swl?01,10,11;swr?00,01
assign Write_strb[1]=sb?(!alu_result[1]&& alu_result[0]):
                     sh?(!alu_result[1]):
                     swl?(alu_result[1] || alu_result[0]):
                     swr?(!alu_result[0]):
                     1;
//Write_strb[2]:sb?10;sh?1x;swl:10,11;swr:00,01,10;
assign Write_strb[2]=sb?( alu_result[1]&&!alu_result[0]):
                     sh?( alu_result[1]):
                     swl?( alu_result[1]):
                     swr?(!( alu_result[1]&& alu_result[0])):
                     1;
//Write_strb[3]:sb?11;sh?1x;swl?11;swr?xx
assign Write_strb[3]=sb?( alu_result[1]& alu_result[0]):
                     sh?( alu_result[1]):
                     swl?( alu_result[1]& alu_result[0]):
                     1;
//module instance-reg_file
assign RF_wen = ((R_C|I_C|Shift|Jal|move_c|Jalr|Load|Lui)&&(current_state==WB))?1:0;
assign RF_waddr = R_Type? rd : (Jal?31:rt );
//RF_wdata--jalr:rd<-PC+8;mov:rd<-rs;jal:PC+8;                        
assign RF_wdata = Load? wdata_res:
                  Shift? Shift_result:
                  (Jalr|Jal)?PC+8:
                  move_c?rdata1:
                  alu_result;
assign raddr1 = rs;
assign raddr2 = Regimm? 5'b0:rt;
reg_file RF(
.clk(clk), 
.rst(rst), 
.waddr(RF_waddr), 
.raddr1(raddr1), 
.raddr2(raddr2), 
.wen(RF_wen), 
.wdata(RF_wdata),
.rdata1(rdata1), 
.rdata2(rdata2)
);

//alu
assign alu_A =  rdata1;
assign alu_B = (R_C|Regimm|I_B) ? rdata2: extend;
//aluop
wire [2:0]  aluop_RC;
wire [2:0]  aluop_Regimm;
wire [2:0]  aluop_IB;
wire [2:0]  aluop_IC;
assign aluop_RC = (R_C && (func[3:2] == 2'b00))?{func[1],2'b10}:
                  (R_C && (func[3:2] == 2'b01))?{func[1],1'b0,func[0]}:
                  {~func[0],2'b11};
assign aluop_Regimm = SLT;
assign aluop_IB = Ib1?SUB:SLT;
assign aluop_IC = (opcode[2:1] == 2'b00)?{opcode[1],2'b10}:
                  (opcode[2] == 1'b1)?{opcode[1],1'b0,opcode[0]}:
                  {~opcode[0],2'b11};

assign aluop = R_C?aluop_RC:
               Regimm?aluop_Regimm:
               I_B?aluop_IB:
               I_C?aluop_IC:
               ADD;
               
//module instance-alu
alu ALU(
.A(alu_A), 
.B(alu_B), 
.ALUop(aluop), 
.Overflow(overflow), 
.CarryOut(carryout), 
.Zero(zero), 
.Result(alu_result)
);

//PC
wire [31:0] PC_4;
wire [31:0] PC_result;
wire [31:0] PC_Branch;
wire [31:0] PC_next;
assign PC_4 = PC_r + 4;
assign PC_result = {PC_4[31:28],Instruction_r[25:0],2'b00};
assign PC_next = Branch?PC_Branch:
		 Jump?PC_result:
                 R_J?rdata1:
		 PC_4;
wire [31:0] PC_B;
assign PC_B={{14{immediate[15]}},immediate[15:0],2'b0};
//PC Adder
alu PC_add(
.A(PC_4), 
.B(PC_B), 
.ALUop(ADD), 
.Overflow(), 
.CarryOut(), 
.Zero(), 
.Result(PC_Branch)
);
//Shifter
wire [31:0] shift_A;
wire [31:0] shift_B;
wire [1:0] shiftop;
wire [31:0] Shift_result;
assign shift_A = rdata2;
assign shift_B = (func[2]==0)?{27'b0,shamt[4:0]}:rdata1;
assign shiftop = func[1:0];
//module instance-shifter
shifter Shifter(
.A(shift_A), 
.B(shift_B), 
.Shiftop(shiftop),
.Result(Shift_result)
);


endmodule

