#Archivo principal

	.include "constantes.asm" #Archivo con la definicion de las constantes
	.eqv MAX 15  #Tamaño maximmo cadenas
	
	.data
cadNombre:	.space MAX
msgInicio: 	.string "Este programa dibuja líneas y círculos \n Ingrese 1 para dibujar una línea, 2 para dibujar un círculo, 3 para salir y 4 para limpiar el bitmap \n"
msgLinea: 	.string "Usted ha escogido dibujar una linea\n"
msgCirculo:	.string "Usted ha escogido dibujar un circulo\n"
msgX1:		.string "Ingrese x1: "
msgY1:		.string "Ingrese y1: "
msgX2:		.string "Ingrese x2: "
msgY2:		.string "Ingrese y2: "
msgX:		.string "Ingrese x del centro: "
msgY:		.string "Ingrese y del centro: "
msgR:		.string "Ingrese el radio: "

	.text
	.globl main

main:
loop:
	# Imprimir mensaje inicial
	imprimirCadena msgInicio
	

# Leer entrada del usuario (como número)
	li a7, READ_INTEGER
	ecall
	mv t1, a0  # Guardar valor ingresado en t0

	# Comparar la eleccion del usuario
    	li t0, LINEA
    	beq t1, t0, imprimirLinea

    	li t0, CIRCULO
    	beq t1, t0, pedirPuntosCirculo

    	li t0, SALIR
    	beq t1, t0, fin

    	li t0, LIMPIAR
    	beq t1, t0, limpiarBitMap


	



imprimirLinea:

	imprimirCadena msgLinea
	
	#Para pedir x1
	imprimirCadena msgX1
	li a7, READ_INTEGER
	ecall
	mv t0, a0 #Guardar x1 en t0
	
	#Pedir y1
	imprimirCadena msgY1
	li a7, READ_INTEGER
	ecall
	mv t1, a0 #Guardar y1 en t1
	
	#Pedir x2
	imprimirCadena msgX2
	li a7, READ_INTEGER
	ecall
	mv t2, a0 #Guardar x2 en t2
	
	# Pedir y2
	imprimirCadena msgY2
	li a7, READ_INTEGER
	ecall
	mv t3, a0  # Guardar y2 en t3
	
	# Inicializar dx, dy, sx, sy, err
    	sub t4, t2, t0  # dx = x1 - x0
    	blt t4, zero, neg_dx
    	j pos_dx
	
	



neg_dx:
    neg t4, t4 #Calcula el valor absoluto de x2
    

pos_dx:
    # t4 contiene abs(dx)

    sub t5, t3, t1  # dy = y2 - y1
    blt t5, zero, neg_dy
    j pos_dy
neg_dy:
    neg t5, t5


#Determina la dirección del desplazamiento
pos_dy:

    # t5 contiene abs(dy)

    blt t0, t2, set_sx_pos
    li t6, -1  # sx
    j set_sy
    
#Si y1 < y2, sy = 1 (incremento positivo).
#Si y1 > y2, sy = -1 (incremento negativo).
set_sx_pos:
    li t6, 1

set_sy:
    blt t1, t3, set_sy_pos
    li a1, -1  # sy
    j set_err
set_sy_pos:
    li a1, 1
#Calcula el error inicial
set_err:
    sub a2, t4, t5  # err = dx - dy




bresenham_loop:
    # Pintar el pixel en (t0, t1)
    li a0, 0x10010000        # Direccion base del bitmap
    li a3, 512              # Ancho del bitmap
    mul a4, t1, a3          # y * ancho
    add a4, a4, t0          # (y * ancho) + x
    slli a4, a4, 2          # Direccion * 4 (4 bytes por pixel)
    add a4, a0, a4          # Direccion base + desplazamiento

    li a0, 0xFFFFFF         # Color blanco
    sw a0, 0(a4)

    # if x0 == x1 and y0 == y1: break
    beq t0, t2, revisarY
    j actualizarE2
revisarY:
    beq t1, t3, finDibujarLinea

actualizarE2:
    slli a3, a2, 1          # e2 = err * 2

    # if e2 > -dy:
    blt a3, t5, actualizarY

actualizarX:
    # x0 += sx
    add t0, t0, t6

    # err -= dy
    sub a2, a2, t5
    j bresenham_loop

actualizarY:
    # if e2 < dx:
    blt a3, t4, actualizarSy

    # y0 += sy
    add t1, t1, a1

    # err += dx
    add a2, a2, t4
    j actualizarX

actualizarSy:
    # y0 += sy
    add t1, t1, a1

    # err += dx
    add a2, a2, t4
    j bresenham_loop

finDibujarLinea:
    j loop

dibujarCirculo:
   

    # Inicializar valores para el algoritmo de Bresenham para circulos
    li t3, 0       # x = 0
    mv t4, t2      # y = r
    li t6, 1       # err = 1
    sub t6, t6, t2 # err = 1 - r

