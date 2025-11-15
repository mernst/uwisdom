# The uwisdom collection of useful facts

This is a collection of information that enables easy, local lookup.

## Motivation

Albert Einstein said,

> I never waste memory on things that can easily be stored and retrieved
> from elsewhere.

The uwisdom project stores information that is not worth memorizing, but which I
may wish to look up later.  You can retrieve the information with programs such
as `doc`, described below.  Here are some sample invocations:

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

Install the [Lookup program](https://github.com/plume-lib/lookup).

The Lookup program can also be used to search other resources in addition to the
wisdom files, as shown in the examples above.  Here are some bash aliases that
you can use when invoking the program.  `doc` (short for "documentation")
searches these wisdom files.

```sh
alias lookup='java -ea -jar SOMEDIRECTORY/lookup/build/libs/lookup-all.jar -a'
alias doc='lookup -f ${HOME}/wisdom/root_user --two-blank-lines'
alias bibfind='lookup -l -f ${HOME}/bib/bibroot'
alias rolo='lookup -f ${HOME}/private/addresses.tex --comment-re='
alias quotefind='lookup -f ${HOME}/misc/quotes1 -f ${HOME}/misc/quotes'
```

Pass `-h` for usage instructions; for example, run `doc -h`.  You can learn more
from the [Lookup program's
documentation](https://plumelib.org/lookup/api/org/plumelib/lookup/Lookup.html).

## Searching private information

Running the `doc` alias searches all the files mentioned in [`root`](root).  If
file `root_user` exists, it is used instead.  You can create a `root_user` file
of the following form, which searches both everything in uwisdom and also your
personal files.

```text
\include{root}
\include{my-personal-file1}
\include{my-personal-file2}
```

## Comparison to web/email/etc. search

Why would you want to use this program when you could just search the web or ask
an LLM?

* You may have local data that you choose not to put on the web for global
  searching (e.g., your address book).
* Having a local copy enables offline use.
* Information may be available elsewhere, but time-consuming to find via a web
  search or in a manual.
* The web, and LLMs, sometimes provide incorrect or out of date information.

Whenever I spend time finding information, and I might want the information
again in the future, I write an entry for a wisdom file.  Then, when I am
searching for information, I first search my wisdom files, which only takes a
moment.  Only if that fails do I proceed to the manual, a web search, etc.

## Writing a wisdom entry

You can help to improve this resource by adding and updating the information.
You can submit a paragraph of text, a pull request, or an issue on the issue
tracker.

Each wisdom file is a Markdown file containing entries separated by **two**
blank lines.

When writing a wisdom entry, please use appropriate keywords to ensure that
you and others can find the information.  I often intentionally include
synonyms ("description" and "blurb", or "search" and "find") to make a search
more likely to find the correct entry.


// LocalWords:  wiki PAG pag pdfnup Cytron's bibfind cytron quotefind einstein
// LocalWords:  rolo rebelo Lookup lookup
