function marked --description 'Open a markdown file in Marked 2.app'
	if test -f $argv[1]
open -a "Marked 2" $argv[1]
else
open -a "Marked 2"
end
end
