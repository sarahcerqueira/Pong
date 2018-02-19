// Problema 4 - Sistema Digital
// Módulo RandomNumber
// Camille Jesus, Pedro Gomes e Sarah Pereira
// 15/2/2018

module RandomNumber (
	Clock,
	Reset,
	RanNum
);

	input Clock;
	input Reset;
	output [7:0] RanNum;

	reg [7:0] counter;

	always @ (posedge Clock)
		begin

			if (Reset)
				begin
					counter <= 8'd0;
				end
			else
				begin
					counter <= counter + 8'd1;
				end
		end

	xor (RanNum[0], counter[3], counter[0]);
	xor (RanNum[1], counter[5], RanNum[0]);

endmodule
