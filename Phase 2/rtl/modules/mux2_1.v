module mux2_1(out, A1, A2, Select);

output out;
input A1, A2, Select;
wire T1, T2, Select_bar;
    
and (T1, A2, Select), (T2, A1, Select_bar);
not (Select_bar, Select);
or (out, T1, T2);

endmodule