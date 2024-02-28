vlib work
vlog -sv +define+SIM transaction_p.sv coverage_p.sv scoreboard_p.sv shared_p.sv FIFO_if.sv FIFO.sv FIFO_Monitor.sv FIFO_top.sv FIFO_tb.sv  +cover
vsim -voptargs=+acc work.FIFO_TOP -cover
add wave -position insertpoint  \
sim:/FIFO_TOP/filo/clk \
sim:/FIFO_TOP/filo/wr_en \
sim:/FIFO_TOP/filo/rd_en \
sim:/FIFO_TOP/filo/rst_n \
sim:/FIFO_TOP/filo/full \
sim:/FIFO_TOP/filo/empty \
sim:/FIFO_TOP/filo/almostfull \
sim:/FIFO_TOP/filo/almostempty \
sim:/FIFO_TOP/filo/wr_ack \
sim:/FIFO_TOP/filo/overflow \
sim:/FIFO_TOP/filo/underflow \
sim:/FIFO_TOP/filo/test_finished \
sim:/FIFO_TOP/filo/data_in \
sim:/FIFO_TOP/filo/data_out \
sim:/FIFO_TOP/filo/count \
sim:/FIFO_TOP/m1/scoreboard \
sim:/FIFO_TOP/dut/mem

add wave /FIFO_TOP/dut/P1 /FIFO_TOP/dut/P2 /FIFO_TOP/dut/P3 /FIFO_TOP/dut/P4 /FIFO_TOP/dut/P5 /FIFO_TOP/dut/P6 /FIFO_TOP/dut/P7 /FIFO_TOP/dut/P14 /FIFO_TOP/dut/P8 /FIFO_TOP/dut/P9 /FIFO_TOP/dut/P10 /FIFO_TOP/dut/P11 /FIFO_TOP/dut/P12 /FIFO_TOP/dut/P13 /FIFO_TOP/dut/P15 /FIFO_TOP/dut/P16 /FIFO_TOP/dut/P17 /FIFO_TOP/dut/P18 /FIFO_TOP/dut/P19

coverage save FIFO_TOP.ucdb -onexit -du FIFO
run -all