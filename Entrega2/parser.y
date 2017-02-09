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
		: FUNCIONES PROGRAMA
		| PROGRAMA
		;
	# Reglas para reconocer funciones antes del codigo del programa
	FUNCIONES
		: FUNCION FUNCIONES
		| FUNCION
		;
	# Reglas para escribir funciones
	FUNCION
		: ID '(' ')' 'begin' INSTRUCCIONES 'end' ';'
		| ID '(' PARAMETROS ')' 'begin' INSTRUCCIONES 'end' ';'
		| ID '(' ')' '->' TIPO 'begin' INSTRUCCIONES 'end' ';'
		| ID '(' PARAMETROS ')' '->' TIPO 'begin' INSTRUCCIONES 'end' ';'
		;
	# Reglas para reconocer los parametros de una funcion
	PARAMETROS
		: TIPO ID ',' PARAMETROS
		| TIPO ID
		;
	# Reglas para reconocer codigos en programas
	PROGRAMA
		: 'program' BLOQUE 'end' ';'
		;
	# Reglas para escribir bloque de instrucciones
	BLOQUE
		: 'with' DECLARACION 'do' INSTRUCCIONES 'end' ';'	# Aqui se agrego ;
		| 'do' INSTRUCCIONES 'end' ';'	# Y aqui...
		;
	# Reglas para reconocer una lista de declaraciones
	LISTA_DECLARACION
		: DECLARACION ';' LISTA_DECLARACION
		| DECLARACION ';'
		;
	# Reglas para reconocer una declaracion
	DECLARACION
		: TIPO LISTA_ID ';'
		| TIPO ID ';'
		| TIPO ASIGNACION 
		;
	LISTA_ID
		: ID
		| LISTA_ID ',' ID
		;
	# Regla para reconocer una lista de instrucciones
	INSTRUCCIONES
		: SECUENCIACION
		| INSTRUCCION
		;
	# Reglas para reconocer secuencias de instrucciones
	SECUENCIACION
		: INSTRUCCIONES INSTRUCCION
		;
	# Reglas para reconocer una instruccion
	INSTRUCCION
		: ASIGNACION ';'	{ result = val[0] }
		| ENTRADA ';'		
		| SALIDA ';'
		| CONDICIONAL ';'
		| REPETICION_D ';'
		| REPETICION_I ';'
		| BLOQUE 			# Verificar si puede haber un bloque dentro de otro
		;
	# Reglas para reconocer asignaciones
	ASIGNACION
		: ID '=' EXPRESION 	# Cambio de expresion del lado izquierdo por ID
		;
	# Reglas para reconocer la lectura por entrada estandar
	ENTRADA
		: 'read' ID
		;
	# Reglas para escribir por la salida estandar
	SALIDA
		: 'write' ESCRIBIR
		| 'writeln' ESCRIBIR
		;
	# Reglas para escribir expresiones o strings por la salida estandar
	ESCRIBIR
		: EXPRESION
		| STRING
		| ESCRIBIR ',' EXPRESION
		| ESCRIBIR ',' STRING
		;
	# Reglas para reconocer la instruccion condicional
	CONDICIONAL
		: 'if' EXPRESION 'then' INSTRUCCION COND
		;
	# Reglas para reconocer como termina el condicional
	COND
		: 'end' {result = nil}
		| 'else' INSTRUCCION 'end' {result = val[2]}
		;
	# Reglas para reconocer las repeticiones determinadas
	REPETICION_D
		: 'for' ID 'from' EXPRESION 'to' EXPRESION 'by' EXPRESION 'do' INSTRUCCIONES 'end'
		| 'for' ID 'from' EXPRESION 'to' EXPRESION 'do' INSTRUCCIONES 'end'
		| 'repeat' EXPRESION 'times' INSTRUCCIONES 'end'
		;
	# Reglas para reconocer las repeticiones indeterminadas
	REPETICION_I
		: 'while' EXPRESION 'do' INSTRUCCIONES 'end'
		;
	# Reglas para reconocer las expresiones
	EXPRESION
		: LITERAL
		| VARIABLE
		| '(' EXPRESION ')'
		| 'not' EXPRESION 			{ result = ExpresionUnaria.new(val[1], "NEGACION") }
		| '-' EXPRESION =UMINUS 	{ result = ExpresionUnaria.new(val[1], "NEGATIVO") }
		| EXPRESION '*' EXPRESION 	{ result = ExpresionBinaria.new(val[0], val[2], "MULTIPLICACION") }
		| EXPRESION '/' EXPRESION 	{ result = ExpresionBinaria.new(val[0], val[2], "DIVISIONEX") }
		| EXPRESION '%' EXPRESION 	{ result = ExpresionBinaria.new(val[0], val[2], "RESTOEX") }
		| EXPRESION 'div' EXPRESION { result = ExpresionBinaria.new(val[0], val[2], "DIVISION") }
		| EXPRESION 'mod' EXPRESION { result = ExpresionBinaria.new(val[0], val[2], "MODULO") }
		| EXPRESION '+' EXPRESION 	{ result = ExpresionBinaria.new(val[0], val[2], "SUMA") }
		| EXPRESION '-' EXPRESION 	{ result = ExpresionBinaria.new(val[0], val[2], "RESTA") }
		| EXPRESION '==' EXPRESION 	{ result = ExpresionBinaria.new(val[0], val[2], "IGUALDAD") }
		| EXPRESION '/=' EXPRESION 	{ result = ExpresionBinaria.new(val[0], val[2], "DESIGUALDAD") }
		| EXPRESION '>=' EXPRESION 	{ result = ExpresionBinaria.new(val[0], val[2], "MAYORIGUAL") }
		| EXPRESION '<=' EXPRESION 	{ result = ExpresionBinaria.new(val[0], val[2], "MENORIGUAL") }
		| EXPRESION '>' EXPRESION 	{ result = ExpresionBinaria.new(val[0], val[2], "MAYOR") }
		| EXPRESION '<' EXPRESION 	{ result = ExpresionBinaria.new(val[0], val[2], "MENOR") }
		| EXPRESION 'and' EXPRESION { result = ExpresionBinaria.new(val[0], val[2], "CONJUNCION") }
		| EXPRESION 'or' EXPRESION 	{ result = ExpresionBinaria.new(val[0], val[2], "DISYUNCION") }
		;
	# Reglas de tipos de datos
	TIPO
		: 'number' {result = "number"}
		| 'boolean' {result = "boolean"}
		;
	# Reglas de Literales
	LITERAL
		: LITERAL_NUMBER
		| LITERAL_BOOLEAN
		;
	# Reglas de Literales Numericos
	LITERAL_NUMBER
		: NUMBER
		;
	# Reglas de Literales Booleanos
	LITERAL_BOOLEAN
		: 'true'
		| 'false'
		;
	# Reglas para reconocer variables
	VARIABLE 
		: ID {result = Variable.new(val[0])}
		;
end

# Aqui terminamos la gramatica

---- inner ----

load 'MainRtn.rb'
load 'clasesParser.rb'
	
	def initialize(tokens)
		@tokens = tokens
		@yydebug = true
	end 

	def parse
		do_parse
	end

	def next_token
		@tokens.next_token
	end

	