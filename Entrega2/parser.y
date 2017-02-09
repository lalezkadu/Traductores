#!/usr/bin/ruby
# = parser.y
#
# Autor:: Lalezka Duque, 12-10613
# Autor:: Marcos Jota, 12-10909
#
# == Descripcion
#
# Archivo que contiene la Gramatica para el reconocimiento del lenguaje Retina
# mediante la herramienta generadora de analizadores sintacticos en Ruby, Racc.

class ParserRtn

	# Declaramos los tokens.
	token
			'program' 'end' 'read' 'write' 'writeln' 'with' 'do' 'if' 'then' 
			'else' 'while' 'for' 'from' 'to' 'by' 'repeat' 'times' 'func' 
			'begin' 'return' 'number' 'boolean' 'true' 'false' 'not' 'and' 'or'
			'==' '/=' '>=' '<=' '>' '<' '+' '-' '*' '/' '%' 'div' 'mod' '=' ';' 
			',' '->' '(' ')' ID STRING NUMBER

	# Declaramos la precedencia explicita de los operadores,
	prechigh
		right 'not'
		right UMINUS
		left '*' '/' '%' 'div' 'mod'
		left '+' '-'
		nonassoc '==' '/=' '>=' '<=' '>' '<'
		left 'and'
		left 'or'
	preclow

	# Comienzo de la gramatica.
	start ESTRUCTURA
	# Se definen las reglas de la gramatica que reconoce el lenguaje Retina.

	rule

	# Reglas para reconocer la estructura de un programa
	ESTRUCTURA
		: FUNCIONES PROGRAMA 	{ result = Estructura.new(val[0], val[1]) }
		| PROGRAMA 				{ result = Estructura.new(nil, val[0]) }
		;

	# Reglas para reconocer funciones antes del codigo del programa
	FUNCIONES
		: FUNCIONES FUNCION 	{ result = Funcion.new(val[1]) }
		| FUNCION 				{ result = val[0] }
		;

	# Reglas para escribir funciones
	FUNCION
		: ID '(' ')' 'begin' INSTRUCCIONES 'end' ';'						{ result = Funcion.new(val[0], nil, nil, val[4], nil, nil) }
		| ID '(' PARAMETROS ')' 'begin' INSTRUCCIONES 'end' ';'				{ result = Funcion.new(val[0], val[2], nil, val[6]) }
		| ID '(' ')' '->' TIPO 'begin' INSTRUCCIONES 'end' ';'				{ result = Funcion.new(val[0]) }
		| ID '(' PARAMETROS ')' '->' TIPO 'begin' INSTRUCCIONES 'end' ';'	{ result = Funcion.new() }
		;

	# Reglas para reconocer los parametros de una funcion
	PARAMETROS
		: TIPO ID ',' PARAMETROS 	{ result = Parametros.new(val[0],val[1],val[3]) }
		| TIPO ID 					{ result = Parametros.new(val[0],val[1],nil) }
		;

	# Reglas para reconocer codigos en programas
	PROGRAMA
		: 'program' BLOQUE 'end' ';'	{ result = Programa.new(val[1]) }
		;

	# Reglas para escribir bloque de instrucciones
	BLOQUE
		: 'with' LISTA_DECLARACION 'do' INSTRUCCIONES 'end' ';'	{ result = Bloque.new(val[1], val[3]) }
		| 'do' INSTRUCCIONES 'end' ';'							{ result = Bloque.new(nil, val[1]) }
		;

	# Reglas para reconocer una lista de declaraciones
	LISTA_DECLARACION 							
		: LISTA_DECLARACION ';' DECLARACION		{ result = ListaDeclaracion.new(val[0], val[2]) }	
		| DECLARACION ';'						{ result = ListaDeclaracion.new(val[0], nil) }
		;

	# Reglas para reconocer una declaracion
	DECLARACION
		: TIPO LISTA_ID ';'		{ result = Declaracion.new(val[0], val[1], nil) }
		| TIPO ASIGNACION  		{ result = Declaracion.new(val[0], nil, val[1]) }
		;

	# Reglas para reconocer una lista de identificadores
	LISTA_ID
		: ID  					{ result = Identificador.new(val[0], nil) }
		| LISTA_ID ',' ID 		{ result = Identificador.new(val[0], val[2]) }
		;

	# Regla para reconocer una lista de instrucciones
	INSTRUCCIONES
		: SECUENCIACION 		{ result = Secuenciacion.new(val[0]) }
		| INSTRUCCION 			{ result = Instruccion.new(val[0]) }
		;

	# Reglas para reconocer secuencias de instrucciones
	SECUENCIACION
		: INSTRUCCIONES INSTRUCCION 	{ result = Instruccion.new(val[0], val[1]) }
		;

	# Reglas para reconocer una instruccion
	INSTRUCCION
		: ASIGNACION ';'	{ result = val[0] }
		| ENTRADA ';'		{ result = val[0] }
		| SALIDA ';'		{ result = val[0] }
		| CONDICIONAL ';'	{ result = val[0] }
		| REPETICION_D ';'	{ result = val[0] }
		| REPETICION_I ';'	{ result = val[0] }
		| RETURN ';'		{ result = val[0] }
		| BLOQUE 			{ result = val[0] }
		;

	# Reglas para reconocer retorno de valores en las funciones
	RETURN
		: 'return' EXPRESION 	{ result = Return.new(val[1]) }
		;

	# Reglas para reconocer asignaciones
	ASIGNACION
		: ID '=' EXPRESION 		{ result = Asignacion.new(val[0], val[2]) }
		;

	# Reglas para reconocer la lectura por entrada estandar
	ENTRADA
		: 'read' ID 			{ result = Entrada.new(val[1]) }
		;

	# Reglas para escribir por la salida estandar
	SALIDA
		: 'write' ESCRIBIR 		{ result = Salida.new(val[1], nil) }
		| 'writeln' ESCRIBIR 	{ result = Salida.new(val[1], "SALTO") }
		;

	# Reglas para escribir expresiones o strings por la salida estandar
	ESCRIBIR
		: EXPRESION 				{ result = val[0] }
		| STRING 					{ result = val[0] }
		| ESCRIBIR ',' EXPRESION 	{ result = Escribir.new() }
		| ESCRIBIR ',' STRING 		{ result = Escribir.new()}
		;

	# Reglas para reconocer la instruccion condicional
	CONDICIONAL
		: 'if' EXPRESION 'then' INSTRUCCION COND 	{ result = Condicional.new(val[1],val[3],val[4]) }
		;

	# Reglas para reconocer como termina el condicional
	COND
		: 'end' 					{ result = nil }
		| 'else' INSTRUCCION 'end' 	{ result = val[2] }
		;

	# Reglas para reconocer las repeticiones determinadas
	REPETICION_D
		: 'for' ID 'from' EXPRESION 'to' EXPRESION 'by' EXPRESION 'do' INSTRUCCIONES 'end' 	{ result = For.new(val[1], val[3], val[5], val[7], val[9])}
		| 'for' ID 'from' EXPRESION 'to' EXPRESION 'do' INSTRUCCIONES 'end' 				{ result = For.new(val[1], val[3], val[5], nil, val[7]) }
		| 'repeat' EXPRESION 'times' INSTRUCCIONES 'end'									{ result = Repeat.new(val[1],val[3]) }
		;

	# Reglas para reconocer las repeticiones indeterminadas
	REPETICION_I
		: 'while' EXPRESION 'do' INSTRUCCIONES 'end'	{ result = RepeticionI.new(val[1],val[3]) }
		;

	# Reglas para reconocer las expresiones
	EXPRESION
		: LITERAL
		| ID 						{ result = Identificador.new(val[0])}
		| '(' EXPRESION ')'			{ result = val[1] }
		| 'not' EXPRESION 			{ result = OpNot.new(val[1]) }
		| '-' EXPRESION = UMINUS 	{ result = OpUMINUS.new(val[1]) }
		| EXPRESION '*' EXPRESION 	{ result = OpMultiplicacion.new(val[0], val[2]) }
		| EXPRESION '/' EXPRESION 	{ result = OpDivisionE.new(val[0], val[2]) }
		| EXPRESION '%' EXPRESION 	{ result = OpModE.new(val[0], val[2]) }
		| EXPRESION 'div' EXPRESION { result = OpDivision.new(val[0], val[2]) }
		| EXPRESION 'mod' EXPRESION { result = OpMod.new(val[0], val[2]) }
		| EXPRESION '+' EXPRESION 	{ result = OpSuma.new(val[0], val[2]) }
		| EXPRESION '-' EXPRESION 	{ result = OpResta.new(val[0], val[2]) }
		| EXPRESION '==' EXPRESION 	{ result = OpEquivalente.new(val[0], val[2]) }
		| EXPRESION '/=' EXPRESION 	{ result = OpDesigual.new(val[0], val[2]) }
		| EXPRESION '>=' EXPRESION 	{ result = OpMayorIgual.new(val[0], val[2]) }
		| EXPRESION '<=' EXPRESION 	{ result = OpMenorIgual.new(val[0], val[2]) }
		| EXPRESION '>' EXPRESION 	{ result = OpMayor.new(val[0], val[2]) }
		| EXPRESION '<' EXPRESION 	{ result = OpMenor.new(val[0], val[2]) }
		| EXPRESION 'and' EXPRESION { result = OpAnd.new(val[0], val[2]) }
		| EXPRESION 'or' EXPRESION 	{ result = OpOr.new(val[0], val[2]) }
		;

	# Reglas de tipos de datos
	TIPO
		: 'number' 	{ result = TipoNumber.new() }
		| 'boolean' { result = TipoBoolean.new() }
		;

	# Reglas de Literales
	LITERAL
		: LITERAL_NUMBER
		| LITERAL_BOOLEAN
		;

	# Reglas de Literales Numericos
	LITERAL_NUMBER
		: NUMBER 	{ result = LiteralNumerico.new(val[0]) }
		;

	# Reglas de Literales Booleanos
	LITERAL_BOOLEAN
		: 'true'	{ result = LiteralBooleano.new("true") }
		| 'false'	{ result = LiteralBooleano.new("false") }
		;
end

# Aqui terminamos la gramatica

---- header ----

require_relative 'lexer'
require_relative 'clasesParser'

class ErrorSintactico < RuntimeError

    def initialize(token)
        @token = token
    end

    def to_s
        return "fila: " + @token.fila.to_s() + ", columna: " + @token.columna.to_s() + ", token inesperado: #{@token.token} \n"   
    end
end

---- inner ----
	
	def initialize(tokens)
		@tokens = tokens
		@yydebug = true
		super()
	end 

	def parse
		do_parse
	end

	def next_token
		@tokens.next_token
	end

	def on_error(id, token, pila)
	    raise SyntacticError::new(token)
	end
	