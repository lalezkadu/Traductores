require_relative 'clasesParser'
require_relative 'lexer'
require_relative 'imagen'

# Clase de la tabla

class SymTable
	attr_accessor :tabla, :nombre, :padre, :funciones, :instrucciones, :valores

	def initialize(nombre, funciones, padre=nil, tabla=Hash.new, instrucciones=nil, valores=Hash.new)
		@tabla = tabla
		@nombre = nombre
		@padre = padre
		@funciones = funciones
		@instrucciones = instrucciones
		
		@valores = valores
		if @padre != nil
			@valores = @valores.merge!(@padre.valores)
		end
	end

	def add_sym(key, value)

		if self.check_var_exists(key)
			puts ErrorDeclaracion.new(key).to_s()
		else
			@tabla[key] = value
		end

	end

	def set_value(key, value)
		@valores[key] = value
	end

	def get_valor(key)
		if @valores.has_key? key
			return @valores[key]
		else
			puts ErrorDeclaracion.new(key).to_s()
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
			puts "Error: Función #{key.id} no declarada." # Error, función no declarada
			exit
		end
	end

	def get_func_var_type(key, pos)
		if self.check_func_var_pos(key, pos)
			return @funciones[key].tabla[pos]
		else
			puts "Error: Hay mas argumentos de los esperados en la funcion #{key}."
			exit
		end
	end

	def check_func_var_type(key, type, pos)
		if self.check_func_var_pos(key, pos)
			return @funciones[key].tabla[pos] == type
		else
			puts "Error: Hay mas argumentos de los esperados en la funcion #{key}."
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

		func_home = SymTable.new	nombre='home', 
									funciones=@tablafunciones, 
									padre=nil,
									tabla={ 'return'=>nil }	# Agregar las instrucciones necesarias....
		
		func_openeye = SymTable.new nombre='openeye', 
									funciones=@tablafunciones, 
									padre=nil,
									tabla={ 'return'=>nil }	# Agregar las instrucciones necesarias....
		
		func_closeeye = SymTable.new	nombre='closeeye', 
										funciones=@tablafunciones, 
										padre=nil,
										tabla={ '0'=>'number', 'return'=>nil }	# Agregar las instrucciones necesarias....
		
		func_forward = SymTable.new nombre='forward', 
									funciones=@tablafunciones, 
									padre=nil,
									tabla={ '0'=>'number', 'return'=>nil }	# Agregar las instrucciones necesarias....
		
		func_backward = SymTable.new	nombre='backward', 
										funciones=@tablafunciones, 
										padre=nil,
										tabla={ '0'=>'number', 'return'=>nil }	# Agregar las instrucciones necesarias....
		
		func_rotatel = SymTable.new nombre='rotatel', 
									funciones=@tablafunciones, 
									padre=nil,
									tabla={ '0'=>'number', 'return'=>nil } # Agregar las instrucciones necesarias....
		
		func_rotater = SymTable.new nombre='rotater', 
									funciones=@tablafunciones, 
									padre=nil,
									tabla={ '0'=>'number', 'return'=>nil }	# Agregar las instrucciones necesarias....
		
		func_setposition = SymTable.new nombre='setposition', 
										funciones=@tablafunciones, 
										padre=nil,
										tabla={ '0'=>'number', '1'=>'number', 'return'=>nil }	# Agregar las instrucciones necesarias....
		
		func_arc = SymTable.new 	nombre='arc', 
									funciones=@tablafunciones, 
									padre=nil,
									tabla={ '0'=>'number', '1'=>'number', 'return'=>nil }	# Agregar las instrucciones necesarias....

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

		@tabla = SymTable.new 	nombre="Estructura", 
								funciones=@tablafunciones, 
								padre=nil,
								tabla={ 'return'=>nil }

		if @programa != nil
			@programa.check(@tabla)
		end
	end

	def ejecutar(nombre_imagen)
		imagen = Imagen.new(nombre_imagen)
		if @programa != nil
			@programa.ejecutar(imagen,@tabla)
		end
		imagen.generarImagen
	end
end

