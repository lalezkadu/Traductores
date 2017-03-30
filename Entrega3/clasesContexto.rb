require_relative 'clasesParser'
require_relative 'lexer'

# Clase de la tabla

class SymTable
	attr_accessor :tabla, :nombre, :padre, :funciones

	def initialize(nombre, funciones, padre=nil, tabla=Hash.new)
		@tabla = tabla
		@nombre = nombre
		@padre = padre
		@funciones = funciones
	end

	def add(key, value)

		if self.check_var_exists(key)
			puts ErrorDeclaracion.new(key).to_s()
		else
			@tabla[key] = value
		end

	end

	def check_var_exists(key)
		if @padre == nil || (@tabla.has_key? key)
			return (@tabla.has_key? key)
		else
			if ((@tabla.has_key? key) || (@padre.check_var_exists(key)))
				return true
			else
				return false
			end
		end
	end

	def get_var_type(key)
		if self.check_var_exists(key)
			if (@tabla.has_key? key)
				return @tabla[key]
			else
				return @padre.get_var_type(key)
			end
		else
			puts ErrorVariableNoDeclarada.new key
			exit
		end
	end

	def check_func_exists(key)
		return @funciones.has_key? key
	end

	def check_func_var_pos(key, pos)
		if self.check_func_exists(key)
			return @funciones[key].tabla.has_key? pos
		else
			puts "Error: Función no declarada." # Error, función no declarada
			exit
		end
	end

	def get_func_var_type(key, pos)
		if self.check_func_var_pos(key, pos)
			return @funciones[key].tabla[pos]
		else
			puts "Error: Hay mas argumentos de los esperados."
			exit
		end
	end

	def check_func_var_type(key, type, pos)
		if self.check_func_var_pos(key, pos)
			return @funciones[key].tabla[pos] == type
		else
			puts "Error: Hay mas argumentos de los esperados."
			exit
		end
	end

	def to_s()
		puts @nombre
		puts
		puts 'Tabla: '
		puts @tabla 
		puts 
		puts 'Padre: '
		puts @padre
		puts 
		puts 'Funciones: '
		puts @funciones
		puts
	end
end

# Errores de Contexto

class ErrorContexto < RuntimeError 
end

class ErrorDeclaracion < ErrorContexto
	def initialize(token)
		@token = token
	end

	def to_s
		"Error: La variable #{@token} fue previamente declarada."
	end
end

class ErrorTipoAsignacion < ErrorContexto
	def initialize(tipo_asig,tipo_var,nombre)
		@tipo_asig = tipo_asig
		@tipo_var = tipo_var
	end

	def to_s
		"Error: Se intento asignar un valor de tipo #{@tipo_asig} a la variable #{@nombre} que es de tipo #{@tipo_var}."
	end
end

class ErrorVariableNoDeclarada < ErrorContexto
	def initialize(token)
		@token = token
	end

	def to_s
		"Error: La variable #{@token} no ha sido declarada."
	end
end

class ErrorTipos < ErrorContexto
	def initialize(op,op1,op2)
		@op = op
		@op1 = op1
		@op2 = op2
	end

	def to_s
		"Error: En la expresion de tipo #{@op}: Se intento operar un operando izquierdo del tipo #{@op1} con un operando derecho del tipo #{@op2}."
	end
end

class ErrorTipoUnario < ErrorContexto
	def initialize(oper,op)
		@oper = oper
		@op = op
	end

	def to_s
		"Error: Se intento realizar la operacion #{oper} en un operando de tipo #{@operando}"
	end
end

class ErrorCondicional < ErrorContexto
	def initialize(tipo)
		@tipo = tipo
	end

	def to_s
		"Error: La condicion es de tipo #{@tipo}."
	end
end

class ErrorCondicionIteracionIndeterminada < ErrorContexto
	def initialize(tipo)
		@tipo = tipo
	end

	def to_s
		"Error: La condicion de la iteracion while es de tipo #{@tipo}, pero debe ser de tipo boolean."
	end
