#lang racket


(define-struct level (type name children))

;; 1)
(define ks (make-level 'species 'anim-s '()))
(define kg (make-level 'genus 'anim-g (cons ks '())))
(define kf (make-level 'family 'anim-f (cons kg '())))
(define ko (make-level 'order 'anim-o (cons kf '())))
(define kc (make-level 'class 'anim-c (cons ko '())))
(define kp (make-level 'phylum 'anim-p (cons kc '())))
(define hk (make-level 'kingdom 'anim (cons kp'())))

(define hspecies (make-level 'species 'Sapien '()))
(define hgenus (make-level 'genus 'Homo (cons hspecies '())))
(define hkingom (make-level 'kingdom 'Animalia (cons hgenus '())))
  
;; 2)
(define (child-names name t-node)
  (cond 
    [(empty? t-node) '()]
    [(symbol=? name (level-name t-node)) (map level-name (level-children t-node))]))

(child-names 'anim-o ko)
(child-names 'anim hk)

;; 3)
(define (is-classified? type name-string t-node)
  (local ((define (is-classified?/list type name-string lst-t-node)
            (cond 
              [(empty? lst-t-node) #f]
              [else 
               (local ((define result (is-classified? type name-string (first lst-t-node))))
                 (if result #f (is-classified?/list type name-string (rest lst-t-node))))])))
    
    (let ([name-sym (string->symbol name-string)])
      (cond
        [(and (symbol=? type (level-type t-node))
              (symbol=? name-sym (level-name t-node))) #t]
        [else (is-classified?/list type name-string (level-children t-node))]))))

(is-classified? 'kingdom "anim" hk)
(is-classified? 'class "anim-c" kc)

;; 4)
;; output (or? typename false)
(define (get-type name-string t-node)
  (local ((define (get-type/list name-string lst-t-node)
            (cond
              [(empty? lst-t-node) #f]
              [else
               (let ([ty (get-type name-string (first lst-t-node))])
                 (if ty 
                     (symbol->string ty)
                     (get-type/list name-string (rest lst-t-node))))])))
    
    (let ([name-sym (string->symbol name-string)])
      (cond 
        [(symbol=? name-sym (level-name t-node)) 
         (symbol->string (level-type t-node))]
        
        [(empty? (level-children t-node)) #f]
        [else 
         (let ([ty (get-type name-string (first (level-children t-node)))])
           (if ty (symbol->string ty) (get-type/list name-string (rest (level-children t-node)))))]))))

(get-type "anim" hk)

;;5)
;; ouput : list of names having the type.
(define (get-all-name type-sym t-node)
  (local ((define (get-all-name/list type-sym lst-t-node)
            (for/fold ([result '()])
              ([i (in-range (length lst-t-node))])
              (get-all-name type-sym (list-ref lst-t-node i)))))
    (let loop ([out-list '()]
               [children '()])
      (if (symbol=? (level-type t-node) type-sym)
          (cons type-sym (get-all-name/list type-sym (level-children t-node)))
          (get-all-name/list type-sym (level-children t-node))))))

(get-all-name 'kingdom hk)

;; 6)
;; output list-of-name
(define (get-species-under-type type name-string t-node)
  #f)
    
  