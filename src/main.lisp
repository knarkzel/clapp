;; Dependencies
(ql:quickload '(:hunchentoot :easy-routes :spinneret))

(defpackage :app 
  (:use :cl :easy-routes :spinneret))

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
       (:link :rel "stylesheet" :href "/pico.css")
       (:link :rel "stylesheet" :href "/styles.css"))
      (:body (:main (:h1 ,title) ,@body)))))

;; Routes
(defroute home "/" ()
  (with-page (:title "Home")
    (:form :action "/submit" :method :post
           (:div :class "grid grid-cols-2 gap-4"
                 (:label :for "name" "Name" (:input :type "text" :name "name"))
                 (:label :for "age" "Age" (:input :type "number" :name "age")))
           (:button "Submit"))))

(defroute submit ("/submit" :method :post) (&post name age)
  (redirect 'home))

;; Create server
(setf hunchentoot:*dispatch-table*
      `(hunchentoot:dispatch-easy-handlers
        ,(hunchentoot:create-folder-dispatcher-and-handler 
          "/" "../static/")))
(defvar *server* (make-instance 'easy-routes:easy-routes-acceptor :port 8080)) ;; (hunchentoot:start *server*)

