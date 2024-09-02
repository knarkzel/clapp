;; Dependencies
(ql:quickload '(:hunchentoot :easy-routes :spinneret :hunchentoot-errors))

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
          (:li (:strong "BILKURSEN")))
         (:ul
          (:li (:a :href "/kjøp-bil" "Kjøp bil"))
          (:li (:a :href "/selg-bil" "Selg bil")))
         (:ul
          (:li (:button "Logg inn")))))
       (:main ,@body)))))

;; Routes
(defmacro section (&key name text body)
  `(with-html
     (:div :class "grid grid-cols-2 gap-4 pb-4 border-b"
           (:div (:h2 ,name) (:p ,text)) ,body)))

(defroute home "/" ()
  (with-page (:title "Home")
    (:form :action "/submit" :method :post
           (section :name "Personal information"
                    :text "This is specifically for people that haven't travelled before"
                    :body (:div (:label :for "name" "Name" (:input :name "name")))))))
