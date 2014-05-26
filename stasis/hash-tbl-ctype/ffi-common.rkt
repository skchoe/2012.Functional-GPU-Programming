#lang racket
(require ffi/unsafe)
(provide (all-defined-out))


;; one byte -> 1
(define _byte-size (ctype-sizeof _byte))


(define (string-size-byte str)
  (* (string-length str) _byte-size))


(define INIT-CHAR #\space) ;; byte for `space' #\space in scheme


;; set all byte to be INIT-CHAR.
#;(define (zero-fill ptr size-b char)
  (for ([i (in-range size-b)])
    (ptr-set! ptr _byte i (char->integer char))))

(define (zero-fill ptr size-b char)
  (memset ptr (char->integer char) size-b _byte))



;; string -> lst-char -> lst-ascii-code -> set-the-code in ptr at pos.
(define (string->ptr str)
  (let* ([lstr (string->list str)]
         [len (length lstr)]
         
         [ptr (malloc (* len _byte-size) _byte)] ;; alloc one more byte
         [p (for/fold ([p-str ptr])
              ([i (in-range len)])
              (let ([byv (char->integer (list-ref lstr i))])
                (ptr-set! p-str _byte (* i _byte-size) byv)
                p-str))])

    #;(printf "__string->ptr of ~a-->\n" str)
    #;(for ([i (in-range len)])
      (let ([e (ptr-ref p _byte (* i _byte-size))])
        (printf "(string->ptr: ~ath str:~a(~a)\n" i e (integer->char e))))
    p))

;;  byte-string -> alloc-ptr -> set each byte to ptr -> ptr : cpointer
(define (bytes->ptr bys)
  (let* ([len (bytes-length bys)];; number of bytes
         [ffi-cstr (malloc len _byte)])
    (zero-fill ffi-cstr len INIT-CHAR)
    (for-each (λ (pos by)
                (ptr-set! ffi-cstr _byte pos by))
              (build-list len values)
              (bytes->list bys))
    ffi-cstr))
  
;; cpointer -> byte-string in
;; num-elt: constraint size(Byte)
(define (ptr->bytes ptr num-elt [type _byte])
  (let loop ([lst '()]
             [cnt 0])
    (cond 
      [(equal? cnt num-elt) (list->bytes (reverse lst))]
      [else (let* ([elt (ptr-ref ptr type cnt)])
              #;(printf "~ath elt:~a\n" cnt elt)
              (loop (cons elt lst) (add1 cnt)))])))
  
;; looking for delimiter 'return'=code INIT-CHAR=0, from the back to allow INIT-CHAR in between constraint elements
(define (ptr->string ptr num-bytes [modifier (λ (x) (integer->char x))])
  (cut-from-last ptr num-bytes INIT-CHAR modifier))


(define (cut-from-last ptr num-bytes char-by modifier)
  (let-values
      ([(l-by flg)
         (for/fold ([l-byte '()]
                    [flg #f]) ; #t means iterator meet non-char-by byte 
           ([i (in-range (- num-bytes 1) -1 -1)])
           (let ([elt (ptr-ref ptr _byte (* i _byte-size))])
             #;(printf "cut-from-last:~a - ~a ~a\n" i elt (integer->char elt))
             (if (equal? char-by elt)
                 (if flg (values (cons elt l-byte) flg) (values l-byte flg))
                 (values (cons elt l-byte) #t))))])
    #;(printf "ptr---->string lby:=>~a\n ~a\n\n" l-by (map integer->char l-by))
    (list->string (map modifier l-by))))

(define (cut-from-first ptr num-bytes char-by)
  (let-values
      ([(l-by flg)
         (for/fold ([l-byte '()]
                    [flg #t]) ; #t means continue update.
           ([i (in-range num-bytes)] #:when flg)
           (let ([elt (ptr-ref ptr _byte (* i _byte-size))])
             #;(printf "cut-from-first:~a - ~a ~a\n" i elt (integer->char elt))
             (if (equal? char-by elt) 
                 (values l-byte #f)
                 (values (append l-byte (list elt)) flg))))])
    #;(printf "ptr---->string lby:~a, ~a\n" l-by (map integer->char l-by))
    (list->string (map integer->char l-by))))
     
