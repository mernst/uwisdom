MD_FILES:=$(wildcard *.md)

default:
	@echo "Doing nothing."

markdownlint:
	markdownlint-cli2 "**/*.md" "#node_modules"

TAGS: tags
tags:
	etags ${MD_FILES}


showvars:
	@echo "MD_FILES=${MD_FILES}"
