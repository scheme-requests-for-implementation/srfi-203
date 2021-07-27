;;;; SPDX-FileCopyrightText: 2014 Peter Danenberg <pcd@roxygen.org>
;;;; SPDX-FileCopyrightText: 2021 Vasilij Schneidermann <mail@vasilij.de>
;;;;
;;;; SPDX-License-Identifier: BSD-3-Clause

(define canvas-width (make-parameter 256))
(define canvas-height (make-parameter 256))
(define canvas-path (make-parameter #f))
(define canvas-stack (make-parameter '()))

(define (canvas-frame)
  `((0 0) (,(canvas-width) 0) (0 ,(canvas-height))))

(define (display-svg svg out)
  (define (entity-encode string)
    (let ((out (open-output-string)))
      (for-each (lambda (char)
                  (case char
                    ((#\<) (display "&lt;" out))
                    ((#\>) (display "&gt;" out))
                    ((#\&) (display "&amp;" out))
                    ((#\') (display "&#x27;" out))
                    ((#\") (display "&quot;" out))
                    (else (display char out))))
                string)
      (get-output-string out)))
  (cond
   ((string? svg)
    (entity-encode svg))
   ;; (foo (@ ...) body ...)
   ((and (pair? svg) (symbol? (car svg))
         (pair? (cdr svg)) (pair? (cadr svg)))
    (let ((tag (car svg))
          (attrs (cdr (cadr svg)))
          (body (cddr svg)))
      (display "<" out)
      (display tag out)
      (for-each (lambda (attr)
                  (display " " out)
                  (display (car attr) out)
                  (display "=" out)
                  (write (cadr attr) out))
                attrs)
      (if (pair? body)
          (begin
            (display ">" out)
            (for-each (lambda (form) (display-svg form out)) body)
            (display "</" out)
            (display tag out)
            (display ">" out))
          (display "/>" out))))
   (else
    (error "Malformed SXML"))))

(define (canvas-svg)
  `(svg (@ (xmlns "http://www.w3.org/2000/svg")
           (xmlns:xlink "http://www.w3.org/1999/xlink")
           (height ,(number->string (canvas-height)))
           (width ,(number->string (canvas-width))))
        (g (@ (stroke "black"))
           ,@(reverse (canvas-stack)))))

(define (canvas-ensure)
  (when (not (canvas-path))
    (error "Canvas path unset")))

(define (canvas-cleanup)
  (when (and (canvas-path) (file-exists? (canvas-path)))
    (delete-file (canvas-path))
    (call-with-output-file (canvas-path) values)))

(define (canvas-reset)
  (canvas-cleanup)
  (canvas-ensure)
  (canvas-stack '()))

(define (canvas-refresh)
  (canvas-ensure)
  (call-with-output-file (canvas-path)
    (lambda (out)
      (display-svg (canvas-svg) out)))
  (string-append "file://" (canvas-path)))

(define origin-frame car)
(define edge1-frame cadr)
(define edge2-frame caddr)
(define xcor-vect car)
(define ycor-vect cadr)

(define (draw-line start end)
  (define svg
    `(line (@ (x1 ,(number->string (xcor-vect start)))
              (y1 ,(number->string (ycor-vect start)))
              (x2 ,(number->string (xcor-vect end)))
              (y2 ,(number->string (ycor-vect end))))))
  (canvas-stack (cons svg (canvas-stack))))

(define (draw-image url frame)
  (define svg
    (let* ((origin (origin-frame frame))
           (edge1 (edge1-frame frame))
           (edge2 (edge2-frame frame))
           (a (xcor-vect edge1))
           (b (ycor-vect edge1))
           (c (xcor-vect edge2))
           (d (ycor-vect edge2))
           (e (xcor-vect origin))
           (f (ycor-vect origin))
           (transform (string-append "matrix("
                                     (number->string a)
                                     ", "
                                     (number->string b)
                                     ", "
                                     (number->string c)
                                     ", "
                                     (number->string d)
                                     ", "
                                     (number->string e)
                                     ", "
                                     (number->string f)
                                     ")")))
      `(g (@ (transform ,transform))
          (image (@ (xlink:href ,url)
                    (width "1")
                    (height "1"))))))
  (canvas-stack (cons svg (canvas-stack))))

(define (rogers frame)
  (draw-image rogers-data-url frame))

(define (image-file->painter file-name)
  (lambda (frame)
    (draw-image file-name frame)))

(define (jpeg-file->painter file-name)
  (image-file->painter file-name))
