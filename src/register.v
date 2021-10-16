/**
 * 16-bit register:
 */
 module Register(
     d,
     ld,    // if (load[t] == 1)  out[t+1] = in[t]
     clk,
     reset,
     q);
    
    input [15:0] d;
    input ld, clk, reset;
    
    output reg [15:0] q;
    
    always @ (posedge clk, posedge reset) begin
        if (reset)
            q <= 0;
        else if (ld)
            q <= d;
    end
endmodule
