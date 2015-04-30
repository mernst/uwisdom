This file is a bit of a catch-all, for everything that does not have a
dedicated page.


Contents:




---

# Kerberos #


For jobs running longer than 8 days that need Kerberos tickets, see
> /afs/csail/group/lis/bin/lislongjob
Also see "longsession" command.
Finally, see the "longjob" command.  The syntax for this one is
```
  longjob <your job>
```
longjob -h shows other options.

To renew a Kerberos ticket (without having to type a password):
```
  kinit -R
```
To see the result:
```
  klist
```
On AFS, the appropriate commands are:
```
  renew -r 8d
  authloop &
```
To run a detached long job, you can do
```
  authloop &
  <your job>
```
but "longjob" may be more convenient.

kpasswd:  change Kerberos password
(I may need to do `kinit` before `kpasswd`.)

Cross-realm Kerberos authentication:
To get athena tickets:
> setenv KRB5CCNAME /tmp/krb5cc_$$.athena
> kinit -5 $USER@ATHENA.MIT.EDU
> aklog -cell athena
To get CSAIL tickets:
> setenv KRB5CCNAME /tmp/krb5cc_$$.csail
> kinit -5 $USER@CSAIL.MIT.EDU
> aklog -cell csail.mit.edu
To get UW CSE tickets:
> setenv KRB5CCNAME /tmp/krb5cc_$$.uwcse
> kinit -5 $USER@CS.WASHINGTON.EDU
Also see:  http://tig.csail.mit.edu/twiki/bin/view/TIG/CrossCellHowto
Also see:  ~mernst/bin/share/csail-athena-tickets.bash_



---

# AFS #

To modify AFS directory/file permissions/acls/access control lists, see
  * http://www-2.cs.cmu.edu/~help/afs/afs_quickref.html
  * http://openafs.org/
  * http://web.mit.edu/answers/unix/unix_chmod.html
To view permissions:
```
  fs listacl directory
```
To set permissions:
```
  fs setacl directory [id rights]*
```
where id is a user or "system:groupname".
To make a directory world-readable:
```
  fs sa directory system:anyuser rl
```
To make a directory and all subdirectories world-readable:
```
  find . -type d -exec fs sa {} system:anyuser rl \;
  find . -type d -exec fs sa {} mernst.cron rlidw \;
```

Seven rights/permissions are predefined by AFS: four control access to
a directory and three to all of the files in a directory.
The four directory rights are:
  * lookup (l) -- list the contents of a directory
  * insert (i) -- add files or subdirectories to a directory
  * delete (d) -- delete entries from a directory
  * administer (a) -- modify the ACL
The three rights that affect all of the files in a directory are:
  * read (r) -- read file content and query file status
  * write (w) -- write file content and change the Unix permission modes
  * lock (k) -- use full-file advisory locks
The following are shortcuts:
  * all : gives all rights - rlidwka
  * write : gives rlidwk rights
  * read : gives rl rights
  * none : removes all rights

In AFS, (only) the user mode bits of regular files retain their function;
they are applied to anyone who can access the file.

AFS groups:
On Athena, don't use these commands.
> Instead, use blanche, listmaint, or http://web.mit.edu/moira.
Add a user to an AFS group:
```
  pts adduser USERNAME GROUPNAME
```
List users in a group, or groups a user belongs to
```
  pts mem GROUPNAME
  pts mem USER
```
Create a group:
```
  pts creategroup GROUPNAME
  pts creategroup pag-admin:daikondevelopers -owner pag-admin
```
(If you belong to a group, you can add members if its fourth privacy flag
is the lowercase letter a.)

To determine how much AFS (e.g., Athena) quota is available/free and used
(i.e., to determine disk space usage), do
fs lq /mit/6.170

The command
```
  zgrep 'Lost contact' /var/log/messages*
```
on a CSAIL Debian box will show you all the times in the last month that
your machine noticed the AFS servers being down.

To test AFS latency performance (when the file system is sluggish), run
(bash syntax):
```
  for i in `seq 1 10`; do /usr/bin/time -f "%E" mkdir foo; rmdir foo; done
```
(To test AFS bandwidth, use pv to copy a large file; but we've never seen
such problems.)



---

# Shells #

Redirecting output in command shells:
  * In csh/tcsh:
    * To overwrite an existing file, redirect via ">!" instead of ">".
    * To redirect both standard error and standard output to a file,
> > > use ">&" (">" redirects just standard output to the file).
    * To redirect standard error and output through the pipe, use "|&".
  * In sh/bash:
    * To redirect standard error to standard output, use "2>&1".
> > > Warning:  this must come after any file redirection:  "cmd > file 2>&1".
> > > This is because "2>&1" means to make stderr a copy of stdout.  If you
> > > redirect to a file with "> file" after doing so, then stdout is
> > > reopened as the file, but stderr (a copy of the original stdout) is
> > > not affected.
    * To send both standard error and standard output through a pipe: "2>&1 |".
> > > There are simpler commands in bash, but they don't work in sh.
    * To redirect standard error to a file, use "2>filename".
> > > For more details, see http://tomecat.com/jeffy/tttt/shredir.html

In csh shell scripts, $**means all the arguments.
In bash shell scripts, "$@" is preferred, because it quotes each argument
individually before concatenating them (separated by spaces).
In bash, to do an extra level of shell expansion on "FOO", use "eval echo FOO".**

In bash, interactive shells call .bashrc; noninteractive shells call
.bash\_profile.

In tcsh, a for loop looks like
```
  foreach var (a b c d)
    use $var
  end
```
In bash, a for loop looks like
```
  for name [ in word ] ; do list ; done
```

In bash, the exit status ("exit code") of a command is stored in variable "$?".
In csh, it is stored in variable "$status".
Zero means success, non-zero means failure.

Command substitution, performed by a subshell, in csh/bash:
enclose in backquotes/backticks (`...`).
In sh, it's better style to use $(...) than `...`, but both have the same effect.

The bash, of csh's "rehash" command is "hash -r".

When debugging a bash script, it can be helpful to turn on Bash's strict
error handling and debug options (exit on error, unset variable detection
and execution tracing) to make sure problems are caught early:
  1. /bin/bash

> set -o errexit -o nounset -o xtace
> ...

To get bash 3.0 to fail if any command in a pipeline fails, do
```
  set -o pipefail
```
or launch bash with
```
  bash -o pipefail
```
To give make this semantics, put the following in the Makefile:
```
  export SHELL=/bin/bash -o pipefail
```
Alternatives, if stuck with bash 2.x:
> ${PIPESTATUS[n](n.md)} where n=0 is the status from the first command in the pipe,
The exact syntax for a Makefile is:
```
  foo | bar | baz && exit $${PIPESTATUS[0]}
```
or the following simple bash script that preserves exit status
```
  export result=$?
  cat | $*
  exit $result
```

The program "timeout" seems to subsume exec\_cpu\_limited (and perhaps
more).
The shell builtin "ulimit" can be used to limit a processes stack size, CPU
time, virtual memory, etc.

In general, a bash script should contain this at the top:
```
  set -o errexit -o nounset -o xtrace
```

To get a shell in which none of your personal customizations (environment
variables) are set, do:
```
  exec -c bash --noprofile --norc
```
(There is not a way to do this directly via ssh, which always reads your
.bashrc file.)
A problem is that with DISPLAY not set, X program such as xterm do not
work.
I tried
```
   echo $DISPLAY > ~/tmp/display
   xauth list > ~/tmp/xauth-list
   exec -c bash --noprofile --norc
   export DISPLAY=`cat ~/tmp/display`
   xauth -f ~/.Xauthority-2 add [relevant a line from ~/tmp/xauth-list]
```
but this did not work; I still got
```
  X11 connection rejected because of wrong authentication.
```

To create a shell with no environment variables set:
```
 /usr/bin/bash --noprofile --norc
```



---

# ssh (secure shell) #

To use ssh (and other tools like CVS, SVN, git, Hg, ...) with RSA public keys,
do this at the beginning of each development session (say, immediately
after logging in):
```
  ssh-agent bash
  ssh-add
```
or, alternately:
```
  eval `ssh-agent`
  ssh-add
```
To run an entire X-session underneath ssh-agent:
  1. move .xinitrc file (other X client startup script) to .xinitrc-real.
  1. add the command "ssh-add" to the beginning of that script.
  1. create a new .xinitrc script containing the sole command:
> > exec ssh-agent $HOME/.xinitrc-real

To set up public keys for ssh-agent and similar programs:
  1. On client machine (from which I will login), do `ssh-keygen`
  1. Append client's `~/.ssh/id_rsa.pub` (or `identity.pub`, etc.) to server's `~/.ssh/authorized_keys` (and maybe `~/.ssh/authorized_keys2`, if you are using ssh2)
ssh2 needs file ~/.ssh/authorized\_keys2; to make it, do
```
  cd ~/.ssh; cat is_dsa.pub > authorized_keys2; chmod 600 authorized_keys2
```
The `authorized_keys*` files must not be group-writeable; do this:
```
  chmod 600 ~/.ssh/authorized_keys
  chmod 600 ~/.ssh/authorized_keys2
```

ssh: secure remote login.  Need to copy contents of identify.pub on client
machine into authorized\_keys on server machine.

ssh2 supports sftp, an ftp client.  It does not seem to be free for
research use.  OpenSSH doesn not seem to have sftp.



---

# Perl #

Perl5:
  * arguments are in `@_`, that is `$_[0]`, `$_[1]`, etc.
  * "local" gives dynamic scoping; "my" gives static scoping.  But "local" does not seem to work for imported variables (declared via @EXPORT in a module).
  * Forward jumps screw up containing for loops, it seems.
  * foreach implicitly localizes the argument inside the for body.
  * `wantarray` (no parens) returns true if current sub called in list context
Regexps:
  * To match end of line without newline, `\Z(?!\n)`.
  * Add `?` after a repetition operator to render it stingy instead of greedy: `foo(.*?)bar`
  * To quote regexp metacharacters, use `\Q...\E` or `quotemeta()`.
  * `(?:REGEXP)` is like `(REGEXP)` but doesn't make backreferences.
Data structures:
```
  @foo[$bar] => my @foo; returns one-element slice of foo = ($foo[$bar])
  @{$foo[$bar]} => my @foo = list of references to arrays; @{...} converts
    such a reference into the referred-to array
  @{$foo}[$bar] => foo = reference to array; take that array's bar'th element
```
Don't assign result from splice; use `splice(@foo, $i, 0)`, not `@foo = splice(...)`

Perl to consider:
```
 @_ => @ARG; $_ => $ARG
 Packages: class::template, alias
 -d:DProf flag to profile
 -I to add include path (do this as an alias??)
 -u  (faster startup; why?)
 Compiler: do  "perl -MO=C foo.pl > foo.c"
```

Perl 5 uses $PERLLIB environment variable as include path for libraries

In awk, perl, and C, output format "%2.1f" rounds, does not truncate.

Perl regular expression to match a string: /"([^"\\]|\\[\000-\377])**"/**

In Perl, to read (slurp) a whole file into a string, do
```
          undef $/;
          $_ = <FH>;              # whole file now here
```
To read an entire file in perl:
```
open(FILE, "data.txt") or die("Unable to open file");
@data = <FILE>;
close(FILE);
```

To run Perl interactively, invoke the Perl debugger on an empty program:
```
   perl -de 42
```

In Perl, to count the number of newlines (or any other character) in a
string, use tr/\n// (or tr/\n/\n/).

To make a script use perl without specifying an explicit #!path, adjust the
"-n" flag as appropriate, then put this at the top instead of #!/usr/bin/perl:
```
#!/usr/bin/env perl
```
or, alternately:
```
: # Use -*- Perl -*- without knowing its path
  eval 'exec perl -S -w -n $0 "$@"'
  if 0;
```
Using #!/usr/bin/perl is faster but requires knowing perl's path.

To install/build a perl module, do the following as root:
```
  perl -MCPAN -e shell
  install MIME::Base64
```
For more details, see ~mernst/wisdom/build/build-perl-module

In Perl, to determine whether file named $foo exists, use "if (-e $foo) ...".

Perl scripts should start this way, for portability and error checking:
```
#!/usr/bin/env perl
use strict;
use English;
$WARNING = 1;
```

In perl:
  * To read a whole file:  $/ = undef.
  * To read by paragraphs:  $/ = "\n\n".
  * To read by paragraphs, eliminating empty paragraphs: $/ = "".
  * $/ is also known as $RS or $INPUT\_RECORD\_SEPARATOR.

In perl, to properly open a file, check like this:
```
  open(FILE, $filename) or die "Can't open '$filename': $!";
```

In Perl, Date::Manip seems a touch nicer than Date::Calc.
(There's also Date::Format and Date::Parse, but Date::Manip does it all.)

In perl, write
```
  use filetest 'access';  # for AFS
```
to make the file access test operators (-r, -w, etc) work better for AFS.

To disable Perl's "deep recursion" warnings (they're not errors), use
```
  no warnings 'recursion';
```

In Perl, here is a way to extract the unique elements from a list.
```
  # Return the argument list with duplicates removed (eliminated).
  sub uniq () {
    my @uniq = ();
    my %seen = ();
    foreach my $item (@_) {
      push(@uniq, $item) unless $seen{$item}++;
    }
    return @uniq;
  }
```

Perl trick:
```
use FindBin ();
use lib "$FindBin::Bin";
```



---

# PostScript and PDF #

To convert a text file to PostScript or PDF, here are possibilities.
Reasonable choices:
  * paps: is packaged for Unix distributions (Ubuntu, Red Hat), so perhaps
> > it is widely used, even though the last release was in 2007
  * cedilla: works fine, many cammand-line arguments.  A bit of a pain to
> > install because you have to install clisp first.
Poor choices, if you are concerned about UTF-8 (non-ASCII characters):
  * enscript: doesn't handle 8-bit by default
  * a2ps: doesn't handle 8-bit by default
  * mpage: doesn't handle 8-bit by default
  * u2ps: Internet chatter says it is not as good as paps?
  * h2ps and bg5ps: intended specifically for Asian fonts
Enscript is a standby, since it has so many options and is widely
installed, but it doesn't handle UTF-8.

