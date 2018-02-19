`include "sicro.v"
`include "AD.v"
`include "RandomNumber.v"



module pong_t(Clock, HSync, VSync, R, G, B, Reset_n, ADC_OUT, ADC_CNVST, ADC_CS_N, 
ADC_REFSEL, ADC_SCLK, ADC_SD, ADC_UB, ADC_SEL, iniciar, lcd_databus,
lcd_operationenable,lcd_registerselect,lcd_readwrite);


//INPUTS
input Clock;
input Reset_n; 					//Resete para o conversor AD
input [1:0] ADC_OUT;				//AD
input iniciar;     

//OUTPUTS
output HSync;
output VSync;
output [3:0] R;
output [3:0] G;
output [3:0] B;

output ADC_CNVST;			//AD
output ADC_CS_N;			//AD
output ADC_REFSEL;		//AD
output ADC_SCLK;			//AD
output ADC_SD;				//AD
output ADC_UB;				//AD
output ADC_SEL;			//AD

output [7:0] lcd_databus;         
output lcd_operationenable;
output lcd_registerselect;
output lcd_readwrite;

wire [7:0]DATA_AD0;	//AD
wire [7:0]DATA_AD1;	//AD

wire BUSY;				//AD
wire [9:0]bola_x;
wire [9:0]bola_y;
wire [9:0]barra_d_y;
wire [9:0]barra_e_y;
wire [7:0]RAnNum;

reg reset;

always @(posedge Clock)
begin
	 reset <= ~Reset_n;
	 
end


pong u0 (RAnNum, DATA_AD0, DATA_AD1, barra_d_y,barra_e_y, bola_x, bola_y, BUSY, Clock, iniciar,lcd_databus,
lcd_operationenable,lcd_registerselect,lcd_readwrite, Reset_n);


AD converso_ad (reset, Clock, ADC_OUT, ADC_CNVST, ADC_CS_N, ADC_REFSEL, ADC_SCLK, ADC_SD, ADC_UB, ADC_SEL, BUSY,
DATA_AD0, DATA_AD1);

sicro tela (Clock, HSync, VSync, R, G, B, bola_x, bola_y, barra_e_y, barra_d_y);


RandomNumber rand (Clock, reset, RanNum);


endmodule