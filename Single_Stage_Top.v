`include "register_file.v"
`include "instruction_memory.v"
`include "data_memory.v"
`include "ALU.v"
`include "control_unit_alu.v"
`include "control_unit_main.v"
`include "PC_block.v"
`include "Mux.v"
`include "PC_Adder.v"
`include "Imm_Gen.v"

module Single_Stage_Top(
    input clk,
    input rst
);

//LEFT TO RIGHT

wire [63:0] PC_NEXT;
wire [63:0] PC_CURR;

PC_block PC_block (
    .clk(clk),
    .rst(rst),
    .PC_NEXT(PC_NEXT),
    .PC(PC_CURR)
);

initial begin
    $monitor("Time: %0t | PC_CURR: %h | PC_NEXT: %h", $time, PC_CURR, PC_NEXT);
end

wire [63:0] PC_NEXT_REG;

PC_Adder PC_Adder_Regular(
    .a(PC_CURR),
    .b(64'd4),
    .c(PC_NEXT_REG)
);

wire [31:0] INSTRUCTION_BUS;

instruction_memory instruction_memory(
    .PC(PC_CURR),
    .rst(rst),
    .instruction(INSTRUCTION_BUS)
);

wire Branch;
wire MemRead;
wire MemtoReg;
wire [2:0] ALUOp;
wire MemWrite;
wire ALUSrc;
wire RegWrite;
wire [1:0] Imm_Src;

control_unit_main control_unit_main(
    .opcode(INSTRUCTION_BUS[6:0]),
    .Branch(Branch),
    .MemRead(MemRead),
    .MemtoReg(MemtoReg),
    .ALUOp(ALUOp),
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
    .Imm_Src(Imm_Src)
);

wire [63:0] WRITE_DATA;
wire [63:0] READ_DATA1;
wire [63:0] READ_DATA2;

register_file register_file(
    .ReadReg1(INSTRUCTION_BUS[19:15]),
    .ReadReg2(INSTRUCTION_BUS[24:20]),
    .WriteReg(INSTRUCTION_BUS[11:7]),
    .WriteData(WRITE_DATA),
    .clk(clk),
    .rst(rst),
    .RegWrite(RegWrite),
    .ReadData1(READ_DATA1),
    .ReadData2(READ_DATA2)
);

wire [63:0] IMM_OUT;

Imm_Gen Imm_Gen(
    .imm_in(INSTRUCTION_BUS),
    .imm_src(Imm_Src),
    .imm_out(IMM_OUT)
);

wire [2:0] ALUCONTROL;
wire SUB;

control_unit_alu control_unit_alu(
    .ALUOp(ALUOp),
    .funct({INSTRUCTION_BUS[30], INSTRUCTION_BUS[14:12]}),
    .ALUControl(ALUCONTROL),
    .sub(SUB)
);

wire [63:0] ALU_B;

Mux ALU_Mux(
    .a(READ_DATA2),
    .b(IMM_OUT),
    .s(ALUSrc),
    .c(ALU_B)
);

initial begin
    $monitor("Time: %0t | READ_DATA1: %h | READ_DATA2: %h | ALU_B: %h | ALUSrc: %b", $time, READ_DATA1, READ_DATA2, ALU_B, ALUSrc);
    $monitor("Time: %0t | PC_CURR: %h | PC_NEXT: %h", $time, PC_CURR, PC_NEXT);
end

wire [63:0] ALU_OUT;
wire ALU_ZERO;
wire ALU_CARRY;

ALU ALU(
    .A(READ_DATA1),
    .B(ALU_B),
    .ALU_Sel(ALUCONTROL),
    .sub(SUB),
    .ALU_Out(ALU_OUT),
    .Carry_out(ALU_CARRY),
    .zero(ALU_ZERO)
);

wire [63:0] PC_NEXT_IMM;

PC_Adder PC_Adder_Imm(
    .a(PC_CURR),
    .b(IMM_OUT),
    .c(PC_NEXT_IMM)
);

wire [63:0] DMEM_READ_DATA;

data_memory data_memory(
    .address(ALU_OUT),
    .WriteData(READ_DATA2),
    .zero(ALU_ZERO),
    .MemWrite(MemWrite),
    .MemRead(MemRead),
    .clk(clk),
    .rst(rst),
    .ReadData(DMEM_READ_DATA)
);

Mux PC_Update_Mux(
    .a(PC_NEXT_REG),
    .b(PC_NEXT_IMM),
    .s(Branch & ALU_ZERO),
    // .s(1'b0),
    .c(PC_NEXT)
);

Mux Write_Back_Mux(
    .a(ALU_OUT),
    .b(DMEM_READ_DATA),
    .s(MemtoReg),
    .c(WRITE_DATA)
);

endmodule