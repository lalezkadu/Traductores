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
			s << " funciones: \n" + @funciones.to_s(2) 
		end
		s << " programa: \n" + @programa.to_s(2)
		return s + "\n"
	end
end

class Funcion
	attr_accessor :nombre, :parametros, :instrucciones, :tipo, :funcion

	def initialize(funcion, nombre, parametros, instrucciones, tipo)
		@nombre = nombre
		@parametros = parametros
		@instrucciones = instrucciones
		@tipo = tipo
		@funcion = funcion
	end

	def to_s(tab)
		s = "Funcion: \n"
		s << (" "*tab) + "nombre: " + @nombre.to_s()
		s << (" "*tab) + "parametros: \n" + @parametros.to_s(tab+1)
		s << (" "*tab) + "instrucciones: \n" +@instrucciones.to_s(tab+1)
		if @tipo != nil
			s << (" "*tab) + "retorna: " + @tipo.to_s(tab+1)
		end
		if @funcion != nil
			s << @funcion.to_s(tab)
		end
		return s + "\n"
	end
end

class Parametros
	attr_accessor :tipo, :id, :parametros

	def initialize(tipo, id, parametros)
		@tipo = tipo
		@id = id
		@instrucciones = instrucciones
	end

	def to_s(tab)
		s = "Parametro:\n"
		s << (" "*tab) + "tipo: " + @tipo.to_s(tab+1)
		s << (" "*tab) + "id: " + @id.to_s(tab+1)
		if @parametros != nil
			s << @parametros.to_s(tab)
		end
		return s + "\n"
	end
end

class Programa
	attr_accessor :bloque

	def initialize(bloque)
		@bloque = bloque
	end

	def to_s(tab)
		return "Programa:\n" + (" "*tab) + "bloques:\n" + @bloque.to_s(tab+1) + "\n"
	end
end

class Bloque
	attr_accessor :declaraciones, :instrucciones

	def initialize(declaraciones, instrucciones)
		@declaraciones = declaraciones
		@instrucciones = instrucciones
	end

	def to_s(tab)
		s = "Bloque:\n" 
		s << (" "*tab) + "declaraciones:\n" + @declaraciones.to_s(tab+1) 
		s << (" "*tab) + "instrucciones:\n" + @instrucciones.to_s(tab+1)
		return s + "\n"
	end
end

class Lista_Declaraciones
	attr_accessor :declaracion, :declaraciones

	def initialize(declaraciones, declaracion)
		@declaracion = declaracion
		@declaraciones = declaraciones
	end

	def to_s(tab)
		s = "Lista de declaraciones: \n"
		s << (" "*tab) + @declaracion
		return s + "\n"
	end
end

class Declaracion
	attr_accessor :tipo, :declaracion

	def initialize(tipo, declaracion)
		@tipo = tipo
		@declaracion = declaracion
	end

	def to_s(tab)
		s = "Declaracion: \n"
		s << (" "*tab) + @tipo.to_s(tab+1)
		s << (" "*tab) + "identificadores:\n" + @declaracion.to_s(tab+1)
		return s + "\n"
	end

end

class Identificador
	attr_accessor :id, :var

	def initialize(id, var)
		@id = id
		@var = var
	end

	def to_s(tab)
		s = "Identificador: \n"
		s << (" "*tab) + "nombre: " + @id.to_s()
		if var != nil
			s << @var.to_s(tab)
		end
		return s + "\n"
	end
	
end

class Secuenciacion
	attr_accessor :secuencia

	def initialize(secuencia)
		@secuencia = secuencia
	end

	def to_s(tab)
		s = "Secuencia de instrucciones: \n"
		s << (" "*tab) + @secuencia.to_s(tab+1)
		return s + "\n"
	end
end

class Instruccion
	attr_accessor :instruccion, :instrucciones

	def initialize(instrucciones, instruccion)
		@instruccion = instruccion
		@instrucciones = instrucciones
	end

	def to_s(tab)
		s = "Instruccion:\n"
		s << (" "*tab) + @instruccion.to_s(tab+1)
		if instrucciones != nil
			s << @instrucciones.to_s(tab)
		end
		return s + "\n"
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
		s = "Condicional:\n"
		s << (" "*tab) + "Instrucciones TRUE:\n" + @instif.to_s(tab+1)
		if instelse != nil
			s << (" "*tab) + "Instrucciones FALSE:\n" + @instelse.to_s(tab+1)
		end
		return s + "\n"
	end
end

