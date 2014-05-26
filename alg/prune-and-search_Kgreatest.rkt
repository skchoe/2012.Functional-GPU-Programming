#lang racket
(define (partition data p)
  (let loop([c data]
            [s '()]
            [e '()]
            [l '()])
    (cond
      [(empty? c) (values (reverse s) (reverse e) (reverse l))]
      [else (let ([o (first c)])
              (cond
                [(< o p) (loop (rest c) 
                                (cons o s) e l)]
                [(equal? o p) (loop (rest c) s (cons o e) l)]
                [(> o p) (loop (rest c) s e (cons o l))]))])))


(define (choose-pivot-first data)
  (cond [(empty? data) (error "data cannot be empty")]
        [else (first data)]))



(define (prune-and-search-pivot data k pivot-selection-method)
  (let*-values
   ([(p) (pivot-selection-method data)]
    [(s e l) (partition data p)])
    (printf "p(~a),  k(~a),  ~a, ~a, ~a\n" p k s e l)
   
   (let ([ns (length s)]
         [ne (length e)]
         [nl (length l)])
     (cond
       [(<= k nl) (prune-and-search-pivot l k pivot-selection-method)]
       [(<= k (+ ne nl)) p]
       [else (prune-and-search-pivot s (- k ne nl) pivot-selection-method)]))))
;(partition 
; '(12 12 3 5 5 4 32 5 6 75 56 78 23 4) 12)

#;(prune-and-search
  '(12 12 3 5 5 4 32 5 6 75 56 78 23 4) 12)



;; sort: data -> data
;; data is sorted list
;; insert x into data with the comparison operator, comp_op (<=, <, equal?, >, or >=)
(define (insert x data comp_op)
  (cond
    [(empty? data) (cons x empty)]
    [else 
     (cond
       [(comp_op x (first data)) (cons x data)]
       [else (cons (first data) (insert x (rest data) comp_op))])]))

(insert 4 '() <=)
(insert 5 '() > )
;; insertion-sort: sort data by comp_op.
(define (insertion-sort data comp_op)
  (cond 
    [(empty? data) data]
    [else 
     (insert (first data) (insertion-sort (rest data) comp_op) comp_op)]))

(insertion-sort '( 9 7 5 4 2 1) <=)
(insertion-sort '( 9 7 5 4 2 1) >)

;; input data - list of element
;; output - list of local medians
(define (all-medians data) #f)
;(let loop([median-list '()])
;  (cond [(empty? data) (error "data empty")]
;        [else
;         (let
;          ([data-len (length data)]
;           [m (/ data-len 5)]
;           [i (any '(1..m))]
;           [median ('((- (* i 5) 4)..(* i 5)) (- (* i 5) 2))]))
;         (cons (median median-list))
;         ])))

  ;; lst -> list of sublst
;; (length sublst) = 5
(define (divide-to-groups lst)
  (let* ([N (length lst)]
         [num-grp (ceiling (/ N 5))])
    (let loop ([cnt 0]
               [rst lst]
               [sublst '()]
               [collector '()]
               [gidx 0])
      (cond 
        [(equal? gidx num-grp) collector]
        [else
         (cond 
           [(equal? cnt 5) (loop 0 rst '()
                                 (cons sublst collector)
                                 (add1 gidx))]
           [else (if (empty? rst)
                     (loop (add1 cnt) '() (cons +inf.0 sublst) collector gidx)
                     (loop (add1 cnt) (rest rst) (cons (car rst) sublst) collector gidx))])]))))

(define (map-sort lol)
  (cond [(empty? lol) '()]
        [else (cons (insertion-sort (car lol) <=) (map-sort (rest lol)))]))

;; lst: sorted list -> median element
(define (mdn-sort lst)
  (let ([sl (insertion-sort lst <=)])
    (list-ref sl (floor (/ (sub1 (length sl)) 2)))))

(define (map-mdn lol proc)
  (cond [(empty? lol) '()]
        [else (cons (proc (car lol)) (map-mdn (rest lol) proc))]))

(define (choose-pivot-mom lst)
  (cond
    [(<= (length lst) 5) (mdn-sort lst)]
    [else
     (let*-values 
         ;; step 1. - [n/5] groups
         ([(lol) (divide-to-groups lst)]
          [(x) (printf "DIVISN: ~a\n" lol)]
          ;; step 2 - sort each sublst
          [(losl) (map-sort lol)])
       ;; step 3 - p? : median of median
       (mdn-sort (map-mdn losl mdn-sort)))]))


;(choose-pivot-second '( 1 3 5 7 8 5 3))
(define ex1 '( 1 3 5 7 8 5 3 10 334 45 67 78 5 2 6 9))
;(define k1 (floor (/ (- (length ex1) 1) 2)))

(insertion-sort ex1 <=)
(insertion-sort ex1 >)

;(choose-pivot-mom ex)


;(prune-and-search-pivot ex1 k1 choose-pivot-first)
;(prune-and-search-pivot ex1 k1 choose-pivot-mom)

;(define (random-list size max-value)
;  (build-list size (lambda (x) (random max-value))))

;(define ex2 (random-list 100 10000))
;(define k2 (floor (/ (- (length ex2) 1) 2)))
;(prune-and-search-pivot ex2 k2 choose-pivot-first)
;(prune-and-search-pivot ex2 k2 choose-pivot-mom)
