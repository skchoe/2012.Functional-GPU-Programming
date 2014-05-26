#lang racket

(provide (all-defined-out))
(define (generate-cubin module-path)
  (begin 
    (printf "MODULE-Path in scuda.ss : ~a\n" module-path)
    (system "make")
    module-path))

(define (generate-kernel-bin folder kernel-name)
  (let ([oport (open-output-file (string->path "Makefile") #:mode 'text #:exists 'replace)])
    (system (string-append "gracket " kernel-name "_kernel.rkt"))
    (display (string->symbol (makefile-content folder kernel-name)) oport)
    (close-output-port oport)
    (system "make")
    (string-append folder "/" kernel-name "_kernel.cu")))
    
(define (makefile-content dir kernel)
  (string-append 
"# Add source files here
EXECUTABLE      := " kernel "
# Cuda source files (compiled with cudacc)
CUBINFILES      := " kernel "_kerenl.cu 
# C/C++ source files (compiled with gcc / c++)
CCFILES         := \
\t" kernel ".cpp
USEDRVAPI     := 1
#lib to verify.
SOFILE  := #libmatrixMul_gold.so

################################################################################
# Rules and targets
include ../../sdk-ex/_common.mk

all:
\tmake clean
\tnvcc -o $(EXECUTABLE) -keep $(CUBINFILES) $(CCFILES) -I. -I$(CUDAHOME)/include -I$(CUDASDKHOME)/common/inc -L. -L$(CUDALIB) -L$(CUDASDKHOME)/lib -L$(CUDASDKHOME)/common/lib/linux -lcuda -lcutil_$(LIB_ARCH)

\tmkdir data
\tmv *.cubin " dir "\n
\trm *.o *.cu.cpp *.cubin *.hash *.i *.ii *.cudafe* *.gpu* *.fatbin* *.ptx *.cu.c *.*~

clean:
\trm -rf $(SOFILE) $(EXECUTABLE) data obj *.o *.cu.cpp *.cu.c *.cubin *.hash *.i *.ii *.cudafe* *.gpu* *.fatbin* *.ptx
#gcc -fPIC -shared -o $(SOFILE) matrixMul_gold.cpp -I$(CUDAHOME)/include -I$(CUDASDKHOME)/common/inc -L. -L$(CUDAHOME)/lib -L$(CUDASDKHOME)/lib -L$(CUDASDKHOME)/common/lib/linux -lcuda -lcutil
"))

#;(makefile-content "data" "sum")

#;(generate-kernel-bin "data" "sum")
  