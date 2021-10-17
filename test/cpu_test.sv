module CPU_test;
    parameter SZ = 98; // data length

    reg clk, reset;

    reg [31:0] vectornum, errors;
    reg [SZ-1:0] testvectors[10000:0];

    reg [15:0] instruction;
    reg [15:0] inM;
    reg reset_test;

    reg [15:0] outM_expected;
    reg writeM_expected;
    reg [15:0] addressM_expected;
    reg [15:0] pc_expected;
    reg [15:0] dreg_expected;

    wire [15:0] outM;
    wire writeM;
    wire [15:0] addressM;
    wire [15:0] pc;
    wire [15:0] dreg;

    CPU sut(inM, instruction, clk, reset | reset_test, outM, writeM, addressM, pc, dreg);

    always begin
        clk = 1;
        #10;
        clk = 0;
        #10;
    end

    initial begin
        $readmemb("test/cpu_test.cmp", testvectors);
        vectornum = 0; errors = 0;
        reset = 1; #35; reset = 0;
    end

    // apply test vectors on rising edge of clk
    always @(posedge clk) begin
        #1; {inM, instruction, reset_test, outM_expected, writeM_expected, addressM_expected, pc_expected, dreg_expected} = testvectors[vectornum];
    end

    // check results on falling edge of clk
    always @(negedge clk) begin
        if (~reset) begin
            if ({outM, writeM, addressM, pc, dreg} != {outM_expected, writeM_expected, addressM_expected, pc_expected, dreg_expected})  begin
                $display("Test: %d", vectornum + 1);
                $display("Error: inM = %b instruction = %b reset = %b (%b)", inM, instruction, reset_test, {outM, writeM, addressM, pc, dreg} == {outM_expected, writeM_expected, addressM_expected, pc_expected, dreg_expected});
                $display(" A =        %d (%d exp)", addressM, addressM_expected);
                $display(" D =        %d (%d exp)", dreg, dreg_expected);
                $display(" PC =       %d (%d exp)", pc, pc_expected);
                $display(" outM =     %d (%d exp)", outM, outM_expected);
                $display(" writeM =   %b (%b exp)", writeM, writeM_expected);
                errors = errors + 1;
            end

            vectornum = vectornum + 1;
            if (testvectors[vectornum] === {SZ{1'bx}}) begin
                $display("CPU:\t\tResults %d tests completed with %d errors", vectornum, errors);
                if (errors) $error("Verification failed");
                $finish; // End simulation
            end
        end
    end
endmodule
