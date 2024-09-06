module SPI_RAM_tb();
reg  MOSI,clk,rst_n,SS_n;
wire MISO;

integer i=0;

//clock generation
initial begin
	clk=0;
	forever
	#1 clk=~clk;
end

//initialzion
Wrapper my_wrapper(MOSI,MISO,clk,rst_n,SS_n);

//chech
initial begin
	//test operation
	//$readmemh("RAM.dat",my_wrapper.my_ram.Memory_SPI);

	rst_n=0;
	SS_n=1;
	#10

	rst_n=1;
	#10

	SS_n=0;
	#2

	//test operation address
	MOSI=0;// Write ( check_cmd bit)
	#2
	MOSI=0;
	#2
    MOSI=0; // Write address
    #2

	for(i=0;i<8;i=i+1) begin // address = 1111_1111
	MOSI=1;
		#2;
	end//for loop
    SS_n=1;
    #2

//test Write data
    SS_n=0;
    #2
	MOSI=0;// Write ( check_cmd bit)
	#2
	MOSI=0;
	#2
    MOSI=1; // Write Data
    #2

	for(i=0;i<8;i=i+1) begin // Data = 1111_1111
	MOSI=1;
		#2;
	end//for loop
    SS_n=1;
    #2

    //test Read Adrress
    SS_n=0;
    //#2
	MOSI=1;// Write ( check_cmd bit)
	#2
	MOSI=1;
	#2
    MOSI=0; // Read Address
    #2

	for(i=0;i<8;i=i+1) begin // Data = 1111_1111
	MOSI=1;
		#2;
	end//for loop
    SS_n=1;
    #2

    //test Read data
    SS_n=0;
    #2
	MOSI=1;// Write ( check_cmd bit)
	#2
	MOSI=1;
	#2
    MOSI=1; // Read Data
    #2

	for(i=0;i<8;i=i+1) begin // Data = 1111_1111  // here data is not important
	MOSI=1;
		#2;
	end//for loop
    #20
    SS_n=1;
    #2
$stop;
end//initial end

endmodule