module main(input clk,
			input [7:0]btn,
			input [7:0]key,
			output [7:0]row,
			output [7:0]line_g,
			output [7:0]line_r,
			output beep,
			output [7:0]seg,
			output [7:0]ds
			);
		
wire [7:0]keyPress;


reg [2:0]value;
wire [1:0]tone;
assign tone={key[0],key[1]};
//编码器, 将按转换成1~7的音值
always @(posedge clk or posedge btn[0])
if(btn[0])value=3'b000;
else begin
	case (keyPress)
	8'b00000000:value=3'b000;
	8'b10000000:value=3'b001;
	8'b01000000:value=3'b010;
	8'b00100000:value=3'b011;
	8'b00010000:value=3'b100;
	8'b00001000:value=3'b101;
	8'b00000100:value=3'b110;
	8'b00000010:value=3'b111;
	default:value=3'b000;
	endcase
end

reg [2:0]value_play;
reg [1:0]tone_play;

wire [2:0] value_record;
wire[1:0] tone_record;

wire [2:0]value_preset;
wire[1:0]tone_preset;

//决定播放源:key[5]播放预存音乐,key[3]播放录制音乐
always@(posedge clk or posedge btn[0])
if(btn[0])begin
	value_play=0;
	tone_play=0;
	end
else 
	if(!key[2]);else 
	if(key[5])begin
		value_play=value_preset;
		tone_play=tone_preset;
		end
		else if(key[6])begin
		value_play=value_record;
		tone_play=tone_record;
		end


//调用点阵模块
dotMatrix  u1 (                               
                  .clk(clk),
                  .rst(btn[0]),
                  .value_input(value),
                  .tone_input(tone),
				  .state(key[2]),
				  .value_play(value_play),
				  .tone_play(tone_play),
				  .row(row),
				  .line_g(line_g),
				  .line_r(line_r)
                  );
//蜂鸣器发声模块			  
freq u2(
			.clk(clk),
			.rst(btn[0]),
			.value_input(value),
			.tone_input(tone),
			.value_play(value_play),
			.tone_play(tone_play),
			.state(key[2]),
			.beep(beep)
		);
//按键消抖模块
debounce u3(
				.clk(clk),
				.rst(btn[0]),
				.key_p(keyPress),
				.key_i(btn)
			);
			
//播放预存音乐
play u4(
				.clk(clk),
				.rst(btn[0]),
				.value_out(value_preset),
				.tone_out(tone_preset)
			);
			
//录制/播放模块
record u5(
				.clk(clk),
				.rst(btn[0]),
				.value_in(value),
				.tone_in(tone),
				.play(key[6]),
				.record(key[3]),
				.value_out(value_record),
				.tone_out(tone_record)
			);
		
//数码管显示
tube u6(
			.clk(clk),
			.rst(btn[0]),
			.seg(seg),
			.ds(ds),
			.state(key[2]),
			.value_input(value),
			.value_play(value_play)
		);
endmodule



