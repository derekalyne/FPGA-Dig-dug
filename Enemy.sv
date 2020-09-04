module Enemy (input        Clk, 
				  input        Reset, 
				  input [9:0]  DrawX, 
				  input [9:0]  DrawY, 
				  input        frame_clk, 
				  input [9:0]  Enemy_X_Start, 
				  input [9:0]  Enemy_Y_Start, 
				  input [23:0] dug_state[31:0],
				  input [9:0]  Min_X_roaming, 
				  input [9:0]  Max_X_roaming,
				  input [9:0]  Min_Y_roaming,
				  input [9:0]  Max_Y_roaming, 
				  input        hori0_verti1, 
				  input [9:0]  Pump_X_Loc,
				  input [9:0]  Pump_Y_Loc,
				  input        Pump_enable,
				  input [7:0]  pump_sum, 
				  output       is_Enemy, 
				  output [9:0] Enemy_X_Loc,
				  output [9:0] Enemy_Y_Loc, 
				  output       Enemy_attacked,
				  output       Delete_enemy);
				  
				  
		parameter [9:0] Enemy_Step = 10'd1;
				  
		logic [9:0] Enemy_Y_Pos, Enemy_Y_Pos_in; 
		logic [9:0] Enemy_Y_Motion, Enemy_Y_Motion_in;
		logic [9:0] Enemy_X_Pos, Enemy_X_Pos_in; 
		logic [9:0] Enemy_X_Motion, Enemy_X_Motion_in; 
		
		logic Delete_enemy_in; 
		
		logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end 
	 
	 always_ff @ (posedge Clk) begin 
		if(Reset) begin 
				Enemy_Y_Pos <= Enemy_Y_Start; 
				Enemy_X_Pos <= Enemy_X_Start;
				Enemy_Y_Motion <= Enemy_Y_Motion_in;
				if(hori0_verti1 == 1'b0) begin 
					Enemy_X_Motion <= (~(Enemy_Step) + 1'b1);
					Enemy_Y_Motion <= 1'd0;
				end 
				else begin 
					Enemy_X_Motion <= 1'd0; 
					Enemy_Y_Motion <= Enemy_Step;
				end 
				Delete_enemy <= 1'b0;
		end 
		else begin 
				Enemy_Y_Pos <= Enemy_Y_Pos_in;
				Enemy_X_Pos <= Enemy_X_Pos_in; 
				
				Enemy_Y_Loc <= Enemy_Y_Pos;
				Enemy_X_Loc <= Enemy_X_Pos; 
				
				Enemy_X_Motion <= Enemy_X_Motion_in; 
				Enemy_Y_Motion <= Enemy_Y_Motion_in; 
				
				Delete_enemy <= Delete_enemy_in; 
		end 
	 end 
	 always_comb begin 
			if(pump_sum == 8'd5)
				Delete_enemy_in = 1'b1;
			else 
				Delete_enemy_in = Delete_enemy; 
	 end 
	 always_comb begin 
			Enemy_Y_Pos_in = Enemy_Y_Pos; 
			Enemy_X_Pos_in = Enemy_X_Pos;
			Enemy_Y_Motion_in = Enemy_Y_Motion;
			Enemy_X_Motion_in = Enemy_X_Motion; 
			
			if(frame_clk_rising_edge) begin
				Enemy_X_Motion_in = Enemy_X_Motion;
				Enemy_Y_Motion_in = Enemy_Y_Motion; 
				 	
					if (hori0_verti1 == 1'b0) begin 
						if ( Enemy_X_Pos + Enemy_Step >= Max_X_roaming )  // Ball is at right edge, BOUNCE! :D
							Enemy_X_Motion_in = (~(Enemy_Step) + 1'b1); // 2's complement.
						else if ( Enemy_X_Pos <= Min_X_roaming + Enemy_Step )  // Ball is at left edge, BOUNCE! :D
							Enemy_X_Motion_in = Enemy_Step;
					end 
					else begin 
						if( Enemy_Y_Pos + Enemy_Step >= Max_Y_roaming )  // Ball is at the bottom edge, BOUNCE!
							Enemy_Y_Motion_in = (~(Enemy_Step) + 1'b1);
						else if ( Enemy_Y_Pos <= Min_Y_roaming + Enemy_Step)  // Ball is at the top edge, BOUNCE!
							Enemy_Y_Motion_in = Enemy_Step;
					end 
				if(pump_sum >= 8'd2)begin 
					Enemy_X_Motion_in = 10'd0;
					Enemy_Y_Motion_in = 10'd0;
				end 
				
				Enemy_X_Pos_in = Enemy_X_Pos + Enemy_X_Motion;
				Enemy_Y_Pos_in = Enemy_Y_Pos + Enemy_Y_Motion;
			end 
	 end 
	 
	 always_comb begin
        if ((DrawX >= (Enemy_X_Pos-10'd8)) && (DrawX <= (Enemy_X_Pos+10'd8)) && 
		       (DrawY >= (Enemy_Y_Pos-10'd8)) && (DrawY <= (Enemy_Y_Pos+10'd8)) ) 
            is_Enemy = 1'b1;
        else
            is_Enemy = 1'b0;
    end
	 always_comb begin 
			if(Pump_enable == 1'b1) begin 
				if ((Enemy_X_Pos + 10'd8 >= Pump_X_Loc-10'd8) && (Enemy_X_Pos <= (Pump_X_Loc + 10'd8))
					&& (Enemy_Y_Pos  >= (Pump_Y_Loc-10'd8)) && (Enemy_Y_Pos <=(Pump_Y_Loc+10'd8)))
						Enemy_attacked = 1'b1; 
				else if ( (Enemy_X_Pos-10'd8 <= Pump_X_Loc+10'd8) && (Enemy_X_Pos >= (Pump_X_Loc - 10'd8))
					&& (Enemy_Y_Pos >= (Pump_Y_Loc-10'd8)) && (Enemy_Y_Pos <=(Pump_Y_Loc+10'd8)))
						Enemy_attacked = 1'b1;		
				else if ( (Enemy_X_Pos+10'd8 >= Pump_X_Loc-10'd8) && (Enemy_X_Pos-10'd8 <= Pump_X_Loc +10'd8)
					&& (Enemy_Y_Pos+10'd8 >= Pump_Y_Loc-10'd8) && (Enemy_Y_Pos <= Pump_Y_Loc+10'd8))
						Enemy_attacked = 1'b1; 	
				else 
						Enemy_attacked = 1'b0;
			end 
			else 
				 Enemy_attacked = 1'b0;
	 end 
endmodule 