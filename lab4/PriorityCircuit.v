module PriorityCircuit(input [9:0] SW, 
                      output reg [6:0] HEX0_D);
							 
reg [3:0] data;
// Setting data from switches' state
always @(*)
	begin
	casez(SW) // ? = don’t care
		10'b1?????????: data = 9;
      10'b01????????: data = 8;
		10'b001???????: data = 7;
      10'b0001??????: data = 6;
      10'b00001?????: data = 5;
      10'b000001????: data = 4;
      10'b0000001???: data = 3;
      10'b00000001??: data = 2;
      10'b000000001?: data = 1;
      10'b0000000001: data = 0;
      default: data = 10;
	endcase
	end

// 7 segment setting
always @(*)
	begin
	case(data)
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
