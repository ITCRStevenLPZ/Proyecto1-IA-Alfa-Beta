#lang racket/gui
 (require htdp/gui)
;;++++++++++++++++++++++++++++++++++++++++++++++++
;;+++++++Proyecto 1 Inteligencia Artificial+++++++ 
;;++++++++++++++++++++++++++++++++++++++++++++++++
;;++++++Ricardo Murillo Jiménez - 2018173697++++++ 
;;++++++++++++++++++++++++++++++++++++++++++++++++
;;+++++++Ronald Esquivel López - 2018093269+++++++ 
;;++++++++++++++++++++++++++++++++++++++++++++++++




;;------------------------------------------------
;;----------------Constantes----------------------
;;------------------------------------------------

;;Matriz De Prueba
(define Ma '(
            (0 0 0 0 0 0 0)
            (0 1 0 1 0 1 0)
            (1 2 0 1 1 2 0)
            (0 2 2 0 1 0 0)
            (0 1 1 1 2 2 0)
            (2 2 2 2 1 2 1)
            ))

(define FIL 6) ;; Filas de un 4enLinea Común
(define COL 7) ;; Columnas de un 4enLinea Común
(define LargoLinea 4) ;; LLamado usualmente "Window-Widht"
(define IA_PIECE 2)
(define PL_PIECE 1)

;;++++++++++++++++++++++++++++++++++++++++++++++++
;;++++++++++++++++Funciones+++++++++++++++++++++++
;;++++++++++++++++++++++++++++++++++++++++++++++++

;;------------------------------------------------
;;----------------Eval-Statica--------------------
;;------------------------------------------------

;; Evaluación Estática - Evalua un tablero del nivel 0
;; Params: Matriz, puntaje inicial = 0, un i auxiliar para recorrer la matriz
(define (static_eval Matrix)
  (for-inicial Matrix 0 0))

;; For-Inicial - Da un valor inicial al tablero, y se encarga de llamar a los siguientes evaluciones
;; Por cada 2 que se encuentre en la columna central, suma 3 puntos al score.
;; Params: M = matriz, N = puntaje, i para recorrer la matriz y dar un score inicial
(define (for-inicial M N i)
  (cond ((> i 5) (sum-total M N))
        ((= IA_PIECE (list-ref (list-ref M i) (quotient 7 2))) (for-inicial M (+ N 3) (+ i 1)))
        (else (for-inicial M N (+ i 1)))))

;; Encargada de Sumar todo el score del tablero y devolver la suma
;; Recibe el tablero actual y el score obtenido en el paso anterior.
;; Devuelve El valor de la evaluación estática según la Heuristica hecha
(define (sum-total M N)
  (display N)
  (+ N (calc-puntajes-H M 0) (calc-puntajes-V M 0) (calc-puntajes-DP M 0) (calc-puntajes-DN M 0) );;(calc-puntajes-V M 0) (calc-puntajes-DP M 0) (calc-puntajes-DN M 0)
  )

;; Recibe una matriz y un valor al cual se le asignará el scorde de la evaluación horizonral 
(define (calc-puntajes-H M N)
  (for ([r (in-range 0 FIL)])
    (define lista_filas (build-list 7 (lambda (x) 0)))
    (for ([c (in-range 0 7)])
      (set! lista_filas (list-with lista_filas c (list-ref (list-ref (reverse M) r) c)))
      )
    ;;(display lista_filas)
    (for ([c (in-range 0 4)])
      (define window (build-list 4 (lambda (x) 0)))
      (for ([t (in-range 0 4)])
        (set! window (list-with window t (list-ref lista_filas (+ t c))))
        )
      ;;(display window)
      (set! N (+ N (w-eval window)))
      )
    
    )
  (display N)
  N
  )

;; Recibe una matriz y un valor al cual se le asignará el scorde de la evaluación Vertical
;;+++++static Eval Vertical+++++
(define (calc-puntajes-V M N)
  (for ([c (in-range 0 7)])
    (define lista_columnas (build-list 6 (lambda (x) 0)))
    (for ([f (in-range 0 6)])
      (set! lista_columnas (list-with lista_columnas f (list-ref (list-ref M f) c)))
      )
    ;;(display lista_columnas)
    ;;(display lista_filas)
    (for ([f (in-range 0 3)])
      (define window (build-list 4 (lambda (x) 0)))
      (for ([t (in-range 0 4)])
        ( display (+ t f))
        (set! window (list-with window t (list-ref lista_columnas (+ t f))))
        )
      ;;(display window)
      (set! N (+ N (w-eval window)))
      )
    
    )
  N
  )

