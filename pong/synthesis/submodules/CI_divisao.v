module CI_divisao
	#( parameter latency =0)

	(

		input clk,    // Clock
		input clk_en, // Clock Enable
		input rst_n,  // Asynchronous reset active low
		input [31:0] numerator,
		input [31:0] denominator,
		input start,
		output [31:0] quotient,
		output done
		
	);
	
	wire [31:0] sqrt_quotient;

	divisao div(
		.clk (clk),    // Clock
		.clk_en (clk_en), // Clock Enable
		.rst_n (rst_n),  // Asynchronous reset active low
		.numerator (numerator),
		.denominator (denominator),
		.quotient (sqrt_quotient)
		);


	reg [4:0] state;

	always @(posedge clk) begin 
		if(rst_n) begin
			state <= 0;
		end else if(start & clk_en) begin
			state <= latency;
		end else if(clk_en) begin
			state <= state -1;
		end else begin
			state <= 0;
		end
	end

	assign done = (state ==1) & clk_en;
	assign quotient = sqrt_quotient;

endmodule