end 

class ErrorTipoVariableInicioIteracionDeterminadaFor < ErrorContexto
	def initialize(tipo)
		@tipo = tipo
	end

	def to_s
		"Error: El inicio de la iteracion for es de tipo #{@tipo}, pero debe ser de tipo number."
	end
end

class ErrorTipoVariableFinIteracionDeterminadaFor < ErrorContexto
	def initialize(tipo)
		@tipo = tipo
	end

	def to_s
		"Error: El fin de la iteracion for es de tipo #{@tipo}, pero debe ser de tipo number."
	end
end

class ErrorTipoVariableStepIteracionDeterminadaFor < ErrorContexto
	def initialize(tipo)
		@tipo = tipo
	end

	def to_s
		"Error: El step de la iteracion for es de tipo #{@tipo}, pero debe ser de tipo number."
	end
end

class ErrorTipoVariableIteracionDeterminadaRepeat < ErrorContexto
	def initialize(tipo)
		@tipo = tipo
	end

	def to_s
		"Error: La variable de la iteracion repeat es de tipo #{@tipo}, pero debe ser de tipo number."
	end
end

class ErrorLimiteVariableIteracionDeterminada < ErrorContexto

	def to_s
		"Error: Iteracion fuera del rango."
	end
end

# Chequeos de las clases
class Estructura	# Construyo primero la lista de funciones y luego cada uno de los demas bloques
	def check()

		@tablafunciones = Hash.new

		func_home = SymTable.new 'home', @tablafunciones, nil, { 'return'=>nil }
		func_openeye = SymTable.new 'openeye', @tablafunciones, nil, { 'return'=>nil }
		func_closeeye = SymTable.new 'closeeye', @tablafunciones, nil, { '0'=>'number', 'return'=>nil }
		func_forward = SymTable.new 'forward', @tablafunciones, nil, { '0'=>'number', 'return'=>nil }
		func_backward = SymTable.new 'backward', @tablafunciones, nil, { '0'=>'number', 'return'=>nil }
		func_rotatel = SymTable.new 'rotatel', @tablafunciones, nil, { '0'=>'number', 'return'=>nil }
		func_rotater = SymTable.new 'rotater', @tablafunciones, nil, { '0'=>'number', 'return'=>nil }
		func_setposition = SymTable.new 'setposition', @tablafunciones, nil, { '0'=>'number', '1'=>'number', 'return'=>nil }
		func_arc = SymTable.new 'arc', @tablafunciones, nil, { '0'=>'number', '1'=>'number', 'return'=>nil }

		@tablafunciones.merge!({	'home'=>func_home,
									'openeye'=>func_openeye,
									'closeeye'=>func_closeeye,
									'forward'=>func_forward,
									'backward'=>func_backward,
									'rotatel'=>func_rotatel,
									'rotater'=>func_rotater,
									'setposition'=>func_setposition,
									'arc'=>func_arc
								})

		if @funciones != nil			
			@funciones.check(@tablafunciones)
		end

		@tabla = SymTable.new "Estructura", @tablafunciones

		if @programa != nil
			@programa.check(@tabla)
		end
	end
end

class ListaFunciones
	def check(padre)
		@funcion.check(padre)
		if @funciones != nil
			@funciones.check(padre)#.merge!(padre.merge!(@funcion.check(padre))) 	# Si existe una lista de funciones continuo agregando
		else
			#padre.merge!(@funcion.check(padre)) # Sino, agrego la última función
		end
	end
end

