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

class Estructura
	attr_accessor :funciones, :programa

	def initialize(funciones, programa)
		@funciones = funciones
		@programa = programa
	end

	def to_s()
		s = "Estructura: \n" 
		if @funciones != nil
			s << "  funciones: \n" + @funciones.to_s(4) 
		end
		s << "  programa: \n" + @programa.to_s(4)
		return s
	end
end

class ListaFunciones
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


class Funcion
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

class Parametros
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

class Parametro
	attr_accessor :tipo, :id

	def initialize(tipo,id)
		@tipo = tipo
		@id = id
	end

	def to_s(tab)
		s = (" "*tab) + "Parametro:\n"
		s << (" "*(tab+2)) + "tipo: \n" + @tipo.to_s(tab+4)
		s << (" "*(tab+2)) + "id: \n" + @id.to_s(tab+4)
		return s
	end
end
class Programa
	attr_accessor :bloque

	def initialize(bloque)
		@bloque = bloque
	end

	def to_s(tab)
		return (" "*tab) + "Programa:\n" + (" "*(tab+2)) + "bloques:\n" + @bloque.to_s(tab+4)
	end
end

class Bloque
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

class ListaDeclaracion
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

class Declaracion
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

class ListaId
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

class Identificador
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

class Instruccion
	attr_accessor :secuencia

	def initialize(secuencia)
		@secuencia = secuencia
	end

	def to_s(tab)
		s = (" "*tab) + "Instruccion: \n" #"Secuenciacion: \n"
		s << @secuencia.to_s(tab+2)
		return s
	end
end

class Instrucciones
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
		s << (" "*tab) + "Instruccion: \n"  #"Instruccion:\n"
		s << @instruccion.to_s(tab+2)
		return s
	end
end

class Return
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

class Condicional
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

class RepeticionI
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

class Repeat

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

class For
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

class Entrada
	attr_accessor :id

    def initialize(id)
        @id = id
    end

    def to_s(tab)
    	return (" "*tab) + "Entrada: \n" + @id.to_s(tab+2) + "\n"  
    end
end

# NO SIRVEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE <- Ahora si....
class Salida 

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
 
# NOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO <- Tambien... 
class Escribir
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

		return s + "\n"
	end
end

# NOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
class Str
	attr_accessor :str

	def initialize(str)
		@str = str
	end

	def to_s(tab)
		s = (" "*tab) + "string: " + @str.to_s()
	end
end

class ExpresionBinaria
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

class Asignacion < ExpresionBinaria
    def initialize(id, expresion)
        super(id, expresion, "Asignacion")
    end
end

class OpMultiplicacion < ExpresionBinaria
    def initialize(op1,op2)
        super(op1, op2,"Multiplicacion")
    end
end

class OpSuma < ExpresionBinaria
    def initialize(op1,op2)
        super(op1, op2,"Suma")
    end
end

class OpResta < ExpresionBinaria
    def initialize(op1,op2)
        super(op1, op2,"Resta")
    end
end

class OpDivision < ExpresionBinaria
    def initialize(op1,op2)
        super(op1, op2,"Division")
    end
end

class OpMod < ExpresionBinaria
    def initialize(op1,op2)
        super(op1, op2,"Mod")
    end
end

class OpDivisionE < ExpresionBinaria
    def initialize(op1,op2)
        super(op1, op2,"Division Exacta")
    end
end

class OpModE < ExpresionBinaria
    def initialize(op1,op2)
        super(op1, op2,"Mod Exacto")
    end
end

class OpEquivalente < ExpresionBinaria
    def initialize(op1,op2)
        super(op1, op2,"Equivalente")
    end
end

class OpDesigual < ExpresionBinaria
    def initialize(op1,op2)
        super(op1, op2,"Desigual")
    end
end

class OpMenor < ExpresionBinaria
    def initialize(op1,op2)
        super(op1, op2,"Menor que")
    end
end

class OpMenorIgual < ExpresionBinaria
    def initialize(op1,op2)
        super(op1, op2,"Menor o igual que")
    end
end

class OpMayor < ExpresionBinaria
    def initialize(op1,op2)
        super(op1, op2,"Mayor que")
    end
end

class OpMayorIgual < ExpresionBinaria
    def initialize(op1,op2)
        super(op1, op2,"Mayor o igual que")
    end
end

class OpAnd < ExpresionBinaria
    def initialize(op1,op2)
        super(op1, op2,"And")
    end
end

class OpOr < ExpresionBinaria
    def initialize(op1,op2)
        super(op1, op2,"Or")
    end
end

class ExpresionUnaria
	attr_accessor :op, :oper
	def initialize(op, oper)
		@op = op
		@oper = oper
	end

	def to_s(tab)
		return (" "*tab) + @oper + ": \n" + (" "*(tab+2)) + "lado derecho: \n" + @op.to_s(tab+4)
	end
end

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

class LlamadaFuncion
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

class ListaPaseParametros
	attr_accessor :lista, :parametro

	def initialize( lista = nil, parametro)
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

class Tipo

	attr_accessor :tipo

	def initialize( tipo )
		@tipo = tipo
	end

	def to_s(tab)
		return (" "*tab) + "Tipo: \n" + (" "*(tab+2)) + "nombre: " + @tipo.to_s() + "\n"
	end
end

class TipoNum < Tipo
	def initialize()
		super("number")
	end
end

class TipoBoolean < Tipo
	def initialize()
		super("boolean")
	end
end

class Literal
	attr_accessor :valor, :tipo

	def initialize(valor, tipo)
		@valor = valor
		@tipo = tipo
	end

	def to_s(tab)
		return (" "*tab) + @tipo.to_s() + (" "*(tab+2)) + "valor: " + @valor.to_s() + "\n"
	end
end

class LiteralNumerico < Literal

	def initialize(valor)
		super(valor, "Literal numerico: \n")
	end
end

class LiteralBooleano < Literal
	def initialize(valor)
		super(valor, "Literal booleano: \n")
	end
end