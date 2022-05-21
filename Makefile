.DEFAULT_GOAL := help
.PHONY: build deps node-build node jar-build java all help

deps: ## installs all the dependencies
	@echo "installing dependencies" 
	@echco "clojure/java:"
	@brew install clojure/tools/clojure
	@brew install gradle
	@echco "node:"
	@npm install -g yarn
	@echco "dotnet:"
	@brew tap isen-ng/dotnet-sdk-versions
	@brew install --cask dotnet-sdk5-0-400 #clojure clr supports .NET 5 currently
	@dotnet tool install --global Clojure.Main

node-build: ## builds common lib js package
	@echo "clj -> js"
	@rm -rf ./dist/node
	@cd ./lib-clj; \
	clj -M -m cljs.main --target node --output-dir ../dist/node -c common.lib # add "--optimizations advanced" for production build
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

all: java node dotnetcore ## builds and tests all platforms
	@echo "all done"

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'