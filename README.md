# Proyecto 1 Organización de Computadores

Revisar documento **PDF** adjunto (documentación oficial del proyecto).

⚠️ **NOTA** ⚠️

Para poder correr el programa se necesita tener [SPIM](http://spimsimulator.sourceforge.net/) instalado.
En OSX, esto puede hacerse con [brew](https://formulae.brew.sh/formula/spim#default):
```
$ brew install spim
```

Luego se puede ejecutar el archivo `main.asm` de la siguiente manera:
```
$ spim -f main.asm
```
O con make:
```
$ make asm
```

## Integrantes

| Nombre                | Usuario (GH) | E-Mail (ESPOL)          |
|:----------------------|:-------------|:------------------------|
| Juan Antonio González | `anntnzrb`   | `juangonz@espol.edu.ec` |
| Alexander Goussas     | `aloussase`  | `agoussas@espol.edu.ec` |

## Entregables

Implementación del programa:

| Lenguaje           | Archivo    | Compilador |
|:-------------------|:-----------|:-----------|
| Ensamblador (MIPS) | `main.asm` | SPIM       |
| C                  | `main.c`   | GCC        |
