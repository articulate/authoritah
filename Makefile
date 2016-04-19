VERSION:= $(shell crystal eval 'require "./src/authoritah/version"; puts Authoritah::VERSION')

all: setup test build-release

setup:
	crystal deps install

build:
	crystal build -o authoritah src/cli.cr

build-release:
	crystal build --release -o authoritah src/cli.cr

test:
	crystal spec

release: all
	git push origin master
	git tag $(VERSION)
	git push origin tag $(VERSION)
