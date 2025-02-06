#Archivo principal

	.include "constantes.asm" #Archivo con la definicion de las constantes
	.eqv MAX 15  #Tamaño maximmo cadenas
	
	.data
cadNombre:	.space MAX
msgInicio: 	.string "Este programa dibuja líneas y círculos \n Ingrese 1 para dibujar una línea y 0 para dibujar un círculo\n"
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
	# Imprimir mensaje inicial
	imprimirCadena msgInicio
	

# Leer entrada del usuario (como número)
	li a7, READ_INTEGER
	ecall
	mv t0, a0  # Guardar valor ingresado en t0

	# Comparar con 1 (LINEA)
	li t1, LINEA
	beq t0, t1, pedirPuntosLinea  # Si es 1, dibujar línea

	# Si no es 1, dibujar círculo
	imprimirCadena msgCirculo
	b pedirPuntosCirculo


#Dibujar linea:
pedirPuntosLinea:
	imprimirCadena msgLinea
	
	# Pedir x1
	imprimirCadena msgX1


imprimir_linea:
	imprimirCadena msgLinea
	
	#Para pedir x1
	imprimirCadena msgX1
	li a7, READ_INTEGER
	ecall
	mv t2, a0 #Guardar x1
	
	#Pedir y1
	imprimirCadena msgY1
	li a7, READ_INTEGER
	ecall
	mv t3, a0 #Guardar y1
	
	#Pedir x2
	imprimirCadena msgX2
	li a7, READ_INTEGER
	ecall
	mv t4, a0 #Guardar x2
	
	# Pedir y2
	imprimirCadena msgY2
	li a7, READ_INTEGER
	ecall
	mv t5, a0  # Guardar y2

	# Aquí se podrían pasar los valores a una función que dibuje la línea con gráficos

	b fin
pedirPuntosCirculo:
	imprimirCadena msgCirculo

	# Pedir x (centro)
	imprimirCadena msgX
	li a7, READ_INTEGER
	ecall
	mv t2, a0  # Guardar x del centro

	# Pedir y (centro)
	imprimirCadena msgY
	li a7, READ_INTEGER
	ecall
	mv t3, a0  # Guardar y del centro

	# Pedir radio
	imprimirCadena msgR
	li a7, READ_INTEGER
	ecall
	mv t4, a0  # Guardar radio

	# Aquí se podrían pasar los valores a una función que dibuje el círculo con gráficos



#Dibujar circulo

fin:
	# Salida del programa
	li a7, EXIT
	ecall





