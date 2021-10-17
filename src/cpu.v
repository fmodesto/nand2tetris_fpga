/**
 * The Hack CPU (Central Processing unit), consisting of an ALU,
 * two registers named A and D, and a program counter named PC.
 * The CPU is designed to fetch and execute instructions written in
 * the Hack machine language. In particular, functions as follows:
 * Executes the inputted instruction according to the Hack machine
 * language specification. The D and A in the language specification
 * refer to CPU-resident registers, while M refers to the external
 * memory location addressed by A, i.e. to Memory[A]. The inM input
 * holds the value of this location. If the current instruction needs
 * to write a value to M, the value is placed in outM, the address
 * of the target location is placed in the addressM output, and the
 * writeM control bit is asserted. (When writeM==0, any value may
 * appear in outM). The outM and writeM outputs are combinational:
 * they are affected instantaneously by the execution of the current
 * instruction. The addressM and pc outputs are clocked: although they
 * are affected by the execution of the current instruction, they commit
 * to their new values only in the next time step. If reset==1 then the
 * CPU jumps to address 0 (i.e. pc is set to 0 in next time step) rather
 * than to the address resulting from executing the current instruction.
 */
module CPU(
    inM,         // M value input  (M = contents of RAM[A])
    instruction, // Instruction for execution
    clk,         // Clock
    reset,       // Signals whether to re-start the current
                 // program (reset==1) or continue executing
                 // the current program (reset==0).

    outM,        // M value output
    writeM,      // Write to M?
    addressM,    // Address in data memory (of M)
    pc,          // address of next instruction

    dreg);       // D output

    input [15:0] instruction;
    input [15:0] inM;
    input clk;
    input reset;

    output [15:0] outM;
    output writeM;

    output[15:0] addressM;
    output[15:0] pc;
    output[15:0] dreg;

    wire [15:0] aOut;
    wire [15:0] dOut;
    wire [15:0] aluOut;
    wire ng, zr, ps;
    wire ldPC;

    wire op, a, c1, c2, c3, c4, c5, c6, d1, d2, d3, j1, j2, j3;

    assign {op, a, c1, c2, c3, c4, c5, c6, d1, d2, d3, j1, j2, j3} = { instruction[15], instruction[12:0] };

    assign ps = !ng & !zr;

    assign ldPC = op & j1 & ng
                | op & j2 & zr
                | op & j3 & ps;

    Register uRA(
        .d      ( op ? aluOut : instruction ),
        .ld     ( !op | op & d1 ),
        .clk    ( clk ),
        .reset  ( reset ),
        .q      ( aOut )
    );

    Register uRD(
        .d      ( aluOut ),
        .ld     ( op & d2 ),
        .clk    ( clk ),
        .reset  ( reset ),
        .q      ( dOut )
    );

    ALU uALU(
        .x      ( dOut ),
        .y      ( a ? inM : aOut ),
        .zx     ( c1 ),
        .nx     ( c2 ),
        .zy     ( c3 ),
        .ny     ( c4 ),
        .f      ( c5 ),
        .no     ( c6 ),
        .out    ( aluOut ),
        .zr     ( zr ),
        .ng     ( ng )
    );

    PC uPC(
        .in     ( aOut ),
        .inc    ( 1'b1 ),
        .ld     ( ldPC ),
        .clk    ( clk ),
        .reset  ( reset ),
        .out    ( pc )
    );

    assign outM = aluOut;
    assign writeM = op & d3 & !reset;
    assign addressM = aOut;
    assign dreg = dOut;

endmodule
