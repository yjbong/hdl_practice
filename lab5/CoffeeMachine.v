`timescale  1ns/1ps

module CoffeeMachine(input CLOCK_50, input [9:0] SW,
							output reg [6:0] HEX3_D, output reg [6:0] HEX1_D, output reg [6:0] HEX0_D);
	
	// money에 대한 state
	reg [5:0] curMoney; // 입력을 받기 전 액수 (100원 단위)
	reg [5:0] nxtMoney; // 입력을 받은 후 액수 (100원 단위)
	reg [5:0] tmp;
	reg [5:0] tmpMoney;
	
	// SW[0]에 대한 state
	reg [1:0] curSW0State;
	reg [1:0] nxtSW0State;
	
	// SW[1]에 대한 state
	reg [1:0] curSW1State;
	reg [1:0] nxtSW1State;
	
	// SW[2]에 대한 state
	reg [1:0] curSW2State;
	reg [1:0] nxtSW2State;

	// SW[3]에 대한 state
	reg [1:0] curSW3State;
	reg [1:0] nxtSW3State;

	// SW[4]에 대한 state
	reg [1:0] curSW4State;
	reg [1:0] nxtSW4State;
	
	parameter S0 = 2'b00; // 스위치가 low로 유지 상태
	parameter S1 = 2'b01; // 스위치가 low->high로 바뀐 상태 (active)
	parameter S2 = 2'b10; // 스위치가 high로 유지 상태

	// state register
	always @(posedge SW[9], posedge CLOCK_50)
	begin
		if(SW[9])	curMoney <= 0;	// reset = SW[9]
		else			curMoney <= nxtMoney;
		
		if(SW[9])	curSW0State <= S0;
		else			curSW0State <= nxtSW0State;
		
		if(SW[9])	curSW1State <= S0;
		else			curSW1State <= nxtSW1State;
		
		if(SW[9])	curSW2State <= S0;
		else			curSW2State <= nxtSW2State;
		
		if(SW[9])	curSW3State <= S0;
		else			curSW3State <= nxtSW3State;
		
		if(SW[9])	curSW4State <= S0;
		else			curSW4State <= nxtSW4State;
	end

	// next state logic
	always @(*)
	begin
		// add money
		tmpMoney = 6'b000000;
		if(curSW0State == S1) tmpMoney = curMoney+6'b000001;
		else if(curSW1State == S1) tmpMoney = curMoney+6'b000101;
		else if(curSW2State == S1) tmpMoney = curMoney+6'b001010;
		else if(curSW3State == S1)
		begin
			if(curMoney >= 6'b000110) tmpMoney = curMoney-6'b000110;
			else tmpMoney = curMoney;
		end
		else if(curSW4State == S1) tmpMoney = 6'b000000;
		else tmpMoney = curMoney;
		
		// money가 20을 넘은 경우 20으로 맞춰줌
		if(tmpMoney > 6'b010100) nxtMoney = 6'b010100;
		else nxtMoney = tmpMoney;
	end
	
	always @(*)
	begin
		// Next SW[0] state
		case(curSW0State)
			S0: if(SW[0])	nxtSW0State = S1;
				 else			nxtSW0State = S0;
			S1: nxtSW0State = S2;
			S2: if(~SW[0]) nxtSW0State = S0;
				 else 		nxtSW0State = S2;
			default:	nxtSW0State = S0;
		endcase
		
		// Next SW[1] state
		case(curSW1State)
			S0: if(SW[1])	nxtSW1State = S1;
				 else			nxtSW1State = S0;
			S1: nxtSW1State = S2;
			S2: if(~SW[1]) nxtSW1State = S0;
				 else 		nxtSW1State = S2;
			default:	nxtSW1State = S0;
		endcase
		
		// Next SW[2] state
		case(curSW2State)
			S0: if(SW[2])	nxtSW2State = S1;
				 else			nxtSW2State = S0;
			S1: nxtSW2State = S2;
			S2: if(~SW[2]) nxtSW2State = S0;
				 else 		nxtSW2State = S2;
			default:	nxtSW2State = S0;
		endcase
		
		// Next SW[3] state
		case(curSW3State)
			S0: if(SW[3])	nxtSW3State = S1;
				 else			nxtSW3State = S0;
			S1: nxtSW3State = S2;
			S2: if(~SW[3]) nxtSW3State = S0;
				 else 		nxtSW3State = S2;
			default:	nxtSW3State = S0;
		endcase
		
		// Next SW[4] state
		case(curSW4State)
			S0: if(SW[4])	nxtSW4State = S1;
				 else			nxtSW4State = S0;
			S1: nxtSW4State = S2;
			S2: if(~SW[4]) nxtSW4State = S0;
				 else 		nxtSW4State = S2;
			default:	nxtSW4State = S0;
		endcase
	end
	
	// output logic for HEX3_D (# of dispensable coffee)
	always @(*)
	begin
								           // gfe_dcba
		if(curMoney >= 6'b010010) HEX3_D = ~7'b100_1111; // HEX3_D displays 3.
		else if(curMoney >= 6'b001100) HEX3_D = ~7'b101_1011; // HEX3_D displays 2.
		else if(curMoney >= 6'b000110) HEX3_D = ~7'b000_0110; // HEX3_D displays 1.	
		else HEX3_D = ~7'b011_1111; // HEX3_D displays 0.		
	end
	
	// output logic for HEX1_D, HEX0_D (Amount of money)
	always @(*)
	begin
		if(curMoney >= 6'b010100)
		begin
			tmp = curMoney-6'b010100;
			HEX1_D = ~7'b101_1011; // HEX1_D displays 2.
		end
			
		else if(curMoney >= 6'b001010)
		begin
			tmp = curMoney-6'b001010;
			HEX1_D = ~7'b000_0110; // HEX1_D displays 1.
		end
		
		else
		begin
			tmp = curMoney;
			HEX1_D = ~7'b011_1111; // HEX1_D displays 0.
		end
		
		case(tmp)
			//              gfe_dcba
			0: HEX0_D = ~7'b011_1111;
			1: HEX0_D = ~7'b000_0110;
			2: HEX0_D = ~7'b101_1011;
			3: HEX0_D = ~7'b100_1111;
			4: HEX0_D = ~7'b110_0110;
			5: HEX0_D = ~7'b110_1101;
			6: HEX0_D = ~7'b111_1101;
			7: HEX0_D = ~7'b000_0111;
			8: HEX0_D = ~7'b111_1111;
			9: HEX0_D = ~7'b110_1111;
			default: HEX0_D = ~7'b000_0000; // required
		endcase
	
	end
	
endmodule
