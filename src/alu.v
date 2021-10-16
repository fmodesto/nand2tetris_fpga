/**
 * The ALU (Arithmetic Logic Unit).
 * Computes one of the following functions:
 * x+y, x-y, y-x, 0, 1, -1, x, y, -x, -y, !x, !y,
 * x+1, y+1, x-1, y-1, x&y, x|y on two 16-bit inputs, 
 * according to 6 input bits denoted zx,nx,zy,ny,f,no.
 */
module ALU (
    x,   // 16-bit input
    y,   // 16-bit input
    zx,  // if (zx == 1) set x = 0        // 16-bit constant
    nx,  // if (nx == 1) set x = !x       // bitwise not
    zy,  // if (zy == 1) set y = 0        // 16-bit constant
    ny,  // if (ny == 1) set y = !y       // bitwise not
    f,   // if (f == 1)  set out = x + y  // integer 2's complement addition
         // if (f == 0)  set out = x & y  // bitwise and
    no,  // if (no == 1) set out = !out   // bitwise not

    out, // 16-bit output
    zr,  // if (out == 0) set zr = 1
    ng   // if (out < 0) set ng = 1
);

    input [15:0] x;
    input [15:0] y;
    input zx, nx, zy, ny, f, no;

    output [15:0] out;
    output zr, ng;

    wire [15:0] xz;
    wire [15:0] xn;

    wire [15:0] yz;
    wire [15:0] yn;

    wire [15:0] of;
    
    assign xz = zx ? 16'b0 : x;
    assign xn = nx ? ~xz : xz;
    
    assign yz = zy ? 16'b0 : y;
    assign yn = ny ? ~yz : yz;
    
    assign of = f ? xn + yn : xn & yn;
    
    assign out = no ? ~of : of;
    assign zr = out == 16'b0;
    assign ng = out[15];

endmodule
