class ParserRtn

	# Declaramos los tokens.
	token: 
			'program' 'end' 'read' 'write' 'writeln' 'with' 'do' 'if' 'then' 
			'else' 'while' 'for' 'from' 'to' 'by' 'repeat' 'times' 'func' 
			'begin' 'return' 'number' 'boolean' 'true' 'false' 'not' 'and' 'or'
			'==' '/=' '>=' '<=' '>' '<' '+' '-' '*' '/' '%' 'div' 'mod' '=' ';' 
			',' '->' '(' ')'

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

	# Asignamos alias a los tokens - Opcional

	# Comienzo de la gramatica.

	start Inicio
	# Se definen las reglas de la gramatica que reconoce el lenguaje Retina.
rule


TIPO
	: number {result = "number"}
	| boolean {result = "boolean"}
	;
VARIABLE 
	: ID
	;
end