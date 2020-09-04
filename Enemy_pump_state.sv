module  Enemy_pump_state(input    Clk, 
								 input    Enemy_attacked,
								 output   Increment_pumped);
								 
								 
	enum logic [1:0] {Before_Pump, 
							Pump,
							After_Pump} State, Next_State; 
	
	always_ff@(posedge Clk) 
	begin 
			if(Enemy_attacked)
				State = Before_Pump; 
			else 
				State = Next_State;	
	end 
		
	always_comb 
	begin 
		Next_State = State; 
		unique case(State)
			Before_Pump:
				Next_State <= Pump; 
			Pump:
				Next_State <= After_Pump; 
			After_Pump:;
		endcase
		
		case(State)
			Before_Pump: 
				Increment_pumped = 1'b0; 
			Pump:
				Increment_pumped = 1'b1;
			After_Pump:
				Increment_pumped = 1'b0; 
		endcase
				
	end 
endmodule 