class RepeticionI
	attr_accessor :condicion, :instrucciones

	def initialize(condicion, instrucciones)
		@condicion = condicion
		@instrucciones = instrucciones
	end

	def to_s(tab)
		s = "Repeticion Indeterminada: \n"
		s << (" "*tab) + "condicion: \n" + @exp.to_s(tab+1)
		s << (" "*tab) + "instrucciones: \n" + @instrucciones.to_s(tab+1)
		return s + "\n"
	end
end

class Repeat

	attr_accessor :repeticiones, :instrucciones

	def initialize(repeticiones, instrucciones)
		@repeticiones = repeticiones
		@instrucciones = instrucciones
	end

	def to_s(tab)
		s = "Repeticion Determinada Repeat: \n"
		s << (" "*tab) + "numero de repeticiones: \n" + @repeticiones.to_s(tab+1)
		s << (" "*tab) + "instrucciones: \n" + @instrucciones.to_s(tab+1)
		return s + "\n"
	end
end

class For
	attr_accessor :id, :inicio, :fin, :paso, :instrucciones

	def initialize(id, inicio, fin, paso = 1, instrucciones)
		@id = id
		@inicio = inicio
		@fin = fin
		@paso = paso
		@instrucciones = instrucciones
	end

	def to_s(tab)
		s = "Repeticion Determinada For: \n"
		s << (" "*tab) + "iterador: " + @id.to_s()

		if @inicio.is_a? Numeric
			s << (" "*tab) + "limite inferior: " + @inicio.to_s()
		else
			s << (" "*tab) + "limite inferior: \n" + @inicio.to_s(tab+1)
		end

		if @fin.is_a? Numeric
			s << (" "*tab) + "limite superior: " + @fin.to_s()
		else
			s << (" "*tab) + "limite superior: \n" + @fin.to_s(tab+1)
		end

		if @paso.is_a? Numeric
			s << (" "*tab) + "paso: " + @paso.to_s()
		else
			s << (" "*tab) + "paso: \n" + @paso.to_s(tab+1)
		end
		s << (" "*tab) + "instrucciones: \n" + @instrucciones.to_s(tab+1)
		return s + "\n"
	end
end

class Entrada
	attr_accessor :id

    def initialize(id)
        @id = id
    end

    def to_s(tab)
    	return "Entrada: \n" + (" "*tab) + @id.to_s(tab+1) + "\n"  
    end
end

class Salida 

	attr_accessor :tipo, :ids

	def initialize(ids, tipo)
		@tipo = tipo
        @ids = ids
    end

    def to_s(tab)
    	s = ""
    	if @tipo != nil
    		s = "Salida con salto de linea: \n"
    	else
    		s = "Salida: \n"
    	end 
    	s << (" "*tab) + "impresiones: \n" + @ids.to_s(tab+1)
    	return s + "\n"
    end
end

class Escribir
	attr_accessor :expresion, :cadenas

	def initialize(cadenas = nil, expresion)
		@expresion = expresion
		@cadenas = cadenas
	end

	def to_s(tab)
		s = "Impresion: "
		if expresion.is_a? String
			s << (" "*tab) + "objeto: " + @expresion
		else
			s << (" "*tab) + "objeto: \n" + @expresion.to_s(tab+1)
		end

		if cadenas != nil
			s << (" "*tab) + @cadenas.to_s(tab)
		end

		return s + "\n"
	end
end

class ExpresionBinaria
	attr_accessor :op1, :op2, :oper
	def initialize(op1, op2, oper)
		@op1 = op1
		@op2 = op2
		@oper = oper
	end

	def to_s()
		s = @oper + ": \n" 
		s << (" " * tab) + "lado izquierdo: \n" + @op1.to_s(tab+1)
		s << (" " * tab) + "lado derecho: \n" + @op2.to_s(tab+1)
		return s + "\n"
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

class OpDiv < ExpresionBinaria
    def initialize(op1,op2)
        super(op1, op2,"Div")
    end
end

class OpModE < ExpresionBinaria
    def initialize(op1,op2)
        super(op1, op2,"Mod")
    end
end

class OpEquivalente < ExpresionBinaria
    def initialize(op1,op2)
        super(op1, op2,"Equivalente")
    end
end

class OpInequivalente < ExpresionBinaria
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

	def to_s()
		return @oper + ": \n" + (" " * tab) + "lado derecho: \n" + @op.to_s(tab+1) + "\n"
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

class Tipo

	attr_accessor :tipo

	def initialize( tipo )
		@tipo = tipo
	end

	def to_s(tab)
		return "Tipo: \n" + (" "*tab) + "nombre: " + @tipo.to_s() + "\n"
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
		return @tipo + (" "*tab) + "valor: " + @valor.to_s() + "\n"
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