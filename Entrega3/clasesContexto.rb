require_relative 'clasesParser'
require_relative 'lexer'

# Tabla de simbolos

class SymTable
	attr_accessor :declaraciones, :funciones, :padre, :hijos, :nombre

	def initialize(nombre="",padre=nil,hijos=nil,declaraciones=nil,funciones=[])
		@declaraciones
		@padre
		@hijos
	end

	def to_s(tab)
		aux_tabla = @tabla
		s = ""
		aux_tabla.each { |key, value| s+= (" "*tab)+"#{key}: #{value}\n" }
	end
	return s
end

# Alcance de las variables

class Alcance
	attr_accessor :nombre, :tabla, :alcances, :padre

	def initialize(nombre,tabla,alcances,padre=nil)
		@nombre = nombre
		@tabla = tabla
		@alcances = alcances
		@padre = padre
	end

	def to_s(tab)
		s = (" "*tab)+"Alcance #{nombre}:\n"
		s << (" "*(tab+2)) + "Variables:\n"
		if @tabla != nil
			s << @tabla.to_s(tab+4)
		else
			s << "None\n"
		s << (" "*(tab+2)) + "Sub_alcances:\n"
		if @alcances != nil
			s << @alcances.to_s(tab+4)
		else
			s << "None\n"

		return s
	end
end

# Errores de Contexto

class ErrorContexto < RuntimeError
end

class ErrorDeclaracion < ErrorContexto
	def initialize()
	end

	def to_s
	end
end

class ErrorVariableNoDeclarada < ErrorContexto
	def initialize()
	end

	def to_s
	end
end

class ErrorTipos < ErrorContexto
	def initialize()
	end

	def to_s
	end
end

class ErrorOperarDistintosTipos < ErrorContexto
	def initialize()
	end

	def to_s
	end
end

class ErrorTipoUnario < ErrorContexto
	def initialize()
	end

	def to_s
	end
end

# Chequeos de las clases

class Estructura
	def check(tabla)
	end
end

class ListaFunciones
	def check(tabla)
	end
end

class Funcion
	def check(tabla)
	end
end

class Parametros
	def check(tabla)
	end
end

class Programa
	def check(tabla)
	end
end

class Bloque
	def check(tabla)
	end
end

class ListaDeclaracion
	def check(tabla)
	end
end

class Declaracion
	def check(tabla)
	end
end

class ListaId
	def check(tabla)
	end
end

class Identificador
	def check(tabla)
	end
end

class Instrucciones
	def check(tabla)
	end
end

class Return
	def check(tabla)
	end
end

class Condicional
	def check(tabla)
	end
end

class RepeticionI
	def check(tabla)
	end
end

class Repeat
	def check(tabla)
	end
end

class For
	def check(tabla)
	end
end

class Entrada
    def check(tabla)
	end
end

class Salida 
    def check(tabla)
	end
end

class Escribir
	def check(tabla)
	end
end

class ExpresionBinaria
	def check(tabla)
	end
end

class Asignacion
    def check(tabla)
	end
end

class OpMultiplicacion
	def check(tabla)
	end
end

class OpSuma
    def check(tabla)
	end
end

class OpResta
    def check(tabla)
	end
end

class OpDivision
    def check(tabla)
	end
end

class OpMod
    def check(tabla)
	end
end

class OpDivisionE
    def check(tabla)
	end
end

class OpModE
    def check(tabla)
	end
end

class OpEquivalente
    def check(tabla)
	end
end

class OpDesigual
    def check(tabla)
	end
end

class OpMenor
    def check(tabla)
	end
end

class OpMenorIgual
    def check(tabla)
	end
end

class OpMayor
    def check(tabla)
	end
end

class OpMayorIgual
    def check(tabla)
	end
end

class OpAnd
    def check(tabla)
	end
end

class OpOr
	def check(tabla)
	end
end

class ExpresionUnaria
	def check(tabla)
	end
end

class OpUMINUS
	def check(tabla)
	end
end

class OpNot
	def check(tabla)
	end
end

class LlamadaFuncion
	def check(tabla)
	end
end

class ListaPaseParametros
	def check(tabla)
	end
end

class Tipo
	def check(tabla)
	end
end

class TipoNum
	def check(tabla)
	end
end

class TipoBoolean
	def check(tabla)
	end
end

class Literal
	def check(tabla)
	end
end

class LiteralNumerico
	def check(tabla)
	end
end

class LiteralBooleano
	def check(tabla)
	end
end