class Funcion
	def check(padre)	# Padre es lista de Funciones, que contiene las funciones declaradas hasta el momento

		if padre.has_key? @nombre.id.to_s()
			puts ErrorDeclaracion.new(@nombre).to_s()	# ERROR ya existe una función con ese nombre
			exit
		end

		# Creo mi tabla de variables y me traigo las funciones declaradas
		@tabla= SymTable.new @nombre.id.to_s(), padre # Las funciones son padre, porque está sobre el hash de las funciones
		
		if @tipo
			@tabla.add('return', @tipo.tipo.to_s)
		else
			@tabla.add('return', nil)
		end

		padre[@nombre.id.to_s()] = @tabla

		if @parametros != nil
			@parametros.check(@tabla,0)	# Obtenemos las variables
		end

		if @instrucciones != nil
			@instrucciones.check(@tabla)	# Para futuras instrucciones desarrollamos la función
		end

	end
end

class Parametros
	def check(tabla,pos)
		if !(tabla.check_var_exists(@id.id.to_s()))
			tabla.add(pos.to_s, @tipo.tipo)
			tabla.add(@id.id.to_s(), @tipo.tipo)
			@id.tipo = @tipo
		else
			puts ErrorDeclaracion.new(@id).to_s() # ERROR ya existe la variable
			exit
		end

		if @parametros != nil
			@parametros.check(tabla,pos+1)
		end
	end
end

class Programa
	def check(padre)	# Padre tiene la tabla inicial
		
		@tabla= SymTable.new "Programa", padre.funciones, padre
		
		if @instrucciones != nil
			@instrucciones.check(@tabla)
		end
	end
end

class Bloque	## Este señor imprime Variables. 
	def check(padre)

		@tabla =SymTable.new "Bloque", padre.funciones, padre

		if @declaraciones != nil
			@declaraciones.check(@tabla)	# Pasan la lista de variables
		end

		if @instrucciones != nil
			@instrucciones.check(@tabla)
		end
	end
end

class ListaDeclaracion
	def check(padre)		# Padre referencia a las variables
		@declaracion.check(padre)	# Lleno las variables del objeto
		
		if @declaraciones != nil
			@declaraciones.check(padre)
		end
	end
end

class Declaracion
	def check(padre)	# Padre está referenciando a las variables
		@declaracion.check(padre,@tipo.to_s)
	end
end

class ListaId
	def check(padre, tipo)	# Padre referencia a las variables
		@id.check(padre, tipo)

		if @ids != nil
			@ids.check(padre, tipo)
		end
	end
end

class Identificador
	def check(padre, tipo=nil)
		
		if tipo == nil
			if !(padre.check_var_exists(@id.to_s()))
				puts ErrorVariableNoDeclarada.new @id.to_s()
				exit
			end
			@tipo = padre.get_var_type(@id.to_s())
		else
			@tipo=tipo
			padre.add(@id.to_s(), tipo)
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

		if @condicion.tipo != 'boolean'
			puts "Error: Esperaba una expresión de tipo \'boolean\' y recibi una expresión de tipo \'#{@condicion.tipo}\'"
		end
		
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
		@condicion.check(padre, nil)

		if @condicion.tipo != 'boolean'
			puts ErrorCondicionIteracionIndeterminada.new(@condicion.tipo)
			exit
		end

		if @instrucciones != nil
			@instrucciones.check(padre)
		end
	end
end

class Repeat
	def check(padre)

		@tabla = SymTable.new "Repeat", padre.funciones, padre

		if @repeticiones != nil
			@repeticiones.check(@tabla, nil)	# Verifico que la expresión sea de tipo number
			if @repeticiones.tipo != 'number'
				puts ErrorTipoVariableIteracionDeterminadaRepeat.new(@repeticiones.tipo)
				exit
			end
		end

		if @instrucciones != nil
			@instrucciones.check(@tabla)
		end
	end
end

