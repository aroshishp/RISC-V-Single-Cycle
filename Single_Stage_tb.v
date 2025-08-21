module Single_Stage_tb();

    reg clk = 1'b1;
    reg rst;

    Single_Stage_Top Single_Stage_Top(
        .clk(clk),
        .rst(rst)
    );

    initial begin
        $dumpfile("SS.vcd");
        $dumpvars(0, Single_Stage_Top);
    end

    always begin
        clk = ~clk;
        #50;
    end

    initial begin
        rst = 1'b1;
        #150;

        rst = 1'b0;
        #500;
        $finish;
    end
endmodule