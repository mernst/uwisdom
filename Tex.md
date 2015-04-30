<a href='Hidden comment: 
% Each entry should contain one of the words "TeX", "LaTeX", "BibTeX", etc.

% PROBLEM with this file is that TeX comments starting in column 1 will be
% ignored by the database searching program!  Therefore, put a space before
% any "%" character that is part of an entry.
'></a>


Contents:



---

# Figures (floats) #

In LaTeX, always put a \protect in front of a \ref in a \caption.

In LaTeX, to get a line between floats (figures, tables, etc.) and text, do
something like (these must take up zero vertical space):
```
 % Add line between figure and text
 \makeatletter
 \def\topfigrule{\kern3\p@ \hrule \kern -3.4\p@} % the \hrule is .4pt high
 \def\botfigrule{\kern-3\p@ \hrule \kern 2.6\p@} % the \hrule is .4pt high
 \def\dblfigrule{\kern3\p@ \hrule \kern -3.4\p@} % the \hrule is .4pt high
 \makeatother
```
In ACM styles that add a line between the figure and the caption,
additionally do
```
 \nocaptionrule
```
Once you have the line, you can consider reducing `\floatsep`:
```
 % Reduce space between figures and text
 \addtolength{\textfloatsep}{-.5\textfloatsep}
 \addtolength{\dbltextfloatsep}{-.5\dbltextfloatsep}
 % Optional
 \addtolength{\floatsep}{-.5\floatsep}
 \addtolength{\dblfloatsep}{-.5\dblfloatsep}
```

<a href='Hidden comment: 
% Can"t unindent the LaTeX comments or the doc program will respect those
% comments.  That"s unfortunate, because I typically unindent when inserting
% in a LaTeX document.
'></a>
To prevent having just a couple of figures, and lots of white space, on a
page produced by LaTeX, do the following.  Also consider making it 90%.
```
 % At least 80% of every float page must be taken up by
 % floats; there will be no page with more than 20% white space.
 \def\topfraction{.8}
 \def\dbltopfraction{\topfraction}
 \def\floatpagefraction{\topfraction}     % default .5
 \def\dblfloatpagefraction{\topfraction}  % default .5
 \def\textfraction{.2}
```

To fix "too many unprocessed floats" error, do one of the following:
  * spread your figures further apart in your document, or
  * put in a \clearpage or \cleardoublepage command to allow a page full of figures to be generated.

The change in font size of a LaTeX figure caption won't take unless you give an
empty optional argument, like so:
\caption[.md](.md){{\small Small caption}}
But, I think that does not adjust the inter-line spacing in the caption, so don't use that approach.

To get inter-line spacing right in LaTeX figure captions that are set smaller than
body text:
In the paper, do
```
  \renewcommand{\captionfont}{\small}
```
or
```
  \renewcommand{\captionfont}{\small\bf}
```
and use the following definition of \captionfont:
```
\newcommand{\captionfont}{\bf}
\long\def\@makecaption#1#2{
   \vskip \baselineskip
   \setbox\@tempboxa\hbox{\captionfont{#1: #2\strut}}
   \ifdim \wd\@tempboxa >\hsize % IF longer than one line:
       {\captionfont\noindent\parbox{\hsize}{#1: #2\strut}}\par     %   THEN set as ordinary paragraph.
     \else                      %   ELSE  center.
       \hbox to\hsize{\hfil\box\@tempboxa\hfil}
   \fi}
```


---

# Tables #

To reduce intercolumn space in tables:
```
  \addtolength{\tabcolsep}{-.5\tabcolsep}
  \setlength{\tabcolsep}{0pt}
```

Aligning decimal points (periods) in tables in TeX/LaTeX:
use dcolumn package (described in the LaTeX Companion).
In particular:
```
  \usepackage{dcolumn}
  % dcolumn customization
  \newcolumntype{d}[1]{D{.}{.}{#1}} % argument is number of decimal places
  \newcolumntype{.}{d{1}} % "1" means one digit after the decimal point
  \newcolumntype{.}{d{-1}} % "-1" means center the decimal point in the column; ugly
  \newcolumntype{.}{d{0}} % "0" means decimal point is right-justified, not so different from right-justifying the column
  \newcolumntype{.}{d{5.1} % 5 places to the left of the decimal, one to the right
```
and then use "." as a column separator, much like "c".
These column separators do not check the number of decimal points in the
table itself.  Thus, using a value other than -1 can leave additional space
at the right side of the column, or let extra digits after the decimal
point lap into the next column.

To put a footnote within a table in LaTeX, surround the table with a minipage:
```
  \begin{minipage}{\textwidth}
  \begin{tabular}{ccc}
  1 & 2 & 3\footnote{Nothing important}\\
  4 & 5 & 6
  \end{tabular}
  \end{minipage}
```

To make entries in a LaTeX "tabular" table that span multiple columns,
as with the HTML "colspan" attribute, use an entry like
```
   \multicolumn{3}{l}{text}
```
where 3 is the number of columns to span, and "l" is the alignment of
the spanning contents. \multicolumn seems to want to insert
inter-column spacing around the contents even if you've tried to
disable it in the header line with @{} (or @{your amount of space}),
but you can override it by putting a negative version of the space on
the **inside** of the multicolumn, as in:
```
   \multicolumn{3}{l}{\hskip-\tabcolsep...}
```
To span multiple rows (as with the HTML "rowspan" attribute), use
\multirow:
```
  \usepackage{multirow}
  \multirow{nrows}[bigstruts]{width}[fixup]{text}
```
Multirow documentation is at
http://mirror.math.ku.edu/tex-archive/macros/latex/contrib/multirow/multirow.sty
The width is a size like "25mm" or "**" for "vertically centered".
The rows that don’t contain the "multi-row" specification must have empty
cells where the multi-row is going to appear.
\multirow requires use of the multirow package:
You can nest \multirow in \multicolumn but not vice versa.**



---

# Displays #

To intersperse left-justified text with aligned equations, use the TeX
\noalign primitive. For example,
```
  \begin{eqnarray}
  test & 1 & 2 \\
  \noalign{\hbox{left}}
  test & 3 & 4
  \end{eqnarray}
```
produces results like the following:
```
            test  1  2       (1)
  left
            test  3  4       (2)
```

Use
```
  \setlength{\arraycolsep}{.25em}
```
to reduce/compress the horizontal spaces (as around equal signs) between
columns in a LaTeX array or eqnarray environment.
Use
```
  \setlength{\tabcolsep}{.5\tabcolsep}
```
to reduce the width of columns in a table or tabular environment.



---

# Lists #

