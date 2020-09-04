module Pump_count( input              Clk, 
						input              Reset, 
						input              Increment_pumped,
						output [7:0]       pump_sum);  
		
		always_ff @(posedge Clk) begin 
			if (Reset)
				pump_sum <= 8'd0; 
			else if(Increment_pumped == 1'b1)
				pump_sum <= pump_sum + 1'b1;
		end 
endmodule 