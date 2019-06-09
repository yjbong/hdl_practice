`timescale  1ns/1ps
							
module CoffeeMachine_tb();
	reg CLOCK_50;
	reg [9:0] SW;
	wire [6:0] HEX3_D, HEX1_D, HEX0_D;
	
	parameter clk_period = 20;
	
	CoffeeMachine dut(.CLOCK_50(CLOCK_50),
							.SW		(SW),
							.HEX3_D	(HEX3_D),
							.HEX1_D	(HEX1_D),
							.HEX0_D	(HEX0_D) );

	// reset
	initial
	begin
		SW[9] = 1;
		#(clk_period+3)
		SW[9] = 0;
	end
	
	// clk setting
	always
	begin
		CLOCK_50 = 1;
		forever #(clk_period/2) CLOCK_50 = ~CLOCK_50;
	end
	
	initial
	begin
		SW[4] = 0; SW[3] = 0; SW[2] = 0; SW[1] = 0; SW[0] = 0; #3
		SW[4] = 0; SW[3] = 0; SW[2] = 0; SW[1] = 0; SW[0] = 0; #(clk_period*2)
		SW[4] = 0; SW[3] = 0; SW[2] = 1; SW[1] = 0; SW[0] = 0; #(clk_period*5)	// push SW[2]
		SW[4] = 0; SW[3] = 0; SW[2] = 0; SW[1] = 0; SW[0] = 0; #(clk_period*5)	// release SW[2] (add 1000won at next clk) 
		SW[4] = 0; SW[3] = 0; SW[2] = 0; SW[1] = 1; SW[0] = 0; #(clk_period*3)	// push SW[1]
		SW[4] = 0; SW[3] = 0; SW[2] = 0; SW[1] = 0; SW[0] = 0; #(clk_period*2)	// release SW[1] (add 500won at next clk)
		SW[4] = 0; SW[3] = 0; SW[2] = 0; SW[1] = 0; SW[0] = 1; #(clk_period*3)	// push SW[0]
		SW[4] = 0; SW[3] = 0; SW[2] = 0; SW[1] = 0; SW[0] = 0; #(clk_period*2)	// release SW[0] (add 100won at next clk)
		SW[4] = 0; SW[3] = 0; SW[2] = 0; SW[1] = 1; SW[0] = 0; #(clk_period*3)	// push SW[1]
		SW[4] = 0; SW[3] = 0; SW[2] = 0; SW[1] = 0; SW[0] = 0; #(clk_period*2)	// release SW[1] (add 500won at next clk)
		SW[4] = 0; SW[3] = 1; SW[2] = 0; SW[1] = 0; SW[0] = 0; #(clk_period*3)	// push SW[3]
		SW[4] = 0; SW[3] = 0; SW[2] = 0; SW[1] = 0; SW[0] = 0; #(clk_period*2)	// release SW[3] (spend 600won at next clk)
		SW[4] = 1; SW[3] = 0; SW[2] = 0; SW[1] = 0; SW[0] = 0; #(clk_period*3)	// push SW[4]
		SW[4] = 0; SW[3] = 0; SW[2] = 0; SW[1] = 0; SW[0] = 0; #(clk_period*2)	// release SW[4] (money becomes 0 at next clk)
		SW[4] = 0; SW[3] = 0; SW[2] = 0; SW[1] = 1; SW[0] = 0; #(clk_period*3)	// push SW[1]
		SW[4] = 0; SW[3] = 0; SW[2] = 0; SW[1] = 0; SW[0] = 0; #(clk_period*2)	// release SW[1] (add 500won at next clk)
		SW[4] = 0; SW[3] = 1; SW[2] = 0; SW[1] = 0; SW[0] = 0; #(clk_period*3)	// push SW[3]
		SW[4] = 0; SW[3] = 0; SW[2] = 0; SW[1] = 0; SW[0] = 0; 						// release SW[3] (spend 600won at next clk)
	end
	
endmodule
