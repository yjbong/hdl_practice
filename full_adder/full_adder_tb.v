`timescale 100ns/1ns
module full_adder_tb;

reg A, B, Cin;
wire S, Cout;
full_adder uut(A, B, Cin, S, Cout);
initial begin
A = 0; B = 0; Cin = 0; #250;
A = 0; B = 0; Cin = 1; #250;
A = 0; B = 1; Cin = 0; #250;
A = 0; B = 1; Cin = 1; #250;
A = 1; B = 0; Cin = 0; #250;
A = 1; B = 0; Cin = 1; #250;
A = 1; B = 1; Cin = 0; #250;
A = 1; B = 1; Cin = 1; #250;
end

endmodule
