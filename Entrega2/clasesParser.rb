#!/usr/bin/ruby
# = clasesParser.rb
#
# Autor:: Lalezka Duque, 12-10613
# Autor:: Marcos Jota, 12-10909
#
# == Descripcion
#
# Archivo que contiene todas las clases del Arbol Sintactico mediante el  
# analizador sintactico generado por Racc.

# == Clase Estructura
#
# Clase que representa el nodo de la estructura del programa 
class Estructura

	# == Atributos
	#
	# funciones: Secuencia de funciones definidas en el programa
	# programa: Bloque de instrucciones del programa
	attr_accessor :funciones, :programa

	def initialize(funciones, programa)
		@funciones = funciones
		@programa = programa
	end

	def to_s()
		s = ""
		if @funciones != nil || @programa != nil
			s = "Estructura: \n" 
			if @funciones != nil
				s << "  funciones: \n" + @funciones.to_s(4) 
			end
			if @programa != nil
				s << "  programa: \n" + @programa.to_s(4)
			end
		end
		return s
	end
end

# == Clase ListaFunciones
#
# Clase que representa al nodo de la lista de funciones
class ListaFunciones

	# == Atributos
	#
	# funciones:
	# funcion:
	attr_accessor :funciones, :funcion

	def initialize(funciones, funcion)
		@funciones = funciones
		@funcion = funcion
	end

	def to_s(tab)
		s = (" "*tab) + "Lista de funciones:\n"
		s << @funcion.to_s(tab+2)
		if @funciones != nil
			s << @funciones.to_s(tab+2)
		end
		return s
	end

end

# == Clase Funcion
#
# Clase que representa el nodo de una funcion
class Funcion

	# == Atributos
	#
	# nombre: Identificador de la funcion
	# parametros: Parametros de la funcion
	# instrucciones: Secuencia de instrucciones del cuerpo de la funcion
	# tipo: Tipo de dato del retorno de la funcion
	attr_accessor :nombre, :parametros, :instrucciones, :tipo

	def initialize(nombre, parametros, tipo, instrucciones)
		@nombre = nombre
		@parametros = parametros
		@instrucciones = instrucciones
		@tipo = tipo
	end

	def to_s(tab)
		s =  (" "*tab) + "Funcion: \n"
		s << (" "*(tab+2)) + "nombre: \n" + @nombre.to_s(tab+4)
		if parametros != nil
			s << (" "*(tab+2)) + "parametros: \n" + @parametros.to_s(tab+4)
		else
			s << (" "*(tab+2)) + "parametros: \n"
		end
		if @tipo != nil
			s << (" "*(tab+2)) + "retorna: \n" + @tipo.to_s(tab+4)
		end
		s << (" "*(tab+2)) + "instrucciones: \n" + @instrucciones.to_s(tab+4)
		return s
	end
end

# == Clase Parametros
#
# Clase que representa al nodo de los parametros de una funcion
class Parametros

	# == Atributos
	#
	# tipo: Tipo de dato del parametro
	# id: identificador del parametro
	# parametros: Lista de parametros
	attr_accessor :tipo, :id, :parametros

	def initialize(tipo, id, parametros)
		@tipo = tipo
		@id = id
		@parametros = parametros
	end

	def to_s(tab)
		s = (" "*tab) + "Parametro:\n"
		s << (" "*(tab+2)) + "tipo: \n" + @tipo.to_s(tab+4)
		s << (" "*(tab+2)) + "id: \n" + @id.to_s(tab+4)
		if @parametros != nil
			s << @parametros.to_s(tab)
		end
		return s
	end
end

# == Clase Programa
#
# Clase que representa al nodo de un programa
class Programa

	# == Atributos
	#
	# bloque: bloque a ejecutar del programa
	attr_accessor :bloque

	def initialize(bloque)
		@bloque = bloque
	end

	def to_s(tab)
		if bloque != nil
			return (" "*tab) + "Programa:\n" + (" "*(tab+2)) + "bloques:\n" + @bloque.to_s(tab+4)
		else
			return ""
		end
	end
end

