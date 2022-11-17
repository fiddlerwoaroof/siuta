(require :asdf)

(setf *debugger-hook* (lambda (condition _)
                        (declare (ignore _))
                        (format t "~&Exiting with error: ~a~%" condition)
                        (uiop:quit 42)))

(asdf:load-asd (truename "siuta.asd"))

(asdf:load-system :siuta)

(sb-ext:save-lisp-and-die "siuta"
                          :executable t
                          :toplevel 'fwoar.lisp-sandbox.shouldiusethisacronym:main)
