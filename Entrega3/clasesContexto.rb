require_relative 'clasesParser'
require_relative 'lexer'

# Tabla de simbolos
class SymTable

	attr_accessor :declaraciones, :funciones, :padre

	def initialize(padre=nil,declaraciones=Hash.new,funciones=[])
		@declaraciones = declaraciones
		@padre = padre
		
		if @padre != nil
			@funciones = padre.funciones
		else
			@funciones = funciones
		end
		
		@declaraciones = declaraciones
		
		@padre = padre
	end

	def to_s(tab)
		s = ""
		if @tabla.length > 0:
			@tabla.each { |key, value| s+= (" "*tab)+"#{key}: #{value}\n" }
		else
			s << "None\n"
		end
		return s
	end
end

# Alcance de las variables
class Alcance
	attr_accessor :nombre, :tabla, :padre

	def initialize(nombre="",tabla,padre=nil)
		@nombre = nombre
		@tabla = tabla
		@padre = padre
	end

	def to_s(tab)
		s = (" "*tab)+"Alcance #{nombre}:\n"
		s << (" "*(tab+2)) + "Variables:\n"
		if @tabla != nil
			s << @tabla.to_s(tab+4)
		else
			s << "None\n"
		end
		return s
	end
end

# Errores de Contexto

class ErrorContexto < RuntimeError; end

class ErrorDeclaracion < ErrorContexto
	def initialize(token)
		@token = token
	end

	def to_s
		"Error en la linea #{@token.linea}, columna #{@token.columna}: \nLa variable #{@token.token} fue previamente declarada."
	end
end

class ErrorTipoAsignacion < ErrorContexto
	def initialize(tipo_asig,tipo_var,nombre,linea,columna)
		@token = token
	end

	def to_s
		"Error en la linea #{@token.linea}, columna #{@token.columna}: \nSe intento asignar un valor de tipo #{@tipo_asig} a la variable #{@nombre}\n que es de tipo #{@tipo_var}."
	end
end

class ErrorVariableNoDeclarada < ErrorContexto
	def initialize(token)
		@token = token
	end

	def to_s
		"Error en la linea #{@token.linea}, columna #{@token.columna}: \nLa variable #{@token.token} no ha sido declarada."
	end
end

class ErrorTipos < ErrorContexto
	def initialize(op,op1,op2,linea,columna)
		@op = op
		@op1 = op1
		@op2 = op2
		@linea = linea
		@columna = columna
	end

	def to_s
		"Error en la linea #{@linea}, columna #{@columna}: \nEn la expresion de tipo #{op}: Se intento operar un operando izquierdo del tipo #{@op1} con un\n operando derecho del tipo #{@op2}."
	end
end

class ErrorTipoUnario < ErrorContexto
	def initialize(oper,op,linea,columna)
		@oper = oper
		@op = op
		@linea = linea
		@columna = columna
	end

	def to_s
		"Error en la linea #{@linea}, columna #{@columna}: \nSe intento realizar la operacion #{oper} en un operando de tipo #{@operando}"
	end
end

class ErrorCondicional < ErrorContexto
	def initialize(tipo,linea,columna)
		@tipo = tipo
		@linea = linea
		@columna = columna
	end

	def to_s
		"Error en la linea #{@linea}, columna #{@columna}: La condicion es de tipo #{@tipo}."
	end
end

class ErrorCondicionIteracionIndeterminada < ErrorContexto
	def initialize(tipo, linea, columna)
		@tipo = tipo
		@linea = linea
		@columna = columna
	end

	def to_s
		"Error en la linea #{@linea}, columna #{@columna}: La condicion de la iteracion es de tipo #{@tipo}."
	end
end 

class ErrorTipoVariableIteracionDeterminada < ErrorContexto
	def initialize(tipo,linea,columna)
		@tipo = tipo
		@linea = linea
		@columna = columna
	end

	def to_s
		"Error en la linea #{@linea}, columna #{@columna}: La variable de la iteracion es de tipo #{@tipo}."
	end
end

