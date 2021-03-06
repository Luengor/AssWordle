;; Modulo principal.
;; El menú está aquí

          .module   main
          .area     MAIN (ABS)
          .org      0x1000

;; Distintas cadenas
texto_menu:
          .ascii  "\nWORDLE (v5.00)\n"
          .ascii    "1) Ver Diccionario\n"
          .ascii    "2) Jugar\n"
          .asciz    "S) Salir\n"
text_volver_jugar:
          .asciz    "Seguir jugando? [y/N]" 
texto_reiniciar:
          .asciz    "\n\nREINICIAR..."
texto_diccionario_inicio:
          .asciz    "\n\nDiccionario:\n"
texto_diccionario_final:
          .asciz    "Numero de palabras = "

;; Importadiones globales
          .globl    imprime_valor_decimal
          .globl    imprime_cadena_color
          .globl    imprime_cadena_x
          .globl    imprime_cadena_y
          .globl    imprime_palabra
          .globl    palabras
          .globl    normal
          .globl    clear
          .globl    bold
          .globl    game


main:
          lds       #0xFF00

          ;; Pongo el texto en negrita
          ldx       #bold
          lbsr      imprime_cadena_x

          ldx       #palabras
menu:
          ;; Limpio la pantalla y muestro el menú
          ldy       #clear
          lbsr      imprime_cadena_y
          ldy       #texto_menu
          lbsr      imprime_cadena_y

          ;; Leo la opción en b
          ldb       0xFF02

          ;; Salto a donde corresponda
          cmpb      #'1
          lbeq      diccionario
          cmpb      #'2
          lbeq      jugar
          cmpb      #'S
          lbeq      acabar
          cmpb      #'s
          lbeq      acabar

          ;; Si ninguna opción del menú coincide, vuelve al menu
          bra       menu

diccionario:
          ;; Imprimo comienzo diccionario
          ldx       #texto_diccionario_inicio
          lbsr      imprime_cadena_x

          ;; Bucle para imprimir todas las palabras
          lda       #0
          ldb       #0
          ldx       #palabras
diccionario_bucle:
          ldb       ,x
          cmpb      #0
          beq       diccionario_fin
          
          ;; Imprimo palabra a palabra
          lbsr      imprime_palabra
          pshs      b
          ldb       #'\n
          stb       0xFF00
          puls      b

          inca
          leax      5,x

          bra       diccionario_bucle
diccionario_fin:
          ;; Imprimo el número de palabras
          ldy       #texto_diccionario_final
          lbsr      imprime_cadena_y
          lbsr      imprime_valor_decimal

          ldb       #'\n
          stb       0xFF00

          ldb       0xFF02
          bra       menu

jugar:
          ;; Limpio la pantalla
          ldy       #clear
          lbsr      imprime_cadena_y

          ;; Empiezo un juego
          ldy       #0xF000
          lbsr      game

          ;; Compruebo si ha terminado bien
          cmpa      #0
          beq       fin_juego
          
          ;; Volver al menú
          cmpa      #'v
          lbeq       menu
          
          ;; Reinicio
          pshs      a,x
          ldx       #texto_reiniciar
          lda       #1
          lbsr      imprime_cadena_color
          puls      a,x
          bra       jugar

fin_juego:
          ;; Incremento la palabra
          leax      5,x
          lda       ,x
          cmpa      #0
          bne       volver_a_jugar
          ldx       #palabras

volver_a_jugar:
          ;; Pregunto si se vuelve a jugar
          pshs      x
          ldx       #text_volver_jugar
          lbsr      imprime_cadena_x
          puls      x

          ;; y/n
          lda       0xFF02
          cmpa      #'y
          lbne       menu

          lbra      jugar

acabar:   
          ;; Quito la negrita
          ldx       #normal
          lbsr      imprime_cadena_x

          ;; Fin
          clra
          sta       0xFF01
          .org      0xFFFE
          .word     main