If you care about UTF-8, use cedilla or paps.
Otherwise, to convert a text file to PostScript (86 characters per line):
```
  enscript -pout.ps in.txt
  enscript -o OUTFILE.ps -f Courier8 INFILE        # 105 columns
  enscript -o OUTFILE.ps -f Courier7 -r INFILE     # 132 columns, landscape
```
Can add "-H 2" for highlight bars (good for tabular data).
The equivalent a2ps line is:
```
  a2ps -r -f 7 -E --highlight-level=normal --columns=1 -o OUTFILE.ps INFILE
```
or, with syntax highlighting (why no -E argument?):
```
  a2ps -r -f 7 --columns=1 -o OUTFILE.ps INFILE
```
To print on Lexmark Z52, which cannot image the top .5 inches of a sheet,
for twoup output use
```
  enscript --margins=:::36 -2r
```
enscript common options:
  * -h: no burst/header page
  * -B: no page headings

To convert a PostScript file for A4 paper for printing on letter
size paper (that is, to shift the text down on the page), use
```
   pstops -pletter '0(0,-.75in)' a4file.ps letterfile.ps
```
Alternately, convert to PDF and then back to PostScript, using ps2pdf and
pdf2ps.  Or use pdftops, which seems nicer than pdf2ps.
(By default, dvips creates PostScript for A4 paper.  Some people forget to
fix this when they install dvips.  See file ~mernst/wisdom/build/build-dvips)
To create Encapsulated PostScript, can also run
```
  pdftops -eps
```

To rotate a PostScript document (landscape to portrait to seascape), use
the "L" or "R" or "U" modifiers.  For instance:
```
  pstops -pletter '0L(8.5in,0)' orig.ps rotated-counterclockwise.ps
```

Two sets of tools for transforming PDF files are pdftk and PDFjam.
  * pdftk is a single program with many command-line options.  Installed on Ubuntu.
  * PDFjam is a single program, along with 10 wrappers, each with a single purpose (e.g., pdf90 to rotate by 90 degrees).  Installed on Red Hat and Fedora.
Separate/split a file into individual pages:
```
  pdftk infile.pdf burst
```
Select pages from a file:
```
  pdftk infile.pdf cat 2-3 output outfile.pdf
  pdftk infile.pdf cat 3-end output outfile.pdf
  pdfjam -o outfile.pdf infile.pdf 2-3
  pdfjam -o outfile.pdf infile.pdf 3-
```
To concatenate PDF files:
```
  pdftk ${ALL_PDFS} cat output singlefile.pdf 
  pdfjoin --output singlefile.pdf ${ALL_PDFS}
```

