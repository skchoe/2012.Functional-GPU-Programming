#lang racket

(require ffi/unsafe)


(define libptr_test (ffi-lib "libptr_test"))

(define sl
  (_fun (here : (_ptr o _ulong))
	(size : _uint)
	-> _void
	-> here))

;; if a foreign ftn is of this type: [   type fn(void* arg){  }    ], and caller use fn(&newarg), where newarg is of ulong type(64bit).
;; we declare it in racket: (_fun (arg : (_ptr io _ulong)) -> _rackettype)
(define fl
  (_fun (here : (_ptr io _ulong))
	(size : _uint)
	(src  : _pointer)
	-> _void
	-> here))

(define hl
  (_fun (here : _ulong)
        (size : _uint)
        -> _void))

(define set_location
  (get-ffi-obj 'set_location_dev libptr_test sl (lambda () (error "error-sl\n"))))

(define fill_location
  (get-ffi-obj 'fill_location_dev libptr_test fl (lambda () (error "error-fl\n"))))

(define show_location
  (get-ffi-obj 'show_location_dev libptr_test hl (lambda () (error "error-hl\n"))))

(define (main)
  (let* ([count 5]
	 [loc0 (set_location count)] ;; loc0 is pointer value in ulong type
	 [src (let* ([_src (malloc _float (* count (ctype-sizeof _float)))])
		(for ([i (in-range count)])
                  (let ([v (* (+ 1 i) 0.0001)])
                    (ptr-set! _src _float i v)
                    (printf "Origianl src ~a=~a\n" i v)))
                _src)]
         [v (printf "cpointer?-loc0:~a, cpointer?-src:~a\n" (cpointer? loc0) (cpointer? src))]
         [loc1 (fill_location loc0 count src)]
         )
    (for ([i (in-range count)])
      (printf "in src=~a\n" (ptr-ref src _float i))
      (printf "in des=~a\n" (ptr-ref loc1 _float i))
      )
    (show_location loc0 count)
    (printf "loc0 : ~a\n" loc0)))
(main)

