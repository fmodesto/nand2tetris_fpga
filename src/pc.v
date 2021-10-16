/**
 * A 16-bit counter with load and reset control bits.
 */
module PC (
    in,
    inc,    // if (inc[t] == 1)   out[t+1] = out[t] + 1  (integer addition)
    ld,     // if (load[t] == 1)  out[t+1] = in[t]
    clk,    // Clock
    reset,  // if (reset == 1) out = 0

    out
);

    input [15:0] in;
    input inc, ld, clk, reset;
    
    output [15:0] out;
    
    reg [15:0] out;
    
    always @ (posedge clk, posedge reset) begin
        if (reset)
            out <= 0;
        else if (ld)
            out <= in[15:0];
        else if (inc)
            out <= out + 16'd1;
   end
    
endmodule
