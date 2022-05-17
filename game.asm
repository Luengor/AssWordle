;; Este módulo contiene el loop del juego.
          .module   game

comienzo_tabla:
          .ascii    "\n\n  | JUEGO |\n"
          .ascii        "-----------\n"
          .ascii        "  | 12345 |\n"
          .asciz        "-----------\n"

fin_linea:
          .asciz    " |\n"
comienzo_linea:
          .asciz    " | "
linea_vacia:
          .asciz    " |       |\n"
win:      .asciz    "HAS ACERTADO LA PALABRA\n\n"
loss:     .asciz    "HAS TERMINADO TUS INTENTOS\n\n"

palabra_no_en_diccionario:
          .asciz    "\n\nLa palabra no se encuentra en el diccionario."

          .globl    game
          .globl    lee_palabra
          .globl    imprime_cadena
          .globl    compara_palabras
          .globl    imprime_cadena_color
          .globl    imprime_cadena_wordle
          .globl    palabra_en_diccionario

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; game_loop:                                                                  ;
;     Ejecuta un juego de wordle                                              ;
;                                                                             ;
; Entrada: X-dirección de comienzo de la palabra correcta                     ;
; Salida:  A-Resultado: 0: ningún problema, r: reset, v: vuelta al menú       ;
; Afecta: X,A                                                                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
game:
          pshs      b,x,y

          lda       #0
game_loop:
          cmpa      #6                            ;; s:
          lbeq      game_loss
          pshs      a                             ;; s: a

          ;; Pido palabra
          ldb       #5
          mul
          pshs      y                             ;; s: a - y
          leay      b,y
          pshs      a                             ;; s: a - y - a2
          lbsr      lee_palabra

          ;; Compruebo que no hemos tendríamos que acabar
          cmpa      #0
          lbne      game_end_mal

          puls      a                             ;; s: a - y

          ;; Digo si la palabra estaba en el diccionario
          lbsr      palabra_en_diccionario
          puls      y                             ;; s: a
          cmpa      #0
          beq       imprime

          pshs      x                             ;; s: a - x
          ldx       #palabra_no_en_diccionario
          lbsr      imprime_cadena
          puls      x                             ;; s: a

imprime: 
          ;; Imprimo la cabeza de la tabla
          pshs      x                             ;; s: a - x
          ldx       #comienzo_tabla
          lbsr      imprime_cadena
          puls      x                             ;; s: a

          lda       #0
bucle_anterior:
          cmpa      ,s
          bhi       bucle_anterior_end
          pshs      a                             ;; s: a - a2          

          ;; Imprimo el número de línea
          adda      #'1
          sta       0xFF00
          suba      #'1

          ;; Imprimo el comienzo de linea
          pshs      x                             ;; s: a - a2 - x
          ldx       #comienzo_linea
          lbsr      imprime_cadena
          puls      x                             ;; s: a - a2

          ;; Imprimo la palabra
          ldb       #5
          mul
          pshs      y                             ;; s: a - a2 - y
          leay      b,y
          lbsr      imprime_cadena_wordle
          puls      y                             ;; s: a - a2

          ;; Imprimo el fin de linea
          pshs      x                             ;; s: a - a2 - x
          ldx       #fin_linea
          lbsr      imprime_cadena
          puls      x                             ;; s: a - a2

          ;; Incremento
          puls      a                             ;; s: a
          inca
          bra       bucle_anterior

bucle_anterior_end:

          ;; Imprimo líneas vacías
          pshs      x                             ;; s: a - x
          ldx       #linea_vacia
bucle_next:
          cmpa      #6
          beq       bucle_next_end
          adda      #'1
          sta       0xFF00
          suba      #'1
          lbsr      imprime_cadena
          inca
          bra       bucle_next 

bucle_next_end:
          puls      x                             ;; s: a

          ;; Compruebo si la palabra era la correcta
          puls      a                             ;; s: 
          pshs      a                             ;; s: a

          ldb       #5
          mul
          pshs      y                             ;; s: a - y
          leay      b,y
          lbsr      compara_palabras
          cmpa      #0

          puls      y                             ;; s: a 
          puls      a

          beq       game_win

          ;; Incremento el loop
          inca
          lbra       game_loop

game_end_mal:
          leas      4,s
          puls      b,x,y,pc

game_loss:
          ldx       #loss
          lda       #0
          bra       game_end
game_win:
          ldx       #win
          lda       #2
game_end:
          lbsr      imprime_cadena_color
          lda       #0
          puls      b,x,y,pc



