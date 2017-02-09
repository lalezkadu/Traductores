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
		return "Estructura: \n" + " funciones: \n" + @funciones.to_s(2) + " programa: \n" + @programa.to_s(2)
	end
end

class Funcion
	attr_accessor :nombre, :parametros, :instrucciones, :tipo, :funcion

	def initialize(nombre, parametros, instrucciones, tipo = "", funcion = "")
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
		if @tipo != ""
			s << (" "*tab) + "retorna: " + @tipo.to_s(tab+1)
		end
		if @funcion != ""
			s << @funcion.to_s(tab)
		end
		return s
	end
end

class Parametros
	attr_accessor :tipo, :id, :parametros

	def initialize(tipo, id, parametros = "")
		@tipo = tipo
		@id = id
		@instrucciones = instrucciones
	end

	def to_s(tab)
		s = "Parametro:\n"
		s << (" "*tab) + "tipo: " + @tipo.to_s(tab+1)
		s << (" "*tab) + "id: " + @id.to_s(tab+1)
		if @parametros != ""
			s << @parametros.to_s(tab)
		end
		return s
	end
end

class Programa
	attr_accessor :bloque

	def initialize(bloque)
		@bloque = bloque
	end

	def to_s(tab)
		return "Programa:\n" + (" "*tab) + "bloques:\n" + @bloque.to_s(tab+1)
	end
end

class Bloque
	attr_accessor :declaraciones, :instrucciones

	def initialize(declaraciones, instrucciones)
		@declaraciones = declaraciones
		@instrucciones = instrucciones
	end

	def to_s(tab)
		return "Bloque:\n" + (" "*tab) + "declaraciones:\n" + @declaraciones.to_s(tab+1) + (" "*tab) + "instrucciones:\n" @instrucciones.to_s(tab+1)
	end
end


class Declaracion
	attr_accessor :tipo, :ids, :declaraciones

	def initialize(tipo, ids, declaraciones = "")
		@tipo = tipo
		@ids = ids
		@declaraciones = declaraciones
	end

	def to_s(tab)
		s = "Declaracion: \n"
		s << (" "*tab) + @tipo.to_s(tab+1)
		s << (" "*tab) + @ids.to_s(tab+1)
		if declaraciones != ""
			s << @declaraciones.to_s(tab)
		end
		return s
	end

end

class ListaID
	attr_accessor :id, :var

	def initialize(id, var = "")
		@id = id
		@var = var
	end

	def to_s(tab)
		s = "Identificador: \n"
		s << (" "*tab) + "Nombre: " + @id.to_s()
		if var != ""
			s << @var.to_s(tab)
		end
		return s
	end
	
end

class Instruccion
end

class Condicional < Instruccion
	attr_accessor :exp, :instif, :instelse

	def initialize(exp,instif,instelse)

		@instelse = instelse
	end
end

class Asignacion < Instruccion
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

class RepeticionI < Instruccion
	attr_accessor :exp, :cuerpo

	def initialize(exp, cuerpo)
		@exp = exp
		@cuerpo = cuerpo
	end

	def to_s(tab)
		s = "Repeticion Indeterminada: \n"
		s << (" "*tab) + "expresion: \n" + @exp.to_s(tab+1)
		s << (" "*tab) + "cuerpo: \n" + @cuerpo.to_s(tab+1)
	end
end

class Repeat

	attr_accessor :repeticiones, :cuerpo

	def initialize(repeticiones, cuerpo)
		@repeticiones = repeticiones
		@cuerpo = cuerpo
	end

	def to_s(tab)
		s = "Repeticion Determinada Repeat: \n"
		s << (" "*tab) + "numero repeticiones: \n" + @repeticiones.to_s(tab+1)
		s << (" "*tab) + "cuerpo: \n" + @cuerpo.to_s(tab+1)
	end
end

class For
	attr_accessor :var, :inicio, :fin, :paso, :cuerpo

	def initialize(var, inicio, fin, paso, cuerpo)
		@var = var
		@inicio = inicio
		@fin = fin
		@paso = paso
		@cuerpo = cuerpo
	end

	def to_s(tab)
		s = "Repeticion Determinada For: \n"
		s << (" "*tab) + "iterador: \n" + (" "*tab) + @var.to_s(tab+1) 
		s << (" "*tab) + "limite inferior: 1\n" + @inicio.to_s(tab+1)
		s << (" "*tab) + "limite superior: \n" + @fin.to_s(tab+1)
		s << (" "*tab) + "paso: \n" + @paso.to_s(tab+1)
		s << (" "*tab) + "cuerpo: \n" + @cuerpo.to_s(tab+1)
	end
end

class Declaraciones
end

class ListaExpresiones < Instruccion
end

class Secuenciacion < ListaExpresiones
end

class Tipo

	attr_accessor :tipo

	def initialize( tipo )
		@tipo = tipo
	end

	def to_s(tab)
		return "Tipo: \n" + (" "*tab) + "nombre: " + @tipo.to_s()
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
		return @tipo + (" "*tab) + "valor: " + @valor.to_s()
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

class Entrada < Instruccion

	attr_accessor :var
    def initialize(var)
        @var = var
    end

    def to_s(tab)
    	return "Entrada: \n" (" "*tab) + @var.to_s(tab+1)
    end
end

class Salida < Instruccion

	attr_accessor :tipo, :lista

	def initialize(tipo, lista)
		@tipo = tipo
        @lista = lista
    end

    def to_s(tab)
    	aux = ""
    	if @tipo == "LN"
    		aux = "Salida con salto de linea: \n"
    	else
    		aux = "Salida: \n"
    	end 
    	return aux + (" "*tab) + @lista.to_s(tab+1)
    end
end

class Identificador
	attr_accessor :id

	def initialize( id )
		super(id)
	end

	def to_s(tab)
		return "Identificador: \n" + (" "*tab) + "nombre: " + @id.to_s()
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
		return @oper + ": \n" + (" " * tab) + "lado izquierdo: \n" + @op1.to_s(tab+1) + "\n" + (" " * tab) + "lado derecho: \n" + @op2.to_s(tab+1)
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
		return @oper + ": \n" + (" " * tab) + "lado derecho: \n" + @op.to_s(tab+1)
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