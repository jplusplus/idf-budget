install:
	sudo gem install compass
	yarn
	bower install

run:
	./node_modules/.bin/grunt serve

build:
	./node_modules/.bin/grunt build

deploy: build
	./node_modules/.bin/grunt gh-pages
