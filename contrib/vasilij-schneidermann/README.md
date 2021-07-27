<!--
SPDX-FileCopyrightText: 2021 Vasilij Schneidermann <mail@vasilij.de>

SPDX-License-Identifier: BSD-3-Clause
-->

This directory contains an implementation of SRFI 203 provided by
Vasilij Schneidermann.

## About

Implementation of
[SRFI-203](https://srfi.schemers.org/srfi-203/srfi-203.html) (A Simple
Picture Language in the Style of SICP) using code from the former
[sicp egg](http://wiki.call-cc.org/eggref/4/sicp) for CHICKEN.

The primary benefit over the sample implementation is that it doesn't
require any implementation-specific procedures and runs on any
R7RS-small compliant Scheme system. This is due to the implementation
strategy of generating a SVG file which can then be opened in a
browser or image viewer. One downside is that users must set the SVG
file path themselves.

## API

The procedures listed below expect a proper list of numbers for their
data representation. Vector and frame accessors are therefore defined
as follows:

    (define origin-frame car)
    (define edge1-frame cadr)
    (define edge2-frame caddr)
    (define xcor-vect car)
    (define ycor-vect cadr)

If you chose to use a different internal representation, you'll need
to define appropriate conversion procedures. For example a pair
representation can be transformed as follows:

     (define (fixup-vector vector)
       (list (xcor-vect vector) (ycor-vect vector)))

     (draw-line (fixup-vector start) (fixup-vector end))

### Canvas manipulation

**Parameter**: (canvas-path)

Obtain or set the path the canvas should be rendered to.

**Parameter**: (canvas-width)  
**Parameter**: (canvas-height)

Obtain or set the width and height of the canvas measured in pixels.

**Procedure**: (canvas-frame)

Obtain a frame corresponding to the canvas width and height.

**Procedure**: (canvas-reset)

Reset the canvas to its initial state.

**Procedure**: (canvas-refresh)

Commit all pending drawing operations and return a `file://` URL to
the file backing the canvas. This will call `canvas-reset` if needed.

**Procedure**: (canvas-cleanup)

Delete the current canvas, including its backing file.

### Painters

**Procedure**: (draw-line start end)

Draws a line from `start` to `end` on the canvas. This should be used
in combination with a procedure that adjusts the coordinates of
`start` and `end` to fit the canvas.

**Procedure**: (rogers frame)

A built-in painter that paints an image of William Rogers into
`frame`.

**Procedure**: (image-file->painter file-name)

Returns a painter that will paint the image at `file-name`.

Note that `file-name` is interpreted relative to `canvas-path`.
Therefore only absolute paths are guaranteed to work.

**Procedure**: (jpeg-file->painter file-name)

Alias for `image-file->painter`.

## Example

    (import (scheme base))
    (import (scheme write))
    (import (srfi 203))

    (define (flip-vert painter) ...)
    (define (beside painter1 painter2) ...)
    (define (below painter1 painter2) ...)

    (define rogers2 (beside rogers (flip-vert rogers)))
    (define rogers4 (below rogers2 rogers2))

    (rogers4 (canvas-frame))
    (display (canvas-refresh))
    (newline)

## License

BSD-3-Clause
CC0-1.0
