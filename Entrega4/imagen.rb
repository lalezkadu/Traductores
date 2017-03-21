#!/usr/bin/env ruby

class Imagen
	attr_accessor :tam_ancho, :tam_alto, :plano, :x, :y, :sentido, :pintar, :programa
	def initialize(programa="archivo")
		@programa = programa
		@tam_ancho = 11
		@tam_alto = 11
		@plano = Array.new(@tam_ancho) { Array.new(@tam_alto) { 0 } }
		self.home()
		@plano[@y][@x] = 1
		@sentido = 90
		self.openeye()
	end

	def home()
		@x = @tam_ancho/2
		@y = @tam_alto/2
	end

	def openeye()
		@pintar = true
	end

	def closeeye()
		@pintar = false
	end

	def forward(pasos)
		if pasos < 0
			backward(pasos.abs)
		else
			#implementar forward
		end
	end

	def backward(pasos)	
		if pasos < 0
			forward(pasos.abs)
		else
			#implementar backward
		end
	end

	def arc(grado,radio)
	end

	def rotatel(grado)
		aux = @sentido + grado
	end

	def rotater(grado)
		aux = @sentido - grado
	end

	def setposition(x,y)
		@x = x
		@y = y
	end

	def genPbm()
		File.open(@programa+'.pbm', 'w') do |f2|
			f2.puts "P1"
			f2.puts "#{@tam_ancho} #{@tam_alto}"
  			@tam_alto.times do |i|
  				s = ""
				@tam_ancho.times do |j|
					s << @plano[i][j].to_s + " "
				end
				f2.puts s
			end
		end
	end

	def to_s
		@tam_alto.times do |i|
			@tam_ancho.times do |j|
				print @plano[i][j].to_s + " "
			end
			print "\n"
		end
	end
end

x = Imagen.new()
x.genPbm