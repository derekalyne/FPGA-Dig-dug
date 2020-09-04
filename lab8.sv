//-------------------------------------------------------------------------
//      lab8.sv                                                          --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Modified by Po-Han Huang                                         --
//      10/06/2017                                                       --
//                                                                       --
//      Fall 2017 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 8                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module lab8( input               CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
             output logic [6:0]  HEX0, HEX1,
             // VGA Interface 
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             // CY7C67200 Interface
             inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                 OTG_RD_N,     //CY7C67200 Write
                                 OTG_WR_N,     //CY7C67200 Read
                                 OTG_RST_N,    //CY7C67200 Reset
             input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK      //SDRAM Clock
                    );
    
    logic Reset_h, Clk;
    logic [7:0] keycode;
    
    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
    end
    
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;
    
    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h | endgame),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            .from_sw_reset(hpi_reset),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),
                            .OTG_RST_N(OTG_RST_N)
    );
     
    // You need to make sure that the port names here match the ports in Qsys-generated codes.
    lab8_soc nios_system(
						  .clk_clk(Clk),         
						  .reset_reset_n(1'b1),    // Never reset NIOS
						  .sdram_wire_addr(DRAM_ADDR), 
						  .sdram_wire_ba(DRAM_BA),   
						  .sdram_wire_cas_n(DRAM_CAS_N),
						  .sdram_wire_cke(DRAM_CKE),  
						  .sdram_wire_cs_n(DRAM_CS_N), 
						  .sdram_wire_dq(DRAM_DQ),   
						  .sdram_wire_dqm(DRAM_DQM),  
						  .sdram_wire_ras_n(DRAM_RAS_N),
						  .sdram_wire_we_n(DRAM_WE_N), 
						  .sdram_clk_clk(DRAM_CLK),
						  .keycode_export(keycode),  
						  .otg_hpi_address_export(hpi_addr),
						  .otg_hpi_data_in_port(hpi_data_in),
						  .otg_hpi_data_out_port(hpi_data_out),
						  .otg_hpi_cs_export(hpi_cs),
						  .otg_hpi_r_export(hpi_r),
						  .otg_hpi_w_export(hpi_w),
						  .otg_hpi_reset_export(hpi_reset)
	 );
	 
	 /* Useful logic registers for VGA/Simulation interface */
	 logic [9:0] DrawX, DrawY;
	 
	 logic is_ball;  
	 logic [23:0] dug_update [31:0]; 
	 logic [9:0]    Ball_X_Loc;
	 logic [9:0]    Ball_Y_Loc;
	 logic          is_killed; 
	 logic          kill_dug; 
	 
	 logic [9:0]    Rock_X_Loc;
	 logic [9:0]    Rock_Y_Loc; 
	 logic          is_rock;
    logic          Delete_rock1;
	 logic          falling_rock1; 
	 
	 logic [9:0]    Rock2_X_Loc;
	 logic [9:0]    Rock2_Y_Loc; 
	 logic          is_rock2; 
	 logic          Delete_rock2; 
	 logic          falling_rock2; 
	 
	 logic [9:0]    Rock3_X_Loc; 
	 logic [9:0]    Rock3_Y_Loc; 
	 logic          is_rock3; 
	 logic          Delete_rock3; 
	 logic          falling_rock3; 
	 
	 logic [9:0]    Rock4_X_Loc; 
	 logic [9:0]    Rock4_Y_Loc; 
	 logic          is_rock4;
	 logic          Delete_rock4; 
	 logic          falling_rock4; 
	 
	 logic [1:0]    life_state; 
	 logic          one; 
	 logic          two; 
	 
	 logic          endgame;  //resets the game in the case of players loses all lives 
	 logic          endgame_delay; //delay signal needed for resetting dug_states
	 
	 logic          game_state; //used for determining whether the game just began, needed for setting rock location
	 
	 logic [7:0]    last_key_press;
	 logic          pump_enable; 
	 logic          is_pump; 
	 logic [9:0]    Pump_X_Loc;
	 logic [9:0]    Pump_Y_Loc;
	 
	 logic          is_L;
	 logic          is_I; 
	 logic          is_V;
	 logic          is_E; 
	 logic          is_S;  
	 logic [10:0]   addr_lives;
	 logic [7:0]    Lives_data; 
	 
	 logic [9:0]    dig_sum;
	 logic          is_increase_dug_score;
	 
	 logic          is_S_Score;
	 logic          is_C_Score;
	 logic          is_O_Score;
	 logic          is_R_Score;
	 logic          is_E_Score; 
	 logic [10:0]   addr_score;  
	 logic [7:0]    Score_data;
	 
	 logic [3:0]    thousands; 
	 logic [3:0]    hundreads; 
	 logic [3:0]    tens; 
	 logic [3:0]    ones;
	 
	 logic          is_thousands;
	 logic          is_hundreads;
	 logic          is_tens;
	 logic          is_ones; 
	 logic [10:0]   addr_digit;
	 logic [7:0]    Digit_data; 
	 
	 logic [23:0]   dug_states [31:0]; //after tunnels have been placed into game 
	 
	 logic          Enemy_kill_dug;
	 
	 logic [9:0]    Enemy_X_Loc;
	 logic [9:0]    Enemy_Y_Loc; 
	 logic          is_Enemy; 
	 logic          Delete_enemy; 
	 logic          Increment_pumped; 
	 logic [7:0]    pump_sum;
	 logic          Enemy_attacked; 
	 
	 logic [9:0]    Enemy2_X_Loc; 
	 logic [9:0]    Enemy2_Y_Loc;
	 logic          is_Enemy2; 
	 logic          Delete_enemy2; 
	 logic          Increment_pumped2; 
	 logic [7:0]    pump_sum2;
	 logic          Enemy_attacked2; 
	 
	 logic [9:0]    Enemy3_X_Loc;
	 logic [9:0]    Enemy3_Y_Loc;
	 logic          is_Enemy3; 
	 logic          Delete_enemy3;
	 logic          Increment_pumped3; 
	 logic [7:0]    pump_sum3;
	 logic          Enemy_attacked3; 
	 
	 logic [9:0]    Enemy4_X_Loc; 
	 logic [9:0]    Enemy4_Y_Loc;
	 logic 			 is_Enemy4;
	 logic			 Delete_enemy4;
	 logic			 Increment_pumped4;
	 logic [7:0]	 pump_sum4;
	 logic 			 Enemy_attacked4;
	 
	 logic          is_R_Round; 
	 logic          is_O_Round; 
	 logic          is_U_Round; 
	 logic          is_N_Round; 
	 logic          is_D_Round; 
	 logic [10:0]   addr_round;
	 logic [7:0]    Round_data;  
	 
	 // Use PLL to generate the 25MHZ VGA_CLK.
    // You will have to generate it on your own in simulation.
    vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));
    //implements dig dug lives, life counter increments when killed
	 life_counter REMOVE_LIFE(.Clk(Clk), .is_killed(is_killed), .Reset(Reset_h | endgame), .life_state(life_state)); 
	 
	 lives LIVES(.life_state(life_state), .one(one), .two(two));
    // TODO: Fill in the connections for the rest of the modules 
    VGA_controller vga_controller_instance(.*, .Reset(Reset_h));
    // kills dig dug 
	 dug_death DUGKILL(.kill_dug(kill_dug), 
	                   .attack(falling_rock1 | falling_rock2 
										| falling_rock3 | falling_rock4),  
							 .touched_enemy(Enemy_kill_dug), 
							 .is_killed(is_killed)); 
							 
	 dig_score DIGSCORE(.Clk(Clk), 
							  .Reset(Reset_h | endgame), 
							  .is_increase_dug_score(is_increase_dug_score), 
							  .dig_sum(dig_sum));
							  
		 score_board SCOREBOARD(.dig_sum(dig_sum), 
										.thousands(thousands), 
										.hundreads(hundreads), 
										.tens(tens), 
										.ones(ones));
	 
	//ends the game, player has lost 
	 game_over GAMEOVER(.life_state(life_state), .endgame(endgame)); 
	//A small state machine for determining when the game began, used for enabling rock positions instead of reset 
	 start_game STARTGAME(.Clk(Clk), .Reset(Reset_h | endgame), .game_state(game_state));
	 //dig dug pump module, used to kill enemies, press SPACE key to activate, pumps in the direction of last wasd key
	 pump PUMP(.Clk(Clk),
	           .keycode(keycode), 
	           .last_key_press(last_key_press), .DrawX(DrawX), .DrawY(DrawY), 
				  .Ball_X_Loc(Ball_X_Loc), 
				  .Ball_Y_Loc(Ball_Y_Loc),
				  .Pump_X_Loc(Pump_X_Loc), 
				  .Pump_Y_Loc(Pump_Y_Loc),  
				  .pump_enable(pump_enable), 
				  .is_pump(is_pump));
	 // Lives sprite module 			  
	 Lives_sprite LIVESSPRITE(.DrawX(DrawX), .DrawY(DrawY), 
	                          .is_L(is_L), 
	                          .is_I(is_I), 
									  .is_V(is_V), 
									  .is_E(is_E), 
									  .is_S(is_S), 
									  .addr_lives(addr_lives));
	 
	 font_rom FONTROM(.addr(addr_lives), .data(Lives_data));
	 
	 Score_sprite SCORESPRITE(.DrawX(DrawX), .DrawY(DrawY), 
									 .is_S_Score(is_S_Score),
									 .is_C_Score(is_C_Score), 
									 .is_O_Score(is_O_Score),
									 .is_R_Score(is_R_Score),
									 .is_E_Score(is_E_Score),
									 .addr_score(addr_score));
	
	 font_rom SCOREROM(.addr(addr_score), .data(Score_data));
	 
	 Digit_sprites DIGITSPRITS(.DrawX(DrawX), .DrawY(DrawY), 
										.thousands(thousands),
										.hundreads(hundreads),
										.tens(tens),
										.ones(ones),
										.is_thousands(is_thousands),
										.is_hundreads(is_hundreads),
										.is_tens(is_tens),
										.is_ones(is_ones), 
										.addr_digit(addr_digit));
										
	 font_rom DIGITROM(.addr(addr_digit), .data(Digit_data));
	 
	 Round_sprite ROUNDSPRITE(.DrawX(DrawX), .DrawY(DrawY), 
									  .is_R_Round(is_R_Round),
									  .is_O_Round(is_O_Round), 
									  .is_U_Round(is_U_Round),
									  .is_N_Round(is_N_Round),
									  .is_D_Round(is_D_Round),
									  .addr_round(addr_round)); 
									  
	 font_rom ROUNDROM(.addr(addr_round), .data(Round_data)); 
			
    // Which signal should be frame_clk?
    ball ball_instance(.Clk(Clk), .Reset(Reset_h | endgame | game_state), .frame_clk(VGA_VS), .DrawX(DrawX), 
								.DrawY(DrawY), .keycode(keycode),  
								.Rock_X_Loc(Rock_X_Loc), .Rock_Y_Loc(Rock_Y_Loc),
								.Rock2_X_Loc(Rock2_X_Loc), .Rock2_Y_Loc(Rock2_Y_Loc), 
								.Rock3_X_Loc(Rock3_X_Loc), .Rock3_Y_Loc(Rock3_Y_Loc), 
								.Rock4_X_Loc(Rock4_X_Loc), .Rock4_Y_Loc(Rock4_Y_Loc), 
							   .delete_rock(Delete_rock1),
								.delete_rock2(Delete_rock2),
								.delete_rock3(Delete_rock3), 
								.delete_rock4(Delete_rock4),
								.Enemy_X_Loc(Enemy_X_Loc), .Enemy_Y_Loc(Enemy_Y_Loc),
								.Enemy2_X_Loc(Enemy2_X_Loc), .Enemy2_Y_Loc(Enemy2_Y_Loc),
								.Enemy3_X_Loc(Enemy3_X_Loc), .Enemy3_Y_Loc(Enemy3_Y_Loc), 
								.Enemy4_X_Loc(Enemy4_X_Loc), .Enemy4_Y_Loc(Enemy4_Y_Loc),
								.delete_enemy(Delete_enemy),
								.delete_enemy2(Delete_enemy2), 
								.delete_enemy3(Delete_enemy3),
								.delete_enemy4(Delete_enemy4),
								.Enemy_kill_dug(Enemy_kill_dug), 
								.is_killed(is_killed), 
								.is_ball(is_ball),
								.Ball_X_Loc(Ball_X_Loc), .Ball_Y_Loc(Ball_Y_Loc),
								.kill_dug(kill_dug),
								.last_key_press(last_key_press));
    
    color_mapper color_instance(.*, .dug_state(dug_states), 
	                             .is_rock(is_rock), 
										  .is_rock2(is_rock2),
										  .is_rock3(is_rock3),
										  .is_rock4(is_rock4),
										  .Delete_rock4(Delete_rock4), 
										  .Delete_rock3(Delete_rock3), 
										  .Delete_rock2(Delete_rock2), 
	                             .Delete_rock1(Delete_rock1), 
										  .one(one),
										  .two(two),
										  .pump_enable(pump_enable),
										  .is_pump(is_pump),
										  .is_L(is_L), 
										  .is_I(is_I),
										  .is_V(is_V), 
										  .is_E(is_E), 
										  .is_S(is_S),
										  .Lives_data(Lives_data),
										  .is_S_Score(is_S_Score),
										  .is_C_Score(is_C_Score),
										  .is_O_Score(is_O_Score),
										  .is_R_Score(is_R_Score),
										  .is_E_Score(is_E_Score),
										  .Score_data(Score_data),
										  .is_thousands(is_thousands),
										  .is_hundreads(is_hundreads),
										  .is_tens(is_tens),
										  .is_ones(is_ones),
										  .Digit_data(Digit_data),
										  .is_Enemy(is_Enemy),
										  .is_Enemy2(is_Enemy2),
										  .is_Enemy3(is_Enemy3),
										  .is_Enemy4(is_Enemy4),
										  .Delete_enemy(Delete_enemy),
										  .Delete_enemy2(Delete_enemy2),
										  .Delete_enemy3(Delete_enemy3),
										  .Delete_enemy4(Delete_enemy4),
										  .is_R_Round(is_R_Round),
										  .is_O_Round(is_O_Round), 
										  .is_U_Round(is_U_Round),
										  .is_N_Round(is_N_Round),
										  .is_D_Round(is_D_Round),
										  .Round_data(Round_data));
    
	 update_dug_delay UPDATEDELAY(.Clk(Clk), .Reset(Reset_h | endgame), .endgame_delay(endgame_delay)); 
	 // update dug implementation, we added this module 
	 Update_dug_state UPDATE_DUG(.Clk(Clk), .Reset(endgame_delay), .Ball_X_Loc(Ball_X_Loc), 
	 								    .Ball_Y_Loc(Ball_Y_Loc), .update_dug_state(dug_update),
										 .is_increase_dug_score(is_increase_dug_score)); 
	 
	 Tunnels TUNNELS(.Clk(Clk), 
	                 .update_dug_state(dug_update), 
						  .Tunnel_X_Start(10'd5),
						  .Tunnel_Y_Start(10'd5), 
						  .Tunnel_X_Start2(10'd6), 
						  .Tunnel_Y_Start2(10'd17),
						  .Tunnel_X_Start3(10'd25), 
						  .Tunnel_Y_Start3(10'd12),
						  .Tunnel_X_Start4(10'd24),
						  .Tunnel_Y_Start4(10'd3),
						  .dug_state(dug_states));
	 //Rock module, first rock 
	 Rocks ROCK1(.Clk(Clk), .Reset(Reset_h | endgame | game_state), .DrawX(DrawX), .DrawY(DrawY), .frame_clk(VGA_VS), 
					 .Rock_X_Start(10'd56), .Rock_Y_Start(10'd169), .dug_state(dug_states), .is_rock(is_rock), 
					 .Rock_X_Loc(Rock_X_Loc), .Rock_Y_Loc(Rock_Y_Loc),
					 .Delete_rock(Delete_rock1),
					 .falling(falling_rock1));
	 Rocks ROCK2(.Clk(Clk), .Reset(Reset_h | endgame | game_state), .DrawX(DrawX), .DrawY(DrawY), .frame_clk(VGA_VS), 
					 .Rock_X_Start(10'd359), .Rock_Y_Start(10'd183), .dug_state(dug_states), .is_rock(is_rock2),
					 .Rock_X_Loc(Rock2_X_Loc), .Rock_Y_Loc(Rock2_Y_Loc),
					 .Delete_rock(Delete_rock2),
					 .falling(falling_rock2)); 
	 Rocks ROCK3(.Clk(Clk), .Reset(Reset_h | endgame | game_state), .DrawX(DrawX), .DrawY(DrawY), .frame_clk(VGA_VS), 
					 .Rock_X_Start(10'd455), .Rock_Y_Start(10'd296), .dug_state(dug_states), .is_rock(is_rock3), 
					 .Rock_X_Loc(Rock3_X_Loc), .Rock_Y_Loc(Rock3_Y_Loc),
					 .Delete_rock(Delete_rock3),
					 .falling(falling_rock3));
	 Rocks ROCK4(.Clk(Clk), .Reset(Reset_h | endgame | game_state), .DrawX(DrawX), .DrawY(DrawY), .frame_clk(VGA_VS), 
					 .Rock_X_Start(10'd136), .Rock_Y_Start(10'd280), .dug_state(dug_states), .is_rock(is_rock4), 
					 .Rock_X_Loc(Rock4_X_Loc), .Rock_Y_Loc(Rock4_Y_Loc), 
					 .Delete_rock(Delete_rock4), 
					 .falling(falling_rock4)); 
	 
	 Enemy_pump_state ENEMYPUMP1(.Clk(Clk), 
										  .Enemy_attacked(Enemy_attacked | Reset_h | endgame | game_state), 
										  .Increment_pumped(Increment_pumped));
	 
	 Pump_count PUMPCOUNT1(.Clk(Clk), 
								  .Reset(Reset_h | endgame | game_state), 
								  .Increment_pumped(Increment_pumped),
								  .pump_sum(pump_sum));
	 
	 Enemy ENEMY1(.Clk(Clk), .Reset(Reset_h | endgame | game_state), .DrawX(DrawX), .DrawY(DrawY), .frame_clk(VGA_VS), 
					  .Enemy_X_Start(10'd135), .Enemy_Y_Start(10'd375), .dug_state(dug_states), 
					  .Min_X_roaming(10'd102), .Max_X_roaming(10'd169), 
					  .Min_Y_roaming(10'd0), .Max_Y_roaming(10'd0),
					  .hori0_verti1(1'd0), 
					  .Pump_X_Loc(Pump_X_Loc),
					  .Pump_Y_Loc(Pump_Y_Loc),
					  .Pump_enable(pump_enable),
					  .pump_sum(pump_sum),  
					  .is_Enemy(is_Enemy), 
					  .Enemy_X_Loc(Enemy_X_Loc), 
					  .Enemy_Y_Loc(Enemy_Y_Loc), 
					  .Enemy_attacked(Enemy_attacked),
					  .Delete_enemy(Delete_enemy));
					  
	 Enemy_pump_state ENEMYPUMP2(.Clk(Clk), 
										  .Enemy_attacked(Enemy_attacked2 | Reset_h | endgame | game_state), 
										  .Increment_pumped(Increment_pumped2));
	 
	 Pump_count PUMPCOUNT2(.Clk(Clk), 
								  .Reset(Reset_h | endgame | game_state),
								  .Increment_pumped(Increment_pumped2), 
								  .pump_sum(pump_sum2));
								  
	 Enemy ENEMY2(.Clk(Clk), .Reset(Reset_h | endgame | game_state), .DrawX(DrawX), .DrawY(DrawY), .frame_clk(VGA_VS), 
					  .Enemy_X_Start(10'd439), .Enemy_Y_Start(10'd151), .dug_state(dug_states), 
					  .Min_X_roaming(10'd390), .Max_X_roaming(10'd456), 
					  .Min_Y_roaming(10'd0), .Max_Y_roaming(10'd0),
					  .hori0_verti1(1'd0), 
					  .Pump_X_Loc(Pump_X_Loc),
					  .Pump_Y_Loc(Pump_Y_Loc),
					  .Pump_enable(pump_enable),
					  .pump_sum(pump_sum2),  
					  .is_Enemy(is_Enemy2), 
					  .Enemy_X_Loc(Enemy2_X_Loc), 
					  .Enemy_Y_Loc(Enemy2_Y_Loc), 
					  .Enemy_attacked(Enemy_attacked2),
					  .Delete_enemy(Delete_enemy2));
	Enemy_pump_state ENEMYPUMP3(.Clk(Clk), 
										 .Enemy_attacked(Enemy_attacked3 | Reset_h | endgame | game_state),
										 .Increment_pumped(Increment_pumped3));
	Pump_count PUMPCOUNT3(.Clk(Clk), 
								 .Reset(Reset_h | endgame | game_state), 
								 .Increment_pumped(Increment_pumped3), 
								 .pump_sum(pump_sum3));
								 
	Enemy ENEMY3(.Clk(Clk), .Reset(Reset_h | endgame | game_state), .DrawX(DrawX), .DrawY(DrawY), .frame_clk(VGA_VS), 
					  .Enemy_X_Start(10'd87), .Enemy_Y_Start(10'd215), .dug_state(dug_states), 
					  .Min_X_roaming(10'd0), .Max_X_roaming(10'd0), 
					  .Min_Y_roaming(10'd182), .Max_Y_roaming(10'd248),
					  .hori0_verti1(1'b1), 
					  .Pump_X_Loc(Pump_X_Loc),
					  .Pump_Y_Loc(Pump_Y_Loc),
					  .Pump_enable(pump_enable),
					  .pump_sum(pump_sum3),  
					  .is_Enemy(is_Enemy3), 
					  .Enemy_X_Loc(Enemy3_X_Loc), 
					  .Enemy_Y_Loc(Enemy3_Y_Loc), 
					  .Enemy_attacked(Enemy_attacked3),
					  .Delete_enemy(Delete_enemy3));
					  
	Enemy_pump_state ENEMYPUMP4(.Clk(Clk),
										 .Enemy_attacked(Enemy_attacked4 | Reset_h | endgame | game_state), 
										 .Increment_pumped(Increment_pumped4)); 
	
	Pump_count PUMPCOUNT4(.Clk(Clk), 
								 .Reset(Reset_h | endstate | game_state), 
								 .Increment_pumped(Increment_pumped4),
								 .pump_sum(pump_sum4)); 
	Enemy ENEMY4(.Clk(Clk), .Reset(Reset_h | endgame | game_state), .DrawX(DrawX), .DrawY(DrawY), .frame_clk(VGA_VS), 
					  .Enemy_X_Start(10'd407), .Enemy_Y_Start(10'd327), .dug_state(dug_states), 
					  .Min_X_roaming(10'd0), .Max_X_roaming(10'd0), 
					  .Min_Y_roaming(10'd295), .Max_Y_roaming(10'd359),
					  .hori0_verti1(1'b1), 
					  .Pump_X_Loc(Pump_X_Loc),
					  .Pump_Y_Loc(Pump_Y_Loc),
					  .Pump_enable(pump_enable),
					  .pump_sum(pump_sum4),  
					  .is_Enemy(is_Enemy4), 
					  .Enemy_X_Loc(Enemy4_X_Loc), 
					  .Enemy_Y_Loc(Enemy4_Y_Loc), 
					  .Enemy_attacked(Enemy_attacked4),
					  .Delete_enemy(Delete_enemy4));
	
    // Display keycode on hex display
    HexDriver hex_inst_0 (pump_sum[3:0], HEX0);
    HexDriver hex_inst_1 (pump_sum[7:4], HEX1);
    
    /**************************************************************************************
        ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
        Hidden Question #1/2:
        What are the advantages and/or disadvantages of using a USB interface over PS/2 interface to
             connect to the keyboard? List any two.  Give an answer in your Post-Lab.
    **************************************************************************************/
endmodule
