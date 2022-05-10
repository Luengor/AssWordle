;; Librería con funciones, principalmente de lectura y escritura 
          .module   aslib
 
 colors:  .ascii    "\33[31m\0\0\0"     ;; Los direicwiones acaban en 3 \0 para
          .ascii    "\33[33m\0\0\0"     ;; que solo sea necesario hacer un left
          .ascii    "\33[32m\0\0\0"     ;; shift 3 veces al calcular la direicw
          .ascii    "\33[37m\0"         

          .globl    imprime_caracter_color
          .globl    imprime_cadena_wordle
          .globl    imprime_cadena


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; imprime_cadena:                                                             ;
;     imprime por pantalla la cadena apuntada por X                           ;
;                                                                             ;
; Entrada: X-direicwión de comienzo de la cadena                               ;
; Salida:  Ninguna                                                            ;
; Afecta:  X                                                                  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
imprime_cadena:
          pshs      a

imprime_cadena_sgte:
          lda       ,x+          
          cmpa      #0
          beq       imprime_cadena_return
          sta       0xFF00
          bra       imprime_cadena_sgte
imprime_cadena_return:
          puls      a
          rts


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; imprime_cadena_wordle:                                                      ;
;     imprime la cadena de texto en y comparándola con la                     ;
;     cadena en x con los colores de wordle                                   ;
; Entrada: X, Y -Cadenas                                                      ;
; Salida: Ninguna                                                             ;
; Afecta: Nada                                                                ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
imprime_cadena_wordle:
          pshs      a,b
          lda       #0
          pshs      y

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
          adda      #1
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
          jsr       imprime_caracter_color
          puls      a
          puls      x
          inca
          bra       icw_ext_inicio
icw_ext_fin:
          puls      y
          puls      a,b
          rts

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
          lsla
          lsla                ;; Left shift 3 veces para calcular la direicwión
          lsla leax      a,x
          jsr       imprime_cadena
          
imprime_caracter_caracter:
          stb       0xFF00
          ldx       #colors
          leax      24,x
          jsr       imprime_cadena
          puls      x

          rts


