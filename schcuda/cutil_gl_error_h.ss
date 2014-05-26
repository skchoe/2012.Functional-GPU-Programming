(module cutil_gl_error_h mzscheme
  (require sgl)

(provide cutCheckErrorGL)
(define (cutCheckErrorGL filename line)
  (let* ([ret_val #t]

         ;// check for error
         [gl_error (gl-get-error)])
    (if (not (equal? gl_error 'GL_NO_ERROR))
        (begin
          (printf "GL Error in file '~s' in line ~s :\n" filename line)
          (printf "~s\n" (gl-get-string 'gl_error))
          #f);CUTFalse)
        ret_val)))
  )

