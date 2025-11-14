# The uwisdom collection of useful facts

This is a collection of information that enables easy, local lookup.

## Motivation

Albert Einstein said,

> I never waste memory on things that can easily be stored and retrieved
> from elsewhere.

The "wisdom" files store information that is not worth memorizing, but
which I may wish to look up later.  You can retrieve the information with
the "doc" program.  Here are some sample invocations:

```sh
# Look up how to cross-mount PAG machines' scratch drives.
doc pag scratch

# How to remove inter-item vertical space from LaTeX list environments.
doc latex list space

# Typical command-line options to the pdfnup program.
doc pdfnup

# Find Ron Cytron's papers on static single assignment form.
bibfind cytron static single

# Find the Albert Einstein quote above.
quotefind einstein memory

# What is Maria's phone number?
rolo maria rebelo
```

## Obtaining the files

```sh
git clone https://github.com/mernst/uwisdom.git
```

## Searching the wisdom files

Each nugget of wisdom is separated from others by two blank lines.  The [Lookup
program](https://github.com/plume-lib/lookup) can search paragraph-wise,
respecing the two-blank-line delimiter.

The Lookup program can also be used to search other resources, as shown in the
examples above.  Here are some bash aliases that you can use when invoking the
program.  (You won't invoke `lookup` directory, only the others.)

```sh
alias lookup='java -ea -jar SOMEDIRECTORY/lookup/build/libs/lookup-all.jar -a'
alias doc='lookup -f ${HOME}/wisdom/root_user --two-blank-lines'
alias bibfind='lookup -l -f ${HOME}/bib/bibroot'
alias rolo='lookup -f ${HOME}/private/addresses.tex --comment-re='
alias quotefind='lookup -f ${HOME}/misc/quotes1 -f ${HOME}/misc/quotes'
```

Pass `-h` (for example, `doc -h`) for usage instructions.
You can learn more about the Lookup program from its [documentation](https://plumelib.org/lookup/api/org/plumelib/lookup/Lookup.html).

## Comparison to web/email/etc. search

Why would you want to use this program when you can just search the web or ask
an LLM instead?

* You may have local data that you choose not to put on the web for global
  searching (e.g., your address book).
* Having a local copy enables offline use.
* Information may be available elsewhere, but time-consuming to find via a web
  search or in a manual.
* LLMs can yield incorrect information.

Whenever I spend too long finding information, and especially if I think I
might find the information useful in the future, I write an entry for a
wisdom file.  Then, when I am searching for information, I first search my
wisdom files, which only takes a moment.  Only if that fails do I proceed
to the manual, a web search, etc.

## Writing a wisdom entry

Please help to improve this resource by adding and updating the information!
You can submit a paragraph of text, a pull request, or an issue on the issue
tracker.  You can also make your own clone and add your personal information
there, though it won't contribute to the main version.

When writing a wisdom entry, please use appropriate keywords to ensure that
you and others can find the information.  I often intentionally include
synonyms ("description" and "blurb", or "search" and "find") to make a search
more likely to find the correct entry.


// LocalWords:  wiki PAG pag pdfnup Cytron's bibfind cytron quotefind einstein
// LocalWords:  rolo rebelo Lookup lookup
