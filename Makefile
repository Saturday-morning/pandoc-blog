POSTS=$(shell find posts/*)
# OUT contains all names of static HTML targets corresponding to markdown files
# in the posts directory.
OUT=$(patsubst posts/%.md, output/gen/%.html, $(POSTS))

all: $(OUT) output/index.html

output/gen/%.html: ./posts/%.md
	pandoc -f markdown+fenced_divs -s $< -o $@ --template templates/post.html --css="../styles/common.css"

output/index.html: $(OUT) make_index.py
	python3 make_index.py
	pandoc -s output/index.md -o output/index.html --template templates/index.html  --css="./styles/common.css" --css="./styles/index.css"
	rm output/index.md

# Shortcuts

open: all
	open ./output/index.html

# Get an ISO 8601 date.
date:
	date -u +"%Y-%m-%dT%H:%M:%SZ"

clean:
	rm -f output/gen/*.html
	rm -f output/index.html

hook:
	ln -s -f ../../.hooks/pre-commit ./.git/hooks/pre-commit

.PHONY: install
install:
	pip install -r requirements.txt
	mkdir output gen styles posts img
	cp -r ./styles ./output/styles
	cp -r ./gen ./output/gen
	cp -r ./img ./output/img

update:
	rm -r ./output
	mkdir output
	cp -r ./styles ./output/styles
	cp -r ./gen ./output/gen
	cp -r ./img ./output/img