# == Clase Bloque
#
# Clase que representa al nodo de un programa
class Bloque

	# == Atributos
	#
	# declaraciones: Declaraciones del bloque.
	# instrucciones: Instrucciones a ejecutar en el bloque
	attr_accessor :declaraciones, :instrucciones

	def initialize(declaraciones = nil, instrucciones)
		@declaraciones = declaraciones
		@instrucciones = instrucciones
	end

	def to_s(tab)
		s = (" "*tab) + "Bloque:\n" 
		if declaraciones != nil
			s << (" "*(tab+2)) + "declaraciones:\n" + @declaraciones.to_s(tab+4) 
		else
			s << (" "*(tab+2)) + "declaraciones:\n"			
		end
		s << (" "*(tab+2)) + "instrucciones:\n" + @instrucciones.to_s(tab+4)
		return s
	end
end

# == Clase ListaDeclaracion
#
# Clase que represeenta al nodo de una lista de declaracione
class ListaDeclaracion

	# == Atributos
	#
	# declaracion: Declaracion
	# declaraciones: Lista de declaraciones
	attr_accessor :declaracion, :declaraciones

	def initialize(declaraciones, declaracion)
		@declaracion = declaracion
		@declaraciones = declaraciones
	end

	def to_s(tab)
		s = ""
		if @declaraciones != nil
			s << @declaraciones.to_s(tab)
		end
		s << @declaracion.to_s(tab)
		return s
	end
end

# == Clase Declaracion
#
# Clase que representa al nodo de una declaracion
class Declaracion

	# == Atributos
	#
	# tipo: Tipo de dato de la declaracion
	# declaracion: Declaracion del identificador
	attr_accessor :tipo, :declaracion

	def initialize(tipo, declaracion)
		@tipo = tipo
		@declaracion = declaracion
	end

	def to_s(tab)
		s = (" "*tab) + "Declaracion: \n"
		s << (" "*(tab+2)) + "tipo: \n" + @tipo.to_s(tab+4) 
		s << (" "*(tab+2)) + "identificadores:\n" + @declaracion.to_s(tab+4)
		return s
	end
end

# == Clase ListaId
#
# Clase que representa al nodo de una lista de identificadores
class ListaId

	# == Atributos
	#
	# id: Identificador
	# ids: Lista de identificadores
	attr_accessor :id, :ids

	def initialize(ids,id)
		@ids = ids
		@id = id
	end

	def to_s(tab)
		s = ""
		if ids != nil
			s << @ids.to_s(tab)
		end
		s << @id.to_s(tab+2)
		return s
	end
end

# == Clase Identificador
#
# Clase que representa al nodo de un identificador
class Identificador

	# == Atributos
	#
	# id: Identificador a almacenar
	attr_accessor :id

	def initialize(id)
		@id = id
	end

	def to_s(tab)
		s = (" "*tab) + "Identificador: \n"
		s << (" "*(tab+2)) + "nombre: " + @id.to_s()
		return s + "\n"
	end
end

# == Clase Instrucciones
#
# Clase que representa al nodo de una secuencia de instrucciones
class Instrucciones

	# == Atributos
	#
	# instruccion:
	# instrucciones: 
	attr_accessor :instruccion, :instrucciones

	def initialize(instrucciones, instruccion)
		@instruccion = instruccion
		@instrucciones = instrucciones
	end

	def to_s(tab)
		s = ""
		if instrucciones != nil
			s << @instrucciones.to_s(tab)
		end
		s << (" "*tab) + "Instruccion: \n"
		if instruccion != nil
			s << @instruccion.to_s(tab+2)
		end
		return s
	end
end

# == Clase Return
#
# Clase que representa el nodo de la instruccion retorno de una funcion
class Return

	# == Atributos
	#
	# expresion: Expresion que retorna una funcion
	attr_accessor :expresion

	def initialize(expresion)
		@expresion = expresion
	end

	def to_s(tab)
		s = (" "*tab) + "Retorna: \n"
		s << (" "*(tab+2)) + "expresion: \n" + @expresion.to_s(tab+4)
		return s
	end
