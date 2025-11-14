# Information about the uwisdom collection of useful facts, and how to search it


This is a description/blurb of the doc/lookup/help program for searching wisdom files.





## Motivation


Albert Einstein said,


  I never waste memory on things that can easily be stored and retrieved
  from elsewhere.


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


Run `doc -h` for complete usage instructions (see `doc` alias below).



## Obtaining the files


The wisdom files appear on the web at
  <https://github.com/mernst/uwisdom/tree/wiki> .
You can get a local copy by following the instructions on that webpage.



## Comparison to web/email/etc. search


Why would you want to use this program when you can just search the web
instead?

* You may have local data that you choose not to put on the web for global searching (e.g., your address book).
* Having a local copy enables offline use.
* Information may be available elsewhere, but time-consuming to find via a web search or in a manual.


Whenever I spend too long finding information, and especially if I think I
might find the information useful in the future, I write an entry for a
wisdom file.  Then, when I am searching for information, I first search my
wisdom files, which only takes a moment.  Only if that fails do I proceed
to the manual, a web search, etc.


## Writing a wisdom entry


Please help to improve this resource by adding and updating the information!
You can submit a paragraph of text, a patch, a Mercurial bundle, or an
issue on the issue tracker.  You can also make your own clone and add your
personal information there, though it won't contribute to the main version.


When writing a wisdom entry, please use appropriate keywords to ensure that
you and others can find the information.  I often intentionally include
synonyms ("description" and "blurb", or "search" and "find" to make a search
more likely to find the correct entry.


The files use AsciiDoc syntax.



## Installing the lookup program, and shell aliases


The Lookup program is available as part of plume-lib
(<https://github.com/mernst/plume-lib>).


As indicated in the examples above, the Lookup program can be used for more
than just searching the wisdom files.  Here are some further bash aliases
that you can use when invoking the program.


```sh
  ## Lookup program.  "Lookup" is like "doc", but with the "-a" option (print
  ## all matches) and with no default files to examine.
  alias lookup='java -ea -jar ${HOME}/java/lookup.jar -a'
  alias doc='lookup -f ${HOME}/wisdom/root_user'
  alias bibfind='lookup -l -f ~/bib/bibroot'
  alias rolo='lookup -f ~/random/addresses.tex --comment-re='
  alias quotefind='lookup -f ~/random/quotes1 -f ~/random/quotes'
```


You can learn more about the Lookup program from its documentation.


<entry


// LocalWords:  wiki PAG pag pdfnup Cytron's bibfind cytron quotefind einstein
// LocalWords:  rolo rebelo Lookup lookup
