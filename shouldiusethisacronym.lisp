(defpackage :fwoar.lisp-sandbox.shouldiusethisacronym
  (:use :cl)
  (:export :main))
(in-package :fwoar.lisp-sandbox.shouldiusethisacronym)

(defclass acceptor (hunchentoot:acceptor)
  ())

(defmethod hunchentoot:acceptor-dispatch-request ((acceptor acceptor) request)
  (when (> (length (hunchentoot:script-name request))
           1)
    (let* ((acronym (subseq (hunchentoot:script-name request) 1))
           (question (format nil "Should I use the acronym \"~a\"?" acronym)))
      (spinneret:with-html-string
        (:head
         (:meta :property "og:title" :content question)
         (:meta :property "og:content" :content "No.")
         (:style :type "text/css"
                 "html {font-family: sans-serif; width: 100vw; height: 100vh;}"
                 "body {height: 50%; width: 75%; margin: 25% auto;}"
                 ))
        (:h1 question)
        (:div :style "padding-top: 1em; font-size: 2em;"
              "Don't use acronyms; they impede signification and thought.")))))

(defun main ()
  (uiop:setup-command-line-arguments)
  (let* ((port (if (= (length (uiop:command-line-arguments)) 1)
                   (parse-integer (elt (uiop:command-line-arguments) 0))
                   9092))
         (acceptor (make-instance 'acceptor :port port)))
    (hunchentoot:start acceptor)
    (bt:join-thread
     (hunchentoot::acceptor-process
      (hunchentoot::acceptor-taskmaster acceptor)))))
