(defpackage :fwoar.lisp-sandbox.shouldiusethisacronym
  (:use :cl)
  (:export :main))
(in-package :fwoar.lisp-sandbox.shouldiusethisacronym)

(defclass acceptor (hunchentoot:acceptor)
  ())

(defun lookup-acronym (acronym)
  (string-case:string-case ((string-downcase acronym) :default nil)
    ("aiui" "As I Understand It")
    ("afaict" "As Far As I Can Tell")
    ("iow" "In Other Words")
    ("lotr" "Lord of the Rings")
    ("mia" "Missing In Action")
    ("n/a" "Not Applicable")
    ("qotd" "Quote of the Day")
    ("siuta" "Should I Use This Acronym")
    ("tl;dr" "To Long; Didn't Read")
    ("tldr" "To Long; Didn't Read")
    ("lol" "Laughing Out Loud")
    ("fr fr" "???")
    ("no cap" "wut?")
    ))

(defmethod hunchentoot:acceptor-dispatch-request ((acceptor acceptor) request)
  (let ((script-name (hunchentoot:script-name request)))
    (cond ((or (equal script-name "")
               (equal script-name "/"))
           (if (eql :post
                    (hunchentoot:request-method request))
               (hunchentoot:redirect (format nil "/~a"
                                             (hunchentoot:post-parameter "acronym" request)))
               (spinneret:with-html-string
                 (:head
                  (:meta :property "og:title" :content "Should I use this acronym?")
                  (:meta :property "og:description" :content "No.")
                  (:style :type "text/css"
                          "html {font-family: sans-serif; width: 100vw; height: 100vh;}"
                          "body {height: 50%; width: 75%; margin: 25% auto;}"
                          ))
                 (:h1  "Should I use this acronym?")
                 (:form :action "/" :method "post"
                        (:input  :name "acronym" :style "margin-top: 1em; font-size: 2em;")
                        (:button :type "submit" :style "font-size: 2em;"
                                 "?")))))
          ((> (length script-name)
              1)
           (let* ((acronym (subseq (hunchentoot:script-name request) 1))
                  (question (format nil "Should I use the acronym \"~a\"?" acronym)))
             (spinneret:with-html-string
               (:head
                (:meta :property "og:title" :content question)
                (:meta :property "og:description" :content (format nil "No.~:[~;~:* Just say \"~a\"~]"
                                                                   (lookup-acronym acronym)))
                (:style :type "text/css"
                        "html {font-family: sans-serif; width: 100vw; height: 100vh;}"
                        "body {height: 50%; width: 75%; margin: 6.25% auto;}"
                        ))
               (:h1 question)
               (:div :style "padding-top: 2rem; font-size: 2em;"
                     "Don't use acronyms; they impede signification and thought.")
               (alexandria:when-let ((expansion (lookup-acronym acronym)))
                 (:div :style "padding-top: 2rem;"
                       ("You might use \"~a\" instead!" expansion)))))))))

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
