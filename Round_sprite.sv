module Round_sprite(input [9:0]		DrawX, 
						  input [9:0]     DrawY, 
						  output 			is_R_Round,
						  output          is_O_Round, 
						  output          is_U_Round, 
						  output          is_N_Round, 
						  output          is_D_Round, 
						  output [10:0] 	addr_round); 
		always_comb begin 
			if((DrawX >= 10'd527) && (DrawX < 10'd535)
				&& (DrawY >= 10'd192) && (DrawY < 10'd208)) begin 
					is_R_Round = 1'b1; 
					is_O_Round = 1'b0; 
					is_U_Round = 1'b0; 
					is_N_Round = 1'b0; 
					is_D_Round = 1'b0; 
					addr_round = (DrawY - 10'd192 + 16*'h52);
			end 
			else if((DrawX >= 10'd535) && (DrawX < 10'd543)
				&& (DrawY >= 10'd192) && (DrawY < 10'd208)) begin 
					is_R_Round = 1'b0; 
					is_O_Round = 1'b1; 
					is_U_Round = 1'b0; 
					is_N_Round = 1'b0; 
					is_D_Round = 1'b0; 
					addr_round = (DrawY - 10'd192 + 16*'h4f); 
			end 
			else if((DrawX >= 10'd543) && (DrawX < 10'd551)
				&& (DrawY >= 10'd192) && (DrawY < 10'd208)) begin 
					is_R_Round = 1'b0; 
					is_O_Round = 1'b0; 
					is_U_Round = 1'b1; 
					is_N_Round = 1'b0; 
					is_D_Round = 1'b0; 
					addr_round = (DrawY - 10'd192 + 16*'h55);
			end 
			else if((DrawX >= 10'd551) && (DrawX < 10'd559)
				&& (DrawY >= 10'd192) && (DrawY < 10'd208)) begin 
					is_R_Round = 1'b0; 
					is_O_Round = 1'b0; 
					is_U_Round = 1'b0; 
					is_N_Round = 1'b1; 
					is_D_Round = 1'b0; 
					addr_round = (DrawY - 10'd192 + 16*'h4e); 
			end 
			else if((DrawX >= 10'd559) && (DrawX < 10'd567)
				&& (DrawY >= 10'd192) && (DrawY < 10'd208)) begin 
					is_R_Round = 1'b0; 
					is_O_Round = 1'b0; 
					is_U_Round = 1'b0; 
					is_N_Round = 1'b0; 
					is_D_Round = 1'b1; 
					addr_round = (DrawY - 10'd192 + 16*'h44); 
			end 
			else begin 
					is_R_Round = 1'b0; 
					is_O_Round = 1'b0; 
					is_U_Round = 1'b0; 
					is_N_Round = 1'b0; 
					is_D_Round = 1'b0; 
					addr_round = (DrawY - 10'd192); 
			end 
		end 
endmodule 