To eliminate LaTeX list/itemize/enumerate spacing between items:
1. From one list:
```
    \begin{itemize}
    \itemsep 0pt \parskip 0pt
    ...
    \end{itemize}
```
> (Since the default values for \itemsep and \parskip are set in a somewhat
> roundabout way, putting "\itemsep=0pt" in the preamble doesn't work.)
2. From all lists:
```
    %% Bring items closer together in list environments
    %% This doesn't work with an optional argument to the list environment.
    % Prevent infinite loops
    \let\Itemize =\itemize    
    \let\Enumerate =\enumerate
    \let\Description =\description
    % Zero the vertical spacing parameters
    \def\Nospacing{\itemsep=0pt\topsep=0pt\partopsep=0pt\parskip=0pt\parsep=0pt}
    % Redefine the environments in terms of the original values
    \renewenvironment{itemize}{\Itemize\Nospacing}{\endlist}
    \renewenvironment{enumerate}{\Enumerate\Nospacing}{\endlist}
    \renewenvironment{description}{\Description\Nospacing}{\endlist}
```
> > This doesn't work with an optional argument to the list environment,
> > however; if you do, for example,
```
    \begin{enumerate}[$\bullet$]
```
> > then you need to use the other approach.
3. From all lists:
> > Copy the \itemize (etc.) macros from latex.ltx, and add at the end
> > (before the last "\fi"):
```
    \itemsep 0pt \parskip 0pt
```
4. From all lists:

> PROBLEM:  This can put negative vertical space in some places (e.g., it
> overlaps the list and the following paragraph), so isn't worth the hassle.
> tweaklist (http://dcwww.camp.dtu.dk/~schiotz/comp/LatexTips/LatexTips.html):
```
  % Remove vertical space from between list/itemize/enumerate items.
  \usepackage{tweaklist}
  \renewcommand{\itemhook}{\setlength{\topsep}{-\topsep}\setlength{\itemsep}{-\itemsep}}
  \renewcommand{\enumhook}{\setlength{\topsep}{-\topsep}\setlength{\itemsep}{-\itemsep}}
  \renewcommand{\descripthook}{\setlength{\topsep}{-\topsep}\setlength{\itemsep}{-\itemsep}}
```
5. From all lists, or customize:  see TeX FAQ at
> http://www.tex.ac.uk/cgi-bin/texfaq2html?label=complist

To control pre-list space, set \partopsep (or insert an explicit negative
\vspace (not \vskip)).  (I had to give an explicit argument, not -\parsep
etc.; but `\vspace*{-\partopsep}` worked for me if it came after the
\begin{enumerate}.)  (See manual page 167.)
<br>
To remove the vertical space from between two LaTeX trivlist environments:<br>
<pre><code>   \vspace*{-\topsep}\vspace*{-\partopsep}\vspace*{-\itemsep}<br>
</code></pre>
<blockquote>No combination of only two of these does the trick.<br>
(Why don't I have -\parskip here too?)</blockquote>

To reduce the indentation of a LaTeX list environment (itemize, enumerate,<br>
description), do this <b>outside</b> the env:<br>
<pre><code>  % Reduce indentation in lists.<br>
  \setlength{\leftmargini}{.75\leftmargini}<br>
  \setlength{\leftmarginii}{.75\leftmarginii}<br>
  \setlength{\leftmarginiii}{.75\leftmarginiii}<br>
</code></pre>

In a LaTeX enumerate list environment, to insert an ordinary<br>
(left-justified) paragraph of text without interrupting the item numbering,<br>
do the following:<br>
<pre><code>  \label{item:pre-break}<br>
  \end{enumerate}<br>
  PARAGRAPH GOES HERE.<br>
  \begin{enumerate}<br>
  \setcounter{enumi}{\ref{item:pre-break}}<br>
</code></pre>

To interrupt an enumerate environment, then continue the numbering later:<br>
<pre><code>    \newcounter{saveenumi}<br>
    ...<br>
    \begin{enumerate}<br>
      ...<br>
      \item ...<br>
      \setcounter{saveenumi}{\theenumi}<br>
    \end{enumerate}<br>
    ...<br>
    \begin{enumerate}<br>
      \setcounter{enumi}{\thesaveenumi}<br>
      \item ...<br>
      ...<br>
    \end{enumerate}<br>
</code></pre>

To change the margins similarly to what the quote (<code>\begin{quote}</code>)<br>
environment does:<br>
<pre><code> % Arguments are left and right margins<br>
 \def\changemargin#1#2{\list{}{\rightmargin#2\leftmargin#1}\item[]}<br>
 \let\endchangemargin=\endlist<br>
 \begin{changemargin}{.05\columnwidth}{.05\columnwidth}<br>
 \end{changemargin}<br>
</code></pre>


<hr />
<h1>Defining macros</h1>

Here are ways to test wither a macro argument is empty/null:<br>
<ol><li>The following macro definition will test whether a macro argument is empty:<br>
<pre><code>    \def\mymacro#1{%<br>
     \def\tempa{#1}\ifx\tempa\empty{then-part}\else{else-part}\fi<br>
     }%<br>
</code></pre>
<blockquote>Note that PLAIN.TEX defines \empty as follows:<br>
<pre><code>    \def\empty{}%<br>
</code></pre>
LaTeX defines \@empty in a similar way, if you want to work with .sty files.<br>
Note that since this uses \def to assign the value of #2 to a macro, it<br>
won't work in TeX's mouth, and needs the stomach as well (so it won't work<br>
inside an \edef for example).<br>
</blockquote></li></ol><blockquote>2. This way of testing for null arguments can be done entirely in TeX's mouth:<br>
<pre><code>      \def\showempty#1{\message{\ifx\relax#1\relax empty\else not empty\fi}}<br>
</code></pre>
<blockquote>It does however fail badly if #1 begins with \relax<br>
(e.g., \showempty{\relax...}).<br>
</blockquote>3. Another way of testing for empty arguments in TeX's mouth is to say:<br>
<pre><code>       \ifx\unlikely#2\unlikely ...true text... \else ...false text ... \fi<br>
</code></pre>
<blockquote>This will expand to `true text' iff #2 is empty, or begins with<br>
\unlikely.  So if you make \unlikely an unlikely macro for #2 to begin<br>
with, then you're away.  (It also dies if #2 contains unbalanced \if,<br>
\else or \fi's, but that should be pretty rare.  Touch wood.)</blockquote></blockquote>

LaTeX macros gobble space after them.  If you wish to insert space<br>
(except before punctuation or other places where it shouldn't be<br>
inserted) after a macro expansion, then add "\xspace" at the end of the<br>
macro body.<br>
<pre><code>  \usepackage{xspace}<br>
  ...<br>
  \newcommand{\restenergy}{\ensuremath{mc^2}\xspace}<br>
  ...<br>
  ... and we find \restenergy available to us ...<br>
</code></pre>

Here is a LaTeX command that typesets its argument in a smaller \tt font.  It<br>
permits line breaks at spaces within the argument (but not within words),<br>
respects current series (such as boldface), and works in both horizontal (text)<br>
and math mode.<br>
<pre><code>  \newcommand{\code}[1]{\ifmmode{\mbox{\smaller\ttfamily{#1}}}\else{\smaller\ttfamily #1}\fi}<br>
</code></pre>
Here's a version that takes care of URLs, too:<br>
<pre><code>  \def\codesize{\smaller}<br>
  %HEVEA \def\codesize{\relax}<br>
  \newcommand{\code}[1]{\ifmmode{\mbox{\codesize\ttfamily{#1}}}\else{\codesize\ttfamily #1}\fi}<br>
  \newcommand{\myurl}[1]{{\codesize\url{#1}}}<br>
  %HEVEA \def\myurl{\url}<br>
</code></pre>
Similarly, "\scshape" is generally preferred to "\sc", because it<br>
respects the typesetting of the current context.<br>
For Verbatim environments, do this:<br>
<pre><code>  \usepackage{fancyvrb}<br>
  \RecustomVerbatimEnvironment{Verbatim}{Verbatim}{fontsize=\smaller}<br>
</code></pre>

Use \mathit{...} (or, simpler, \|...|), not $...$, to typeset a<br>
multi-character identifier in LaTeX math mode.  $...$ puts incorrect<br>
kerning between the letters.  (It looks bad, and enough people will notice<br>
that it is worthwhile to get the typesetting right.)<br>
<br>
<a href='Hidden comment: 
% Can"t unindent the LaTeX comments or the doc program will respect those
% comments.  That"s unfortunate, because I typically unindent when inserting
% in a LaTeX document.
'></a><br>
<br>
Here are definitions for identifiers in LaTeX math mode formulas:<br>
<pre><code>  % \|name| or \mathid{name} denotes identifiers and slots in formulas<br>
  \def\|#1|{\mathid{#1}}<br>
  \newcommand{\mathid}[1]{\ensuremath{\mathit{#1}}}<br>
  % \&lt;name&gt; or \codeid{name} denotes computer code identifiers<br>
  \def\&lt;#1&gt;{\codeid{#1}}<br>
  \protected\def\codeid#1{\ifmmode{\mbox{\ttfamily{#1}}}\else{\ttfamily #1}\fi}<br>
</code></pre>
This alternate definition of <code>\codeid</code> does not work inside an array environments (see <a href='http://tex.stackexchange.com/questions/27592/'>http://tex.stackexchange.com/questions/27592/</a> ):<br>
<pre><code>  \newcommand{\codeid}[1]{\ifmmode{\mbox{\ttfamily{#1}}}\else{\ttfamily #1}\fi}<br>
</code></pre>

To permit hyphenation in tt font globally throughout a document, see<br>
<a href='http://tex.stackexchange.com/questions/44361/how-to-automatically-hyphenate-within-texttt'>http://tex.stackexchange.com/questions/44361/how-to-automatically-hyphenate-within-texttt</a>
However, all of those solutions give me a Roman font that differs from the text font, whereas I want a typewriter font.<br>
<code>\usepackage[htt]{hyphenat}</code> doesn't seem to work either.<br>
<br>
<br>
<hr />
<h1>Bibliographies and citations</h1>

Very simple BibTeX usage:<br>
<ol><li>See ~mernst/bib for bibliographies (but you should get your own copy).<br>
</li><li>At beginning of document:   ((Why not at the end?))<br>
<blockquote>\bibliographystyle{alpha}<br>
</blockquote></li><li>Within document:<br>
<blockquote>\cite{key}<br>
</blockquote></li><li>At end of document:<br>
<blockquote>\bibliography{bibstring-unabbrev,invariants,dispatch,generals,alias}<br>
</blockquote></li><li>Run latex, then bibtex, then latex again.</li></ol>

Typical LaTeX commands for bibliography:<br>
<pre><code>  \bibliographystyle{alpha}<br>
  \bibliography{bibstring-unabbrev,ernst,invariants,dispatch,generals,alias}<br>
</code></pre>

\thebibliography is defined in the main document style (article.sty, etc.).<br>
<br>
For multiple bibliographies (say, one per chapter), use chapterbib.sty.<br>
<br>
How can I permit line breaks in a citation?<br>
I'm not sure if this is good style or not, but this is how to do it:<br>
<pre><code> % undo LaTeX's decision to make citation labels be \hbox'd.<br>
 \makeatletter<br>
 \def\@citex[#1]#2{\if@filesw\immediate\write\@auxout{\string\citation{#2}}\fi<br>
   \def\@citea{}\@cite{\@for\@citeb:=#2\do<br>
     {\@citea\def\@citea{,\penalty\@m\ }\@ifundefined<br>
        {b@\@citeb}{{\bf ?}\@warning<br>
        {Citation `\@citeb' on page \thepage \space undefined}}%<br>
 {\csname b@\@citeb\endcsname}}}{#1}}<br>
 \makeatother<br>
</code></pre>

BibTeX journal abbreviations are in /usr/local/lib/tex/bib/abbreviations,<br>
which is pointed to by ~/tex/abbreviations.<br>
<br>
The problem with BibTeX's cross referencing feature is that it puts the<br>
book, proceedings, etc. in the bibliography as an entry of its own.<br>
However, supplying argument -min-crossrefs=10000 disables this feature.<br>
<br>
For mix-n-match BibTeX citations,<br>
<pre><code>  \makeatletter<br>
  \def\bibref#1{\nocite{#1}\@ifundefined{b@#1}{{\bf ??}\@warning<br>
     {Citation `#1' on page \thepage \space <br>
      undefined}}{\@nameuse{b@#1}}}<br>
  \makeatother<br>
</code></pre>
and then<br>
<pre><code>  [\bibref{Horn86},p.86;\bibref{PressFTV88},p.516]<br>
</code></pre>
produces<br>
<blockquote>[50,p.86;75,p.516]<br>
which is better than the<br>
[50,p.86],[76,p.516]<br>
produced by<br>
<pre><code>  \cite[p.~86]{Horn86},\cite[p.~516]{PressFTV88}<br>
</code></pre></blockquote>

In LaTeX, to remove vertical spacing (space) between bibliography items, use:<br>
<pre><code>   \setlength{\bibsep}{0pt}<br>
</code></pre>
before the <code>\biblography</code> command.<br>
<br>
In LaTeX 2e, to adjust bibliography formatting:<br>
(For IEEE styles, just do <code>\def\IEEEbibitemsep{0pt plus .5pt}</code>.)<br>
<blockquote>First, copy from article.cls the definition of<br>
<pre><code>    \newenvironment{thebibliography}[1]<br>
</code></pre>
Surround it by<br>
<pre><code>    \makeatletter<br>
    ...<br>
    \makeatother<br>
</code></pre>
and change the "newenvironment" to "renewenvironment".<br>
To make bibliography items less indented, do one or both of the these:<br>
</blockquote><ol><li>Comment out<br>
<pre><code>       \advance\leftmargin\labelsep<br>
</code></pre>
</li></ol><blockquote>2. Change<br>
<pre><code>       \settowidth\labelwidth{\@biblabel{#1}}%<br>
</code></pre>
<blockquote>to<br>
<pre><code>       \settowidth\labelwidth{~}%<br>
</code></pre>
(though this is a bit drastic).<br>
To remove all vertical spacing (space) between bibliography items, add:<br>
<pre><code>  % These two commands remove inter-bib-item spacing<br>
  \setlength{\itemsep}{0pt}<br>
  \setlength{\parsep}{0pt}<br>
</code></pre></blockquote></blockquote>

To use only first initials (not whole first name) in BibTeX, change "ff" to<br>
"f." in the .bst file, on the line containing "format.name".<br>
Or just use abbrv.bst, which does this.<br>
<br>
To omit the month in BibTeX, change<br>
<code>{ month " " * year * }</code>
to<br>
<code>'year</code>
in the .bst file.<br>
This is rarely worthwhile, though:  the savings tend to be very small.<br>
<br>
<br>
<hr />
<h1>Texinfo</h1>

In Texinfo, to prevent the last index pages from being numbered i, ii,<br>
etc., add an @page before @summarycontents or @contents.<br>
<br>
To format a texinfo file (ie, to produce a .dvi file from a .texi file), do<br>
<pre><code>    tex foo.texi<br>
    texindex foo.??<br>
    tex foo.texi<br>
</code></pre>

Texinfo definitions can be done like this:<br>
<pre><code> @iftex @def@foo ...<br>
</code></pre>
Make sure that any usages of the macro are also put inside @iftex, and<br>
make sure that you provide an equivalent construction inside @ifinfo.<br>
<br>
Help for texinfo:<br>
You might want to check out texinfo, a system for preparing both<br>
high-quality typeset (by TeX) documents and on-line hypertext (viewable<br>
from Emacs or a stand-alone viewer).  It's available from<br>
prep.ai.mit.edu:/pub/gnu/texinfo-2.??.tar.Z.  There's also a latexinfo<br>
system available from<br>
tut.cis.ohio-state.edu:pub/gnu/emacs/elisp-archive/packages/LaTeXinfo.shar.<b>.Z.</b>

LaTeXinfo takes a different input format than LaTeX -- for instance, there<br>
are only three special characters (\{}), so comments are introduced by \c,<br>
and so forth.  Thus, it could be a lot of work to convert a document into<br>
LaTeXinfo.<br>
<br>
Texinfo summary of cross reference commands (@xref @ref @pxref @inforef):<br>
<a href='http://www.gnu.org/software/texinfo/manual/texinfo/texinfo.html#Cross-Reference-Commands'>http://www.gnu.org/software/texinfo/manual/texinfo/texinfo.html#Cross-Reference-Commands</a>

<hr />
<h1>Hyphenization; word, line, and page breaking</h1>

raymond@sunkist.berkeley.edu (Raymond Chen) says:<br>
To prevent word breaking (hyphenation) in (La)TeX, \hypenpenalty=10000<br>
Note, however, that although it'll work, it ain't exactly the nicest<br>
thing to do to your CPU :-)<br>
Reason:  TeX will go ahead and hyphenate all the words in your<br>
paragraph, and consider every possible breakpoint (including the<br>
hyphens it inserted), but when it's just about ready to insert a hyphen,<br>
it looks at \hyphenpenalty and say "Whoa!  Better not do it here."<br>
This is repeated for every hyphenation point in every word of your<br>
paragraph.<br>
A much more polite way to do it is to set the \hyphenchar to a<br>
number not between 0 and 255; typically, -1 is used to suppress<br>
hyphenation.  When the \hyphenchar is set to an invalid number,<br>
TeX skips the hyphenation step altogether.  So you would say<br>
something like<br>
<pre><code>  \hyphenchar\the\font=-1<br>
</code></pre>
to suppress hyphenation for the current font.  If you use several<br>
fonts, you'll want to set the \hyphenchar for each one.  So you<br>
would start off like this:<br>
<pre><code>  \hyphenchar\tenrm=-1<br>
  \hyphenchar\ninerm=-1<br>
  ...<br>
</code></pre>
You'll probably also want to set \defaulthyphenchar=-1 so that any<br>
new fonts that get loaded will also have hyphenation disabled.<br>
.<br>
Another way is<br>
<pre><code>  \pretolerance=10000<br>
</code></pre>
and, if you get complaints about overfull hboxes, also add<br>
<pre><code>  \emergencystretch=2em<br>
</code></pre>
or some bigger value.<br>
<br>
piet@cs.ruu.nl (Piet van Oostrum) says:<br>
To hyphenate words with imbedded hyphens, you must disable the hyphenchar<br>
while reading the word and enable it while TeX hyphenates (i.e. at the end<br>
of the paragraph).  Two ways to do this:<br>
<pre><code>  \def\H#1{\setbox0=\hbox{#1}\unhbox0}<br>
  \showhyphens{subsystem module \H{subsystem-module}}<br>
</code></pre>
or<br>
<pre><code>  \edef\savehyphenchar{\the\hyphenchar\the\font}<br>
  \hyphenchar\the\font=0<br>
  \showhyphens{subsystem module subsystem-module<br>
  \hyphenchar\the\font=\savehyphenchar} <br>
</code></pre>

To have TeX hyphenate words with imbedded hyphens, you may use the<br>
`breakable hyphen' command:<br>
<pre><code>      \def\hyph{-\penalty0\hskip0pt\relax}<br>
</code></pre>
You could play tricks mapping it to a character that's made active for<br>
the purpose, but `-'?<br>
<br>
Another way to permit breaking of hyphenated words:<br>
<pre><code>  \lccode`\-=`\- \hyphenchar\the\font=`\#<br>
</code></pre>
and voila, TeX will hyphenate words containing a `-'. There is only one<br>
drawback: if TeX hyphenates a word it uses a <code>#' instead of a </code>-', as in<br>
<pre><code>  \showhyphens{hyphenation}<br>
</code></pre>
.<br>
<pre><code>  Underfull \hbox (badness 10000) detected at line 0<br>
  [] \tenrm hy#phen#ation<br>
</code></pre>
To solve that, the font should contain two hyphen symbols, one in the<br>
normal position and one in the position for `#'.<br>
<br>
LaTeX doesn't hyphenate automatically when in font \tt because in the<br>
customary uses for \tt fonts, one does not want TeX to insert any hyphens.<br>
Here are two workarounds:<br>
<ol><li>Insert explicit "\-" wherever you wish to permit hyphenization.<br>
</li></ol><blockquote>2. Non-hyphenization is implemented by setting \hyphenchar of the tt fonts<br>
<blockquote>to -1.  You can undo it by explicitly resetting \hyphenchar.</blockquote></blockquote>

In LaTeX, \discretionary is a way to do custom hyphenization (without<br>
necessarily using the hyphen character).  Use it like<br>
<pre><code>  \discretionary{beforebreak}{afterbreak}{unbroken}<br>
</code></pre>
Examples:<br>
<pre><code>  \discretionary{-}{}{}              % normal hyphenization; equivalest to: \-<br>
  \discretionary{}{}{}               % no space, but permit break<br>
  \discretionary{}{}{\,}             % thin space, or permit break<br>
  \discretionary{/}{}{/}             % permit break after slash; equivalent to: /\discretionary{}{}{}<br>
  \discretionary{}{.}{.}             % permit break before period (e.g., in URL)<br>
  \discretionary{f-}{fi}{ffi}cult    % kerning<br>
</code></pre>

Redhat 6's (RH6's) LaTeX hyphenation is totally broken<br>
because it uses all the different lanaguages hyphenation rules.<br>
\usepackage<a href='english.md'>english</a>{babel}<br>
fixes the problem by forcing it to use only English.<br>
<br>
<br>
To permit more space between words, in order to prevent bad breaks in<br>
narrow columns (like in a newspaper):<br>
<pre><code> {\spaceskip = \fontdimen2\the\font<br>
 \advance\spaceskip by 0pt plus 0.5em<br>
 \xspaceskip = \fontdimen7\the\font<br>
 \advance\xspaceskip by 0pt plus 0.5em<br>
 Several features were included in TRACEMAP to make it particularly<br>
 useful for programmers who need to understand the behavior of<br>
 their codes.}<br>
 The most important part is a static pictorial representation of<br>
 .. etc<br>
</code></pre>
This adds an extra 0.5em of stretchability to all spaces, producing big<br>
spaces in the line. This modification is closed as soon as possible by the<br>
} (could probably be earlier) to avoid having strange spacing further down<br>
as a space is better than a hyphenation for TeX ... even one of these nasty<br>
big ones - TeX can't tell the difference. \fontdimen2\the\font is the space<br>
factor of the current font and 0.5em is the extra space factor.<br>
<br>
\def\nopgbrk{\@nobreaktrue}<br>
appears to prevent LaTeX page breaks, even just before lists.<br>
<br>
LATEX can break an inline formula only when a relation symbol (=, >, ...)<br>
or a binary operation symbol (+, -, ...) exists and at least one of these<br>
symbols appears at the outer level of a formula. Thus $a+b+c$ can be broken<br>
across lines, but ${a+b+c}$ cannot.  So, you can wrap parts of your formula<br>
in \mathrel or the like.<br>
<br>
<br>
<hr />
<h1>pdf and pdflatex</h1>

TeX uses bitmap based fonts by default, so PDF looks bad for them.  To<br>
correct this, do one of 2 things:<br>
<ul><li>use "pdflatex" on your tex documents, to use outline fonts instead (and<br>
<blockquote>to generate PDF instead of .dvi); however, "pdflatex" cannot cope with<br>
included .eps files in the documents<br>
</blockquote></li><li>tell dvips to use outline fonts; see<br>
<blockquote><a href='http://web.mit.edu/ajfox/Public/projects/FAQ/BaKoMa.html'>http://web.mit.edu/ajfox/Public/projects/FAQ/BaKoMa.html</a>
and, equally important, see my athena .dvipsrc<br>
Two other solutions:<br>
</blockquote></li><li>use dvipdfm to convert from .dvi to PDF.<br>
</li><li>In dvips, using "-P pdf" option fixes many problems<br>
<blockquote>when later converting to PDF (for instance, it uses outline fonts).</blockquote></li></ul>

When using the graphicx package to include figures in a LaTeX document:<br>
The latex command requires all graphics/images/pictures to be in EPS format.<br>
The pdflatex command requires all graphics to be in JPEG/JPG, TIFF, PNG, or PDF.<br>
Therefore, all figures must appear in at least two different formats.<br>
<br>
To convert .eps to .pdf, either of the following:<br>
<pre><code>  # epstopdf seems to do a better job than convert<br>
  epstopdf picture.eps<br>
  # This version embeds fonts in the resulting PDF file<br>
  GS_OPTIONS="-dEmbedAllFonts=true -dPDFSETTINGS=/printer" epstopdf myfile.eps<br>
  convert file.eps file.pdf<br>
  eps2pdf<br>
  ps2pdf -dEPSCrop<br>
  # a2ping is the successor to epstopdf<br>
  a2ping<br>
  # To embed fonts using a2ping<br>
  a2ping --gsextra='-dEmbedAllFonts=true -dPDFSETTINGS=/printer'<br>
</code></pre>
To convert .pdf to .eps, either of the following ("convert" sometimes makes<br>
huge .eps files, though "pdftops" creates more pixellated .eps files):<br>
<pre><code>  convert file.pdf file.eps<br>
  pdftops -f 1 -l 1 -eps<br>
</code></pre>
To include the pdf file:<br>
<pre><code>  \usepackage{graphicx}<br>
  ...<br>
  % There should never be a .pdf (or any other) filename extension<br>
  \includegraphics[width=\textwidth]{picture}<br>
</code></pre>

To check whether fonts are embedded, run<br>
<pre><code>  pdffonts myfile.pdf<br>
</code></pre>
or alternately use Adobe Acrobat Reader: go to "File --> Document<br>
Properties --> Fonts".<br>
This might tell you a font isn't embedded, but no output can also be a bad sign.<br>
<br>
pdflatex creates a document with fonts embedded, so long as all your images<br>
are bitmaps or are .pdf or .ps images with all their fonts embedded.<br>
<br>
To embed fonts in a PDF document:<br>
<pre><code>  gs -q -dSAFER -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=tmp.pdf -dCompatibilityLevel=1.5 -dPDFSETTINGS=/prepress -c .setpdfwrite -f file.pdf<br>
</code></pre>
This creates tmp.pdf with as many fonts embedded as are available on the<br>
computer where you ran the command.<br>
<br>
To embed the 14 base fonts (make them embedded fonts) in a PDF document,<br>
when starting from a PostScript document:<br>
<pre><code>  ps2pdf13 -dPDFSETTINGS=/prepress doc.ps doc2.pdf<br>
</code></pre>
Be sure to do this on PostScript that is generated by dvips, not on<br>
PostScript that is generated by pdf2ps or similar programs.<br>
(The instructions at <a href='http://users.rsise.anu.edu.au/~luke/embedded_fonts.html'>http://users.rsise.anu.edu.au/~luke/embedded_fonts.html</a>
that are supposed to make pdflatex embed the fonts did not work for me.)<br>
<br>
<br>
<hr />
<h1>URLs</h1>

To make hyperlinks (e.g., to URLs) in a LaTeX document:<br>
<pre><code>  \usepackage{hyperref}<br>
  \url{http://www.wikibooks.org}<br>
  \href{http://www.wikibooks.org}{Wikibooks home}<br>
</code></pre>
If you also want to line-break the URL text, then:  \usepackage{hyperref}<br>
  \usepackage{url}<br>
  \url{http://www.wikibooks.org}<br>
  \href{\url{http://www.wikibooks.org}}{Wikibooks home}<br>
}}<br>
More on LaTeX HEVEA URLs (\ahref, etc.):<br>
  http://pauillac.inria.fr/~maranget/hevea/doc/manual018.html#toc22<br>
but perhaps I want to ignore that and focus on using standard <br>
<br>
<br>
URLs in HTML and PDF documents:<br>
{{{<br>
 % Make a URL visible in PDF the but just be attached to anchor text in HTML:<br>
 %BEGIN LATEX<br>
 \newcommand{\ahreforurl}[2]{#2 (\url{#1})}<br>
 %END LATEX<br>
 %HEVEA \newcommand{\ahreforurl}[2]{\ahref{#1}{#2}}<br>
}}}<br>
<br>
The url package for LaTeX linebreaks a URL appropriately.<br>
For a moving argument (or a URL containing characters like %), use<br>
{{{<br>
    \urldef{\myself}\url{myself%node@gateway.net}   or<br>
    \urldef{\myself}\url|myself%node@gateway.net|<br>
}}}<br>
and then use "\myself" instead of "\url{myself%node@gateway.net}".<br>
However, the hyperref package forbids URL line breaks; the workaround is<br>
{{{<br>
  \usepackage{hyperref}<br>
  \usepackage{breakurl}<br>
}}}<br>
<br>
To typeset URLs in a smaller font in LaTeX, using \package{url}:<br>
First approach (shorter, usually works):<br>
{{{<br>
  \def\UrlFont{\smaller\ttfamily}<br>
}}}<br>
Second approach (better style, possibly more robust):<br>
{{{<br>
  %% Define and use a 'smallertt' URL style.<br>
  \makeatletter<br>
  \def\url@smallerttstyle{%<br>
    \@ifundefined{selectfont}{\def\UrlFont{\smaller\tt}}{\def\UrlFont{\smaller\ttfamily}}}<br>
  \makeatother<br>
  \urlstyle{smallertt}<br>
}}}<br>
<br>
<br>
<br>
---------------------------------------------------------------------------<br>
=Hevea=<br>
<br>
Conditional compilation with LaTeX and Hevea:<br>
To avoid problems with the imagen program, it's usually best to not<br>
redefine macros with %HEVEA, but to use the \ifhevea conditional.<br>
<br>
In LaTeX files, to avoid the "This document was translated from LaTeX to<br>
Hevea" advertisement, write:<br>
{{{<br>
  %HEVEA \footerfalse    % Disable hevea advertisement in footer<br>
}}}<br>
<br>
Adding info to HTML header in Hevea (this must come after \begin{document}):<br>
{{{<br>
\let\oldmeta=\@meta<br>
\renewcommand{\@meta}{%<br>
\oldmeta<br>
\begin{rawhtml}<br>
<link rel="icon" type="image/png" href="my-favicon.png" /><br>
\end{rawhtml}}<br>
}}}<br>
<br>
<br>
---------------------------------------------------------------------------<br>
=Everything else=<br>
<br>
In LaTeX, rather than<br>
{{{<br>
  \usepackage{times}<br>
}}}<br>
consider<br>
{{{<br>
  \usepackage{pslatex}<br>
}}}<br>
which differs in that it uses a specially narrowed Courier font.<br>
(Also consider \usepackage{palatino}?)<br>
<br>
To change fonts temporarily in LaTeX, use comands like the following<br>
{{{<br>
  {\fontfamily{phv}\selectfont Helvetica looks like this}<br>
}}}<br>
and<br>
{{{<br>
  {\fontencoding{OT1}\fontfamily{ppl} Palatino looks like this}.<br>
}}}<br>
<br>
LaTeX style files are found in the directories listed in the TEXINPUTS<br>
environment variable.<br>
<br>
Don't forget to check ~/tex/sty/ when looking for TeX files.<br>
<br>
LATEX directory: see /usr/share/texmf/tex/latex/misc, among others<br>
<br>
LaTeX form letter:  use "merge" documentstyle option<br>
<br>
Ragged right text in LaTeX:  use flushleft environment without explicit \\'s.<br>
Another possibility is \pretolerance=10000 and \raggedright.<br>
<br>
The following six TeX document style options exist for using PostScript<br>
fonts as your text fonts on theory machines.<br>
(1) avantgarde, for using the Avant Garde family.<br>
(2) bookman, for using the Bookman family.<br>
(3) helvetica, for using the Helvetica family.<br>
(4) palatino, for using the Palatino family.<br>
(5) ncs, for using the New Century Schoolbook Roman family.<br>
(6) times, for using the Times Roman family<br>
<br>
Use the \jobname command to get the name of the file that TeX is working on.<br>
.<br>
Summary of UNIX-based methods for "portably" getting FILEID information of<br>
.tex source into the .dvi file:  (By portable, I mean that the .tex file<br>
does not identify itself; at processing time, its location is obtained from<br>
the system and encoded in the resulting .dvi file.)<br>
1) Use the ability of tex/latex to take information from the invocation.<br>
Here is a script that does this for a latex document, so that the variable<br>
\fileid can be used at will in the document and will expand to the absolute<br>
pathname with hostname prepended<br>
{{{<br>
 FN=`basename $1 .tex`.tex<br>
 FILEID=`hostname`:`pwd`/$FN<br>
 FILEID=`echo $FILEID | tr _ .`<br>
 echo Inserting $FILEID...<br>
 virtex "&"lplain \\def\\fileid{$FILEID}\\input $1<br>
}}}<br>
2) Use rcs or make.<br>
3) Use a script and UNIX file-editing filters to replace tokens in the text<br>
with dynamically obtained environment information.<br>
From: vjcarey@sphunix.sph.jhu.edu ("Vincent J. Carey")<br>
<br>
How can I make the pagestyle of the first page be empty (no page number)?<br>
Put \pagestyle{empty} in the preamble (before \begin{document}).  This<br>
works as long as you don't use \maketitle, which resets the pagestyle.  If<br>
you use \maketitle, you have to place a \thispagestyle{empty} after the<br>
\maketitle command, as well.<br>
<br>
You can use MakeIndex to process a glossary (.glo file).  Here's an example<br>
of a MakeIndex style-file you'd need:<br>
{{{<br>
keyword "\\glossaryentry"<br>
preamble "\\begin{theglossary}\n"<br>
postamble "\n\n\\end{theglossary}\n"<br>
actual '='<br>
quote '!'<br>
encap '|'<br>
level '>'<br>
delim_0 "\\pfill"<br>
delim_1 "\\pfill"<br>
delim_2 "\\pfill"<br>
lethead_flag 0<br>
}}}<br>
Use it with the command:<br>
{{{<br>
  makeindex -s glossary.ist -o your-file.gls your-file.glo<br>
}}}<br>
<br>
For alphabetic enumeration, do:<br>
{{{<br>
\newcounter{alphaenum@count}<br>
\newenvironment{alphaenum}%<br>
{\begin{list}%<br>
{\alph{alphaenum@count})}%<br>
{\usecounter{alphaenum@count}\def\p@alphaenum@count{\expandafter\@alph}}}%<br>
{\end{list}}<br>
}}}<br>
<br>
In LaTeX, to make the first line of all sections etc be indented by the<br>
usual paragraph indentation:<br>
{{{<br>
  \let\@afterindentfalse\@afterindenttrue<br>
  \@afterindenttrue<br>
}}}<br>
OR, change the definition of \section (example from art10; '-' becomes '+')<br>
{{{<br>
  \def\section{\@startsection {section}{1}{\z@}{-3.5ex plus -1ex minus <br>
   -.2ex}{2.3ex plus .2ex}{\Large\bf}}<br>
}}}<br>
to<br>
{{{<br>
  \def\section{\@startsection {section}{1}{\z@}{+3.5ex plus +1ex minus <br>
   +.2ex}{2.3ex plus .2ex}{\Large\bf}}<br>
}}}<br>
<br>
To remove some of the extra whitespace around section headers:<br>
{{{<br>
  \usepackage[compact]{titlesec}<br>
}}}<br>
<br>
A simple LaTeX environment that keeps everything within it<br>
on the same page:<br>
{{{<br>
 \def\window#1{\@need=#1\advance\@need\pagetotal<br>
 \if\@need>\textheight\vfil\newpage\else\fi}<br>
 %<br>
 \newbox\@keepbox<br>
 \newenvironment{keep}{%<br>
   \setbox\@keepbox=\vbox\bgroup<br>
 }{%<br>
   \egroup\window{\ht\@keepbox}\box\@keepbox<br>
 }<br>
}}}<br>
This works fine, except that if the \vbox is higher than textheight, it<br>
overflows the page. So it needs to be broken up somehow.<br>
<br>
TeX primitive \time is the number of minutes since midnight this morning.<br>
Use it via \number\time.  For a timestamp, use it with \today (which<br>
prints something like `August 7, 1989').<br>
If you want something like ``13:48'' try the following:<br>
{{{<br>
 \def\clocktime{{\newcount\scratch<br>
  \scratch=\time<br>
  \divide\scratch by 60<br>
  \number\scratch :\multiply\scratch by -60<br>
  \advance\scratch by\time<br>
  \number\scratch}}<br>
}}}<br>
Another version by Nelson Beebe, U. of Utah., is:<br>
{{{<br>
 % TIME OF DAY<br>
 \newcount\hh<br>
 \newcount\mm<br>
 \mm=\time<br>
 \hh=\time<br>
 \divide\hh by 60<br>
 \divide\mm by 60<br>
 \multiply\mm by 60<br>
 \mm=-\mm<br>
 \advance\mm by \time<br>
 \def\hhmm{\number\hh:\ifnum\mm<10{}0\fi\number\mm}<br>
}}}<br>
<br>
I once had to set<br>
{{{<br>
  \topskip = 0pt<br>
}}}<br>
to remove extra space before the first paragraph of a LaTeX document.<br>
<br>
Marcel van der Goot's midnight macros (.tex and .doc files):<br>
 * quire  Macros for making booklets, printing double pages, and printing outlines and crop marks.<br>
 * gloss:  Macros for vertically aligning words in consecutive sentences.<br>
 * loop:   A simple looping construct (meta-macros).<br>
 * dolines: Meta-macros to separate arguments by newlines and by empty lines.<br>
 * labels: Macros to print address labels and bulk letters.<br>
   Do `tex make-labels' and then supply the label file name.<br>
   There are other packages for labels, as well.<br>
<br>
sober.sty reduces the spacing around section headings in the<br>
default document styles.<br>
<br>
In text with explicit line breaks, we can make a box just wide enough to<br>
hold the widest one via (see LaTeX manual under tabbing for explanation):<br>
{{{<br>
  \newenvironment{centerlongestline}{\begin{center}\begin{minipage}{\linewidth}<br>
     \begin{tabbing}}{\end{tabbing}\end{minipage}\end{center}}<br>
}}}<br>
Another alternative would be to use \begin{tabular}{l} ...<br>
\end{tabular} rather than a tabbing environment, in which case<br>
the minipage environment could be omitted entirely.<br>
<br>
To capitalize (the first letter only of) a string in TeX, use<br>
\caps{string}.  The string may contain macros and even embedded macros.<br>
\def\caps#1{{\edef\tempa{#1}\expandafter\Caps\tempa}}<br>
\def\Caps#1{\uppercase{#1}}<br>
<br>
To number tables, figures, footnotes, consecutively through the entire<br>
report (not by chapters) in LaTeX:<br>
{{{<br>
        \makeatletter<br>
        \def\cl@chapter{}<br>
        \@addtoreset{section}{chapter}<br>
        \def\thetable{\@arabic\c@table}<br>
        \def\thefigure{\@arabic\c@figure}<br>
        \def\theequation{\arabic{equation}}<br>
        \makeatother<br>
}}}<br>
One could also define<br>
{{{<br>
    \def\@takefromreset#1#2{%<br>
        \def\@tempa{#1}%<br>
        \let\@tempd\@elt<br>
        \def\@elt##1{%<br>
            \def\@tempb{##1}%<br>
            \ifx\@tempa\@tempb\else<br>
                \@addtoreset{##1}{#2}%<br>
            \fi}%<br>
        \expandafter\expandafter\let\expandafter\@tempc\csname cl@#2\endcsname<br>
        \expandafter\def\csname cl@#2\endcsname{}%<br>
        \@tempc<br>
        \let\@elt\@tempd<br>
    }<br>
}}}<br>
and then the solution to the original problem becomes:<br>
{{{<br>
        \@takefromreset{footnote}{chapter}<br>
        \@takefromreset{table}{chapter}<br>
        \@takefromreset{figure}{chapter}<br>
        \@takefromreset{equation}{chapter}<br>
        \def\thetable{\@arabic\c@table}<br>
        \def\thefigure{\@arabic\c@figure}<br>
        \def\theequation{\arabic{equation}}<br>
}}}<br>
<br>
From the ``Golden Rules of Macro Coding'' (for TeX)<br>
  If a macro starts with \if..., put a \relax in front of it.<br>
  \if... is not evaluated during the syntactic/semantic analysis, but<br>
  during the lexical analysis. So there may be places where TeX scans<br>
  ahead, and where the scan must be stopped, to allow a change to math<br>
  mode before the test is done. An example where this may occur is<br>
  within \halign's.<br>
<br>
TeX code for definitions including multiple alternatives:<br>
{{{<br>
  \newcommand{\twolinedef}[4]{\left\{ \begin{array}{ll}<br>
        #1 & \mbox{#2} \\<br>
        #3 & \mbox{#4} \\<br>
  \end{array} \right.}<br>
}}}<br>
<br>
To run TeX or LaTeX in batch mode on file foo.tex, do<br>
{{{<br>
  [la]tex \\batchmode \\input foo.tex<br>
}}}<br>
The doubled backslashes are for the shell; TeX will see just one of each pair.<br>
<br>
6) How can I get TeX to see LaTeX \ref{...} as a _number_?<br>
{{{<br>
\def\alphref#1{\@ifundefined{r@#1}{?}{\edef\@tempa{\@nameuse{r@#1}}\expandafter<br>
    \expandafter\expandafter\@alph\expandafter\@car\@tempa \@nil\null}}<br>
}}}<br>
<br>
LaTeX's \raisebox is like TeX's \smash:  change the apparent height of a<br>
piece of text.<br>
<br>
\negphantom is like phantom, but the space is negative, not positive.<br>
\newcommand{\negphantom}[1]{\settowidth{\nplength}{#1}\hspace*{-\nplength}}<br>
<br>
The useful LaTeX macro \ensuremath lets macros appear in either math or<br>
horizontal mode; if the latter, it automatically switches to math mode.<br>
<br>
ACM LaTeX styles FAQ:<br>
  http://www.acm.org/sigs/publications/sigfaq<br>
{{{<br>
  % "\let\thepage\relax" in sig-alternate.cls causes hyperref to issue warnings.<br>
  % Fix those warnings:<br>
  \pagenumbering{arabic}<br>
  \pagestyle{empty}<br>
}}}<br>
but I'm not sure how to do it wit<br>
<br>
To add page numbers in ACM SIG (or sig-alternate) LaTeX style (and remove<br>
the copyright box):<br>
{{{<br>
  % Add page numbers, remove copyright box.  For submitted version only.<br>
  \pagenumbering{arabic}<br>
  \makeatletter<br>
  \def\@copyrightspace{\relax}<br>
  \makeatother<br>
}}}<br>
In sigplanconf style, it's even easier:<br>
{{{<br>
  \documentclass[preprint,nocopyrightspace]{sigplanconf}<br>
}}}<br>
In acmlarge.cls, remove the copyright info by doing:<br>
{{{<br>
  \def\permission{}<br>
}}}<br>
Fixes to ACM SIG style (sig-alternate.cls):<br>
 * Uncapitalize section titles: <br>
    * Delete all instances of "\@ucheadtrue"<br>
    * Replace "ABSTRACT" by "Abstract" and "REFERENCES" by "References"<br>
    * Remove (comment out) `\section*{APPENDIX}`<br>
 * Captions:<br>
    * Change "then" clause to the following:<br>
       {\small\parbox{\hsize}{#1: #2\strut}}\par               %   THEN set as ordinary paragraph.<br>
    * Remove instances of "textbf"<br>
    * Add "\strut" after "#2"<br>
    * Consider adding "\small"<br>
    * Comment out "\vskip 10pt" and/or "\vskip \baselineskip"<br>
 * References:<br>
    * No section number: <br>
       * change "\section[References]" to `\section*`.  (note removal of optional argument)<br>
       * remove (comment out) "\vskip -9pt".<br>
       * remove (comment out) "\advance\leftmargin\labelsep"<br>
 * Copyright data:<br>
    * In sig-alternate, change two lines to the following:<br>
{{{<br>
       \begin{picture}(20,5) %Space for copyright notice<br>
       \put(0,-.75){\crnotice{\@toappear}}<br>
}}}<br>
      (or use a slightly more negative last number like -.95 instead of -.75).<br>
    * In sigplanconf.cls, change "\vbox to 1in" so that we use:<br>
{{{<br>
       \@float{copyrightbox}[b]%<br>
         \vbox to .8in{%<br>
}}}<br>
 * Font size:<br>
{{{<br>
    \def\footnotesize{\@setsize\footnotesize{8pt}\viipt\@viipt}<br>
}}}<br>
Fixes to sigplanconf.cls:<br>
{{{<br>
  \vbox to .8in{%<br>
    % \vfill<br>
}}}<br>
Maybe:<br>
{{{<br>
  % \vspace{2pt}<br>
}}}<br>
To reduce whitespace in the titlebox (near the title and authors):<br>
 * Comment out:<br>
{{{<br>
    %\vskip 2em                   % Vertical space above title.<br>
}}}<br>
 * To reduce space *after* the authors, reduce "12.75" on this line:<br>
{{{<br>
 \advance\dimen0 by -12.75pc\relax % Increased space for title box -- KBT<br>
}}}<br>
 * To reduce space between the title and authors (without affecting the<br>
   total size of the title box), reduce "1.25" in this line:<br>
{{{<br>
  {\subttlfnt \the\subtitletext\par}\vskip 1.25em%\fi<br>
}}}<br>
<br>
Fixes to IEEETran style file, to save space and improve appearance:<br>
 * \usepackage{microtype}<br>
 * pass "nofonttune" option to the class (in \documentclass[...]); IEEETran's font metric tuning is very bad, and microtype is better<br>
 * After \begin{document}: `\nonfrenchspacing\hyphenpenalty=50\hbadness=1000` (IEEETran inexplicably tells TeX to hyphenate *far* less frequently than normal, wasting space and making things ugly)<br>
<br>
To remove the extra vertical space from around \begin{definition}, make the<br>
following change to sig-alternate.cls.<br>
{{{<br>
--- a/sig-alternate.cls	Sat Aug 14 14:00:55 2010 -0700<br>
+++ b/sig-alternate.cls	Sat Aug 14 14:13:52 2010 -0700<br>
@@ -948,8 +948,8 @@<br>
     \expandafter\@ifdefinable\csname #1\endcsname<br>
         {\@definecounter{#1}%<br>
          \expandafter\xdef\csname the#1\endcsname{\@thmcounter{#1}}%<br>
-         \global\@namedef{#1}{\@defthm{#1}{#2}}%<br>
-         \global\@namedef{end#1}{\@endtheorem}%<br>
+         \global\@namedef{#1}{\vspace{-5pt}\@defthm{#1}{#2}}%<br>
+         \global\@namedef{end#1}{\@endtheorem\vspace{-5pt}}%<br>
     }%<br>
 }<br>
 \def\@defthm#1#2{%<br>
}}}<br>
<br>
Make these fixes to figures and captions when writing a paper using IEEE latex8.sty:<br>
 * Remove all references to \tenhv<br>
 * Edit the setting of \@figindent as follows:<br>
{{{<br>
  \setlength{\@figindent}{0pc}<br>
}}}<br>
 * In definition of @makecaption, change "then" clause to:<br>
{{{<br>
      % THEN set as an indented paragraph<br>
      {\parbox{\hsize}{#1: #2\strut}}\par<br>
}}}<br>
<br>
To permit underfull hboxes in LaTeX, use <br>
{{{<br>
\begin{sloppypar} ... \end{sloppypar}<br>
}}}<br>
I can't get \sloppy to work.<br>
To disable the warnings globally, say "\hbadness=10000", this<br>
disables overfull hbox warnings too.<br>
<br>
In LaTeX, <br>
to typeset text in a superscript or subscript, use A_{\mathit{pred}}}<br>
<br>
To produce a footnote without a footnote mark (as for a copyright notice in<br>
the lower left-hand corner of a conference paper) in LaTeX, do this:<br>
{{{<br>
  \renewcommand{\thefootnote}{}<br>
  \footnotetext{A version of this paper will appear in the 25th <br>
  Annual International Symposium on Computer Architecture, June 1998}<br>
  \renewcommand{\thefootnote}{\arabic{footnote}}<br>
}}}<br>
<br>
The Harvard bib style for LaTeX<br>
        http://www.arch.su.edu.au/~peterw/latex/harvard/<br>
supports a "URL" field.  It even works with LaTeX2html so the<br>
appropriate links are generated.<br>
<br>
LaTeX2HTML CVS repository:<br>
  http://cdc-server.cdc.informatik.th-darmstadt.de/~latex2html/<br>
though the source recommends<br>
  http://www-dsed.llnl.gov/files/programs/unix/latex2html/manual/<br>
  http://www.cbl.leeds.ac.uk/nikos/tex2html/doc/latex2html/<br>
<br>
To use a smaller (9-point) font in a LaTeX document, use<br>
{{{<br>
  \makeatletter\input{size09.clo}\makeatother<br>
}}}<br>
as the first set of commands after \documentclass.<br>
<br>
To use a thinner (narrower) version of a font in a LaTeX document, run the<br>
following before running pdflatex:<br>
{{{<br>
# Run with --clean once if the --xscale argument changes.<br>
#	/usr/share/doc/texlive-doc/latex/savetrees/makethin article.dvi --clean<br>
	-/usr/share/doc/texlive-doc/latex/savetrees/makethin article.dvi --pdftex --xscale=0.94<br>
}}}<br>
<br>
The TeX FAQ is searchable:<br>
    http://www.tex.ac.uk/cgi-bin/texfaq2html<br>
or printable, available from from CTAN, in<br>
 * usergrps/uktug/faq/newfaq.ps     (for A4 paper)<br>
 * usergrps/uktug/faq/newfaq.pdf    (likewise)<br>
 * usergrps/uktug/faq/letterfaq.ps  (for U.S. letter-size paper)<br>
 * usergrps/uktug/faq/letterfaq.pdf (likewise)<br>
<br>
Environment for formatting pseudocode<br>
http://homes.cs.washington.edu/~zasha/latex.html<br>
<br>
To get a plain tilde character in LaTeX, do:  \textasciitilde.<br>
This works even in \tt font.<br>
<br>
In LaTeX, any character can be obtained by giving its ASCII code.<br>
The left and right braces are, respectively, \char"7B and \char"7D.<br>
Using \{ in \tt yields a Roman "{", it seems.  Here are macros that use the<br>
\tt font:<br>
{{{<br>
  % Left and right curly braces in tt font<br>
  \newcommand{\ttlcb}{\texttt{\char "7B}}<br>
  \newcommand{\ttrcb}{\texttt{\char "7D}}<br>
}}}<br>
<br>
To set the page number in LaTeX:  \setcounter{page}{98}<br>
<br>
One way to number LaTeX figures by chaper/section, 1.1, 1.2, ..., 2.1, ...:<br>
  http://www-compiler.csa.iisc.ernet.in/~janaki/tex/numbering.html<br>
<br>
Dvipdfm is a DVI to PDF translator.<br>
http://gaspra.kettering.edu/dvipdfm/<br>
<br>
This Makefile rule runs LaTeX until it stops saying "Labels may have changed":<br>
{{{<br>
latex:<br>
  latex ${TEXFILE}<br>
  (fgrep 'Label(s) may have changed' $(subst .tex,.log,${TEXFILE}) && $(MAKE) latex) || true<br>
}}}<br>
But you could use "rubber" instead.<br>
<br>
Rubber is a latex build system written in python.  Run it like this:<br>
{{{<br>
  rubber main.tex<br>
}}}<br>
It iterates latex / bibtex until a fixed-point (more or less: it won't loop<br>
forever, and if you use some obscure latex packages you may need an extra<br>
run).  Rubber filters the latex output to report only issues of importance.<br>
You can apt-get install rubber.<br>
<br>
Three LaTeX references, all published by Addison-Wesley:<br>
 * LaTeX:  A Document Preparation System, by Leslie Lamport, 1994<br>
 * The LaTeX Companion, by Goossens, Mittelbach, and Samarin, 1994<br>
 * A Guide to LaTeX, by Helmut Kopka and Patrick Daly, 1999<br>
<br>
Do not use math mode (such as $define$) for italics.  Instead, use<br>
\emph{define} or \mathem{define}.  Math mode does not use ligatures and gets<br>
interletter spacing wrong.<br>
.<br>
You have improperly used TeX's math mode as a shortcut for producing words<br>
in italic type.  This is ugly and distracting.  Instead of saying $START$<br>
(which puts too much space between "T" and "A"), you should say {\em START}<br>
or, in a formula, \mathit{START} or \mbox{\em START}.  (There are also<br>
other good ways to get the same output.)  This small point will improve<br>
readability and will build confidence that you have been careful throughout<br>
your work.<br>
<br>
The "beamer" package permits making nice slides with LaTeX.<br>
(It's better than the "prosper" package, according to Stephen McCamant.)<br>
"t" class option puts slide content at top rather than vertically centered.<br>
<br>
Any LaTeX-Beamer slide containing a verbatim environment must start out:<br>
{{{<br>
  \begin{frame}[fragile]<br>
}}}<br>
(or [containsverbatim], though that's more typing)<br>
<br>
In LaTeX-Beamer:<br>
{{{<br>
  \begin{frame}[shrink=5]   permits change of font size<br>
  \begin{frame}[squeeze]    reduces vertical space<br>
}}}<br>
<br>
In TeX/LaTeX, to create a large "forall" symbol (which ordinarily is no<br>
larger in display mode than in any other math mode), do something like<br>
{{{<br>
  \newcommand{\bigforall}[2]{{{\raisebox{-6pt}{\mbox{\Large$\forall$}$#1$}}\atop{\scriptstyle #2}}}<br>
}}}<br>
<br>
For a paragraph in a smaller font, on the smaller font's baseline<br>
inter-line spacing (but it isn't permitted to be broken across columns), do<br>
{{{<br>
  {\small\noindent\parbox{\columnwidth}{\quad<br>
  ...<br>
  }<br>
}}}<br>
<br>
This defines a \Hline macro that is like \hline, but it has an independent<br>
thickness.<br>
{{{<br>
\newdimen\arrayruleHwidth<br>
\setlength{\arrayruleHwidth}{1pt}<br>
\makeatletter<br>
\def\Hline{\noalign{\ifnum0=`}\fi\hrule \@height \arrayruleHwidth<br>
  \futurelet \@tempa\@xhline}<br>
\makeatother<br>
}}}<br>
<br>
LLNCS (LaTeX LNCS) style:<br>
wget ftp://ftp.springer.de/pub/tex/latex/llncs/latex2e/llncs2e.zip<br>
<br>
Derek Rayside says:<br>
I wrote a little latex macro that lets one write things such as:<br>
{{{<br>
    \digraph{MyGraph}{a->b}<br>
}}}<br>
this produces MyGraph.dot with the contents:<br>
{{{<br>
    digraph MyGraph {a->b}<br>
}}}<br>
If you run dot to get MyGraph.ps (ie, dot -Tps -o MyGraph.ps MyGraph.dot),<br>
then the \digraph macro will include the postscript file in your document.<br>
The macro file is available at:<br>
    http://web.mit.edu/~drayside/www/graphviz.tex/graphviz.tex<br>
and a bit more documentation is at:<br>
   http://web.mit.edu/~drayside/www/graphviz.tex/main.pdf<br>
<br>
In LaTeX, use \enlargethispage to expand a page or column, fitting slightly<br>
more text on it.<br>
<br>
Tell TeX programs (from the teTeX distribution, which is standard on modern<br>
Unix systems) to default to US-Letter-sized paper:<br>
{{{<br>
  texconfig xdvi us<br>
  texconfig dvips paper letter<br>
  texconfig dvipdfm paper letter<br>
  texconfig pdftex paper letter<br>
}}}<br>
Alternately, a less desirable fix that only solves part of the problems above:<br>
To make dvips produce lettersize output by default, edit config.ps (maybe in<br>
/usr/share/texmf/dvips/config/config.ps or<br>
/g2/local/lib/texmf/texmf/dvips/config/config.ps) to make sure the "letter"<br>
pagesize block comes first; the first "@" block is the default.<br>
(Otherwise, one must invoke dvips with the "-t letter" switch.)<br>
<br>
If you edit /usr/lib/tex/ps/config.ps (or wherever that file is) to tell<br>
dvips that you have a good printer with lots of memory (with a line like<br>
m 1000000<br>
or maybe even more) then things will in general print faster.<br>
<br>
dvips has the undocumented feature that, for use with the -p and -l<br>
options, 1.1 indicates the second page numbered 1, 1.2 indicates the third<br>
page numbered 1, and so forth.<br>
<br>
Emacs "Local variables" section of a LaTeX file looks like one of the following:<br>
{{{<br>
 %%% Local Variables: <br>
 %%% mode: latex<br>
 %%% TeX-master: t<br>
 %%% auto-fill-function: nil<br>
 %%% fill-column: 75<br>
 %%% TeX-command-default: "PDF"<br>
 %%% End: <br>
}}}<br>
.<br>
{{{<br>
 %%% Local Variables: <br>
 %%% mode: latex<br>
 %%% TeX-master: "daikon-ioa-2002"<br>
 %%% End: <br>
}}}<br>
<br>
LaTeX Verbatim environment with embedded commands:<br>
{{{<br>
\usepackage{fancyvrb}<br>
\begin{Verbatim}[commandchars=\\\{\}]<br>
...<br>
\end{Verbatim}<br>
}}}<br>
Other initial lines:<br>
{{{<br>
\begin{Verbatim}[commandchars=\|\[\]]<br>
\begin{Verbatim}[commandchars=\\\<\>]   % < and > cannot be used as delimiters<br>
\begin{Verbatim}[commandchars=\\\<\>,numbers=left,numbersep=6pt,xleftmargin=12pt]<br>
}}}<br>
Or set parameters globally:<br>
{{{<br>
\fvset{fontsize=\small}<br>
\fvset{fontsize=\relsize{-2}}<br>
}}}<br>
The fancyvrb package is preferable to:<br>
 * the moreverb package.  (The moreverb documentation recommends fancyvrb!)<br>
 * \alltt, which is built into LaTeX (except possibly for very simple tasks<br>
   or use with Hevea)<br>
 * listings (which breaks fancyvrb if both are loaded)<br>
   listings provides the lstlisting command, and inserts too much space<br>
   between characters, which looks bad in any font (fixed- or variale-width).<br>
   An advantage of listings is that it provides multi-character escapes to<br>
   LaTeX code, so you don't have to find specific command characters that<br>
   do not appear in the text (only multi-character sequences that don't appear.)<br>
   listings can also boldface keywords, but that ends up looking very bad too:<br>
   it's best to emphasize what is most important, which is never the keywords.<br>
A disadvantage of fancyvrb is that Hevea only partially supports it; for<br>
example, Hevea does not support the commandchars functionality nor its<br>
`\VerbatimInput` command.  The Hevea manual (section B.17.12) recommends the<br>
moreverb package.<br>
Note that Computer Modern font has no bold fixed width font.<br>
(See elsewhere in this file for solutions.)<br>
<br>
To get bold fixed width (typewriter, teletype, tt) font in LaTeX, here are some options.<br>
When using Computer Modern fonts), use<br>
{{{<br>
  \usepackage{bold-extra}<br>
}}}<br>
See installation instructions at<br>
   http://www.tex.ac.uk/cgi-bin/texfaq2html?label=bold-extras<br>
(which also offers other solutions).<br>
Or, use underlining for emphasis.<br>
Or, try a different font than Computer Modern.  For example, try<br>
{{{<br>
  \usepackage[T1]{fontenc}<br>
  \usepackage{lmodern} % "latin modern", which has a boldface typewriter font<br>
  \usepackage[lighttt]{lmodern} % lighter non-bold version (looks better)<br>
  %\usepackage{luximono}<br>
  %\usepackage[scaled=0.85]{beramono}<br>
  \usepackage[T1]{lucidabr}<br>
}}}<br>
but if you use Lucida Bright, you probably want to scope the Lucida Bright to<br>
only the verbatim text.<br>
Courier also has regular and bold options, but it's considered very ugly.<br>
<br>
To include a literal backslash (or other special characters) in a LaTeX<br>
Verbatim (fancyverb) environment, use \SaveVerb and \UseVerb.<br>
{{{<br>
  \DefineShortVerb{\|}<br>
  \SaveVerb{myname}|verbatim text \ _ ^|<br>
  \UndefineShortVerb{\|}<br>
  \UseVerb{myname}<br>
}}}<br>
Even simpler is the verbdef package:<br>
{{{<br>
  \usepackage{verbdef}<br>
  \verbdef\mymacroname|verbatim text \ _ ^|<br>
  \mymacroname<br>
}}}<br>
<br>
In LaTeX, as a general rule, backslashing punctuation characters inside<br>
\code{} won't give you the right tt-font ones:  you need to either replace<br>
\code with \verb or use \char and an ASCII code for the symbol, such as<br>
{{{<br>
  \renewcommand{\_}{\char"5F}<br>
}}}<br>
or, to get a backslash<br>
{{{<br>
  \newcommand{\bs}{\char"5C}<br>
}}}<br>
<br>
The llncs.cls style (class) file (and also sig-alternate.cls) does<br>
{{{<br>
  \let\footnotesize\small<br>
}}}<br>
which changes the font in footnotes.  This is an acceptable goal, but the<br>
implementation is seriously flawed, since it makes it impossible to get<br>
that size font in the program.  To fix this, find the "\newcommand" for<br>
"\footnotesize" (perhaps in file /usr/share/texmf/tex/latex/base/size10.clo)<br>
and copy it to the document after the "\documentclass" directive.<br>
<br>
The PGF package for LaTeX makes drawings, much like LaTeX picture mode or<br>
the pstricks package, but works with PDF and is much more powerful than<br>
LaTeX picture mode.<br>
<br>
To generate foo.sty (or foo.cls) from foo.dtx, run<br>
{{{<br>
  latex foo.ins<br>
}}}<br>
and then copy the resulting file somewhere appropriate.<br>
<br>
TeX fonts are in /usr/local/lib/tex/fonts/tfm.<br>
<br>
Aim to make your figure captions self-explanatory.  A short caption ("graph<br>
of the results") forces readers to hunt through the text in order to<br>
comprehend your results or your message.  Choose to place explanatory<br>
sentences (such as describing the meaning of the rows, columns, or other<br>
elements) in the caption itself; they take up no more space there, but are<br>
easily located either by a careful reader or by someone flipping through<br>
the document.  This also makes the figures more likely to draw readers into<br>
the text.<br>
<br>
Here is a definition of a \todo macro for LaTeX (it needs `\usepackage{color}`):<br>
{{{<br>
 %% Comment out one of these two definitions.<br>
 % \newcommand{\todo}[1]{\relax}<br>
 \newcommand{\todo}[1]{{\color{red}\bfseries [[#1]]}}<br>
}}}<br>
When using the macro, don't leave space around it.  For example, write<br>
{{{<br>
  The approach is effective\todo{add citations}.<br>
}}}<br>
rather than<br>
{{{<br>
  The approach is effective \todo{add citations}.<br>
}}}<br>
because the latter would leave a space before the period when todo comments<br>
are disabled.<br>
(An alternate definition would be<br>
`\newcommand{\todo}[1]{\textcolor{red}{\textbf{[[#1]]}}}`<br>
but that executes \leavevmode and so it cannot span paragraphs.)<br>
<br>
Absolute value in LaTeX:<br>
{{{<br>
  \left| \frac{A+B}{3} \right|<br>
}}}<br>
<br>
Typesetting pseudocode in LaTeX:<br>
http://www.tex.ac.uk/cgi-bin/texfaq2html?label=algorithms<br>
Possible choices seem like<br>
 * algorithmicx bundle, which offers several environments.<br>
   It's more flexible than algorithmic and is probably the best choice.<br>
 * algorithms bundle, which provides the `algorithmic` and `algorithms` environments<br>
 * clrscode<br>
 * algorithm2e<br>
    This is the one with the vertical lines (which I find ugly and<br>
    distracting); I've had trouble wrestling with it in the past.<br>
The algorithmic environment uses \STATE, \IF, \WHILE, \ENDWHILE...<br>
The algpseudocode environment uses \State, \If, \While, \EndWhile...<br>
<br>
To undo LaTeX's \frenchspacing: \nonfrenchspacing<br>
<br>
In a two column (or at least twocolumn) document, \newpage doesn't give<br>
you a new page; it just gives you a new column. An alternative that works<br>
is \clearpage. (I think the other difference is that it also acts as a<br>
fence for floats, but you often want that too anyway.)<br>
<br>
To get extra space in a document:<br>
{{{<br>
  \renewcommand{\baselinestretch}{.994}<br>
}}}<br>
But that is terrible, so consider<br>
{{{<br>
  \enlargethispage{10pt} in strategic locations.<br>
}}}<br>
Also helpful is <br>
{{{<br>
  \usepackage{microtype}<br>
}}}<br>
after which only pdflatex, not regular latex, works.<br>
The `makethin` program of the savetrees package creates thinner versions of<br>
fonts.<br>
<br>
To adjust section numbering in LaTeX (e.g., make subsubsections be numbered):<br>
{{{<br>
  \setcounter{secnumdepth}{3}<br>
}}}<br>
There is no `\subsubsubsection` command, but you can make `\paragraph` be numbered:<br>
{{{<br>
  \setcounter{secnumdepth}{4}<br>
}}}<br>
<br>
If a paragraph has only a word or two on its last line, try adding {{{<br>
\looseness=-1<br>
}}} to the end of it. If possible TeX will change line breaks to<br>
reduce/shorten the length of the paragraph by a line. This won't always<br>
work because there is a limit to how close TeX will move words. The longer<br>
the paragraph, the more likely this trick is successful.<br>
<br>
PGF/TikZ, is a declarative graphics package and relatively-friendly front end syntax<br>
 * http://sourceforge.net/projects/pgf/ -- to download<br>
 * http://www.fauskes.net/pgftikzexamples/ -- examples<br>
Ben Lerner says: TikZ is a bit  tricky to figure out at first (like most of<br>
LaTeX), but it's the most consistent and convenient graphics package I've<br>
found yet.<br>
<br>
To use color in LaTeX:<br>
{{{<br>
\usepackage{color}<br>
\textcolor{color}{words to be in color}<br>
}}}<br>
<br>
To find LaTeX special command that matches a given character shape,<br>
scribble the shape here:<br>
http://detexify.kirelabs.org/classify.html<br>
<br>
To define a (say) binary operator in TeX or LaTeX, use \mathord, \mathop,<br>
\mathbin, \mathrel, \mathopen, \mathclose, \mathpunct, \mathinner.<br>
These give "class" 1..8 to the math character or formula.<br>
(Maybe operator has less surrounding space, binary more and relation most?)<br>
(There is no \binop or \binrel.)<br>
<br>
More attractive monospaced fonts:<br>
{{{<br>
  % sans-serif monospaced font<br>
  \usepackage{inconsolata}<br>
}}}<br>
{{{<br>
  % serifed monospaced font<br>
  \usepackage[T1]{fontenc}  % Is this necessary?<br>
  \usepackage[scaled=0.88]{luximono}<br>
}}}<br>
<br>
Your LaTeX documents should always use<br>
{{{<br>
  \usepackage[T1]{fontenc}<br>
}}}<br>
Even if you don't care about foreign languages, it has the advantage of<br>
providing typewriter fonts for curly braces, and other characters that look<br>
bad due to the fact that OT1 has only 128 glyphs and LaTeX has to get some<br>
characters such as curly braces from a different font.<br>
It particular, it solves the problem<br>
{{{<br>
  Font shape `OMS/cmss/m/n' undefined using `OMS/cmsy/m/n' instead for symbol `textbraceleft'<br>
}}}<br>
<br>
The default Computer Modern fonts are Type 3 (bitmap).  Here is how to use<br>
"Latin Modern" fonts, which are a Type 1 reimplementation of the Computer<br>
Modern fonts, and ensure you only get Type 1 fonts:<br>
{{{<br>
\usepackage{lmodern}<br>
\usepackage[T1]{fontenc}<br>
}}}<br>
However, it is easier and better to just use pdflatex, which will use the<br>
good-quality type 1 "Blue Sky" implementation of Computer Modern.  Or use a<br>
different font like Times.<br>
<br>
Ways to get a circled number in LaTeX with better formatting than \textcircled:<br>
{{{<br>
 % serif font:<br>
 \usepackage{pifont}<br>
 \newcommand{\numcircled}[1]{\ding{\numexpr171+#1\relax}}<br>
 % sans-serif font:<br>
 \usepackage{pifont}<br>
 \newcommand{\numcircled}[1]{\ding{\numexpr191+#1\relax}}<br>
 % Without using any extra packages<br>
 \newcommand{\numcircled}[1]{\raisebox{.5pt}{\textcircled{\raisebox{-.9pt}{#1}}}}<br>
}}}<br>
<br>
<br>
---------------------------------------------------------------------------<br>
<wiki:comment><br>
Please put new content in the appropriate section above, don't just<br>
dump it all here at the end of the file.<br>
</wiki:comment><br>
<br>
<wiki:comment><br>
This entry is to avoid having the ones earlier in this file be interpreted.<br>
Local Variables: <br>
major-mode: text-mode<br>
End: <br>
</wiki:comment><br>
<br>
<wiki:comment><br>
 LocalWords:  Hevea wiki makeatletter topfigrule kern hrule botfigrule floatsep<br>
 LocalWords:  dblfigrule makeatother nocaptionrule textfloatsep dbltextfloatsep<br>
 LocalWords:  dblfloatsep unindent topfraction dbltopfraction floatpagefraction<br>
 LocalWords:  dblfloatpagefraction textfraction clearpage cleardoublepage ifdim<br>
 LocalWords:  renewcommand captionfont newcommand baselineskip hsize noindent<br>
 LocalWords:  parbox hbox fi<br>
</wiki:comment><br>
</code></pre>