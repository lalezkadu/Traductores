#!/usr/bin/ruby
# = lexerRtn.rb
#
# Autor:: Lalezka Duque, 12-10613
# Autor:: Marcos Jota, 12-10909
#
# == Descripcion
#
# Main del lexer del lenguaje Retina

require_relative 'lexer'
require_relative 'parser'

# MAIN
def main

	# Verificacion de la extension del archivo y su ubicacion
	ARGV[0] =~ /\w+\.rtn/
  	if $&.nil? 
  		puts "Extension desconocida." 
  		return 
  	end
  	begin
    	File::read(ARGV[0])
  		rescue
    	puts "Archivo no encontrado."
    	return
	end

	# Almacenar entrada
	programa = ""
	File.open(ARGV[0], "r") do |f|
	    f.each_line do |linea|
	      programa = programa + linea
	    end
	end

	begin
		# Tokenizar entrada
		lex =  LexerRtn.new(programa)
		puts "Hello"
		begin
			for tok in lex.error
				tok.imprimir
			end
			puts "Aqui"
			pars = ParserRtn.new(lex.parserTk)
			puts "Segurisimo..."
	    	arbolS = pars.parse
	    	puts "WTF? "
	    	puts type(arbol)
	    	arbol.to_s()
	    	rescue ErrorSintactico => e
	      		puts e
	      		return
		end

	rescue ErrorSintactico => e
      	puts e
      	return
     end
end

main