#lang racket
(require ffi/unsafe)

(provide (all-defined-out))

;; Shared object for constraint solver on CPU
(define sba-cpu-shared-path (string->path
                             (string-append
                              (path->string (find-system-path 'home-dir))
                              "project-gpu/lib/")))

(define sba-cpu-so (string->path
                    (string-append
                     (path->string sba-cpu-shared-path)
                     "libsba_clib.so")))

(define sba-cpu-lib (case (system-type)
                      [(windows) (ffi-lib "nvcuda")]
                      ; windows: currently unsupported
                      [(macosx) (ffi-lib "/System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libcuda")]
                      ; macosx: currently unsupported
                      [else (ffi-lib sba-cpu-so)]))

;; Shared object for constraint solver on GPU
(define sba-gpu-shared-path (string->path
                             (string-append
                              (path->string (find-system-path 'home-dir))
                              "project-gpu/lib/")))

(define sba-gpu-so (string->path
                    (string-append
                     (path->string sba-gpu-shared-path)
                     "libsba_culib.so")))

(define sba-gpu-lib (case (system-type)
                      [(windows) (ffi-lib "nvcuda")]
                      ; windows: currently unsupported
                      [(macosx) (ffi-lib "/System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libcuda")]
                      ; macosx: currently unsupported
                      [else (ffi-lib sba-gpu-so)]))



;; helper functions in gl.ss
(define (unavailable name)
  (lambda ()
    (lambda x
      (error name "unavailable on this system"))))

(define-syntax define-foreign-lib
  (syntax-rules (->)
    ((_ lib name type ... ->)
     (define-foreign-lib lib name type ... -> _void))
    ((_ lib name type ...)
     (begin
       (provide name)
       (define name
         (get-ffi-obj 'name lib (_fun type ...) (unavailable 'name)))
       ;(printf "~s: defined\n" 'name)
))))

(define-syntax define-foreign-sba-cpu
  (syntax-rules ()
    ((_ args ...)
     (define-foreign-lib sba-cpu-lib args ...))))

(define-syntax define-foreign-sba-gpu
  (syntax-rules ()
    ((_ args ...)
     (define-foreign-lib sba-gpu-lib args ...))))


(define-cstruct _sba-stream ([num-const _pointer]
                             [constnames _pointer]
                             [constm _pointer]))


;; gstm_driver.h
(define-foreign-sba-cpu ffi_tester _int -> _int)
;; gstm_common.h
(define-foreign-sba-cpu SbaStream_init_empty _int -> _sba-stream-pointer) ;; output is a pointer of sba-stream
(define-foreign-sba-cpu print_num_const _int (_cpointer 'int) ->)
(define-foreign-sba-cpu print_constraint_stream _int _int _pointer ->)

;; CPU solver
;void solver_constraint_wrapper(SbaStream* ss_in, 
;                               int num_var,
;			       int var_max_size,
;			       SbaStream* ss_out_analysis);
(define-foreign-sba-cpu solver_constraint_wrapper _sba-stream-pointer _int _int (ss_out : _sba-stream-pointer) _int _int -> _void -> ss_out)

;; GPU solver
;; matrix form of constraint structure
;void sba_solve_stm(SbaStream* ss_in, int num_var, size_t var_const_max, SbaStream* ss_out_analysis,
;		int is_uniform_var_width, int is_equal_const_size);
(define-foreign-sba-gpu sba_solve_stm _sba-stream-pointer _int _int (ss_out : _sba-stream-pointer) _int _int -> _void -> ss_out)

;; csr structure of constraint structure
;void sba_solve_csr(SbaStream* ss_in, int num_var, size_t var_const_max, SbaStream* ss_out_analysis,
;		int is_uniform_var_width, int is_equal_const_size);
(define-foreign-sba-gpu sba_solve_csr _sba-stream-pointer _int _int (ss_out : _sba-stream-pointer) _int _int -> _void -> ss_out)

