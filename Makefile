.DEFAULT_GOAL := help
.PHONY: build deps node-build node jar-build java dotnetcore all help

deps: ## installs all the dependencies
	@echo "installing dependencies" 
	@echo "clojure/java:"
	@brew install clojure/tools/clojure
	@brew install gradle # to build and run Java sample
	@echo "node:"
	@nvm install
	@npm install -g yarn # to run Node.js sample
	@echo "dotnet:"
	@brew tap isen-ng/dotnet-sdk-versions
	@brew install --cask dotnet-sdk5-0-400 #clojure clr supports .NET 5 currently
	@dotnet tool install --global Clojure.Main #for clojure clr REPL
	@echo "clojurem:"
	@./app-objc/clojurem/script/bootstrap 

node-build: ## builds common lib js package
	@echo "clj -> js"
	@rm -rf ./dist/node
	@cd ./lib-clj; \
	clj -M -m cljs.msrcain --target node --output-dir ../dist/node -c common.lib # add "--optimizations advanced" for production build
	@echo "done"

node: node-build ## builds and runs node app 
	@echo "running node app"
	@cd ./app-node; \
	yarn; \
	node index.js
	@echo "done"

jar-build: ## builds common lib jar
	@echo "clj -> jar"
	@cd ./lib-clj; \
	clj -T:build clean; \
	clj -T:build jar
	@echo "done"

java: jar-build ## builds and runs java app
	@echo "running java app"
	@rm -rf ./app-java/app/build
	@cd ./app-java; \
	gradle jar -PjarDir="${realpath ./dist/jar}"
	@java -jar ./app-java/app/build/libs/app.jar
	@echo "done"

dotnetcore: ## builds and runs .NET Core app
	@echo "running .NET Core app"
	@cd ./app-dotnetcore; \
	if [ "$(shell arch)" = "arm64" ]; then \
        dotnetx64 run; \
    else \
        dotnet run; \
    fi # on Mac M1 dotnet 5 SDK is linked to dotnetx64
	@echo "done"

clojurem-build: ## builds common lib to obj-c using clojurem compiler
	@echo "clj -> obj-c"
	@rm -rf ./dist/objc
	@rm -rf ./app-objc/clojurem/tmp
	@mkdir ./app-objc/clojurem/tmp

	@for file in $(shell find ./lib-clj/src -name \*.cljc); do \
		basename "$$file" .cljc | xargs -I {} cp $$file ./app-objc/clojurem/tmp/{}.cljm; \
	done
	cp ./app-objc/clojurem/src/cljm/cljm/core.cljm ./app-objc/clojurem/tmp/core.cljm

	@cd ./app-objc/clojurem; \
	./bin/cljmc ./tmp "{:out ../../dist/objc}"
	@echo "done"

objc: clojurem-build ## builds and runs objective-c app
	@echo "running Objective-C app"
	@rm -rf ./app-objc/out
	@xcodebuild -quiet -scheme app-objc -project ./app-objc/app-objc.xcodeproj build
	@mkdir ./app-objc/out/bin
	@mkdir ./app-objc/out/Frameworks
	@mv ./app-objc/out/app-objc ./app-objc/out/bin/app-objc
	@mv ./app-objc/out/CLJMRuntime.framework/ ./app-objc/out/Frameworks/CLJMRuntime.framework/
	@./app-objc/out/bin/app-objc
	@echo "done"

all: java node dotnetcore objc ## builds and tests all platforms
	@echo "all done"

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'