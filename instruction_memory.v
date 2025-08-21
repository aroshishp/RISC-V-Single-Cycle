module instruction_memory(
    input [63:0] PC,
    input rst,
    output [31:0] instruction
);

reg [31:0] IMEM [1023:0];

assign instruction = (rst == 1'b1) ? 32'h00000000 : IMEM[PC[63:2]];

initial begin
    IMEM[0] = 32'hFFC4A303;
end
endmodule