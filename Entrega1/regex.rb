puts "Colocar la REGEX sin //"
STDOUT.flush
regex = STDIN.gets.chomp
re = Regexp.new(regex)
pal = STDIN.gets.chomp
if re.match(pal) then 
	print true
else 
	print false
end