class ListaFunciones
	def check(padre)
		@funcion.check(padre)
		if @funciones != nil
			@funciones.check(padre) # Si existe una lista de funciones continuo agregando
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
		@tabla= SymTable.new 	nombre=@nombre.id.to_s(), 
								funciones=padre, 
								padre=padre, 
								tabla=Hash.new, 
								instrucciones=@instrucciones, 
								valores=Hash.new # Las funciones son padre, porque está sobre el hash de las funciones
							# Considerar si es mejor poner @instrucciones o self

		if @tipo
			@tabla.add_sym('return', @tipo.tipo.to_s)
		else
			@tabla.add_sym('return', nil)
		end

		padre[@nombre.id.to_s()] = @tabla

		if @parametros != nil
			@parametros.check(@tabla,0)	# Obtenemos las variables
		end

		if @instrucciones != nil 			# Agregar a tabla
			@instrucciones.check(@tabla)	# Para futuras instrucciones desarrollamos la función
			if @instrucciones.instruccion.instance_of? Return 	# Verificar que el tipo de retorno es correcto
				if @tipo != nil
					if @instrucciones.instruccion.expresion.tipo.to_s != @tipo.tipo.to_s
						puts "Error: El tipo del valor de retorno de la funcion #{@nombre.id} es de tipo #{@instrucciones.instruccion.expresion.tipo} pero debe ser de tipo #{@tipo.tipo}."
						exit
					end
				else
					puts "Error: La funcion #{@nombre.id} no debe retornar valores."
					exit
				end
			end
		end

	end

	def ejecutar(imagen, tabla)
		if @instrucciones != nil
			@instrucciones.ejecutar(imagen, tabla)
		end
	end
end

class Parametros
	def check(tabla,pos)
		if !(tabla.check_var_exists(@id.id.to_s()))
			tabla.add_sym(pos.to_s, @tipo.tipo)
			tabla.add_sym(@id.id.to_s(), @tipo.tipo)
			@id.tipo = @tipo.tipo
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
		
		@tabla= SymTable.new 	nombre="Programa", 
								funciones=padre.funciones, 
								padre=padre, 
								tabla=Hash.new, 
								instrucciones=@instrucciones, 
								valores=Hash.new	# Considerar si es mejor poner a self o @instrucciones
		
		if @instrucciones != nil
			@instrucciones.check(@tabla)
			if @instrucciones.instruccion.instance_of? Return
				puts "Error: Solo se puede usar la instruccion return en funciones."
				exit
			end
		end
	end

	def ejecutar(imagen, tabla)
		if @instrucciones != nil
			@instrucciones.ejecutar(imagen, tabla)
		end
	end
end

class Bloque	## Este señor imprime Variables. 
	def check(padre)

		@tabla =SymTable.new 	nombre="Bloque", 
								funciones=padre.funciones, 
								padre=padre, 
								tabla=Hash.new, 
								instrucciones=@instrucciones, 
								valores=Hash.new	# Considerar si es mejor poner a self o @instrucciones

		if @declaraciones != nil
			@declaraciones.check(@tabla)	# Pasan la lista de variables
		end

		if @instrucciones != nil
			@instrucciones.check(@tabla)
		end
	end

	def ejecutar(imagen, tabla)
		# Agregar valores a la tabla
		if @declaraciones != nil
			@declaraciones.ejecutar(imagen,tabla)
		end

		if @instrucciones != nil
			@instrucciones.ejecutar(imagen, tabla)
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

	def ejecutar(imagen, tabla) 	# Falta tabla
		@declaracion.ejecutar(imagen,tabla)

		if @declaraciones != nil
			@declaraciones.ejecutar(imagen,tabla)
		end
	end
end

class Declaracion
	def check(padre)	# Padre está referenciando a las variables
		@declaracion.check(padre,@tipo.to_s)
	end

	def ejecutar(imagen, tabla)	# Falta tabla
		@declaracion.ejecutar(imagen,tabla)
	end
end

class ListaId
	def check(padre, tipo)	# Padre referencia a las variables
		@id.check(padre, tipo)

		if @ids != nil
			@ids.check(padre, tipo)
		end
	end

	def ejecutar(imagen, tabla)
		if @id.tipo == "number"
			tabla.valores[@id.to_s] = 0
		elsif @id.tipo == "boolean"
			tabla.valores[@id.to_s] = false
		end
		if @ids != nil
			@ids.ejecutar(imagen,tabla)
		end
		#puts tabla.valores
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
			padre.add_sym(@id.to_s(), tipo)
		end
	end

	def get_valor(tabla) 		# Falta tabla
		return tabla.valores[@id.to_s]
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

	def ejecutar(imagen,tabla)
		if @instrucciones != nil
			@instrucciones.ejecutar(imagen, tabla)
		end
		if @instruccion != nil
			@instruccion.ejecutar(imagen, tabla)
		end
	end
end

class Return
	def check(padre)
		@expresion.check(padre)
	end

	def ejecutar(imagen, tabla)
		return @expresion.get_valor(tabla)
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

	def ejecutar(imagen, tabla)
		if @condicion.get_valor(tabla)
			if @instif != nil
				@instif.ejecutar(imagen, tabla)
			end
		else
			if @instelse != nil
				@instelse.ejecutar(imagen, tabla)
			end
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

	def ejecutar(imagen, tabla)
		condicion = @condicion.get_valor(tabla)
		while condicion
			if @instrucciones != nil
				@instrucciones.ejecutar(imagen, tabla)
			end
			condicion = @condicion.get_valor(tabla)
		end
	end
