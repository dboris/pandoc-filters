.PHONY: all build clean run

all: build

build clean:
	@dune $@

run: build
	pandoc -t html \
		-M skip-attrs=class:foo,id:bar \
		--filter _build/default/bin/remove_by_attr.exe \
		test/test.md