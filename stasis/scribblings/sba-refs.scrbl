#lang scribble/manual
@(require scribblings/scribble/utils)

@title[#:style '(toc)]{Set-based static analysis of Racket programs}

@author[@author+email["Seungkeol Choe" "skchoe@cs.utah.edu"]]
@table-of-contents[]

This scribble document describes mainly the prototypes of functions on constraints generation, example program generations.

@; ------------------------
@include-section["run.scrbl"]
@include-section["../rkt-app/common/gen-constraints.scrbl"]
@include-section["constraints-solver.scrbl"]
@include-section["inputs.scrbl"]

@;@index-section[]