class For
	def check(padre)

		@tabla = SymTable.new "For", padre.funciones, padre

		@id.check(@tabla,'number')
		@inicio.check(@tabla,nil)
		@fin.check(@tabla,nil)
		@paso.check(@tabla,nil)

		if @inicio.tipo != 'number' || @fin.tipo != 'number' || @paso.tipo != 'number'
			if @inicio.tipo != 'number'
				puts ErrorTipoVariableInicioIteracionDeterminadaFor.new(@inicio.tipo) # Error, deben ser de tipo numérico
			elsif @fin.tipo != 'number'
				puts ErrorTipoVariableFinIteracionDeterminadaFor.new(@fin.tipo)
			else
				puts ErrorTipoVariableStepIteracionDeterminadaFor.new(@paso.tipo)
			end
			exit				
		end

		@instrucciones.check(@tabla)
	end
end

class Entrada

	def check(tabla)
		@id.check(tabla)
	end
end

class Salida 
	def check(tabla)
		if not(@expresion.is_a? String)
			@expresion.check(tabla, nil)
		end
		if impresiones != nil
			@impresiones.check(tabla)
		end
	end
end

class Escribir
	def check(tabla)
		if not(@expresion.is_a? String)
			@expresion.check(tabla)
		end
		if @impresiones != nil
			@impresiones.check(tabla)
		end
	end
end

class Str
	def check(tabla)
		return @str
	end
end

class ExpresionBinaria
	def check(padre, tipo=nil)
		@op1.check(padre, tipo)
		@op2.check(padre, tipo)

		if tipo != nil			# Error, no es del tipo esperado
			if @op1.tipo != tipo || @op2.tipo != tipo
				if @op1.tipo != tipo
					puts "Error: Esperaba lado izquierdo de la expresion de tipo #{@op1.tipo} pero recibi una expresion de tipo #{tipo}"
				else
					puts "Error: Esperaba lado derecho de la expresion de tipo #{@op2.tipo} pero recibi una expresion de tipo #{tipo}"
				end 
				exit
			end
		else
			if @op1.tipo != @op2.tipo
				puts ErrorTipos.new(@oper,@op1,@op2).to_s() # Error, los tipos no concuerdan
				exit
			end
		end

		@tipo=@op1.tipo	
		# Hay que chequear el tipo de dato 	
	end
end

class Asignacion # Probablemente eliminada
	def check(padre, tipo=nil)
		@op1.check(padre, tipo)
		@op2.check(padre, tipo)

		if tipo != nil
			if @op1.tipo != tipo || @op2.tipo != tipo
				if @op1.tipo != tipo
					puts "Error: Esperaba lado izquierdo de la expresion de tipo #{@op1.tipo} pero recibi una expresion de tipo #{tipo}"
				else
					puts "Error: Esperaba lado derecho de la expresion de tipo #{@op2.tipo} pero recibi una expresion de tipo #{tipo}"
				end # Error, no es del tipo esperado
				exit
			end
		else
			if @op1.tipo != @op2.tipo
				puts ErrorTipos.new(@oper,@op1,@op2) # Error, los tipos no concuerdan
				exit
			end
		end
		# Hay que chequear el tipo de dato 	
		@tipo=@op1.tipo
	end
end

class OpMultiplicacion
	def check(padre,tipo=nil)

		oper1 = @op1.check(padre,tipo)
		oper2 = @op2.check(padre,tipo)

		if tipo != nil
			if @op1.tipo != tipo || @op2.tipo != tipo
				if @op1.tipo != tipo
					puts "Error: Esperaba lado izquierdo de la expresion de tipo #{@op1.tipo} pero recibi una expresion de tipo #{tipo}"
				else
					puts "Error: Esperaba lado derecho de la expresion de tipo #{@op2.tipo} pero recibi una expresion de tipo #{tipo}"
				end # Error, no es del tipo esperado
				exit
			end
		else
			if @op1.tipo != @op2.tipo
				puts ErrorTipos.new(@oper,@op1,@op2) # Error, los tipos no concuerdan
				exit
			end
		end

		@tipo="number"

		#return oper1 * oper2
	end
end