;; Recibe una matriz y un valor al cual se le asignará el scorde de la evaluación Diagonal Positiva
(define (calc-puntajes-DP M N) ;; Diagona positiva
  (for ([f (in-range 0 (- FIL 3))])
    (define lista_diagpos (build-list 4 (lambda (x) 0)))
    (for ([c (in-range 0 (- COL 3))])
      (for ([i (in-range 0 4)])
        (set! lista_diagpos (list-with lista_diagpos i (list-ref (list-ref Ma (+ f i)) (+ c i))))
        )
      ;;(display window)
      (set! N (+ N (w-eval lista_diagpos)))
      )
    
    )
  N
)

;; Recibe una matriz y un valor al cual se le asignará el scorde de la evaluación Diagonal Negativa
(define (calc-puntajes-DN M N) ;; Diagona positiva
  (for ([r (in-range 0 (- FIL 3))])
    (define lista_diag (build-list 4 (lambda (x) 0)))
    (for ([c (in-range 0 (- COL 3))])
      (for ([i (in-range 0 4)])
        (set! lista_diag (list-with lista_diag i (list-ref (list-ref Ma (- (+ r 3) i)) (+ c i))))
        )
      ;;(display window)
      (set! N (+ N (w-eval lista_diag)))
      )
    
    )
  N
)

;;;; Función Evaluación para dar valor a una fila de 4 y poder usarla en la heurística

;; eval window
;; recibe una lista, devuelve un score: Por ejemplo :: '(1 1 1 0) devolverá un valor de 5
(define (w-eval Lista)
  (w-eval-aux Lista 0 0 0));;0 u N es el puntaje de esta window

;; Acá lo que hacemos es contar la cantidad de 1s, 2s o 0s que hay en la sublista
;; 1 significa ficha de IA, 2 Ficha de persona, 0 No hay ficha
(define (w-eval-aux Lista X Y Z)
  (cond ((null? Lista) (eval-final 0 X Y Z))
        ((= (car Lista) PL_PIECE) (w-eval-aux (cdr Lista) (+ X 1) Y Z))
        ((= (car Lista) IA_PIECE) (w-eval-aux (cdr Lista) X (+ Y 1) Z))
        (else (w-eval-aux (cdr Lista) X Y (+ Z 1)))))

;; recive el puntaje, y fichas, piezas y oponentes y vacio
;; Devuelve un Score
(define (eval-final N X Y Z)
  (cond ((= X 4) (+ N 100))
        ((and (= X 3) (= Z 1)) (+ N 5))
        ((and (= X 2) (= Z 2)) (+ N 2))
        ((and (= Y 3) (= Z 1)) (- N 4))
        (else N)
        ))

;;------------------------------------------------
;;----------------Ckeck-Win-----------------------
;;------------------------------------------------

;; Recibe la matriz, para verificar si hay algún gane
;; Sí alguna de las expresiones del or, da verdadero, quiere decir, que en el tablero existe al menos un 4 en lines
(define (check-win M)
  (or (check-win-H M) (check-win-V M) (check-win-DP M) (check-win-DN M)))

