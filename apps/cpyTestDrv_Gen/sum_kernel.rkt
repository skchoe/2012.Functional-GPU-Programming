(module sum_kernel typed/racket

  (: test_kernel 
     ((Vectorof Float) Integer
                       -> 
                       (values (Vectorof Float) Integer)))
  (define (test_kernel array_in sgl_in)
    (values array_in 100))
)
