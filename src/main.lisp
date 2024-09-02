;; Dependencies
(ql:quickload '(:hunchentoot :easy-routes :spinneret))

(defpackage :app 
  (:use :cl :easy-routes :spinneret))

(in-package :app)

;; Create server
(setf hunchentoot:*dispatch-table*
      `(hunchentoot:dispatch-easy-handlers
        ,(hunchentoot:create-folder-dispatcher-and-handler 
          "/" "../static/")))
(defvar *server* (make-instance 'easy-routes:easy-routes-acceptor :port 8080)) ;; (hunchentoot:start *server*)

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
      (:body
       (:header
        (:nav
         (:ul
          (:li (:strong "Halal")))
         (:ul
          (:li (:a :href "/side-1" "Side 1"))
          (:li (:a :href "/side-2" "Side 2"))
          (:li (:a :href "/side-3" "Side 3")))))
       (:main (:h1 ,title) ,@body)))))

;; Routes
(defmacro section (&key left right)
  `(with-html (:div :class "grid grid-cols-2 gap-4" ,left ,right)))

(defroute home "/" ()
  (with-page (:title "Home")
    (:form :action "/submit" :method :post
           (section
            :left (:div
                   (:h1 "Hello there")
                   (:p "Amazing day today"))
            :right (:div
                    (:label :for "name" "Name" (:input :name "name")))))))
