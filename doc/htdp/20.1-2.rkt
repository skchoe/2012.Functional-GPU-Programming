;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname 20.1-2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ())))
<def> 	=	  (define (<var> <var> ...<var>) <exp>)
		| (define <var> <exp>)
		| (define-struct <var0> (<var-1> ...<var-n>))
<exp> 	=	  <var>
		| <con>
		| (<prm> <exp> ...<exp>)
		| (<var> <exp> ...<exp>)
		| (cond (<exp> <exp>) ...(<exp> <exp>))
		| (cond (<exp> <exp>) ...(else <exp>))
		| (and <exp> <exp>)
		| (or <exp> <exp>)
<var> 	=	  x | area-of-disk | perimeter | ...
<con> 	=	  true | false
		  'a | 'doll | 'sum | ...
		  1 | -1 | 3/5 | 1.22 | ...
<prm> 	=	  + | - | ...                
Figure 24:  Beginning Student Scheme: The full grammar

<val> = <con>
<con> 	=	  true | false
		  'a | 'doll | 'sum | ...
		  1 | -1 | 3/5 | 1.22 | ...
Values in Beginning Student
----------------------------------------------------------------------------

<def> 	=	  (define (<var> <var> ...<var>) <exp>)
		| (define <var> <exp>)
		| (define-struct <var> (<var> <var> ...<var>))
<exp> 	=	  <var>
		| <boo>
		| <sym>
		| <prm>
		| empty
		| (<exp> <exp> ...<exp>)
		| (cond (<exp> <exp>) ...(<exp> <exp>))
		| (cond (<exp> <exp>) ...(else <exp>))
		| (local (<def> ...<def>) <exp>)
<var> 	=	  x | area-of-disk | circumference | ...
<boo> 	=	  true | false
<sym> 	=	  'a | 'doll | 'sum | ...
<num> 	=	  1 | -1 | 3/5 | 1.22 | ...
<prm> 	=	  + | - | cons | first | rest | ...

Figure 56:  Intermediate Student Scheme: The grammar

<val> 	= 	  <boo> | <sym> | <num> | empty | <lst>
		| <var> (names of defined functions)
		| <prm>
<lst> 	= 	empty | (cons <val> <lst>) 
Values in Intermediate Student