end

# == Clase Condicional
#
# Clase que representa al nodo de una instruccion condicional
class Condicional

	# == Atributos
	#
	# condicion: Expresion de tipo boolean a verificar
	# instif: Secuencia de instrucciones a ejecutar si condicion es true
	# instelse: Secuencia de instrucciones a ejecutar si condicion es false
	attr_accessor :condicion, :instif, :instelse

	def initialize(condicion, instif, instelse)
		@condicion = condicion
		@instif	= instif
		@instelse = instelse
	end

	def to_s(tab)
		s = (" "*tab) + "Condicional:\n"
		s << (" "*(tab+2)) + "instrucciones If:\n" + @instif.to_s(tab+4)
		if instelse != nil
			s << (" "*(tab+2)) + "instrucciones Else:\n" + @instelse.to_s(tab+4)
		end
		return s
	end
end

# == Clase RepeticionI
#
# Clase que representa al nodo de la instruccion iteracion while
class RepeticionI

	# == Atributos
	#
	# condicion: Expresion de tipo boolean que determina la ejecucion
	# instrucciones: Secuencia de instrucciones del cuerpo de la iteracion
	attr_accessor :condicion, :instrucciones

	def initialize(condicion, instrucciones)
		@condicion = condicion
		@instrucciones = instrucciones
	end

	def to_s(tab)
		s = (" "*tab) + "Repeticion Indeterminada: \n"
		s << (" "*(tab+2)) + "condicion: \n" + @condicion.to_s(tab+4)
		s << (" "*(tab+2)) + "instrucciones: \n" + @instrucciones.to_s(tab+4)
		return s
	end
end

# == Clase Repeat
#
# Nodo que representa al nodo de la instruccion de iteracion repeat
class Repeat

	# == Atributos
	#
	# repeticiones: Expresion del tipo number del numero de iteraciones
	# instrucciones: Secuencia de instrucciones del cuerpo de la iteracion
	attr_accessor :repeticiones, :instrucciones

	def initialize(repeticiones, instrucciones)
		@repeticiones = repeticiones
		@instrucciones = instrucciones
	end

	def to_s(tab)
		s = (" "*tab) + "Repeticion Determinada Repeat: \n"
		s << (" "*(tab+2)) + "numero de repeticiones: \n" + @repeticiones.to_s(tab+4)
		s << (" "*(tab+2)) + "instrucciones: \n" + @instrucciones.to_s(tab+4)
		return s
	end
end

# == Clase For
# 
# Clase que representa a la clase de una instruccion de iteracion for.
class For

	# == Atributos
	#
	# id: identificador que  a la iteracion
	# inicio: Expresion de tipo number que identifica el inicio de la iteracion
	# fin: Expresion de tipo number que identifica el fin de la iteracion
	# paso: Expresion de tipo number del incremento del contador de la iteracion
	# instrucciones: Secuencia de instrucciones del cuerpo de la iteracion
	attr_accessor :id, :inicio, :fin, :paso, :instrucciones

	def initialize(id, inicio, fin, paso, instrucciones)
		@id = id
		@inicio = inicio
		@fin = fin
		if paso == nil
			@paso = LiteralNumerico.new(1)
		else
			@paso = paso
		end
		@instrucciones = instrucciones
	end

	def to_s(tab)
		s = (" "*tab) + "Repeticion Determinada For: \n"
		s << (" "*(tab+2)) + "iterador: \n" + @id.to_s(tab+4)
		s << (" "*(tab+2)) + "limite inferior: \n" + @inicio.to_s(tab+4)
		s << (" "*(tab+2)) + "limite superior: \n" + @fin.to_s(tab+4)
		s << (" "*(tab+2)) + "paso: \n" + @paso.to_s(tab+4)
		s << (" "*(tab+2)) + "instrucciones: \n" + @instrucciones.to_s(tab+4)
		return s
	end
end

# == Clase Entrada
#
# Clase que representa al nodo a la instruccion de lectura
class Entrada

	# == Atributos
	#
	# id: Identificador en el cual se almacena la lectura
	attr_accessor :id

    def initialize(id)
        @id = id
    end

    def to_s(tab)
    	return (" "*tab) + "Entrada: \n" + @id.to_s(tab+2) + "\n"  
    end
