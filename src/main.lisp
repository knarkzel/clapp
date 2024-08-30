;; Dependencies
(ql:quickload '(:hunchentoot :easy-routes :spinneret))

(defpackage :app 
  (:use :cl :easy-routes)
  (:import-from :spinneret #:with-html-string))

(in-package :app)

;; HTML template
(defmacro with-page ((&key title) &body body)
  `(with-html-string
     (:doctype)
     (:html
      (:head
       (:title ,title)
       (:meta :charset "utf-8")
       (:meta :name "viewport" :content "width=device-width, initial-scale=1")
       (:link :rel "stylesheet" :href "https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.min.css")
       (:script :src "https://unpkg.com/htmx.org@2.0.2"))
      (:body :class "container"
       (:h1 ,title)
       ,@body))))

;; Routes
(defroute home "/" ()
  (with-page (:title "Welcome")
    (:p "Welcome to my simple web app!")
    (:p "Fetch about")
    (:button :hx-get "/about" :hx-swap "outerHTML")
    (:a :href "/greet?name=World" "Say hello")))

(defroute about "/about" ()
  (with-page (:title "About")
    (:p "Who am I?")
    (:a :href "https://github.com/knarkzel" "More about me")))

(defroute greet "/greet" (name)
  (with-page (:title "Greeting")
    (:p (format nil "Hello, ~A!" name))
    (:a :href "/" "Go back home")))

;; Create server
(defvar *server* (make-instance 'easy-routes:easy-routes-acceptor :port 8080))

(defun start-server ()
  (hunchentoot:start *server*)
  (format t "Server started on http://localhost:8080~%"))

(defun stop-server ()
  (hunchentoot:stop *server*)
  (format t "Server stopped~%"))
