#Archivo principal

	.include "constantes.asm" #Archivo con la definicion de las constantes
	.eqv MAX 15  #Tamaño maximmo cadenas
	
	.data
cadNombre:	.space MAX
msgInicio: 	.string "Este programa dibuja líneas y círculos \n Ingrese 1 para dibujar una línea y 0 para dibujar un círculo\n"
msgLinea: 	.string "Usted ha escogido dibujar una linea\n"
msgCirculo:	.string "Usted ha escogido dibujar un circulo\n"

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
	beq t0, t1, imprimir_linea  # Si es 1, dibujar línea

	# Si no es 1, dibujar círculo
	imprimirCadena msgCirculo
	b fin

imprimir_linea:
	imprimirCadena msgLinea

fin:
	# Salida del programa
	li a7, EXIT
	ecall



