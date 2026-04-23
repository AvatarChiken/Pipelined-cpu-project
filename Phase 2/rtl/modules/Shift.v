module Shift (
   input wire [63:0] in,
   output wire [63:0] out
);

assign out = in << 1;

endmodule