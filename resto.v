`timescale 1 ps/1 ps

module resto (
	input clk,    // Clock
	input clk_en, // Clock Enable
	input rst_n,  // Asynchronous reset active low
	input [31:0] numerator,
	input [31:0] denominator,
	output [31:0] rest
	
);

	assign rest = numerator % denominator;



endmodule