class OpSuma
	def check(padre,tipo=nil)
		oper1 = @op1.check(padre,tipo)
		oper2 = @op2.check(padre,tipo)

		if tipo != nil
			if @op1.tipo != tipo || @op2.tipo != tipo
				if @op1.tipo != tipo
					puts "Error: Esperaba lado izquierdo de la expresion de tipo #{@op1.tipo} pero recibi una expresion de tipo #{tipo}"
				else
					puts "Error: Esperaba lado derecho de la expresion de tipo #{@op2.tipo} pero recibi una expresion de tipo #{tipo}"
				end # Error, no es del tipo esperado
				exit
			end
		else
			if @op1.tipo != @op2.tipo
				puts ErrorTipos.new(@oper,@op1,@op2) # Error, los tipos no concuerdan
				exit
			end
		end

		@tipo="number"
		#return oper1 + oper2
	end
end

class OpResta
	def check(padre,tipo=nil)
		oper1 = @op1.check(padre,tipo)
		oper2 = @op2.check(padre,tipo)

		if tipo != nil
			if @op1.tipo != tipo || @op2.tipo != tipo
				puts ErrorTipos.new(@oper,@op1,@op2) # Error, no es del tipo esperado
				exit
			end
		else
			if @op1.tipo != @op2.tipo
				puts ErrorTipos.new(@oper,@op1,@op2) # Error, los tipos no concuerdan
				exit
			end
		end

		@tipo="number"
		#return oper1 - oper2
	end
end

class OpDivision # La división entre cero ? o.O
	def check(padre,tipo=nil)
		if tipo != nil
			oper1 = @op1.check(padre,tipo)
			oper2 = @op2.check(padre,tipo)

			if @op1.tipo != tipo || @op2.tipo != tipo
				if @op1.tipo != tipo
					puts "Error: Esperaba lado izquierdo de la expresion de tipo #{@op1.tipo} pero recibi una expresion de tipo #{tipo}"
				else
					puts "Error: Esperaba lado derecho de la expresion de tipo #{@op2.tipo} pero recibi una expresion de tipo #{tipo}"
				end # Error, no es del tipo esperado
				exit
			end
		else
			if @op1.tipo != @op2.tipo
				puts ErrorTipos.new(@oper,@op1,@op2) # Error, los tipos no concuerdan
				exit
			end
		end

		@tipo="number"
		if oper1 != 0
			#return oper1 / oper2
		else
			puts "Error: Division entre cero."
			exit
		end
	end
end

class OpMod
	def check(padre,tipo=nil)
		oper1 = @op1.check(padre,tipo)
		oper2 = @op2.check(padre,tipo)

		if tipo != nil
			if @op1.tipo != tipo || @op2.tipo != tipo
				if @op1.tipo != tipo
					puts "Error: Esperaba lado izquierdo de la expresion de tipo #{@op1.tipo} pero recibi una expresion de tipo #{tipo}"
				else
					puts "Error: Esperaba lado derecho de la expresion de tipo #{@op2.tipo} pero recibi una expresion de tipo #{tipo}"
				end # Error, no es del tipo esperado
				exit
			end
		else
			if @op1.tipo != @op2.tipo
				puts ErrorTipos.new(@oper,@op1,@op2) # Error, los tipos no concuerdan
				exit
			end
		end


		@tipo="number"
		if oper1 != 0
			#return oper1 % oper2
		else
			puts "Error: Division entre cero."
			exit
		end
	end
end

class OpDivisionE
	def check(padre,tipo=nil)
		oper1 = @op1.check(padre,tipo)
		oper2 = @op2.check(padre,tipo)
		
		if tipo != nil
			if @op1.tipo != tipo || @op2.tipo != tipo
				if @op1.tipo != tipo
					puts "Error: Esperaba lado izquierdo de la expresion de tipo #{@op1.tipo} pero recibi una expresion de tipo #{tipo}"
				else
					puts "Error: Esperaba lado derecho de la expresion de tipo #{@op2.tipo} pero recibi una expresion de tipo #{tipo}"
				end # Error, no es del tipo esperado
				exit
			end
		else
			if @op1.tipo != @op2.tipo
				puts ErrorTipos.new(@oper,@op1,@op2) # Error, los tipos no concuerdan
				exit
			end
		end

		@tipo="number"
		if oper1 != 0
			#return oper1.to_i() / oper2.to_i()
		else
			puts "Error: Division entre cero."
			exit
		end
	end
