module data_memory(
    input [63:0] address,
    input [63:0] WriteData,
    input zero,
    input MemWrite,
    input MemRead,
    input clk, 
    input rst,

    output [63:0] ReadData
);

reg [63:0] DMEM [1023:0];

assign ReadData = (rst == 1'b1 || MemRead == 1'b0) ? 64'b0 : DMEM[address];

always @(posedge clk) begin
    if (MemWrite) begin
        DMEM[address] <= WriteData;
    end
end
endmodule