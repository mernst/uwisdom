Contents:




---

# General tips #


Emacs's tags facility allows you to easily find a definition (of a
function, variable, class, etc.) or search a collection of related files.
To create a tags table, run "etags _files_"; for instance, "etags **.h**.c"
To find a tag within Emacs, type  M-.  or  M-x find-tag RET
To search all files in the tags table, type  M-x tags-search RET
To select a different tags table, type  M-x visit-tags-table RET

You should always run gdb within Emacs; use  M-x gdb RET
One advantage is that when you move up and down the stack, the file with
the relevant code is read into a buffer and displayed.
(Getting jdb to work within Emacs is a tiny bit tricky; I find that the JDE
package with a few modifications works fine for me.)

To compile a program or run make, use  M-x compile RET
(A typical compilation command is "make -k".)
You can continue work while the compilation proceeds.
If there are any errors,  C-x `  or  M-x next-error RET  takes you to the
line of the code which is mentioned in the error.  This works with the
output of most compilers.

Why are there two backslashes in \\| in a regexp in Lisp code?
Because the string is being interpreted twice, once by the Emacs Lisp
string-reading routine and once by the regexp routine.  Both of them happen
to use backslash as their escape character.  So "a\\|b" is a four-character
string with contents a \ | b and \| is the regexp routine's alternative
specifier.



---

# Less-polished Emacs wisdom #


To not load .emacs file, do "emacs -q".  To debug it, "emacs --debug-init".

(symbol-function 'foo) to determine whether an emacs function is coded in C
or elisp; C-h f now also gives that information.

just-one-space                ESC SPC
> Function: Delete all spaces and tabs around point, leaving one space.

To get local variables in emacs, put one of the following at the end of the
file, preferrably following a page-feed (^L) character:
Local Variables:
page-delimiter: "^\f\n===========================================================================\n"
End:
/**Local Variables:**/
/**compile-command: "gcc thisfile.c -o thisfile -lm -O -g"**/
/**compile-history: ("gcc thisfile.c -o thisfile -lm -O -g")**/
/**End:**/
(Compile-command first cd's to default-directory.)
These are equivalent (save a mode line update), but the second doesn't
require eval:
Local Variables:
eval: (auto-fill-mode 0)
End:
Local Variables:
auto-fill-function: nil
End:

To save (or execute some other gnus keystroke command upon) multiple
articles to a file in GNUS, use '&' in Subject mode.  This only works on
articles past point.
In gnus, do C-c C-r to caesar-rotate the text of an article.
In gnus 5, use  S o m  to forward the current article.

Kill file like so:
(gnus-kill "Subject" "foo\\|bar" "u")
(gnus-kill "Subject" ".")
(gnus-expunge "X")
will un-kill all except foo or bar in subject.  (There might be a faster
way, but this works fine.)

In gnus, "S o m" to forward/resend article via mail.

The following form will make the emacs buffer-list `transient':
```
  (global-set-key "\C-x\C-b" 'electric-buffer-list)
```
The following will make emacs `help' windows transient:
```
  (progn (require 'ehelp)
         (fset 'help-command ehelp-map))
```

To prevent emacs from wrapping lines, (setq truncate-lines t).
I have a function M-x truncate-lines that toggles this value.

Use split-line (by default, bound to ESC C-o) for open-line-like behavior.

The tex-complete emacs package provides completion of TeX commands.

To remember the old value of an emacs function:
```
  (fset 'old-fill-paragraph (symbol-function 'fill-paragraph))
```

To force a window or screen to repaint DURING the execution of an Elisp
function:  (sit-for 0).

(setq cw-ignore-whitespace t) ingores whitespace in emacs's compare-windows.
Or, supply a prefix argument when invoking compare-windows.

Bard Bloom wrote insert-patterned for emacs.
Also see Wayne Mesard's dmacro (Dynamic Macro) for flexible template insertion.

To delete (kill) the entire contents of an Emacs buffer, use (erase-buffer)
or M-x erase-buffer.

To specify Emacs' indenting of a lisp expression, do something like:
(put 'with-output-to-temp-buffer 'lisp-indent-hook 1)
The number is the number of "special" (indented more than usual) arguments.
To see some examples, do M-. indent-sexp, then go up a few lines.

Set command-switch-alist to something like '(("-foo" . foo-handler)) to add
new command line switches; use command-line-args-left to see following
arguments, and remove them from it when done.

To redump emacs, put the following in a file (say load-and-dump.el) and run
it as
> gnuemacs -batch -l load-and-dump
(load "pkg1.elc")
(garbage-collect)
(load "pkg2.elc")
(garbage-collect)
(message "Dumping...")
(setq command-line-processed nil)
(garbage-collect)
(dump-emacs "product" "/local/bin/gnuemacs")
For more info, see startup.el.

To add hooks to an Emacs function, use advice, which, like Aspect-Oriented
Programming, permits you to run arbitrary code before, after, around, or
instead of a given function call.
Also see post-command-hook.

The gnuserv program lets you force a running Emacs to edit a file or
evaluate Lisp code.

In Emacs, to show only those unindented lines that are **not** preceded by _N_
spaces, do
> C-u _N_ C-x $
To reset, do
> C-x $

A crude, undocumented, and not-guaranteed-to-work-in-the-future way to
silence any Emacs function is to temporarily bind executing-kbd-macro to a
non-nil value.

edebug-eval-top-level-form is bound to C-x x; use this to debug an Emacs
Lisp program or function.

To use tabs instead of spaces when indenting in Emacs, do
```
 (setq-default indent-tabs-mode nil)
```

Use condition-case to catch errors in Emacs Lisp (like try...catch).

To prevent Emacs from simulating a scrolling line mode terminal under X
Windows, do
```
  (if (equal window-system 'x)
      (setq baud-rate 153600))
```

In Emacs C source, initial\_define\_key sets up default keybindings.

To create a standalone program that does Emacs Lisp, you can do something like
```
 #!/usr/local/emacs/bin/emacs -batch
 ...
```

Emerge commands:
```
  sa: auto-advance
  a,b: choose that text
  n,p: next,previous difference
```
(It's probably better to use ediff-merge, rather than emerge.)

The .texi (texinfo) files for Emacs are in the distribution in the man
directory.

easymenu provides for common menus for Emacs 19 and Lucid Emacs 19.

**Never** use string-match to check Emacs version in a Lisp file without
save-match-data as well; the reason is that files can be loaded at any time
(due to autoload) and loading a file shouldn't modify match-data.

To figure out how to bind a key in Emacs, first do it using M-x
global-set-key, then use repeat-complex-command to see the Lisp representation.

Version control keystrokes:
```
  C-x v =    Compare buffer with latest checked-in version
```

In an Emacs shell, if tabs are expanded into an (incorrect) number of
spaces, do `stty tabs' -- probably in one of your dotfiles.

In Emacs 20, to remove text properties (such as faces/fonts/colors) from a
string, use (format "%s" string-with-properties).
In Emacs 21, use `copy-sequence' to copy the string, then use
`set-text-properties' to remove the properties of the copy.

To avoid compiler warnings about undefined symbols, consider compile-time
require:  (eval-when-compile (require 'dired))
The downside is that the require also happens if the uncompiled code is
loaded.

etags returns the best matches in a TAGS table first; however, it examines
entire TAGS tables at a time, so it is advantageous to use a single TAGS
table instead of multiple smaller ones (along with include directives).

Emacs perl (and cperl) mode mismatches the parentheses in "(\b|$)" because
"$)" looks like a variable rather than looking like it contains a close
parenthesis.  The solution is to reverse the parts of the test:  "($|\b)".

When debugging Emacs Lisp that does frame/window/buffer switching:
> (setq special-display-buffer-names '("**Backtrace**"))

Emacs pretests are available from alpha.gnu.org,
but a better way to get them is via CVS:
```
cvs -z3 -d:pserver:anonymous@cvs.savannah.gnu.org:/sources/emacs co emacs
```

pcl-cvs used to be distributed with CVS, in its tools/pcl-cvs directory.
Now it is distributed with Emacs.

To save a DOS file using Unix end-of-line (carriage-return and newline)
conventions, in Emacs do
```
  (setq buffer-file-coding-system nil)
```
Or, use the dos2unix program.
To save a file with DOS end-of-file conventions, in Emacs do
```
  C-x <RET> f dos <RET>
```

To add to the existing list of tags tables, do
```
(let ((tags-add-tables t))
  (visit-tags-table FILE))
```

New in Emacs 20.4:
See new functions file-expand-wildcards, with-temp-message.
See new command pop-tag-mark.

To start an Emacs using a smaller font size,
```
  emacs -fn 7x13
```
To change the font while emacs is running,
```
  M-x set-frame-font RET 9x15 RET
```
To list available fonts:
  * use program xlsfonts.
> > Any font with `m' or `c' in the SPACING field of
> > the long name is a fixed-width font.  Here's how to use the `xlsfonts'
> > program to list all the fixed-width fonts available on your system:
> > > xlsfonts -fn '**x**' | egrep "^[0-9]+x[0-9]+"
> > > xlsfonts -fn '**-**-**-**-**-**-**-**-**-**-**-m**'
> > > xlsfonts -fn '**-**-**-**-**-**-**-**-**-**-**-c**'
  * see variable x-fixed-font-alist
  * run (x-list-fonts "**")
To see what a particular font looks like, use the `xfd' command, eg
```
  xfd -fn 6x13
```**

If starting Emacs gives an error like ``Font `Inconsolata 12' is not defined``,
then do:
```
 emacs --font Monospace
```
since that font is generally defined.

To recompile my emacs directory:
emacs -batch -l $HOME/.emacs -f batch-byte-recompile-directory $HOME/emacs/ |& grep -v '<sup>Add to load-path: ' | grep -v '</sup>Checking'

This bit of text makes Emacs automatically update the date at the bottom of
a webpage when it is saved.
```
  <hr />
  <p>
  Last updated: July 4, 1776
  </p>
  </body>
  </html>
  <!--
  Local Variables:
  time-stamp-start: "^Last updated: "
  time-stamp-end: "\\.?$"
  time-stamp-format: "%:b %:d, %:y"
  time-stamp-line-limit: -50
  End:
  -->
```

On Debian, site-local .el Emacs Lisp source code files are installed in
(for example)
```
  /usr/share/emacs/site-lisp/
```
as distinguished from where the .elc versions can be found:
```
  /usr/share/emacs22/site-lisp/
```

To run a command whenever a file is saved, add to its end:
```
# Local variables:
# eval: (add-hook 'after-save-hook '(lambda () (shell-command "make")) nil t)
# end:
```

To select an input method [e.g., spanish-postfix, to get accents] in Emacs:
```
  C-x <RET> C-\ METHOD <RET>
```
To enable/disable the selected input method:  C-\

Emacs and multibyte encodings:
Emacs 22 and earlier saves non-ASCII files in its own internal file format,
called mule.
This format has some advantages; for example, like unicode, it can specify
characters in a variety of input formats.  However, a serious disadvantage
is that the mule format is not recognized by other programs; for example,
printing such a file from the command line (or via enscript) leads to
gibberish.  (Doing so from within Emacs does the right thing.)  To make
Emacs save files in a different format, after reading the file, do "M-x
set-buffer-file-coding-system".  Also consider adding a line like "-**-
coding: latin-0 -**-" to the top of the file, or in the local variables
section.  (Even without this, Emacs ought to recognize the file's format
when you read it back in, though Emacs can't tell among the various latin-X
variants.)

crypt.el :
http://cvs.xemacs.org/viewcvs.cgi/XEmacs/packages/xemacs-packages/os-utils/crypt.el
It's best, I think, to encrypt the file via the command line rather than
trying to create an encrypted file within Emacs.
Example:
```
  openssl enc -bf -e -in file -out file.bfe
```
(But I don't need to use any special suffix.)

To do incremental search (isearch) across multiple files or buffers:
  * In dired, `M-s a C-s` for isearch across marked files.
  * In dired, `Q` does query-replace-regexp on all marked files.
  * In buffer-menu (Buffer List buffer) `M-s a C-s` for isearch across marked buffers.

To override dtrt-indent (which guesses indentation), do:
```
  (set (nth 2 (assoc major-mode dtrt-indent-hook-mapping-list)) 2)
```
This is not the same as Emacs's tab-width or c-indent-level, but I'm including
them in this entry because someone searching for this entry might use them.

In Mew, use the following for searching:
  * `C-cC-s`

> > Incremental search forward in Message mode, only within the
> > current message.
  * `C-cC-r` Incremental search backward in Message mode, only within the
> > current message.
  * `?`
> > Put the `*` mark onto messages in this folder, which are matched
> > to a specified pattern. Either `mewl` or `grep` is called according to
> > the specified pattern.

In Mew, bcc: changes the Subject to "A blind carbon copy".
To keep the original Subject line, use dcc: instead of bcc:.

In Emacs, to search and replace a regex across multiple files:
  * M-x find-grep-dired RET my-regex RET
  * mark files of interest: `% m`
  * invoke search and replace: `Q`
To search through symbolic links, first do
> > (setq find-program "find -L")

In Emacs, to edit a file with long lines so the display wraps/flows/fills
the lines but the underlying buffer text retains long lines, use M-x
visual-line-mode.  It's better than longlines mode.


<a href='Hidden comment: 
% This last  is to prevent emacs from thinking the local variables above
% are for real; there are no local variables mentioned on the last page now.
'></a>