end

class Repeat
	def check(padre)

		@tabla = SymTable.new 	nombre="Repeat", 
								funciones=padre.funciones, 
								padre=padre, 
								tabla=Hash.new, 
								instrucciones=@instrucciones, 
								valores=Hash.new	# Considerar si es mejor poner a self o @instrucciones

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

	def ejecutar(imagen, tabla)				# Falta la tabla
		repeticiones = @repeticiones.get_valor(@tabla)
		if repeticiones > 0
			for i in (1..repeticiones)
				tabla.valores[@repeticiones.id.to_s] = i
				if @instrucciones != nil
					@instrucciones.ejecutar(imagen, @tabla)
				end
			end
		else
			puts "Error Dinamico: Rango invalido para iteracion repeat."
			exit
		end
	end
end

class For
	def check(padre)

		@tabla = SymTable.new 	nombre="For", 
								funciones=padre.funciones, 
								padre=padre, 
								tabla=Hash.new, 
								instrucciones=@instrucciones, 
								valores=Hash.new	# Considerar si es mejor poner a self o @instrucciones

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

	def ejecutar(imagen, tabla)
		id = @id.id.to_s()		# Falta declarar y asiganr valor de id para la tabla de valores de los hijos
		inicio = @inicio.get_valor(tabla)
		fin = @fin.get_valor(tabla)
		if @paso != nil
			paso = @paso.get_valor(tabla)
		end
		i = inicio
		tabla.valores[id] = i
		if inicio <= fin
			if paso == nil
				for i in (inicio..fin)	# Falta declarar y asignar valor de i para la tabla de valores para los hijos
					tabla.valores[id] = i
					if @instrucciones != nil
						@instrucciones.ejecutar(imagen, tabla)
					end
				end
			else
				for i in (inicio..fin).step(paso)	# Falta declarar y asignar valor de i para la tabla de valores para los hijos
					tabla.valores[id] = i
					if @instrucciones != nil
						@instrucciones.ejecutar(imagen, tabla)
					end
				end
			end
		else
			puts "Error Dinamico: Rango invalido para la iteracion for."
			exit
		end
	end
end

class Entrada
	def check(tabla)
		@id.check(tabla)
	end

	def ejecutar(image, tabla)
		e = $stdin.gets.chomp
		if @id.tipo == "number"
			if /^\d+$|^\d*[.]?\d*$/.match(e)
				tabla.valores[@id.id] = e
			else
				puts "Error Dinamico: El tipo de la entrada de la instruccion read es invalido, se esperaba un valor de tipo number."
				exit
			end
		elsif @id.tipo == "boolean"
			if /^".*"$/.match(e)
				tabla.valores[@id.id] = e
			else
				puts "Error Dinamico: El tipo de la entrada de la instruccion read es invalido, se esperaba un valor de tipo boolean."
				exit
			end
		end	
    end
end

class Salida 
	def check(tabla)
		if impresiones != nil
			@impresiones.check(tabla)
		end
	end

	def ejecutar(imagen, tabla)
		if @salto == "SALTO"						# writeln
			str = @impresiones.ejecutar(imagen, tabla)
			puts str
		else 										# write
			str = @impresiones.ejecutar(imagen, tabla)
			print str
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

	def ejecutar(imagen, tabla)
		str = ""
		if impresiones != nil
			str << @impresiones.get_valor(tabla).to_s
		end
		
		if not(@expresion.is_a? String)
			str << @expresion.get_valor(tabla).to_s
		end
		return str
	end

	def get_valor(tabla)
		str = ""
		
		if impresiones != nil
			str << @impresiones.get_valor(tabla).to_s
		end
		str << @expresion.get_valor(tabla).to_s
		return str
	end
end

class Str
	def check(tabla)
		nil #return @str.to_s
	end

	def get_valor(tabla)
		return @str.token[1..(@str.token.length-2)] # Para quitar las comillas
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

class Asignacion
	def check(padre, tipo=nil)
		@op1.check(padre, tipo)
		@op2.check(padre, tipo)

		puts padre.valores

		if tipo != nil
			padre.set_value(@op1.id.to_s(), @op2.get_valor(padre.tabla))
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

	def ejecutar(imagen, tabla)
		tabla.valores[@op1.id.to_s] = @op2.get_valor(tabla)
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
	end

	def get_valor(tabla)
		return @op1.get_valor(tabla) * @op2.get_valor(tabla)
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
	end

	def get_valor(tabla)
		return @op1.get_valor(tabla) + @op2.get_valor(tabla)
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
	end

	def get_valor(tabla)
		return @op1.get_valor(tabla) - @op2.get_valor(tabla)
	end
