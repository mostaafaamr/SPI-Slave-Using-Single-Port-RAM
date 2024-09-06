module SPI_Slave(clk,rst_n,SS_n,MOSI,tx_valid,tx_data,MISO,rx_valid,rx_data);
input clk,rst_n,SS_n,MOSI,tx_valid;
input [7:0] tx_data;
output reg MISO,rx_valid;
output reg[9:0] rx_data;

//States
parameter[2:0] IDLE=3'b000; 
parameter[2:0] CHK_CMD=3'b001;
parameter[2:0] READ_ADDR=3'b010;
parameter[2:0] READ_DATA=3'b011;
parameter[2:0] WRITE=3'b100;

integer k,g;
reg check_read;
reg check_cmd;
reg [3:0] count=0;
reg [2:0] count_2=0;
reg [2:0]cs,ns;
reg[7:0] tx_buffer;

always @(*)begin
	case(cs)

    IDLE:
    begin 
    if(~SS_n) 
    	ns=CHK_CMD;
    else ns=IDLE;
    end

    CHK_CMD:
    begin
    if(SS_n==0&&check_cmd==0)
    	ns=WRITE;
      else if(SS_n==0&&check_cmd==1&&check_read==0)
    	ns=READ_ADDR;
      else if(SS_n==0&&check_cmd==1&&check_read==1)
    	ns=READ_DATA;
    	else if(SS_n) ns=IDLE;
    	//else ns=CHK_CMD;
    end

    WRITE:
    begin
    if(SS_n==0)
    	ns=WRITE;
    else ns=IDLE;
    end

    READ_DATA:
    begin
    if(SS_n==0)
    	ns=READ_DATA;
    else ns=IDLE;
    end

    READ_ADDR:
    begin
    if(SS_n==0)
    	ns=READ_ADDR;
    else ns=IDLE;	
    end

    default: ns = IDLE;
	endcase
end

always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		cs<=IDLE;
	end
	else begin
		cs<=ns;
	end
end

always @(posedge clk) begin
	
	if(cs==IDLE) begin
		rx_data<=0;
		rx_valid<=0;
		MISO<=0;
		count<=0;
		check_cmd<=0;
		//check_read<=0;
	end	


	else if(cs==CHK_CMD) begin
		check_cmd<=MOSI;
        //check_read<=1;
	end


	else if(cs==WRITE) begin

		if(count<10) begin
			rx_data<={rx_data[8:0],MOSI};
			count<=count+1;
		end

		else begin
			count<=0;
			rx_valid<=1;
			check_read<=0;
		end

	end	


	else if(cs==READ_ADDR) begin
	g=1;
		if(check_read==0) begin
			/*if(count==0) begin
				rx_data[9]<=1;	
			end

			else if(count==1) begin
				rx_data[8]<=0;	
			end*/

			//else 
			if(count<10) begin
				rx_data<={rx_data[8:0],MOSI};
				count<=count+1;
			end
			else begin
				count<=0;
				check_read<=1;
				rx_valid<=1;
			end

		end	 
		
	end
	

	else if(cs==READ_DATA) begin

		if(check_read==1) begin
		k=1;
			/*if(count==0) begin
				rx_data[9]<=1;	
			end

			else if(count==1) begin
				rx_data[8]<=1;	
			end*/

			//else 
			if(count<10) begin
				rx_data<={rx_data[8:0],MOSI};
				count<=count+1;
			end
			else begin
				///////count<=0;
				check_read<=0;
				rx_valid<=1;
			end

		end
		//removed else	 
		 else if(tx_valid) begin
		        tx_buffer<=tx_data;
			if(count<8) begin
				//MISO<=tx_data[7-count];
				MISO<=tx_buffer[7];
	  			tx_buffer<={tx_buffer[6:0],1'b0};
				rx_valid <= 0;
				count<=count+1;
			end
			else begin
				///////count<=0;
			end

		end

	end



end

endmodule
