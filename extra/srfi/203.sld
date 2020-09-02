;;; -*- mode: scheme; -*-
;;; Time-stamp: <2020-09-02 13:52:16 lockywolf>
;;; Author: lockywolf
;;; Created: 2020-09-02

(define-library (srfi 203)
  (import (scheme base)
	  (kawa pictures))
  (export canvas-cleanup
	  canvas-name
	  canvas-refresh
          canvas-reset
	  canvas-size
	  draw-line
	  draw-bezier
	  jpeg-file->painter
	  rogers
	  landau)

  (include "203/203.scm"))

