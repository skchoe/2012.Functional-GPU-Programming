(module glew_h mzscheme
(require scheme/foreign
         "glew-libs.ss") 
  
(provide (all-defined))
  
;GLEWAPI GLenum glewInit ();
(define-foreign-glew glewInit
                        -> (result : _uint))

;GLEWAPI GLboolean glewIsSupported (const char* name);
(define-foreign-glew glewIsSupported
	_pointer -> _bool)

)
