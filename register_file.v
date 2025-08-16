module register_file(
    input [4:0] ReadReg1, //src reg
    input [4:0] ReadReg2, //src reg
    input [4:0] WriteReg, //destination reg
    input [63:0] WriteData, //data to write
    input clk,
    input rst,
    input RegWrite, //control signal

    output [63:0] ReadData1,
    output [63:0] ReadData2
);

reg [63:0] registers [31:0];

assign registers[0] = 64'b0;

assign ReadData1 = (rst == 1'b1 || ReadReg1 == 5'b0) ? 64'b0 : registers[ReadReg1];
assign ReadData2 = (rst == 1'b1 || ReadReg2 == 5'b0) ? 64'b0 : registers[ReadReg2];

always @(posedge clk) begin
    if (RegWrite && WriteReg != 5'b0) begin
        registers[WriteReg] <= WriteData;
    end
end
endmodule