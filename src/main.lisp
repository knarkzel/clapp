;; Dependencies
(ql:quickload '(:hunchentoot :easy-routes :spinneret :dexador :com.inuoe.jzon))

(defpackage :app 
  (:use :cl :easy-routes :spinneret)
  (:local-nicknames (:jzon :com.inuoe.jzon)))

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
       (:link :rel "preconnect" :href "https://fonts.googleapis.com")
       (:link :rel "preconnect" :href "https://fonts.gstatic.com")
       (:link :href "https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,300;0,400;0,500;0,700;1,300;1,400;1,500;1,700&display=swap" :rel "stylesheet")
       (:style (:raw "body { font-family: Roboto; }"))
       (:script :src "https://unpkg.com/htmx.org@2.0.2"))
      (:body :class "container"
       (:h1 ,title)
       ,@body))))

;; Routes
(defroute home "/" ()
  (with-page (:title "Home")
    (:div
     (:p "Fetch latest data from news page")
     (:button :hx-get "/items" :hx-target "div" "Click me"))))

(defroute items "/items" ()
  (let* ((response (dex:get "https://jsonplaceholder.typicode.com/photos"))
         (items (jzon:parse response)))
    (with-html-string
      (:ul
       (loop for item across items do
         (:li
          (:p (gethash "title" item))
          (:img :src (gethash "url" item))))))))

;; Create server
(defvar *server* (make-instance 'easy-routes-acceptor :port 8080))

(defun start-server ()
  (hunchentoot:start *server*)
  (format t "Server started on http://localhost:8080~%"))

(defun stop-server ()
  (hunchentoot:stop *server*)
  (format t "Server stopped~%"))
