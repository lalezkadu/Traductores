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

class Instruccion
end

class Estructura < Instruccion
end

class Condicional < Instruccion
end

class Asignacion < Instruccion
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

class Alcance
end

class Funcion
end

class Tipo
end

class TipoNum < Tipo
end

class TipoBoolean < Tipo
end

class Literal
end

class LiteralNumerico < Literal
end

class LiteralBooleano < Literal
end

class Variable
end

class ExpresionBinaria
end

class ExpresionUnaria
end

class Entrada
end

class Salida
end

class Identificador
end