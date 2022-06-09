# C
CC     := gcc
CFLAGS := -std=c11 -pedantic -Wall -Wextra -Wno-deprecated-declarations -Os
LDFLAGS := -lreadline

# MIPS
MIPS := spim -file

SRC  = main.c
OBJ  = ${SRC:.c=.o}

all: main

clean:
	rm -f main *.o

# -----------------------------------------------------------------------------
# MIPS (ASM) Compilation
# -----------------------------------------------------------------------------

mips: main.asm
	${MIPS} ${^}

asm: mips

# -----------------------------------------------------------------------------
# C Compilation
# -----------------------------------------------------------------------------

.c.o:
	${CC} -c ${CFLAGS} ${<}

main: ${OBJ}
	${CC} -o $@ $^ $(LDFLAGS)

.PHONY: all clean mips asm
