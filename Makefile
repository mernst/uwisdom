MD_FILES:=$(wildcard *.md)

default:
	@echo "The 'default' target does nothing."

markdownlint:
	markdownlint-cli2 --fix "**/*.md" "#node_modules"

TAGS: tags
tags:
	etags ${MD_FILES}


showvars:
	@echo "MD_FILES=${MD_FILES}"
