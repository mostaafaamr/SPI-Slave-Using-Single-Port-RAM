module Wrapper(MOSI,MISO,clk,rst_n,SS_n);
input MOSI,clk,rst_n,SS_n;
output MISO;

//internal wires to connect between  SPI and RAM
wire [9:0] RX_DATA_WIRE;
wire [7:0] TX_DATA_WIRE;
wire  RX_VALID_WIRE;
wire  TX_VALID_WIRE;



//Instance
SPI_Slave my_spi(.clk(clk),.rst_n(rst_n),.SS_n(SS_n),
	.MOSI(MOSI),.rx_valid(RX_VALID_WIRE),
		.rx_data(RX_DATA_WIRE),
		.tx_valid(TX_VALID_WIRE),.tx_data(TX_DATA_WIRE),.MISO(MISO));

memory_spi my_ram(.din(RX_DATA_WIRE),.rx_valid(RX_VALID_WIRE),.tx_valid(TX_VALID_WIRE),.dout(TX_DATA_WIRE),.clk(clk),.rst_n(rst_n));
endmodule
