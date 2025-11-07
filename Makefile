default:
	asciidoctor *.adoc

clean:
	for f in *.adoc ; do echo $$f ; rm -f $$(basename $$f .adoc).html ; done





# for f in *.adoc; do
#   echo ${f}:
#   # Or: --wrap=none
#   asciidoctor -b docbook -o $f.xml $f
#   pandoc --wrap=preserve -t gfm -f docbook -o $f.md $f.xml
# done
