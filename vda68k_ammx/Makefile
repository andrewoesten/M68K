CC	= cc
COPTS	= -D_ANSI_SOURCE -O2
CLIBS	=

vda68k: vda68k.c m68k_disasm.c m68k_disasm.h
	$(CC) $(COPTS) -o vda68k vda68k.c m68k_disasm.c $(CLIBS)

clean:
	-rm vda68k
