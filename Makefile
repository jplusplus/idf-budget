install:
	sudo gem install compass
	yarn
	bower install

run:
	./node_modules/.bin/grunt serve

build:
	./node_modules/.bin/grunt build
