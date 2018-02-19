
module pong (
	aleatorio_export,
	ana_barra_d_export,
	ana_barra_e_export,
	barra_d_y_export,
	barra_e_y_export,
	bola_x_export,
	bola_y_export,
	busy_export,
	clk_clk,
	iniciar_export,
	lcd_databus,
	lcd_operationenable,
	lcd_registerselect,
	lcd_readwrite,
	rst_export);	

	input	[7:0]	aleatorio_export;
	input	[7:0]	ana_barra_d_export;
	input	[7:0]	ana_barra_e_export;
	output	[9:0]	barra_d_y_export;
	output	[9:0]	barra_e_y_export;
	output	[9:0]	bola_x_export;
	output	[9:0]	bola_y_export;
	output	[7:0]	busy_export;
	input		clk_clk;
	input	[7:0]	iniciar_export;
	output	[7:0]	lcd_databus;
	output		lcd_operationenable;
	output		lcd_registerselect;
	output		lcd_readwrite;
	input	[7:0]	rst_export;
endmodule