end

class OpModE
	def check(padre,tipo=nil)
		
		oper1 = @op1.check(padre,tipo)
		oper2 = @op2.check(padre,tipo)

		if tipo != nil
			if @op1.tipo != tipo || @op2.tipo != tipo
				if @op1.tipo != tipo
					puts "Error: Esperaba lado izquierdo de la expresion de tipo #{@op1.tipo} pero recibi una expresion de tipo #{tipo}"
				else
					puts "Error: Esperaba lado derecho de la expresion de tipo #{@op2.tipo} pero recibi una expresion de tipo #{tipo}"
				end # Error, no es del tipo esperado
				exit
			end
		else
			if @op1.tipo != @op2.tipo
				puts ErrorTipos.new(@oper,@op1,@op2) # Error, los tipos no concuerdan
				exit
			end
		end

		@tipo="number"

		if oper1 != 0
			#return oper1.to_i() % oper2.to_i()
		else
			puts "Error: Division entre cero."
			exit
		end
	end
end

class OpEquivalente
	def check(padre,tipo=nil)
		
		oper1 = @op1.check(padre,tipo)
		oper2 = @op2.check(padre,tipo)
		
		if tipo != nil
			if @op1.tipo != tipo || @op2.tipo != tipo
				if @op1.tipo != tipo
					puts "Error: Esperaba lado izquierdo de la expresion de tipo #{@op1.tipo} pero recibi una expresion de tipo #{tipo}"
				else
					puts "Error: Esperaba lado derecho de la expresion de tipo #{@op2.tipo} pero recibi una expresion de tipo #{tipo}"
				end # Error, no es del tipo esperado
				exit
			end
		else
			if @op1.tipo != @op2.tipo
				puts ErrorTipos.new(@oper,@op1,@op2) # Error, los tipos no concuerdan
				exit
			end
		end

		@tipo="boolean"
		#return oper1 == oper2
	end
end

class OpDesigual
	def check(padre,tipo=nil)
		
		oper1 = @op1.check(padre,tipo)
		oper2 = @op2.check(padre,tipo)
		
		if tipo != nil
			if @op1.tipo != tipo || @op2.tipo != tipo
				if @op1.tipo != tipo
					puts "Error: Esperaba lado izquierdo de la expresion de tipo #{@op1.tipo} pero recibi una expresion de tipo #{tipo}"
				else
					puts "Error: Esperaba lado derecho de la expresion de tipo #{@op2.tipo} pero recibi una expresion de tipo #{tipo}"
				end # Error, no es del tipo esperado
				exit
			end
		else
			if @op1.tipo != @op2.tipo
				puts ErrorTipos.new(@oper,@op1,@op2) # Error, los tipos no concuerdan
				exit
			end
		end

		@tipo="boolean"
		#return oper1 != oper2
	end
end

class OpMenor
	def check(padre,tipo=nil)
		
		oper1 = @op1.check(padre,tipo)
		oper2 = @op2.check(padre,tipo)
		
		if tipo != nil
			if @op1.tipo != tipo || @op2.tipo != tipo
				if @op1.tipo != tipo
					puts "Error: Esperaba lado izquierdo de la expresion de tipo #{@op1.tipo} pero recibi una expresion de tipo #{tipo}"
				else
					puts "Error: Esperaba lado derecho de la expresion de tipo #{@op2.tipo} pero recibi una expresion de tipo #{tipo}"
				end # Error, no es del tipo esperado
				exit
			end
		else
			if @op1.tipo != @op2.tipo
				puts ErrorTipos.new(@oper,@op1,@op2) # Error, los tipos no concuerdan
				exit
			end
		end

		@tipo="boolean"
		#return oper1 < oper2
	end
