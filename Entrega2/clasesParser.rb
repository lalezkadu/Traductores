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

class AST
end

class Programa
end

class Estructura
end

class Funcion
end

class Parametros
end

class Declaracion
end

class Instruccion
end

class Condicional < Instruccion
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
end

class RepeticionD < Instruccion
end

class Bloque < Instruccion
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

	def toString(tabs)
		out = 

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
end

class Entrada
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
end

class OpMultiplicacion < ExpresionBinaria
end

class OpSuma < ExpresionBinaria
end

class OpResta < ExpresionBinaria
end

class OpDivision < ExpresionBinaria
end

class OpMod < ExpresionBinaria
end

class OpDiv < ExpresionBinaria
end

class OpModE < ExpresionBinaria
end

class OpEquivalente < ExpresionBinaria
end

class OpInequivalente < ExpresionBinaria
end

class OpMenor < ExpresionBinaria
end

class OpMenorIgual < ExpresionBinaria
end

class OpMayor < ExpresionBinaria
end

class OpMayorIgual < ExpresionBinaria
end

class OpAnd < ExpresionBinaria
end

class OpOr < ExpresionBinaria
end

class ExpresionUnaria
end

class OpUMINUS < ExpresionUnaria
end

class OpNot < ExpresionUnaria
end