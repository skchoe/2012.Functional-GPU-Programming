;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname |14.2|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ())))
;; bst is false or node.

(define-struct node (ssn name left right))

(define ex1 (make-node 35 'd (make-node 25 'i false false) false))

(define (inorder bt)
  (cond 
    [(false? bt) empty]
    [else 
     (append (inorder (node-left bt))
             (list (node-ssn bt))
             (inorder (node-right bt)))]))

(inorder ex1)

(define (search-bst n BST)
  (cond 
    [(false? BST) #f]
    [else 
     (cond 
       [(equal? n (node-ssn BST)) (node-name BST)]
       [(< n (node-ssn BST)) (search-bst n (node-left BST))]
       [else (search-bst n (node-right BST))])]))

(search-bst 25 false)
(search-bst 25 ex1)

       
(define web 
  '(The TeachScheme Web Page
        Here you can find: 
        (LectureNotes for Teachers)
        (Guidance for (DrScheme: a Scheme programming environment))
        (Exercise Sets)
        (Solutions for Exercises)
        For further information: write to scheme@cs))

(define (size a-wp) 
  (cond
    [(empty? a-wp) 0]
    [(symbol? (first a-wp)) (+ 1 (size (rest a-wp)))]
    [else (+ (size (first a-wp)) (size (rest a-wp)))]))

(size  web)
