# Wisdom about programs


On github.com, you can view the table of contents of this file by clicking the
menu icon (three lines or dots) in the top corner.


This file is a bit of a catch-all, for everything that does not have a
dedicated wisdom file.


## File format conversions for printing


To convert a text file to PostScript or PDF.
Reasonable choices:

* paps: is packaged for Unix distributions (Ubuntu, Red Hat), so perhaps
   it is widely used, even though the last release was in 2007
* cedilla: works fine, many command-line arguments.  A bit of a pain to
   install because you have to install clisp first.

Poor choices, if you are concerned about UTF-8 (non-ASCII characters):

* enscript: doesn't handle 8-bit by default
* a2ps: probably handles 8-bit
* mpage: doesn't handle 8-bit by default
* u2ps: Internet chatter says it is not as good as paps?
* h2ps and bg5ps: intended specifically for Asian fonts


Enscript is a standby, since it has so many options and is widely installed,
but it doesn't handle UTF-8, and GNU enscript has not been updated since
2012 (version 1.6.6).  a2ps has, though, and it does syntax highlighting.
If you care about UTF-8 or Unicode, use cedilla or paps (neither one does
syntax highlighting).
Otherwise, to convert a text file to PostScript (86 characters per line):

```sh
  enscript -pout.ps in.txt
  enscript -o OUTFILE.ps -f Courier8 INFILE        # 105 columns
  enscript -o OUTFILE.ps -f Courier7 -r INFILE     # 132 columns, landscape
```

Can add "-H 2" for highlight bars (good for tabular data).

enscript common options:

* -h: no burst/header page
* -B: no page headings


a2ps is maintained!  But it's a bit of a pain to install.
The equivalent a2ps line is:

```sh
  a2ps -r -f 7 -E --highlight-level=normal --columns=1 -o OUTFILE.ps INFILE
```

or, with syntax highlighting (why no -E argument?):

```sh
  a2ps -r -f 7 --columns=1 -o OUTFILE.ps INFILE
```


Conversions between PostScript and PDF:

* PS -> PDF:

```sh
   distill foo.ps   (for an entire directory, "distill -files .ps")
   ps2pdf foo.ps
```

* PDF -> PS:
   Avoid these acroread invocations; pdftops seems better.

```sh
   acroread -toPostScript file.pdf
   cat sample.pdf | acroread -toPostScript > sample.ps
   acroread -toPostScript sample1.pdf sample2.pdf <dir>
   acroread -toPostScript -pairs pdf_file_1 ps_file_1 ...
   acroread -toPostScript -level2 pdf_file_1
```

When using acroread to manually do the conversion, selecting the option
"Download Fonts Once" in the Print menu may cause math fonts to be messed
up; in case of that trouble, deselect this option.


sam2p: convert raster (bitmap) image formats into Adobe PostScript or PDF.


To convert a Microsoft Word .doc file to PDF:

* open it in OpenOffice and export as PDF
* wvPDF file.doc file.pdf

Neither technique dominates the other, and each is sometimes bad


To convert PDF to ASCII text (txt) format, use the pdftotext program, which is
part of the xpdf package.


To convert a 1-page PDF to good-quality .gif:

```sh
  convert -density 300 -quality 100 file.pdf file.gif
```


html2ps converts a HTML file to PostScript, potentially recursively.

```sh
  html2ps -n -u -C bh -W bp http://pag.csail.mit.edu/daikon/ > index.ps
```

* "-n" means number pages
* "-u" means underline links
* "-C bh" means generate a table of contents.
* "-W bp" means process recursively retrieving hyperlinked documents ("p"
   means prompt for remote documents).  Watch out:  using -W b might seem
   reasonable, but it will try to print some binary files!
* "-2L" means two-column landscape


Format manual pages:  nroff -man foo.1 | more
Print roff files:     troff -t filename | lpr -t
.ms => PostScript:    groff -pte -ms file.ms > file.ps
man pages => PS:      groff -pte -man foo.1 > file.ps


/uns/share/bin/ps2img converts PostScript to gif (or other image format?)
files.  It will handle multipage postscript files fairly gracefully without
filling up your disk, and it will look for and pay attention to the
BoundingBox of EPS files if you give the -e option.  Run it with no
arguments to see the options.


