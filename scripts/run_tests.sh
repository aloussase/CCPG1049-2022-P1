#!/bin/sh

if [ ! -f ./scripts/preprocess.sh ]; then
   printf 'Please run the tests from the project root\n'
   exit 1
fi
if [ -z "`command -v spim`" ]; then
    printf 'spim executable not found'
    exit 1
fi

# Import the preprocess function.
. ./scripts/preprocess.sh

main()
{
    run=0; failed=0; succeeded=0

    for t in ./tests/* ; do
        printf '\033[32mTEST:\033[m Running test %s\n' "$t"

        # Preprocess the file to resolve any @include s
        out="`mktemp`"
        preprocess "$t" "$out"
        result="`spim -file $out`"

        if [ -n "$DEBUG" ]; then
            echo "$result"
        fi

        # Tests must output a line starting with the string
        # ERROR: for each failure.
        errors="`echo "$result" | awk '/ERROR:/ {print}' | tee /dev/stderr | wc -l`"

        if [ "$errors" -gt 0 ]; then
            failed="$(( failed + errors ))"
        else
            succeeded="$(( succeeded + 1 ))"
        fi

        run="$(( run + 1 ))"

        # Remove the temporary file.
        rm -rf "$out"
    done

    printf 'Run %d tests, succeeded: %d, failed: %d\n' "$run" "$succeeded" "$failed"

    [ "$failed" -ne  0 ] && exit 1
}

main

exit 0
