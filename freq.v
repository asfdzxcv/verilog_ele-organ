module freq(input clk,
			input rst,
			input [2:0]value_input,//输入的音符
			input [1:0]tone_input,//输入的音阶
			input state,//模式控制,1使用自动播放的数据源,0使用输入的数据源
			input [2:0]value_play,//自动播放的音符
			input [1:0]tone_play,//自动播放的音阶
			output reg beep		
			);
reg[12:0]uplimit;//计数器上限
reg[12:0]counter;//计数器



reg [2:0]value;//真正使用的音符
reg[1:0]tone;

//根据state控制数据源的选择
always@(posedge clk or posedge rst)
if(rst)begin
value=3'b0;
tone=2'b0;
end
else if(state)begin
value=value_play;
tone=tone_play;
end
else begin
value=value_input;
tone=tone_input;
end

//分频操作
always@(posedge clk or posedge rst)
if(rst)begin
	uplimit=0;
	counter=0;
	beep=0;
end
else begin
	case(value)//根据输入value来控制高音分频的系数M
	3'b001:uplimit=13'd956;
	3'b010:uplimit=13'd851;
	3'b011:uplimit=13'd758;
	3'b100:uplimit=13'd716;
	3'b101:uplimit=13'd638;
	3'b110:uplimit=13'd568;
	3'b111:uplimit=13'd506;
	default:uplimit=12'd0;
	endcase
	if(value==3'b000)beep=0;
	else begin
		if(tone==2'b11);
		else begin
			if(tone!=2'b00)uplimit=uplimit+uplimit;//中音频率为高音一半, 故直接使计数器上限乘2
			else begin
			//低音频率为高音频率四分之一, 可以直接使计数器上限乘4, 但误差也是高音的4倍, 因此这里再进行一次计算并赋值, 减小音乐失真
			case(value)
				3'b001:uplimit=12'd3822;
				3'b010:uplimit=12'd3405;
				3'b011:uplimit=12'd3034;
				3'b100:uplimit=12'd2863;
				3'b101:uplimit=12'd2551;
				3'b110:uplimit=12'd2273;
				3'b111:uplimit=12'd2025;
				default:uplimit=12'd0;
			endcase
			
			//uplimit=uplimit+uplimit+uplimit+uplimit;
			end
		end
	end
	if (counter==uplimit)begin//检测到达分频上限,计数器置零,输出反转
	counter=0;
	beep=~beep;
	end
	else counter=counter+1;
end


endmodule