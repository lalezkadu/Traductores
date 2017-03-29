#!/usr/bin/env ruby
# = imagen.rb
#
# Autor:: Lalezka Duque, 12-10613
# Autor:: Marcos Jota, 12-10909
#
# == Descripcion
#
# Implementacion de las imagenes en el lenguaje Retina.

include Math

# == Clase Imagen
#
# Clase que representa a una imagen
class Imagen

	# == Atributos
	#
	# tam_ancho: Ancho del plano
	# tam_alto: Alto del plano
	# plano: Matriz tam_anchoxtam_alto que representa al plano
	# x: posicion x del cursor
	# y: posicion y del cursor
	# grados: direccion de movimiento
	# pintar: booleano que indica si se puede pintar el plano o no
	# programa: nombre de la imagen a generar
	attr_accessor :tam_ancho, :tam_alto, :plano, :x, :y, :grados, :pintar, :programa
	
	# Crea la imagen
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

	# Funcion para devolver el cursor al centro del plano
	def home()
		@x = @tam_ancho/2
		@y = @tam_alto/2
	end

	# Funcion para dibujar mientras el cursor avance
	def openeye()
		@pintar = true
	end

	# Funcion para no dibujar mientras el cursor avance
	def closeeye()
		@pintar = false
	end

	# Funcion para avanzar una cantidad de pasos en el plano.
	# Calculamos el punto final de la trayectoria dada por los pasos a avanzar,
	# luego calculamos las constantes de la ecuacion general de una recta 
	# Ax+By+C=0, donde A = pendiente, B=-1.
	# Teniendo el punto inicial y el punto final recorremos la submatriz formada
	# por esos puntos y verificamos para cada punto su distancia a la recta
	# calculada anteriormente. Finalmente dibujamos si la distancia es menor o 
	# igual a la raiz cuadrada de dos entre dos.
	# Avanzar una cantidad negativa de pasos es equivalente a retroceder el
	# valor absoluto de los pasos (backward(pasos.abs))
	def forward(pasos)
		if pasos < 0
			self.backward(pasos.abs)
		else
			punto_final = self.calcularPuntoFinal(pasos)	# Calculo del punto final de la trayectoria

			xf = self.index2point(punto_final[0])
			yf = self.index2point(punto_final[1])
			x0 = self.index2point(@x)
			y0 = self.index2point(@y)

			m = self.pendiente(x0,y0,xf,yf)	# Pendiente de la recta, constante A de la ecuacion general de la recta
			c = y0-m*x0 					# Constante C de la ecuacion general de la recta
			
			# Definimos los limites de la iteracion
			if @x <= punto_final[0]	
				x0 = @x
				xf = punto_final[0]
			else
				x0 = punto_final[0]
				xf = @x
			end
			if @y <= punto_final[1]	
				y0 = @y
				yf = punto_final[1]
			else
				y0 = punto_final[1]
				yf = @y
			end
				
			# Pintar la trayectoria
			(x0..xf).each do |x|
				(y0..yf).each do |y|
					#puts "#{x} #{y} puntos x,y"
					auxX = self.index2point(x)
					auxY = self.index2point(y)
					#puts "#{auxX} #{auxY} puntos aux x,y"
					distancia = (m*auxX-1*auxY+c).to_f.abs/Math.sqrt(m*m+1)	# Distancia desde un punto a una recta
					#puts "#{distancia} distancia"
					if distancia <= Math.sqrt(2)/2	# Distancia maxima para pintar el punto
						if @pintar && x >= 0 && x < @tam_ancho && y >= 0 && y < @tam_alto
							#puts "PINTE"
							@plano[y][x] = 1		# Ya que en realidad (x,y) representa a la fila y, columna x
						end
					end
				end
			end
			self.setposition(punto_final[0],punto_final[1])	# Continuamos el dibujo desde el punto final
		end	
	end

	# Funcion que calcula el punto final de una trayectoria.
	# Para ello dibujamos un triangulo rectangulo donde la hipotenusa es el
	# numero de pasos a dar y el grado entre la hipotenusa y el eje x es el
	# atributo @grado. 
	# Mediante el uso de las razones trigonometricas se calculan los lados del
	# triangulo, las cuales representan al desplazamiento en los ejes x e y del
	# plano en el cual estamos dibujando, es decir, la matriz @plano.
	# Finalmente, el punto deseado se calcula con la suma algebraica de la
	# posicion actual en la matriz con los desplazamientos.
	def calcularPuntoFinal(pasos)
		if @grados >= 0 && @grados < 90
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

	# Funcion que calcula la pendiente de una recta dados dos puntos (x0,y0) y (xf,yf)
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

	# Funcion que convierte grados a radianes
	def grados2radianes(alfa)
		return ((alfa*Math::PI)/180)
	end

	# Funcion que convierte el indice de una matriz en puntos de un plano cartesiano
	def index2point(x)
		return (@tam_ancho/2-x)
	end

	# Funcion para retroceder una cantidad de pasos en el plano.
	# Retroceder es equivalente a avanzar hacia el sentido contrario y luego
	# devolver el sentido original.
	# Retroceder una cantidad negativa de pasos es equivalente a avanzar
	# el valor absoluto de la cantidad de pasos.
	def backward(pasos)	
		if pasos < 0
			self.forward(pasos.abs)
		else
			self.rotatel(180)
			self.forward(pasos)
			self.rotatel(180)
		end
	end

	# Rota cierta cantidad de grados a la izquierda la direccion de movimiento
	# Los grados siempre estaran en el intervaldo 0<=@grados<360
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

    # Rota cierta cantidad de grados a la derecha la direccion de movimiento
    # Los grados siempre estaran en el intervaldo 0<=@grados<360
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

    # Define la posicion actual del cursor.
	def setposition(x,y)
		@x = x
		@y = y
	end

	# Genera la imagen en formato .pbm
	def generarImagen()
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

	# Funcion para poder imprimir la imagen en consola.
	def to_s
		@tam_alto.times do |i|
			@tam_ancho.times do |j|
				print @plano[i][j].to_s + " "
			end
			print "\n"
		end
	end
end

# Pequeña prueba

x = Imagen.new()
x.forward(3)
x.rotatel(60)
x.forward(3)
x.rotatel(75)
x.forward(5)
x.rotater(75)
x.forward(5)
#x.to_s
x.generarImagen
