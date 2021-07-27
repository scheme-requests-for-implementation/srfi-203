;;;; SPDX-FileCopyrightText: 2021 Vasilij Schneidermann <mail@vasilij.de>
;;;;
;;;; SPDX-License-Identifier: BSD-3-Clause

(define-library (srfi 203)
  (import (scheme base))
  (import (scheme cxr))
  (import (scheme file))
  (import (scheme write))
  (export canvas-reset canvas-refresh canvas-cleanup
          canvas-path canvas-width canvas-height canvas-frame
          draw-line
          rogers
          jpeg-file->painter
          image-file->painter)

  (include "203.scm")
  (include "rogers.scm"))
