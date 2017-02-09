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

	# Reglas para reconocer llamadas a funciones
	LLAMADA
		: ID '(' ')'
		| ID '(' EXPRESION ')'
		| ID '(' LISTA_ID ')'
		;

class AST
end

class Estructura
	attr_accessor :funciones, :programa

	def initialize(funciones, programa)
		@funciones = funciones
		@programa = programa

	end

	def toString()
	end

end

class Funcion
	attr_accessor :parametros, :tipoReturn, :instrucciones

	def initialize(parametros, tipoReturn, instrucciones)
		@parametros = parametros
		@tipoReturn = tipoReturn
		@instrucciones = instrucciones
	end
end

class Parametros
	attr_accessor :tipo, :id, :parametros

	def initialize(tipo, id, parametros)
		@tipo = tipo
		@tipoReturn = tipoReturn
		@instrucciones = instrucciones
	end

end

class Programa
	attr_accessor :bloque

	def initialize(bloque)
		@bloque = bloque
	end

end

class Bloque
	attr_accessor :declaracion, :instrucciones

	def initialize(declaracion, instrucciones)
		@declaracion = declaracion
		@instrucciones = instrucciones
	end
end

class Declaracion
	attr_accessor :tipo, :var

	def initialize(tipo, var)
		@tipo = tipo
		@var = var
	end
end

class ListaID
	attr_accessor :id, :var

	def initialize(id, var)
		@id = id
		@var = var
	end
	
end

class Instruccion
end

class Condicional < Instruccion
	attr_accessor :exp, :instif, :instelse 
end

class Asignacion < Instruccion
    attr_accessor :id, :valor

    def initialize(id, val)
        @id = id
        @valor = valor
    end
end

class EntradaSalida < Instruccion
end

class RepeticionI < Instruccion
	attr_accessor :exp, :inst
end

class RepeticionD < Instruccion
	attr_accessor :var, :inicio, :fin, :inc, :inst 
end

class Declaraciones
end

class ListaExpresiones < Instruccion
end

class Secuenciacion < ListaExpresiones
end

class Tipo

	attr_accessor :nombre

	def initialize( nombre )
		@nombre = nombre
	end
end

class TipoNum < Tipo
	def initialize( nombre )
		super(nombre)
	end
end

class TipoBoolean < Tipo
	def initialize( nombre )
		super(nombre)
	end
end

class Literal

end

class LiteralNumerico < Literal
end

class LiteralBooleano < Literal
end

class Variable

	attr_accessor :id

	def initialize(id)
		@id = id
	end
end

class Entrada

	attr_accessor :var
    def initialize(var)
        @var = var
    end
end

class Salida

	attr_accessor :lista

	def initialize(lista)
        @lista = lista
    end
end

class Identificador
	
	attr_accessor :id

	def initialize( id )
		super(id)
	end
end

class ExpresionBinaria
	attr_accessor :op1, :op2, :oper
	def initialize(op1, op2, oper)
		@op1 = op1
		@op2 = op2
		@oper = oper
	end
end

class OpMultiplicacion < ExpresionBinaria
    def initialize(op1,op2)
        super(op1, op2,"*")
    end
end

class OpSuma < ExpresionBinaria
    def initialize(op1,op2)
        super(op1, op2,"+")
    end
end

class OpResta < ExpresionBinaria
    def initialize(op1,op2)
        super(op1, op2,"-")
    end
end

class OpDivision < ExpresionBinaria
    def initialize(op1,op2)
        super(op1, op2,"/")
    end
end

class OpMod < ExpresionBinaria
    def initialize(op1,op2)
        super(op1, op2,"mod")
    end
end

class OpDiv < ExpresionBinaria
    def initialize(op1,op2)
        super(op1, op2,"div")
    end
end

class OpModE < ExpresionBinaria
    def initialize(op1,op2)
        super(op1, op2,"%")
    end
end

class OpEquivalente < ExpresionBinaria
    def initialize(op1,op2)
        super(op1, op2,"==")
    end
end

class OpInequivalente < ExpresionBinaria
    def initialize(op1,op2)
        super(op1, op2,"/=")
    end
end

class OpMenor < ExpresionBinaria
    def initialize(op1,op2)
        super(op1, op2,"<")
    end
end

class OpMenorIgual < ExpresionBinaria
    def initialize(op1,op2)
        super(op1, op2,"<=")
    end
end

class OpMayor < ExpresionBinaria
    def initialize(op1,op2)
        super(op1, op2,">")
    end
end

class OpMayorIgual < ExpresionBinaria
    def initialize(op1,op2)
        super(op1, op2,">=")
    end
end

class OpAnd < ExpresionBinaria
    def initialize(op1,op2)
        super(op1, op2,"and")
    end
end

class OpOr < ExpresionBinaria
    def initialize(op1,op2)
        super(op1, op2,"or")
    end
end

class ExpresionUnaria
	attr_accessor :op
	def initialize(op)
		@op = op
	end
end

class OpUMINUS < ExpresionUnaria
    def initialize(op)
        super(op,"-")
    end
end

class OpNot < ExpresionUnaria
	def initialize(op1)
        super(op1, op2,"-")
    end
end

class Estructura
	attr_accessor :funciones, :programa

	def initialize(funciones,programa)
		@funciones = funciones
		@programa = programa
	end

	def to_s(tab)
		return @funciones.to_s(tab+1) + @programa.to_s(tab+1)
	end
end

class Operacion		# PARA FUTURA INTEGRACION COMO PADRE DE LOS DEMAS
	attr_accessor :operIzq, :operador, :operDer

	def initialize(operIzq, operador, operDer)
		@operIzq = operIzq
		@operador = operador
		@operDer = operDer
	end

end

class Asignacion < ExpresionBinaria
    attr_accessor :id, :valor

    def initialize(id, val)
        @id = id
        @valor = valor
    end

    def to_s(tab)
    	s = "Asignacion: \n"
    	s << (" "*tab) + "lado derecho: \n" + @id.to_s(tab+1)
    	s << (" "*tab) + "lado izquierdo: \n" + @valor.to_s(tab+1)
    end
end

class Identificador 	# ????????????????????????????????????
	attr_accessor :id

	def initialize( id )
		super(id)
	end

	def to_s(tab)
		return "Identificador: \n" + (" "*tab) + "nombre: " + @id.to_s()
	end
end