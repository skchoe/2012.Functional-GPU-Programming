#lang scheme
(require scheme/foreign)
(unsafe!)


(free (malloc (ctype-sizeof _int) 'raw))
