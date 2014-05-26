#lang racket
(define prog
  '(let (x (let (z-proc (lambda (z) 
                          (let (z1 (cons z z))
                            z1)))
             (let (w-proc (lambda (w) 
                            (let (z-proc (cdr w))
                              z-proc)))
               (let (cons1 (cons 1 1))
                 (let (app-w (apply w-proc cons1))
                   (let (app-zw (apply z-proc app-w))
                     app-zw))))))
     (let (x (lambda (y) 
                    (let (y1 (cons y y)) 
                      y1)))
       (let (car-x (car x))
         (let (app-yx (apply x car-x))
           app-yx)))))

