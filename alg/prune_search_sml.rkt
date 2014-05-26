#lang racket

(define (check-range len k)
  ;(printf "rng - len:~a, k:~a\n" len k)
  (cond [(not (number? k)) #f]
        [(>= 0 k) #f]
        [(< len k) #f]
        [else #t]))
      
;; k >= 1. 
(define (sort-and-pick lst k)
  (list-ref (sort lst <) (- k 1)))

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
        [else (cons (sort (car lol) <) (map-sort (rest lol)))]))

;; lst: sorted list -> median element
(define (mdn-sort lst)
  (let ([sl (sort lst <)])
    (list-ref sl (floor (/ (sub1 (length sl)) 2)))))

(define (mdn lst) 
  (prune-and-search lst 
                    (add1 (floor (/ (sub1 (length lst)) 2)))))

(define (map-mdn lol proc)
  (cond [(empty? lol) '()]
        [else (cons (proc (car lol)) (map-mdn (rest lol) proc))]))

;; lst, p -> s1 s2 s3
(define (partition lst p )
  (let loop ([l lst]
             [s1 '()]
             [s2 '()]
             [s3 '()])
    (cond 
      [(empty? l) (values (reverse s1) (reverse s2) (reverse s3))]
      [else
         (let ([e (first l)])
           (cond 
             [(< e p)      (loop (rest l) (cons e s1) s2 s3)]
             [(equal? e p) (loop (rest l) s1 (cons e s2) s3)]
             [else         (loop (rest l) s1 s2 (cons e s3))]))])))
              
 
;; k>= 1.
(define (prune-and-search lst k)
  (cond
    [(not (check-range (length lst) k)) (error "picking out of range")]
    [(< (length lst) 5) (list-ref (sort lst <) (sub1 k))]
    [else
     (let*-values 
         ;; step 1. - [n/5] groups
         ([(lol) (divide-to-groups lst)]
          ;; step 2 - sort each sublst
          [(losl) (map-sort lol)]
          ;; step 3 - p? : median of median
          [(p) (mdn-sort (map-mdn losl mdn-sort))]
          ;; step 4 - partition)
          [(s1 s2 s3) (partition lst p)])
       
       (printf "P : ~a\n" p)
       (printf "s1:~a, s2:~a, s3:~a\n" s1 s2 s3)
       
       ;; step 5 - check size/k, recurse
       (let* ([len1 (length s1)]
              [len2 (length s2)]
              [len3 (length s3)])
         (cond
           [(<= k len1) (prune-and-search s1 k)]
           [(<= k (+ len1 len2)) p]
           [else (prune-and-search s3 (- k len1 len2))])))]))
          
;(mdn '(2 3 4 3 1 4 6 3 1))
;(mdn '(1))
;(partition '( 2 4 6  2 5  2 1 4 7 8) 5)        
(mdn-sort (map-mdn (map-sort  (divide-to-groups '(1 2 3 4 5 3 2 1))) mdn-sort))
;(prune-and-search '(4 7 4 5 23 1) 6)
(define input '(1  2 3   2 38 7   6 23   23  9  4 5  8))
(map-mdn (map-sort (divide-to-groups input)) mdn-sort)
;(prune-and-search input 6)
;(prune-and-search '(1 2 3 4 5 3 2 1) 3)