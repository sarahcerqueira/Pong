module CI_multiplicacao 
	#( parameter latency =0)

	(
		input clk,    // Clock
		input clk_en, // Clock Enable
		input rst_n,  // Asynchronous reset active low
		input [15:0] dataa,
		input [15:0] datab,
		input start,
		output [31:0] result,
		output done
	);
	
	wire [31:0] sqrt_result;

	multiplicacao mul(
		.clk (clk),    // Clock
		.clk_en (clk_en), // Clock Enable
		.rst_n (rst_n),  // Asynchronous reset active low
		.dataa (dataa),
		.datab (datab),
		.result (sqrt_result)
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
	assign result = sqrt_result;

endmodule