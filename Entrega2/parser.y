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
			',' '->' '(' ')' ID STRING

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
	start Inicio
	# Se definen las reglas de la gramatica que reconoce el lenguaje Retina.
rule

# Reglas para la estructura de un programa
ESTRUCTURA
	: FUNCIONES PROGRAMA
	;
# Reglas para escribir funciones antes del codigo del programa
FUNCIONES
	: FUNCION FUNCIONES
	;
# Reglas para escribir funciones
FUNCION
	: ID '(' ')' 'begin' INSTRUCCION 'end'
	| ID '(' PARAMETROS ')' 'begin' INSTRUCCION 'end'
	| ID '(' ')' '->' TIPO 'begin' INSTRUCCION 'end'
	| ID '(' PARAMETROS ')' '->' TIPO 'begin' INSTRUCCION 'end'
	;
PARAMETROS
# Reglas para escribir codigos en programas
PROGRAMA
	: 'program' BLOQUE 'end'
	;
# Reglas para escribir bloque de instrucciones
BLOQUE
	: 'with' LISTA_DECLARACION 'do' INSTRUCCIONES 'end'
	| 'do' INSTRUCCIONES 'end'
	;

INSTRUCCIONES
	: SECUENCIACION
	| INSTRUCCION ';'
	;

SECUENCIACION
	: INSTRUCCIONES ';' INSTRUCCION
	;

INSTRUCCION
	: ASIGNACION
	| ENTRADA
	| SALIDA
	| CONDICIONAL
	| REPETICION_D
	| REPETICION_I
	| ESTRUCTURA
	| PROGRAMA
	| BLOQUE
	;
# Reglas para realizar asignaciones
ASIGNACION
	: ID '=' EXPRESION
	;
# Reglas para leer por la entrada estandar
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
# Reglas de la instruccion condicional
CONDICIONAL
	: 'if' EXPRESION 'then' INSTRUCCION COND
	;
# Reglas para reconocer como termina el condicional
COND
	: 'end' {result = nil}
	| 'else' INSTRUCCION 'end' {result = result = val[2]}
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

# Reglas de tipos de datos
TIPO
	: number {result = "number"}
	| boolean {result = "boolean"}
	;
# Reglas de Literales
LITERAL
	: LITERAL_NUMBER
	| LITERAL_BOOLEAN
	;
# Reglas de Literales Numericos
LITERAL_NUMBER
	: 'number' 
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