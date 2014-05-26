#lang at-exp racket/base 

(require racket/list
         racket/local
         racket/match
         racket/pretty
         racket/contract
         scribble/srcdoc
         "commons.rkt"
         (for-doc racket/base
                  scribble/manual))

#|
(require ffi/unsafe
         racket/bool
         racket/local
         racket/match
         racket/pretty
         racket/set
         racket/list
         "../../hash-tbl-ctype/hash-ffi-string.rkt"
         "../../hash-tbl-ctype/hash-ffi-strarray.rkt"
         "../../hash-tbl-ctype/ffi-common.rkt"
         "../../seq-code/SBA-utils.rkt"

         "commons.rkt"
         "alpha-conversion.rkt"
         "a-normal-to-simple-rep.rkt"
         "encoding-constraints.rkt"
         
         "ffi-sbastream.rkt"
         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
         ;; code made maually
         #;"../../input-progs/input-progs-forseq.rkt"
         ;; code generated
         "../../input-progs/input-prog-gen.rkt")
|#


(define LZ_MAX_CODE 4095)

(define GifVersionPrefix #"GIF89a")

(provide
 (proc-doc/names gif-stream?
                 (-> any/c boolean?)
                 (v)
                 @{Returns @racket[#t] if @racket[v] is a GIF stream created by
                           @racket[gif-write], @racket[#f] otherwise.})
 
 (proc-doc/names image-ready-gif-stream?
                 (-> any/c boolean?)
                 (v)
                 @{Returns @racket[#t] if @racket[v] is a GIF stream that is not in
                           @racket['done] mode, @racket[#f] otherwise.})
 (proc-doc/names image-or-control-ready-gif-stream?
                 (-> any/c boolean?)
                 (v)
                 @{Returns @racket[#t] if @racket[v] is a GIF stream that is in
                           @racket['init] or @racket['image-or-control] mode, @racket[#f]
                           otherwise.})
 (proc-doc/names empty-gif-stream?
                 (-> any/c boolean?)
                 (v)
                 @{Returns @racket[#t] if @racket[v] is a GIF stream that in
                           @racket['init] mode, @racket[#f] otherwise.})
 (proc-doc/names gif-colormap?
                 (-> any/c boolean?)
                 (v)
                 @{Returns @racket[#t] if @racket[v] represets a colormap,
                           @racket[#f] otherwise.  A colormap is a list whose size is a power
                           of @math{2} between @math{2^1} and @math{2^8}, and whose elements
                           are vectors of size 3 containing colors (i.e., exact integers
                                                                          between @math{0} and @math{255} inclusive).})
 (proc-doc/names color?
                 (-> any/c boolean?)
                 (v)
                 @{The same as @racket[byte?].})
 (proc-doc/names dimension?
                 (-> any/c boolean?)
                 (v)
                 @{Returns @racket[#t] if @racket[v] is an exact integer between
                           @racket[#x0] and @racket[#xFFFF] inclusive, @racket[#f]
                           otherwise.}))

(define-struct gif-stream
  (port SWidth SHeight SBackGroundColor SColorMap [FileState #:mutable]))

(define (image-ready-gif-stream? g)
  (and (gif-stream? g)
       (memq (gif-stream-FileState g) '(init image-or-control image))))

(define (image-or-control-ready-gif-stream? g)
  (and (gif-stream? g)
       (memq (gif-stream-FileState g) '(init image-or-control))))

(define (empty-gif-stream? g)
  (and (gif-stream? g)
       (memq (gif-stream-FileState g) '(init))))

(define color? byte?)
(define (dimension? x) (and (exact? x) (integer? x) (<= 0 x #xFFFF)))

(define (gif-colormap? l)
  (and (list? l)
       (member (length l) '(2 4 8 16 32 64 128 256))
       (andmap (lambda (c)
                 (and (vector? c)
                      (= 3 (vector-length c))
                      (color? (vector-ref c 0))
                      (color? (vector-ref c 1))
                      (color? (vector-ref c 2))))
               l)))

(define (color-map->bytes ColorMap)
  (apply bytes (apply append (map vector->list ColorMap))))

(define (bits-per-pixel ColorMap)
  (case (length ColorMap)
    [(2) 1] [(4) 2] [(8) 3] [(16) 4] [(32) 5] [(64) 6] [(128) 7] [(256) 8]
    [else (error 'bits-per-pixel
                 "strange colormap size: ~e"
                 (length ColorMap))]))

(define (WRITE g bytes)
  (write-bytes bytes (gif-stream-port g)))

#;(provide/doc (proc-doc/names gif-state
                             (-> gif-stream? symbol?)
                             (stream)
                             @{Returns the state of @racket[stream].}))
(define (gif-state GifFile)
  (gif-stream-FileState GifFile))

;;/******************************************************************************
;; * This routine should be called before any other EGif calls, immediately
;; * follows the GIF file openning.
;; *****************************************************************************/
#;(provide/doc (proc-doc/names
              gif-start
              (-> output-port?
                  dimension?
                  dimension?
                  color?
                  (or/c gif-colormap? #f)
                  gif-stream?)
              (out w h bg-color cmap)
              @{Writes the start of a GIF file to the given output port, and
                returns a GIF stream that adds to the output port.

                The width and height determine a virtual space for the overall
                GIF image.  Individual images added to the GIF stream must fit
                within this virtual space.  The space is initialized by the
                given background color.

                Finally, the default meaning of color numbers (such as the
                background color) is determined by the given colormap, but
                individual images within the GIF file can have their own
                colormaps.

                A global colormap need not be supplied, in which case a
                colormap must be supplied for each image. Beware that the
                bg-color is ill-defined if a global colormap is not
                provided.}))
(define (gif-start port Width Height BackGround ColorMap)
  (define GifFile
    (make-gif-stream port Width Height BackGround ColorMap 'init))

  (when ColorMap
    (unless (BackGround . < . (length ColorMap))
      (error 'gif-start
             "background color ~a is out of range for the color map: ~e"
             BackGround
             ColorMap)))

  (WRITE GifFile GifVersionPrefix)

  ;;/*
  ;; * Put the logical screen descriptor into the file:
  ;; */
  ;;/* Logical Screen Descriptor: Dimensions */
  (EGifPutWord Width GifFile)
  (EGifPutWord Height GifFile)

  ;;/* Logical Screen Descriptor: Packed Fields */
  ;;/* Note: We have actual size of the color table default to the largest
  ;; * possible size (7+1 == 8 bits) because the decoder can use it to decide
  ;; * how to display the files.
  ;; */
  (WRITE GifFile
         (bytes (bitwise-ior
                 (if ColorMap #x80 #x00)
                 (arithmetic-shift #x7 4) ; /* Bits originally allocated to each primary color */
                 (if ColorMap (sub1 (bits-per-pixel ColorMap)) #x07)) ; /* Actual size of the color table. */
                BackGround ; /* Index into the ColorTable for background color */
                0)) ; /* Pixel Aspect Ratio */

  ;; /* If we have Global color map - dump it also: */
  (when ColorMap
    (WRITE GifFile (color-map->bytes ColorMap)))

  GifFile)

;;/******************************************************************************
;; * This routine should be called before any attempt to dump an image - any
;; * call to any of the pixel dump routines.
;; *****************************************************************************/
#;(provide/doc (proc-doc/names
              gif-add-image
              (-> image-ready-gif-stream?
                  dimension?
                  dimension?
                  dimension?
                  dimension?
                  any/c
                  (or/c gif-colormap? #f)
                  bytes?
                  void?)
              (stream left top width height interlaced? cmap bstr)
              @{Writes an image to the given GIF stream. The @racket[left],
                @racket[top], @racket[width], and @racket[height] values
                specify the location and size of the image within the overall
                GIF image's virtual space.

                If @racket[interlaced?] is true, then @racket[bstr] should
                provide bytes ininterlaced order instead of top-to-bottom
                order. Interlaced order is:

                @(itemize @item{every 8th row, starting with 0}
                          @item{every 8th row, starting with 4}
                          @item{every 4th row, starting with 2}
                          @item{every 2nd row, starting with 1})

                If a global color is provided with @racket[gif-start], a
                @racket[#f] value can be provided for @racket[cmap].

                The @racket[bstr] argument specifies the pixel content of the
                image.  Each byte specifies a color (i.e., an index in the
                colormap).  Each row is provided left-to-right, and the rows
                provided either top-to-bottom or in interlaced order (see
                above).  If the image is prefixed with a control that specifies
                an transparent index (see @racket[gif-add-control]), then the
                corresponding ``color'' doesn't draw into the overall GIF
                image.

                An exception is raised if any byte value in @racket[bstr] is
                larger than the colormap's length, if the @racket[bstr] length
                is not @racket[width] times @racket[height], or if the
                @racket[top], @racket[left], @racket[width], and
                @racket[height] dimensions specify a region beyond the overall
                GIF image's virtual space.}))
(define (gif-add-image GifFile Left Top Width Height Interlace ColorMap Line)

  (unless ColorMap
    (unless (gif-stream-SColorMap GifFile)
      (error 'gif-add-image
             "no color map for image")))

  (unless (= (bytes-length Line)
             (* Width Height))
    (error 'gif-add-image
           "bytes string size doesn't match width times height: ~e"
           Line))

  (unless (and ((+ Left Width) . <= . (gif-stream-SWidth GifFile))
               ((+ Top Height) . <= . (gif-stream-SHeight GifFile)))
    (error 'gif-add-image
           "image extends beyond GIF virtual screen"))

  (WRITE GifFile #",") ; /* Image seperator character. */
  (EGifPutWord Left GifFile)
  (EGifPutWord Top GifFile)
  (EGifPutWord Width GifFile)
  (EGifPutWord Height GifFile)
  (WRITE GifFile
         (bytes
          (bitwise-ior
           (if ColorMap #x80 #x00)
           (if Interlace #x40 #x00)
           (if ColorMap (sub1 (bits-per-pixel ColorMap)) #x00))))

  ;; /* If we have local color map - dump it also: */
  (when ColorMap
    (WRITE GifFile (color-map->bytes ColorMap)))

  (let* ([cmap (or ColorMap (gif-stream-SColorMap GifFile))])

    (check-line-bytes (length cmap) Line)

    (EGifCompress GifFile
                  (max 2 ;; min code size of LZW is 2
                       (bits-per-pixel cmap))
                  Line))

  (set-gif-stream-FileState! GifFile 'image-or-control))

(define (check-line-bytes sz Line)
  (let loop ([i (bytes-length Line)])
    (unless (zero? i)
      (let ([i (sub1 i)])
        (unless ((bytes-ref Line i) . < . sz)
          (error 'gif-add-image
                 "out-of-range color index ~a in line: ~e"
                 (bytes-ref Line i)
                 Line))
        (loop i)))))


;;/******************************************************************************
;; * This routine should be called to add graphic control before the next image
;; *****************************************************************************/
#;(provide/doc (proc-doc/names
              gif-add-control
              (-> image-or-control-ready-gif-stream?
                  (or/c 'any 'keep 'restore-bg 'restore-prev)
                  any/c
                  dimension?
                  (or/c color? #f)
                  void?)
              (stream disposal wait-for-input? delay transparent)
              @{Writes an image-control command to a GIF stream. Such a control
                must appear just before an image, and it applies to the
                following image.

                The GIF image model involves processing images one by one,
                placing each image into the specified position within the
                overall image's virtual space. An image-control command can
                specify a delay before an image is added (to create animated
                GIFs), and it also specifies how the image should be kept or
                removed from the overall image before proceeding to the next
                one (also for GIF animation).

                The @racket[disposal] argument specifies how to proceed:

                @(itemize @item{@racket['any] : doesn't matter (perhaps because
                                the next image completely overwrites the
                                current one)}
                          @item{@racket['keep] : leave the image in place}
                          @item{@racket['restore-bg] : replace the image with
                                the background color}
                          @item{@racket['restore-prev] : restore the overall
                                image content to the content before the image
                                is added})

                If @racket[wait-for-input?] is true, then the display program
                may wait for some cue from the user (perhaps a mouse click)
                before adding the image.

                The @racket[delay] argument specifies a delay in 1/100s of a
                second.

                If the @racket[transparent] argument is a color, then it
                determines an index that is used to represent transparent
                pixels in the follow image (as opposed to the color specified
                by the colormap for the index).

                An exception is raised if a control is already added to
                @racket[stream] without a corresponding image.}))

(define (gif-add-control GifFile
                         Disposal
                         UserInput?
                         Delay ; 1/100s of a second
                         TransparentColor)
  (WRITE GifFile #"\x21\xF9\x04")
  (WRITE GifFile
         (bytes (bitwise-ior
                 (case Disposal
                   [(any) 0]
                   [(keep) #x4]
                   [(restore-bg) #x8]
                   [(restore-prev) #xC])
                 (if UserInput? #x2 0)
                 (if TransparentColor #x1 0))))
  (EGifPutWord Delay GifFile)
  (WRITE GifFile (bytes
                  (or TransparentColor 0)
                  0)) ; block terminator
  (set-gif-stream-FileState! GifFile 'image))

;;/******************************************************************************
;; * This routine should be called to add the "loop" graphic control
;;   before adding any images
;; *****************************************************************************/
#;(provide/doc (proc-doc/names
              gif-add-loop-control
              (-> empty-gif-stream? dimension? void?)
              (stream iteration)
              @{Writes a control command to a GIF stream for which no images or
                other commands have already been written. The command causes
                the animating sequence of images in the GIF to be repeated
                `iteration-dimension' times, where 0 can be used to mean
                ``infinity.''

                An exception is raise if some control or image has been added
                to the stream already.}))
(define (gif-add-loop-control GifFile
                              Iterations)
  (WRITE GifFile #"\x21\xFF\x0BNETSCAPE2.0\x03\x01")
  (EGifPutWord Iterations GifFile)
  (WRITE GifFile #"\x00")
  (set-gif-stream-FileState! GifFile 'image-or-control))

;;/******************************************************************************
;; * This routine should be called to add arbitrary comment text
;; *****************************************************************************/
#;(provide/doc (proc-doc/names
              gif-add-comment
              (-> image-or-control-ready-gif-stream?
                  bytes?
                  void?)
              (stream bstr)
              @{Adds a generic comment to the GIF stream.

                An exception is raised if an image-control command was just
                written to the stream (so that an image is required next).}))
(define (gif-add-comment GifFile Str)
  (WRITE GifFile #"\x21\xFE")
  (let loop ([pos 0])
    (when (pos . < . (bytes-length Str))
      (let ([amt (min 255 (- (bytes-length Str) pos))])
        (write-byte amt (gif-stream-port GifFile))
        (write-bytes Str (gif-stream-port GifFile) pos (+ pos amt))
        (loop (+ pos amt)))))
  (WRITE GifFile #"\0")
  (set-gif-stream-FileState! GifFile 'image-or-control))

;;/******************************************************************************
;; * This routine should be called last, to end GIF file.
;; *****************************************************************************/
#;(provide/doc (proc-doc/names
              gif-end
              (-> image-or-control-ready-gif-stream?
                  void?)
              (stream)
              @{Finishes writing a GIF file. The GIF stream's output port is
                not automatically closed.

                An exception is raised if an image-control command was just
                written to the stream (so that an image is required next).}))
(define (gif-end GifFile)
  (WRITE GifFile #";")
  (set-gif-stream-FileState! GifFile 'done))

;;/******************************************************************************
;; * Put 2 bytes (word) into the given file:
;; *****************************************************************************/
(define (EGifPutWord Word GifFile)
  (WRITE GifFile (integer->integer-bytes Word 2 #f #f)))

;;/******************************************************************************
;; * LZ compression output
;; *****************************************************************************/
(define (write-buffered-byte b buf port)
  (let ([cnt (add1 (bytes-ref buf 0))])
    (bytes-set! buf cnt b)
    (bytes-set! buf 0 cnt)
    (when (= cnt 255)
      (write-bytes buf port)
      (bytes-set! buf 0 0))))

(define (CompressOutput port buf Code
                        RunningBits RunningCode MaxCode1
                        CrntShiftState CrntShiftDWord)
  (let-values ([(CrntShiftState CrntShiftDWord)
                (let loop ([CrntShiftDWord
                            (bitwise-ior CrntShiftDWord
                                         (arithmetic-shift Code CrntShiftState))]
                           [CrntShiftState (+ CrntShiftState RunningBits)])
                  (if (CrntShiftState . >= . 8)
                    (begin
                      (write-buffered-byte (bitwise-and CrntShiftDWord #xff) buf port)
                      (loop (arithmetic-shift CrntShiftDWord -8)
                            (- CrntShiftState 8)))
                    (values CrntShiftState CrntShiftDWord)))])
    (if (and (RunningCode . >= . MaxCode1)
             (Code . <= . 4095))
      (values (add1 RunningBits) (arithmetic-shift 1 (add1 RunningBits))
              CrntShiftState CrntShiftDWord)
      (values RunningBits MaxCode1
              CrntShiftState CrntShiftDWord))))

;;/******************************************************************************
;; * LZ compression
;; *****************************************************************************/
(define (EGifCompress GifFile BitsPerPixel Line)

  (WRITE GifFile (bytes BitsPerPixel))

  (let* ([ClearCode (arithmetic-shift 1 BitsPerPixel)]
         [EOFCode (add1 ClearCode)]
         [RunningCode (add1 EOFCode)]
         [RunningBits (add1 BitsPerPixel)];    /* Number of bits per code. */
         [MaxCode1 (arithmetic-shift 1 RunningBits)];    /* Max. code + 1. */
         [HashTable (make-hasheq)]
         [CrntShiftState 0];    /* No information in CrntShiftDWord. */
         [CrntShiftDWord 0]
         [port (gif-stream-port GifFile)]
         [len (bytes-length Line)]
         [buf (make-bytes 256 0)])

    (let-values ([(RunningBits MaxCode1 CrntShiftState CrntShiftDWord)
                  (CompressOutput port buf ClearCode
                                  RunningBits RunningCode MaxCode1
                                  CrntShiftState CrntShiftDWord)])
      (let loop ([CrntCode (bytes-ref Line 0)]
                 [RunningCode RunningCode]
                 [RunningBits RunningBits]
                 [MaxCode1 MaxCode1]
                 [CrntShiftState CrntShiftState]
                 [CrntShiftDWord CrntShiftDWord]
                 [HashTable HashTable]
                 [i 1])
        (if (= i len)
          ;; Finish:
          (let-values ([(RunningBits MaxCode1 CrntShiftState CrntShiftDWord)
                        (CompressOutput port buf CrntCode
                                        RunningBits RunningCode MaxCode1
                                        CrntShiftState CrntShiftDWord)])
            (let-values ([(RunningBits MaxCode1 CrntShiftState CrntShiftDWord)
                          (CompressOutput port buf EOFCode
                                          RunningBits RunningCode MaxCode1
                                          CrntShiftState CrntShiftDWord)])
              ;; Flush output:
              (let loop ([CrntShiftState CrntShiftState]
                         [CrntShiftDWord CrntShiftDWord])
                (when (CrntShiftState . > . 0)
                  (write-buffered-byte (bitwise-and CrntShiftDWord #xff)
                                       buf port)
                  (loop (arithmetic-shift CrntShiftDWord -8)
                        (- CrntShiftState 8))))
              (unless (zero? (bytes-ref buf 0))
                (write-bytes buf port 0 (add1 (bytes-ref buf 0))))
              (write-bytes #"\0" port)))
          ;; /* Get next pixel from stream. */
          (let ([Pixel (bytes-ref Line i)])
            ;; /* Form a new unique key to search hash table for the code combines 
            ;;  * CrntCode as Prefix string with Pixel as postfix char.
            ;;  */
            (let* ([NewKey (bitwise-ior (arithmetic-shift CrntCode 8) Pixel)]
                   [NewCode (hash-ref HashTable NewKey #f)])
              (if NewCode
                ;;/* This Key is already there, or the string is old one, so
                ;; * simple take new code as our CrntCode:
                ;; */
                (loop NewCode
                      RunningCode RunningBits MaxCode1
                      CrntShiftState CrntShiftDWord
                      HashTable (add1 i))
                ;;/* Put it in hash table, output the prefix code, and make our
                ;; * CrntCode equal to Pixel. */
                (let-values ([(RunningBits MaxCode1 CrntShiftState CrntShiftDWord)
                              (CompressOutput port buf CrntCode
                                              RunningBits RunningCode MaxCode1
                                              CrntShiftState CrntShiftDWord)])
                  (let ([CrntCode Pixel])
                    ;; /* If however the HashTable if full, we send a clear first and
                    ;;  * Clear the hash table. */
                    (if (RunningCode . >= . LZ_MAX_CODE)
                      ;; /* Time to do some clearance: */
                      (let-values ([(RunningBits MaxCode1 CrntShiftState CrntShiftDWord)
                                    (CompressOutput port buf ClearCode
                                                    RunningBits RunningCode MaxCode1
                                                    CrntShiftState CrntShiftDWord)])
                        (loop CrntCode
                              (add1 EOFCode) (add1 BitsPerPixel) (arithmetic-shift 1 (add1 BitsPerPixel))
                              CrntShiftState CrntShiftDWord
                              (make-hasheq) (add1 i)))
                      ;; /* Put this unique key with its relative Code in hash table: */
                      (begin
                        (hash-set! HashTable NewKey RunningCode)
                        (loop CrntCode
                              (add1 RunningCode) RunningBits MaxCode1
                              CrntShiftState CrntShiftDWord
                              HashTable (add1 i))))))))))))))
(define (quantize argb) 1)

#|
;; key:number, a-value:constraint- -> new hash table with <key {set U a-value)
(define (add-to-hash ht key new-elt)
  #;(printf " adding key:~a, value:~a into ht : ~a\n" key new-elt ht)
  (cond
    [(and (hash? ht) (hash-has-key? ht key)) (hash-set ht key (set-add (hash-ref ht key) new-elt))]
    [else (hash-set ht key (set new-elt))]))

;; lstlst is list of lists
;; adding new-elt to a list at pos in lstlst.
;; output : lstlst
(define (add-to-list lstlst pos new-elt)
  (cond
    [(< pos (length lstlst))
     (let ([new-elt-list (cons new-elt (list-ref lstlst pos))]
           [list-w-new-elt 
            (λ (lst pos new-value) 
              (let ([lst-idx (build-list (length lst) values)])
                (map (λ (p x)
                       (if (equal? p pos) new-value x))
                     lst-idx lst)))])
       (list-w-new-elt lstlst pos new-elt-list))]
    [else (printf "add-to-list error: lst-len:~a, pos:~a\n" (length lstlst) pos)
          (error "add-to-list: pos is out of index")]))
    

(define (out-ht-set? out-type)
  (symbol=? out-type 'ht-set))
(define (out-list-list? out-type)
  (symbol=? out-type 'list-list))
(define (out-list-bytestring? out-type)
  (symbol=? out-type 'list-bytestring))
(define (out-list-ptr? out-type)
  (symbol=? out-type 'list-ptr))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; input: prog w/o var-dup, simplified form (with variable names are all distance to binding)
;;        out-type: (or 'ht-set 'list-list 'list-bytestring 'list-ptr)
;; output: hash-table <var:number, {set of constraints}> if (symbol=? out-type 'ht-set)
;;         list-list (list (list constraint-list ...) ...) if (symbol=? out-type 'list-list)
;;         list-bytestring (list bytestring ...) if (symbol=? out-type 'list-bytestring), where bytestring is defined dy
;;          
;;         list-ptr (list cpointer ...) where cpointer is defined malloc, content are defined by encoding if (symbol=? out-type list-ptr
;; variables are represented as box
;;(gen-constraints-de-Bruijn-form prog)
;;
;; curr-cpos : current constraint pos
;;         i.e (let (x exp) M), constraint from `exp' is corresponding to x whose index is current-cpos.
; generate constraint mapping
(define (gen-constraints-simple-rep-form prog 
                                         #:out-type [out-type 'ht-set] 
                                         #:powerof2 [var-size-cond #t]
                                         #:uniform-width [uniform-width #t]
                                         #:equal-length [equal-length #t])
  (local
    [(define encode-constraint-local 
       (cond [(symbol=? out-type 'ht-set) #f] ;; direct input to hash table
             [(symbol=? out-type 'list-list) #f]  ;; direct input to list
             [(symbol=? out-type 'list-bytestring) encode-constraint-to-bytestring]
             [(symbol=? out-type 'list-ptr) encode-constraint-to-cpointer]
             [else (error "out-type is set wrong")]))
     
     ;; term: list, curr-cpos: number, out-collect: out-collection -> updated-pos, out-collect
     ;; out: new-pos, finalvar, out-collect
     (define (gen-constraint-term term curr-cpos out-collect #:var-const-max [var-max-byte 1]
                                                             #:uniform-width [uniform-width #t]
                                                             #:equal-length  [equal-length #t])
       #;(printf "term: ~a, curr-cpos:~a, out-collect:~s, var-max-byte:~a\n" term curr-cpos out-collect var-max-byte)
       
       (match term
         [(? box? x)
          (values curr-cpos (distance->pos-box curr-cpos x) out-collect)]
         
         [`(let ,exp ,body)
          (let*-values 
              ([(new-cpos out-collect-exp) (gen-constraint-exp exp curr-cpos out-collect #:var-const-max var-max-byte
                                                                                         #:uniform-width uniform-width)])
            
            (gen-constraint-term body (add1 new-cpos) out-collect-exp  #:var-const-max var-max-byte
                                                                       #:uniform-width uniform-width))]))
     
     ;; exp: list, curr-cpos: number, out-collect: hash-table above -> updated-pos, out-collect
     ;; 2 byte convers variables 0 ~ 65535
     (define (gen-constraint-exp exp curr-cpos out-collect #:var-const-max [var-max-byte 2] 
                                                           #:uniform-width [uniform-width #t]
                                                           #:equal-length  [equal-length #t])
       
       #;(printf "exp: ~a, curr-cpos:~a, out-collect:~s, var-max-byte:~a\n" exp curr-cpos out-collect var-max-byte)
       (let ([cn-byte (if uniform-width var-max-byte 1)]
             [prev-cpos (sub1 curr-cpos)]
             [next-cpos (add1 curr-cpos)])
         
         (match exp
           [(? number? c)
            #;(printf "-------------exp is in c:~a\n" c)
            (values curr-cpos 
                    (cond
                      [(out-ht-set? out-type) 
                       (add-to-hash out-collect (new-box next-cpos) exp)];; constraint of a var with number.
                      [(out-list-list? out-type) (add-to-list out-collect next-cpos exp)]
                      [(out-list-bytestring? out-type) 
                       (add-to-list out-collect next-cpos 
                                    (encode-constraint-local 'v (list exp) var-max-byte 
                                                             #:const-name-byte cn-byte
                                                             #:equal-length equal-length))]
                      [(out-list-ptr? out-type) 
                       (add-to-list out-collect next-cpos 
                                    (encode-constraint-local 'v (list exp) var-max-byte #:const-name-byte cn-byte
                                                             #:equal-length equal-length))]))]
           
           [(? boolean? b)
            #;(printf "exp is in b:~a\n" b)
            (values curr-cpos
                    (cond
                      [(out-ht-set? out-type) 
                       (add-to-hash out-collect (new-box next-cpos) exp)];; constraint of a var with boolean.
                      [(out-list-list? out-type) (add-to-list out-collect next-cpos exp)]
                      [(out-list-bytestring? out-type)
                       (add-to-list out-collect next-cpos 
                                    (encode-constraint-local 'b (list exp) var-max-byte #:const-name-byte cn-byte
                                                             #:equal-length equal-length))]
                      [(out-list-ptr? out-type) 
                       (add-to-list out-collect next-cpos 
                                    (encode-constraint-local 'b (list exp) var-max-byte #:const-name-byte cn-byte
                                                             #:equal-length equal-length))]))]
           
           [`(cons ,y1 ,y2)
            (values curr-cpos
                    (let* ([var-y1 (distance->pos-box curr-cpos y1)]
                           [var-y2 (distance->pos-box curr-cpos y2)]
                           [exp `(cons ,var-y1 ,var-y2)])
                      (cond
                        [(out-ht-set? out-type) (add-to-hash out-collect (new-box next-cpos) exp)]
                        [(out-list-list? out-type) (add-to-list out-collect next-cpos exp)]
                        [(out-list-bytestring? out-type) 
                         (add-to-list out-collect next-cpos 
                                      (encode-constraint-local 'c (list var-y1 var-y2) 
                                                               var-max-byte #:const-name-byte cn-byte
                                                             #:equal-length equal-length))]
                        [(out-list-ptr? out-type) 
                         (add-to-list out-collect next-cpos 
                                      (encode-constraint-local 'c (list var-y1 var-y2) 
                                                               var-max-byte #:const-name-byte cn-byte
                                                             #:equal-length equal-length))])))]
           
           [`(lambda ,N)
            (let*-values
                ([(new-cpos finalvar-N N-out-collect) (gen-constraint-term N next-cpos out-collect 
                                                                           #:var-const-max var-max-byte
                                                                           #:uniform-width uniform-width
                                                                           #:equal-length equal-length)])
              
              #;(printf "____lambda N:~a, curr-pos:~a, finalvar-N:~a\n" N curr-cpos finalvar-N)
              
              (values new-cpos
                      (let ([exp `(lambda 
                                    ,(new-box next-cpos)
                                    ,N ;; defined as a distance index ->processed equally as original 
                                    ,finalvar-N)]
                            [new-cpos-lambda (add1 new-cpos)])
                        (cond
                          [(out-ht-set? out-type)
                           (add-to-hash N-out-collect
                                        (new-box new-cpos-lambda)
                                        exp)]
                          [(out-list-list? out-type) (add-to-list N-out-collect new-cpos-lambda exp)]
                          [(out-list-bytestring? out-type) 
                           (add-to-list N-out-collect new-cpos-lambda 
                                        (encode-constraint-local 'l (list (new-box next-cpos) finalvar-N) 
                                                                 var-max-byte #:const-name-byte cn-byte
                                                                 #:equal-length equal-length))]
                          [(out-list-ptr? out-type) 
                           (add-to-list N-out-collect new-cpos-lambda 
                                        (encode-constraint-local 'l (list (new-box next-cpos) finalvar-N) 
                                                                 var-max-byte #:const-name-byte cn-byte
                                                                 #:equal-length equal-length))]))))]

           [`(car ,y)
            (values curr-cpos 
                    (let* ([new-pos-car (distance->pos curr-cpos y)]
                           [exp `(propagate-car-to ,(new-box next-cpos))])
                           (cond
                             [(out-ht-set? out-type) 
                              (add-to-hash out-collect (new-box new-pos-car) exp)]
                             [(out-list-list? out-type) 
                              (add-to-list out-collect new-pos-car exp)]
                             [(out-list-bytestring? out-type) 
                              (add-to-list out-collect new-pos-car 
                                           (encode-constraint-local 'C (list (new-box next-cpos)) 
                                                                    var-max-byte #:const-name-byte cn-byte
                                                                    #:equal-length equal-length))]
                             [(out-list-ptr? out-type) 
                              (add-to-list out-collect new-pos-car 
                                           (encode-constraint-local 'C (list (new-box next-cpos)) 
                                                                    var-max-byte #:const-name-byte cn-byte
                                                                    #:equal-length equal-length))])))]
           
           [`(cdr ,y) 
            (values curr-cpos 
                    (let* ([new-pos-cdr (distance->pos curr-cpos y)]
                          [exp `(propagate-cdr-to ,(new-box next-cpos))])
                           (cond
                             [(out-ht-set? out-type)
                              (add-to-hash out-collect (new-box new-pos-cdr) exp)]
                             [(out-list-list? out-type) 
                              (add-to-list out-collect new-pos-cdr exp)]
                             [(out-list-bytestring? out-type) 
                              (add-to-list out-collect new-pos-cdr 
                                           (encode-constraint-local 'D (list (new-box next-cpos)) 
                                                                    var-max-byte #:const-name-byte cn-byte
                                                                    #:equal-length equal-length))]
                             [(out-list-ptr? out-type) 
                              (add-to-list out-collect new-pos-cdr 
                                           (encode-constraint-local 'D (list (new-box next-cpos)) 
                                                                    var-max-byte #:const-name-byte cn-byte
                                                                    #:equal-length equal-length))])))]
           
           [`(if ,y ,M1 ,M2)
            (let*-values
                ([(new-pos-if) (distance->pos curr-cpos y)]
                 
                 [(new-cpos1 finalvar-M1 out-collect-1) (gen-constraint-term M1 curr-cpos out-collect 
                                                                             #:var-const-max var-max-byte
                                                                             #:uniform-width uniform-width
                                                                             #:equal-length equal-length)]
                 [(new-cpos2 finalvar-M2 out-collect-2) (gen-constraint-term M2 new-cpos1 out-collect-1 
                                                                             #:var-const-max var-max-byte
                                                                             #:uniform-width uniform-width
                                                                             #:equal-length equal-length)]
                 
                 [(pos-bound) (add1 new-cpos2)])
              
              #;(printf "new-pos-if:~a, M1:~a, M2:~a, out-collect-2:~a, curr-pos:~a, finalvar-M1:~a, finalvar-M2:~a, new-cpos1:~a, new-cpos2:~a\n" 
                      new-pos-if M1 M2 out-collect-2 curr-cpos finalvar-M1 finalvar-M2 new-cpos1 new-cpos2)
              
              (values new-cpos2
                      (let ([exp1 `(conditional-prop #t ,finalvar-M1 ,(new-box pos-bound))]
                            [exp2 `(conditional-prop #f ,finalvar-M2 ,(new-box pos-bound))])
                        (cond
                          [(out-ht-set? out-type) 
                           (add-to-hash (add-to-hash out-collect-2 (new-box new-pos-if) exp1)
                                        (new-box new-pos-if)
                                        exp2)]
                          [(out-list-list? out-type)
                           (add-to-list (add-to-list out-collect-2 new-pos-if exp1) new-pos-if exp2)]
                          [(out-list-bytestring? out-type) 
                           (add-to-list (add-to-list out-collect-2 new-pos-if 
                                                     (encode-constraint-local 'B (list #t finalvar-M1 (new-box pos-bound)) 
                                                                              var-max-byte #:const-name-byte cn-byte
                                                                              #:equal-length equal-length))
                                        new-pos-if
                                        (encode-constraint-local 'B (list #f finalvar-M2 (new-box pos-bound)) 
                                                                 var-max-byte #:const-name-byte cn-byte
                                                                 #:equal-length equal-length))]
                          [(out-list-ptr? out-type) 
                           (add-to-list (add-to-list out-collect-2 new-pos-if 
                                                     (encode-constraint-local 'B (list #t finalvar-M1 (new-box pos-bound))
                                                                              var-max-byte #:const-name-byte cn-byte
                                                                              #:equal-length equal-length))
                                        new-pos-if
                                        (encode-constraint-local 'B (list #f finalvar-M2 (new-box pos-bound)) 
                                                                 var-max-byte #:const-name-byte cn-byte
                                                                 #:equal-length equal-length))]))))]

           [`(apply ,y ,z)
            ;; let ([curr-cpos '(apply curr-y curr-z) because y,z are distance indices
            (let ([var-y-pos (distance->pos curr-cpos y)]
                  [var-z-pos (distance->pos curr-cpos z)])
              #;(printf "----apply, curr-pos:~a y:~a, z:~a, var-y:~a, var-z:~a\n" curr-cpos y z var-y-pos var-z-pos)
              
              (values curr-cpos
                      (let ([exp `(application 
                                   ,(new-box next-cpos)
                                   ,(new-box var-z-pos))])
                        (cond
                          [(out-ht-set? out-type) 
                           (add-to-hash out-collect (new-box var-y-pos) exp)] ;; bounded var
                          [(out-list-list? out-type)
                           (add-to-list out-collect var-y-pos exp)]
                          [(out-list-bytestring? out-type) 
                           (add-to-list out-collect 
                                        var-y-pos 
                                        (encode-constraint-local 'A (list (new-box next-cpos) (new-box var-z-pos)) 
                                                                 var-max-byte #:const-name-byte cn-byte
                                                                 #:equal-length equal-length))]
                          [(out-list-ptr? out-type) 
                           (add-to-list out-collect 
                                        var-y-pos 
                                        (encode-constraint-local 'A (list (new-box next-cpos) (new-box var-z-pos)) 
                                                                 var-max-byte #:const-name-byte cn-byte
                                                                 #:equal-length equal-length))]))))]
           
           [_ ;; term
            (let*-values
                ([(new-cpos finalvar-exp out-collect-term) (gen-constraint-term exp curr-cpos out-collect 
                                                                                #:var-const-max var-max-byte
                                                                                #:uniform-width uniform-width
                                                                                #:equal-length equal-length)]
                 [(finalvar-pos) (distance->pos new-cpos finalvar-exp)])
              (values new-cpos 
                      (let* ([obj-pos (add1 new-cpos)]
                             [exp `(propagate-to ,(new-box obj-pos))])
                        (cond
                          [(out-ht-set? out-type) 
                           (add-to-hash out-collect-term (new-box finalvar-pos) exp)]
                          [(out-list-list? out-type) (add-to-list out-collect-term finalvar-pos exp)]
                          [(out-list-bytestring? out-type) 
                           (add-to-list out-collect-term finalvar-pos 
                                        (encode-constraint-local 'P (list (new-box obj-pos)) 
                                                                 var-max-byte #:const-name-byte cn-byte
                                                                 #:equal-length equal-length))]
                          [(out-list-ptr? out-type) 
                           (add-to-list out-collect-term finalvar-pos 
                                        (encode-constraint-local 'P (list (new-box obj-pos))
                                                                 var-max-byte #:const-name-byte cn-byte
                                                                 #:equal-length equal-length))]))))])))]
    
    ;-1 means free variable
    (let* ([num-var (count-bindings prog)]
           [var-max-byte (decimal->container-size/byte (sub1 num-var) #:powerof2 var-size-cond)])
      #;(printf "powerof2:~a, num-var:~a, var-max-byte:~a\n" var-size-cond num-var var-max-byte)
      
      (let-values
          ([(pos finalvar lst-lst-constraints)
            (gen-constraint-term prog 
                                 -1 
                                 (cond
                                   [(out-ht-set? out-type) (make-immutable-hash '())]
                                   [else (build-list num-var (λ (x) '()))])
                                 #:var-const-max var-max-byte
                                 #:uniform-width uniform-width
                                 #:equal-length equal-length)])
        (values pos finalvar lst-lst-constraints var-max-byte)))))

;; give pointer of _bytes, length of byte(var-max-byte)
;; evaluate polynomial of degree (var-max-byte-1)
;; At p, cofee of 2^8^(var-max-byte-1) ,,,,, at (var-max-byte-1), coeff of 2^0 is p -> summation of all.
(define (eval-a-var p var-max-byte)
       (let loop ([deg (sub1 var-max-byte)]
                  [cp p]
                  [sum 0])
         (cond
           [(equal? -1 deg) sum]
           [else
            (let* ([poly (expt (expt 2 8) deg)]
                   [cof (ptr-ref cp _byte)]
                   [local-sum (*  cof poly)])
              #;(printf "\neval-a-var deg:~a poly:~a coeff:~a, local-sum:~a\n" 
                      deg poly cof local-sum)
              (loop (sub1 deg) (ptr-add cp 1 _byte) (+ sum local-sum)))])))
     
;; list of list of ptr of constraint: constraint itself doesn't change
;; output: pointer to array of num constraints, list of numbers(num-constraints)
(define (combine-num-const ll-ptr)
  (cond 
    [(empty? ll-ptr) #f]
    [else
     (let* ([len-var (length ll-ptr)]
            [p-num-const (malloc (* len-var (ctype-sizeof _int)))])
       
       (let loop ([i 0]
                  [l-nc '()])
         (cond 
           [(equal? i len-var) (values p-num-const l-nc)]
           [else
            (let* ([len (length (list-ref ll-ptr i))]
                  [new-l-nc (append l-nc (list len))])
              (ptr-set! p-num-const _int i len)
              
              ;(printf "~ath list's length = ~a, ~a\n" i len (ptr-ref p-num-const _int i))
              
              (loop (add1 i) new-l-nc))])))]))


;; l-ptr : list of pointer to constraint
;; output-> bytes for sum of all constarints if equal-length = #f, 4 * var-max-byte * length of l-ptr if equal-length = #t
(define (size-list-const-bytes l-ptr var-max-byte #:uniform-width [uniform-width #t] #:equal-length [equal-length #t])
  (cond
    [equal-length (* 4 var-max-byte (length l-ptr))] ;; 4(max num of variable in constraint), vmb: unit bytes for var in const, length-lptr: number of variable
    [else ;; constraints are not equal length
     (let loop ([by-size 0]
                [l l-ptr])
       (cond 
         [(empty? l) #;(printf "total size: ~a\n" by-size) by-size]
         [else
          (let* ([p (first l)]
                 [ch (integer->char (ptr-ref p _byte (if uniform-width (sub1 var-max-byte) 1)))])
            (let*-values
                ([(size-byte num-var) (constraint-length ch 
                                                         var-max-byte
                                                         #:const-name-byte (if uniform-width var-max-byte 1))])
              #;(printf "Combine constraint(~a) sz:~a, numvar:~a\n" ch size-byte num-var)
              (loop (+ by-size size-byte) (rest l))))]))]))
  

;; out-collect: list of list of constraint(bytes)
;; output-> list of byte string
(define (lstlst-bytes->lst-ptrs out-collect 
                                 var-max-byte 
                                 #:uniform-width [uniform-width #t]
                                 #:equal-length [equal-length #t])
  (local
    [(define max-a-const-length (* 4 var-max-byte)) ;; used for allocation of mem if equal-length=#t
     
    ;; to malloc bytestream containing all constraint, need size of each constraint for given variable.
    ;; lst-ptr(of a given var) number -> number
    ;; list-of-cpointers(to constname) -> pointer to combined cpointers
     (define (combine-constnames l-ptr-const)
       (let* ([len (length l-ptr-const)]) ;; length of constraint for given variable
         (cond
           [(zero? len) #f]
           [else
            (let ([p-constnames (malloc (* len (ctype-sizeof _byte)))])
              (let loop ([i 0])
                (cond
                  [(equal? i len) (begin
                                    #;(for ([i (in-range len)])
                                      (printf "~a consts added[~a]:~a\n" len i (integer->char (ptr-ref p-constnames _byte i))))
                                    p-constnames)]
                  [else 
                   (let ([cname (ptr-ref (list-ref l-ptr-const i) _byte (if uniform-width (sub1 var-max-byte) 0))])
                     #;(printf "constname combine at ~ath:~a\n" i (integer->char cname))
                     (ptr-set! p-constnames _byte i cname)
                     (loop (add1 i)))])))])))
     
     ;; p-constn : pointer of bytes for const names for given variable
     (define (print-p-constnames num-const p-constn)
       (let loop ([i num-const]
                  [p p-constn])
         (cond
           [(zero? i) (newline)]
           [else
            (let* ([cname (ptr-ref p-constn _byte (sub1 i))])
              (printf "constname:~a(~a)\t" cname (integer->char cname))
              (loop (sub1 i) (ptr-add p 1 _byte)))])))
     
     
     ;; give list of cpointers for a variable,
     ;; lst-of-cpointers (of constraints) -> cpointer of stream
     ;; '(cptr ...) -> cptr
     ;; #f if l-ptr-const empty
     (define (combine-constraints l-ptr-const var-max-byte #:uniform-width [uniform-width #t] #:equal-length [equal-length #t])
       (let* ([num-bytes (size-list-const-bytes l-ptr-const var-max-byte #:uniform-width uniform-width #:equal-length equal-length)])
         #;(printf "in combine-constraints ~a bytes needed for all const-names\n" num-bytes)
         (cond
           [(zero? num-bytes) #f]
           [else
            (let* ([p (malloc num-bytes)])
              (memset p 0 num-bytes _byte) ;; initialization - essential for equal-length constraint byte string
              (let loop ([offset 0] ;; distance in byte from the beginning of allocated space for multiple constraint pointed by p
                         [ptrs l-ptr-const]) ;; list of current pointer of constraint
                (cond
                  [(empty? ptrs) p]
                  [else 
                   (let*-values
                       ([(src-cptr) (first ptrs)]
                        [(const-size-byte num-var) (constraint-length (ptr-ref src-cptr _byte (sub1 var-max-byte)) 
                                                                      var-max-byte
                                                                      #:const-name-byte (if uniform-width var-max-byte 1))])
                     
                     #;(printf "***const-name:~a, const-size-byte:~a, num-var:~a, offset:~a\n" 
                             (integer->char (ptr-ref src-cptr _byte (sub1 var-max-byte))) const-size-byte num-var offset)
                     
                     ;; check what will be into p.
                     #;(let loop ([i 0])
                       (cond [(equal? i const-size-byte) #t]
                             [else
                              (let ([v (ptr-ref src-cptr _byte i)])
                                (printf "src - byte[~a]: ~a\n" i (if (< i var-max-byte) (integer->char v) v))
                                (loop (add1 i)))]))
                     
                     ;; actual insertion
                     (memcpy p offset src-cptr 0 const-size-byte _byte)
                                          
                     (loop (+ offset (if equal-length max-a-const-length const-size-byte)) (rest ptrs)))])))])))
     
     ;; l-ptr list of element either <pointer> or #f, if there is no constraint for the variable
     ;;list -> ptr w/ type and length, where l-ptr is list of pointer of the type or #f
     (define (listofptrs->ptr2ptrs l-ptr)
       #;(printf "ptrlst->ptr2ptrs----:~a, with length :~a\n" l-ptr (length l-ptr))
       (cond
         [(empty? l-ptr) #f]
         [else
          (let* ([len-ptr (length l-ptr)]
                 [p-ptrs (malloc (* len-ptr (ctype-sizeof _pointer)))])
            (let loop ([i 0])
              (cond
                [(equal? i len-ptr) p-ptrs]
                [else
                 (let* ([p (list-ref l-ptr i)])
                   #;(printf "~ath ptr w/ const-name:~a\n" i (if p (ptr-ref p _byte (sub1 var-max-byte)) #f))
                   (ptr-set! p-ptrs _pointer i p)
                   (loop (add1 i)))])))]))]
    
    (printf "length of out-collect - num var:~a\n" (length out-collect))
    
    (let-values ([(num-const lst-numconst) (combine-num-const out-collect)]) ;; pointer to array of num-constraint:int as many var.
      (let* ([num-var (length out-collect)]
             [l-constnames (map combine-constnames out-collect)] ;; list of pointers to cnames
             [l-constm (let loop ([oc out-collect]
                                  [out-lst '()])
                         (cond 
                           [(empty? oc) out-lst]
                           [else
                            (loop (cdr oc) (append out-lst (list (combine-constraints (car oc) 
                                                                                      var-max-byte 
                                                                                      #:uniform-width uniform-width
                                                                                      #:equal-length equal-length))))]))])
;        (printf "-----------check constnam------------\n")
;        (for-each print-p-constnames lst-numconst l-constnames)
;        (printf "-----------end of check constnam------------\n")
        (values num-const (listofptrs->ptr2ptrs l-constnames) (listofptrs->ptr2ptrs l-constm))))))

;; int, ptr-of-int -> void
(define (print-num-const num-var num-const)
  (let loop ([i 0])
    (cond 
      [(equal? i num-var) #t]
      [else
       (begin (printf "num-const ~a -> ~a \n" 
                      i (ptr-ref num-const _int i)))
              (loop (add1 i))])))

;; constnames: pointer of pointer /or #f(if no constraints) containing bytes as many as constnames at the variable.
;; int, ptr-to-arrayof-ptr, ptr-to-arrayof-ptr each ptr pointing to strm -> void
(define (print-pp-constnames num-var num-const constnames)
  (let loop1 ([iv 0])
    (cond
      [(equal? iv num-var) #t]
      [else
       (let ([nc (ptr-ref num-const _int iv)]
             [p-cn (ptr-ref constnames _pointer iv)])
         (printf "~a constraints at ~ath var\n" nc iv)
         (let loop2 ([ic 0])
           (cond 
             [(equal? ic nc) (newline) (loop1 (add1 iv))]
             [else
              (printf "~a\t" (ptr-ref p-cn _byte ic))
              (loop2 (add1 ic))])))])))

;; int, ptr-of-int, int -> void
;; constm is list of pointer to stream
(define (print-constm num-var var-max-size num-const constnames constm 
                      #:out-type [out-type 'list-ptr] #:uniform-width [uniform-width #t] #:equal-length [equal-length #t])
  (let ([max-a-const-length (* 4 var-max-size)])
    (let loop1 ([iv 0]) ;; iv Xth variable
      (cond
        [(equal? iv num-var) #t]
        [else
         (let ([nc (ptr-ref num-const _int iv)]
               [p-stm (ptr-ref constm _pointer iv)])
           
           (let loop2 ([ic 0] ;; for each constraint at iv
                       [curr-pos p-stm])
             (cond
               [(equal? ic nc) (printf "~a.......constraints\n" nc)]
               [else
                (let*-values
                    ([(cname-byte) (ptr-ref curr-pos _byte (if uniform-width (sub1 var-max-size) 0))]
                     [(cname-byte-evaluated) (eval-a-var curr-pos var-max-size)]
                     [(xxxxx) (printf "~a th variable, ~athe constraint - constname : ~a, (~a), eval:~a\n" 
                                      iv ic cname-byte (integer->char cname-byte) cname-byte-evaluated)]
                     [(size-const var-cnt) (constraint-length cname-byte
                                                              var-max-size 
                                                              #:const-name-byte (if uniform-width var-max-size 1))])
                  (printf "Constraint name at var:~ath, const:~ath = ~a, ~a variables\n" iv ic (integer->char cname-byte) var-cnt)
                  (let loop3 ([ib 0] ;; for each variable in constraint
                              [cpos curr-pos]) ;; next position from constraint-name
                    (cond
                      [(equal? ib var-cnt) (printf "\n....const-var\n")]
                      [else 
                       (let ([new-pos 
                              (if (zero? ib) ;; initial position
                                  (begin (printf "constraint name:~a\n" (integer->char cname-byte))
                                         (ptr-add cpos (if uniform-width var-max-size 1) _byte))
                                  cpos)])
                         ;; printing new-pos
                         (let ([vp (malloc var-max-size _byte)])
                           (memcpy vp 0 new-pos 0 (* (ctype-sizeof _byte) var-max-size))
                           ;                         (printf "XXXXX(~a)  ~a\t" ib (eval-a-var vp var-max-size))
                           ;                         (printf "YYYYY(~a)  ~a\t" ib (eval-a-var new-pos var-max-size))
                           (loop3 (add1 ib) (ptr-add new-pos var-max-size _byte))))]))
                  ;                (printf "offset to next constraint: ~a bytes, num assoc vars:~a\n" size-const var-cnt)
                  (loop2 (add1 ic) (ptr-add curr-pos (if equal-length max-a-const-length size-const) _byte)))]))
           
           (loop1 (add1 iv)))]))))

;; program -> list of bytestream containing multiple constraints in a row.
;; options - #:uniform-width: each space for constraint name, variables are all same
;;           #:equal-length: length of constraints are all same (ie 4 elements: constname, var0, var1, var2 so that constraint 'B is longest, other shorter constraint fills from the beginning of the constraint.
;;           #:out-type ->
;; output type of gen-constraints-simple-rep-form
;;         hash-table <var:number, {set of constraints}> if (symbol=? out-type 'ht-set)
;;         list-list (list (list constraint-list ...) ...) if (symbol=? out-type 'list-list)
;;         list-bytestring (list bytestring ...) if (symbol=? out-type 'list-bytestring)
;;         list-ptr (list cpointer ...) where cpointer is defined malloc, content are defined by encoding if (symbol=? out-type list-ptr)
;;           #:powerof2 : boolean number of variable is power of two or not. - important to simplicity of gpu variable handling.
;;
;;TODO
;;
(define (gen-constraint-ptr->stream prog 
                                    #:uniform-width [uniform-width #t]
                                    #:equal-length [equal-length #t]
                                    #:out-type [out-type 'list-ptr]
                                    #:powerof2 [powerof2 #t])
  (let*-values
      ([(pos finalvar out-collect var-max-byte)
        (gen-constraints-simple-rep-form prog #:out-type out-type
                                              #:powerof2 powerof2
                                              #:uniform-width uniform-width
                                              #:equal-length equal-length)]
       [(num-var) (length out-collect)]
       [(lst-num-const)
        (cond
          [(list? out-collect) (map length out-collect)]
          [(hash? out-collect) (hash-map out-collect (λ (k v) 
                                                       (cond
                                                         [(set? v) (set-count v)]
                                                         [(list? v) (length v)])))]
          [else (begin
                  (printf "~a\n" out-collect)
                  (error "what's the output type of out-collect?"))])]
       
       [(num-const constnames constm)
        (lstlst-bytes->lst-ptrs out-collect var-max-byte #:uniform-width uniform-width #:equal-length equal-length)])

;    (printf "List of numbers of constraint in each variable:\n")
;    (when num-const (print-num-const num-var num-const))
;    (printf "List of constraint name in each variable:\n")
;    (print-pp-constnames num-var num-const constnames)
;    (printf "List of constm in each variable:\n")
;    (print-constm num-var var-max-byte num-const constnames constm #:out-type out-type #:uniform-width uniform-width)

    (values num-const constnames constm)))

;; output is 1d array:
;; update carefully the changes, improvements during development.
#;(define (gen-constraint-ptr->array2 prog 
                                    #:out-type [out-type 'list-ptr]
                                    #:powerof2 [powerof2 #t] 
                                    #:uniform-width [uniform-width #t]
                                    #:equal-length [equal-length #t])
  (let*-values
      ([(pos finalvar out-collect var-max-byte)
        (gen-constraints-simple-rep-form prog #:out-type out-type 
                                              #:powerof2 powerof2
                                              #:uniform-width uniform-width
                                              #:equal-length equal-length)] ;; list of pointers which point to bytestream, var-const-max is order of 2,  element of constraint has same bytes (name part has same size as variable part)
       [(num-var) (length out-collect)]
       
       
       
       ; how to combine out-collect into 2d array
       
       
       [(lst-num-const)
        (cond
          [(list? out-collect) (map length out-collect)]
          [(hash? out-collect) (hash-map out-collect (λ (k v) 
                                                       (cond
                                                         [(set? v) (set-count v)]
                                                         [(list? v) (length v)])))]
          [else (begin
                  #;(printf "~a\n" out-collect)
                  (error "what's the output type of out-collect?"))])]
       [(num-const constnames const-ary)
        (lstlst-bytes->2d-bytes out-collect var-max-byte)])
#|
    (printf "List of numbers of constraint in each variable:\n")
    (when num-const (print-num-const num-var num-const))
    (printf "List of constraint name in each variable:\n")
    (print-pp-constnames num-var num-const constnames)
    (printf "List of constm in each variable:\n")
    (print-constm num-var var-max-byte num-const constnames constm #:out-type out-type #:uniform-width uniform-width)
|#
    (values num-const constnames const-ary)))
    
(let* ([otype 'list-ptr]
       [uniform-width #t]
       [equal-length #t] ;;;; TODO if equal_length==#f, sba-solver-cpu cannot get constraint_name properly.
       [run-on-gpu #t]) ;; #f for using serial solver in C
  (when (or (symbol=? otype 'list-bytestring) (symbol=? otype 'list-ptr))
    (let*-values
        (;; program tranformation - alpha conversion (removing duplicate variable names)
         [(lol-vars prog1) (convert-no-dupvar prog)]
         [(xxxx) (begin (printf "---------------------------------\n") (pretty-display prog1))]
         [(lst-var) (prog->list-of-binders prog1)]
         [(num-var) (length lst-var)]
         [(xxx) (printf "list of binders:\n~a\n numvar:~a\n" lst-var num-var)]
         
         ;; program transformation - represent term without variable using distance. 
         [(prog2) (convert-to-distance-form prog1)]
         #;[(yyy) (printf "program by distance:\n~a\n" prog2)]
         [(zzz) (begin (printf "-----convert var by distance-----\n") (pretty-display prog2))]
         
         ;; creating constraints, tranformation of data structure depending on solver.
         [(num-const constnames constm) (gen-constraint-ptr->stream prog2 #:uniform-width uniform-width #:equal-length equal-length #:out-type otype #:powerof2 #t)]
         [(v) (printf "num-const:~a, \nconstnames:~a,\nconstm:~a.\n" num-const constnames constm)]
         [(sbastm) (make-sba-stream num-const constnames constm)]
         [(p-sbastm) (SbaStream_init_empty num-var)]
         [(var-max-byte) (decimal->container-size/byte (sub1 num-var) #:powerof2 #t)]
         [(x) (begin
                (print-num-const num-var num-const)
                (print-pp-constnames num-var num-const constnames)
                (print-constm num-var var-max-byte num-const constnames constm #:out-type otype #:uniform-width uniform-width #:equal-length equal-length))])
      
      ;; Applying solver on CPU or GPU using FFI.
      (if run-on-gpu ;; currently #f
          
          ;; gpu
          (let ([p-out-gsbastm (sba_solve_csr sbastm num-var var-max-byte p-sbastm (if uniform-width 1 0) (if equal-length 1 0))])
            #f)
        
          ;; cpu 
          (let (;; applying constraint solver(serial) need testing for memory free()
                [p-out-sbastm (solver_constraint_wrapper sbastm num-var var-max-byte p-sbastm  (if uniform-width 1 0) (if equal-length 1 0))])
      
            (printf "~a: ~a, ~a, ~a\n" sbastm (sba-stream-num-const sbastm) (sba-stream-constnames sbastm) (sba-stream-constm sbastm) )
            (printf "printing input sbastm---------------------------------------------------------------------------------------------------------\n")
            ;; rpc at libsba_culib.so
            ;(print_num_const num-var num-const) ;; int->C: expected argument of type <non-null `int' pointer>; given #<cpointer>
            (print_constraint_stream num-var var-max-byte sbastm)
            (printf "printing output sbastm---------------------------------------------------------------------------------------------------------\n")
            (print_constraint_stream num-var var-max-byte p-out-sbastm)
            
            #f
            ;; racket call by return value from libsba_host.so
            #;(let* ([numconst   (sba-stream-num-const p-out-sbastm)]
                   [constnames (sba-stream-constnames p-out-sbastm)]
                   [constm     (sba-stream-constm p-out-sbastm)])
              (print-num-const num-var numconst)
              #;(print-pp-constnames num-var numconst constnames)
              #;(print-constm num-var var-max-byte numconst constnames constm #:out-type otype #:uniform-width uniform-width)
              )
            )))))

|#