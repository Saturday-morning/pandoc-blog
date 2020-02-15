POSTS=$(shell find posts/*)
# OUT contains all names of static HTML targets corresponding to markdown files
# in the posts directory.
OUT=$(patsubst posts/%.md, static/%.html, $(POSTS))

all: requirements.txt $(OUT) index.html

# TODO: template.
static/%.html: posts/%.md
	pandoc -s $< -o $@

index.html: $(OUT)
	python3 make_index.py
	# TODO: template.
	pandoc -s index.html -o index.html --metadata pagetitle="blog"

clean:
	rm -f static/*

requirements.txt:
	pip install -r requirements.txt
