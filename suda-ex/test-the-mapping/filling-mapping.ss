
(module filling-mapping scheme
  (require "the-mapping.ss")
  (require (for-syntax "the-mapping.ss"))
  (provide fill-in-mapping)
  (define (fill-in-mapping lst lst-id)
    (for ([j (in-range (length lst))])
      (let ([ids (list-ref lst-id j)])
        (if (identifier? ids)
            (begin (mp-put! ids (list-ref lst j))
                   (printf "~s is successfully inserted(~s)\n" (mp-get ids) (syntax->datum ids)))
            (printf "non-IDIENTIFIER\n"))))))