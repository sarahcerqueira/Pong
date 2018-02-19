// Problema 4 - Sistema Digital
// Módulo LCD
// Camille Jesus, Pedro Gomes e Sarah Pereira
// 15/2/2018

module LCD (
	DataA,
	DataB,
	Result,
	Clock,
	ClockEnable,
	Start,
	Reset,
	Done,
	RegisterSelect,
	ReadWrite,
	OperationEnable,
	DataBus
);

	input [31:0] DataA, DataB;
	input Clock, ClockEnable, Start, Reset;
	output reg [31:0] Result;
	output ReadWrite;
	output reg [7:0] DataBus;
	output reg Done, RegisterSelect, OperationEnable;

	reg [1:0] state;
	reg [15:0] counter;

	assign ReadWrite = 1'b0;
	localparam Idle = 2'b00, Busy = 2'b01, Final = 2'b11;

	always @ (posedge Clock)
	begin

		if (Reset)
			begin
				state <= Idle;
				counter <= 16'd0;
				Result <= 32'd0;
				DataBus <= 8'b0;
				Done <= 1'b0;
				RegisterSelect <= 1'b0;
				OperationEnable <= 1'b1;
			end
		else
			begin

				if (ClockEnable)
					begin
						case (state)
							Idle: 
								begin
									Done <= 1'b0;
									OperationEnable <= 1'b1;

									if (Start)
										begin
											state <= Busy;
											counter <= 16'd0;
											RegisterSelect <= DataA[0];
											DataBus <= DataB[7:0];
										end
								end
							Busy:
								begin

									if (counter < 16'd100000)
										begin
											counter <= counter + 16'd1;
										end
									else
										begin
											state <= Final;
											counter <= 16'd0;
											OperationEnable <= 1'b0;
										end
								end
							Final:
								begin

									if (counter < 16'd100000)
										begin
											counter <= counter + 16'd1;
										end
									else
										begin
											state <= Idle;
											Done <= 1'b1;
											Result <= 32'd1;
										end
								end
						endcase

					end
			end
	end

endmodule