IVERILOG = "iverilog"
VVP = "vvp"

all: run

build:
	$(IVERILOG) -s stream_upsize_tb -g2012 -o stream_upsize_tb src/stream_upsize.sv src/stream_upsize_tb.sv
run: build
	$(VVP) stream_upsize_tb

clean:
	$(RM) stream_upsize_tb
