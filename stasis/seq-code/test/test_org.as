(let (cons-it (lambda (x) (let (r (cons x x)) r)))
     (let (t1 1)
       (let (pair1 (apply cons-it t1))
         (let (t3 3)
         (let (t2 2)
           (let (pair2 (apply cons-it t2))
             (let (a (car pair2))
               a)))))))))