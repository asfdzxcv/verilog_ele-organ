module tube(
			input [2:0]value_input,
			input clk,
			input rst,
			output reg[7:0]ds,
			output reg[7:0]seg,
			input state,
			input [2:0]value_play
			);
reg [2:0]value;
always@(posedge clk or posedge rst)
if(rst)value=3'b000;
else if(state)value=value_play;
else value=value_input;

task shownum;
	input [2:0]value;
	output [7:0]seg;
	begin
	case (value)
	3'b000:seg=8'b00000000;
	3'b001:seg=8'b00000110;
	3'b010:seg=8'b01011011;
	3'b011:seg=8'b01001111;
	3'b100:seg=8'b01100110;
	3'b101:seg=8'b01101101;
	3'b110:seg=8'b01111101;
	3'b111:seg=8'b00100111;
	default: seg=8'b00000000;
	endcase
	end
endtask

reg [2:0]curtube;
always@(posedge rst or posedge clk)
if(rst)curtube=3'b000;
else curtube=curtube+1;

always@(posedge clk or posedge rst)
if(rst)seg=8'b0;
else shownum(value,seg);

always@(posedge clk or posedge rst)
if(rst)ds=8'b1;
else if(value-1'b1==curtube)ds[curtube]=0;
else ds[curtube]=1'b1;

endmodule