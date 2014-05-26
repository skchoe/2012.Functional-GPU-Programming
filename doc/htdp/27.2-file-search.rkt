#lang racket

(require "tab-reader.rkt")
(require "../edit-distances/edit-distance-dp.rkt")
(require "../count-scantime-tiffsize-4-subfolders/file-list-recursive-unix.rkt")

(define-struct cdm_fileinfo (id cdm))
(define-struct fullres_fileinfo (fn path))

;; string -> string (length 1 at the end).
(define (last-char str)
  (and
   (string-longenough? str 1)
   (last (string->list str))))

(define (string-longenough? str len)
  (if (<= len (string-length str)) #t #f))
  
(define (second-last-char str)
  (and
   (string-longenough? str 2)
   (second (reverse (string->list str)))))

(define (third-last-char str)
  (and
   (string-longenough? str 3)
   (third (reverse (string->list str)))))

(define (fourth-last-char str)
  (and
   (string-longenough? str 4)
   (fourth (reverse (string->list str)))))

(define (remove-last-char str)
  (list->string (reverse (rest (reverse (string->list str))))))

(define (lower-char? ch)
  (and ch
       (<= (char->integer #\a) (char->integer ch) (char->integer #\z))))

(define (upper-char? ch)
  (and ch
       (<= (char->integer #\A) (char->integer ch) (char->integer #\Z))))

(define (digit-char? ch)
  (and ch
       (<= (char->integer #\0) (char->integer ch) (char->integer #\9))))

(define (filename->body fn)
  (let ([f (fourth-last-char fn)])
    (if f
        (if (char=? #\. f)
            (substring fn 0 (- (string-length fn) 4))
            fn)
        fn)))
;(last-char "sdfkasdjhfaslkdjfhlask")
;(second-last-char "sdfkasdjhfaslkdjfhlask")
;(remove-last-char "sdfkasdjhfaslkdjfhlask")

;; filename "namebody.ext" - last 4 digits - extension
;; namebody = XXXXXXX{a,b,c,d,e,f,g,h,i,j,k} -> XXXXXXXX
;; output = string
(define (filename->clue-word filename)
  (let* ([body (filename->body filename)]
         [lc (last-char body)]
         [lc2 (second-last-char body)])
    #;(if (or ;; part to take care of _001a.jpg from _001.tif
         (and (digit-char? lc2) (lower-char? lc))
         (and (digit-char? lc2) (upper-char? lc)))
        (remove-last-char body)
        body)
    body))
    
  
#;(filename->clue-word filename)
#;(filename->body "sdfkasdjhfaslkdjfhlask")
#;(filename->body "sdfkasdjhfaslkdjfhl.ask")
#;(filename->clue-word "AAA4b.rkt")

;; output = list of filenames close to input
;; compare string=? w.r.t. lower case
(define (search-close-file filename top-folder)
  #f)

(define filename "export_new.txt")
(define lolos (tab-txt->list-list-string filename))
(define loorgfn (map list-ref lolos (build-list (length lolos) (lambda (x) 1)))) ;; 1 is filename
(define locdmfn (map list-ref lolos (build-list (length lolos) (lambda (x) 3)))) ;; 3 is cdm filename
(define l-cdm-fn (map make-cdm_fileinfo loorgfn locdmfn))


(define (absfilename->filename absfn)
  (let ([los (string-split absfn #\/)])
    ;(printf "------------absfilename ~a from ~a \n" los absfn)
    (last los)))
   
;; path -> list of fullres_fileinfo 
(define (path->list-of-fr-fileinfo pth)
  (let* ([dfl (directory-list pth)] ;;; get files and directories
         [l-abs-path (map (λ (p) (path-append pth p)) dfl)] ;;; longpathes from input pth
         ;[v (printf "path:~a--l-abs-path:~a\n" (directory-exists? pth) l-abs-path)]
         [l-dir (filter directory-exists? l-abs-path)]
         [l-tifjpg (filter is-tif-jpg-jp2?
                           (map absfilename->filename 
                                (map path->string
                                     (filter file-exists? l-abs-path))))]
    
         ;[v (printf "l-dir:~a, l-imgfile:~a\n" l-dir l-tifjpg)]
         ;; file processing
         [lof-file (let loop ([out-list '()]
                              [in-list l-tifjpg])
                     (cond
                       [(empty? in-list) out-list]
                       [else 
                        (let* ([imgfile (car in-list)]
                               [new-out-lst (append out-list
                                                    (list (make-fullres_fileinfo imgfile 
                                                                                 (path->string pth))))])
                          (loop new-out-lst (rest in-list)))]))])
    ;; directory processing
    (for/fold ([lst-fr-fi lof-file])
      ([dir l-dir])
      (append lst-fr-fi (path->list-of-fr-fileinfo dir)))))

;; cdm string, fr:string -> number
(define (edit-distance-cdm-fr cdm fr)
  #;(let-values ([(lol dst) (edit-distances-dp cdm fr)])
    dst)
  (if (string=? cdm fr) 0 7)
)


(define topfolder-path (string->path "/Volumes/SPC-PhotoArchives"))
;topfolder-path
(define l-frfn (path->list-of-fr-fileinfo topfolder-path))
(printf "Final list of fullres_fileinfo : ~a\n" (map fullres_fileinfo-fn l-frfn))


(define (compare-and-output l-cdm-fn l-frfn)
  (let* ([p0 (open-output-file (string->path "ed0.txt")
                              #:mode 'text
                              #:exists 'replace)]
         [p1 (open-output-file (string->path "ed1.txt")
                              #:mode 'text
                              #:exists 'replace)]
         [p2 (open-output-file (string->path "ed2.txt")
                              #:mode 'text
                              #:exists 'replace)]
         [p3 (open-output-file (string->path "ed3.txt")
                              #:mode 'text
                              #:exists 'replace)]
         [p4 (open-output-file (string->path "ed4.txt")
                              #:mode 'text
                              #:exists 'replace)]
         [p5 (open-output-file (string->path "ed5.txt")
                              #:mode 'text
                              #:exists 'replace)]
         [p6 (open-output-file (string->path "ed6.txt")
                              #:mode 'text
                              #:exists 'replace)]
         #;[px (open-output-file (string->path "edx.txt")
                              #:mode 'text
                              #:exists 'replace)])
    (printf "LFRFN:~a\n" (map fullres_fileinfo-fn l-frfn))
    (printf "Length fullres:~a\n" (length l-frfn))
    
    (let loop-out ([cnt 0]
                   [lc l-cdm-fn])
      (cond 
        [(empty? lc) #t]
        [else 
         (begin
           (printf "cdm: ~a ~a th / ~a\n" (cdm_fileinfo-id (car lc)) (add1 cnt) (length l-cdm-fn))
           (let loop-in ([lf l-frfn])
             (cond
               [(empty? lf) #t]
               [else 
                (let* ([c (car lc)]
                       [f (car lf)]
                       [lw-c (string-downcase (filename->clue-word (cdm_fileinfo-id c)))]
                       [lw-f (string-downcase (filename->clue-word (fullres_fileinfo-fn f)))]
                       [ed (edit-distance-cdm-fr lw-c lw-f)]
                       [disp-line (string-append (cdm_fileinfo-cdm c) "\t"
                                          (cdm_fileinfo-id c) "\t" 
                                          lw-c "\t"
                                          "<->" "\t"
                                          lw-f "\t"
                                          (fullres_fileinfo-fn f) "\t"
                                          (fullres_fileinfo-path f) "\t"
                                          (number->string ed) "\n")])
                  (if (not (zero? ed))
                      (loop-in (rest lf))
                      (begin (display disp-line p0)
                             (loop-out (add1 cnt) (rest lc)))))]))
           
           (loop-out (add1 cnt) (rest lc)))]))
    
    (close-output-port p0)
    (close-output-port p1)
    (close-output-port p2)
    (close-output-port p3)
    (close-output-port p4)
    (close-output-port p5)
    (close-output-port p6)
    #;(close-output-port px)
    ))

(compare-and-output l-cdm-fn l-frfn)