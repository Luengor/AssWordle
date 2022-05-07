;; Librería con funciones, principalmente de lectura y escritura 
          .module   aslib
 
 colors:  .ascii    "\33[31m\0\0\0"     ;; Los direcciones acaban en 3 \0 para
          .ascii    "\33[32m\0\0\0"     ;; que solo sea necesario hacer un left
          .ascii    "\33[37m\0"         ;; shift 3 veces al calcular la direcc

          .globl    imprime_cadena
          
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; imprime_cadena:                                                             ;
;     imprime por pantalla la cadena apuntada por X en el color               ;
;     en el color que se especifique en el registro a:                        ;
;         (0: blanco, 1:rojo, 2: verde, >2: mantiene color anterior)          ;
;                                                                             ;
; Entrada: X-dirección de comienzo de la cadena                               ;
;          A-color a usar                                                     ;
; Salida:  Ninguna                                                            ;
; Afecta:  X, A                                                               ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
imprime_cadena:
          pshs      b

          cmpa      #2
          bhi       imprime_cadena_sgte
          
          pshs      x
          
          ldx       #colors
          lsla
          lsla                ;; Left shift 3 veces para calcular la dirección
          lsla
          leax      a,x

          lda       #0xFF
          bsr       imprime_cadena        ;; Recursión en assembly :)
          puls      x
          
imprime_cadena_sgte:
          ldb       ,x+
          cmpb      #0
          beq       imprime_cadena_return
          stb       0xFF00
          bra       imprime_cadena_sgte

imprime_cadena_return:
          puls      b
          rts

