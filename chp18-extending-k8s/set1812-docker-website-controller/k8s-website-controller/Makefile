build:
	CGO_ENABLED=0 GOOS=linux go build -o website-controller -a pkg/website-controller.go

image: build
	docker build -t georgebaptista/website-controller:v1.1 .

push: image
	docker push georgebaptista/website-controller:v1.1
