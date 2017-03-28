#!/usr/bin/env ruby

include Math

class Imagen
	attr_accessor :tam_ancho, :tam_alto, :plano, :x, :y, :grados, :pintar, :programa
	def initialize(programa="archivo")
		@programa = programa
		@tam_ancho = 1001
		@tam_alto = 1001
		@plano = Array.new(@tam_ancho) { Array.new(@tam_alto) { 0 } }
		self.home()
		@plano[@y][@x] = 1
		@grados = 90
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
			punto = self.calcular_punto_final(pasos)

			if @x <= punto[0]	# definimos los limites de la iteracion
				x0 = @x
				xf = punto[0]
			else
				x0 = punto[0]
				xf = @x
			end
			if @y <= punto[1]	# definimos los limites de la iteracion
				y0 = @y
				yf = punto[1]
			else
				y0 = punto[1]
				yf = @y
			end

			puts "#{x0} #{y0} x0,y0 #{xf} #{yf} xf,yf"
			m = self.pendiente(x0,y0,xf,yf)
			c = @y-m*@x
			puts "#{c} #{m} c, m"
			(x0..xf).each do |x|
				(y0..yf).each do |y|
					puts "#{x} #{y} puntos x,y"
					auxX = self.x2abs(x)
					auxY = self.y2ord(y)
					puts "#{auxX} #{auxY} puntos aux x,y"
					distancia = (m*auxX-1*auxY+c).to_f.abs/Math.sqrt(m*m+1)
					puts "#{distancia} distancia"
					if distancia <= Math.sqrt(2)/2
						if @pintar && x >= 0 && x < @tam_ancho && y >= 0 && y < @tam_alto
							puts "PINTE"
							@plano[y][x] = 1		# Ya que en realidad (x,y) representa a la fila y, columna x
						end
					end
				end
			end
			self.setposition(punto[0],punto[1])
		end	
	end

	def calcular_punto_final(pasos)
		if @grados >= 0 && @grados < 90	# Calculamos el punto final de la trayectoria
			grados_aux = @grados
			alfa = self.grados2radianes(grados_aux)				
			co = (pasos*Math.sin(alfa)).abs
			y_final = (@y-co).round
			ca = (pasos*Math.cos(alfa)).abs
			x_final = (@x+ca).round
		elsif @grados >= 90 && @grados <= 180
			grados_aux = 180 - @grados
			alfa = self.grados2radianes(grados_aux)
			co = (pasos*Math.sin(alfa)).abs
			y_final = (@y-co).round
			ca = (pasos*Math.cos(alfa)).abs
			x_final = (@x-ca).round
		elsif @grados > 180 && @grados < 270
			grados_aux = 270 - @grados
			alfa = self.grados2radianes(grados_aux)
			co = (pasos*Math.sin(alfa)).abs
			y_final = (@y+co).round
			ca = (pasos*Math.cos(alfa)).abs
			x_final = (@x-ca).round
		elsif @grados >= 270 && @grados < 360 
			grados_aux = 360 - @grados
			alfa = self.grados2radianes(grados_aux)
			co = (pasos*Math.sin(alfa)).abs
			y_final = (@y+co).round
			ca = (pasos*Math.cos(alfa)).abs
			x_final = (@x+ca).round
		end
		return [x_final,y_final]
	end

	def pendiente(x0,y0,xf,yf)
		if yf == y0 && xf == x0
			m = yo/x0
		elsif xf == x0 && xf < 0
			m = -100000
		elsif xf == x0 && xf >= 0
			m = 1000000
		else
			m = (yf-y0)/(xf-x0)
		end
		return m
	end

	def grados2radianes(alfa)
		r = (alfa*Math::PI)/180
		return r
	end

	def x2abs(x)
		if x > @tam_ancho/2
			auxX = @tam_ancho -1 -x
		else
			auxX = x
		end
		return auxX
	end

	def y2ord(y)
		if y > @tam_ancho/2
			auXY = @tam_ancho -1 -y
		else
			auxY = y
		end
		return auxY
	end

	def backward(pasos)	
		if pasos < 0
			forward(pasos.abs)
		else
			self.rotatel(180)
			self.forward(pasos)
			self.rotatel(180)
		end
	end

    def rotatel(grados)
        if grados < 0
            self.rotater(grados.abs)
        else
            suma = @grados + grados
            if suma >= 360
                @grados = suma%360
            else
            	@grados = suma
            end
        end
    end

    def rotater(grados)
        if grados < 0
            self.rotatel(grados.abs)
        else
            suma = @grados - grados
            if suma >= 360
                grados_aux = suma%360	
            else
            	grados_aux = suma
            end
            if grados_aux < 0
           		@grados = 360 + grados_aux
           	else
           		@grados = grados_aux
           	end
        end
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

#x = Imagen.new()
#x.rotatel(180)
#puts x.grados
#x.forward(6)
#x.to_s