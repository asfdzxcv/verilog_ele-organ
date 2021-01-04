module play(
			input clk,
			input rst,
			output reg[2:0]value_out,
			output reg[1:0]tone_out
			);
/*
*预置音乐的设置与播放
*
*
*/
parameter N=19;
//预置音乐设置
reg[2:0]music_value[N-1:0];
reg[1:0]music_tone[N-1:0];
always@(posedge clk or posedge rst)
begin 
if(rst)begin

	music_value[0]=3'b011;
	music_value[1]=3'b010;
	music_value[2]=3'b011;
	music_value[3]=3'b010;
	music_value[4]=3'b011;
	music_value[5]=3'b111;
	music_value[6]=3'b010;
	music_value[7]=3'b001;
	music_value[8]=3'b110;
	
	music_value[9]=3'b000;
	music_value[10]=3'b001;
	music_value[11]=3'b011;
	music_value[12]=3'b110;
	music_value[13]=3'b111;
	music_value[14]=3'b000;
	
	music_value[15]=3'b011;
	music_value[16]=3'b110;
	music_value[17]=3'b111;
	music_value[18]=3'b001;

	
	music_tone[0]=2'b11;
	music_tone[1]=2'b11;
	music_tone[2]=2'b11;
	music_tone[3]=2'b11;
	music_tone[4]=2'b11;
	music_tone[5]=2'b10;
	music_tone[6]=2'b11;
	music_tone[7]=2'b11;
	music_tone[8]=2'b10;

	music_tone[9]=2'b10;
	music_tone[10]=2'b10;
	music_tone[11]=2'b10;
	music_tone[12]=2'b10;
	music_tone[13]=2'b10;
	music_tone[14]=2'b10;
	music_tone[15]=2'b10;
	music_tone[16]=2'b10;
	music_tone[17]=2'b10;
	music_tone[18]=2'b11;
	end
	else;
end

//预置音乐播放频率设置
reg [17:0]cnt_pre;
always@(posedge clk or posedge rst)
begin
	if(rst)cnt_pre=0;
	else cnt_pre=cnt_pre+1;
end


reg [5:0]cur;

always@(posedge clk or posedge rst)
if(rst)cur=0;
else if(cur==N)cur=0;
else if(cnt_pre==18'h3ffff)
cur=cur+1;
else;

always@(posedge clk or posedge rst)
if(rst)begin
value_out=3'b000;
tone_out=2'b00;
end
else begin
tone_out=music_tone[cur];
value_out=music_value[cur];
end
endmodule