CC     := cc
CFLAGS := -std=c99 -pedantic -Wall -Wextra -Wno-deprecated-declarations -Os

SRC = proj01.c
OBJ = ${SRC:.c=.o}

all: options c

options:
	@printf "Opciones de compilador:\n"
	@printf "CFLAGS = ${CFLAGS}\n"
	@printf "CC     = ${CC}\n"

.c.o:
	${CC} -c ${CFLAGS} ${<}

c: ${OBJ}
	${CC} -o ${@} ${OBJ}

.PHONY: all options c
