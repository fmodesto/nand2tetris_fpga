module ALU_test;
    parameter SZ = 56; // data length

    reg clk, reset;

    reg [31:0] vectornum, errors;
    reg [SZ-1:0] testvectors[10000:0];
    
    reg [15:0] x;
    reg [15:0] y;
    reg zx, nx, zy, ny, f, no;
    reg [15:0] out_expected;
    reg zr_expected, ng_expected;

    wire [15:0] out;
    wire zr, ng;

    ALU sut(x, y, zx, nx, zy, ny, f, no, out, zr, ng);

    always begin
        clk = 1; 
        #10; 
        clk = 0; 
        #10;
    end

    initial begin
        $readmemb("test/alu_test.cmp", testvectors);
        vectornum = 0; errors = 0;
        reset = 1; #35; reset = 0;
    end

    // apply test vectors on rising edge of clk
    always @(posedge clk) begin
        #1; {x, y, zx, nx, zy, ny, f, no, out_expected, zr_expected, ng_expected} = testvectors[vectornum];
    end

    // check results on falling edge of clk
    always @(negedge clk) begin
        if (~reset) begin
            if ({out, zr, ng} !== {out_expected, zr_expected, ng_expected})  begin 
                $display("Test: %d", vectornum);
                $display("Error: inputs = %b", {x, y, zx, nx, zy, ny, f, no});
                $display(" outputs = %b (%b exp)", {out, zr, ng}, {out_expected, zr_expected, ng_expected});
                errors = errors + 1;
            end

            vectornum = vectornum + 1;
            if (testvectors[vectornum] === {SZ{1'bx}}) begin 
                $display("ALU:\t\tResults %d tests completed with %d errors", vectornum, errors);
                if (errors) $error("Verification failed");
                $finish; // End simulation 
            end
        end
    end
endmodule
