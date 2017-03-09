require_relative 'clasesParser'
require_relative 'lexer'

$tabla_simbolos = Hash.new

# Tabla de simbolos
class SymTable

	attr_accessor :declaraciones, :funciones, :padre

	def initialize(padre=nil,declaraciones=Hash.new,funciones)
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
		if @declaraciones.length > 0:
			@declaraciones.each { |key, value| s+= (" "*tab)+"#{key}: #{value}\n" }
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
	def check()
		hashEstructura={ 'funciones' => Hash.new }

		if @funciones != nil			
			@funciones.check(hashEstructura['funciones'])
		end

		if @programa != nil
			@programa.check(hashEstructura)
		end
	end
end

class ListaFunciones
	def check(padre)
		if @funciones != nil
			@funciones.check(padre).merge!(padre.merge!(@funcion.check(padre))) 	# Si existe una lista de funciones continuo agregando
		else
			padre.merge!(@funcion.check(padre)) # Sino, agrego la última función
		end



		if @funciones != nil
			return @funciones.check(padre)
		end
		@funcion.check(padre)
		if @funciones != nil
			@funciones.check(padre)
		end
		return padre
	end
end

class Funcion
	def check(padre)	# Padre es lista de Funciones, que contiene las funciones declaradas hasta el momento

		if padre.has_key? @nombre
			nil	# ERROR ya existe una función con ese nombre
		end

		# Creo mi tabla de variables y me traigo las funciones declaradas
		@tabla=Hash.new	
		@tabla['variables']=Hash.new
		@tabla['funciones']=padre
		@tabla['return']=@tipo

		if @parametros != nil
			@parametros.check(@tabla['variables'],0)	# Obtenemos las variables
		end

		if @instrucciones != nil
			@instrucciones.check(@tabla)	# Para futuras instrucciones desarrollamos la función
		end
	
		padre[@nombre]=tabla

	end
end

class Parametros
	def check(tabla,pos)
		if !(tabla.has_key?(@id)) 
			tabla[:pos] = @tipo
			tabla[:(@id)] = @tipo
		else
			nil # ERROR ya existe la variable
		end

		if @parametros != nil
			@parametros.check(tabla,pos+1)
		end
	end
end

class Programa
	def check(padre)	# Padre tiene la tabla inicial
		
		@tabla=Hash.new	
		@tabla['variables']=Hash.new
		@tabla['funciones']=padre['funciones']

		padre['programa']=@tabla

		if @instrucciones != nil
			@instrucciones.check(tabla)
		end
	end
end

class Bloque	## Este señor imprime Variables. 
	def check(padre)
		@tabla=Hash.new
		@tabla['variables']=Hash.new
		@tabla['funciones']=padre['funciones']

		padre['bloque']=@tabla

		if @declaraciones != nil
			@declaraciones.check(@tabla['variables'])	# Pasan la lista de variables
		end

		if @instrucciones != nil
			@instrucciones.check(@tabla)
		end
	end
end

class ListaDeclaracion
	def check(padre)		# Padre referencia a las variables
		if @declaraciones != nil
			@declaraciones.check(padre)
		end

		@declaracion.check(padre)	# Lleno las variables del objeto
	end
end

class Declaracion
	def check(padre)	# Padre está referenciando a las variables
		@declaracion.check(padre,@tipo)

		if @declaraciones != nil
			@declaraciones.check(padre)
		end
	end
end

class ListaId
	def check(padre, tipo)	# Padre referencia a las variables
		@id.check(padre, tipo)

		if @ids != nil
			@ids.check(padre)
		end
	end
end

class Identificador
	def check(padre, tipo=nil)
		
		if tipo == nil
			if not(padre.has_key? @id)
				nil # Error, no existen variables declaradas
			end
		else
			@tipo=tipo
			padre[@id]=tipo	    	
		end
	end
end

class Instrucciones
	def check(padre)
		if @instrucciones != nil
			@instrucciones.check(padre)
		end
		if @instruccion != nil
			@instruccion.check(padre)
		end
	end
end

class Return
	def check(padre)
		@expresion.check(padre)
	end
end

class Condicional
	def check(padre)

		@condicion.check(padre)

		if @instif != nil
			@instif.check(padre)
		end
		if (@instelse != nil)
			@instelse.check(padre)
		end
	end
end

class RepeticionI
	def check(padre)
		@condicion.check(padre)

		if @instrucciones != nil
			@instrucciones.check(padre)
		end
	end
end

class Repeat
	def check(padre)
		@tabla=Hash.new
		@tabla['variables']=padre['variables']
		@tabla['funciones']=padre['funciones']

		@padre['repeat']=@tabla 	# Hay que ver como identificarlos

		if @repeticiones != nil
			@repeticiones.check(@tabla, 'number')	# Verifico que la expresión sea de tipo number
		end

		if @instrucciones != nil
			@instrucciones.check(@tabla)
		end
	end
end

class For
	def check(padre)
		@tabla=Hash.new
		@tabla['variables']=padre['variables']
		@tabla['funciones']=padre['funciones']

		@padre['for']=@tabla 		# Hay que ver como identificarlos

		if @inicio.tipo != 'number' || @fin.tipo != 'number' || @paso.tipo != 'number'
			nil # Error, deben ser de tipo numérico
		end

		@instrucciones.check(@tabla)

	end
end

class Entrada
	def check(padre)
	end
end

class Salida 
	def check(padre)
	end
end

class Escribir
	def check(padre)
	end
end

class ExpresionBinaria
	def check(padre, tipo=nil)
		
		if tipo != nil
			if @op1.tipo != tipo || @op2.tipo != tipo
				nil # Error, no es del tipo esperado
			end
		else
			if @op1.tipo != @op2.tipo
				nil # Error, los tipos no concuerdan
			end
		end

		@op1.check(padre, tipo)
		@op2.check(padre, tipo)

		@tipo = @op1.tipo


