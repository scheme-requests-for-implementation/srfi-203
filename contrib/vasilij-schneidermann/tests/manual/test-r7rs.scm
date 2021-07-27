;;;; SPDX-FileCopyrightText: 2021 Vasilij Schneidermann
;;;;
;;;; SPDX-License-Identifier: CC0-1.0

(import (scheme base))
(import (scheme cxr))
(import (scheme write))
(import (srfi 203))

;; helper definitions

(define (make-vect x y) (list x y))
(define (xcor-vect v) (car v))
(define (ycor-vect v) (cadr v))

(define (add-vect v1 v2)
  (make-vect (+ (xcor-vect v1) (xcor-vect v2))
             (+ (ycor-vect v1) (ycor-vect v2))))

(define (sub-vect v1 v2)
  (make-vect (- (xcor-vect v1) (xcor-vect v2))
             (- (ycor-vect v1) (ycor-vect v2))))

(define (scale-vect s v)
  (make-vect (* s (xcor-vect v))
             (* s (ycor-vect v))))

(define (make-frame origin edge1 edge2)
  (list origin edge1 edge2))

(define (origin-frame frame) (car frame))
(define (edge1-frame frame) (cadr frame))
(define (edge2-frame frame) (caddr frame))

(define (frame-coord-map frame)
  (lambda (v)
    (add-vect
     (origin-frame frame)
     (add-vect
      (scale-vect (xcor-vect v) (edge1-frame frame))
      (scale-vect (ycor-vect v) (edge2-frame frame))))))

(define (transform-painter painter origin corner1 corner2)
  (lambda (frame)
    (let ((m (frame-coord-map frame)))
      (let ((new-origin (m origin)))
        (painter (make-frame
                  new-origin
                  (sub-vect (m corner1) new-origin)
                  (sub-vect (m corner2) new-origin)))))))

(define (flip-vert painter)
  (transform-painter painter
                     (make-vect 0 1)
                     (make-vect 1 1)
                     (make-vect 0 0)))

(define (beside painter1 painter2)
  (let ((split-point (make-vect 0.5 0)))
    (let ((paint-left
           (transform-painter painter1
                              (make-vect 0 0)
                              split-point
                              (make-vect 0 1)))
          (paint-right
           (transform-painter painter2
                              split-point
                              (make-vect 1 0)
                              (make-vect 0.5 1))))
      (lambda (frame)
        (paint-left frame)
        (paint-right frame)))))

(define (below painter1 painter2)
  (let ((split-point (make-vect 0.0 0.5)))
    (let ((paint-bottom
           (transform-painter
            painter1
            split-point
            (make-vect 1.0 0.5)
            (make-vect 0.0 1.0)))
          (paint-top
           (transform-painter
            painter2
            (make-vect 0.0 0.0)
            (make-vect 1.0 0.0)
            split-point)))
      (lambda (frame)
        (paint-bottom frame)
        (paint-top frame)))))

;; actual exercise

(canvas-path "/tmp/srfi-203.svg")

(define rogers2 (beside rogers (flip-vert rogers)))
(define rogers4 (below rogers2 rogers2))
(rogers4 (canvas-frame))

(display (canvas-refresh))
(newline)
