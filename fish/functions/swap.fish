function swap -d "Swap two files around"
    set -l TEMPFILE (mktemp tmp.XXXX)
    command mv "$argv[1]" $TEMPFILE
    command mv "$argv[2]" "$argv[1]"
    command mv $TEMPFILE "$argv[2]"
end
