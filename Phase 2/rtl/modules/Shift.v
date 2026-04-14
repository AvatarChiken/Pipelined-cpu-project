module Shift (
 input wire [63:0] in,
 output wire [63:0] out,
 begin
    out <= in << 1; // Shift left by 1 bit
 end     
);
    
endmodule