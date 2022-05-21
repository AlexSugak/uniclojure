(ns build
  (:require [clojure.tools.build.api :as b]))

(def lib 'uniclojure/common.ijava)
(def target "../dist/jar")
;;(def version (format "1.0.%s" (b/git-count-revs nil)))
(def version "1.0.0")
(def class-dir (str target "/classes"))
(def basis (b/create-basis {:project "deps.edn"}))
(def jar-file (format (str target "/%s-%s.jar") (name lib) version))

(defn clean [_]
  (b/delete {:path target}))

(defn jar [_]
  (b/write-pom {:class-dir class-dir
                :lib lib
                :version version
                :basis basis
                :src-dirs ["src"]})
  (b/copy-dir {:src-dirs ["src" "resources"]
               :target-dir class-dir})
  (b/compile-clj {:basis basis
                  :src-dirs ["src"]
                  :class-dir class-dir})
  (b/uber {:class-dir class-dir
           :uber-file jar-file
           :basis basis}))