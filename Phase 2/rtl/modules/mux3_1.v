module mux3_1(out, A1, A2, A3, Select1, Select0);

output out;
input A1, A2, A3, Select1, Select0;
wire T1, T2, T3, Select1_bar, Select0_bar;

not (Select1_bar, Select1);
not (Select0_bar, Select0);

and (T1, A1, Select1_bar, Select0_bar), (T2, A2, Select1_bar, Select0), (T3, A3, Select1, Select0_bar);
or (out, T1, T2, T3);

endmodule