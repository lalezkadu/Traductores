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
	token 'TkString' 'TkNum' 'TkId'

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
		| FUNCIONES 			{ result = Estructura.new(val[0], nil) }
		| PROGRAMA 				{ result = Estructura.new(nil, val[0]) }
		| 						{ result = Estructura.new(nil, nil) }
		;

	# Reglas para reconocer funciones antes del codigo del programa
	FUNCIONES
		: FUNCION FUNCIONES 	{ result = ListaFunciones.new(val[1], val[0]) }
		| FUNCION 				{ result = val[0] }
		;

	# Reglas para escribir funciones
	FUNCION
		: 'func' IDENTIFICADOR '(' ')' 'begin' INSTRUCCIONES 'end' ';'							{ result = Funcion.new(val[1], nil, nil, val[5]) }
		| 'func' IDENTIFICADOR '(' PARAMETROS ')' 'begin' INSTRUCCIONES 'end' ';'				{ result = Funcion.new(val[1], val[3], nil, val[6]) }
		| 'func' IDENTIFICADOR '(' ')' '->' TIPO 'begin' INSTRUCCIONES 'end' ';'				{ result = Funcion.new(val[1], nil, val[5], val[7]) }
		| 'func' IDENTIFICADOR '(' PARAMETROS ')' '->' TIPO 'begin' INSTRUCCIONES 'end' ';'		{ result = Funcion.new(val[1], val[3], val[6], val[8]) }
		;

	# Reglas para reconocer los parametros de una funcion
	PARAMETROS
		: TIPO IDENTIFICADOR ',' PARAMETROS 	{ result = Parametros.new(val[0],val[1],val[3]) }
		| TIPO IDENTIFICADOR 					{ result = Parametros.new(val[0],val[1],nil) }
		;

	# Reglas para reconocer codigos en programas
	PROGRAMA
		: 'program' INSTRUCCIONES 'end' ';'	{ result = Programa.new(val[1]) }
		| 'program' 'end' ';'				{ result = Programa.new(nil) }
		;

	# Reglas para escribir bloque de instrucciones
	BLOQUE
		: 'with' LISTA_DECLARACION ';' 'do' INSTRUCCIONES 'end'	{ result = Bloque.new(val[1], val[4]) }
		| 'with' 'do' INSTRUCCIONES 'end'						{ result = Bloque.new(nil, val[2]) }							
		;

	# Reglas para reconocer una lista de declaraciones
	LISTA_DECLARACION 							
		: DECLARACION							{ result = ListaDeclaracion.new(nil, val[0]) }
		| LISTA_DECLARACION ';' DECLARACION		{ result = ListaDeclaracion.new(val[0], val[2]) }	
		;

	# Reglas para reconocer una declaracion
	DECLARACION
		: TIPO LISTA_IDENTIFICADOR		{ result = Declaracion.new(val[0], val[1]) }
		| TIPO ASIGNACION  				{ result = Declaracion.new(val[0], val[1]) }
		;

	# Reglas para reconocer una lista de identificadores
	LISTA_IDENTIFICADOR
		: IDENTIFICADOR									{ result = ListaId.new(nil, val[0]) }
		| LISTA_IDENTIFICADOR ',' IDENTIFICADOR 		{ result = ListaId.new(val[0], val[2]) }
		;

	# Regla para reconocer una secuencia de instrucciones
	INSTRUCCIONES
		: INSTRUCCIONES INSTRUCCION 	{ result = Instrucciones.new(val[0], val[1]) }
		| INSTRUCCION 					{ result = Instrucciones.new(nil, val[0]) }
		;

	# Reglas para reconocer una instruccion
	INSTRUCCION
		: ASIGNACION ';'		{ result = val[0] }
		| BLOQUE ';'			{ result = val[0] }
		| ENTRADA ';'			{ result = val[0] }
		| SALIDA ';'			{ result = val[0] }
		| CONDICIONAL ';'		{ result = val[0] }
		| REPETICION_D ';'		{ result = val[0] }
		| REPETICION_I ';'		{ result = val[0] }
		| RETURN ';'			{ result = val[0] }
		| LLAMADA_FUNCION ';' 	{ result = val[0] }
		| ';'					{ result = nil }
		;

	# Reglas para reconocer retorno de valores en las funciones
	RETURN
		: 'return' EXPRESION 	{ result = Return.new(val[1]) }
		;

	# Reglas para reconocer asignaciones
	ASIGNACION
		: IDENTIFICADOR '=' EXPRESION 		{ result = Asignacion.new(val[0], val[2]) }
		;

	# Reglas para reconocer la lectura por entrada estandar
	ENTRADA
		: 'read' IDENTIFICADOR 			{ result = Entrada.new(val[1]) }
		;

	# Reglas para escribir por la salida estandar
	SALIDA
		: 'write' ESCRIBIR 		{ result = Salida.new(val[1], nil) }
		| 'writeln' ESCRIBIR 	{ result = Salida.new(val[1], "SALTO") }
		;

	# Reglas para escribir expresiones o strings por la salida estandar
	ESCRIBIR
		: EXPRESION 				{ result = Escribir.new(nil, val[0]) }
		| STRING 					{ result = Escribir.new(nil, val[0]) }
		| ESCRIBIR ',' EXPRESION 	{ result = Escribir.new(val[0], val[2]) }
		| ESCRIBIR ',' STRING 		{ result = Escribir.new(val[0], val[2]) }
		;

	# Regla para reconocer un string en la salida
	STRING 
		: 'TkString'	{ result = Str.new(val[0]) }
		;

	# Reglas para reconocer la instruccion condicional
	CONDICIONAL
		: 'if' EXPRESION 'then' INSTRUCCIONES COND 	{ result = Condicional.new(val[1],val[3],val[4]) }
		;

	# Reglas para reconocer como termina el condicional
	COND
		: 'end' 						{ result = nil }
		| 'else' INSTRUCCIONES 'end' 	{ result = val[1] }
		;

	# Reglas para reconocer las repeticiones determinadas
	REPETICION_D
		: 'for' IDENTIFICADOR 'from' EXPRESION 'to' EXPRESION 'by' EXPRESION 'do' INSTRUCCIONES 'end' 	{ result = For.new(val[1], val[3], val[5], val[7], val[9])}
		| 'for' IDENTIFICADOR 'from' EXPRESION 'to' EXPRESION 'do' INSTRUCCIONES 'end' 					{ result = For.new(val[1], val[3], val[5], nil, val[7]) }
		| 'repeat' EXPRESION 'times' INSTRUCCIONES 'end'												{ result = Repeat.new(val[1],val[3]) }
		;

	# Reglas para reconocer las repeticiones indeterminadas
	REPETICION_I
		: 'while' EXPRESION 'do' INSTRUCCIONES 'end'	{ result = RepeticionI.new(val[1],val[3]) }
		;

	# Reglas para reconocer las expresiones
	EXPRESION
		: LITERAL 					{ result = val[0] }
		| LLAMADA_FUNCION			{ result = val[0] }
		| IDENTIFICADOR 			{ result = val[0] }
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

	# Reglas para reconocer llamadas a funciones
	LLAMADA_FUNCION
		: IDENTIFICADOR '(' ')'							{ result = LlamadaFuncion.new(val[0], nil) }
		| IDENTIFICADOR '(' LISTA_PASE_PARAMETROS ')'	{ result = LlamadaFuncion.new(val[0], val[2]) }
		;

	# Reglas para reconocer los parametros de una llamada a funcion
	LISTA_PASE_PARAMETROS
		: EXPRESION 							{ result = ListaPaseParametros.new(nil,val[0]) }
		| EXPRESION ',' LISTA_PASE_PARAMETROS 	{ result = ListaPaseParametros.new(val[2],val[0]) }
		;

	# Reglas de tipos de datos
	TIPO
		: 'number' 	{ result = TipoNum.new() }
		| 'boolean' { result = TipoBoolean.new() }
		;

	# Reglas de Literales
	LITERAL
		: LITERAL_NUMBER
		| LITERAL_BOOLEAN
		;

	# Reglas de Literales Numericos
	LITERAL_NUMBER
		: 'TkNum' 	{ result = LiteralNumerico.new(val[0]) }
		;

	# Reglas de Literales Booleanos
	LITERAL_BOOLEAN
		: 'true'	{ result = LiteralBooleano.new("true") }
		| 'false'	{ result = LiteralBooleano.new("false") }
		;

	# Regla para reconocer un identificador
	IDENTIFICADOR
		: 'TkId' 	{ result =  Identificador.new(val[0]) }
		;
end

# Aqui terminamos la gramatica

---- header ----

require_relative 'lexer'
require_relative 'clasesParser'
require_relative 'clasesContexto'

# Errores sintacticos
class ErrorSintactico < RuntimeError

	def initialize(token)
		@token = token
	end

	def to_s
		"fila: " + @token.fila.to_s() + ", columna: " + @token.columna.to_s() + ", token inesperado: #{@token.token} \n"   # EL PROBLEMA ES ACA
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
		@tokens.shift
	end

	def on_error(id, token, pila)
		raise ErrorSintactico.new(token)
	end
	