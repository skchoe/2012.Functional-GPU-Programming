#lang scribble/doc

@(require scribble/manual
          scribble/extract)

@title[#:tag "const"]{Generation of constraints}


@;@(include-extracted "test-srcdoc.rkt")
@section{Alpha Conversion}
@(include-extracted "alpha-conversion.rkt")

@section{A-Normal Form}
@(include-extracted "a-normal-to-simple-rep.rkt")

@section{Constraint Generation}
@(include-extracted "SBA-gen-constraints.rkt")

@section{Common procedures}
@;@(include-extracted "commons.rkt")



@;{
@(include-extracted "scribble-test.rkt")
	@(include-extracted "commons.rkt")
   
	@(include-extracted "../stasis/input-progs/ex-code-gen.rkt")
    	@;@defmodule[stasis/rkt-app/common/a-normal-to-simple-rep]
    	Redefinition of binding using distance.
    	@(include-extracted "../rkt-app/common/a-normal-to-simple-rep.rkt")
}
  
  
@;{
   	@defmodule[stasis/rkt-app/common/encoding-constraints]
	Def module encoding strategy
	@defmodule[stasis/rkt-app/common/nameless-constraints]
	Def module nameless conversion
	@defmodule[stasis/rkt-app/common/SBA-gen-constraints]
	Def module constraint generation
}