;; Chequea si hay un cuatro en linea Horizontalmente
(define (check-win-H M)
  (define win 0)
  (for ([c (in-range 0 (- COL 3))]
        #:break (or (equal? win 1) (equal? win 2)))
    (for ([r (in-range 0 FIL)]
          #:break (or (equal? win 1) (equal? win 2)))
      (set! win (cond ((and
                     (= (list-ref (list-ref M r) c) 1)
                     (= (list-ref (list-ref M r) (+ c 1)) PL_PIECE)
                     (= (list-ref (list-ref M r) (+ c 2)) PL_PIECE)
                     (= (list-ref (list-ref M r) (+ c 3)) PL_PIECE)
                     ) 1)
                      ((and
                     (= (list-ref (list-ref M r) c) 2)
                     (= (list-ref (list-ref M r) (+ c 1)) IA_PIECE)
                     (= (list-ref (list-ref M r) (+ c 2)) IA_PIECE)
                     (= (list-ref (list-ref M r) (+ c 3)) IA_PIECE)
                     ) 2)
                      (else #f)))))
  win
)


;; Chequea si hay un cuatro en linea Verticalmente
(define (check-win-V M)
  (define win 0)
  (for ([c (in-range 0 COL)]
        #:break (or (equal? win 1) (equal? win 2)))
    (for ([r (in-range 0 (- FIL 3))]
          #:break (or (equal? win 1) (equal? win 2)))
      (set! win (cond ((and
                     (= (list-ref (list-ref M r) c) 1)
                     (= (list-ref (list-ref M (+ r 1)) c) PL_PIECE)
                     (= (list-ref (list-ref M (+ r 2)) c) PL_PIECE)
                     (= (list-ref (list-ref M (+ r 3)) c) PL_PIECE)
                     ) 1)
                      ((and
                     (= (list-ref (list-ref M r) c) 2)
                     (= (list-ref (list-ref M (+ r 1)) c) IA_PIECE)
                     (= (list-ref (list-ref M (+ r 2)) c) IA_PIECE)
                     (= (list-ref (list-ref M (+ r 3)) c) IA_PIECE)
                     ) 2)
                      (else #f)))))
  win
)


;; Chequea si hay un cuatro en linea Diagonal Positivo
(define (check-win-DP M)
  (define win 0)
  (for ([c (in-range 0 (- COL 3))]
        #:break (or (equal? win 1) (equal? win 2)))
    (for ([r (in-range 0 (- FIL 3))]
          #:break (or (equal? win 1) (equal? win 2)))
      (set! win (cond ((and
                     (= (list-ref (list-ref M r) c) 1)
                     (= (list-ref (list-ref M (+ r 1)) (+ c 1)) PL_PIECE)
                     (= (list-ref (list-ref M (+ r 2)) (+ c 2)) PL_PIECE)
                     (= (list-ref (list-ref M (+ r 3)) (+ c 3)) PL_PIECE)
                     ) 1)
                      ((and
                     (= (list-ref (list-ref M r) c) 2)
                     (= (list-ref (list-ref M (+ r 1)) (+ c 1)) IA_PIECE)
                     (= (list-ref (list-ref M (+ r 2)) (+ c 2)) IA_PIECE)
                     (= (list-ref (list-ref M (+ r 3)) (+ c 3)) IA_PIECE)
                     ) 2)
                      (else #f)))))
  win
)

;; Chequea si hay un cuatro en linea Diagonal Negativo
(define (check-win-DN M )
  (define win 0)
  (for ([c (in-range 0 (- COL 3))]
        #:break (or (equal? win 1) (equal? win 2)))
    (for ([r (in-range 3 FIL)]
          #:break (or (equal? win 1) (equal? win 2)))
      (set! win (cond ((and
                     (= (list-ref (list-ref M r) c) 1)
                     (= (list-ref (list-ref M (- r 1)) (+ c 1)) PL_PIECE)
                     (= (list-ref (list-ref M (- r 2)) (+ c 2)) PL_PIECE)
                     (= (list-ref (list-ref M (- r 3)) (+ c 3)) PL_PIECE)
                     ) 1)
                      ((and
                     (= (list-ref (list-ref M r) c) 2)
                     (= (list-ref (list-ref M (- r 1)) (+ c 1)) IA_PIECE)
                     (= (list-ref (list-ref M (- r 2)) (+ c 2)) IA_PIECE)
                     (= (list-ref (list-ref M (- r 3)) (+ c 3)) IA_PIECE)
                     ) 2)
                      (else #f)))))
  win
)

;;++++++++++++++++++++++++++++++++++++++++++++++++
;;++++++++++++++++Auxiliares+++++++++++++++++++++++
;;++++++++++++++++++++++++++++++++++++++++++++++++

;; Cambia el Valor de una lista
;; recibe: lst = lista / idx = indice a cambiar / val = Valor nuevo
(define (list-with lst idx val)
  (if (null? lst)
    lst
    (cons
      (if (zero? idx)
        val
        (car lst))
      (list-with (cdr lst) (- idx 1) val))))
