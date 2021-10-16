module Register_test;
    parameter SZ = 33; // data length

    reg clk, reset;

    reg [31:0] vectornum, errors;
    reg [SZ-1:0] testvectors[10000:0];
    
    reg [15:0] d;
    reg ld;
    reg [15:0] q_expected;

    wire [15:0] q;
    
    Register sut(d, ld, clk, reset, q);

    always begin
        clk = 1; 
        #10; 
        clk = 0; 
        #10;
    end

    initial begin
        $readmemb("test/register_test.cmp", testvectors);
        vectornum = 0; errors = 0;
        reset = 1; #35; reset = 0;
    end

    // apply test vectors on rising edge of clk
    always @(posedge clk) begin
        #1; {d, ld, q_expected} = testvectors[vectornum];
    end

    // check results on falling edge of clk
    always @(negedge clk) begin
        if (~reset) begin
            if (q !== q_expected)  begin 
                $display("Test: %d", vectornum + 1);
                $display("Error: inputs = %b", {d, ld});
                $display(" outputs = %b (%b exp)", q, q_expected);
                errors = errors + 1;
            end

            vectornum = vectornum + 1;
            if (testvectors[vectornum] === {SZ{1'bx}}) begin 
                $display("Register:\tResults %d tests completed with %d errors", vectornum, errors);
                if (errors) $error("Verification failed");
                $finish; // End simulation 
            end
        end
    end
endmodule