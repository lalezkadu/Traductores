#!/usr/bin/env ruby

include Math

class Imagen
	attr_accessor :tam_ancho, :tam_alto, :plano, :x, :y, :grados, :pintar, :programa
	def initialize(programa="archivo")
		@programa = programa
		@tam_ancho = 11
		@tam_alto = 11
		@plano = Array.new(@tam_ancho) { Array.new(@tam_alto) { 0 } }
		self.home()
		@plano[@x][@y] = 1
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
			if @grados >= 0 && @grados <= 90	# Calculamos el punto final de la trayectoria
				puts "0-90"
				grados_aux = @grados
				alfa = self.grados2radianes(grados_aux)
				co = (pasos*Math.sin(alfa)).abs
				ca = (pasos*Math.cos(alfa)).abs
				x_final = self.redondear(@x+ca)
				y_final = self.redondear(@y+co)
			elsif @grados > 90 && @grados <= 180
				puts "90-180"
				grados_aux = 180 - @grados
				alfa = self.grados2radianes(grados_aux)
				co = (pasos*Math.sin(alfa)).abs
				ca = (pasos*Math.cos(alfa)).abs
				x_final = self.redondear(@x-ca)
				y_final = self.redondear(@y+co)
			elsif @grados > 180 && @grados <= 270
				puts "180-270"
				grados_aux = 270 - @grados
				alfa = self.grados2radianes(grados_aux)
				co = (pasos*Math.sin(alfa)).abs
				ca = (pasos*Math.cos(alfa)).abs
				x_final = self.redondear(@x-ca)
				y_final = self.redondear(@y-co)
			elsif @grados > 270 && @grados < 360 
				puts "270-360"
				grados_aux = 360 - @grados
				alfa = self.grados2radianes(grados_aux)
				co = (pasos*Math.sin(alfa)).abs
				ca = (pasos*Math.cos(alfa)).abs
				x_final = self.redondear(@x+ca)
				y_final = self.redondear(@y-co)
			end
			puts "#{@x} #{@y} @x,@y #{x_final} #{y_final} xf,yf"

			if @x <= x_final	# definimos los limites de la iteracion
				x0 = @x
				xf = x_final
				y0 = @y
				yf = y_final
			else
				x0 = x_final
				xf = @x
				y0 = y_final
				yf = @y
			end

			puts "#{x0} #{y0} x0,y0 #{xf} #{yf} xf,yf"
			if yf == y0 && xf == x0
				pendiente = yo/x0
			elsif xf == x0 && xf < 0
				pendiente = -100000
			elsif xf == x0 && xf >= 0
				pendiente = 1000000
			else
				pendiente = (yf-y0)/(xf-x0)
			end
			
			a = pendiente
			b = -1
			c = y0-pendiente*x0
			puts "#{a} #{b} #{c} a,b,c"

			puts "#{pendiente} PENDIENTE"
			#distancia = ((A*x+B*y).abs)/Math.sqrt(A*A+B*B)

			(x0..xf).each do |x|
				(y0..yf).each do |y|
					puts "#{x} #{y} puntos x,y"
					y1 = self.redondear(pendiente*x)
					puts "#{y1} y1"
					distancia = (a*x+b*y+c).abs/Math.sqrt(a*a+b*b)
					puts "#{distancia} distancia"
					if distancia <= Math.sqrt(2)/2
						puts "VOY A PINTAR"
						if @pintar && x >= 0 && x < @tam_ancho && y >= 0 && y < @tam_alto
							puts "PINTE"
							@plano[x][y] = 1
						end
					end
				end
			end
		end	
	end

	def grados2radianes(alfa)
		r = (alfa*Math::PI)/180
		return r
	end

	def redondear(num)
		base = num.floor
		decimal = num - base
		if decimal >= 0.5
			return num.round
		else
			return base
		end
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

	def arc(grados,radio)
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
				print @plano[j][i].to_s + " "
			end
			print "\n"
		end
	end
end

x = Imagen.new()
x.rotatel(30)
puts x.grados
x.forward(5)
x.to_s