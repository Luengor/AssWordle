;; Modulo principal.
;; El menú está aquí
          .module   main
          .area     MAIN (ABS)
          .org      0x1000

texto_menu:
          .ascii  "\nWORDLE (v2.00)\n"
          .ascii    "1) Ver Diccionario\n"
          .ascii    "2) Jugar\n"
          .ascii    "S) Salir\n\0"
texto_reiniciar:
          .ascii    "\n\nREINICIAR..."

          .globl    imprime_cadena
          .globl    palabras
          .globl    normal
          .globl    clear
          .globl    bold
          .globl    game

;; s -> 0xFF00
;; x -> 0xF000
;; y -> 0xEA00
main:
          lds       #0xFF00

          ;; Pongo el texto en negrita
          ldx       #bold
          lbsr      imprime_cadena

          ldx       #palabras
menu:
          ;; Limpio la pantalla y muestro el menú
          pshs      x
          ldx       #clear
          lbsr      imprime_cadena
          ldx       #texto_menu
          lbsr      imprime_cadena
          puls      x

          ;; Leo la opción en b
          ldb       0xFF02

          ;; Salto a donde corresponda
          cmpb      #'1
          beq       diccionario
          cmpb      #'2
          beq       jugar
          cmpb      #'S
          beq       acabar
          cmpb      #'s
          beq       acabar

          beq       menu

diccionario:
          ldb       #'e
          stb       0xFF00

          ldb       0xFF02
          bra       menu

jugar:
          ldb       #'\n
          stb       0xFF00
          ;; Empiezo un juego
          ldy       #0xF000
          lbsr      game

          ;; Compruebo si ha terminado bien
          cmpa      #0
          beq       fin_juego
          
          cmpa      #'v
          beq       menu

          pshs      a,x
          ldx       #texto_reiniciar
          lda       #1
          lbsr      imprime_cadena
          puls      a,x
          
          bra       jugar

fin_juego:
          ldb       0xFF02

          ;; Incremento la palabra
          leax      5,x
          lda       ,x
          cmpa      #0
          bne       menu
          ldx       #palabras
          bra       menu


acabar:   ;; Quito la negrita
          ldx       #normal
          lbsr      imprime_cadena

          ;; Fin
          clra
          sta       0xFF01
          .org      0xFFFE
          .word     main