bresenhamCirculo:

    # Pintar los ocho octantes del circulo
    jal ra, pintarPixelesCirculo

    # Si x >= y, terminamos
    bge t3, t4, finDibujarCirculo

    # Actualizar err y determinar los siguientes valores de x e y
    slli t5, t3, 1      # 2*x
    add t5, t5, t6      # 2*x + err
    blt t5, zero, actualizarXUnicamente

    # Actualizar y
    addi t4, t4, -1
    slli t5, t4, 1      # 2*y
    sub t6, t6, t5      # err = err - 2*y
    addi t6, t6, 1      # err = err + 1

actualizarXUnicamente:
    # Actualizar x
    addi t3, t3, 1
    slli t5, t3, 1      # 2*x
    add t6, t6, t5      # err = err + 2*x
    j bresenhamCirculo

finDibujarCirculo:
    j loop

pintarPixelesCirculo:
    # Dibujar p�xeles en los ocho octantes
    li a1, 0x10010000  # Direcci�n base del bitmap
    li a2, 512         # Ancho del bitmap

    # Octante 1
    add a3, t1, t4  # y0 + y
    mul a4, a3, a2
    add a4, a4, t0  # (y0 + y) * width + x0 + x
    add a4, a4, t3
    slli a4, a4, 2  # Direcci�n * 4
    add a4, a1, a4  # Direcci�n base + desplazamiento
    li a0, 0xFFFFFF  # Color blanco
    sw a0, 0(a4)

    # Octante 2
    sub a3, t1, t4  # y0 - y
    mul a4, a3, a2
    add a4, a4, t0  # (y0 - y) * width + x0 + x
    add a4, a4, t3
    slli a4, a4, 2  # Direcci�n * 4
    add a4, a1, a4  # Direcci�n base + desplazamiento
    sw a0, 0(a4)

    # Octante 3
    add a3, t1, t4  # y0 + y
    mul a4, a3, a2
    add a4, a4, t0  # (y0 + y) * width + x0 - x
    sub a4, a4, t3
    slli a4, a4, 2  # Direcci�n * 4
    add a4, a1, a4  # Direcci�n base + desplazamiento
    sw a0, 0(a4)

    # Octante 4
    sub a3, t1, t4  # y0 - y
    mul a4, a3, a2
    add a4, a4, t0  # (y0 - y) * width + x0 - x
    sub a4, a4, t3
    slli a4, a4, 2  # Direcci�n * 4
    add a4, a1, a4  # Direcci�n base + desplazamiento
    sw a0, 0(a4)

    # Octante 5
    add a3, t1, t3  # y0 + x
    mul a4, a3, a2
    add a4, a4, t0  # (y0 + x) * width + x0 + y
    add a4, a4, t4
    slli a4, a4, 2  # Direcci�n * 4
    add a4, a1, a4  # Direcci�n base + desplazamiento
    sw a0, 0(a4)

    # Octante 6
    sub a3, t1, t3  # y0 - x
    mul a4, a3, a2
    add a4, a4, t0  # (y0 - x) * width + x0 + y
    add a4, a4, t4
    slli a4, a4, 2  # Direcci�n * 4
    add a4, a1, a4  # Direcci�n base + desplazamiento
    sw a0, 0(a4)

    # Octante 7
    add a3, t1, t3  # y0 + x
    mul a4, a3, a2
    add a4, a4, t0  # (y0 + x) * width + x0 - y
    sub a4, a4, t4
    slli a4, a4, 2  # Direcci�n * 4
    add a4, a1, a4  # Direcci�n base + desplazamiento
    sw a0, 0(a4)

    # Octante 8
    sub a3, t1, t3  # y0 - x
    mul a4, a3, a2
    add a4, a4, t0  # (y0 - x) * width + x0 - y
    sub a4, a4, t4
    slli a4, a4, 2  # Direcci�n * 4
    add a4, a1, a4  # Direcci�n base + desplazamiento
    sw a0, 0(a4)

    jr ra  # Retornar de la funci�n











	
pedirPuntosCirculo:
	imprimirCadena msgCirculo

	# Pedir x (centro)
	imprimirCadena msgX
	li a7, READ_INTEGER
	ecall
	mv t0, a0  # Guardar x del centro

	# Pedir y (centro)
	imprimirCadena msgY
	li a7, READ_INTEGER
	ecall
	mv t1, a0  # Guardar y del centro

	# Pedir radio
	imprimirCadena msgR
	li a7, READ_INTEGER
	ecall
	mv t2, a0  # Guardar radio
	
	# Inicializar valores para el algoritmo de Bresenham para c�rculos
    	li t3, 0       # x = 0
    	mv t4, t2      # y = r
    	li t6, 1       # err = 1
    	sub t6, t6, t2 # err = 1 - r






limpiarBitMap:
    li a0, 0x10010000  # Direcci�n base del bitmap
    li a1, 0           # Color de fondo (negro)
    li a2, 262144      # Tama�o del bitmap (asumiendo 512x512 p�xeles)
    li a3, 0           # Contador de p�xeles
    
limpiarLoop:
    sw a1, 0(a0)       # Establecer el color del p�xel actual
    addi a0, a0, 4     # Avanzar a la siguiente direcci�n de p�xel
    addi a3, a3, 1     # Incrementar el contador de p�xeles
    blt a3, a2, limpiarLoop # Repetir hasta que todos los p�xeles est�n limpios

    j loop  # Volver al bucle principal

fin:
	# Salida del programa
	li a7, EXIT
	ecall



