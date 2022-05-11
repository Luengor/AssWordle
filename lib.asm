;; Librería con funciones, principalmente de lectura y escritura 
          .module   aslib
 
 colors:  .asciz    "\33[31m\0\0"     ;;  Estos \0 son una mickey
          .asciz    "\33[33m\0\0"     ;; herramienta sorpresa que
          .asciz    "\33[32m\0\0"     ;; nos ayudará más adelante
          .asciz    "\33[37m\0"         

bold:     .asciz    "\33[1m"
normal:   .asciz    "\33[0m"
clear:    .asciz    "\33[2J\33[1;1H"

cadena_leer:
          .asciz    "\nPALABRA: "

          .globl    imprime_caracter_color
          .globl    imprime_cadena_wordle
          .globl    imprime_cadena_color
          .globl    imprime_cadena
          .globl    lee_palabra

          .globl    bold
          .globl    normal
          .globl    clear


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; imprime_cadena:                                                             ;
;     imprime por pantalla la cadena apuntada por X                           ;
;                                                                             ;
; Entrada: X-direicwión de comienzo de la cadena                               ;
; Salida:  Ninguna                                                            ;
; Afecta:  X                                                                  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
imprime_cadena:
          pshs      a,x
imprime_cadena_sgte:
          lda       ,x+          
          cmpa      #0
          beq       imprime_cadena_return
          sta       0xFF00
          bra       imprime_cadena_sgte
imprime_cadena_return:
          puls      a,x,pc



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; imprime_cadena_color:                                                       ;
;     imprime por pantalla la cadena apuntada por X en el color               ;
;     especificado en a                                                       ;
;                                                                             ;
; Entrada: X-dirección de comienzo de la cadena                               ;
;          A-color a usar (0 - 3) rojo, amarillo, verde, blanco, mantiene     ;
; Salida:  Ninguna                                                            ;
; Afecta:  A                                                                  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
imprime_cadena_color:
          pshs      x
          ldx       #colors
          lsla lsla lsla
          leax      a,x
          lbsr       imprime_cadena
          puls      x

          lbsr       imprime_cadena

          pshs      x
          ldx       #colors+24
          lbsr       imprime_cadena
          puls      x,pc



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; imprime_cadena_wordle:                                                      ;
;     imprime la cadena de texto en y comparándola con la                     ;
;     cadena en x con los colores de wordle                                   ;
; Entrada: X, Y -Cadenas                                                      ;
; Salida: Ninguna                                                             ;
; Afecta: Nada                                                                ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
imprime_cadena_wordle:
          pshs      a,b,y
          lda       #0

icw_ext_inicio:
          cmpa      #5
          beq       icw_ext_fin
          pshs      x
          pshs      a

          lda       #0
          ldb       #0
icw_int_inicio:
          cmpb      #5
          beq       icw_int_fin
          pshs      b

          ldb       ,x
          cmpb      ,y
          puls      b
          bne       icw_int_inc
          cmpb      ,s
          bne       icw_distinto_sitio
          adda      #10
icw_distinto_sitio:
          inca
icw_int_inc:
          incb
          leax      1,x
          bra       icw_int_inicio
icw_int_fin:
          cmpa      #10
          blo       icw_lo1
          lda       #2
          bra       icw_ext_inc
icw_lo1:  cmpa      #0
          beq       icw_ext_inc
          lda       #1
icw_ext_inc:
          ldb       ,y+
          lbsr      imprime_caracter_color
          puls      a
          puls      x
          inca
          bra       icw_ext_inicio
icw_ext_fin:
          puls      a,b,y,pc



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; imprime_caracter_color:                                                     ;
;     imprime por pantalla el caracter en b con el color que se especifique   ;
;     a:  (0: rojo, 1:amarillo, 2: verde, 3: blanco,                          ;
;          >3: mantiene color anterior)                                       ;
;                                                                             ;
; Entrada: B-caracter a imprimir                                              ;
;          A-color a usar                                                     ;
; Salida:  Ninguna                                                            ;
; Afecta:  A, B                                                               ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
imprime_caracter_color:
          cmpa      #3
          pshs      x
          bhi       imprime_caracter_caracter
          
          ldx       #colors
          lsla lsla lsla
          leax      a,x
          lbsr       imprime_cadena
          
imprime_caracter_caracter:
          stb       0xFF00
          ldx       #colors
          leax      24,x
          lbsr       imprime_cadena
          puls      x,pc



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; lee_palabra:                                                                ;
;     lee una palabra de 5 letras mayúsculas por pantalla permitiendo         ;
;     borrar la letra anterior con un espacio y la almacena en X              ;
;                                                                             ;
; Entrada: X-Dirección donde almacenar la cadena                              ;
; Salida:  X-Cadena leída                                                     ;
; Afecta:  X                                                                  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
lee_palabra:
          pshs      a,b,y
          ldy       #cadena_leer
          lda       #0

lp_bucle_leer:
          cmpa      #5
          beq       lp_return

          exg       x,y
          lbsr      imprime_cadena
          exg       y,x
          ldb       #0
          stb       a,x
          lbsr      imprime_cadena
          
          ldb       0xFF02
          cmpb      #' 
          beq       lp_back
          stb       a,x
          inca
          bra       lp_bucle_leer
lp_back:
          ldb       #0
          stb       a,x
          cmpa      #0
          beq       lp_bucle_leer
          deca
          bra       lp_bucle_leer
lp_return:
          puls      a,b,y,pc


