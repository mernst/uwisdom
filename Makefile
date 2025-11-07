ADOC_FILES:=$(wildcard *.adoc)
MD_PANDOC_FILES:=$(patsubst %.adoc,%.md-pandoc,${ADOC_FILES})
MD_PANDOC_NOWRAP_FILES:=$(patsubst %.adoc,%.md-pandoc-nowrap,${ADOC_FILES})
MD_DOWNDOC_FILES:=$(patsubst %.adoc,%.md-downdoc,${ADOC_FILES})

default:
	@echo "Doing nothing."

# This is for linting.
asciidoctor:
	asciidoctor *.adoc

clean:
	for f in *.adoc ; do echo $$f ; rm -f $$(basename $$f .adoc).html ; done

very-clean:
	for f in *.adoc ; do echo $$f ; b=$$(basename $$f .adoc) ; rm -f $$b.html $$b.md-downdoc $$b.md-pandoc $$b.xml ; done

# Both pandoc and downdoc have their limitations.  I will probably need to run and diff both. :-(

md-pandoc: ${MD_PANDOC_FILES}

md-downdoc: ${MD_DOWNDOC_FILES}

%.md-pandoc: %.adoc
	b=$$(basename $< .adoc); asciidoctor -b docbook $$b.adoc; pandoc -f docbook -t commonmark_x --wrap=preserve -o $$b.md $$b.xml ; preplace '``` ' '```' $$b.md ; mv $$b.md $@

%.md-downdoc: %.adoc
	b=$$(basename $< .adoc); npx downdoc $< ; sed -i "s/’/'/g" $$b.md ; mv $$b.md $@

clean-markdown:
	for f in *.adoc ; do echo $$f ; rm -f $$(basename $$f .adoc).md ; done

# This is a bit perverse.  The point is to find whitespace fixes to perform.
markdownlint-on-adoc:
	markdownlint-cli2 ${ADOC_FILES}


# for f in *.adoc; do
#   echo ${f}:
#   # Or: --wrap=none
#   asciidoctor -b docbook -o $f.xml $f
#   pandoc --wrap=preserve -t gfm -f docbook -o $f.md $f.xml
# done

TAGS: tags
tags:
	etags ${ADOC_FILES}


showvars:
	@echo "ADOC_FILES=${ADOC_FILES}"
	@echo "MD_PANDOC_FILES=${MD_PANDOC_FILES}"
	@echo "MD_PANDOC_NOWRAP_FILES=${MD_PANDOC_NOWRAP_FILES}"
	@echo "MD_DOWNDOC_FILES=${MD_DOWNDOC_FILES}"
