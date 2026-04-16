module pc (
  
  input [31:0] PC_in,
  input clk,
  input reset,
  input stall, 
  output reg [31:0] PC_out);
  
  always @(posedge clk or posedge reset)
    begin
      if (reset==1'b1)
        begin        
          PC_out = 32'd0;
        end
      else if (stall == 1'b0) 
        begin 
          PC_out = PC_in;
        end
    end
endmodule
