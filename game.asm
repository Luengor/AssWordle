;; Este módulo contiene el loop del juego.
          .module   game

comienzo_tabla:
          .ascii    "  | JUEGO |\n"
          .ascii    "-----------\n"
          .ascii    "  | 12345 |\n"
          .asciz    "-----------\n"
comienzo_linea:
          .asciz    "  | "
fin_linea:
          .asciz    " |\n"

palabra_no_en_diccionario:
          .asciz    "\n\nLa palabra no se encuentra en el diccionario."

          .globl    game
          .globl    lee_palabra
          .globl    imprime_cadena
          .globl    imprime_cadena_wordle
          .globl    palabra_en_diccionario

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; game_loop:                                                                  ;
;     Ejecuta un juego de wordle                                              ;
;                                                                             ;
; Entrada: X-dirección de comienzo de la palabra correcta                     ;
; Salida: Ninguna                                                             ;
; Afecta: X                                                                   ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
game:
          pshs      a,b,y

          lda       #0
game_loop:
          cmpa      #6
          beq       game_end
          inca

          ;; Pido palabra
          lbsr      lee_palabra

          ;; Digo si la palabra estaba en el diccionario
          exg       a,b
          lbsr      palabra_en_diccionario
          exg       a,b
          cmpb      #1
          beq       game_imprime
          pshs      x
          ldx       #palabra_no_en_diccionario
          lbsr      imprime_cadena
          puls      x

game_imprime: 
          ;; Imprimo la cabeza de la tabla
          ldb       #10
          stb       0xFF00
          stb       0xFF00
          
          pshs      x
          ldx       #comienzo_tabla
          lbsr      imprime_cadena

          ;; Imprimo la linea nueva
          ldx       #comienzo_linea
          lbsr      imprime_cadena
          puls      x
          lbsr      imprime_cadena_wordle
          pshs      x
          ldx       #fin_linea
          lbsr      imprime_cadena
          puls      x

          bra       game_loop
game_end:
          puls      a,b,y,pc



