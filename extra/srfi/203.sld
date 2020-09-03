;;; -*- mode: scheme; -*-
;;; Time-stamp: <2020-09-03 11:44:23 lockywolf>
;;; Author: lockywolf
;;; Created: 2020-09-02

(define-library (srfi 203)
  (import (scheme base)
	  (scheme cxr)
	  (scheme file)
	  (kawa pictures)
	  (only (kawa base) path-bytes))
  (export canvas-cleanup
	  canvas-name
	  canvas-refresh
          canvas-reset
	  canvas-size
	  draw-line
;;	  draw-bezier
	  jpeg-file->painter
	  rogers
	  landau
	  rogers-bytevector)

  (include "203/203.scm"))

