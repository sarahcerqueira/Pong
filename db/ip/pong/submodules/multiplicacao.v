`timescale 1 ps/1 ps

module multiplicacao (
	input clk,    // Clock
	input clk_en, // Clock Enable
	input rst_n,  // Asynchronous reset active low
	input [15:0] dataa,
	input [15:0] datab,
	output [31:0] result
	
);

	assign result = dataa * datab;


endmodule