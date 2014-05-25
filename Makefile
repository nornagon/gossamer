all:
	@npm install
	@mkdir -p gen
	./node_modules/.bin/watchify --debug -v -t coffeeify --extension='.coffee' src/main.coffee -o gen/bundle.js
