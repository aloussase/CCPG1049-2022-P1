# C
CC     := cc
CFLAGS := -std=c99 -pedantic -Wall -Wextra -Wno-deprecated-declarations -Os

# MIPS
MIPS := spim -file

NAME = proj01-x
SRC  = proj01.c
OBJ  = ${SRC:.c=.o}

all: options

options:
	@printf "=> Opciones de compilador C:\n"
	@printf "CC     = ${CC}\n"
	@printf "CFLAGS = ${CFLAGS}\n"

	@printf "\n=> Opciones de compilador MIPS:\n"
	@printf "MIPS     = ${MIPS}\n"

	@printf "\n=> Opciones:\n"
	@printf "make c     --- Compila y genera el archivo .c\n"
	@printf "make mips  --- Compila y corre el archivo .asm\n"
	@printf "make asm   --- alias de 'make mips'\n"
	@printf "make clean --- Elimina objetos y otra basura\n"

clean:
	rm -f ${NAME:-x=-c} *.o

# -----------------------------------------------------------------------------
# MIPS (ASM) Compilation
# -----------------------------------------------------------------------------

mips: proj01.asm
	${MIPS} ${^}

asm: mips

# -----------------------------------------------------------------------------
# C Compilation
# -----------------------------------------------------------------------------

.c.o:
	${CC} -c ${CFLAGS} ${<}

c: ${OBJ}
	${CC} -o ${NAME:-x=-c} ${OBJ}
	@printf "\n\nExecutable generado, correr con: ./%s\n" ${NAME:-x=-c}

.PHONY: all clean options c mips asm
