# Universal Clojure

At some point in your life you will want to write code once and use it on multiple platforms.

**DON'T DO THIS!**

But if you must, Clojure, as a universal language, is a good choice.

This repo provides an example of a simple library code, written in Clojure, that is used on multiple platforms:
- Java: being a JVM hosted language in the first place, it is possible to call Clojure functions from Java code
- Node.JS: using [ClojureScript](https://clojurescript.org/) to transpile Clojure code to node package
- **TODO:** Browser: using [ClojureScript](https://clojurescript.org/) to transpile Clojure code to modern JS
- .NET Core: using [ClojureCLR](https://github.com/clojure/clojure-clr) to host Clojure on .NET runtime
- **TODO:** .NET Framework: using [ClojureCLR](https://github.com/clojure/clojure-clr) to build .dll from clojure files
- C/ObjC: using [clojurem](https://github.com/joshaber/clojurem) to transpile Clojure code to Objective C
- **TODO:** C/ObjC: test [clojure-objc](https://github.com/galdolber/clojure-objc) and [clojurec](https://github.com/schani/clojurec)


## Getting started

- `$ make deps` to install dependencies. If that fails on your machine (it probably will), use corresponding target definition in Makefile to see what needs to be installed and why
- `$ make all` to build and run all samples
- `$ make help` to list all available targets