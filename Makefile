# C
CC     := gcc
CFLAGS := -std=c11 -pedantic -Wall -Wextra -Wno-deprecated-declarations -Os
LDFLAGS := -lreadline

# MIPS
MIPS := spim -file

SRC  = main.c
OBJ  = ${SRC:.c=.o}

RM := rm -Rf

all: options

options:
	@printf "=> Opciones de compilador C:\n"
	@printf "CC     = ${CC}\n"
	@printf "CFLAGS = ${CFLAGS}\n"
	@printf "\n=> Opciones de compilador MIPS:\n"
	@printf "MIPS = ${MIPS}\n"
	@printf "\n=> Opciones:\n"
	@printf "make c     --- Compila y genera el archivo .c\n"
	@printf "make mips  --- Compila y corre el archivo .asm\n"
	@printf "make asm   --- Alias de 'make mips'\n"
	@printf "make clean --- Elimina objetos y otra basura\n"

clean:
	${RM} main *.o main.asm

# -----------------------------------------------------------------------------
# MIPS (ASM) Compilation
# -----------------------------------------------------------------------------

main.asm: main.in
	${RM} ${@}
	./scripts/preprocess.sh ${<} ${@}
	${MIPS} ${@}

asm: main.asm

# -----------------------------------------------------------------------------
# C Compilation
# -----------------------------------------------------------------------------

.c.o:
	${CC} -c ${CFLAGS} ${<}

main: ${OBJ}
	${CC} -o $@ ${^} ${LDFLAGS}

c: main

.PHONY: all options clean main mips asm
