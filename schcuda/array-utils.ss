(module array-utils scheme
(require srfi/25
         scheme/foreign)
  
  
  (provide array1d->_pointer
           array1d->_pointer)

  (unsafe!)
  
  ;; malloc mode can be empty or 'raw ... used in (malloc).
  (define (array1d->_pointer array-in type . malloc-mode)
    (let* ([rank (array-rank array-in)]
           [start (array-start array-in 0)]
           [end (array-end array-in  0)]
           [size (- end start)]
           [ptr 
            (cond 
              [(null? malloc-mode) (malloc type size)]
              [(null? (cdr malloc-mode)) (malloc type size (car malloc-mode))]
              [else (error "malloc mode in array1d->_pointer cannot be more than 1")])])
      (for ([i (in-range size)])
        (let ([val (array-ref array-in i)])
          (printf "val   = ~s\t" val)
          (ptr-set! ptr type i val)))
      (printf "\n")
      ptr))


  (define (array2d->_pointer array-in type . malloc-mode)
    (let* ([rank (array-rank array-in)])
      (unless (equal? rank 2)
        (begin
          (error "input rank is wrong\n")
          (exit)))
      (let* ([shp (array-shape array-in)]
             [start-x (array-start array-in 0)]
             [start-y (array-start array-in 1)]
             [end-x (array-end array-in 0)]
             [end-y (array-end array-in 1)]
             [size-x (- end-x start-x)]
             [size-y (- end-y start-y)]
             [ptr 
              (cond
                [(null? malloc-mode) (malloc type (* size-x size-y))]
                [(null? (cdr malloc-mode)) (malloc type (* size-x size-y) (car malloc-mode))]
                [else (error "malloc mode in array1d->_pointer cannot be more than 1")])])
        (for ([i (in-range size-x)])
          (for ([j (in-range size-y)])
            (ptr-set! ptr 
                      type 
                      (+ (* size-y i) j) 
                      (array-ref array-in i))))
        ptr)))
  
;; this routine (play) is from the specification of SRFI/25 code set
(define (play arr)
  (let ((low (- (array-rank arr) 1))
        (shp (array-shape arr)))
    (define (play ks dim)
      (let* ((b (array-ref shp dim 0))
             (e (array-ref shp dim 1)))
        (write-prefix (reverse ks) b (- low dim))
        (if (= dim low)
            (let ((vec (share-array
                        arr
                        (shape b e)
                        (lambda (k)
                          (apply values (reverse (cons k ks)))))))
              (do ((k b (+ k 1)))
                ((= k e))
                (write-char #\space)
                (write (array-ref vec k)))
              (newline))
            (do ((k b (+ k 1)))
              ((= k e))
              (play (cons k ks) (+ dim 1))))))
    (define (write-prefix ks k cs)
      (for-each (lambda (k) (write k) (write-char #\:)) ks)
      (write k) (write-char #\.) (write-char #\.)
      (do ((cs cs (- cs 1))) ((= cs 0)) (write-char #\:))
      (when (> cs 0) (newline)))
    (if (zero? (array-rank arr))
        (begin
          (write (array-ref arr))
          (newline))
        (play '() 0))))

)
