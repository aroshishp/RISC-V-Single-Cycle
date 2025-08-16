module control_unit_alu(
    input [2:0] ALUOp,
    input [9:0] funct, //[9:3] funct7, [2:0] funct3
    output [2:0] ALUSrc,
    output sub
);

wire [2:0] funct3 = funct[2:0];
wire [6:0] funct7 = funct[9:3];
/*
sum (add + sub),0
slt,1
and,2
or,3
xor,4
sra,5
sll,6
srl7
*/

assign ALUSrc = (ALUOp == 3'b000) ? //R
                    (
                        (funct3 == 3'b000 && funct7 == 7'b0000000) ? 3'b000 :
                        (funct3 == 3'b000 && funct7 == 7'b0100000) ? 3'b000 :
                        (funct3 == 3'b100 && funct7 == 7'b0000000) ? 3'b100 :
                        (funct3 == 3'b110 && funct7 == 7'b0000000) ? 3'b011 :
                        (funct3 == 3'b111 && funct7 == 7'b0000000) ? 3'b010 :
                        (funct3 == 3'b001 && funct7 == 7'b0000000) ? 3'b110 :
                        (funct3 == 3'b101 && funct7 == 7'b0000000) ? 3'b111 :
                        (funct3 == 3'b101 && funct7 == 7'b0100000) ? 3'b101 :
                        (funct3 == 3'b010 && funct7 == 7'b0000000) ? 3'b001 :
                        (funct3 == 3'b011 && funct7 == 7'b0000000) ? 3'b001 : 3'bxxx;
                    ) :
                (ALUOp == 3'b001) ? //I
                    (
                        (funct3 == 3'b000) ? 3'b000 : //addi
                        (funct3 == 3'b100) ? 3'b100 : //xori
                        (funct3 == 3'b110) ? 3'b011 : //ori
                        (funct3 == 3'b111) ? 3'b010 : //andi
                        (funct3 == 3'b001) ? 3'b110 : //slli
                        (funct3 == 3'b101 && funct7[5] == 1'b0) ? 3'b111 :
                        (funct3 == 3'b101 && funct7[5] == 1'b1) ? 3'b101 : //srli
                        (funct3 == 3'b010) ? 3'b001 : //slti
                        (funct3 == 3'b011) ? 3'b001 : 3'bxxx;
                    ) :
                (ALUOp == 3'b010) ? 3'b000 :
                (ALUOp == 3'b011) ? 3'b000 :
                (ALUOp == 3'b100) ? 3'b000 :
                (ALUOp == 3'b101) ? 3'b000 :
                (ALUOp == 3'b110) ? 3'b000 :
                (ALUOp == 3'b111) ? 3'b000 : 3'bxxx;


///INCOMPLETE 
assign sub = (ALUOp == 3'b000) ? //R
                    (
                        (funct3 == 3'b000 && funct7 == 7'b0000000) ? 3'b000 :
                        (funct3 == 3'b000 && funct7 == 7'b0100000) ? 3'b000 :
                        (funct3 == 3'b100 && funct7 == 7'b0000000) ? 3'b100 :
                        (funct3 == 3'b110 && funct7 == 7'b0000000) ? 3'b011 :
                        (funct3 == 3'b111 && funct7 == 7'b0000000) ? 3'b010 :
                        (funct3 == 3'b001 && funct7 == 7'b0000000) ? 3'b110 :
                        (funct3 == 3'b101 && funct7 == 7'b0000000) ? 3'b111 :
                        (funct3 == 3'b101 && funct7 == 7'b0100000) ? 3'b101 :
                        (funct3 == 3'b010 && funct7 == 7'b0000000) ? 3'b001 :
                        (funct3 == 3'b011 && funct7 == 7'b0000000) ? 3'b001 : 3'bxxx;
                    ) :
                (ALUOp == 3'b001) ? //I
                    (
                        (funct3 == 3'b000) ? 3'b000 : //addi
                        (funct3 == 3'b100) ? 3'b100 : //xori
                        (funct3 == 3'b110) ? 3'b011 : //ori
                        (funct3 == 3'b111) ? 3'b010 : //andi
                        (funct3 == 3'b001) ? 3'b110 : //slli
                        (funct3 == 3'b101 && funct7[5] == 1'b0) ? 3'b111 :
                        (funct3 == 3'b101 && funct7[5] == 1'b1) ? 3'b101 : //srli
                        (funct3 == 3'b010) ? 3'b001 : //slti
                        (funct3 == 3'b011) ? 3'b001 : 3'bxxx;
                    ) :
                (ALUOp == 3'b010) ? 3'b000 :
                (ALUOp == 3'b011) ? 3'b000 :
                (ALUOp == 3'b100) ? 3'b000 :
                (ALUOp == 3'b101) ? 3'b000 :
                (ALUOp == 3'b110) ? 3'b000 :
                (ALUOp == 3'b111) ? 3'b000 : 3'bxxx;
endmodule