Use psnup to place multiple logical pages of a PostScript document on a single
physical page (say, to print two-up), try psnup.
Other options are psmulti and
mpage (but mpage doesn't deal well with graphics or encapsulated PostScript).
Sample use (-d adds lines between logical pages):
```
  psnup -4 -d file.ps file-4up.ps
  psnup -2 -d file.ps file-2up.ps
  psnup -4 -l -d file.ps file-4up.ps    # landscape (e.g., slides)
```
One can also use pdfnup:
```
  pdfnup --nup 2x1 file.pdf
  pdfnup --frame true --nup 2x2 file.pdf    # 4-up slides
  pdfnup --frame true --nup 2x3 file.pdf    6-up slides
```
pdfnup is part of PDFjam.  Also see pdftk, an alternative to PDFjam.
<a href='Hidden comment: 
% Sample use of mpage (-o suppresses lines between pages):
% {{{
%   mpage -2 file.ps > file-2up.ps
% }}}
% but don"t use it; psnup seems better.
% mpage remains in the paragraph above because I too often search on it when I
% can"t remember the name of psnup.
'></a>

To compute a correct bounding box for an Encapsulated PostScript file:
```
  epstool --copy --bbox bad.eps --output good.eps
```
This replaces the obsolete bbfig program.

To compute a correct MediaBox and/or CropBox (the PDF equivalents of a
bounding box):
```
  FILE=myfilename
  pdftops -eps ${FILE}.pdf
  epstool --copy --bbox ${FILE}.eps --output ${FILE}-cropped.eps
  epstopdf ${FILE}-cropped.eps  
```
(One culprit is Visio 2010, saving the selection as PDF (the selection is under "page
range" choices, only after you have selected PDF) still gives a page-size
PDF file, and "save as EPS" is no longer supported.  I cropped it by hand
in Acrobat Professional.  Or, do this:
  * save as PDF
  * pdftops -eps file.pdf
  * bbfig -o file.eps | gv -
> > and add the %%BoundingBox line to the header of the ps file.


<a href='Hidden comment: 
% bbfig computes the bounding boxes of PostScript figures.
% See the bbfig man page for more details.
% To avoid wasting paper and time going to the printer, use
% {{{
%   bbfig -o file.ps | gv -
% }}}
'></a>

ghostview:  view PostScript on an X windows display.

Conversions between PostScript and PDF:
  * PS -> PDF:
```
   distill foo.ps   (for an entire directory, "distill -files .ps")
   ps2pdf foo.ps
```
  * PDF -> PS:
> > Avoid these acroread invocations; pdftops seems better.
```
   acroread -toPostScript file.pdf
   cat sample.pdf | acroread -toPostScript > sample.ps
   acroread -toPostScript sample1.pdf sample2.pdf <dir>
   acroread -toPostScript -pairs pdf_file_1 ps_file_1 ...
   acroread -toPostScript -level2 pdf_file_1
```
When using acroread to manually do the conversion, selecting the option
"Download Fonts Once" in the Print menu may cause math fonts to be messed
up; in case of that trouble, deselect this option.

If you are having trouble printing from Acrobat Reader (such as mising
characters on some pages):
  * Printer Properties >> Advanced >> Postscript Options >> PS Output : Optimize for Portability

If ghostview can't view a document correctly, then perhaps the PostScript
file starts with something like
```
  %!PS-Adobe-2.0 EPSF-1.2
```
but does not conform to ADSC (Adobe document structuring conventions).
Try changing the first line to
```
  %!PS
```
and the ghostview will turn off looking for ADSC comments.
Or, use gs (ghostscript), which gives a plain X window, no ghostview buttons.

To convert an Excel PostScript file into Encapsulated PostScript (for
inclusion in a LaTeX document, for instance), use Greg Badros's
excel-ps-to-eps program.  (First remove the leading/trailing HPLJ
notations, and be sure there are no ^M characters in the file.)
```
  excel-ps-to-eps graph1.ps graph2.ps
```
It may produce lots of spurious warning messages but creates a valid .eps file.
[used to only work on Linux, with ~gjb/bin/{share,linux} in your path.](This.md)
Another problem is that the PostScript's clipping region won't be set; this
draws a (too) big white box.  To fix that, in LaTeX2e, use
```
    \epsfig{file=foo.eps,clip=}
```
(note that there is nothing after the "clip=").
Alternately, Jeremy Buhler says:
GhostScript (GS) 6.0 includes a ps2ps script that can munge printed output from
Excel well enough to turn it into an eps file with ps2epsi and
put it in a LaTeX document.
Alternately, Mike Perkowitz says:
  1. print chart to a postscript file in excel.

> 2. edit the postscript:
> > - the file is full of little blocks that are, i assume, the PC representation
> > > of unix linefeeds or crs or whatever. (if you're editing on PC)

> > - remove everything before "%!PS-Adobe-3.0" at the beginning
> > - remove everything after "end" at the end
> > - at the beginning remove all "%%BeginFeature" through "%%EndFeature"
> > > things

> > - my file, at the end, after showpage, had a line "Page SV restore" which
> > > seemed to cause a gratuitous page advance. i removed it

> 3. rotate the document properly.
> > on june: "psfix -r 270 file.ps > file-r.ps"
> > or just remove the **whole** line that contains the word "rotate"

> 4. convert to EPS. on june: "ps2epsi file-r.ps file-r.eps"
> 5. "\input epsf" in your paper, and include the figure with "\epsfig{file=file-r.eps}"
Note that the ghostscript viewer on the PCs can also convert from PS to EPS,
but i had trouble getting it to rotate and save that rotation. and if you do
psfix after the EPS conversion, i think your bounding box gets made full page
size again or something.

To print the word DRAFT diagonally on every page of a PostScript document,
insert this at the second line of a postscript file (immediately after the
"%!PS" line):
```
   << /BeginPage { pop gsave /Helvetica-Bold 200 selectfont 0.9 setgray
   306 396 translate 60 rotate 0 -100 moveto (DRAFT) dup stringwidth pop
   2 div neg 0 rmoveto show grestore } >> setpagedevice
```
It assumes letter-size paper.
Or, if you're using LaTeX2e, use the draftcopy package.

Converting PostScript to text (ASCII), and other PostScript FAQs:
http://www.geocities.com/SiliconValley/5682/postscript.html
Just using gs (ghostscript; see "ps2ascii" alias) works better than the pstotext program.

To add page numbers to a PostScript document (does not work for PDF):  pspage

PrimoPDF.com is a free PDF converter for most Windows applications.

sam2p: convert raster (bitmap) image formats into Adobe PostScript or PDF.

To turn off screensavers in Gnome:
  1. Click on the little foot in the lower left
> > Programs->Settings->Desktop->Screensaver
  1. Select 'No Screensaver' in the list in the upper left
  1. Click 'OK'

Do
```
  xmodmap -e 'add mod1 = Alt_R'
```
to work around this bug with right Meta (Alt) Tab not working:

> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=258003
It's supposed to be fixed now.

To convert a paper formatted for LNCS into two-column, use
```
  lncs2up file.ps
```

To convert a Microsoft Word .doc file to PDF:
  * open it in OpenOffice and export as PDF
  * wvPDF file.doc file.pdf
Neither technique dominates the other, and each is sometimes bad

To annotate a PDF document:
  * pdfedit corrupted my document.
  * I couldn't get Sun PDF Importer (SPI, part of OpenOffice) to work

To convert PDF to text (txt) format, use the pdftotext program, which is
part of the xpdf package.

To compress a PDF file:
```
  gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dNOPAUSE -dQUIET -dBATCH -sOutputFile=output.pdf input.pdf
```

To convert a 1-page PDF to good-quality .gif:
```
  convert -density 300 -quality 100 file.pdf file.gif
```

To create a multi-page set of tiles that can be tiled together to make a poster:
```
  pdftops madrid-transport-center-2009.pdf
  poster -v -mA4 -s1.3 madrid-transport-center-2009.ps > madrid-transport-center-2009-tiled-scaled1.3.ps
  ps2pdf madrid-transport-center-2009-tiled-scaled1.3.ps
```
(I wasn't able to get the pdfposter program to work, so I converted to
PostScript and used poster instead.)



---

# X Windows #

X Windows initialization depends on .Xdefaults and .xsession files, among others.
(.Xdefaults, aka .Xresources, is used by xrdb.)

xmodmap:  modify keymaps in X

xlock:  screen-locking + screen-saving program

xterm windows:  use control + mouse to get VT/VT100 menus.

X fonts are in /usr/local/lib/X11/fonts, aka /usr/lib/X11/fonts, among
other places; xlsfonts lists all available X fonts.

Linux:
```
  M-C-F7 = return to X session after accidentally hitting M-C-F[26] or some such
  M-C-F2 = tty mode (also M-C-F1)
  M-C-n,p,? = change terminal mode (??)
  M-C-backspace: reset X server
  F1 instead of enter = safe login
```

editres lets you inspect and modify X application resources.

xwininfo: gives information about an X Window (eg size, location, etc.)

xev: x event tester (report to stdout all X events sent to it)

Ctrl-Alt-"+" and Ctrl-Alt-"-" switch between resolutions on debian;
and see /etc/X11/XF86Config.  Or run "anXious" to reset X configuration
parameters.
Ctrl-Alt-Backspace kills the X server.
To turn that off, in /etc/X11/XF86Config-4 (or /etc/X11/xorg.conf) add to "ServerLayout":
> Option "DontZap"  "true"
(Also do "man XF86Config")

LeftAlt-Fn switches to a new "virtual console", where "Fn" is F1 for the
main one, F3 for the third one, etc.

/usr/lib/X11/ is directory with rgb.txt, which is names of X11 colors.

Sawfish window manager themes (list of problems with them)
  * brushed-metal
> > slightly goofly looking window title bar
  * CoolClean
> > window title bar has gradient
  * mono
> > default blue focused window color is unreadable, can't drag border to resize
  * simple
> > can't drag border to resize
> > doesn't have all the standard buttons at the top of the window

"xlock -mode blank" locks the screen without running a compute-intensive
screensaver.

gnomecc:  adjust properties of window manager
Especially:
  * Sawfish window manager >> Matched Windows
  * Sawfish window manager >> Shortcuts
  * Sawfish window manager >> Meta >> Advanced
(But I think I now use metacity under Gnome.)

Debian Linux screen resolution:
Applications >> Desktop Preferences >> Screen Resolution



---

# WWW and HTML #

To make a webpage automatically forward/redirect, see

> http://www.cs.washington.edu/info/faq/homefaq.html#else
More simply, do:
```
  <meta http-equiv="Refresh" content="1;URL=http://www.mit.edu/~6.170" />
```
This belongs in the `<head>` section, along with `<title>`.

To restart the httpd server:
```
  /etc/rc.d/init.d/httpd restart
```
or else
```
  /etc/rc.d/init.d/httpd stop
  /etc/rc.d/init.d/httpd start
```
Another possible problem that could lead to failure to server webpages is
that I failed to start Guidescope; do "myxapps".

To allow use of "order", "allow", and "deny" in .htaccess, I had to add the
following to /etc/httpd/conf/httpd.conf:
```
  # To allow use of "order", "allow", and "deny" in .htaccess.
  <Directory /home/httpd/html/pag/daikon>
    AllowOverride limit
  </Directory>
  <Directory /home/httpd/html/pag/pag>
    AllowOverride limit
  </Directory>
```
(Then I stopped and restarted the http server.)

HTML checking:
  * htmlchek is quite picky (not necessarily a problem) and hasn't been
> > updated since February 20, 1995
  * NetMechanic seems reasonable.  http://www.netmechanic.com/html_check.htm
> > Can check both HTML and links (the latter very slow).  Only checks 5 pages.
  * weblint is basic but functional:  http://www.weblint.org
  * Try W3C HTML Validation Service, http://validator.w3.org/

"flatten" program converts hierarchies of WWW (World Wide Web) pages into a
single page, for easier browsing.  The pages are concatenated in
depth-first order.

In HTML and CSS, to set font color and style, one can do
```
  <span style="color:red">
  <p style="color:red">
```
```
  <style>
  .done {
    text-decoration: line-through;
  }
  </style>
  <li class=done>Recitation 3</li>
```
```
  .accesskey {
     text-decoration: underline;
     font-weight: bold;
  }
  <span class="accesskey">x</span>
```
```
  ..uline { text-decoration: underline; }
  ... <span class="uline">"Deliver Us from Evil</span> ...
```
```
  <div style="width: 100px;
    height: 100px;
    background-color: green;
    margin: auto">
  Centered Green Box
  </div>
```

For horizontal and vertical alignment in HTML:
```
    <img src="version-control-fig1.png" alt="Basic version control" style="float:right" />
    <img src="version-control-fig2.png" alt="Centralized version control" style="vertical-align:middle" />
```

HTML em dash: &mdash; or &#8212;
HTML en dash: &ndash; or &#8211;

To use the html-update-toc script to maintain a table of contents in a
webpage, insert the following near the top of the file:
```
<p>Contents:</p>
<!-- start toc.  do not edit; run html-update-toc instead -->
<!-- end toc -->
```
Also consider running, in Emacs, M-x html-add-heading-anchors .

The checklink program (from W3C) tells about broken links in HTML documents.
Run like this:

> checklink -q -r http://pag.lcs.mit.edu/~mernst
(Linkchecker (from http://linkchecker.sourceforge.net/?) seems to spawn
lots of threads and never return.)
Probably best to run these in the background with output sent to a file.
"tidy" cleans/formats HTML (and does error checking); but not so good on
HTML that's already decent, it seems.

/uns/share/bin/wwwis is a Perl script which adds image size tags to
HTML documents.  It's a nifty way to speed page rendering and avoid
ugly incremental reflows.

To convert HTML to a printable form (PostScript):
I sometimes have trouble with html2ps, and find that htmldoc is better:
```
  htmldoc --webpage -t ps --outfile FILE.ps FILE.html
```
html2ps converts a HTML file to PostScript, potentially recursively.
```
  html2ps -n -u -C bh -W bp http://pag.csail.mit.edu/daikon/ > index.ps
```
  * "-n" means number pages
  * "-u" means underline links
  * "-C bh" means generate a table of contents.
  * "-W bp" means process recursively retrieving hyperlinked documents ("p"
> > means prompt for remote documents).  Watch out:  using -W b might seem
> > reasonable, but it will try to print some binary files!
  * "-2L" means two-column landscape
[is the program that Jeff Perkins recommended as well.](This.md)

Apache 1.3.33 recognizes only the last "Options" directive, it seems.
So put all the arguments in one directive:
```
  Options Indexes FollowSymLinks SymLinksIfOwnerMatch
```
Alternately, precede each argument by +, which means to modify the
existing option directives instead of overriding and resetting them.
<br>
A caveat about FollowSymLinks:  if any directory along the path is not<br>
accessible to the web server, then the symbolic link will appear not to<br>
exist.<br>
<br>
If guidescope isn't working, try "guidescope &".  I'm not sure exactly how<br>
to make this start up automatically every time.<br>
<br>
Here is a template/boilerplate for the start/beginning of a typical HTML file:<br>
<pre><code>&lt;!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"<br>
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"&gt;<br>
&lt;html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en"&gt;<br>
&lt;head&gt;<br>
  &lt;meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /&gt;<br>
  &lt;title&gt;TITLE&lt;/title&gt;<br>
  &lt;link rel="Start" href="http://www.mit.edu/~6.170/" /&gt;<br>
  &lt;link rel="StyleSheet" href="stylesheet.css" /&gt;<br>
&lt;/head&gt;<br>
&lt;body&gt;<br>
&lt;h1&gt;TITLE&lt;/h1&gt;<br>
...<br>
&lt;/body&gt;<br>
&lt;/html&gt;<br>
</code></pre>

To find out the location of the apache/httpd config files and other<br>
information about the server, execute 'httpd -V'.  This works on all<br>
systems that support apache (macos, windows, linux)<br>
<br>
To add a "favicon.ico" image to the address bar, do this in the<br>
<code>&lt;head&gt;...&lt;/head&gt;</code> section of the HTML document:<br>
<pre><code>  &lt;link rel="icon" type="image/png" href="my-favicon.png" /&gt;<br>
</code></pre>

How to quote less than and greater than (angle brackets) and at-signs, such as for generics, in Javadoc comments:<br>
<pre><code> Equation: {@literal i &gt; j}<br>
 Inline code: {@code getThat()}<br>
 Multi line code:<br>
   &lt;pre&gt;{@code<br>
   ...<br>
   }&lt;/pre&gt;<br>
</code></pre>


<hr />
<h1>C and C++</h1>

In C++, an auto_ptr is automatically deleted at the end of its scope.<br>
<br>
In C++,<br>
char <b>const s;   declares a constant pointer to possibly varying data<br>
const char</b> s;   declares a possibly varying pointer to constant data<br>
char const <b>s;   is the same as "const char</b> s"<br>
In other words, const modifies the type-element to its left.<br>
Put another way:  "const" and "int" are declaration specifiers which may<br>
occur in any order; "<b><a href='const.md'>const</a>" is a type modifier.</b>

Do not use dbmalloc; use dmalloc instead.<br>
<br>
The GNU program checker (gccchecker) detects memory use errors in a program.<br>
<br>
To run just the GNU C preprocessor (analogous to cpp), do gcc -E.<br>
To suppress line markers (line numbers) in the output, use gcc -E -P.<br>
To retain comments (/<b>...</b>/) in the output, use gcc -E -C.<br>
<br>
When compiling a C program with cc, put the -lLIBNAME flag at the end of<br>
the line, after the cfile name (the order matters).<br>
<br>
Debugging C memory (pointer) corruption problems:<br>
<ul><li>setenv MALLOC_CHECK<i>2<br>
</li><li>compile with "-lefence"</li></ul></i>

GNU Checker:  like Purify (includes gc).<br>
<a href='http://www.gnu.org/software/checker/checker.html'>http://www.gnu.org/software/checker/checker.html</a>, <a href='ftp://alpha.gnu.org/gnu'>ftp://alpha.gnu.org/gnu</a>
It's sometimes called gccchecker or checkergcc.<br>
It has not been tested on C++ (or updated since August 1998, as of 6/2001).<br>
Other Purify-like tools:  <a href='http://www.hotfeet.ch/~gemi/LDT/tools_deb.html'>http://www.hotfeet.ch/~gemi/LDT/tools_deb.html</a>
(libYaMa detects leaks and some other memory errors; is a malloc replacement:<br>
<a href='http://freshmeat.net/projects/libyama/'>http://freshmeat.net/projects/libyama/</a>)<br>
Also consider dmalloc (debug malloc); don't use dbmalloc.<br>
(dmalloc is somewhat distributed with Linux; I had trouble making it work.)<br>
Electric Fence (efence) is distributed with (some versions of?) Linux, and<br>
is available from <a href='ftp://ftp.perens.com/pub/ElectricFence/'>ftp://ftp.perens.com/pub/ElectricFence/</a>.<br>
It uses the virtual memory hardware to detect the instruction at which a<br>
bad memory reference occurs.  (I had a problem with it running out of memory.)<br>
<br>
The c++filt program demangles (unmangles) mangled overloaded C++<br>
method/function names.<br>
<br>
To write a cpp macro which takes a variable number of arguments:<br>
One popular trick is to define the macro with a single argument,<br>
and call it with a double set of parentheses, which appear to<br>
the preprocessor to indicate a single argument:<br>
<ol><li>efine DEBUG(args) {printf("DEBUG: "); printf args;}<br>
</li></ol><blockquote>if(n != 0) DEBUG(("n is %d\n", n));</blockquote>

To strip all comments and blank lines from a (Java or C) file, use<br>
<pre><code>  cpp -P -nostdinc -undef<br>
</code></pre>
(This also expands any #include directives.)<br>
This can help in computing non-comment non-blank (NCNB) lines of code<br>
(though you may want to remove #include directives before doing that, then<br>
reinsert them afterward).  The script ~jhp/bin/ncnbcode.php accepts<br>
a list of files and reports their ncnb lines of code, all lines, and<br>
a total.<br>
÷<br>
This error:<br>
<pre><code>    Undefined symbol            first referenced in file<br>
    socket                              /usr/X11R6/lib/libX11.so<br>
</code></pre>
means I should add more "-lsocket" and such flags to my link command.  Do<br>
"man <i>undefinedsymbol</i>" to see where the symbol is defined.<br>
<br>
Insight:  GUI front end to gdb.<br>
<a href='http://sources.redhat.com/insight/'>http://sources.redhat.com/insight/</a>
Also see DDD.<br>
<br>
gdb:<br>
<ul><li>For wide strings, just print with wstring2string.<br>
</li><li>"x/20s wstr" gives characters one per line; look at every third element.<br>
</li><li>"print wstr@20" gives characters on one line, but in ASCII.</li></ul>

If having trouble with gdb not being able to step over inlined functions,,<br>
add these arguments to gcc:<br>
<pre><code> -O0 -fno-default-inline -fno-inline<br>
</code></pre>

Why g++ 3.2 doesn't like uses of vector that g++ does:<br>
Two things to check:<br>
<ul><li>you must <code>#include &lt;vector&gt;</code>, not <code>&lt;vector.h&gt;</code>
</li><li>you must either say "using namespace std;" or say "std::vector", the<br>
<blockquote>latter being preferable in header files, of course.</blockquote></li></ul>


<hr />
<h1>Email</h1>

Websieve (sieve) RFC is rfc3028, with Sieve grammar and rules.<br>
There is a sieve email filter script tester (and syntax checker) at<br>
<blockquote><a href='http://sastools.com/SieveTest/sievetest.php'>http://sastools.com/SieveTest/sievetest.php</a>
(websieve itself only creates scripts, doesn't validate them.)<br>
Be sure to remove any "From VM" rule before running sievetest!</blockquote>

To have mailing list errors reflected to the list administrator:<br>
<ul><li>If you are using sendmail, the first thing to do is create the alias:<br>
<blockquote>owner-edb-list: edb-list-request<br>
</blockquote><blockquote>This causes errors occuring on edb-list to be reflected to "owner-edb-list".<br>
</blockquote></li><li>The other, sure-fire way is to pipe the edb-list mail through a sendmail<br>
<blockquote>invocation which changes the sender:<br>
<pre><code>    edb-list: "|/usr/lib/sendmail -fedb-list-request -oi real-edb-list"<br>
    real-edb-list: :include:/usr/lib/edb-list.alias<br>
</code></pre></blockquote></li></ul>

To expand a mailing list (alias), to learn its members:<br>
<pre><code>  telnet gh 25<br>
  expn elbows<br>
  quit<br>
</code></pre>
Another technique is "finger -a list@host"; at UW this works for me from<br>
Solaris (eg hoh), but not from Linux (eg nishin).<br>
If you get a 503 error, try doing "helo HOSTNAME" and then doing expn.<br>
<br>
Rich Salz's newsgate/mail2news program can inject all mailing list mail<br>
into a similarly named (local only) newsgroup, and vice versa.<br>
ftp.uu.net:/usenet/comp.sources.unix/volume24/newsgate/part0[1-4].Z<br>
<br>
To decode a MIME file (actually just one component of a mime message), use<br>
<pre><code>  mmencode -u mimefile &gt; plainfile<br>
</code></pre>
You need to save to a file (it doesn't read from standard input), and to<br>
strip off all headers (e.g., "Content-Type:" and "Content-Transfer-Encoding:").<br>
For quoted-printable, use -q flag as well.<br>
Also see the script (stolen from Greg Badros) "decode_mime", which<br>
<ul><li>strips off headers<br>
</li><li>chooses a filename intelligently</li></ul>

Mime unpacking:  use <a href='ftp://ftp.andrew.cmu.edu/pub/mpack/'>ftp://ftp.andrew.cmu.edu/pub/mpack/</a>
Options:<br>
<ul><li>-f<br>
<blockquote>Forces the overwriting of existing files.  If a message<br>
suggests a file name of an existing file, the file will be<br>
overwritten.  Without this flag, munpack appends ".1", ".2",<br>
etc to find a nonexistent file.<br>
</blockquote></li><li>-t<br>
<blockquote>Also unpack the text parts of multipart messages to files.<br>
By default, text parts that do not have a filename parameter<br>
do not get unpacked.<br>
</blockquote></li><li>-q<br>
<blockquote>Be quiet--suppress messages about saving partial messages.<br>
</blockquote></li><li>-C directory<br>
<blockquote>Change the current directory to "directory" before reading<br>
any files.  This is useful when invoking munpack<br>
from a mail or news reader.</blockquote></li></ul>

To send a single file as a MIME email (attachment), do (be sure to copy myself):<br>
<pre><code>  mpack -s "Subject line" -d descriptionfile filename address@host address2@host2<br>
  mpack -s "Subject line" filename address@host address2@host2<br>
</code></pre>
To write to a file,<br>
<pre><code>  mpack -s "Subject line" -o outputfile filename<br>
</code></pre>
To add some ASCII text at the beginning:<br>
<pre><code>  mpack -s "Subject line" -d descriptionfile -o outputfile filename<br>
</code></pre>
mpack can only encode one file, not multiple files.  For that, try pine.<br>
<br>
Mailing lists are in /etc/aliases on pag.<br>
To redirect to a file, it must be in a non-group-writeable directory.<br>
<br>
In Horde, to "bulk delete" or "delete all", go to the folders view, mark<br>
the desired folder, and then "Choose Action:  Empty Folder(s)".<br>
<br>
To upload mbox files to Gmail IMAP, use:  <a href='http://imap-upload.sourceforge.net/'>http://imap-upload.sourceforge.net/</a>
Typical invocation (for hosted apps at cs.washington.edu):<br>
<blockquote>python imap_upload.py --gmail --user=$USER@cs.washington.edu --password=PASSWORD --box GMAIL-LABEL --error ~/error.mail TO-UPLOAD.mail<br>
It may be necessary to convert a BABYL file to mbox format.<br>
Don't use b2m for that; instead, use:  M-x unrmail</blockquote>

If you read Gmail via IMAP, then your trash mail doesn't get deleted and it uses up your quota.  You may want to delete it for real.<br>
You only want to do this for Google Mail that is in <a href='Imap.md'>Imap</a>/trash and has no other user or system labels.  (I can't use -has:userlabels, unfortunately.)<br>
I want the trash label and no others; the way seems to be to list every label!<br>
<blockquote>-in:sent -in:chat -in:draft -in:inbox -in:...<br>
Here is also has:nouserlabels; is that useful?<br>
Also see the tips here:<br>
<a href='https://support.google.com/mail/answer/78892?hl=en'>https://support.google.com/mail/answer/78892?hl=en</a></blockquote>


<hr />
<h1>Make and Makefiles (and ant and buildfiles, build.xml)</h1>

In Makefiles, variables in rule targets and dependences are expanded as<br>
soon as the rule target is read, but variables in rule actions are expanded<br>
only when the action is actually executed.  Watch out for this<br>
inconsistency!  This means that rules with variables in their<br>
targets/dependences should come at the end of Makefiles.<br>
<br>
In a Makefile, the right way to invoke make on a subdirectory or other<br>
directory is<br>
<pre><code>             cd subdir &amp;&amp; $(MAKE)<br>
</code></pre>
or, equivalently,<br>
<pre><code>             $(MAKE) -C subdir<br>
</code></pre>
To execute parallel jobs on a multiprocessor, use the "-j2" option.<br>
<br>
In make, to ensure that a rule always runs even if the target seems to be<br>
up to date, add an extra rule of the form<br>
<pre><code>     .PHONY : clean<br>
</code></pre>
Once this is done, `make clean' will run the commands regardless of<br>
whether there is a file named `clean'.<br>
<br>
After Makefile.in is changed, it is necessary to rerun "config.status" and<br>
then rerun "make".<br>
<br>
Particularly useful "automatic variables" used by make (in Makefile rules):<br>
<ul><li>$@   the target of the rule<br>
</li><li>$<   the first prerequisite<br>
</li><li>$^   all the prerequisites</li></ul>

In Makefiles, to test whether a file/directory exists, do something like this:<br>
<pre><code>  # Test that the directory exists.  There must be a better way to do this.<br>
  INV:=$(wildcard $(INV))<br>
  ifndef INV<br>
    $(error Environment variable INV is not set to an existing directory)<br>
  endif<br>
</code></pre>
or alternately:<br>
<pre><code>  ifeq "$(wildcard ${INV}/scripts)" "${INV}/scripts"<br>
       ... it exists ...<br>
  else<br>
       ... it does not exist ...<br>
  endif<br>
</code></pre>

## Ant and buildfiles<br>
<br>
An Ant guide (documentation) for beginners:<br>
<a href='http://wiki.apache.org/ant/TheElementsOfAntStyle'>http://wiki.apache.org/ant/TheElementsOfAntStyle</a>

To permit user-specific setting of variables in a Makefile, add this at the<br>
top (and change assignments to use "=?" syntax):<br>
<pre><code>  # Put user-specific changes in your own Makefile.user.<br>
  # Make will silently continue if that file does not exist.<br>
  -include Makefile.user<br>
</code></pre>

Suppose I want to write a rule that always performs a task, but doesn't<br>
necessarily cause its dependence to execute first.  This is a snippet of<br>
the Makefile I would like to write:<br>
<pre><code>.PHONY: maybe-update-file1<br>
maybe-update-file1:<br>
	Command A:  may or may not update file1.txt<br>
file2.txt:  maybe-update-file1 file1.txt<br>
	Command B:  computes file2.txt from file1.txt<br>
</code></pre>
Problem: because the maybe-update-file1 target always executes, Command B<br>
always executes.  That wastes the time to execute Command B, and because it<br>
unconditionally updates file2.txt, any command that depends on file2.txt<br>
also executes unnecessarily.<br>
.<br>
Here is an approach that works:<br>
<pre><code>file2.txt: maybe-update-file1 .timestamp-file2<br>
.PHONY: maybe-update-file1<br>
maybe-update-file1:<br>
	@if [ `fortune | wc -l` -eq 1 ] ; then echo touch file1.txt; touch file1.txt; fi<br>
.timestamp-file2: file1.txt<br>
	cp file1.txt file2.txt<br>
	touch .timestamp-file2<br>
</code></pre>

To make a tags table for a LaTeX paper, using an Ant buildfile:<br>
<pre><code>  &lt;target name="etags" depends="tags"&gt;<br>
  &lt;/target&gt;<br>
  &lt;target name="tags" depends="init" description="builds Emacs TAGS table"&gt;<br>
    &lt;exec os="Linux" executable="etags" failonerror="true"&gt;<br>
      &lt;!-- args explicitly specified so that they are in the right order --&gt;<br>
      &lt;!-- To regenerate, run:  latex-process-inputs -antlist main.tex --&gt;<br>
      ...<br>
    &lt;/exec&gt;<br>
  &lt;/target&gt;<br>
</code></pre>
To make a tags table for a Java project, using an Ant buildfile:<br>
<pre><code>  &lt;target name="etags" depends="tags"&gt;<br>
  &lt;/target&gt;<br>
  &lt;target name="tags" description="Create Emacs TAGS table"&gt;<br>
    &lt;exec executable="/bin/sh"&gt;<br>
      &lt;arg value="-c"/&gt;<br>
      &lt;arg value="etags `find -name '*.java' | sort-directory-order`"/&gt;<br>
    &lt;/exec&gt;<br>
  &lt;/target&gt;<br>
</code></pre>

To print out a path in ant, use this snippet of code at the end of your ant<br>
file.  This is good for debugging classpath issues when running javac, as<br>
ant ordinarily doesn't let you see the classpath or the javac command line.<br>
<pre><code>  &lt;!-- = = = = = = = = = = = = = = = = =<br>
       macrodef: echopath<br>
       Use as:    &lt;echopath pathid="mypath"/&gt;<br>
       = = = = = = = = = = = = = = = = = --&gt;<br>
  &lt;macrodef name="echopath"&gt;<br>
    &lt;attribute name="pathid"/&gt;<br>
    &lt;sequential&gt;<br>
      &lt;property name="line.pathprefix" value="| |-- "/&gt;<br>
      &lt;!-- get given path in a printable form --&gt;<br>
      &lt;pathconvert pathsep="${line.separator}${line.pathprefix}"<br>
       property="echo.@{pathid}"<br>
       refid="@{pathid}"&gt;<br>
      &lt;/pathconvert&gt;<br>
      &lt;echo&gt;Path @{pathid}&lt;/echo&gt;<br>
      &lt;echo&gt;${line.pathprefix}${echo.@{pathid}}&lt;/echo&gt;<br>
    &lt;/sequential&gt;<br>
  &lt;/macrodef&gt;<br>
</code></pre>

To print a fileset in Ant:<br>
<pre><code>    &lt;macrodef name="echo-fileset"&gt;<br>
		    &lt;attribute name="filesetref" /&gt;<br>
		    &lt;sequential&gt;<br>
		    &lt;pathconvert pathsep="\n " property="@{filesetref}.echopath"&gt;<br>
				    &lt;path&gt;<br>
					    &lt;fileset refid="@{filesetref}" /&gt;<br>
				    &lt;/path&gt;<br>
			    &lt;/pathconvert&gt;<br>
		    &lt;echo&gt;   ------- echoing fileset @{filesetref} -------&lt;/echo&gt;<br>
		    &lt;echo&gt;${@{filesetref}.echopath}&lt;/echo&gt;<br>
		    &lt;/sequential&gt;<br>
    &lt;/macrodef&gt;<br>
...<br>
    &lt;echo-fileset filesetref="src.files"/&gt;<br>
</code></pre>

To access environment variables in Ant:<br>
<pre><code>  &lt;property environment="env"/&gt;<br>
</code></pre>
and then use<br>
<pre><code>  ${env.HOME}<br>
</code></pre>

A recipe for a temporary directory in Ant:<br>
<pre><code>  &lt;property name="tmpdir" location="${java.io.tmpdir}/${user.name}/${ant.project.name}" /&gt;<br>
  &lt;delete dir="${tmpdir}" /&gt;    <br>
  &lt;mkdir dir="${tmpdir}" /&gt;<br>
</code></pre>

ant wildcards -  means the current directory or any directory<br>
below it.  I still can't find where this is documented.<br>
<br>
In Ant, to check whether files have the same contents, there is no "diff"<br>
task but you can use the "filesmatch" condition.<br>
<br>
In Ant, to convert a relative filename/pathname to absolute, use:<br>
<pre><code>  &lt;property name="x" location="folder/file.txt" /&gt;<br>
</code></pre>
and ${X} will be the absolute path of the file relative to the ${basedir} value.<br>
In general, for a file or directory, it's less error-prone to use<br>
<pre><code>  &lt;property name="x" location="folder/file.txt" /&gt;<br>
</code></pre>
rather than<br>
<pre><code>  &lt;property name="x" value="folder/file.txt" /&gt;<br>
</code></pre>
Also consider using ${basedir}, which is already absolute.<br>
It defaults to the containing directory of the buildfile, and it can appear<br>
in a build.properties file.<br>
A slightly less clean approach than ${basedir} is<br>
<pre><code>  &lt;dirname property="ant.file.dir" file="${ant.file}"/&gt;<br>
</code></pre>

Ant permits you to specify that one target depends on another, but by<br>
default every prerequisite is always rebuilt, even if it is already up to<br>
date.  (This is a key difference between Ant and make:  by default, make<br>
only re-builds a target if some prerequisite is newer.)<br>
<p>
To make Ant re-build prerequisites only if necessary, there are two general<br>
approaches.<br>
<ol><li>Use the uptodate task to set a property.  Then, your task can test the<br>
<blockquote>property and build only if the property is (not) set.<br>
<pre><code>  &lt;uptodate property="mytarget.uptodate"&gt;  // in set.mytarget.uptodate task<br>
    ...<br>
  &lt;/uptodate&gt;<br>
  &lt;!-- The prerequisites are executed before the "unless" is checked. --&gt;<br>
  &lt;target name="mytarget" depends="set.mytarget.uptodate" unless="mytarget.uptodate"&gt;<br>
    ...<br>
  &lt;/target&gt;<br>
</code></pre>
Alternately, use the outofdate task from ant contrib.  It's nicer in<br>
that it is just one target without a separate property being defined; by<br>
contrast, outofdate requires separate targets to set and to test the<br>
property.<br>
</blockquote></li><li>Create a <br>
<br>
<fileset><br>
<br>
 using the <br>
<br>
<modified><br>
<br>
 selector.  It calculates MD5<br>
<blockquote>hashes for files and selects files whose MD5 differs from earlier stored<br>
values.  It's optional to set<br>
<pre><code>     &lt;param name="cache.cachefile"     value="cache.properties"/&gt;<br>
</code></pre>
inside the <br>
<br>
<modified><br>
<br>
 selector; it defaults to "cache.properties".<br>
Example that copies all files from src to dest whose content has changed:<br>
<pre><code>        &lt;copy todir="dest"&gt;<br>
            &lt;fileset dir="src"&gt;<br>
                &lt;modified/&gt;<br>
            &lt;/fileset&gt;<br>
        &lt;/copy&gt;<br>
</code></pre>
<p>
There is also Ivy, but I can't tell from its documentation whether it<br>
provides this feature.  The key use case in the documentation seems to be<br>
downloading subprojects from the Internet rather than avoiding wasted work<br>
by staging the parts of a single project.</blockquote></li></ol>

In Ant, the path to the current ant build file (typically build.xml) is<br>
available as property ant.file .  You can get its directory in this way:<br>
<br>
<br>
<dirname property="ant.file.dir" file="${ant.file}"/><br>
<br>
<br>
<br>
In Ant, to jar up the contents of a set of existing .jar files:<br>
<pre><code>    &lt;zip destfile="out.jar"&gt;<br>
	&lt;zipgroupfileset dir="lib" includes="*.jar"/&gt;<br>
    &lt;/zip&gt;<br>
</code></pre>

Vizant (<a href='http://vizant.sourceforge.net/'>http://vizant.sourceforge.net/</a>) is an ant build visualization tool.<br>
<br>
<br>
<hr />
<h1>Eclipse</h1>

Useful keystrokes in Eclipse:<br>
<blockquote>C-S-t:  lookup type (like M-. in Emacs, but only for classes, not methods)<br>
F3: open definition, also like M-.<br>
<blockquote>(how do you find a method's definitions?)<br>
</blockquote>C-S-h: all callers (call sites) for a particular method implemention (but<br>
<blockquote>not calls via a superclass or interface):  opposite of F3<br>
</blockquote>C-S-r:  lookup resources: finds all uses of this method name, like grep; but<br>
<blockquote>stays within the type hierarchy, not just textual; more useful than C-S-h<br>
</blockquote>C-h:  textual search through Java files<br>
F5:   refresh (for updates made through the file system)<br>
C-O:  quickly type your way to a field or method declaration<br>
F4: class hierarchy (also available from a context menu)<br>
Eclipse Debugger:  F6 goes to next line</blockquote>

To make Eclipse use spaces instead of tabs for indentation:<br>
<ul><li>Go  to 'Window | Preferences | Java | Code Formatter':<br>
<ul><li>In the "Style" tab:<br>
<ul><li>Uncheck "Insert tabs for indentation, not spaces."<br>
</li><li>Set "Number of spaces representing an indentation level" to 2.<br>
</li></ul></li></ul></li><li>Go to 'Window | Preferences | Java | Editor':<br>
<ul><li>In the "Typing" tab:<br>
<ul><li>Check "Insert space for tabs"</li></ul></li></ul></li></ul>

Changing the font size in Eclipse:<br>
<blockquote>Window > Preferences > General > Appearance > Colors and Fonts > Basic ><br>
Text Font > Change : select and apply the new font size<br>
To go back to the old font size, click the Reset button.<br>
Or, use this plugin: <a href='http://smallwiki.unibe.ch/fontsizebuttons'>http://smallwiki.unibe.ch/fontsizebuttons</a></blockquote>

Under Eclipse "Run configurations", a useful VM argument is "-ea".<br>
<br>
When compiling Daikon, may be simpler to add daikon.jar to "User Entries"<br>
section of Eclipse classpath.<br>
You can define your own variables.<br>
<br>
Eclipse Javadoc:  .html files get written to working directory.<br>
So be sure to save changes to these before you start testing javadoc.<br>
<br>
Mahmood suggests:<br>
<ul><li>Eclipse for debugging and writing classes from scratch.<br>
</li><li>Ant or command line for anything complicated.</li></ul>

Eclipse has two compilers.<br>
The model reconciler operates on buffers and runs on every keystroke to create red squigglies.  (It's called that because it reconciles the internal representation or model of the program with the visual representation in the editor.)<br>
The incremental project builder (for short, "builder") operates on files and runs whenever the user saves the file.  It can do a full build (by clearing out resources such as .class files first) as well as an incremental build.  The implementation for java invokes the eclipsec compiler.  <a href='Occasionally.md'>people use the term "reconciler" incorrectly to refer to incremental project building.</a>

<hr />
<h1>General wisdom (that is, everything without its own section above)</h1>

Information about a variety of Java tools can be found in the wisdom<br>
repository, in file java-tools.txt.<br>
<br>
expand, unexpand:  change TABs to SPACEs and vice versa.<br>
<br>
rehash:  If my path seems messed up, or I've added programs, do rehash.<br>
(Perhaps this only works under csh.)<br>
<br>
sed:  for example, sed -e '/^SED/ s|SED|SOGGY|' man-sed | more<br>
<br>
ps:  Use ps -aux to get job #s of all jobs.  On some machines such as SGIs,<br>
ps -lf gives a long full listing (use -e or -d to see more processes).<br>
"top" shows percent of CPU being used by each process; good adjunct to ps.<br>
ps options:<br>
<ul><li>-l long format, shows priorities (set by nice or renice)<br>
</li><li>-u user-oriented format<br>
also:<br>
</li><li>-a show all processes<br>
</li><li>-x show even processes with no controlling terminal<br>
</li><li>-w use wide display</li></ul>

xterm:  give -ut flag to prevent appearing in finger.<br>
<br>
system, eval evaluate their argument.<br>
exec replaces the current shell with its argument.  Be careful!<br>
<br>
sleep:  delays execution; waits that many seconds.<br>
<br>
expr:  Bourne shell way to do lots of stuff (ex regular expressions,<br>
arithmetic, comparisons); see also TEST<br>
<br>
Programs for drawing figures under X Windows (from best to worst in ease of use):<br>
<ul><li>OpenOffice/LibreOffice draw<br>
</li><li>inkscape -- can't attach text to an object easily (could group them to<br>
<blockquote>fix the position, but then scalng doesn't work right)<br>
</blockquote></li><li>xfig (abandoned in 2005)<br>
</li><li>idraw (abandoned in 2002)<br>
</li><li>skencil (formerly called sketch) (Skencil 0.6.17 released 2005-06-19)<br>
</li><li>dia (0.96 was released 2007-03-25; latest as of Sep 2012)<br>
</li><li>tgif -- (version 4.1.45 released 6/2006)<br>
The mayura draw program for Windows takes Windows Metafiles (such as produced by<br>
PowerPoint) and creates PostScript.<br>
It may be best just to create figures using PowerPoint (but that is<br>
crashing for me when I try to create PDF...).</li></ul>

split:<br>
Use<br>
<pre><code>  wc -l &lt;file&gt;<br>
</code></pre>
then<br>
<pre><code>  split -&lt;numberoflines&gt; &lt;file&gt; &lt;newfilebase&gt;<br>
</code></pre>
to split files into parts.<br>
<br>
du:  disk usage.<br>
<ul><li>du -s <b>only display grand total for each file and subdirectory in this dir<br>
</li><li>du -S       not sum child directories in count for parent<br>
</li><li>du | sort -r -n   sort directories, with most usage first.<br>
</li><li>du | xdu -- only when you're in X, obviously. Better grain than above, with the ability to drill down into subdirectories<br>
Also see Alan Donovan's program "prune"<br>
(executable: ~adonovan/bin/Linux-i686/prune; sources: ~/work/c/prune/)<br>
For example,<br>
<pre><code>  ~adonovan/bin/Linux-i686/prune -size 104857600 -age 604800 ~<br>
</code></pre>
Looking at files within a single directory, rather than a whole directory tree:<br>
</li><li>ls -l | sort -n +4 -- sorts files in size order, good for finding big files in a directory<br>
</li><li>du -s</b> | sort -n -- similar to above, find the biggest files & subdirectories of the current dir</li></ul>

.DESKTOP file:  Macintosh info about my files.  Safe to delete.<br>
<br>
To make a soft link, do<br>
<pre><code>  ln -s filename linkname<br>
</code></pre>

expect:  controls interactive programs to permit them to be used in a batch<br>
fashion via send/expect sequences, job control, user interaction, etc.<br>
<br>
To create a script file that will respond to any prompt, not just a<br>
top-level one:<br>
<pre><code>  #! /bin/csh<br>
  ftp -n foo.bar.baz &lt;&lt;END<br>
  user anonymous mernst@theory.lcs.mit.edu<br>
  cd pub/random<br>
  get some-useful-file<br>
  quit<br>
  END<br>
</code></pre>

crontab:  batch sorts of programs run repeatedly (say, each night)<br>
<br>
Format manual pages:  nroff -man foo.1 | more<br>
Print roff files:     troff -t filename | lpr -t<br>
.ms => PostScript:    groff -pte -ms file.ms > file.ps<br>
man pages => PS:      groff -pte -man foo.1 > file.ps<br>
<br>
nslookup converts domain names into ip numbers.<br>
"host" and "dig" also query the same DNS information.<br>
<br>
ftp:  do "prompt off" to turn off confirmation requests on multiple commands<br>
<br>
David Wilson says about running background jobs:<br>
The simplest thing to do is a shell script that does <code>rsh &lt;nice command&gt;</code> on<br>
the various machines, and then run the shell script on a machine that<br>
doesn't get rebooted very often.<br>
<br>
If there is no password specified in the netrc file, then the macdef init<br>
seems not to take.<br>
<br>
To permit arbitrary-size core dumps:  unlimit corelimit<br>
<br>
Undo the setuid bit of a file with chmod -s.<br>
<br>
df:  Report free disk space and which filesystems are mounted.<br>
<br>
tar:  tape archive program.  Usual extraction from files is<br>
<pre><code>  tar xf filename<br>
</code></pre>
Create an archive file recursively containing all the files in the current<br>
directory with<br>
<pre><code>  tar cf tarfile.tar *<br>
</code></pre>
It's better, though, to create a tar archive that extracts itself into a<br>
directory by doing<br>
<pre><code>  tar cf tarfile.tar dir<br>
</code></pre>

To extract a rar archive:<br>
<pre><code>  unrar e archive.rar<br>
</code></pre>

Francesco Potorti` (pot@CNUCE.CNR.IT) says:<br>
To make a single tags file for all the source files in your tree,<br>
<pre><code>    find . -name '*.[chCH]' -print | etags [options] -<br>
    find . \( -name '*.[chCH]' -o -name '*.[cC][cC]' \) -print | etags -<br>
    find . \( -name UNUSED -o -name CVS -o -name SCCS -o -name RCS \) -prune -o \( -name '*.[cC][cC]' -o -name '*.[chCH]' \) -print | etags -<br>
</code></pre>
To create a tags file per directory, write a two line shell script:<br>
<pre><code>    cd $1<br>
    etags *.[chCH]<br>
</code></pre>
and then call it from the root of your source tree like this:<br>
<pre><code>    find . -type d -exec script {} \;<br>
</code></pre>

To see and manipulate your junk files which are taking up precious<br>
space on the computer, use the program junk.  Typing<br>
just "junk" will show you the names of all the junk files subordinate<br>
to your current directory.  Typing "junk -c rm" will remove them<br>
(CAREFUL!).  For more information, see /a/aviary/unix/junk.doc.<br>
<br>
Converting binhex files:<br>
<blockquote>"hexbin foo" creates "foo.bin".  Also consider "-u" or "-U" option.</blockquote>

In /usr/local/man, manX subdirectories contain raw man pages.<br>
catX subdirectories contain formatted man pages preprocessed by<br>
<pre><code>  neqn man1/emacs.1 | tbl | nroff -man &gt; cat1/emacs.1<br>
  pack -f cat1/emacs.1<br>
</code></pre>
The .z suffix on these files indicates that they were created by pack (use<br>
unpack or pcat to view), NOT gzip.<br>
<br>
ppanel program: control printing from a GUI<br>
<br>
"polite" is like "nice"; it runs runs a program at lower priority.<br>
It allows other users to 'nap' the 'polite' program for an interval.<br>
<pre><code>  % polite big-cache-simulator -assoc 2 -size 8192 -other flags<br>
</code></pre>
and then an interactive user of merganser could do<br>
<pre><code>  % nap all<br>
</code></pre>
putting the cache simulator to sleep for 15 minutes.<br>
See the man pages for more information.<br>
Child jobs spawned by the polited process aren't run under polite, however.<br>
<br>
renice causes a running program to acquire only idle resources<br>
<br>
truss, strace tell all systems calls made by a process (a program run from<br>
the command line).  It's truss on Solaris, strace everywhere else.<br>
<br>
ldd <i>executablename</i> tells which shared libraries a program uses.<br>
<br>
/etc/groups on some systems is "ypcat group" on others.<br>
The "id" program also lists the groups for each user.<br>
<br>
jgraph - filter for graph plotting to postscript.<br>
Also see ~jdean/graph, which is a preprocessor for it by Eric Brewer.<br>
Sample invocation:<br>
<pre><code>graph -e -g -p -c &lt;sample-input.graph | jgraph -P | gv -<br>
</code></pre>

gnuplot: with the "eps" terminal, has only six symbols available.  The<br>
"latex" terminal has more symbols (and the output is more customizable),<br>
though the output isn't as pretty.<br>
<br>
An alternative to gnuplot/jgraph is xmgr; supposedly nice but has steep<br>
learning curve.<br>
<br>
xdvi: use "s" to set shrink (image/font size); 3 is a reasonable prefix<br>
argument<br>
<br>
The "search" program is like a combination of 'find' and 'grep' (but using<br>
Perl regular expressions, and more powerful and efficient).<br>
Files:<br>
<ul><li>the program: ~mernst/bin/share/search<br>
</li><li>its manpage: ~mernst/bin/share/search.manpage<br>
</li><li>example dotfile: ~mernst/.search<br>
I find <code>search' easier to use than </code>grep<code>, but </code>grep` can often replace<br>
it.  For example, these give identical results (except for order):<br>
<pre><code>search -dir lucene -n 'SuppressWarnings.*interning'<br>
grep -r -n -e 'SuppressWarnings.*interning' lucene<br>
</code></pre></li></ul>

To find/search and replace in multiple files (say, an entire directory)<br>
use<br>
<pre><code>  preplace [options] oldregexp newregexp [files]<br>
</code></pre>
which is like<br>
<pre><code>  perl -pi -e 's/OLD/NEW/g'<br>
</code></pre>
except that the timestamp on each file is updated only if the replacement<br>
is performed.<br>
<a href='WATCH.md'>OUT when omitting the [files</a> argument, since you generally do <b>not</b>
want to perform the replacement in files in the .svn directory.]<br>
[WARNING: This program does not respect symbolic links, instead replacing<br>
each symbolic link with a copy of its contents.  So, generate the <a href='files.md'>files</a>
part without symbolic links.]<br>
See below for more details.<br>
.<br>
To find/search and replace in multiple files (say, an entire directory)<br>
from the command line via perl, do<br>
<pre><code>  perl -pi.bak -e 's/OLD/NEW/g' *<br>
</code></pre>
NOTE caveats below; it's better to search, then replace only in relevant files.<br>
Add "i" after g for case-insensitive.<br>
Other possible invocations:<br>
<pre><code>  find . -type f -print | xargs perl -pi.bak -e 's/OLD/NEW/g'<br>
  find . -type f -name '*.html' -print | xargs grep -l 'sdg.lcs.mit.edu/~mernst/' | xargs perl -pi.bak -e 's|sdg.lcs.mit.edu/~mernst/|pag.lcs.mit.edu/~mernst/|g'<br>
  find . -type f -name Root -print | xargs grep -l '/g1/users/adbirka/.cvs' | xargs perl -pi.bak -e 's|/g1/users/adbirka/.cvs|/g4/projects/constjava/.cvs|g'<br>
  preplace /g1/users/adbirka/.cvs /g4/projects/constjava/.cvs `find . -type f -name Root -print`<br>
</code></pre>
(You can do the same for SVN with <code>svn switch --relocate OLD-PREFIX NEW-PREFIX</code>,<br>
which retargets a checkout, or for many repositories:<br>
<pre><code>  find . -path \*/.svn/entries -print0 | xargs -0 preplace manioc.csail login.csail<br>
</code></pre>
)<br>
Problems with the first invocation, fixed by the others:<br>
<ul><li>The first invocation will search/replace in compressed, binary, PostScript,<br>
<blockquote>etc. files.  (a few examples: .tar .gz .gif .pdf .ps .Z)<br>
</blockquote></li><li>The first invocation will update all the files' modification dates, even if<br>
<blockquote>no replacement occurs.<br>
</blockquote></li><li>The first invocation will copy links into regular files.<br>
.<br>
An alternate way to fix CVS repositories is<br>
<pre><code>  cd ~/research/invariants<br>
  echo ":ext:${USER}@pag.csail.mit.edu:/g4/projects/invariants/.CVS' &gt;new-root<br>
  find . -name Root | xargs -n1 cp ~/research/invariants/new-root<br>
</code></pre></li></ul>

In CMU Common Lisp (cmucl), smaller applications can result from<br>
<pre><code>    (declaim (optimize (speed 3) (safety 0) (debug 0)))<br>
</code></pre>
An apparently reasonable development setting:<br>
<pre><code>    (declaim (optimize (safety 3) (speed 2) (debug 2) (compilation-speed 0)))<br>
</code></pre>

To copy a (local) directory recursively:  cp -pR source target-parent<br>
To copy a (remote) directory structure from one machine to another:<br>
<pre><code>  tar cf - packages | rsh ebi "cd /tmp/mernst/pack-cppp-new &amp;&amp; tar xf -"<br>
  tar cfz - packages | rsh hokkigai "cd /tmp/mernst &amp;&amp; tar xfz -"<br>
</code></pre>
This is like<br>
<pre><code>  rcp -rp mernst@torigai:/tmp/mernst .<br>
</code></pre>
except that the latter doesn't preserve symbolic links.<br>
<br>
Regular expressions (regexps):<br>
<ul><li>In alternation, first match is chosen, not longest match.  For<br>
<blockquote>efficiency, put most likely match (or most likely to fail fast) first.<br>
</blockquote></li><li><code>(ab)?(abcd)?</code> matches "ab" in "abcde"; does not match the longer "abcd"<br>
</li><li>character class <code>[abc]</code> is more efficient than alternation <code>(a|b|c)</code>
</li><li>unrolling the loop:     <code>opening normal* (special normal*)* closing</code>
<blockquote>eg, for a quoted string:   <code>/L?"[^"\\]*(?:\\.[^"\\]*)*"/</code>
or <code>$string_literal_re = 'L?"[^"\\\\]*(?:\\.[^"\\\\]*)*"';</code>
</blockquote><ul><li>start of normal and special must never intersect<br>
</li><li>special must not match nothingness<br>
</li><li>text matched by one application of special must not be matched by<br>
<blockquote>multiple applications of special</blockquote></li></ul></li></ul>

uname gives operating system (uname -a gives more info).<br>
<br>
sysinfo:  information about this hardware, like amount of memory,<br>
architecture, operating system, and much more.<br>
/usr/sbin/psrinfo -v:  information about processor speed and coprocessor.<br>
The "top" program also tells the machine's amount of memory and swap space.<br>
Also see "uname -a" and "cat /proc/cpuinfo" (as<br>
well as some of the other kernel pseudo-files under /proc).<br>
<br>
In Python, by default variables have function (not block) scope.  To refer<br>
to (really, to change) a global variable, use the "global" declaration in<br>
the class/function/whatever.<br>
<br>
To test whether a file exists in Python, do os.path.exists('/file/name').<br>
In Python, to reimport module foo, do reload(foo).<br>
<br>
Python debugger:  pdb ~/python/test.py<br>
You need to "s"tep a few times before "n"ext, which would jump over the<br>
entire program.  Or just do "continue" to the error.<br>
<br>
For time-critical Python runs, disable assertions via -O command-line<br>
option to Python or setting variable debug to false:  debug = 0.<br>
You can be sure that the optimized version is running if a .pyo instead of<br>
a .pyc file is created after you do "import".<br>
To make Python run optimized, do:<br>
<pre><code>  (setq-default py-which-args (cons "-O" (default-value 'py-which-args)))<br>
</code></pre>
To make Python run unoptimized, do:<br>
<pre><code>  (setq-default py-which-args (delete "-O" (default-value 'py-which-args)))<br>
</code></pre>
To evaluate these in Emacs, put the cursor at the end of the line and type<br>
C-x C-e.<br>
After you change py-which-args, kill the <code>*Python*</code> buffer and restart<br>
(it's not enough to kill the Python process and restart).<br>
<br>
As of Python 1.5.1, cPickle is buggy; don't use it in preference to pickle,<br>
even if it is faster...<br>
<br>
The ispell program will merge personal dictionaries (.ispell_english) found<br>
in the current directory and the home directory.<br>
<br>
To run a program disowned (so that exiting the shell doesn't exit the<br>
program), precede it by "nohup".  Programs run in the background also<br>
continue running when the shell exits (though interactive programs and some<br>
others seem to be exceptions to this rule; or maybe the rule about<br>
background jobs continuing only applies for programs that ignore the hangup<br>
(hup) signal).<br>
<br>
To make a diff file good for patching old-file to produce new-file,<br>
<pre><code>  diff -c old-file new-file<br>
</code></pre>
In GNU diff, specify lines of context using -C # (not -c #).<br>
<br>
With patch version 2.4 or 2.5 (and maybe other versions), you must set the<br>
environment variable POSIXLY_CORRECT to TRUE. Otherwise patch won't look at<br>
the "Index:" lines and it will ask for the filename for each patch.<br>
<br>
moss:  a software plagiarism detector by Alex Aiken.<br>
<a href='http://www.cs.berkeley.edu/~aiken/moss.html'>http://www.cs.berkeley.edu/~aiken/moss.html</a>

To add Frostbyte's public key to my PGP keyring:<br>
<pre><code>  pgpk -a http://sub-zero.mit.edu/fbyte/pgp.html<br>
</code></pre>

To find all the executables on my path with a particular name, use<br>
/usr/local/bin/which -a<br>
<br>
/uns/share/bin/ps2img converts PostScript to gif (or other image format?)<br>
files.  It will handle multipage postscript files fairly gracefully without<br>
filling up your disk, and it will look for and pay attention to the<br>
BoundingBox of EPS files if you give the the -e option.  Run it with no<br>
arguments to see the options.<br>
<br>
To convert a directory from DOS to Unix conventions:<br>
<pre><code>foreach f ( `find . -type f` )<br>
  echo $f<br>
  dos2unix $f $f | grep -v 'get keyboard type US keyboard assumed'<br>
end<br>
</code></pre>

LAOLA converts Microsoft Word .doc documents to plain text.  It is<br>
superseded by the Perl OLE::Storage module<br>
(<a href='http://wwwwbs.cs.tu-berlin.de/~schwartz/perl/'>http://wwwwbs.cs.tu-berlin.de/~schwartz/perl/</a> or<br>
<a href='http://www.cs.tu-berlin.de/~schwartz/perl/'>http://www.cs.tu-berlin.de/~schwartz/perl/</a>), which gives access to<br>
"structured storage", the binary data format of standard Microsoft Windows<br>
OLE documents.<br>
<br>
mkid (part of GNU's id-utils) is something like tags, but records all uses<br>
of all tokens and permits lookup.  There's an Emacs interface, too.<br>
<br>
The file command gives information about the file format (type of file,<br>
executable (including debugging format), etc).<br>
<br>
On a Kinesis Advantage contoured keyboard:<br>
Soft reset: Press Progrm + Shift + F10.<br>
Hard Reset: With computer turned off, press F7, turn computer on, release F7 after about 10 seconds. Successful if the lights on your keyboard flash for several seconds after releasing.<br>
Toggle the click:  Progrm key + pipes/backslash key (below the hyphen key)<br>
Toggle the tone: progrm+hyphen<br>
Dvorak:  progrm+shift+f5 (this erases any remapping, but not macros)<br>
If I am getting bizarre "super" modifiers, then the keyboard may be in Mac<br>
<blockquote>mode.  Holding down = then tapping s may produce "v3.2<a href='.md'>.md</a>".  Change to PC<br>
mode by holding down = then tapping p; now holding down = and tapping s may<br>
produce "v3.2<a href='SL.md'>K H x e </a>".</blockquote>

There's no perfectly reliable way to determine the version of Red Hat Linux<br>
is being run, but you can try:<br>
<pre><code>  rpm -q redhat-release<br>
  cat /etc/redhat-release  # the single file that the above package installs<br>
</code></pre>

ImageMagick is a replacement for (part of) xv:  three of its programs are:<br>
<ul><li>display will view images in a great many different file formats.<br>
</li><li>import grabs screen shots, either that you select with the mouse, that<br>
<blockquote>you specify by window ID, or the root window.<br>
</blockquote></li><li>convert old.gif new.jpg lets you easily change image formats.</li></ul>

"locate" finds a file of a given name anywhere on the system.<br>
Database is updated nightly or so.<br>
<br>
To use "crypt" to encrypt a string, like in the password file /etc/passwd,<br>
use "openssl passwd".<br>
(Note that "crypt" is known to be insecure; only use it for /etc/passwd.)<br>
<br>
Use "chsh" to set/change your shell.<br>
<br>
make: "error 139" means that your program segfaulted:  139 = 128+11, and 11<br>
is a segfault (<a href='http://www.bitwizard.nl/sig11/'>http://www.bitwizard.nl/sig11/</a>).<br>
<br>
If using YP for password (yppasswd) and other files, don't edit /etc/group;<br>
instead, as root, edit, then rebuild the NIS database:<br>
<pre><code> ${EDITOR} /var/yp/etc/group<br>
 cd /var/yp; make<br>
</code></pre>
If yppasswd does not work, then maybe the ypbind and/or yppasswd daemons<br>
have died.  "ypwhich" will return an error message if ypbind has stopped.<br>
To restart the daemons, do (as root)<br>
<pre><code>  /etc/rc.d/init.d/ypbind restart<br>
  /etc/rc.d/init.d/yppasswdd restart<br>
</code></pre>

Find all subdirectories:<br>
<pre><code>  find . -type d -print<br>
  find . -type d -exec script {} \;<br>
</code></pre>
Make all subdirectories readable and executable by group:<br>
<pre><code>  find . -type d -exec chmod g+rx {} \;<br>
</code></pre>
Make all files readable by group:<br>
<pre><code>  find . -type f -exec chmod g+r {} \;<br>
</code></pre>
Find all group-writeable files:<br>
<pre><code>  find . -type l -prune -o -perm -020 -print<br>
</code></pre>

To install an RPM, do  rpm -Uvh foo.rpm<br>
<br>
If machines come up before the ntpd server (and as a result their time<br>
and date are not synchronized/synched), run this command on each machine:<br>
<pre><code>  /etc/rc.d/init.d/xntpd restart<br>
</code></pre>

On pag, use "yppasswd" instead of "passwd".<br>
<br>
SAS:<br>
<ul><li>Avoid all comments.  Comments in random places cause bizarre behavior<br>
<blockquote>and inscrutible error messages.<br>
</blockquote></li><li>In programs (in particular, in "datalines"), lines longer than 127<br>
<blockquote>characters (assuming 8-character tabs) are silently discarded.<br>
</blockquote></li><li>In "infile" files, tab characters cause confusion; untabify.</li></ul>

SAS tips:<br>
Run SAS:<br>
<ul><li>using GUI:  sas<br>
</li><li>from command line:   sas myfile.sas<br>
Data input:<br>
</li><li>skip first observation (first line):<br>
<blockquote>infile 'blah.dat' firstobs=2;<br>
</blockquote></li><li>allow for really long records:<br>
<blockquote>infile 'blah.dat' lrecl=2000;<br>
</blockquote></li><li>data values must be space-separated (tabs cause problems on some systems)<br>
New data set which is a subsets of the original data:<br>
</li><li>data bigx; set orig;<br>
<blockquote>if x > 10;<br>
</blockquote></li><li>data nocontrol; set orig;<br>
<blockquote>if trt = 'control' then delete;<br>
When comparing strings, use only the first 8 characters (!):  not<br>
</blockquote><blockquote>if treat = 'non_partic' then treat_numeric = 0;<br>
</blockquote><blockquote>but<br>
<blockquote>if treat = 'non_part' then treat_numeric = 0;<br>
Subgroups of a data set:  must be sorted before invoking "proc means"<br>
</blockquote></blockquote></li><li>proc sort; by sex trt;<br>
</li><li>proc means; by sex trt;<br>
Procecure return values:<br>
</li><li>proc means noprint;<br>
<blockquote>var x y;<br>
output out=b mean=mx my std=sx sy;  /<b>output means and SD for x,y</b>/<br>
Interaction plot:  plot of the average values of y for each period and trt.<br>
</blockquote></li><li>proc sort; by period trt;<br>
<blockquote>proc means noprint; by period trt;<br>
<blockquote>var y;<br>
output out=means mean=my;<br>
</blockquote>proc plot;<br>
<blockquote>plot my*period=trt;<br>
Proc GLM permits using both regressor (continuous) type variables and<br>
</blockquote></blockquote><blockquote>categorical (class) variables as independent variables.  However, the<br>
dependent variable must be continuous.<br>
Furthermore, no variable noted in the "class" section may be (always missing).<br>
The chi-square test is good for nominal (categorical, class) independent<br>
and dependent variables.<br>
Three-way anova with all interactions:<br>
</blockquote></li><li>proc anova;<br>
<blockquote>class a b c;<br>
model y = a b c a*b a*c b*c a*b*c;<br>
</blockquote></li><li>proc anova;       /<b>shorthand</b>/<br>
<blockquote>class a b c;<br>
model y = a | b | c;<br>
Multivariate methods (manova) may be <b>less</b> powerful than univariate ones<br>
</blockquote><blockquote>if responses are <b>not</b> correlated.<br>
Frequency tables: proc freq<br>
</blockquote></li><li>proc freq;<br>
<blockquote>tables sex;   /<b>one-way table</b>/<br>
</blockquote></li><li>proc freq;<br>
<blockquote>tables infilt*score;   /<b>two-way table</b>/</blockquote></li></ul>

zip -r foo foo<br>
makes a zip archive named foo.zip, which contains directory foo and all its<br>
contents.<br>
<br>
To uuencode a file:   uuencode filename filename > filename.UUE<br>
<br>
Use unzip to extract files from zip/pkzip archives.<br>
<br>
finger crashes on NIS clients when the GECOS field of the NIS-entry is<br>
blank and the user home directories is chmod'd to 700.  (as of 1/2002)<br>
<br>
To compute a file's checksum, use "sum" or "cksum" or "md5sum".<br>
For an entire directory, "md5deep" works.<br>
<br>
A way to find typos and grammar errors in papers:  run ps2ascii on a<br>
(one-column) PostScript file, then paste the result into Microsoft Word and<br>
run its grammar checker.<br>
<br>
If the crontab log says "bad user", that typically means that the password<br>
is expired.  On marjoram, we fixed this (maybe) by adding an entry (with an<br>
in-the-future expiration time) to /etc/shadow, though it really should have<br>
been in /etc/shadow.local.  Other possibilities:<br>
<ul><li>account is not locked<br>
</li><li>password is not expired<br>
</li><li>pwck does not complain about the account<br>
</li><li>account is in /etc/cron.d/cron.allow<br>
</li><li>or maybe (probably not) that the command was run and exited with a<br>
<blockquote>return status of 1 (maybe the command wasn't in the path when cron ran?)</blockquote></li></ul>

Sometimes a single NFS client cannot see a directory when other clients of<br>
the same server can see the directory.  A workaround is to run 'rmdir' on<br>
the troublesome directory; this seems to fix the problem.<br>
<br>
Valgrind is a free, good Purify-like detector of memory errors (for x86<br>
Linux only).  It's better than what is built into gcc.<br>
<a href='http://developer.kde.org/~sewardj/'>http://developer.kde.org/~sewardj/</a>

To see the equivalent of a yppasswd entry for user foo, do<br>
"ypmatch foo passwd" or "ypcat passwd | grep -i foo" or "~/bin/getpwent foo".<br>
Or, at MIT LCS, do "inquir-cui" at mintaka.lcs.mit.edu.<br>
<br>
To encrypt/decrypt with blowfish:<br>
<pre><code>  openssl enc -bf -e -in file -out file.bfe<br>
  openssl enc -bf -d -in file.bfe -out file.decrypted<br>
</code></pre>
Optional argument:  -k secretkey<br>
For rc4 (which is insecure), change -bf to -rc4<br>
<br>
Greg Shomo recommends that one use RPM to install anything that was<br>
included in the original (Red Hat) Linux distribution:  bugfixes and<br>
updates.  He recommends using source to install any new programs.<br>
He recommends installing package foo-1.2 with<br>
<pre><code>  ./configure --prefix=/usr/local/pkg/foo/foo-1.2<br>
</code></pre>
then using gnu stow (<a href='ftp://ftp.gnu.org/gnu/stow/stow-1.3.3.tar.gz'>ftp://ftp.gnu.org/gnu/stow/stow-1.3.3.tar.gz</a>) to make<br>
the proper symlinks into that subdirectory.<br>
<br>
Don't use the "follow" option in Unison, which can delete the real file<br>
behind a symbolic link in ~/.synchronized -- see my Unison files for details.<br>
<br>
After adding a script to /etc/rc.d/init.d, add two symbolic links to<br>
/etc/rc.d/rcN.d/.<br>
The one starting with "S" (start) is invoked when runlevel N is entered.<br>
The one starting with "K" (kill) is invoked when runlevel N is exited.<br>
<br>
At LCS, to upgrade a Red Hat Linux machine with the latest security (or<br>
other) patches:<br>
<pre><code>  # Prepare (can always determine mount point by executing<br>
  # '/usr/sbin/showmount -e coua.lcs.mit.edu')<br>
  mount coua.lcs.mit.edu:/scratch /mnt<br>
  # Check status (a nice list of the rpms that require "freshening")<br>
  # (Does this script need to have "/i686" appended to its pathnames?)<br>
  /mnt/bin/amIUp2Date<br>
  # Update<br>
  cd /mnt/mirror.techsquare.com/redhat-7.2-ia32/suggested/i686<br>
  # Don't do "rpm -Fvh *.rpm"!  Select all the rpms *except* for anything<br>
  # XFree86*, since my laptop's hardware isn't supported and that will prevent<br>
  # X from starting.<br>
  rpm -Fvh `\ls *.rpm | grep -v XFree86`<br>
  # Unmount<br>
  cd /<br>
  umount /mnt<br>
</code></pre>

"chmod g+s dirname" sets the directory's SGID bit/attribute.  Files created<br>
in that directory will have their group set to the directory's group.<br>
Directories created in that directory also have their SGID bit set.<br>
(The SGID bit has nothing to do with the sticky bit.)<br>
<br>
/usr/lib/ical/v2.2/contrib/ contains hacks for ical.<br>
<br>
lpr can assign "classes" or priorities to jobs.  For instance, to bypass<br>
all other jobs in the queue, do "lpr -C Z <i>filename</i>" (Z is the highest<br>
priority/class).<br>
<br>
If trying to print results in the error<br>
<blockquote>lpr: error - scheduler not responding!<br>
then make sure that your PRINTER environment variable is properly set.</blockquote>

ispell that requires only one argument at a time:<br>
<pre><code>foreach file (*.tex)<br>
  ispell $file<br>
end<br>
</code></pre>

To run VNC:<br>
<pre><code>  vncviewer `cat ~/.vncip`<br>
</code></pre>

Samba's smbclient lets you access your NT files (at UW, Solaris, Linux,<br>
AIX), eg:<br>
smbclient '\\rfilesrv1\students' -W cseresearch<br>
<br>
Run smbpasswd to set samba passwords (there is a separate password file for<br>
them).<br>
<br>
To make Samba work from certain locations, I must first edit<br>
/etc/samba/smb.conf to add those IP addresses in the "hosts allow" section.<br>
Also edit /etc/hosts.allow similarly.<br>
<br>
To execute a command on all the PAG clients:<br>
<pre><code>  pagdo sudo &lt;full-path-to-that-command &amp;&amp; args&gt;<br>
</code></pre>
(But that command apparently can't be "emacs", as the X connection gets<br>
rejected due to "wrong authentication.  Also, apparently don't include ";"<br>
to split multiple commands; use multiple "pagdo sudo" commands.)<br>
This requires typing my password N times for N machines.<br>
To make this easier, we could add a /root/.ssh/authorized_keys file to each<br>
client which includes (y)our public key and use "root@" in the ssh command<br>
in pagdo.<br>
<br>
/etc/sudoers says<br>
<pre><code>  # This file MUST be edited with the 'visudo' command as root.<br>
</code></pre>
But the visudo command just does file-locking and checks for syntax errors;<br>
it's fine to edit the file with another editor.<br>
<br>
Combinatorial games suite (supersedes David Wolfe's package):<br>
<a href='http://cgsuite.sourceforge.net/'>http://cgsuite.sourceforge.net/</a>

To have a mount re-done at each reboot:<br>
Put in /etc/fstab<br>
<pre><code>  jbod.ai.mit.edu:/fs/jbod1/mernst-temp /mnt/dtrace-store nfs     defaults       \<br>
 0 0<br>
</code></pre>
(And you can also issue just "mount /mnt/dtrace-store" now.)<br>
This particular mount requires that the following appear in /etc/hosts.allow:<br>
<pre><code>  ALL: 128.52.0.0/255.255.0.0<br>
</code></pre>

Delta debugging appliation, written in perl:<br>
<blockquote><a href='http://daniel-wilkerson.appspot.com/;'>http://daniel-wilkerson.appspot.com/;</a> look for "Delta", under "Software"<br>
Or, at pag: ~smcc/bin/delta<br>
Also, Zeller's Python implementation is at:<br>
<a href='http://www.st.cs.uni-sb.de/dd/'>http://www.st.cs.uni-sb.de/dd/</a></blockquote>

To exit the vi or vim editor:<br>
<pre><code> :q<br>
</code></pre>
To exit without saving changes:<br>
<pre><code> :qa!<br>
</code></pre>
For help:<br>
<pre><code> :help<br>
</code></pre>

To find a meeting time that fits with everyone's schedule, consider using:<br>
<blockquote>~mernst/bin/share/schedule<br>
on a file containing lines such as<br>
<pre><code>  mernst  TR12:30-3,R4-5,W9-5  MR12-1<br>
  notearly MTWRF9-10<br>
  cpacheco  MW1-4 TR9:30-11<br>
  awilliam  T11-4,W11:30-1:30,R11-3,R4-5,F10-12  M11-12,F12-4:30<br>
  smcc  R1-2,R4-5<br>
  jhp     MW9:30-11,F2-3<br>
  akiezun TR11:00-3,F10-12:30<br>
  artzi TR10-17,F10-12<br>
  pgbovine MWF1-4,T4:30-5:30,R1-2<br>
  galen F12:30-1:30<br>
  tschantz MW10:30-4,F10-11<br>
  chenx05 M12-5,TR9:30-11,TR12-1,TR2-5:30,W1-3,F11-3<br>
  mao F9-5<br>
</code></pre>
But you can also use a web survey such as doodle.com</blockquote>

Parallel/distributed jobs across many machines:<br>
<ul><li>The distcc compiler permits compilation jobs to be distributed (in<br>
<blockquote>parallel) across many machines.  See <a href='http://distcc.samba.org/'>http://distcc.samba.org/</a>.<br>
</blockquote></li><li>Another useful tool for speeding up compilation is ccache; to use it,<br>
<blockquote>change the "CC=gcc" line in your Makefile to be "CC=ccache gcc".<br>
</blockquote></li><li>"drqueue", the distributed renderer queue; I'm not sure how<br>
<blockquote>rendering-specific it is.<br>
</blockquote></li><li>There are two add-ons to GNU make:<br>
<ol><li>The customs library; read about it in the make distro in README.customs.<br>
<blockquote>(It will ask you to download pmake from<br>
<a href='ftp://ftp.icsi.berkeley.edu/pub/ai/stolcke/software/'>ftp://ftp.icsi.berkeley.edu/pub/ai/stolcke/software/</a>, among other things.)<br>
</blockquote></li><li>The GNU make port to PVM: <a href='http://www.crosswinds.net/~jlabrous/GNU/PVMGmake/'>http://www.crosswinds.net/~jlabrous/GNU/PVMGmake/</a>
<blockquote>More about PVM: <a href='http://www.epm.ornl.gov/pvm/'>http://www.epm.ornl.gov/pvm/</a>
</blockquote></li></ol></li><li>OpenPBS: <a href='http://www-unix.mcs.anl.gov/openpbs/'>http://www-unix.mcs.anl.gov/openpbs/</a></li></ul>

Firefox extensions (.xpi files): to install, open them in Firefox.<br>
Adblock: <a href='http://adblock.mozdev.org/'>http://adblock.mozdev.org/</a>
Firefox Adblock filter list: <a href='http://www.geocities.com/pierceive/adblock/'>http://www.geocities.com/pierceive/adblock/</a>
(Must update by hand via "Tools > Adblock > Preferences > Adblock Options<br>
>> Import filters".)<br>
Also get the Adblock filter updater extension.<br>
<br>
In Firefox, setting "font.name.serif.x-western" to "sans-serif" (do this in<br>
about:config, or (easier) via Edit >> Preferences >> Content >> Fonts &<br>
Colors >> Default Font) causes webpages to appear in sans serif font by<br>
default.  It also makes webpages print in sans serif, which is not<br>
necessarily desirable:  sans serif is easier to read on screen, but serif<br>
is easier to read on paper.  I wish there was an easy way to get both of<br>
those features.<br>
<br>
If Firefox or Thunderbird says that a copy is already running, but that<br>
doesn't seem to be the case, then find and delete the file .parentlock<br>
somewhere under  ~/.mozilla or ~/.mozilla-thunderbird .<br>
<br>
In Firefox, to make searches ("find") default to case-insensitive:<br>
Press Ctrl+F , the quick find appears at taskbar.<br>
Uncheck the Match case check box<br>
<br>
If Firefox behaves badly (doesn't go to homepage, address bar doesn't<br>
update, back button doesn't work), try moving your ~/.mozilla directory<br>
aside, because one of your plugins may be corrupting Firefox.<br>
<br>
vi commands:<br>
:q quits vi after a file has been saved<br>
:q! quits vi without saving the file<br>
:x saves the file and quits vi<br>
:wq saves the file and quits vi<br>
<br>
To start up network on Linux laptop (for NIC; not necessary for PCMCIA):<br>
Debian:<br>
<pre><code>  /sbin/ifup eth 0<br>
</code></pre>
Red Hat:<br>
<pre><code>  /etc/sysconfig/network-scripts/ifup eth0<br>
</code></pre>

To set wireless card SSID and key, run (as root):<br>
<pre><code>  /sbin/iwconfig eth1 essid "Chaos"<br>
  /sbin/iwconfig eth1 key 03-ef-etc.<br>
  /sbin/iwconfig eth1 key "s:asfd"<br>
</code></pre>
To see your current settings:<br>
<pre><code>  /sbin/iwconfig eth1<br>
</code></pre>


Use the rss2email program as follows:<br>
First, run<br>
<pre><code> r2e new mernst@csail.mit.edu<br>
</code></pre>
but don't re-run that as it blows away all configuration files.<br>
Then, run one of<br>
<pre><code> r2e add 'http://forum6170.csail.mit.edu/index.php?type=rss;action=.xml'<br>
 r2e add 'http://forum6170.csail.mit.edu/index.php?type=rss;action=.xml;limit=255'<br>
 r2e add 'http://cathowell.blogspot.com/feeds/posts/default?alt=rss'<br>
</code></pre>
and finally, nothing happens unless I run<br>
<pre><code> r2e run<br>
</code></pre>
periodically -- say, every minute or hour in a cron job.<br>
<br>
To make the junit task work in Ant without setting classpath, use the hack from:<br>
<a href='http://wiki.osuosl.org/display/howto/Running+JUnit+Tests+from+Ant+without+making+classpath+changes'>http://wiki.osuosl.org/display/howto/Running+JUnit+Tests+from+Ant+without+making+classpath+changes</a>

To list the projects (top-level targets) in an Ant build.xml file, do either of:<br>
<pre><code>  ant -projecthelp<br>
  ant -p<br>
</code></pre>

To get the current working directory from an ant file:<br>
<pre><code>  ${bsh:WorkDirPath.getPath()}<br>
</code></pre>


To print a reasonable map from google maps do the following:<br>
<ul><li>execute 'import map.jpg'<br>
</li><li>Draw a rectangle over the part of the map you want.  The result will<br>
<blockquote>be saved in map.jpg<br>
</blockquote></li><li>execute 'gimp map.jpg'<br>
</li><li>print from gimp.  Gimp does a nice job of laying the jpeg out on<br>
<blockquote>the screen and allows you to scale it and the like.</blockquote></li></ul>

To get a list of LaTeX files that are \inputted (not \included) in a LaTeX<br>
file, for use in making a tags table or in a Makefile or Ant build.xml file:<br>
<pre><code>  TEX_FILES=$(shell latex-process-inputs -list main.tex)<br>
</code></pre>
or, to run tags directly:<br>
<pre><code>  etags `latex-process-inputs -list main.tex`<br>
</code></pre>

To run VMware tools:<br>
<pre><code>  vmware-toolbox &amp;<br>
</code></pre>
To install VMware tools, see ~mernst/wisdom/build/build-vmware<br>
<br>
Information on how to configure our ESX VMware servers is available<br>
in PAG logistics at:  <a href='http://groups.csail.mit.edu/pag/pag/esx.html'>http://groups.csail.mit.edu/pag/pag/esx.html</a>

In VMware, shared folders from the host appear in /mnt/hgfs/.<br>
<br>
To create a transparent signature stamp:<br>
<ul><li>scan a hardcopy of my signature<br>
</li><li>clean it up (in Paint or in the Gimp)<br>
</li><li>use Gimp to make the background transparent:<br>
<ul><li>menu > layer > transparency > add alpha channel<br>
</li><li>click on the fuzzy selector tool<br>
</li><li>for each area to remove, select it, then "edit > clear" (ctrl + k)<br>
</li><li>save as gif or png<br>
</li></ul><blockquote>(instructions from <a href='http://www.fabiovisentin.com/tutorial/GIMP_transparent_image/gimp_how_to_make_transparent_image.asp'>http://www.fabiovisentin.com/tutorial/GIMP_transparent_image/gimp_how_to_make_transparent_image.asp</a>)<br>
</blockquote></li><li>Imagemagick's "convert" program didn't work, so convert the gif or png to<br>
<blockquote>PDF with Acrobat Professional<br>
</blockquote></li><li>Convert the PDF to EPS via imagemagick's "convert" program (other<br>
<blockquote>techniques might work, too)</blockquote></li></ul>

When you have a PDF file that is marked up with annotations, you can either<br>
view the annotation text one-by-one in a PDF reader, or you can create a PDF<br>
file that contains the annotations visibly.  Different people prefer the<br>
two approaches, and some PDF readers such as Evince don't seem to provide<br>
any way to view the annotations.<br>
Here is how to create a PDF that shows the annotation text:<br>
<ul><li>Using Acrobat Reader: start Print, then select "Summarize Comments" near<br>
<blockquote>the upper right corner of the print dialog.  That pops up another print<br>
dialog, where you can finally print or save to PDF.  The final PDF has<br>
alternating pages of the original document and the comments, with each<br>
annotation in the original document cross-referenced to the comments page.<br>
</blockquote></li><li>In Acrobat Professional:  Review & Comment >> Summarize Comments<br>
<blockquote>This can draw lines between the annotations in the original document and<br>
the comments, or print in other ways such as the way Acrobat Reader does.<br>
(The free version of Foxit Reader 5.4 can create a separate document that<br>
lists all the comments, but it doesn't indicate the location in the<br>
original document as the Adobe Acrobat tools do.)</blockquote></li></ul>

To make a screencast video demo (i.e., screen capture/recording from a<br>
running program), Marat Boshernitsan recommends<br>
Camtasia Studio from TechSmith (<a href='http://www.techsmith.com/camtasia.asp'>http://www.techsmith.com/camtasia.asp</a>).<br>
(It's a full suite of tools and has affordable educational pricing.)<br>
Marat Boshernitsan says,<br>
<blockquote>My biggest piece of advice is to edit heavily for length and to add as<br>
many visual annotations to the video as possible.  Camtasia's<br>
video-editing component allows the user to extract all pauses (as short<br>
as a fraction of a second) from the video to create a smooth-flowing<br>
presentation.  Their annotation tools enable insertion of highlights and<br>
callouts to focus the viewer's attention on the important areas of the<br>
screen.  I prefer screen annotations to voiceovers, because they allow<br>
watching the video without reaching for headphones.<br>
To see an example, click on one of the demo links on this page:<br>
<a href='http://nitsan.org/~maratb/blog/2007/05/01/aligning-development-tools-with-the-way-programmers-think-about-code-changes/'>http://nitsan.org/~maratb/blog/2007/05/01/aligning-development-tools-with-the-way-programmers-think-about-code-changes/</a>
It is a bit time-compressed to fit into the 5 minute limit imposed by CHI.</blockquote>

If OpenOffice or LibreOffice is trying to restore a file that no longer<br>
exists, press 'escape' at the Recovery window.<br>
<br>
%% More manual, less desirable solution:<br>
% If OpenOffice is trying to restore a file that no longer exists, delete a<br>
% file such as one of these:<br>
% {{{<br>
%   ~/.openoffice.org2/user/registry/data/org/openoffice/Office/Recovery.xcu<br>
%   ~/.openoffice.org/3/user/registry/data/org/openoffice/Office/Recovery.xcu<br>
% }}}<br>
<br>
To print an OpenOffice or LibreOffice Calc spreadsheet (.xls) on one page, first do:<br>
<blockquote>Format > Page > Sheet tab > Scale options > Scaling mode > "Fit print range(s) on number of pages" > Number of Pages: 1<br>
Alternately:<br>
Print preview icon > Format Page > sheet tab > Scaling Mode > Fit print range on page{s}: 1</blockquote>

In OpenOffice, to freeze rows/columns so that they do not scroll but are<br>
always visible, select the row (or cell) below (and to the right of) the<br>
one you want to freeze, then do Window > Freeze.<br>
<br>
Setting up a new USB microphone/headset:  run<br>
<pre><code>  gnome-volume-control<br>
</code></pre>
When the application starts, choose the default device and unmute both the<br>
headphones <b>and</b> the microphone.<br>
For Skype, under Linux, see<br>
<blockquote><a href='http://www.skype.com/help/guides/soundsetup_linux.html'>http://www.skype.com/help/guides/soundsetup_linux.html</a>
Under Fedora, I had to unset "allow skype to automatically adjust my mixer<br>
levels" lest the recording level was much too low.</blockquote>

On Linux, after plugging in headphones, you have to tell the application<br>
(e.g., Skype) you are trying to use with the headset to use the second<br>
soundcard (card1) in order to get audio over the headphones.<br>
<br>
The "-e" argument to mail means send no mail if the body is empty.  So use<br>
(in csh)<br>
<pre><code>  ${COMMAND} |&amp; ${MAIL} -e -s "${SUBJECT}" mernst &lt; /tmp/mailbody-$$<br>
</code></pre>
instead of<br>
<pre><code>  ${COMMAND} &gt; /tmp/mailbody-$$<br>
  if (!(-z /tmp/mailbody-$$)) ${MAIL} -s "${SUBJECT}" mernst &lt; /tmp/mailbody-$$<br>
  \rm -f /tmp/mailbody-$$<br>
</code></pre>

mkpasswd: generate one random password<br>
pwgen -N1: generate one random password<br>
<br>
Server-side includes (SSI) for web pages:<br>
<pre><code>  &lt;!--#include file="filename.html"--&gt;<br>
  &lt;!--#include virtual="/directory/included.html" --&gt;<br>
</code></pre>
Use "file=" for relative filenames, "virtual=" for relative or non-relative<br>
filenames (e.g., an address starting at the server root).<br>
In some cases, you must configure the webserver to preprocess all<br>
pages with a distinctive extension (normally, ".shtml").<br>
UW CSE lets us tweak our .htaccess file such that we can have<br>
all regular .html files get this behavior, not just .shtml files.  See the<br>
WASP webpages for an example.<br>
<br>
The "rev" program reverses the order of characters in every line of input.<br>
It's the way to reverse all lines of a file.<br>
To sort lines, with the sort key being the reverse of each line:<br>
<blockquote>cat myfile | rev | sort -r | rev</blockquote>

"cd -" connects to your previous directory.<br>
<br>
When printing a blog (or some other types of webpages) from Firefox, often<br>
only the first page is printed:  each blog post is one box, but overflowed<br>
boxes are invisibly hanging off the page instead of ontinued to the next<br>
page.  This is due to a problem in the blog's .css file.<br>
Here are two fixes:<br>
<ol><li>Permit wrapping text across pages:  remove<br>
<pre><code>      &lt;div class="contenttext"&gt;<br>
</code></pre>
<blockquote>Also, get rid of sidebars so the blog content prints full width:  remove<br>
<pre><code>      &lt;div id="leftside"&gt;<br>
</code></pre>
through<br>
<pre><code>      &lt;div class="post"&gt;<br>
</code></pre>
(inclusive).<br>
</blockquote></li></ol><blockquote>2. Fix the .css file.  Copy the blog locally:<br>
<pre><code>      wget -O localfile.html URL<br>
</code></pre>
<blockquote>and also copy its .css file locally.<br>
Edit the .css file to contain:<br>
<pre><code>      * {<br>
      overflow: visible !important;<br>
      }<br>
</code></pre>
</blockquote><blockquote>and edit the .html file to reference the local version of the .css file.</blockquote></blockquote>

The canonical @sys directory for your path is<br>
<pre><code>  $HOME/bin/`uname`-`uname -m`<br>
</code></pre>

When a sh/bash script wishes to pass one of its arguments to another<br>
program, it's necessary to quote those arguments so they are not<br>
re-interpreted (and in particular, so that embedded spaces do not cause an<br>
argument to be split into two).  A way to do this is to surround the<br>
argument by spaces, and then call the other program with "eval" instead of<br>
directly:<br>
<pre><code>  eval other-program "${my_variable}"<br>
</code></pre>

To determine which version of RedHat/Fedora I am running:<br>
<pre><code>  cat /etc/redhat-release <br>
</code></pre>

Make has two flavors of variables that may appear in a Makefile.<br>
The normal type is recursively expanded, re-evaluated on each use:<br>
<pre><code>     foo = $(bar)<br>
</code></pre>
The GNU-specific type is simply expanded, set once when the assignment is<br>
encountered.<br>
<pre><code>     x := foo<br>
</code></pre>

To make the history command show times, do this:<br>
export HISTTIMEFORMAT='%Y-%b-%d::%Hh:%Mm:%Ss '<br>
export HISTTIMEFORMAT='%Hh:%Mm:%Ss '<br>
That can be useful for seeing how long a command took to run, if another<br>
command is issued immediately afterward.<br>
<br>
In Acrobat (not reader), to fill in a form, either:<br>
<ul><li>use the typewriter tool, or<br>
</li><li>ctrl-left-click (this is easier from a unability point of view)</li></ul>

To give up and uninstall a package installed by encap/epkg:<br>
<pre><code>    cd /uns/encap<br>
    epkg -i $pkg<br>
</code></pre>

"ack" is like "grep -r" or "search", but claims to be more flexible.<br>
<blockquote>I've given up using it, though; I find search more featureful and less buggy.<br>
A problem is that unlike the "search" program, it does not seach in<br>
compressed (.gz, .Z) files.<br>
You should always run ack with the --text option (put that in an alias or in<br>
.ackrc).  Otherwise, ack discards some text files, since by default, text<br>
files (and also binary and "skipped") are not considered interesting (!),<br>
but everything else is.  Turning on text, turns off every other type, but<br>
the files get searched anyway since they are considered text as well as<br>
their other file type.<br>
To get a list of files ack is searching (-f means print all files searched):<br>
<pre><code>  ack -f<br>
</code></pre></blockquote>

To perform an advanced search of messages in thunderbird, goto<br>
edit->find->search-messages<br>
<br>
Pidgin (previously GAIM) is a Linux IM client that can interoperate with<br>
Google Talk.<br>
<br>
An uninterrupted Hudson build has one of the following statuses:<br>
<ul><li>Failed - it doesn't compile<br>
</li><li>Unstable - compiles without errors, but tests fail<br>
</li><li>Stable - compiles without errors and all the tests are passing<br>
A manually interrupted Hudson job gives a message like "SCM check out aborted".</li></ul>

To make your slow regular expressions (regexps) faster, restrict the number of<br>
different ways the regexp could match the same text.  For example, if<br>
you're trying to match some whitespace followed by all the text until the<br>
end of the line, don't write this:<br>
<blockquote>\s-+.<b><br>
Since the . can match whitespace too, there are as many different ways<br>
to apportion the match between the two subexpressions "\s-+" and ".</b>"<br>
as there are whitespace characters.  Instead, write this:<br>
\s-.<b><br>
Although this regexp matches exactly the same set of strings, there is<br>
now only one way to match:  the "\\s-" matches the first whitespace<br>
character, and ".</b>" matches the rest.  This runs faster.</blockquote>

To convert a Perl program with POD ("plain old documentation") embedded<br>
documentation into a man page, run pod2man.  For example:<br>
<pre><code>  pod2man my-script.pl | nroff -man <br>
</code></pre>

To resolve a symbolic link to its true name (truename), use <code>readlink</code>.<br>
<br>
The <code>curl</code> program displays an annoying progress meter.  To disable it<br>
without also suppressing errors, use <code>curl -s -S</code>.<br>
<br>
If running <code>dropbox.py start -i</code> yields<br>
<pre><code>  To link this computer to a dropbox account, visit the following url: ...<br>
</code></pre>
then run:<br>
<pre><code>  dropbox.py stop<br>
  dropbox.py start -i<br>
</code></pre>

To get the current date in a sortable numeric format:<br>
<pre><code>  date +%Y%m%d<br>
</code></pre>
To get yesterday's date:<br>
<pre><code>  date --date yesterday<br>
</code></pre>

To recover a closed tab in Chrome:  Ctrl-Shift-t<br>
<br>
To replace the dictionary in the Android Kindle app:<br>
<ul><li>Not officially supported as of May 2013: <a href='http://www.amazon.com/gp/help/customer/forums/kindleqna/ref=kindle_help_forum_md_pl?ie=UTF8&cdForum=Fx1GLDPZMNR1X53&cdMsgID=Mx3CF5CO3HY68KB&cdMsgNo=60&cdPage=3&cdSort=oldest&cdThread=Tx1TP0PSVB5RMFB#Mx3CF5CO3HY68KB'>http://www.amazon.com/gp/help/customer/forums/kindleqna/ref=kindle_help_forum_md_pl?ie=UTF8&amp;cdForum=Fx1GLDPZMNR1X53&amp;cdMsgID=Mx3CF5CO3HY68KB&amp;cdMsgNo=60&amp;cdPage=3&amp;cdSort=oldest&amp;cdThread=Tx1TP0PSVB5RMFB#Mx3CF5CO3HY68KB</a>
<blockquote>and later messages say that previously-posted solutions in that thread no longer work either<br>
</blockquote></li><li>Another possibility: <a href='http://www.amazon.com/gp/help/customer/forums/kindleqna/ref=kindle_help_forum_md_pl?ie=UTF8&cdForum=Fx1GLDPZMNR1X53&cdMsgID=Mx3SFUQ6LQH79EL&cdMsgNo=72&cdPage=3&cdSort=oldest&cdThread=Tx1TP0PSVB5RMFB#Mx3SFUQ6LQH79EL'>http://www.amazon.com/gp/help/customer/forums/kindleqna/ref=kindle_help_forum_md_pl?ie=UTF8&amp;cdForum=Fx1GLDPZMNR1X53&amp;cdMsgID=Mx3SFUQ6LQH79EL&amp;cdMsgNo=72&amp;cdPage=3&amp;cdSort=oldest&amp;cdThread=Tx1TP0PSVB5RMFB#Mx3SFUQ6LQH79EL</a>
</li><li>if you have an Internet connection: <a href='http://ebookfriendly.com/translate-words-in-kindle-app/'>http://ebookfriendly.com/translate-words-in-kindle-app/</a>
</li><li>A Spanish-to-Spanish dictionary is already be installed with the app</li></ul>

For RBCommons, you can submit a review by either downloading their command-line tools, <a href='http://www.reviewboard.org/downloads/rbtools/'>http://www.reviewboard.org/downloads/rbtools/</a>, or by uploading a diff on their webpage.<br>
<br>
To compress a JPEG file:<br>
<pre><code>  convert input.jpg -quality nn output.jpg <br>
</code></pre>
where nn is between 1 and 100.  1 is the lowest quality (highest<br>
compression).<br>
<br>
An alternative to markdown, for GitHub-style markdown format, is <code>grip</code>
(after which browse to localhost:5000 , but that hung my Emacs when I tried<br>
it) or <code>grip --export</code> which exports to <code>&lt;path&gt;.html</code>.<br>
<br>
<br>
<hr />
<a href='Hidden comment: 
Please put new content in the appropriate section above, don"t just
dump it all here at the end of the file.
'></a>