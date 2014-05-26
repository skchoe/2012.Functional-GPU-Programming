(module calling-mapping scheme
  
  (require "the-mapping.ss")
  (require (for-syntax "the-mapping.ss"))  (provide call-out-mapping)
  (define (call-out-mapping lst lst-id)
    (for ([k (in-range (length lst))])
      (let ([ids (list-ref lst-id k)])
        (printf "id = ~s: ~s\n" (syntax-e ids) ids)
        (if (identifier? ids)
            (printf "~s is successfully retrieved\n" (mp-get ids))
            (printf "non-IDIENTIFIER\n"))))))