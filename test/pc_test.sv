module PC_test;
    parameter SZ = 35; // data length

    reg clk, reset;

    reg [31:0] vectornum, errors;
    reg [SZ-1:0] testvectors[10000:0];
    
    reg [15:0] in;
    reg inc, ld, reset_test;
    reg [15:0] out_expected;
    
    wire [15:0] out;
    
    PC sut(in, inc, ld, clk, reset | reset_test, out);

    always begin
        clk = 1; 
        #10; 
        clk = 0; 
        #10;
    end

    initial begin
        $readmemb("test/pc_test.cmp", testvectors);
        vectornum = 0; errors = 0;
        reset = 1; #35; reset = 0;
    end

    // apply test vectors on rising edge of clk
    always @(posedge clk) begin
        #1; {in, reset_test, ld, inc, out_expected} = testvectors[vectornum];
    end

    // check results on falling edge of clk
    always @(negedge clk) begin
        if (~reset) begin
            if (out !== out_expected)  begin 
                $display("Test: %d", vectornum + 1);
                $display("Error: inputs = %b", {in, reset_test, ld, inc});
                $display(" outputs = %b (%b exp)", out, out_expected);
                errors = errors + 1;
            end

            vectornum = vectornum + 1;
            if (testvectors[vectornum] === {SZ{1'bx}}) begin 
                $display("PC:\t\tResults %d tests completed with %d errors", vectornum, errors);
                if (errors) $error("Verification failed");
                $finish; // End simulation 
            end
        end
    end
endmodule