LAOLA converts Microsoft Word .doc documents to plain text.  It is
superseded by the Perl OLE::Storage module
(<http://wwwwbs.cs.tu-berlin.de/~schwartz/perl/> or
<http://www.cs.tu-berlin.de/~schwartz/perl/>), which gives access to
"structured storage", the binary data format of standard Microsoft Windows
OLE documents.


## PostScript and PDF


To convert a PostScript file for A4 paper for printing on letter
size paper (that is, to shift the text down on the page), use

```sh
   pstops -pletter '0(0,-.75in)' a4file.ps letterfile.ps
```

Alternately, convert to PDF and then back to PostScript, using ps2pdf and
pdf2ps.  Or use pdftops, which seems nicer than pdf2ps.
To create Encapsulated PostScript, can also run

```sh
  pdftops -eps
```


To rotate a PostScript document (landscape to portrait to seascape), use
the "L" or "R" or "U" modifiers.  For instance:

```sh
  pstops -pletter '0L(8.5in,0)' orig.ps rotated-counterclockwise.ps
```


To combine/interleave two PDF files, one containing odd pages scanned and the
other containing even pages scanned in reverse order:

* To use `pdfjam`, see <https://unix.stackexchange.com/a/53316/14002> .
* To use `pdftk`: `pdftk A=odds.pdf B=evens.pdf shuffle A Bend-1 output merged.pdf`
* Online: <https://www.sejda.com/alternate-mix-pdf>


Tools for transforming PDF files:

* PDFjam is a single program, along with 10 wrappers, each with
   a single purpose (e.g., pdf90 to rotate by 90 degrees).
* pdftk is a single program with many command-line options.
   As of 2023, there has been no release since 2013.
   Does not install easily on Red Hat/Fedora/RHEL/CentOS.
   A newer version pdftk-java is aliased to pdftk on Ubuntu (& Debian?).
   Maybe it can be installed more easily?
* cpdf is an alternative to both; but is free only for personal use.
   "Charities and educational institutions still require a license."


Separate/split a file into individual pages:

```sh
  cpdf -split in.pdf -o out%%%.pdf
  pdftk infile.pdf burst
```

Select pages from a file:

```sh
  pdfjam -o outfile.pdf infile.pdf 2-3
  pdfjam -o outfile.pdf infile.pdf 3-
  pdftk infile.pdf cat 2-3 output outfile.pdf
  pdftk infile.pdf cat 3-end output outfile.pdf
```

To concatenate PDF files:

```sh
  pdfjam -o outfile.pdf infile1.pdf infile2.pdf
  pdfunite file1.pdf file2.pdf singlefile.pdf
  cpdf -merge ${ALL_PDFS} -o singlegfile.pdf
  pdfjoin --output singlefile.pdf ${ALL_PDFS}
  pdftk ${ALL_PDFS} cat output singlefile.pdf
```


To rotate a PDF file:

```sh
  cpdf -rotate 180 in.pdf -o out.pdf
```

(This worked better than -rotate-contents for me, but see <https://www.coherentpdf.com/cpdfmanual/indexse22.html> .)
Gradescope has a "rotate submission" feature, but it requires a lot of clicks.


Use psnup to place multiple logical pages of a PostScript document on a single
physical page (say, to print two-up), try psnup.
Other options are psmulti and
mpage (but mpage doesn't deal well with graphics or encapsulated PostScript).
Sample use (-d adds lines between logical pages):

```sh
  psnup -4 -d file.ps file-4up.ps
  psnup -2 -d file.ps file-2up.ps
  psnup -4 -l -d file.ps file-4up.ps    # landscape (e.g., slides)
```

One can also use pdfnup:

```sh
  pdfnup --nup 2x1 file.pdf
  pdfnup --frame true --nup 2x2 file.pdf    # 4-up slides
  pdfnup --frame true --nup 2x3 file.pdf    6-up slides
```

pdfnup is part of PDFjam.
Maybe I can just do

```sh
  lpr -o number-up=2 filename
```

There is also the podofo suite of tools.
evince's print dialog does not seem available from the command line.


Sample use of mpage (-o suppresses lines between pages):

```sh
  mpage -2 file.ps > file-2up.ps
```

but don't use it; psnup seems better.


To compute a correct bounding box for an Encapsulated PostScript file:

```sh
  epstool --copy --bbox bad.eps --output good.eps
```

This replaces the obsolete bbfig program.


To compute a correct MediaBox and/or CropBox (the PDF equivalents of a
bounding box):

```sh
  FILE=myfilebasename
  pdftops -eps ${FILE}.pdf
  epstool --copy --bbox ${FILE}.eps --output ${FILE}-cropped.eps
  epstopdf ${FILE}-cropped.eps
```

ghostview:  view PostScript on an X windows display.


If you are having trouble printing from Acrobat Reader (such as missing
characters on some pages):
Printer Properties >> Advanced >> Postscript Options >> PS Output : Optimize for Portability


If ghostview can't view a document correctly, then perhaps the PostScript
file starts with something like

```postscript
  %!PS-Adobe-2.0 EPSF-1.2
```

but does not conform to ADSC (Adobe document structuring conventions).
Try changing the first line to

```postscript
  %!PS
```

and ghostview won't look for ADSC comments.
Or, use gs (ghostscript), which gives a plain X window, no ghostview buttons.


Converting PostScript to text (ASCII), and other PostScript FAQs:
<http://www.geocities.com/SiliconValley/5682/postscript.html>
Just using gs (ghostscript; see "ps2ascii" alias) works better than the pstotext program.


To add page numbers to a PostScript document (does not work for PDF):  pspage


PrimoPDF.com is a free PDF converter for most Windows applications.


To convert a paper formatted for LNCS into two-column, use

```sh
  lncs2up file.ps
```


To compress a PDF file:

```sh
  gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dNOPAUSE -dQUIET -dBATCH -sOutputFile=output.pdf input.pdf
```


To create a multi-page set of tiles (each tile is letter size) that can be
tiled together to make a poster, use `pdfposter`, eg `pdfposter -p3x3Let in.pdf out.pdf`.
...
To print a USGS topographical quad map on 8 sheets of letter paper:

```sh
  BASENAME=foo
  pdfcrop --margins '-20 -40 -40 -200' ${BASENAME}.pdf
  pdfposter -p3x3Let ${BASENAME}-crop.pdf ${BASENAME}-crop-poster.pdf
```

A problem is that this doesn't respect the printable area of the printer.
See <http://leolca.blogspot.com/2010/06/pdfposter.html> .

Here are older commands that use `poster`, from when I wasn't able to get the
pdfposter program to work, so I converted to PostScript and used poster instead:

```sh
  pdftops madrid-transport-center-2009.pdf
  poster -v -mA4 -s1.3 madrid-transport-center-2009.ps > madrid-transport-center-2009-tiled-scaled1.3.ps
  ps2pdf madrid-transport-center-2009-tiled-scaled1.3.ps
```

To print a USGS topographical quad map on 8 sheets of letter paper:

```sh
  BASENAME=foo
  pdfcrop --margins '-200 -50 -150 -150' ${BASENAME}.pdf
  pdftops ${BASENAME}-crop.pdf
  poster -v -mletter -s1.2 ${BASENAME}-crop.ps > ${BASENAME}-scaled1.2.ps
  ps2pdf ${BASENAME}-scaled1.2.ps
```


## HTML and CSS


To make a webpage automatically forward/redirect, see
  <http://www.cs.washington.edu/info/faq/homefaq.html#else>

More simply, do:

```html
  <meta http-equiv="Refresh" content="0; URL=http://www.mit.edu/~6.170" />
```

This belongs in the `<head>` section, along with `<title>`.
The number "0" can be set to a delay in seconds.


HTML checking:

* htmlproofer
* htmlchek is quite picky (not necessarily a problem) and hasn't been
   updated since February 20, 1995
* NetMechanic seems reasonable.  <http://www.netmechanic.com/html_check.htm>
   Can check both HTML and links (the latter very slow).  Only checks 5 pages.
* weblint is basic but functional:  <http://www.weblint.org>
* Try W3C HTML Validation Service, <http://validator.w3.org/>


The checklink program (from W3C) tells about broken links in HTML documents.
Run like this:

```sh
  checklink -q -r http://homes.cs.washington.edu/~mernst/
  ~/bin/src/checklink/checklink -q -r $(grep -v '^#' ~/bin/src/checklink/checklink-args.txt) MYURL
```

(Linkchecker (from <http://linkchecker.sourceforge.net/>?) seems to spawn
lots of threads and never return.)
Probably best to run these in the background with output sent to a file.
`tidy` checks HTML.


To improve accessibility when using bootstrap:

```html
  <style>
    a { text-decoration: underline; }
  </style>
```

Why can't I put this in a .css file?


In HTML and CSS, to set font color and style, you can do one of the following:

```html
  <span style="color:red">
  <p style="color:red">
```

```html
  <style>
  .done {
    text-decoration: line-through;
  }
  </style>
  <li class=done>Recitation 3</li>
```

```html
  .accesskey {
     text-decoration: underline;
     font-weight: bold;
  }
  <span class="accesskey">x</span>
```

```html
  ..uline { text-decoration: underline; }
  ... <span class="uline">"Deliver Us from Evil</span> ...
```

```html
  <div style="width: 100px;
    height: 100px;
    background-color: green;
    margin: auto">
  Centered Green Box
  </div>
```


For horizontal and vertical alignment in HTML:

```html
    <img src="version-control-fig1.png" alt="Basic version control" style="float:right" />
    <img src="version-control-fig2.png" alt="Centralized version control" style="vertical-align:middle" />
```


HTML em dash: &mdash; or &#8212;
HTML en dash: &ndash; or &#8211;


Here is a template/boilerplate for the start/beginning of a typical HTML file:

```html
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
  <title>TITLE</title>
  <link rel="Start" href="http://www.mit.edu/~6.170/" />
  <link rel="StyleSheet" href="stylesheet.css" />
</head>
<body>
<h1>TITLE</h1>
...
</body>
</html>
```


To add a "favicon.ico" image to the address bar, do this in the
`<head>...</head>` section of the HTML document:

```html
  <link rel="icon" type="image/png" href="my-favicon.png" />
```


Do not use the `<tt>` tag, which is not supported in HTML5.
Instead, use one of

* `<kbd>` for keyboard input
* `<var>` for variables (mathematical and meta-variables, but not generally code)
* `<code>` for computer code (including filenames)
* `<samp>` for computer output


## WWW


To target an HTML link to a specific page in a PDF file, add `#page=PAGENUMBER`
to the end of the link's URL.


To restart the httpd server:

```sh
  /etc/rc.d/init.d/httpd restart
```

or else

```sh
  /etc/rc.d/init.d/httpd stop
  /etc/rc.d/init.d/httpd start
```

Another possible problem that could lead to failure to server webpages is
that I failed to start Guidescope; do "myxapps".


To allow use of "order", "allow", and "deny" in .htaccess, I had to add the
following to /etc/httpd/conf/httpd.conf:

```htaccess
  # To allow use of "order", "allow", and "deny" in .htaccess.
  <Directory /home/httpd/html/pag/daikon>
    AllowOverride limit
  </Directory>
  <Directory /home/httpd/html/pag/pag>
    AllowOverride limit
  </Directory>
```

(Then I stopped and restarted the http server.)


The `flatten` program converts hierarchies of WWW (World Wide Web) pages into a
single page, for easier browsing.  The pages are concatenated in depth-first
order.


To use the `html-update-toc` script to maintain a table of contents in a
webpage, insert the following near the top of the file:

```html
<p>Contents:</p>
<!-- start toc.  do not edit; run html-update-toc instead -->
<!-- end toc -->
```

Also consider running, in Emacs, <kbd>M-x html-add-heading-anchors</kbd>.


To convert HTML to a printable form (PostScript):
I sometimes have trouble with html2ps, and find that htmldoc is better:

```sh
  htmldoc --webpage -t ps --outfile FILE.ps FILE.html
```

Apache 1.3.33 recognizes only the last "Options" directive, it seems.
So put all the arguments in one directive:

```apache
  Options Indexes FollowSymLinks SymLinksIfOwnerMatch
```

Alternately, precede each argument by +, which means to modify the
existing option directives instead of overriding and resetting them.

A caveat about FollowSymLinks:  if any directory along the path is not
accessible to the web server, then the symbolic link will appear not to
exist.


If guidescope isn't working, try "guidescope &".  I'm not sure exactly how
to make this start up automatically every time.


To find out the location of the apache/httpd config files and other
information about the server, execute `httpd -V`.  This works on all
systems that support apache (macos, windows, linux)


### Firefox


Firefox extensions (.xpi files): to install, open them in Firefox.
Adblock: <http://adblock.mozdev.org/>
Firefox Adblock filter list: <http://www.geocities.com/pierceive/adblock/>
(Must update by hand via "Tools > Adblock > Preferences > Adblock Options > Import filters".)
Also get the Adblock filter updater extension.


In Firefox, setting "font.name.serif.x-western" to "sans-serif" causes webpages to appear in sans serif font by
default.  It also makes webpages print in sans serif, which is not
necessarily desirable:  sans serif is easier to read on screen, but serif
is easier to read on paper.  I wish there was an easy way to get both of
those features.

To enable the setting: browse to
about:config, or (easier) use Edit >> Preferences >> Content >> Fonts &
Colors >> Default Font)


If Firefox or Thunderbird says that a copy is already running, but that
doesn't seem to be the case, then find and delete the file .parentlock
somewhere under  ~/.mozilla or ~/.mozilla-thunderbird .


In Firefox, to make searches ("find") default to case-insensitive:
Press <kbd>Ctrl+F</kbd>, the quick find appears at taskbar.
Uncheck the Match case check box


If Firefox behaves badly (doesn't go to homepage, address bar doesn't
update, back button doesn't work), try moving your ~/.mozilla directory
aside, because one of your plugins may be corrupting Firefox.


### Chrome


For the URLs of all (recently-used) tabs, browse to:
chrome://inspect/#pages


## ssh (secure shell) and public keys


To use ssh (and other tools like CVS, SVN, git, Hg, ...) with RSA public keys,
do this at the beginning of each development session (say, immediately
after logging in):

```sh
  eval `ssh-agent`
  ssh-add
```

Do not use the following, which is intended for X sessions.

```sh
  ssh-agent bash
  ssh-add
```

or, alternately:
To run an entire X-session underneath ssh-agent:

1. move `.xinitrc` file (other X client startup script) to `.xinitrc-real`.
2. add the command "ssh-add" to the beginning of that script.
3. create a new `.xinitrc` script containing the sole command:

   ```conf
   [source]
   .~/.xinitrc
   ```

   ```sh
   exec ssh-agent $HOME/.xinitrc-real
   ```


To set up public keys for ssh-agent and similar programs:

 1. On client machine (from which I will login), do `ssh-keygen`
 2. Append client's `~/.ssh/id_rsa.pub` (or `identity.pub`, etc.) to server's `~/.ssh/authorized_keys` (and maybe `~/.ssh/authorized_keys2`, if you are using ssh2)

ssh2 needs file `~/.ssh/authorized_keys2`; to make it, do

```sh
  cd ~/.ssh; cat is_dsa.pub > authorized_keys2; chmod 600 authorized_keys2
```

The `authorized_keys*` files must not be group-writeable; do this:

```sh
  chmod 600 ~/.ssh/authorized_keys
  chmod 600 ~/.ssh/authorized_keys2
```


ssh: secure remote login.  Need to copy contents of identify.pub on client
machine into `authorized_keys` on server machine.


ssh2 supports sftp, an ftp client.  It does not seem to be free for
research use.  OpenSSH does not seem to have sftp.


SSH timeouts seem to be controlled in a variety of ways.  The
file `/etc/ssh/sshd_config` contains a number of setups.  It
was suggested to set KeepAlive (possibly TCPKeepAlive) to
avoid the firewall dropping an inactive connection.  Also
ClientAliveInterval which causes the daemon to periodically
poll the client to see if it is still alive.


## Email


Websieve (sieve) RFC is rfc3028, with Sieve grammar and rules.
There is a sieve email filter script tester (and syntax checker) at
  <http://sastools.com/SieveTest/sievetest.php>
(websieve itself only creates scripts, doesn't validate them.)
Be sure to remove any "From VM" rule before running sievetest!


To have mailing list errors reflected to the list administrator:

* If you are using sendmail, the first thing to do is create the alias:

  ```text
      owner-edb-list: edb-list-request
  ```

  This causes errors occuring on edb-list to be reflected to "owner-edb-list".
* The other, sure-fire way is to pipe the edb-list mail through a sendmail
  invocation which changes the sender:

  ```sendmail
      edb-list: "|/usr/lib/sendmail -fedb-list-request -oi real-edb-list"
      real-edb-list: :include:/usr/lib/edb-list.alias
  ```


To expand a mailing list (alias), to learn its members:

```sh
  telnet gh 25
  expn elbows
  quit
```

Another technique is "finger -a list@host"; at UW this works for me from
Solaris (eg hoh), but not from Linux (eg nishin).
If you get a 503 error, try doing "helo HOSTNAME" and then doing expn.


Rich Salz's newsgate/mail2news program can inject all mailing list mail
into a similarly named (local only) newsgroup, and vice versa.
ftp.uu.net:/usenet/comp.sources.unix/volume24/newsgate/part0[1-4].Z


To decode a MIME file (actually just one component of a mime message), use

```sh
  mmencode -u mimefile > plainfile
```

You need to save to a file (it doesn't read from standard input), and to
strip off all headers (e.g., "Content-Type:" and "Content-Transfer-Encoding:").
For quoted-printable, use -q flag as well.
Also see the script (stolen from Greg Badros) "decode_mime", which

* strips off headers
* chooses a filename intelligently


Mime unpacking:  use ftp://ftp.andrew.cmu.edu/pub/mpack/
Options:

* -f
          Forces the overwriting of existing files.  If a message
          suggests a file name of an existing file, the file will be
          overwritten.  Without this flag, munpack appends ".1", ".2",
          etc to find a nonexistent file.
* -t
          Also unpack the text parts of multipart messages to files.
          By default, text parts that do not have a filename parameter
          do not get unpacked.
* -q
          Be quiet--suppress messages about saving partial messages.
* -C directory
          Change the current directory to "directory" before reading
          any files.  This is useful when invoking munpack
          from a mail or news reader.


To send a single file as a MIME email (attachment), do (be sure to copy myself):

```sh
  mpack -s "Subject line" -d descriptionfile filename address@host address2@host2
  mpack -s "Subject line" filename address@host address2@host2
```

To write to a file,

```sh
  mpack -s "Subject line" -o outputfile filename
```

To add some ASCII text at the beginning:

```sh
  mpack -s "Subject line" -d descriptionfile -o outputfile filename
```

mpack can only encode one file, not multiple files.  For that, try pine.


In Horde, to "bulk delete" or "delete all", go to the folders view, mark
the desired folder, and then "Choose Action:  Empty Folder(s)".


To upload mbox files to Gmail IMAP, use:  <http://imap-upload.sourceforge.net/>
Typical invocation (for hosted apps at cs.washington.edu)

```sh
python imap_upload.py --gmail --user=$<USER@cs.washington.edu> --password=PASSWORD --box GMAIL-LABEL --error ~/error.mail TO-UPLOAD.mail
```

It may be necessary to convert a BABYL file to mbox format.
Don't use b2m for that; instead, use:  <kbd>M-x unrmail</kbd>
(No need to read the file in as an RMAIL file; just run <kbd>M-x unrmail</kbd>.)


If you read Gmail via IMAP, then your trash mail doesn't get deleted and it uses up your quota.  You may want to delete it for real.
You only want to do this for Google Mail that is in [Imap]/trash and has no other user or system labels.  (I can't use -has:userlabels, unfortunately.)
I want the trash label and no others; the way seems to be to list every label!

```text
-in:sent -in:chat -in:draft -in:inbox -in
```

There is also `has:nouserlabels`; is that useful?
Also see the tips here:
<https://support.google.com/mail/answer/78892?hl=en>


## Eclipse


Useful keystrokes in Eclipse:

* <kbd>C-S-t</kbd>  lookup type (like <kbd>M-.</kbd> in Emacs, but only for classes, not methods)
* <kbd>F3</kbd> open definition, also like <kbd>M-.</kbd>
          (how do you find a method's definitions?)
* <kbd>C-S-h</kbd> all callers (call sites) for a particular method implemention (but
    not calls via a superclass or interface):  opposite of <kbd>F3</kbd>
* <kbd>C-S-r</kbd>  lookup resources: finds all uses of this method name, like grep; but
    stays within the type hierarchy, not just textual; more useful than <kbd>C-S-h</kbd>
* <kbd>C-h</kbd>  textual search through Java files
* <kbd>F5</kbd>   refresh (for updates made through the file system)
* <kbd>C-O</kbd>  quickly type your way to a field or method declaration
* <kbd>F4</kbd> class hierarchy (also available from a context menu)
  Eclipse Debugger:  <kbd>F6</kbd> goes to next line


To make Eclipse use spaces instead of tabs for indentation:

* Go to menu:Window[Preferences > Java > Code Formatter]:
  * In the "Style" tab:
    * Uncheck "Insert tabs for indentation, not spaces."
    * Set "Number of spaces representing an indentation level" to 2 (2 is standard; but choose whatever value)
* Go to menu:Window[Preferences > Java > Editor]:
  * In the "Typing" tab:
    * Check "Insert space for tabs"


Changing the font size in Eclipse:
  Window > Preferences > General > Appearance > Colors and Fonts > Basic >
  Text Font > Change : select and apply the new font size
To go back to the old font size, click the Reset button.
Or, use this plugin: <http://smallwiki.unibe.ch/fontsizebuttons>


Under Eclipse "Run configurations", a useful VM argument is "-ea".


When compiling Daikon, may be simpler to add daikon.jar to "User Entries"
section of Eclipse classpath.
You can define your own variables.


Eclipse Javadoc:  .html files get written to working directory.
So be sure to save changes to these before you start testing javadoc.


Eclipse has two compilers.


* The model reconciler operates on buffers and runs on every keystroke to
   create red squigglies.  (It's called that because it reconciles the internal
   representation or model of the program with the visual representation in the
   editor.)
* The incremental project builder (for short, "builder") operates on files and
   runs whenever the user saves the file.  It can do a full build (by clearing
   out resources such as .class files first) as well as an incremental build.
   The implementation for java invokes the eclipsec compiler.  (Occasionally
   people use the term "reconciler" incorrectly to refer to incremental project
   building.)


## IntelliJ


To prevent IntelliJ from using wildcard imports, you must do *both* of the following:

* Click on the Settings "wrench" icon on the toolbar, open "Imports" under "Code Style", and check the "Use single class import" selection.
* go to Preferences (<kbd>⌘ + ,</kbd> on macOS / <kbd>Ctrl + Alt + S</kbd> on Windows and Linux) > Editor > Code Style > Java > Imports tab
* set Class count to use import with '*' and Names count to use static import with '*' to a higher value. Any value over 99 seems to work fine.


## VMware


To run VMware tools:

```sh
  vmware-toolbox &
```

To install VMware tools, see ~mernst/wisdom/building/build-vmware


In VMware, shared folders from the host appear in /mnt/hgfs/.


Do not switch between VMware regular and virtual console while the mouse is
moving, because the switch might occur between packets that the mouse is
sending, throwing off synchronization.


<kbd>Ctrl-Alt-Space</kbd> is the VMware escape:  the next key (such as <kbd>Ctrl-Alt-ESC</kbd>)
goes to the guest, rather than being interpreted by VMware.


In VMware, press <kbd>Ctrl-Alt</kbd> to take mouse/keyboard focus away from the guest.


MAC address of VMware (discovered via "/usr/sbin/arp"): 00:0C:29:C1:70:EF
Spoof MAC address under Linux:

```sh
  sudo /sbin/ifdown eth0
  sudo ifconfig eth0 hw ether 00:0C:29:C1:70:EF
  sudo /sbin/ifup eth0
```


## Docker


A Docker container image is simply a root filesystem (snapshot) for a given
process. This snapshot only encapsulates the userspace pieces (specifically, the
filesystem).  Containers use the kernel of the host where they are running, but
they do not share libraries such as libc.  Each Docker container has its own set
of libraries since each container has its own, unique root filesystem.


To run an interactive bash shell in a docker container
(a docker image is an inert file):

```sh
  docker run -it OWNER/NAME /bin/bash
```

or

```sh
  docker images
  docker run -it <image> /bin/bash
```


To copy files out of a docker image:

```sh
  docker cp <containerId>:/path/to/file /path/on/host
  docker cp -r <containerId>:/path/to/directory /path/on/host
```


To create a docker image (which is a static template that can be
instantiated into a running container), good instructions appear at
<https://docs.docker.com/engine/tutorials/dockerimages/>.  In brief, run
the following in an empty directory.

```sh
  docker login
  # No tag number; we'll just depend on the "latest" tag.
  docker -l warn build -t mdernst/ubuntu-for-cf .
  # List the available images
  docker images
  # Upload to Docker Hub
  docker push mdernst/ubuntu-for-cf
  # Browse to https://hub.docker.com/ to verify that it exists
```


To list docker images (static files, that would be instantiated as containers):

```sh
docker images
```

To remove/delete a docker image:

```sh
docker rmi ID
```

To remove all non-running containers:

```sh
docker rm $(docker ps -q -f status=exited)
```

To stop and remove/delete/clean all docker containers (leaves the static images):

```sh
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
```

To stop all docker containers, then remove/delete/clean all docker images:

```sh
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker rmi -f $(docker images -q)
```

To remove even more files, including (large) build cache objects:

```sh
docker system prune -a -f
```


If a Docker container has no Internet (example message: "Temporary failure in name resolution"), run (in the host):

```sh
sudo service docker restart
```


To turn a Docker image into a tarball:

* Build the Docker image locally; for example, `docker -l warn build -t <image-name>:latest .;
* Save it as a .tar.gz with `docker save <image-name> | gzip > foo.tar.gz`
* You can run that `.tar.gz` via `gunzip -c foo.tar.gz > foo.tar` followed by `docker load < foo.tar`


If docker fails with

```text
docker: Error response from daemon: cgroups: cgroup mountpoint does not exist: unknown.
```

then run:

```sh
sudo mkdir /sys/fs/cgroup/systemd
sudo mount -t cgroup -o none,name=systemd cgroup /sys/fs/cgroup/systemd
```


## Markdown


For converting (GitHub-style) markdown format (.md file) to HTML:

* `quarto render INPUT.MD --output-dir OUTDIR` where OUTDIR may be the same for multiple files.
* `basename=myfile && pandoc --standalone < ${basename}.md > ${basename}.html`
* `markdown` produces poor output, doesn't handle triple-backtick, etc.
* `grip --export` exports to `<path>.html`.
Markdown format is idiosyncratic and has many variants, so it may be better
to use AsciiDoc format and the Asciidoctor processor, when possible.


To write a comment in a Markdown file, write this with blank lines both before and after:

```markdown
[comment]: # (Here is the text of the comment.)
```


List of fenced code block identifiers (programming languages) for Markdown:

* <https://github.com/github-linguist/linguist/blob/main/lib/linguist/languages.yml>
* <https://github.com/highlightjs/highlight.js/blob/main/SUPPORTED_LANGUAGES.md>
* <https://pygments.org/docs/lexers/>


Markdown parsers:

* <https://github.com/kivikakk/comrak>
   "Comrak's design goal is to model the upstream cmark-gfm as closely as possible in terms of code structure."
* <https://github.com/github/cmark-gfm>


A modern alternative to Markdown, by the author of Pandoc and CommonMark, is djot.
File names end in `.dj`.
It isn't yet supported by GitHub, which makes it less practical to use.



## AsciiDoc


AsciiDoc has various advantages over Markdown, especially for complex documents
and books, but Markdown handles simple cases and it is widely known by
programmers and supported by tools.


Convert Markdown to AsciiDoc: <https://github.com/asciidoctor/kramdown-asciidoc> .
Some people say don't use pandoc, but for simple documents it seems fine and
<https://pandoc.org/try/?from=markdown&to=asciidoc> doesn't require any software
installation.


Convert AsciiDoc to Markdown:

* `basename=MYBASENAME; asciidoctor -b docbook $basename.adoc; pandoc -f docbook -t commonmark_x -o $basename.md $basename.xml --wrap=none`
  Problem: code fences are turned into indentation, which I do not like.
* <https://github.com/opendevise/downdoc>
  Does not handle backtick fenced code blocks, which are an *extension* to
  AsciiDoc rather than part of the base specification.
* <https://gitlab.com/bburt/convert-asciidoc-to-markdown>
  I don't trust this repo because all its commits are on one day.


An example of an AsciiDoc document that has both HTML and PDF is <https://junit.org/junit5/docs/current/user-guide/> .


On GitHub, AsciiDoc comments (lines starting with //) seem to be rendered rather than ignored.


In AsciiDoc, `+` (space followed by plus) is a hard line break (newline).


In AsciiDoc, to put a callout within a list item (ie, indented rather than at the top level), add unindented "+" on a line by itself immediately before the callout.
Then after the callout use unindented `{empty}` if the following text is indented.
`{empty}` can take the place of `+` elsewhere.


## Diff


To make a diff file good for patching old-file to produce new-file,

```sh
  diff -c old-file new-file
```

In GNU diff, specify lines of context using `-C N` (not `-c N`).


There is no standalone `diff` program that incorporates the patience diff
algorithm, but instead you can use

```sh
  git diff --no-index --patience ...
```

This does a two-way, not a three-way, diff.


moss:  a software plagiarism detector by Alex Aiken.
<http://www.cs.berkeley.edu/~aiken/moss.html>


With the `-N` or `--new-file` command-line option, `diff` shows the full
contents of a new or deleted file (a file that did not exist), rather than
displaying "Only in ...".
Use

```sh
diff --unidirectional-new-file
```

to only show the contents of a new file, not one that has been deleted.


To use difftastic with git:

```sh
GIT_EXTERNAL_DIFF=difft git diff
GIT_EXTERNAL_DIFF=difft git --ext-diff log -p
GIT_EXTERNAL_DIFF=difft git --ext-diff show e96a7241760319
# For current changes only:
git difftool
git dft
```


I cannot figure out how to see all differences (even mergeable ones) among 3
files, using the "<<<<<<", "||||||", and ">>>>>>" conflict markers/brackets.
See my question at <https://stackoverflow.com/questions/78252587>.


## make


For a list of all makefile targets:

```sh
make -qp |
    awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ {split($1,A,/ /);for(i in A)print A[i]}' |
    sort -u
```


## AI tools


AI code review, free for open source:

* CodeRabbit
* Codacity code review: <https://www.codacy.com/pricing>
* CodeAnt code review: <https://www.codeant.ai/pricing>
* Aikido.dev: <https://www.aikido.dev/code-quality/free-open-source-ai-code-review>
AI code review tools to investigate:
* <https://zeropath.com/> -- highly praised by a detailed blog for security vulnerabilities
* <https://www.qodo.ai/>
* <https://www.greptile.com/>
* <https://devlo.ai/>


## Vi editor


vi editor commands:

* <kbd>:q</kbd> quits vi after a file has been saved
* <kbd>:q!</kbd> quits vi without saving the file
* <kbd>:qa!</kbd> quits vi without saving the file
* <kbd>:x</kbd> saves the file and quits vi
* <kbd>:wq</kbd> saves the file and quits vi
* <kbd>:help</kbd> help


## General wisdom (that is, everything without its own section above)


Information about a variety of Java tools can be found in the wisdom
repository, in file JavaTools.md.


`expand`, `unexpand`:  change TABs to SPACEs and vice versa.


`rehash`:  If my path seems messed up, or I've added programs, do rehash.


`sed`:  text replacement.  For example, sed -e '/^SED/ s|SED|SOGGY|' man-sed | more


`ps`:  Use ps -aux to get job #s of all jobs.  On some machines such as SGIs,
`ps -lf` gives a long full listing (use -e or -d to see more processes).
`top` shows percent of CPU being used by each process; good adjunct to ps.
`ps` options:

* `-l` long format, shows priorities (set by nice or renice)
* `-u` user-oriented format
* `-a` show all processes
* `-x` show even processes with no controlling terminal
* `-w` use wide display


`xterm`:  give -ut flag to prevent appearing in finger.


`system`, `eval` evaluate their argument.
`exec` replaces the current shell with its argument.  Be careful!


`sleep`:  delays execution; waits that many seconds.


`expr`:  Bourne shell way to do lots of stuff (ex regular expressions,
arithmetic, comparisons); see also TEST


Programs for drawing figures under X Windows (from best to worst in ease of use):

* OpenOffice/LibreOffice draw
* inkscape -- can't attach text to an object easily (could group them to
     fix the position, but then scalng doesn't work right)
* drawio -- not processable by LaTeX, `convert`, etc.
* xfig (abandoned in 2005)
* idraw (abandoned in 2002)
* skencil (formerly called sketch) (Skencil 0.6.17 released 2005-06-19)
* dia (0.96 was released 2007-03-25; latest as of Sep 2012)
* tgif -- (version 4.1.45 released 6/2006)

The mayura draw program for Windows takes Windows Metafiles (such as produced by
PowerPoint) and creates PostScript.
It may be best just to create figures using PowerPoint...


The Ipe extensible drawing editor edits PDF files directly:
<https://ipe.otfried.org/>


`split`:
Use

```sh
  wc -l <file>
```

then

```sh
  split -<numberoflines> <file> <newfilebase>
```

to split files into parts.


`du`:  disk usage.

* `du -s *`     only display grand total for each file and subdirectory in this dir
* `du -S`       not sum child directories in count for parent
* `du | sort -r -n`   sort directories, with most usage first.
* `du | xdu`    only when you're in X, obviously. Better grain than above, with the ability to drill down into subdirectories

Looking at files within a single directory, rather than a whole directory tree:

* `ls -l | sort -n +4` sorts files in size order, good for finding big files in a directory
* `du -s * | sort -n` similar to above, find the biggest files & subdirectories of the current dir


To make a soft link, do

```sh
  ln -s filename linkname
```


`expect`:  controls interactive programs to permit them to be used in a batch
fashion via send/expect sequences, job control, user interaction, etc.


Use a "here doc" to create a script file that will respond to any prompt, not just a
top-level one:

```sh
  #! /bin/csh
  ftp -n foo.bar.baz <<END
  user anonymous mernst@theory.lcs.mit.edu
  cd pub/random
  get some-useful-file
  quit
  END
```


`crontab`:  batch programs run repeatedly (say, each night)


`nslookup` converts domain names into ip numbers.
`host` and `dig` also query the same DNS information.


`ftp`:  do "prompt off" to turn off confirmation requests on multiple commands


Running persistent background jobs on multiple machines:
Create a shell script that does `rsh <nice command>` on
the various machines, and then run the shell script on a machine that
doesn't get rebooted very often.


If there is no password specified in the netrc file, then the macdef init
seems not to take.


To permit arbitrary-size core dumps:  `unlimit corelimit`


Undo the setuid bit of a file with `chmod -s`.


`df`:  Report free disk space and which filesystems are mounted.


`tar`:  tape archive program for representing a directory as a single file.
Usual extraction from files is

```sh
  tar xf filename
```

Create an archive file recursively containing all the files in the current
directory with

```sh
  tar cf tarfile.tar *
```

It's better, though, to create a tar archive that extracts itself into a
directory by doing

```sh
  tar cf tarfile.tar dir
```


To extract a rar archive:

```sh
  unrar e archive.rar
```


Converting binhex files:
  `hexbin foo` creates `foo.bin`.  Also consider `-u` or `-U` option.


In /usr/local/man, manX subdirectories contain raw man pages.
catX subdirectories contain formatted man pages preprocessed by

```sh
  neqn man1/emacs.1 | tbl | nroff -man > cat1/emacs.1
  pack -f cat1/emacs.1
```

The `.z` suffix on these files indicates that they were created by `pack` (use
`unpack` or `pcat` to view), NOT `gzip`.


`renice` causes a running program to acquire only idle resources.


`strace` tells all systems calls made by a process (a program run from
the command line).  It's `truss` on Solaris.


`ldd *executablename*` tells which shared libraries a program uses.


`/etc/groups` on some systems is `ypcat group` on others.
The `id` program also lists the groups for each user.


`gnuplot`: with the "eps" terminal, has only six symbols available.  The
"latex" terminal has more symbols (and the output is more customizable),
though the output isn't as pretty.


To find/replace a multi-line string, use perl:

```sh
perl -0777 -i.original -pe 's/input containing\nmultiple lines/Output can also have multiple\nlines/igs' myfile.txt
```


To copy a (local) directory recursively:  `cp -pR source target-parent`

To copy a (remote) directory structure from one machine to another:

```sh
  tar cf - packages | rsh ebi "cd /tmp/mernst/pack-cppp-new && tar xf -"
  tar cfz - packages | rsh hokkigai "cd /tmp/mernst && tar xfz -"
```

This is like

```sh
  rcp -rp mernst@torigai:/tmp/mernst .
```

except that the latter doesn't preserve symbolic links.


Regular expressions (regexes, regexps):

* In alternation, first match is chosen, not longest match.  For
  efficiency, put most likely match (or most likely to fail fast) first.
* `(ab)?(abcd)?` matches "ab" in "abcde"; does not match the longer "abcd"
* character class `[abc]` is more efficient than alternation `(a|b|c)`
* unrolling the loop:     `+opening normal* (special normal*)* closing+`
   * eg, for a quoted string:   `+/L?"[^"\\]*(?:\\.[^"\\]*)*"/+`
     or `+$string_literal_re = 'L?"[^"\\\\]*(?:\\.[^"\\\\]*)*"';+`
   * start of normal and special must never intersect
   * special must not match nothingness
   * text matched by one application of special must not be matched by
     multiple applications of special


`uname` gives operating system (`uname -a` gives more info).


`sysinfo`:  information about this hardware, like amount of memory,
architecture, operating system, and much more.
`/usr/sbin/psrinfo -v`:  information about processor speed and coprocessor.
The `top` program also tells the machine's amount of memory and swap space.
Also see `uname -a` and `cat /proc/cpuinfo` (as
well as some of the other kernel pseudo-files under `/proc/`).


The `ispell` program will merge personal dictionaries (`.ispell_english`) found
in the current directory and the home directory.


To run a program disowned (so that exiting the shell doesn't exit the
program), precede it by `nohup`.  Programs run in the background also
continue running when the shell exits (though interactive programs and some
others seem to be exceptions to this rule; or maybe the rule about
background jobs continuing only applies for programs that ignore the hangup
(hup) signal).


To find all the executables on my path with a particular name:
`/usr/local/bin/which -a`


To convert a directory from DOS to Unix conventions:

```sh
foreach f ( `find . -type f` )
  echo $f
  dos2unix $f $f | grep -v 'get keyboard type US keyboard assumed'
end
```


`mkid` (part of GNU's id-utils) is something like `tags`, but records all uses
of all tokens and permits lookup.  There's an Emacs interface, too.


The `file` command gives information about the file format: type of file,
executable (including debugging format), etc.


On a Kinesis Advantage contoured keyboard:

* Soft reset: Press <kbd>Progm + Shift + F10</kbd>.
* Hard Reset: With computer turned off, press <kbd>F7,</kbd> turn computer on, release <kbd>F7</kbd> after about 10 seconds. Successful if the lights on your keyboard flash for several seconds after releasing.
* Toggle the click:  <kbd>Progrm key + pipes/backslash key</kbd> (below the hyphen key)
* Toggle the tone: <kbd>progrm+hyphen</kbd>
* Dvorak
  * on Advantage 2 keyboard:  <kbd>progrm+f4</kbd>
  * on Advantage 1 keyboard:  <kbd>progrm+shift+f5</kbd> (this erases any remapping, but not macros)
* If I am getting bizarre "super" modifiers, then the keyboard may be in Mac
  mode.  Holding down <kbd>=</kbd> then tapping <kbd>s</kbd> may produce
  "v3.2[]".  Change to PC mode by holding down <kbd>=</kbd> then tapping
  <kbd>p;</kbd> now holding down <kbd>=</kbd> and tapping <kbd>s</kbd> may
  produce "v3.2[SL K H x e ]".


ImageMagick is a replacement for (part of) xv:  three of its programs are:

* `display` will view images in a great many different file formats.
* `import` grabs screen shots, either that you select with the mouse, that
   you specify by window ID, or the root window.
* `convert old.gif new.jpg` lets you easily change image formats.


`locate` finds a file of a given name anywhere on the system.
Its database is updated nightly or so.  To update it manually:

```sh
sudo updatedb
```


To use `crypt` to encrypt a string, like in the password file `/etc/passwd`,
use `openssl passwd`.
(Note that `crypt` is known to be insecure; only use it for `/etc/passwd`.)


Use `chsh` to set/change your shell, such as from `sh` to `bash`.


If using YP for password (yppasswd) and other files, don't edit /etc/group;
instead, as root, edit, then rebuild the NIS database:

```sh
 ${EDITOR} /var/yp/etc/group
 cd /var/yp; make
```

If `yppasswd` does not work, then maybe the ypbind and/or yppasswd daemons
have died.  `ypwhich` will return an error message if ypbind has stopped.
To restart the daemons, do (as root)

```sh
  /etc/rc.d/init.d/ypbind restart
  /etc/rc.d/init.d/yppasswdd restart
```


To see the equivalent of a yppasswd entry for user foo, do
`ypmatch foo passwd` or `ypcat passwd | grep -i foo` or `~/bin/getpwent foo`.
Or, at MIT LCS, do `inquir-cui` at mintaka.lcs.mit.edu.


Find all subdirectories:

```sh
  find . -type d -print
  find . -type d -exec script {} \;
```

Make all subdirectories readable and executable by group:

```sh
  find . -type d -exec chmod g+rx {} \;
```

Make all files readable by group:

```sh
  find . -type f -exec chmod g+r {} \;
```

Find all group-writeable files:

```sh
  find . -type l -prune -o -perm -020 -print
```


If machines come up before the ntpd server (and as a result their time
and date are not synchronized/synched), run this command on each machine:

```sh
  /etc/rc.d/init.d/xntpd restart
```


`zip -r foo foo`
makes a zip archive named foo.zip, which contains directory foo and all its
contents.
The first argument is the zipfile base name, and the rest of the arguments
are its contents.


To uuencode a file:   `uuencode filename filename > filename.UUE`


Use `unzip` to extract files from zip/pkzip archives.


`finger` crashes on NIS clients when the GECOS field of the NIS-entry is
blank and the user home directories is chmod'd to 700.  (as of 1/2002)


To compute a file's checksum, use `sum` or `cksum` or `md5sum`.
For an entire directory, `md5deep` works.


A way to find typos and grammar errors in papers:  run ps2ascii on a
(one-column) PostScript file, then paste the result into Microsoft Word and
run its grammar checker.


Sometimes a single NFS client cannot see a directory when other clients of
the same server can see the directory.  A workaround is to run `rmdir` on
the troublesome directory; this seems to fix the problem.


Valgrind is a free, good Purify-like detector of memory errors.  It's better
than what is built into gcc.  <https://valgrind.org/>


To encrypt/decrypt:

```sh
  openssl enc -aes128 -pbkdf2 -e -in file -out file.aes128
  openssl enc -aes128 -pbkdf2 -d -in file.aes128 -out file.decrypted
```

Optional argument:  -k secretkey
For other ciphers, change -aes128
Concrete example:

```sh
  openssl enc -aes128 -pbkdf2 -e -in wisdom.machines.decrypted -out wisdom.machines.aes128 && chmod og-rwx wisdom.machines.decrypted && rm -f wisdom.machines.decrypted
  openssl enc -aes128 -pbkdf2 -d -in wisdom.machines.aes128 -out wisdom.machines.decrypted && chmod og-rwx wisdom.machines.decrypted
```


To encrypt/decrypt a file symmetrically with GPG (but I have had trouble with it):

```sh
  gpg --output encrypted.data --symmetric --cipher-algo AES256 un_encrypted.data
  gpg --output un_encrypted.data --decrypt encrypted.data
``


To encrypt a file symmetrically with openssl:

```sh
  openssl enc -aes256 -pbkdf2 -e -in lastpass.csv-`date +\%Y\%m\%d` -out lastpass.csv-`date +\%Y\%m\%d`.aes256
```

To decrypt:

```sh
  openssl enc -aes256 -pbkdf2 -d -in FILE.aes256 -out FILE.decrypted
```


Don't use the "follow" option in Unison, which can delete the real file
behind a symbolic link in ~/.synchronized -- see my Unison files for details.


After adding a script to /etc/rc.d/init.d, add two symbolic links to
/etc/rc.d/rcN.d/.
The one starting with "S" (start) is invoked when runlevel N is entered.
The one starting with "K" (kill) is invoked when runlevel N is exited.


`chmod g+s dirname` sets the directory's SGID bit/attribute.  Files created
in that directory will have their group set to the directory's group.
Directories created in that directory also have their SGID bit set.
(The SGID bit has nothing to do with the sticky bit.)


`lpr` can assign "classes" or priorities to jobs.  For instance, to bypass
all other jobs in the queue, do `lpr -C Z *filename*` (Z is the highest
priority/class).


If trying to print results in the error
  lpr: error - scheduler not responding!
then make sure that your PRINTER environment variable is properly set.


To run a spell-check program that requires only one filename argument at a time:

```sh
foreach file (*.tex)
  ispell $file
end
```


To run VNC:

```sh
  vncviewer `cat ~/.vncip`
```


`/etc/sudoers` says

```sh
# This file MUST be edited with the 'visudo' command as root
```

But the `visudo` command just does file-locking and checks for syntax errors;
it's fine to edit the file with another editor.


To have a mount re-done at each reboot,
put in `/etc/fstab`:

```fstab
  jbod.ai.mit.edu:/fs/jbod1/mernst-temp /mnt/dtrace-store nfs     defaults       \
 0 0
```

(And you can also issue just `mount /mnt/dtrace-store` now.)
This particular mount requires that the following appear in `/etc/hosts.allow`:

```hosts
  ALL: 128.52.0.0/255.255.0.0
```


Delta debugging application:

* <http://delta.tigris.org/>
* <https://www.st.cs.uni-saarland.de/dd/ddusage.php3>


Parallel/distributed jobs across many machines:

* The distcc compiler permits compilation jobs to be distributed (in
   parallel) across many machines.  See <http://distcc.samba.org/>.
* Another useful tool for speeding up compilation is ccache; to use it,
   change the `CC=gcc` line in your Makefile to be `CC=ccache gcc`.
* `drqueue`, the distributed renderer queue; I'm not sure how
   rendering-specific it is.
* There are two add-ons to GNU make:

  * The customs library; read about it in the make distro in README.customs

    (It will ask you to download pmake from
    ftp://ftp.icsi.berkeley.edu/pub/ai/stolcke/software/, among other things.)

  * The GNU make port to PVM: <http://www.crosswinds.net/~jlabrous/GNU/PVMGmake/>

    More about PVM: <http://www.epm.ornl.gov/pvm/>

* OpenPBS: <http://www-unix.mcs.anl.gov/openpbs/>


To start up network on Linux laptop (for NIC; not necessary for PCMCIA):
Debian:

```sh
  /sbin/ifup eth 0
```

Red Hat:

```sh
  /etc/sysconfig/network-scripts/ifup eth0
```


To set wireless card SSID and key, run (as root):

```sh
  /sbin/iwconfig eth1 essid "Chaos"
  /sbin/iwconfig eth1 key 03-ef-etc.
  /sbin/iwconfig eth1 key "s:asfd"
```

To see your current settings:

```sh
  /sbin/iwconfig eth1
```


Use the rss2email program as follows:
First, run

```sh
 r2e new <mernst@csail.mit.edu>
```

but don't re-run that as it blows away all configuration files.
Then, run one of

```sh
 r2e add '<http://forum6170.csail.mit.edu/index.php?type=rss;action=.xml>'
 r2e add '<http://forum6170.csail.mit.edu/index.php?type=rss;action=.xml;limit=255>'
 r2e add '<http://cathowell.blogspot.com/feeds/posts/default?alt=rss>'
```

and finally, nothing happens unless I run

```sh
 r2e run
```

periodically -- say, every minute or hour in a cron job.


To print a reasonable map from google maps do the following:

* execute `import map.jpg`
* Draw a rectangle over the part of the map you want.  The result will
    be saved in map.jpg
* execute `gimp map.jpg`
* print from gimp.  Gimp does a nice job of laying the jpeg out on
    the screen and allows you to scale it and the like.


To create a transparent signature stamp:

* scan a hardcopy of my signature
* clean it up (in Paint or in the Gimp)
* use Gimp to make the background transparent:
  * menu > layer > transparency > add alpha channel
  * click on the fuzzy selector tool (magic wand)
  * for each area to remove, select it, then "edit > clear" (<kbd>ctrl + k</kbd>)
  * save as gif or png
  (instructions from <http://www.fabiovisentin.com/tutorial/GIMP_transparent_image/gimp_how_to_make_transparent_image.asp>)
* Imagemagick's `convert` program didn't work, so convert the gif or png to
  PDF with Acrobat Professional
* Convert the PDF to EPS via imagemagick's `convert` program (other
  techniques might work, too)


When you have a PDF file that is marked up with annotations, you can either
view the annotation text one-by-one in a PDF reader, or you can create a PDF
file that contains the annotations visibly.  Different people prefer the
two approaches, and some PDF readers such as Evince don't seem to provide
any way to view the annotations.
Here is how to create a PDF that shows the annotation/comment text:

* Using Acrobat Reader or Foxit Reader: start Print, then select "Summarize
   Comments" in the print dialog (sometimes in the upper right).  That pops
   up another print
   dialog, where you can finally print or save to PDF.  The final PDF has
   alternating pages of the original document and the comments, with each
   annotation in the original document cross-referenced to the comments page.
  * Acrobat Reader is a bit easier to use, but as of 4/2019 Dragon is unusably
      slow (10-15 seconds), though Dragon still works with other programs.
  * With Foxit Reader, to make a comment using voice dictation, I must:
    * select the text
    * double-click to open the comment box
    * speak; after a second or two the text comes up in a "Dictation Box"
    * Click "transfer" to copy the text to the comment box.
* In Acrobat Professional:  Review & Comment >> Summarize Comments
   In Foxit Reader: Comment >> Summarize Comments
   This can draw lines between the annotations in the original document and
   the comments, or format in other ways such as the way that printing does.
   I like the numbered, separate page style.
* Foxit Reader can also export just the text of all the annotations.
* I cannot find a way to print PDF annotations on Ubuntu.
  * No answer at <https://askubuntu.com/questions/1092169/is-there-a-pdf-software-that-allows-printing-a-comment-summary>
  * xournal doesn't do it
  * Foxit Reader doesn't do it.  I don't see a button "Summarize Comments" in the print dialog box as claimed by <https://help.foxitsoftware.com/kb/how-to-print-a-pdf-file-with-the-comment-notes-contents-showing.php>
  * Acrobat Reader doesn't exist except for Windows, Mac, and Android.
  * LibreOffice/OpenOffice doesn't display PDF well.


To insert an image in Foxit Reader: Navigate to HOME menu in Foxit Reader,
choose Image Annotation, position the cursor on the area you want to insert
the image, hold and drag your mouse to draw a rectangle, browse an image in
the pop-up Add image dialog box, and click on Ok to insert it.


To make a screencast video demo (i.e., screen capture/recording from a
running program), Marat Boshernitsan recommends
Camtasia Studio from TechSmith (<http://www.techsmith.com/camtasia.asp>).
(It's a full suite of tools and has affordable educational pricing.)
Marat Boshernitsan says,
  My biggest piece of advice is to edit heavily for length and to add as
  many visual annotations to the video as possible.  Camtasia's
  video-editing component allows the user to extract all pauses (as short
  as a fraction of a second) from the video to create a smooth-flowing
  presentation.  Their annotation tools enable insertion of highlights and
  callouts to focus the viewer's attention on the important areas of the
  screen.  I prefer screen annotations to voiceovers, because they allow
  watching the video without reaching for headphones.
  To see an example, click on one of the demo links on this page:
  <http://nitsan.org/~maratb/blog/2007/05/01/aligning-development-tools-with-the-way-programmers-think-about-code-changes/>
  It is a bit time-compressed to fit into the 5 minute limit imposed by CHI.


If OpenOffice or LibreOffice is trying to restore a file that no longer
exists, press 'escape' at the Recovery window.


To print an OpenOffice or LibreOffice Calc spreadsheet (.xls) on one page, first do:
Format > Page > Sheet tab > Scale options > Scaling mode > "Fit print range(s) on number of pages" > Number of Pages: 1

Alternately:
Print preview icon > Format Page > sheet tab > Scaling Mode > Fit print range on page{s}: 1


In LibreOffice/OpenOffice, to freeze rows/columns so that they do not
scroll but are always visible, select the row (or cell) BELOW (and to the
right of) the one you want to freeze, then do Window > Freeze.


Setting up a new USB microphone/headset:  run

```sh
  gnome-volume-control
```

When the application starts, choose the default device and unmute both the
headphones *and* the microphone.


On Linux, after plugging in headphones, you have to tell the application
(e.g., Skype) you are trying to use with the headset to use the second
soundcard (card1) in order to get audio over the headphones.


The `-e` argument to mail means send no mail if the body is empty.  So use
(in csh)

```csh
  ${COMMAND} |& ${MAIL} -e -s "${SUBJECT}" mernst < /tmp/mailbody-$$
```

instead of

```sh
  ${COMMAND} > /tmp/mailbody-$$
  if (!(-z /tmp/mailbody-$$)) ${MAIL} -s "${SUBJECT}" mernst < /tmp/mailbody-$$
  \rm -f /tmp/mailbody-$$
```


Generate a random password:

* CentOS:
   mkpasswd
* Ubuntu:
   echo "$(pwgen -N1)$(pwgen -N1)"


Server-side includes (SSI) for web pages:

```html
  <!--#include file="filename.html"-->
  <!--#include virtual="/directory/included.html" -->
```

Use "file=" for relative filenames, "virtual=" for relative or non-relative
filenames (e.g., an address starting at the server root).
In some cases, you must configure the webserver to preprocess all
pages with a distinctive extension (normally, `.shtml`).
UW CSE lets us tweak our `.htaccess` file such that we can have
all regular .html files get this behavior, not just .shtml files.  See the
WASP webpages for an example.


The `rev` program reverses the order of characters in every line of input.
It's the way to reverse all lines of a file.
To sort lines, with the sort key being the reverse of each line:
  cat myfile | rev | sort -r | rev


`cd -` connects to your previous directory.


The canonical @sys directory for your path is

```sh
  $HOME/bin/`uname`-`uname -m`
```


When a sh/bash script wishes to pass one of its arguments to another
program, it's necessary to quote those arguments so they are not
re-interpreted (and in particular, so that embedded spaces do not cause an
argument to be split into two).  A way to do this is to surround the
argument by spaces, and then call the other program with `eval` instead of
directly:

```sh
  eval other-program "${my_variable}"
```


To determine which version of RedHat/Fedora/CentOS I am running:

```sh
  cat /etc/redhat-release
```


To make the history command show times, do this:

```sh
  export HISTTIMEFORMAT='%Y-%b-%d::%Hh:%Mm:%Ss '
  export HISTTIMEFORMAT='%Hh:%Mm:%Ss '
```

That can be useful for seeing how long a command took to run, if another
command is issued immediately afterward.


In Acrobat (not reader), to fill in a form, either:

* use the typewriter tool, or
* <kbd>ctrl-leftclick</kbd> (this is easier from a unability point of view)


To give up and uninstall a package installed by encap/epkg:

```sh
    cd /uns/encap
    epkg -i $pkg
```


`ack` is like `grep -r` or `search`, but claims to be more flexible.
  I've given up using it, though; I find `search` more featureful and less buggy.
  A problem is that unlike the `search` program, it does not seach in
compressed (.gz, .Z) files.
  You should always run ack with the --text option (put that in an alias or in
.ackrc).  Otherwise, ack discards some text files, since by default, text
files (and also binary and "skipped") are not considered interesting (!),
but everything else is.  Turning on text, turns off every other type, but
the files get searched anyway since they are considered text as well as
their other file type.
  To get a list of files ack is searching (-f means print all files searched):

```sh
  ack -f
```


To perform an advanced search of messages in thunderbird, goto
edit->find->search-messages


Pidgin (previously GAIM) is a Linux IM client that can interoperate with
Google Talk.


An uninterrupted Hudson build has one of the following statuses:

* Failed - it doesn't compile
* Unstable - compiles without errors, but tests fail
* Stable - compiles without errors and all the tests are passing

A manually interrupted Hudson job gives a message like "SCM check out aborted".


To make your slow regular expressions (regexps) faster, restrict the number of
different ways the regexp could match the same text.  For example, if
you're trying to match some whitespace followed by all the text until the
end of the line, don't write this:

```text
 \s-+.*
```

Since the "." can match whitespace too, there are as many different ways
to apportion the match between the two subexpressions "\s-+" and ".*"
as there are whitespace characters.  Instead, write this:

```text
 \s-.*
```

Although this regexp matches exactly the same set of strings, there is
now only one way to match:  the "\\s-" matches the first whitespace
character, and ".*" matches the rest.  This runs faster.


To resolve a symbolic link to its true name (truename):

* in a program, use the `readlink` system call
* from the command line, use `realpath` or `readlink -f` or `readlink -e`
   `readlink` seems to be preferred.

**However**, Mac OS X's `readlink` behaves differently than `readlink` on Linux
(it has no `-f` command-line argument, for example), and `realpath` is not
installed.  Thus, portable scripts should not use them.
If the directory exists (like `readlink -f`), use this instead:

```sh
SCRIPT_DIR="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd -P)"
```

where -P resolves symbolic links.
Common uses for tracing a script (but these do *not* work for a sourced script!):

```sh
echo Entering "$(cd "$(dirname "$0")" && pwd -P)/$(basename "$0")"
echo Exiting "$(cd "$(dirname "$0")" && pwd -P)/$(basename "$0")"
```


On Mac OS X if the directory does not exist, I don't have a good solution.
If the directory ends in ../, you can call dirname twice (and hope that
there is no symbolic link across directories).


If running `dropbox.py start -i` yields

```text
  To link this computer to a dropbox account, visit the following url: ...
```

then run:

```sh
  dropbox.py stop
  dropbox.py start -i
```


To get the current date in a sortable numeric format:

```sh
  date +%Y%m%d
  date +%Y%m%d%H%M
  date +%Y%m%d%H%M%S
  date +%Y%m%d%H%M%S%N
```

To get yesterday's date:

```sh
  date --date yesterday
```

To rename a file to its creation or modification date:

```sh
  mv -f $FILE $FILE-$(date +%Y%m%d -r $FILE)
```


To recover a closed tab in Chrome:  <kbd>Ctrl-Shift-t</kbd>


To open Task Manager in Google Chrome:

* right-click the title bar, or
* press <kbd>Shift-Esc</kbd>

This helps to debug high CPU usage by Chrome.


To replace the dictionary in the Android Kindle app:

* A Spanish-to-Spanish dictionary is already installed with the app
* Adding new dictionaries is finally supported in 2015, but I don't see how to change the default dictionary and it's a pain to always have to click to a new dictionary to see definitions.  So, follow these directions:
   <http://learnoutlive.com/add-german-english-dictionary-android-kindle-app/>
* if you have an Internet connection: <http://ebookfriendly.com/translate-words-in-kindle-app/>


For RBCommons, you can submit a review by either downloading their command-line tools, <http://www.reviewboard.org/downloads/rbtools/>, or by uploading a diff on their webpage.


To compress a JPEG file:

```sh
  convert input.jpg -quality nn output.jpg
```

where nn is between 1 and 100.  1 is the lowest quality (highest
compression).


To convert .svg to vector-format PDF:

```sh
  BASENAME=filename
  rsvg-convert -f pdf -o $BASENAME.pdf $BASENAME.svg
```

But note that Google Slides does not allow import of SVG or PDF files.
To edit a .svg file, use inkscape (or a variety of other tools).
In Inkscape, to resize/crop the canvas to the size of the drawing:

* File >> Document Properties >> Page size >> Custom size >> Resize page to content >> click "Resize Page to drawing or selection" button


Apple Mail, when configured to send mail as "rich text", mangles quoted text.
The quoted text shows up to the recipient colored, but
without a quotation marker such as a vertical bar or ">" in the left column.
This makes the mail very hard for recipients to read.
The solution is to use plain text format.
Choose Mail > Preferences, click Composing, then select "plain text".
This is an issue with Apple Mail on a Mac laptop.
Replies sent from an iPhone look fine, with a quotation marker.


wget is a command-line utility to fetch web pages and save them to the
local disk.  <http://www.gnu.org/software/wget/wget.html>
To download a single file, only if it's newer than the on-disk version:

```sh
  wget -N URL
```

wget is also useful for web site mirroring.
To download everything below a current point:

```sh
  wget -r -k -np URL
```

To get just a single file and its dependencies, converted for local viewing:

```sh
  wget -pk -nH -nd -Pdownload-dir URL
```

Or, an easy way to do the latter is just to view the URL in Firefox, then
choose "save as"!


curl vs wget:

* `wget` is easier to use (better command-line flags, and more needed ones enabled by default), but
   `curl` is more reliable (gives error message instead of hanging) and has more functionality.
* `wget` (by default use same local as remote file name)

   ```sh
   curl -O
   ```

* `wget` (automatically redirect)

   ```sh
   curl -L
   ```

* `wget` (preserve timestamp of remote file)

   ```sh
   curl -R
   ```

* `wget` (automatically retry)

   ```sh
   curl --retry 2
   ```

* `wget -nv` (non-verbose output)

   ```sh
   curl -s -S
   ```

* `wget -O local-filename` (specify a local filename)

   ```sh
   curl -o local-filename
   ```

* `wget -N` (only download if newer)

   ```sh
   curl -L -R -o "$file" -z "$file" "$serverurl"
   ```


To restrict ripgrep to searching only files with given names:

```sh
rg --iglob ControlFlowGraph.java "void checkRep"
```


If ripgrep matches files within the `.git` directory, then add this to the `.gitignore` file:

```gitignore
\# rg needs this:  https://github.com/BurntSushi/ripgrep/issues/1040
.git/
```


Chromebook:

* the `terminal` application runs Linux


To increase font size in an xterm terminal on Ubuntu Linux:
<kbd>Ctrl-rightmouse</kbd>.


Use middle button to paste into an xterm.


For my slide titles in LibreOffice Impress, I like color #674EA7.  I think this is a default purple in PowerPoint, but LibreOffice does not have an equally nice purple in its standard color set.


A replacement for the lines-between program is:

```sh
sed -e '1,/abc/d' -e '/mno/,$d' <FILE>
```


A shell function that works around `wget` or `curl` hanging for very slow
connections.  (`curl`'s timeouts don't seem to work in this case.)
curl's `-z` option requires that the file exists.

```sh
# Download the remote resource to a local file of the same name, if the
# remote resource is newer.  Works around connections that hang.  Takes a
# single command-line argument, a URL.
download_url() {
    if [ "$(uname)" = "Darwin" ] ; then
        wget -nv -N "$@"
    else
 BASENAME=`basename ${@: -1}`
 if [ -f $FILE ]; then
     ZBASENAME="-z $BASENAME"
 else
     ZBASENAME=""
 fi
 timeout 300 curl -s -S -R -L -O "$ZBASENAME" "$@" || (echo "retrying curl $@" && rm -f "$BASENAME" && curl -R -L -O "$@")
    fi
}
```


Three ways to retry a command repeatedly a limited number of times, with a delay between:
(This retries the command if it fails, until it succeeds or the retry limit is reached.)

* timeout 300 COMMAND || COMMAND
* <https://github.com/kadwanev/retry>
* parallel --retries 5 --delay 15s ::: ./do_thing.sh


To use GraphViz to convert a .dot file to a .pdf file:

```sh
dot -T pdf -O filename.dot
```


To find all files that contain one string (stringA) but not another (stringB):

```sh
grep -L stringB $(grep -l stringA FILENAMES)
```

In all files in the directory or subdirectories:

```sh
grep -L stringB $(grep -l -R stringA .)
```


Screen recording:

* kazam always gives me a black screen
* recordmydesktop: creates .ogv files that fail in subsequent conversion with "Broken file, keyframe not correctly marked.".

```sh
recordmydesktop --fps 15 --delay 10 -o myfile.ogv
```

* simplescreenrecorder: I haven't tried it yet.
  To install: `sudo apt install simplescreenrecorder`


Printing all lines after a match in sed:

```sh
sed -ne '/pattern/,$ p'
```

This is similar to my old `lines-after` script.


To uncolorize a file:

```sh
sed -i.bak -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g"
```


To find duplicated/repeated/doubled words:

```sh
rg '\bthe the\b|\band and\b|\bor or\b|\ba a\b|\bto to\b|\bit it\b|@return return\b|\bis is\b|\bare are\b|\bif if\b|\bto to\b|\bas as\b|\bof of\b'
search -n '\b([A-Za-z]+)[ \t]+\1\b'
```


Here is my program for handling multiple repositories, in case you want to try it:
Homepage: <https://github.com/plume-lib/multi-version-control>
Documentation: <https://plumelib.org/multi-version-control/api/org/plumelib/multiversioncontrol/MultiVersionControl.html>
From my dotfiles:
alias mvc='java -ea -cp ${HOME}/java/plume-lib/multi-version-control/build/libs/multi-version-control-all.jar org.plumelib.multiversioncontrol.MultiVersionControl'


As of Dec 2022, the checkstyle Gradle plugin does not support specifying a
suppression filter, as the Maven plugin does with `<SuppressionFilter>`.


Here is how to apply the Google Style with the checkstyle linter, in a Gradle
`build.gradle` file, without downloading the `google_checks.xml` file.
Unfortunately, the checkstyle Gradle plugin does not support a way to
suppress/disable some rules, so it rejects any program that uses the Options
package.

```gradle
/// Checkstyle linter
// Run by `gradle check`, which is run by `gradle build`
apply plugin: 'checkstyle'
ext.checkstyleVersion = '10.5.0'
configurations {
  checkstyleConfig
}
dependencies {
  checkstyleConfig("com.puppycrawl.tools:checkstyle:${checkstyleVersion}") { transitive = false }
}
checkstyle {
  toolVersion "${checkstyleVersion}"
  config = resources.text.fromArchiveEntry(configurations.checkstyleConfig, 'google_checks.xml')
  ignoreFailures = false
}
```


To pretty-print (reformat) a JSON file, either of these commands:

```sh
# outputs to standard out; also works on `.jsonl` files
jq . FILENAME
# reformats file in place; also works on `.jsonl` files ; order of operations retains original file's metadata
json-pp () {
  cp   "$1"      "$1".tmp && \
  jq . "$1".tmp >"$1"     && \
  rm   "$1".tmp
}
json-pp FILENAME
json-compact () {
  cp     "$1"      "$1".tmp && \
  jq -c . "$1".tmp >"$1"     && \
  rm     "$1".tmp
}
json-compact FILENAME
# reformats file in place; also works on `.jsonl` files ; data loss if jq fails
JQFILE="myfilename" && jq . "${FILENAME}" | sponge "${FILENAME}"
# not sure where output goes; does not work on `.jsonl` files
python -m json.tool FILENAME
```


An example scp invocation:

```sh
scp mernst@godwit.cs.washington.edu:sync/gradle-assemble-output-xps8940.txt ~/tmp/
```


To update all snaps (all snap packages) on an Ubuntu system:

```sh
sudo snap update
```


To resolve Ubuntu popup
"please update the application snap-store"
or
"Pending Update of Snap-Store, Close the App to Avoid Disruption"
do one of these:

```sh
sudo snap-store --quit && sudo snap refresh
sudo killall snap-store && sudo snap refresh
```


To output Google Slides *without* "skipped" slides:

* Click File in the Google Slides interface.
* Go to Print preview.
* Deselect Include skipped slides.
* Click Download as PDF.


`lsof` lists open files.  If you run

```sh
lsof | grep deleted | grep ' /tmp'
```

then you will see deleted files that are kept open by (possibly zombie) processes.
This can help in reclaiming space from a full partition, where you cannot figure out which files are making it full.


File `~/.cups/lpoptions` sets a default printer for `lpr`, `lpq`, etc.


The `bear` program is for clang what do-like-javac is for Java.


A better way to do `lsb_release -si` or `lsb_release -sr` is:

```sh
sed -n -e 's/^ID="\(.*\)"/\1/p' /etc/os-release)
sed -n -e 's/^VERSION_ID="\(.*\)"/\1/p' /etc/os-release)
```


To find all files not containing a string: `-L foo`.
This works with `grep` and `ag`, etc.
For `rg`: `--files-without-matches`


To turn off screensavers in Gnome:

1. Click on the little foot in the lower left
   Programs->Settings->Desktop->Screensaver
2. Select 'No Screensaver' in the list in the upper left
3. Click 'OK'


<!--
// Please put new content in the appropriate section above, don't just
// dump it all here at the end of the file.
-->
