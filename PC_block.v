module PC_block(
    input [63:0] PC_NEXT,
    input clk,
    input rst,
    output reg [63:0] PC
);

always @(posedge clk) begin
    if (rst) begin
        PC <= 64'b0;
    end else begin
        PC <= PC_NEXT;
    end
end

endmodule