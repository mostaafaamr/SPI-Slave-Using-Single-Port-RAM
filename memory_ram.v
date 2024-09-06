module memory_spi(
input clk,rst_n,rx_valid, //1 bit
input [9:0] din,          //10 bits
output reg tx_valid,          //1 bit
output reg[7:0] dout      //8 bits
);
//Memory 
parameter MEM_DEPTH=256;
parameter ADDR_SIZE=8;
reg [ADDR_SIZE-1:0] Memory_SPI [MEM_DEPTH-1:0];

//Read Write Addresses
reg[ADDR_SIZE-1:0] Read_ADDR;
reg[ADDR_SIZE-1:0] Write_ADDR;

//temp to initialzie memory
reg temp_word=1'b0;

//Read Write Operation according to the most 2 bits of din : din[9],din[8]
integer i;
always @(posedge clk or negedge rst_n)begin
	if(~rst_n)begin //if rst_n is active low then the output dout=0 and the memory registers are all filled with zeroes
		for(i=0;i<MEM_DEPTH;i=i+1)begin
			Memory_SPI[i]<=temp_word;
		end
		dout<='b0;
		tx_valid<=0;
    end
    else begin
    	   /*First check the rx_valid to accept din*/
    	   if(rx_valid)begin
    		     if(din[9:8]==2'b00)  Write_ADDR<=din[7:0];// Hold din[7:0] as a write address
    		     else if(din[9:8]==2'b01) Memory_SPI[Write_ADDR]<=din[7:0]; // Write din[7:0] in the memory with the address held previosuly 
    		     else if(din[9:8]==2'b10)  Read_ADDR<=din[7:0];// Hold din[7:0] internally  as a read address
    	   end

            /*Now if the 2 most bits of din are not 00,01,10 , then they must be 11 , so this os the case where you output the stored data in the memory
            on the dout,but first you must check that tx_valid is high to be able to read the stored data*/
    	    if(din[9:8]==2'b11)begin
    		      tx_valid<=1'b1;
    		      dout<=Memory_SPI[Read_ADDR];
    	    end
    	    else begin
    	    	tx_valid<=0;
    	    end
    end

end

endmodule