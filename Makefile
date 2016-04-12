all: build

build:
	crystal build -o cartman src/cli.cr

build-release:
	crystal build --release -o cartman src/cli.cr

test:
	crystal spec
