#lang racket

(define filename "ptr_test.ss");;"alloc-launch.rkt");;cpyTest_kernel.cu");;cpyTest_kernel_sm_10.cubin");;Makefile")
(file-exists? (string->path filename))
(let* ([path1 (find-system-path 'orig-dir)]
       [path2 (string-append (path->string path1) filename)]);(string->path filename)])
  (if (directory-exists? path1)
      (printf "exists: ~a\n" path1)
      (printf "Not exists: ~a\n" path1))
  (if (file-exists? (string->path path2))
      (printf "exists: ~a\n" path2)
      (printf "Not exists: ~a\n" path2)))