class Asignacion # Probablemente eliminada
	def check(padre, tipo=nil)
		if tipo != nil
			@op1=
		end

		if @op1.tipo != @op2.tipo
			nil # Error, los tipos son distintos
		end

		@op1.check(padre)
		@op2.check(padre)
		# Hay que chequear el tipo de dato 	
	end
end

class OpMultiplicacion
	def check(padre)

		if @op1.tipo != @op2.tipo
			nil # Error, los tipos son distintos
		end

		@op1.check(padre)
		@op2.check(padre)
	end
end

class OpSuma
	def check(padre)

		if @op1.tipo != @op2.tipo
			nil # Error, los tipos son distintos
		end



		@op1.check(padre)
		@op2.check(padre)
	end
end

class OpResta
	def check(padre)
		if @op1.tipo != @op2.tipo
			nil # Error, los tipos son distintos
		end

		

		@op1.check(padre)
		@op2.check(padre)
	end
end

class OpDivision # La división entre cero ? o.O
	def check(padre)
		if @op1.tipo != @op2.tipo
			nil # Error, los tipos son distintos
		end

		

		@op1.check(padre)
		@op2.check(padre)
	end
end

class OpMod
	def check(padre)
		if @op1.tipo != @op2.tipo
			nil # Error, los tipos son distintos
		end

		

		@op1.check(padre)
		@op2.check(padre)
	end
end

class OpDivisionE
	def check(padre)
		if @op1.tipo != @op2.tipo
			nil # Error, los tipos son distintos
		end

		

		@op1.check(padre)
		@op2.check(padre)
	end
end

class OpModE
	def check(padre)
		if @op1.tipo != @op2.tipo
			nil # Error, los tipos son distintos
		end

		

		@op1.check(padre)
		@op2.check(padre)
	end
end

class OpEquivalente
	def check(padre)
		if @op1.tipo != @op2.tipo
			nil # Error, los tipos son distintos
		end

		

		@op1.check(padre)
		@op2.check(padre)
	end
end

class OpDesigual
	def check(padre)
		if @op1.tipo != @op2.tipo
			nil # Error, los tipos son distintos
		end

		

		@op1.check(padre)
		@op2.check(padre)
	end
end

class OpMenor
	def check(padre)
		if @op1.tipo != @op2.tipo
			nil # Error, los tipos son distintos
		end

		

		@op1.check(padre)
		@op2.check(padre)
	end
end

class OpMenorIgual
	def check(padre)
		if @op1.tipo != @op2.tipo
			nil # Error, los tipos son distintos
		end

		

		@op1.check(padre)
		@op2.check(padre)
	end
end

class OpMayor
	def check(padre)
		if @op1.tipo != @op2.tipo
			nil # Error, los tipos son distintos
		end

		

		@op1.check(padre)
		@op2.check(padre)
	end
end

class OpMayorIgual
	def check(padre)
		if @op1.tipo != @op2.tipo
			nil # Error, los tipos son distintos
		end

		

		@op1.check(padre)
		@op2.check(padre)
	end
end

class OpAnd
	def check(padre)
		if @op1.tipo != @op2.tipo
			nil # Error, los tipos son distintos
		end

		

		@op1.check(padre)
		@op2.check(padre)
	end
end

class OpOr
	def check(padre)
		if @op1.tipo != @op2.tipo
			nil # Error, los tipos son distintos
		end

		

		@op1.check(padre)
		@op2.check(padre)
	end
end

class ExpresionUnaria
	def check(padre, tipo=nil)
		if tipo != nil
			if @tipo != tipo
				nil # Error, los tipos no concuerdan con el solicitado
			end
		else
			if @op.tipo != @tipo
				nil # Error, los tipos son distintos
			end
		end

		@op.check(padre, tipo)

	end
end

class OpUMINUS
	def check(padre)
		@op1.check(padre)
		@op2.check(padre)
	end
end

class OpNot
	def check(padre)
		@op1.check(padre)
		@op2.check(padre)
	end
end

class LlamadaFuncion
	def check(padre, tipo=nil)
		
		if not(padre['funciones'].has_key? @id.id)
			nil # Error, función no declarada
		end

		if tipo != nil
			if padre['funciones'][@id.id]['return'] != tipo
				nil # Error, los tipos no coinciden con el esperado
			end
		end

		@parametros.check(padre['funciones'][@id.id], 0)

		@tipo = padre['funciones'][@id.id]['return']

	end
end

class ListaPaseParametros
	def check(padre, pos)	# Padre tiene la lista de los parametros de la funcion en cuestión

		if not(padre.has_key? pos)
			nil # Hay mas argumentos de los necesarios
		elsif @lista == nil && (padre.length/2-1) > pos # Pregunto si hay tantos argumentos como en el hash
			nil # Faltan argumentos
		end

		@parametro.check(padre)

		if @parametro.tipo != padre[pos.to_s]
			nil # Error en los tipos 
		end


		if padre.has_key?(@id)
		end
		# Preguntar si el id esta en la tabla de padre
		# Si: Checkear parametros con los de la funcion
		# No: Error
	end
end

class Tipo
	def check(padre)
	end
end

class TipoNum
	def check(padre)
	end
end

class TipoBoolean
	def check(padre)
	end
end

class LiteralNumerico
	def check(padre)
		if /^\d+$/.matches(@valor)
			return @valor.to_i()
		else
			return @valor.to_f()
		end
	end
end

class LiteralBooleano
	def check(padre)
		if @valor == "true"
			return true
		else
			return false
		end
	end
end