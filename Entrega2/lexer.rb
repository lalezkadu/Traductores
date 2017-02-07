#!/usr/bin/ruby
# = lexer.rb
#
# Autor:: Lalezka Duque, 12-10613
# Autor:: Marcos Jota, 12-10909
#
# == Proposito
#
# Implementar el lexer del lenguaje Retina.

# == Clase Tripleta
#
# Clase que representa a una tripleta con un string y su ubicacion
class Tripleta
	attr_reader :palabra, :fila, :columna

	def initialize(palabra = "", fila = -1, columna = -1)
		@palabra = palabra
		@fila = fila
		@columna = columna
	end
end

# == Clase Token
#
# Clase que representa un lexema del lenguaje
class Token

	# == Atributos
	#
	# token: String que representa al lexema
	# tipo: Identificador del token
	# fila: fila en la cual comienza el token
	# columna: columna en la cual comienza el token
	attr_reader :token, :tipo, :fila, :columna

	# Crea el token.
	# Por defecto el token nunca fue encontrado.
	def initialize(token = "", tipo = String.new, fila = -1, columna = -1)     
    	@token = token
    	@fila = fila
    	@columna = columna
    	@tipo = tipo
	end

	# Imprime el token con el siguiente formato:
	# linea @fila, columna @columna: tipo_general_del_token '@token'
 	def imprimir  
		aux = String.new()
    	reservada = /TkProgram|TkEnd|TkRead|TkWrite|TkWriteln|TkWith|TkDo|TkIf|TkThen|TkElse|"TkWhile|TkFor|TkFrom|TkTo|TkBy|TkRepeat|TkTimes|TkFunc|TkBegin|TkReturn|"TkTrue|TkFalse/
    	signo = /TkNot|TkAnd|TkNot|TkEquivalente|TkDesigual|TkMayorIgual|TkMenorIgual|TkMayor|TkMenor|TkMas|TkResta|TkMult|TkDiv|TkResto|TkDivEntera|TkMod|TkAsignacion|TkPuntoComa|TkComa|TkTipoReturn|TkParentesisA|TkParentesisC/
    
    	if reservada.match(@tipo)  # palabra reservada
    		aux = "palabra reservada"
    	elsif signo.match(@tipo)  # signo
      		aux = "signo"
    	elsif @tipo == "TkTipoBoolean"  || @tipo == "TkTipoNumber" then  # tipo de dato
      		aux = "tipo de dato"
    	elsif @tipo == "TkNum"  # literal numerico
      		aux = "literal numerico"
    	elsif @tipo == "TkId"  # Identificador
      		aux = "identificador"
    	elsif @tipo == "TkError"  # caracter inesperado
      		aux = "caracter inesperado"
    	elsif @tipo == "TkString"
      		aux = "cadena de caracteres"
    	end

    	puts "linea " + @fila.to_s + ", columna " + @columna.to_s + ": " + aux.to_s + " '#{@token}'"
  	end
end


