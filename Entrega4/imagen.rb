#!/usr/bin/env ruby

class Imagen
	attr_accessor :tam_ancho, :tam_alto, :plano, :x, :y, :sentido, :pintar
	def initialize()
		@tam_ancho = 11
		@tam_alto = 11
		@plano = Array.new(@tam_ancho) { Array.new(@tam_alto) { 0 } }
		self.home()
		@plano[@y][@x] = 1
		@sentido = 0
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
		if @sentido == 0			# Norte
			aux = 0
			(0..pasos).each do |i|
				aux = @y - i
				if (aux >= 0)
					if @pintar
						@plano[aux][@x] = 1
					end
				end
			end
			self.setposition(@x,aux)
		elsif @sentido == 1			# Noroeste
			auxX = 0
			auxY = 0
			(0..pasos).each do |i|
				auxX = @x-i
				auxY = @y-i
				if (auxX >= 0) && (auxY >= 0)
					if @pintar
						@plano[auxY][auxX] = 1
					end
				end
			end
			self.setposition(auxX,auxY)
		elsif @sentido == 2			# Oesta
			aux = 0
			(0..pasos).each do |i|
				aux = @x-i
				if (aux >= 0)
					if @pintar
						@plano[@y][aux] = 1
					end
				end
			end
			self.setposition(aux,@y)
		elsif @sentido == 3			# Suroeste
			auxX = 0
			auxY = 0
			(0..pasos).each do |i|
				auxX = @x-i
				auxY = @y+i
				if (auxX >= 0) && (auxY < @tam_alto)
					if @pintar
						@plano[auxY][auxX] = 1
					end
				end
			end
			self.setposition(auxX,auxY)
		elsif @sentido == 4			# Sur
			aux = 0
			(0..pasos).each do |i|
				aux = @y + i
				if (aux < @tam_alto)
					if @pintar
						@plano[aux][@x] = 1
					end
				end
			end
			self.setposition(@x,aux)
		elsif @sentido == 5			# Sureste
			auxX = 0
			auxY = 0
			(0..pasos).each do |i|
				auxX = @x+i
				auxY = @y+i
				if (auxX < @tam_ancho) && (auxY < @tam_alto)
					if @pintar
						@plano[auxY][auxX] = 1
					end
				end
			end
			self.setposition(auxX,auxY)
		elsif @sentido == 6			# Este
			aux = 0
			(0..pasos).each do |i|
				aux = @x+i
				if (aux < @tam_ancho)
					if @pintar
						@plano[@y][aux] = 1
					end
				end
			end
			self.setposition(aux,@y)
		elsif @sentido == 7			# Noreste
			auxX = 0
			auxY = 0
			(0..pasos).each do |i|
				auxX = @x+i
				auxY = @y-i
				if (auxX < @tam_ancho) && (auxY >= 0)
					if @pintar
						@plano[auxY][auxX] = 1
					end
				end
			end
			self.setposition(auxX,auxY)
		end	
	end

	def backward(pasos)	
		if @sentido == 0		# Norte
			@sentido = 4
			self.forward(pasos)
			@sentido = 0
		elsif @sentido == 1		# Noroeste
			@sentido = 5
			self.forward(pasos)
			@sentido = 1
		elsif @sentido == 2		# Oeste
			@sentido = 6
			self.forward(pasos)
			@sentido = 2
		elsif @sentido == 3		# Suroeste
			@sentido = 7
			self.forward(pasos)
			@sentido = 3
		elsif @sentido == 4		# Sur
			@sentido = 0
			self.forward(pasos)
			@sentido = 4
		elsif @sentido == 5		# Sureste
			@sentido = 1
			self.forward(pasos)
			@sentido = 5
		elsif @sentido == 6		# Este
			@sentido = 2
			self.forward(pasos)
			@sentido = 6
		elsif @sentido == 7		# Noreste
			@sentido = 3
			self.forward(pasos)
			@sentido = 7
		end
	end

	def rotatel(grado)
		grado_aux = grado/45
		aux_sentido =(@sentido+grado_aux)%8
		if aux_sentido < 0
			@sentido = 8 - aux_sentido
		else
			@sentido = aux_sentido
		end
	end

	def rotater(grado)
		grado_aux = grado/45
		aux_sentido =(@sentido-grado_aux)%8
		if aux_sentido < 0
			@sentido = 8 - aux_sentido
		else
			@sentido = aux_sentido
		end
	end

	def setposition(x,y)
		@x = x
		@y = y
	end

	def genPbm()
		File.open('imagen.pbm', 'w') do |f2|
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

x = Imagen.new
x.genPbm