end

# == Clase Salida
#
# Clase que representa al nodo a la instruccion de salida
class Salida 

	# == Atributos
	#
	#
	attr_accessor :expresion, :cadenas

	def initialize(cadenas, expresion)
		@expresion = expresion
        @cadenas = cadenas
    end

    def to_s(tab)
    	s = ""
    	if @expresion != nil
    		s = (" "*tab) + "Salida con salto de linea: \n"
    	else
    		s = (" "*tab) + "Salida: \n"
    	end 
    	s << (" "*(tab+2)) + "impresiones: \n" + @cadenas.to_s(tab+4)
    	return s
    end
end

# == Clase Escribir
#
# Clase que representa al nodo de las expresiones o strings que se escriben en
# la salida
class Escribir

	# == Atributos
	#
	# 
	#
	attr_accessor :expresion, :cadenas

	def initialize(cadenas = nil, expresion)
		@expresion = expresion
		@cadenas = cadenas
	end

	def to_s(tab)
		s = ""
		if cadenas != nil
			s << @cadenas.to_s(tab)
		end
		s << (" "*tab) + "Impresion: \n"
		s << (" "*(tab+2)) + "objeto: \n" + @expresion.to_s(tab+4)
		return s
	end
end

# == Clase Str
#
# Clase que representa al nodo de un string
class Str

	# == Atributos
	#
	# str: string a almacenar
	attr_accessor :str

	def initialize(str)
		@str = str
	end

	def to_s(tab)
		s = (" "*tab) + "String: " + @str.to_s() + "\n"
	end
end

# == Clase ExpresionBinaria
#
#
class ExpresionBinaria

	# == Atributos
	#
	#
	attr_accessor :op1, :op2, :oper

	def initialize(op1, op2, oper)
		@op1 = op1
		@op2 = op2
		@oper = oper
	end

	def to_s(tab)
		s = (" "*tab) + @oper + ": \n" 
		s << (" "*(tab+2)) + "lado izquierdo: \n" + @op1.to_s(tab+4)
		s << (" "*(tab+2)) + "lado derecho: \n" + @op2.to_s(tab+4)
		return s
	end
end

# == Clase Asignacion
#
#
class Asignacion < ExpresionBinaria

    def initialize(id, expresion)
        super(id, expresion, "Asignacion")
    end
end

# == Clase OpMultiplicacion
#
#
class OpMultiplicacion < ExpresionBinaria

    def initialize(op1,op2)
        super(op1, op2,"Multiplicacion")
    end
end

# == Clase OpSuma
#
#
class OpSuma < ExpresionBinaria

    def initialize(op1,op2)
        super(op1, op2,"Suma")
    end
end

# == Clase OpResta
#
#
class OpResta < ExpresionBinaria

    def initialize(op1,op2)
        super(op1, op2,"Resta")
    end
end

# == Clase OpDivision
#
#
class OpDivision < ExpresionBinaria

    def initialize(op1,op2)
        super(op1, op2,"Division")
    end
end

# == Clase OpMod
#
#
class OpMod < ExpresionBinaria

    def initialize(op1,op2)
        super(op1, op2,"Mod")
    end
end

# == Clase OpDivisionE
#
#
class OpDivisionE < ExpresionBinaria

    def initialize(op1,op2)
        super(op1, op2,"Division Exacta")
    end
end

# == Clase OpModE
#
#
class OpModE < ExpresionBinaria

    def initialize(op1,op2)
        super(op1, op2,"Mod Exacto")
    end
end

# == Clase OpEquivalente
#
#
class OpEquivalente < ExpresionBinaria

    def initialize(op1,op2)
        super(op1, op2,"Equivalente")
    end
end

# == Clase OpDesigual
#
#
class OpDesigual < ExpresionBinaria

    def initialize(op1,op2)
        super(op1, op2,"Desigual")
    end
end