end

class OpMenorIgual
	def check(padre,tipo=nil)
		
		oper1 = @op1.check(padre,tipo)
		oper2 = @op2.check(padre,tipo)
		
		if tipo != nil
			if @op1.tipo != tipo || @op2.tipo != tipo
				if @op1.tipo != tipo
					puts "Error: Esperaba lado izquierdo de la expresion de tipo #{@op1.tipo} pero recibi una expresion de tipo #{tipo}"
				else
					puts "Error: Esperaba lado derecho de la expresion de tipo #{@op2.tipo} pero recibi una expresion de tipo #{tipo}"
				end # Error, no es del tipo esperado
				exit
			end
		else
			if @op1.tipo != @op2.tipo
				puts ErrorTipos.new(@oper,@op1,@op2) # Error, los tipos no concuerdan
				exit
			end
		end

		@tipo="boolean"
		#return oper1 <= oper2
	end
end

class OpMayor
	def check(padre,tipo=nil)
		
		oper1 = @op1.check(padre,tipo)
		oper2 = @op2.check(padre,tipo)
		
		if tipo != nil
			if @op1.tipo != tipo || @op2.tipo != tipo
				if @op1.tipo != tipo
					puts "Error: Esperaba lado izquierdo de la expresion de tipo #{@op1.tipo} pero recibi una expresion de tipo #{tipo}"
				else
					puts "Error: Esperaba lado derecho de la expresion de tipo #{@op2.tipo} pero recibi una expresion de tipo #{tipo}"
				end
				exit
			end
		else
			if @op1.tipo != @op2.tipo
				puts ErrorTipos.new(@oper,@op1,@op2) # Error, los tipos no concuerdan
				exit
			end
		end	

		@tipo="boolean"
		#return oper1 > oper2
	end
end

class OpMayorIgual
	def check(padre,tipo=nil)

		oper1 = @op1.check(padre,tipo)
		oper2 = @op2.check(padre,tipo)
		
		if tipo != nil
			if @op1.tipo != tipo || @op2.tipo != tipo
				if @op1.tipo != tipo
					puts "Error: Esperaba lado izquierdo de la expresion de tipo #{@op1.tipo} pero recibi una expresion de tipo #{tipo}"
				else
					puts "Error: Esperaba lado derecho de la expresion de tipo #{@op2.tipo} pero recibi una expresion de tipo #{tipo}"
				end # Error, no es del tipo esperado
				exit
			end
		else
			if @op1.tipo != @op2.tipo
				puts ErrorTipos.new(@oper,@op1,@op2) # Error, los tipos no concuerdan
				exit
			end
		end

		@tipo="boolean"
		#return oper1 >= oper2
	end
end

class OpAnd
	def check(padre,tipo=nil)

		oper1 = @op1.check(padre,tipo)
		oper2 = @op2.check(padre,tipo)
		
		if tipo != nil
			if @op1.tipo != tipo || @op2.tipo != tipo
				if @op1.tipo != tipo
					puts "Error: Esperaba lado izquierdo de la expresion de tipo #{@op1.tipo} pero recibi una expresion de tipo #{tipo}"
				else
					puts "Error: Esperaba lado derecho de la expresion de tipo #{@op2.tipo} pero recibi una expresion de tipo #{tipo}"
				end # Error, no es del tipo esperado
				exit
			end
		else
			if @op1.tipo != @op2.tipo
				puts ErrorTipos.new(@oper,@op1,@op2) # Error, los tipos no concuerdan
				exit
			end
		end
		
		@tipo="boolean"
		#return oper1 && oper2
	end
end

