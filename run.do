vlib work

vlog SPI_RAM_tb.v memory_ram.v Wrapper.v SPI_Slave.v  +cover -covercells

vsim -voptargs=+acc work.SPI_RAM_tb    -cover

add wave -position insertpoint  \
sim:/SPI_RAM_tb/clk \
sim:/SPI_RAM_tb/rst_n \
sim:/SPI_RAM_tb/SS_n \
sim:/SPI_RAM_tb/MOSI \
sim:/SPI_RAM_tb/my_wrapper/RX_VALID_WIRE \
sim:/SPI_RAM_tb/my_wrapper/RX_DATA_WIRE \
sim:/SPI_RAM_tb/my_wrapper/my_ram/Write_ADDR \
sim:/SPI_RAM_tb/my_wrapper/my_ram/Memory_SPI[255] \
sim:/SPI_RAM_tb/my_wrapper/my_spi/cs \
sim:/SPI_RAM_tb/MISO \
sim:/SPI_RAM_tb/my_wrapper/TX_VALID_WIRE \
sim:/SPI_RAM_tb/my_wrapper/TX_DATA_WIRE \
sim:/SPI_RAM_tb/my_wrapper/my_ram/Read_ADDR \
sim:/SPI_RAM_tb/i \
sim:/SPI_RAM_tb/my_wrapper/my_spi/count \
sim:/SPI_RAM_tb/my_wrapper/my_spi/check_cmd \
sim:/SPI_RAM_tb/my_wrapper/my_spi/check_read \
sim:/SPI_RAM_tb/my_wrapper/my_spi/k \
sim:/SPI_RAM_tb/my_wrapper/my_spi/g \
run -all 