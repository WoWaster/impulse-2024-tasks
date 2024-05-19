IVERILOG = "iverilog"
VVP = "vvp"

all: run

build:
	$(IVERILOG) -s f32_adder_tb -g2012 -o f32_adder_tb \
		-I HardFloat-1/source -I HardFloat-1/source/RISCV \
		src/f32_adder.sv src/f32_adder_tb.sv \
		HardFloat-1/source/HardFloat_primitives.v HardFloat-1/source/HardFloat_rawFN.v \
		HardFloat-1/source/fNToRecFN.v HardFloat-1/source/recFNToFN.v \
		HardFloat-1/source/isSigNaNRecFN.v HardFloat-1/source/addRecFN.v

run: build
	$(VVP) f32_adder_tb

clean:
	$(RM) f32_adder_tb
