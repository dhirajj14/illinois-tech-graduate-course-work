(ns examplecom.etc.email
  (:require [riemann.email :refer :all]))

(def email (mailer {:from "djain14@hawk.iit.edu"}))
