AS = /usr/bin/nasm
LD = /usr/bin/ld

ASFLAGS = -g -f elf64
LDFLAGS = -static

SRCS = lab.s
OBJS = $(SRCS:.s=.o)

EXE = lab


SH =3




all: $(SRCS) $(EXE)

clean:
	rm -rf $(EXE) $(OBJS)
	rm *.txt

$(EXE): $(OBJS)
	$(LD) $(LDFLAGS) $(OBJS) -o $@

.s.o:
	$(AS) $(ASFLAGS) -D SH=$(SH) $< -o $@
