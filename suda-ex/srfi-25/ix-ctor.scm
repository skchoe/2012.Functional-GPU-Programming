(define (array-ref a . xs)
  (or (array:array? a)
      (error "not an array"))
  (let ((shape (array:shape a)))
    (if (null? xs)
        (array:check-indices "array-ref" xs shape)
        (let ((x (car xs)))
          (if (vector? x)
              (array:check-index-vector "array-ref" x shape)
              (if (integer? x)
                  (array:check-indices "array-ref" xs shape)
                  (if (array:array? x)
                      (array:check-index-actor "array-ref" x shape)
                      (error "not an index object"))))))
    (vector-ref
     (array:vector a)
     (if (null? xs)
         (vector-ref (array:index a) 0)
         (let ((x (car xs)))
           (if (vector? x)
               (array:index/vector
                (quotient (vector-length shape) 2)
                (array:index a)
                x)
               (if (integer? x)
                   (array:vector-index (array:index a) xs)
                   (if (array:array? x)
                       (array:index/array
                        (quotient (vector-length shape) 2)
                        (array:index a)
                        (array:vector x)
                        (array:index x))
                       (error "array-ref: bad index object")))))))))

(define (array-set! a x . xs)
  (or (array:array? a)
      (error "array-set!: not an array"))
  (let ((shape (array:shape a)))
    (if (null? xs)
        (array:check-indices "array-set!" '() shape)
        (if (vector? x)
            (array:check-index-vector "array-set!" x shape)
            (if (integer? x)
                (array:check-indices.o "array-set!" (cons x xs) shape)
                (if (array:array? x)
                    (array:check-index-actor "array-set!" x shape)
                    (error "not an index object")))))
    (if (null? xs)
        (vector-set! (array:vector a) (vector-ref (array:index a) 0) x)
        (if (vector? x)
            (vector-set! (array:vector a)
                         (array:index/vector
                          (quotient (vector-length shape) 2)
                          (array:index a)
                          x)
                         (car xs))
            (if (integer? x)
                (let ((v (array:vector a))
                      (i (array:index a))
                      (r (quotient (vector-length shape) 2)))
                  (do ((sum (* (vector-ref i 0) x)
                            (+ sum (* (vector-ref i k) (car ks))))
                       (ks xs (cdr ks))
                       (k 1 (+ k 1)))
                    ((= k r)
                     (vector-set! v (+ sum (vector-ref i k)) (car ks)))))
                (if (array:array? x)
                    (vector-set! (array:vector a)
                                 (array:index/array
                                  (quotient (vector-length shape) 2)
                                  (array:index a)
                                  (array:vector x)
                                  (array:index x))
                                 (car xs))
                    (error (string-append
                            "array-set!: bad index object: "
                            (array:thing->string x)))))))))