class OpOr
	def check(padre,tipo=nil)
		
		oper1 = @op1.check(padre,tipo)
		oper2 = @op2.check(padre,tipo)

		if tipo != nil
			if @op1.tipo != tipo || @op2.tipo != tipo
				if @op1.tipo != tipo
					puts "Error: Esperaba lado izquierdo de la expresion de tipo #{@op1.tipo} pero recibi una expresion de tipo #{tipo}"
				else
					puts "Error: Esperaba lado derecho de la expresion de tipo #{@op2.tipo} pero recibi una expresion de tipo #{tipo}"
				end # Error, no es del tipo esperado
				exit
			end
		else
			if @op1.tipo != @op2.tipo
				puts ErrorTipos.new(@oper,@op1,@op2) # Error, los tipos no concuerdan
				exit
			end
		end

		@tipo="boolean"
		#return oper1 || oper2
	end
end

class OpMINUS
	def check(padre,tipo=nil)
		oper = @op.check(padre,tipo)
		if tipo != nil
			if @tipo != tipo
				puts "Error: Esperaba una expresion del tipo #{tipo} pero recibi una expresion de tipo #{tipo}." # Error, los tipos no concuerdan con el solicitado
				exit
			end
		else
			if @op.tipo != @tipo
				puts ErrorTipoUnario.new(@oper,@tipo).to_s() # Error, los tipos son distintos
				exit
			end
		end

		#return -(oper)
	end
end

class OpNot
	def check(padre,tipo=nil)
		oper = @op.check(padre,tipo)
		if tipo != nil
			if @tipo != tipo
				puts "Error: Esperaba una expresion del tipo #{tipo} pero recibi una expresion de tipo #{tipo}." # Error, los tipos no concuerdan con el solicitado
				exit
			end
		else
			if @op.tipo != @tipo
				puts ErrorTipoUnario.new(@oper,@tipo).to_s() # Error, los tipos son distintos
				exit
			end
		end

		#return !(oper)
	end
end

class LlamadaFuncion
	def check(padre, tipo=nil)
		
		if not(padre.check_func_exists(@id.id.to_s()))
			puts "Error: Función #{@id.id} no declarada." # Error, función no declarada
			exit
		end

		if tipo != nil
			if not(padre.check_func_var_type(@id.id.to_s(), tipo, 'return'))
				puts "Error: El tipo de return no coincide con el esperado." # Error, los tipos no coinciden con el esperado
				exit
			end
		end

		if @parametros != nil
			@parametros.check(padre, 0, @id.id.to_s())
		else
			if padre.check_func_var_pos(@id.id.to_s(), 0.to_s)
				puts "Error: Faltan argumentos." # Faltan argumentos
				exit
			end
		end

		@tipo = padre.get_func_var_type( @id.id.to_s(), 'return')

	end
end

class ListaPaseParametros
	def check(padre, pos, func)	# Padre tiene la lista de los parametros de la funcion en cuestión

		@parametro.check( padre, nil )

		if !padre.check_func_var_type(func, @parametro.tipo, pos.to_s)
			puts "Error: Esperaba un parametro de tipo #{padre.get_func_var_type(func, pos.to_s)} pero el tipo recibido es #{@parametro.tipo}" # Error en los tipos 
			exit
		elsif @lista == nil && padre.check_func_var_pos(func, (pos.to_i+1).to_s)
			puts "Error: Faltan argumentos." # Faltan argumentos
			exit
		end

		if @lista != nil
			@lista.check(padre,(pos+1).to_s, func)
		end
	end
end

class LiteralNumerico
	def check(padre,tipo=nil)
	end

	def get_valor()
		if /^\d+$/.match(@valor.token)				# Si no tiene decimales
			return @valor.token.to_i
		elsif /^\d*[.]?\d*$/.match(@valor.token)	# Si tiene decimales
			return @valor.token.to_f
		end
	end
end

class LiteralBooleano
	def check(padre,tipo=nil)
	end

	def get_valor()
		if @valor.token == "true"
			return true
		else
			return false
		end
	end
end