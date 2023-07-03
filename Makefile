.PHONY: all build clean test run

all: build

build clean:
	@dune $@

test:
	@dune runtest

run: build
	pandoc -t html \
		-M remove-attrs=class:foo \
		-M remove-attrs=id:bar \
		--filter _build/default/bin/remove_by_attr.exe \
		test/test.md