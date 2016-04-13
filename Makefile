all: build

build:
	crystal build -o authoritah src/cli.cr

build-release:
	crystal build --release -o authoritah src/cli.cr

test:
	crystal spec
