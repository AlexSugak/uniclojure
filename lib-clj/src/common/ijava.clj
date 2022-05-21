;; a wrapper to expose library to java world
(ns common.ijava
  (:require [common.lib :as cl])
  (:gen-class 
    :name common.ijava
    :methods [#^{:static true} [hello [String] String]]))

(defn -hello [^String input] (cl/hello input))