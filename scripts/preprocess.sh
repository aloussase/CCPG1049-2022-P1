#!/bin/sh

# Script for replacing @include directives by the contents of the corresponding file.
# Usage:
#   preprocess.sh <infile> <outfile>

usage()
{
    printf "Usage: preprocess.sh <infile> <outfile>\n" >& 2
    exit 1
}

info()
{
    printf "\033[34mINFO\033[m: %s\n" "$1" >& 2
}

not_a_file_error()
{
    printf "\033[31mERROR\033[m: '%s' is not a file\n" "$1" >& 2
    exit 1
}

preprocess()
{
    [ -f "$1" ]  || not_a_file_error "$1"

    info "Preprocessing $1"

    IFS=''; while read -r line; do
        match="`echo "$line" | awk '/@include/ {print $1}'`"

        # Not an include directive, just echo back the line.
        if [ -z "$match" ]; then
            printf '%s\n' "$line"
            continue
        fi

        # The filename is the second column as in: @include strlen.asm
        filename="`echo "$line" | awk '{print $2}'`"

        if [ -f "$filename" ]; then
            info "Substituting contents of $filename"
            cat "$filename"
        else
            not_a_file_error "$filename"
        fi
    done <$1 >>$2
}

# Run as a script when given exactly 2 arguments.
[ $# -eq 2 ] && preprocess "$1" "$2"
[ $# -gt 2 ] && usage