# == Clase OpMenor
#
#
class OpMenor < ExpresionBinaria

    def initialize(op1,op2)
        super(op1, op2,"Menor que")
    end
end

# == Clase OpMenorIgual
#
#
class OpMenorIgual < ExpresionBinaria

    def initialize(op1,op2)
        super(op1, op2,"Menor o igual que")
    end
end

# == Clase OpMayor
#
#
class OpMayor < ExpresionBinaria

    def initialize(op1,op2)
        super(op1, op2,"Mayor que")
    end
end

# == Clase OpMayoIgual
#
#
class OpMayorIgual < ExpresionBinaria

    def initialize(op1,op2)
        super(op1, op2,"Mayor o igual que")
    end
end

# == Clase OpAnd
#
#
class OpAnd < ExpresionBinaria

    def initialize(op1,op2)
        super(op1, op2,"And")
    end
end

# == Clase OpOr
#
#
class OpOr < ExpresionBinaria

    def initialize(op1,op2)
        super(op1, op2,"Or")
    end
end

# == Clase ExpresionUnaria
#
#
class ExpresionUnaria

	# == Atributos
	#
	#
	attr_accessor :op, :oper

	def initialize(op, oper)
		@op = op
		@oper = oper
	end

	def to_s(tab)
		return (" "*tab) + @oper + ": \n" + (" "*(tab+2)) + "lado derecho: \n" + @op.to_s(tab+4)
	end
end

# == Clase OpMinus
#
#
class OpUMINUS < ExpresionUnaria

    def initialize(op)
        super(op,"UMINUS")
    end
end

class OpNot < ExpresionUnaria

	def initialize(op)
        super(op,"Not")
    end
end

# == Clase LlamadaFuncion
#
#
class LlamadaFuncion

	# == Atributos
	#
	#
	attr_accessor :id, :parametros

	def initialize(id, parametros)
		@id = id
		@parametros = parametros
	end

	def to_s(tab)
		puts @id.to_s(0)
		s = (" "*tab) + "Llamada a funcion: \n"
		s << (" "*(tab+2)) + "nombre: \n" + @id.to_s(tab+4)
		if @parametros != nil
			s << (" "*(tab+2)) + "parametros: \n" + @parametros.to_s(tab+4)
		else
			s << (" "*(tab+2)) + "parametros: \n"
		end
		return s
	end
end

# == Clase ListaParametros
#
#
class ListaPaseParametros

	# == Atributos
	#
	#
	attr_accessor :lista, :parametro

	def initialize(lista = nil, parametro)
		@lista = lista
		@parametro = parametro
	end

	def to_s(tab)
		s = ""
		if lista != nil
			s << @lista.to_s(tab)
		end
		s << (" "*tab) + "Parametro: \n"
		s << @parametro.to_s(tab+2)
		return s
	end
end

# == Clase Tipo
#
#
class Tipo

	# == Atributos
	#
	#
	attr_accessor :tipo

	def initialize( tipo )
		@tipo = tipo
	end

	def to_s(tab)
		return (" "*tab) + "Tipo: \n" + (" "*(tab+2)) + "nombre: " + @tipo.to_s() + "\n"
	end
end

# == Clase TipoNum
#
#
class TipoNum < Tipo

	def initialize()
		super("number")
	end
end

# == Clase TipoBoolean
#
#
class TipoBoolean < Tipo

	def initialize()
		super("boolean")
	end
end

# == Clase Literal
#
#
class Literal

	# == Atributos
	#
	#
	attr_accessor :valor, :tipo

	def initialize(valor, tipo)
		@valor = valor
		@tipo = tipo
	end

	def to_s(tab)
		return (" "*tab) + @tipo.to_s() + (" "*(tab+2)) + "valor: " + @valor.to_s() + "\n"
	end
end

# == Clase LiteralNumerico
#
#
class LiteralNumerico < Literal

	def initialize(valor)
		super(valor, "Literal numerico: \n")
	end
end

# == Clase LiteralBooleano
#
#
class LiteralBooleano < Literal

	def initialize(valor)
		super(valor, "Literal booleano: \n")
	end
end