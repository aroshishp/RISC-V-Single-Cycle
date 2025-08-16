module control_unit_main(
    // input zero,
    input [6:0] opcode,
    output branch,
    output MemRead,
    output MemtoReg,
    output [2:0] ALUOp,
    output MemWrite,
    output ALUSrc,
    output RegWrite
);

assign branch = (opcode == 7'b1100011) ? 1'b1 : 1'b0;
assign MemRead = (opcode == 7'b0000011) ? 1'b1 : 1'b0;
assign MemtoReg = (opcode == 7'b0000011) ? 1'b1 : 1'b0;

/*
R type -> to be decoded
I type -> 
ld, sd -> always add
branch -> always sutract
jump -> 
u type -> 

*/

assign ALUOp =  (opcode == 7'b0110011) ? 3'b000 : //R
                (opcode == 7'b0010011) ? 3'b001 : //I
                (opcode == 7'b0000011) ? 3'b010 : //ld
                (opcode == 7'b0100011) ? 3'b011 : //sd
                (opcode == 7'b1100011) ? 3'b100 : //branch
                (opcode == 7'b1101111) ? 3'b101 : //jump
                (opcode == 7'b0110111) ? 3'b110 : //lui, auipc
                (opcode == 7'b1110011) ? 3'b111 : 3'bxxx; //ecall, ebreak


assign MemWrite = (opcode == 7'b0100011) ? 1'b1 : 1'b0;
assign ALUSrc = (opcode == 7'b0010011 || opcode == 7'b0000011 || opcode == 7'b0100011) ? 1'b1 : 1'b0;
assign RegWrite = (opcode == 7'b0100011 || opcode == 7'b1100011 || opcode == 7'b1110011) ? 1'b0 : 1'b1;
endmodule