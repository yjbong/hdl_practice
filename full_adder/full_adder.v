module full_adder(input A, input B, input Cin, output S, output Cout);
	wire ha0_S, ha0_C;
	wire ha1_S, ha1_C;

	half_adder ha0(.A(A), .B(B), .S(ha0_S), .C(ha0_C));
	half_adder ha1(.A(ha0_S), .B(Cin), .S(ha1_S), .C(ha1_C));

	assign S = ha1_S;
	or(Cout, ha0_C, ha1_C);
endmodule