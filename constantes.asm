#Archivo de constantes proyecto

#Macro para imprimir cadenas
.macro imprimirCadena (%str)

	la a0, %str  # Cargar la dirección de la cadena
	li a7, 4         # Código de ecall para imprimir string
	ecall
.end_macro

#-- Codigo de los servicios del Sistema Operativo
	.eqv EXIT 10
	.eqv PRINT_STRING 4
	.eqv READ_STRING 8
	.eqv READ_INTEGER 5
	
	.eqv LINEA 1
	.eqv CIRCULO 2
	.eqv SALIR 3
	.eqv LIMPIAR 4
