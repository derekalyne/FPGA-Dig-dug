module dug_death(input kill_dug, 
                input attack,
					 input touched_enemy, 
					 output is_killed);
		always_comb 
		begin
			if((kill_dug == 1'b1 && attack == 1'b1) || (touched_enemy == 1'b1))
				is_killed = 1'b1;
			else 
				is_killed = 1'b0; 
		end	
endmodule 