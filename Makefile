image=nuid/sdk-ruby
container=nuid-sdk-ruby

build:
	docker build -t "$(image):latest" .

clean: stop rm rmi

console:
	docker exec -it $(container) /bin/sh

rm:
	docker rm $(container)

rmi:
	docker rmi $(image)

run:
	docker run -v $$PWD:/nuid/sdk-ruby -it -d --env-file .env --name $(container) $(image) /bin/sh

stop:
	docker stop $(container)

test:
	docker exec -it $(container) rake test

.PHONY: test
