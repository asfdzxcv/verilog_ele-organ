module dotMatrix(input clk,
				input rst,
				input[2:0] value_input,//哆瑞咪发嗦啦西,001为哆, 没有000
				input[1:0] tone_input,//00为低音,10为中音,11为高音
				input state,
				input[2:0]value_play,
				input[1:0]tone_play,
				output reg[7:0] row,//点阵行
				output reg[7:0] line_r,//点阵列 红色
				output reg[7:0] line_g//点阵列 绿色
				);
reg[2:0]curRow;
reg [2:0]value;
reg [1:0]tone;

always@(posedge clk or posedge rst)
if(rst)begin
	value=3'b000;
	tone=2'b00;
	end
else if(state)begin
	value=value_play;
	tone=tone_play;
	end
	else begin
	value=value_input;
	tone=tone_input;
	end

always@(posedge clk or posedge rst)
if(rst) curRow<=3'b001;
else if(curRow==7)curRow<=1;
		else curRow<=curRow+1;

task shine;
	output reg[7:0]r;
	output reg[7:0]g;
	output reg[7:0]row;
	input [1:0]tone;
	input [2:0]rowin;
	input [2:0]value;
	reg [7:0]temp;
	begin
	case (rowin)//根据value控制哪些灯会亮
	3'b001:{row,temp}={8'b11111110,8'b11111110};
	3'b010:{row,temp}={8'b11111101,8'b01111110};
	3'b011:{row,temp}={8'b11111011,8'b00111110};
	3'b100:{row,temp}={8'b11110111,8'b00011110};
	3'b101:{row,temp}={8'b11101111,8'b00001110};
	3'b110:{row,temp}={8'b11011111,8'b00000110};
	3'b111:{row,temp}={8'b10111111,8'b00000010};
	default:{row,temp}={8'b10000000,8'b11111110};
	endcase

	case(value)
	3'b001:temp[7] =0;
	3'b010:temp[6] =0;
	3'b011:temp[5] =0;
	3'b100:temp[4] =0;
	3'b101:temp[3] =0;
	3'b110:temp[2] =0;
	3'b111:temp[1] =0;
	
	endcase
	
	if(tone==2'b00)begin//根据tone控制颜色
		g=temp;
		r=0;
		end
		else if(tone==2'b11)begin
			g=temp;
			r=temp;
			end
			else begin
				g=0;
				r=temp;
				end
	end
endtask


always@(posedge clk or posedge rst)
	if(rst)begin
		row=8'b11111111;
		line_r=8'b00000000;
		line_g=8'b00000000;
	end
	else shine(line_r,line_g,row,tone,curRow,value);


	
		
endmodule