# Makefile MINE

.PHONY: clean

all: ./calc.out

calc.out: calc.S
	 arm-linux-gnueabi-gcc $< -o $@ -ggdb3 -static

clean:
	rm -f calc.out

