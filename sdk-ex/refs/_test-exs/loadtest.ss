#lang racket
(unless (namespace-variable-value 'Section #f (lambda () #f))
  (load-relative "testing.ss"))
