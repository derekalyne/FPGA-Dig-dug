module Tunnels(input                Clk,
					input  [23:0]        update_dug_state[31:0],
					input  [9:0]         Tunnel_X_Start,
					input  [9:0]         Tunnel_Y_Start, 
					input  [9:0]         Tunnel_X_Start2, 
					input  [9:0]         Tunnel_Y_Start2, 
					input  [9:0]         Tunnel_X_Start3, 
					input  [9:0]         Tunnel_Y_Start3, 
					input  [9:0]         Tunnel_X_Start4, 
					input  [9:0]         Tunnel_Y_Start4, 
					output  [23:0]       dug_state[31:0]); 
		logic [23:0] dug_state_in [31:0];  
		always_comb begin 
			for(int y=0; y<24; y++) begin 
				for(int x=0; x<32; x++) begin 
					dug_state[x][y] = dug_state_in[x][y]; 
				end 
			end 
		end 
		always_ff @(posedge Clk) begin 
			for(int y=0; y<24; y++) begin 
				for(int x=0; x<32; x++) begin 
						dug_state_in[x][y] <= update_dug_state[x][y];
				end 
			end 
						dug_state_in[Tunnel_X_Start][Tunnel_Y_Start] <= 1'b1; //column 1 
	
						dug_state_in[Tunnel_X_Start][Tunnel_Y_Start+1] <= 1'b1;
		
						dug_state_in[Tunnel_X_Start][Tunnel_Y_Start+2] <= 1'b1;

						dug_state_in[Tunnel_X_Start][Tunnel_Y_Start+3] <= 1'b1;
	
						dug_state_in[Tunnel_X_Start][Tunnel_Y_Start+4] <= 1'b1; 
					
						dug_state_in[Tunnel_X_Start2][Tunnel_Y_Start2] <= 1'b1;//row1
			
						dug_state_in[Tunnel_X_Start2+1][Tunnel_Y_Start2] <= 1'b1;
					
						dug_state_in[Tunnel_X_Start2+2][Tunnel_Y_Start2] <= 1'b1;
		
						dug_state_in[Tunnel_X_Start2+3][Tunnel_Y_Start2] <= 1'b1;
		
						dug_state_in[Tunnel_X_Start2+4][Tunnel_Y_Start2] <= 1'b1;
			
						dug_state_in[Tunnel_X_Start3][Tunnel_Y_Start3] <= 1'b1; //column2

						dug_state_in[Tunnel_X_Start3][Tunnel_Y_Start3+1] <=1'b1;
			
						dug_state_in[Tunnel_X_Start3][Tunnel_Y_Start3+2] <=1'b1;
			
						dug_state_in[Tunnel_X_Start3][Tunnel_Y_Start3+3] <=1'b1;
			
						dug_state_in[Tunnel_X_Start3][Tunnel_Y_Start3+4] <= 1'b1;
		
						dug_state_in[Tunnel_X_Start4][Tunnel_Y_Start4] <=1'b1; //row2
		
						dug_state_in[Tunnel_X_Start4+1][Tunnel_Y_Start4] <=1'b1;
			
						dug_state_in[Tunnel_X_Start4+2][Tunnel_Y_Start4] <=1'b1;
	
						dug_state_in[Tunnel_X_Start4+3][Tunnel_Y_Start4] <=1'b1;
			
						dug_state_in[Tunnel_X_Start4+4][Tunnel_Y_Start4] <=1'b1;
						
						dug_state_in[15][9] <=1'b1;
						
						dug_state_in[16][9] <=1'b1;
						
						dug_state_in[17][9] <=1'b1; 
						
						dug_state_in[16][8] <= 1'b1;
						dug_state_in[16][7] <= 1'b1;
						dug_state_in[16][6] <= 1'b1;
						dug_state_in[16][5] <= 1'b1;
						dug_state_in[16][4] <= 1'b1;
						dug_state_in[16][3] <= 1'b1;
						dug_state_in[16][2] <= 1'b1;
						dug_state_in[16][1] <= 1'b1;
						dug_state_in[16][0] <= 1'b1;
		end 
endmodule 