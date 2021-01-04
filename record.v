module record(
				input record,
				input play,
				input [2:0]value_in,
				input [1:0]tone_in,
				output reg[2:0]value_out,
				output reg[1:0]tone_out,
				input clk,
				input rst





				);
parameter N=2;
reg [2:0]value_record[N:0];
reg [1:0]tone_record[N:0];
reg [6:0]num;
wire rise_value;
wire fall_value;
//按键边沿检测			
reg [2:0]value_pre;
reg [2:0]value;
	
wire rise_key;
wire fall_key;
reg key_pre;
reg key;
reg [6:0]valuenum;

always@(posedge clk or posedge rst)
if(rst)begin
	value_pre<=3'b000;
	value<=3'b000;
	end
else begin
	value<=value_in;
	value_pre<=value;
	end
//拨码开关边沿检测	

always@(posedge clk or posedge rst)
if(rst)begin
	key_pre<=0;
	key<=0;
	end
else begin
	key_pre<=key;
	key<=record;
	end


assign rise_key=(~key_pre)&key;
assign fall_key=(~key)&key_pre;

//检测到下降沿时,确定输入音符总量, 存到valuenum中

always@(posedge clk or posedge rst)
if(rst)valuenum=0;
else if(fall_key)valuenum=num;
else;



assign rise_value=(~(|value_pre))&(|value);//上升沿
assign fall_value=(|value_pre)&(~(|value));//下降沿


always@(posedge clk or posedge rst)
if(rst)begin

	num=0;
	end
else if(record)begin
		if(fall_value)num=num+1;
		else if(rise_value)begin
		value_record[num]=value_in;
		tone_record[num]=tone_in;
		end
	end
	else ;
	
//播放录好的音频	
reg [17:0]cnt_pre;
always@(posedge clk or posedge rst)
begin
	if(rst)cnt_pre=0;
	else cnt_pre=cnt_pre+1;
end


reg[6:0]cur;
always@(posedge clk or posedge rst)
if(rst)cur=0;
else if(cur==valuenum)cur=0;
else if(cnt_pre==18'h3ffff)
cur=cur+1;
else;

always@(posedge clk or posedge rst)
if(rst)begin
value_out=3'b000;
tone_out=2'b00;
end
else if(play)begin
value_out=value_record[cur];
tone_out=tone_record[cur];
end
else;
endmodule	