# == Clase LexerRtn
#
# Clase que representa al lexer del lenguaje Retina.
class LexerRtn

	# == Atributos
	#
	# tk: Lista de tokens
	# error: Lista de errores
	attr_accessor :tk, :error

	# Crea el lexer.
	#
	# Recibe una cadena de caracteres que representa al programa.
	# En principio las lista de tokens y de errores estan vacias.
	# Luego se tokeniza.
	def initialize programa
		@tk = []
		@error = []
		lexer(programa)
	end

	# Lexer
	#
	# Recibe una cadena de caracteres que representa al programa.
	# Procesa el programa dado como entrada y tokeniza cada lexema.
	# Para ello recorre el programa y y para cada lexema crea el
	# token correspondiente y lo almacena en la lista correspondiente.
	def lexer programa
  
		programa = programa.split("")
		lexema = ""
  		
		# Posiciones (fila, columna) en el programa
		fila = 1
		columna = 1
		lexemas = []

		i = 0;
  		
  		# Procesamiento de los lexemas.
		while i < programa.length
		    
			c = programa[i]

			if c == "#"				# Comentario
				while c != "\n"
					i += 1;
					c = programa[i]
				end
				fila += 1
			elsif c == "\"" 		# Comentarios
				lexema << c
				i += 1
				c = programa[i]

				while c != "\""
					if c == "\\"
						lexema << c
						i += 1
						c = programa[i]
					elsif c == "\n"
						lexema = "\""

					end
					if c == "\n"
						lexemas << Tripleta.new("\"",fila,columna)
						puts "JAJA #{fila} #{columna}"
						break
					end
					lexema << c
					i += 1
					c = programa[i]
				end
				lexema << c
			elsif c == " " || c == "\t"		# Lexema encontrado
				if not(lexema.empty?)
					lexemas << Tripleta.new(lexema,fila,columna)
				end
				columna += lexema.length+1
				lexema = ""
			elsif c == "\n"
				if not(lexema.empty?)
					lexemas << Tripleta.new(lexema,fila,columna)
				end
				columna = 1
				fila += 1
				lexema = ""
			elsif c == ")" || c == "(" || c == "-" || c == ";"	# Caracteres especiales
				if not(lexema.empty?)
					lexemas << Tripleta.new(lexema,fila,columna)
				end
				columna += lexema.length
				lexema = c
				lexemas << Tripleta.new(lexema,fila,columna)
				columna += 1
				lexema = ""
    		else
      			lexema << c
    		end

			i += 1
		end

		for i in lexemas
			crearToken(i.palabra,i.fila,i.columna)
		end
	end

	# Crea el token y lo almacena en la lista de tokens o errores.
	# Mediante el uso de expresiones regulares y una tabla de hash se asigna el
	# tipo de token para tokenizar con el numero de fila y  columna 
	# correspondiente y se guarda en la lista de tokens o en de errores. 
	def crearToken lexema, fila, columna

		tipo = ""
		tipo = $reservadas.fetch(lexema, nil)

		if tipo == nil
			if lexema =~ $string
				if lexema =~ $stringErroneo	# Caracteres que no deben estar escapados
	        		tipo = "TkError"
	        	else
	        		tipo = "TkString"
	        	end
	        elsif lexema =~ $identificador
    	    	tipo = "TkId"
    	  	elsif lexema =~ $numero
    	    	tipo = "TkNum"
    	  	else
    	    	tipo = "TkError"
    	  	end
    	end
		tok = Token.new(lexema,tipo,fila,columna)
		if tok.tipo == "TkError"
			@error << tok
		else
			@tk << tok
		end
	end
end


# Variables globales: Expresiones regulares y tabla de hash
$identificador = /^[a-z][a-zA-Z0-9_]*$/
$string = /^".*"$/
$stringErroneo = /[\s\w"](([\\][\\n"])*([\\][^\\n"])+)+[\s\\]|[\s\w"](([\\][\\n"])+[\\])\s/
$numero = /^\d+$|^\d*[.]?\d*$/
$signo = /not|and|or|==|\/=|>=|<=|>|<|\+|-|\*|\%|div|mod|\=|;|\,|->|\(|\)/
$reservadas = {
            	"program" => "TkProgram", "end" => "TkEnd",
            	"read" => "TkRead","write" => "TkWrite",
            	"writeln" => "TkWriteln", "with" => "TkWith",
            	"do" => "TkDo", "if" => "TkIf",
            	"then" => "TkThen", "else" => "TkElse",
            	"while" => "TkWhile", "for" => "TkFor",
            	"from" => "TkFrom", "to" => "TkTo",
            	"by" => "TkBy", "repeat" => "TkRepeat", 
            	"times" => "TkTimes", "func" => "TkFunc",
            	"begin" => "TkBegin", "return" => "TkReturn", 
           		"number" => "TkTipoNumber", "boolean" => "TkTipoBoolean", 
            	"true" => "TkTrue", "false" => "TkFalse",
            	"not" => "TkNot", "and" => "TkAnd", 
            	"or" => "TkNot", "==" => "TkEquivalente", 
            	"/=" => "TkDesigual", ">=" => "TkMayorIgual", 
            	"<=" => "TkMenorIgual", ">" => "TkMayor", 
            	"<" => "TkMenor", "+" => "TkMas", 
            	"-" => "TkResta", "*" => "TkMult", 
            	"/" => "TkDiv", "%" => "TkResto", 
            	"div" => "TkDivEntera", "mod" => "TkMod", 
            	"=" => "TkAsignacion", ";" => "TkPuntoComa",
            	"," => "TkComa", "->" => "TkTipoReturn", 
            	"(" => "TkParentesisA", ")" => "TkParentesisC",
            	}
