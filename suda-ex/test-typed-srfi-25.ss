#lang typed-scheme

(require "../typed-srfi-25.ss")

(define: A : Array
  (make-array (shape 1) 1))