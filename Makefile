# Generate static website with pandoc

# User configurable stuffs
PUSHCOMMAND := rsync -r site/ myserver.com:/var/www/data/ --delete
CSS := custom.css # custom CSS file
TEMPLATE := template.html # Pandoc template file
SITENAME := -T 'redroom.me' # website name 
PANDOCTOC := --toc --toc-depth 2 # table of contents
MATHJAX := --mathjax=https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML

#----------------------------------
# Pandoc command to build html pages from md
PANDOC := pandoc -s $(SITENAME) $(MATHJAX) -t html5 --template resources/$(TEMPLATE) --css $(CSS) $(PANDOCTOC)

#----------------------------------
all: site index $(addprefix site/, $(patsubst %.md,%.html,$(wildcard *.md))) site/index.html site/custom.css site/bootstrap.min.css

site:
	mkdir -p site

site/custom.css : resources/custom.css
	cp resources/custom.css site/custom.css 

site/bootstrap.min.css : resources/bootstrap.min.css
	cp resources/bootstrap.min.css site/bootstrap.min.css 

index : site
	bash resources/gen_index.sh

site/%.html : %.md | site
	$(PANDOC) $< -o $@

site/index.html : index.md | site
	$(PANDOC) index.md -o site/index.html

# python is required to serve the site
serv : 
	pushd site; python -m SimpleHTTPServer; popd

# change this to be your server
push:
	$(PUSHCOMMAND)

clean :
	rm -r site index.md

