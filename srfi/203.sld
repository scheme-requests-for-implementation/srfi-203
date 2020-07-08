;;; -*- mode: scheme; -*-
;;; Time-stamp: <2020-07-09 00:00:07 lockywolf>
;;; Author: lockywolf
;;; Created: 2020-06

(define-library (srfi 203)
  (import (scheme small))
  (import (chibi process))
  (import (chibi io))
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