end

class OpDivision 
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
	end

	def get_valor(tabla)
		oper2 = @op2.get_valor(tabla)
		if oper2 != 0
			return @op1.get_valor(tabla) / oper2
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
	end

	def get_valor(tabla)
		oper2 = @op2.get_valor(tabla)
		if @op2 != 0
			return @op1.get_valor(tabla) % oper2
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
	end

	def get_valor(tabla)
		oper2 = @op2.get_valor(tabla).to_i
		if oper2 != 0
			return @op1.get_valor(tabla).to_i / oper2
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
	end

	def get_valor(tabla)
		oper2 = @op2.get_valor(tabla).to_i
		if oper2 != 0
			return @op1.get_valor(tabla).to_i % oper2
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
	end

	def get_valor(tabla)
		return @op1.get_valor(tabla) == @op2.get_valor(tabla)
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
	end

	def get_valor(tabla)
		return @op1.get_valor(tabla) != @op2.get_valor(tabla)
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
	end

	def get_valor(tabla)
		return @op1.get_valor(tabla) < @op2.get_valor(tabla)
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
	end

	def get_valor(tabla)
		return @op1.get_valor(tabla) <= @op2.get_valor(tabla)
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
	end

	def get_valor(tabla)
		return @op1.get_valor(tabla) > @op2.get_valor(tabla)
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
	end

	def get_valor(tabla)
		return @op1.get_valor(tabla) >= @op2.get_valor(tabla)
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
	end

	def get_valor(tabla)
		return @op1.get_valor(tabla) && @op2.get_valor(tabla)
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
	end

	def get_valor(tabla)
		return @op1.get_valor(tabla) || @op2.get_valor(tabla)
	end
end

class OpUMINUS
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

		@tipo = "number"
	end

	def get_valor(tabla)
		return -(@op.get_valor(tabla))
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

		@tipo = "boolean"
	end

	def get_valor(tabla)
		return !(@op.get_valor(tabla))
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
				puts "Error: El tipo de return de la funcion #{@id.id} no coincide con el esperado." # Error, los tipos no coinciden con el esperado
				exit
			end
		end

		if @parametros != nil
			@parametros.check(padre, 0, @id.id.to_s())
		else
			if padre.check_func_var_pos(@id.id.to_s(), 0.to_s)
				puts "Error: Faltan argumentos en la llamada de la funcion de #{@id.id}." # Faltan argumentos
				exit
			end
		end

		@tipo = padre.get_func_var_type( @id.id.to_s(), 'return')
	end

	def ejecutar(imagen, tabla)
		if @id.id.to_s == "home"
			imagen.home()
		elsif @id.id.to_s == "setposition"
			imagen.setposition(@parametros.parametro.get_valor(tabla),@parametros.lista.get_valor(tabla))
		elsif @id.id.to_s == "rotater"
			imagen.rotater(@parametros.parametro.get_valor(tabla))
		elsif @id.id.to_s == "rotatel"
			imagen.rotatel(@parametros.parametro.get_valor(tabla))
		elsif @id.id.to_s == "forward"
			imagen.forward(@parametros.parametro.get_valor(tabla))
		elsif @id.id.to_s == "backward"
			imagen.backward(@parametros.parametro.get_valor(tabla))
		elsif @id.id.to_s == "openeye"
			imagen.openeye()
		elsif @id.id.to_s == "closeeye"
			imagen.closeeye()
		else
			# para preguntar por el return algo.class.to_s == la clase que quiero
			# COMO LLAMAR A LA FUNCION :C
		end	
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

	def get_valor(tabla)
		return @parametro.get_valor(tabla)
	end
end

class LiteralNumerico
	def check(padre,tipo=nil)
	end

	def get_valor(tabla)
		if @valor.instance_of? Fixnum
			return @valor
		elsif /^\d+$/.match(@valor.token)				# Si no tiene decimales
			return @valor.token.to_i
		elsif /^\d*[.]?\d*$/.match(@valor.token)	# Si tiene decimales
			return @valor.token.to_f
		end
	end

	def ejecutar()
		return self.get_valor(nil)
	end
end

class LiteralBooleano
	def check(padre,tipo=nil)
	end

	def get_valor(tabla)
		if @valor == "true"
			return true
		else
			return false
		end
	end

	def ejecutar()
		return self.get_valor(nil)
	end
end