class ErrorLimiteVariableIteracionDeterminada < ErrorContexto
	def initialize(linea,columna)
		@linea = linea
		@columna = columna
	end

	def to_s
		"Error en la linea #{@linea}, columna #{@columna}: Iteracion fuera del rango."
	end
end

# Chequeos de las clases
class Estructura
	def check(tabla)
	end
end

class ListaFunciones
	def check(tabla)
		@funcion.check(tabla)
		if @funciones != nil
			@funciones.check(tabla)
		end
	end
end

class Funcion
	def check(tabla)
		tablaParametros = Hash.new
		@parametros.check(tablaParametros)
		sym_table = SymTable.new(tablaParametros,nil,tabla)
		alcance_actual = Alcance.new(@nombre,tablaParametros,tabla)
		@instrucciones.check(alcance_actual)
		tabla[:(@nombre)] = sym_table
	end
end

class Parametros
	def check(tabla)
		tabla[:(@id)] = @tipo
		if @parametros != nil
			@parametros.check(tabla)
		end
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
		if @instrucciones != nil
			@instrucciones.check(tabla)
		end
		if @instruccion != nil
			@instruccion.check(tabla)
		end
	end
end

class Return
	def check(tabla)
		@expresion.check(tabla)
	end
end

class Condicional
	def check(tabla)
        if (@condicion.check(tabla))
            @instif.check(tabla)
        else
            if (@instelse != nil)
                @instelse.check(tabla)
            end
        end
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

class Asignacion
    def check(tabla)

	end
end

class OpMultiplicacion
	def check(tabla)
		@op1.check(tabla)
		@op2.check(tabla)
	end
end

class OpSuma
    def check(tabla)
    	@op1.check(tabla)
		@op2.check(tabla)
	end
end

class OpResta
    def check(tabla)
    	@op1.check(tabla)
		@op2.check(tabla)
	end
end

class OpDivision
    def check(tabla)
    	@op1.check(tabla)
		@op2.check(tabla)
	end
end

class OpMod
    def check(tabla)
    	@op1.check(tabla)
		@op2.check(tabla)
	end
end

class OpDivisionE
    def check(tabla)
    	@op1.check(tabla)
		@op2.check(tabla)
	end
end

class OpModE
    def check(tabla)
    	@op1.check(tabla)
		@op2.check(tabla)
	end
end

class OpEquivalente
    def check(tabla)
    	@op1.check(tabla)
		@op2.check(tabla)
	end
end

class OpDesigual
    def check(tabla)
    	@op1.check(tabla)
		@op2.check(tabla)
	end
end

class OpMenor
    def check(tabla)
    	@op1.check(tabla)
		@op2.check(tabla)
	end
end

class OpMenorIgual
    def check(tabla)
    	@op1.check(tabla)
		@op2.check(tabla)
	end
end

class OpMayor
    def check(tabla)
    	@op1.check(tabla)
		@op2.check(tabla)
	end
end

class OpMayorIgual
    def check(tabla)
    	@op1.check(tabla)
		@op2.check(tabla)
	end
end

class OpAnd
    def check(tabla)
    	@op1.check(tabla)
		@op2.check(tabla)
	end
end

class OpOr
	def check(tabla)
		@op1.check(tabla)
		@op2.check(tabla)
	end
end

class ExpresionUnaria
	def check(tabla)
		@op1.check(tabla)
		@op2.check(tabla)
	end
end

class OpUMINUS
	def check(tabla)
		@op1.check(tabla)
		@op2.check(tabla)
	end
end

class OpNot
	def check(tabla)
		@op1.check(tabla)
		@op2.check(tabla)
	end
end

class LlamadaFuncion
	def check(tabla)
	end
end

class ListaPaseParametros
	def check(tabla)
		if tabla.has_key?(@id)
		end
		# Preguntar si el id esta en la tabla
		# Si: Checkear parametros con los de la funcion
		# No: Error
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

class LiteralNumerico
	def check(tabla)
		if /^\d+$/.matches(@valor)
			return @valor.to_i()
		else
			return @valor.to_f()
		end
	end
end

class LiteralBooleano
	def check(tabla)
		if @valor == "true"
			return true
		else
			return false
		end
	end
end