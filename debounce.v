module debounce(
				input clk,
				input rst,
				input[7:0] key_i,
				output reg[7:0]key_p
				);
reg[14:0]cnt;
reg state;
reg [7:0]p;
reg [7:0]p_pre;
always@(posedge clk or posedge rst)
if(rst)begin
p<=8'b0;
p_pre<=8'b0;
end
else
begin
p<=key_i;
p_pre<=p;
end
always@(posedge clk or posedge rst)
begin
	if(rst)state<=0;
	else begin
	if(p!=p_pre)
	state<=1;
	else state<=0;
	end
end

always@(posedge clk or posedge rst)
begin
	if(rst)begin
	cnt=0;
	end
	else begin
	if(state)
	cnt=0;
	else cnt=cnt+1;
	end
end

always@(posedge clk or posedge rst)
begin 
	if(rst)begin
	key_p=8'b0;
	end
	else if(cnt==15'h7fff)
	key_p=key_i;
	else key_p=key_p;
end
endmodule