# Programming languages


On github.com, you can view the table of contents of this file by clicking the
menu icon (three lines or dots) in the top corner.


## Perl


To install Perl dependencies from a `cpanfile`, run the following in the directory that contains `cpanfile`:

```sh
sudo cpanm --installdeps .
```


Perl5:

* arguments are in `+@_+`, that is `+$_[0]+`, `+$_[1]+`, etc.
* "local" gives dynamic scoping; "my" gives static scoping.  But "local" does not seem to work for imported variables (declared via @EXPORT in a module).
* Forward jumps screw up containing for loops, it seems.
* foreach implicitly localizes the argument inside the for body.
* `wantarray` (no parens) returns true if current sub called in list context


Perl5 regexps:

* To match end of line without newline, `\Z(?!\n)`.
* Add `?` after a repetition operator to render it stingy instead of greedy: `foo(.*?)bar`
* To quote regexp metacharacters, use `\Q...\E` or `quotemeta()`.
* `(?:REGEXP)` is like `(REGEXP)` but doesn't make backreferences.

Perl5 data structures:

```text
  @foo[$bar] => my @foo; returns one-element slice of foo = ($foo[$bar])
  @{$foo[$bar]} => my @foo = list of references to arrays; @{...} converts
    such a reference into the referred-to array
  @{$foo}[$bar] => foo = reference to array; take that array's bar'th element
```

Don't assign result from splice; use `splice(@foo, $i, 0)`, not `@foo = splice(...)`


Perl to consider:

```text
 @_ => @ARG; $_ => $ARG
 Packages: class::template, alias
 -d:DProf flag to profile
 -I to add include path (do this as an alias??)
 -u  (faster startup; why?)
 Compiler: do  "perl -MO=C foo.pl > foo.c"
```


Perl 5 uses $PERLLIB environment variable as include path for libraries


In awk, perl, and C, output format "%2.1f" rounds, does not truncate.


Perl regular expression to match a string:

```perl
  /"([^"\\]|\\[\000-\377])*"/
```


In Perl, to read (slurp) a whole file into a string, do

```perl
          undef $/;
          $_ = <FH>;              # whole file now here
```

To read an entire file in perl:

```perl
open(FILE, "data.txt") or die("Unable to open file");
@data = <FILE>;
close(FILE);
```


To run Perl interactively, invoke the Perl debugger on an empty program:

```sh
   perl -de 42
```


In Perl, to count the number of newlines (or any other character) in a
string, use tr/\n// (or tr/\n/\n/).


To make a script use perl without specifying an explicit #!path, adjust the
"-n" flag as appropriate, then put this at the top instead of #!/usr/bin/perl:

```sh
#!/usr/bin/env perl
```

or, alternately:

```sh
: # Use -*- Perl -*- without knowing its path
  eval 'exec perl -S -w -n $0 "$@"'
  if 0;
```

Using `#!/usr/bin/perl` is faster but requires knowing perl's path.


To install/build a perl module, do the following as root:

```sh
  perl -MCPAN -e shell
  install MIME::Base64
```

For more details, see ~mernst/wisdom/building/build-perl-module


In Perl, to determine whether file named $foo exists, use "if (-e $foo) ...".


Perl scripts should start this way, for portability and error checking:

```perl
#!/usr/bin/env perl
use strict;
use English;
$WARNING = 1;
```


In perl:

* To read a whole file:  $/ = undef.
* To read by paragraphs:  $/ = "\n\n".
* To read by paragraphs, eliminating empty paragraphs: $/ = "".
* $/ is also known as `$RS` or `$INPUT_RECORD_SEPARATOR`.

In perl, to properly open a file, check like this:

```perl
  open(FILE, $filename) or die "Can't open '$filename': $!";
```


In Perl, Date::Manip seems a touch nicer than Date::Calc.
(There's also Date::Format and Date::Parse, but Date::Manip does it all.)


To disable Perl's "deep recursion" warnings (they're not errors), use

```perl
  no warnings 'recursion';
```


In Perl, here is a way to extract the unique elements from a list.

```perl
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

```perl
use FindBin ();
use lib "$FindBin::Bin";
```


To lint Perl:

```sh
perl -Mstrict -Mdiagnostics -cw <file>
```

(Maybe: `perl -I /path/to/dependency/lib -c /path/to/file/to/check` .)
For Perl coding standards:

* Perl::Lint
* Perl::Critic: run with: `perlcritic --brutal --verbose 9 file.pl`


To lint/format/pretty-print perl files, put this in the Makefile:

```make
PERL_FILES   := $(shell grep -r -l --exclude='*~' --exclude='#*' --exclude='*.tar' --exclude=gradlew --exclude-dir=.git '^\#! \?\(/bin/\|/usr/bin/env \)perl'   | grep -v addrfilter | grep -v cronic-orig | grep -v mail-stackoverflow.sh)
perl-style-fix:
 perltidy -b ${PERL_FILES}
perl-style-check:
 perltidy -w ${PERL_FILES}
```


To convert a Perl program with POD ("plain old documentation") embedded
documentation into a man page, run pod2man.  For example:

```sh
  pod2man my-script.pl | nroff -man
```


## Python


In Python, by default variables have function (not block) scope.  To refer
to (really, to change) a global variable, use the "global" declaration in
the class/function/whatever.


To test whether a file exists in Python, do os.path.exists('/file/name').
In Python, to reimport module foo, do reload(foo).


Python debugger:  pdb ~/python/test.py
You need to "s"tep a few times before "n"ext, which would jump over the
entire program.  Or just do "continue" to the error.


For time-critical Python runs, disable assertions via `-O` command-line
option to Python or setting variable `__debug__` to false:  `__debug__ = 0`.
You can be sure that the optimized version is running if a `.pyo` instead of
a `.pyc` file is created after you do `import`.
To make Python run optimized, do:

```elisp
  (setq-default py-which-args (cons "-O" (default-value 'py-which-args)))
```

To make Python run unoptimized, do:

```elisp
  (setq-default py-which-args (delete "-O" (default-value 'py-which-args)))
```

To evaluate these in Emacs, put the cursor at the end of the line and type
<kbd>C-x C-e</kbd>.
After you change `py-which-args`, kill the `*Python*` buffer and restart
(it's not enough to kill the Python process and restart).


As of Python 1.5.1, cPickle is buggy; don't use it in preference to pickle,
even if it is faster...


Typical Makefile rules to enforce Python style rules:

```make
style-fix: python-style-fix
style-check: python-style-fix
PYTHON_FILES:=$(shell find . \( -name ".git" -o -name ".venv" \) -prune -o -name '*.py' -print) $(shell grep -r -l --exclude-dir=.git --exclude-dir=.venv --exclude='*.py' --exclude='*~' --exclude='#*' --exclude='*.tar' --exclude=gradlew --exclude=lcb_runner '^\#! \?\(/bin/\|/usr/bin/env \)python')
python-style-fix:
ifneq (${PYTHON_FILES},)
 @ruff --version
 @ruff format ${PYTHON_FILES}
 @ruff -q check ${PYTHON_FILES} --fix
endif
python-style-check:
ifneq (${PYTHON_FILES},)
 @ruff --version
 @ruff -q format --check ${PYTHON_FILES}
 @ruff -q check ${PYTHON_FILES}
endif
python-typecheck:
ifneq (${PYTHON_FILES},)
 @mypy --version
 @mypy --strict --install-types --non-interactive ${PYTHON_FILES} > /dev/null 2>&1 || true
 mypy --strict --ignore-missing-imports ${PYTHON_FILES}
endif
showvars:
 @echo "PYTHON_FILES=${PYTHON_FILES}"
```


To activate conda:

```sh
source activate <yourenvironmentname>
```


To disable tqdm output:

```python
from functools import partialmethod
if os.getenv("TERM", "dumb") == "dumb":
    tqdm.__init__ = partialmethod(tqdm.__init__, disable=True)
```

More info at:
<https://github.com/tqdm/tqdm/issues/619#issuecomment-425234504>
<https://stackoverflow.com/a/67238486/173852>


Write Python docstrings as a command ("Do this", "Return that"), not as a description ("Does this", "Returns that").
Write `@override` on an overriding method; this requires `from typing import override`.


Running `mypy` on a script without a `.py` extension yields "error:  Duplicate
module named '__main__'".  To fix it, pass `--scripts-are-modules` to `mypy`.


In Python, instead of `datetime.date.today()`, use `datetime.now().astimezone()`.


To suppress a Ruff error or warning message on one line of code:

```python
.... # noqa: F401
```


The simplest way to read or write a a whole file into a string in Python is:

```python
from pathlib import Path
file_content = Path('filename.txt').read_text()
Path('filename.txt').write_text(new_file_content)
```


## Rust


Rust code should have, in its main file (such as `main.rs`):

```rust
#![warn(missing_docs)]
```


## Shells


Parsing command-line arguments in a Posix shell script:
<https://gist.github.com/deshion/10d3cb5f88a21671e17a>


Redirecting output in command shells:

* In sh/bash (in a shell script):
  * To redirect standard error to standard output, use `2>&1`.
      Warning:  this must come after any file redirection:  `cmd > file 2>&1`.
      This is because `2>&1` means to make stderr a copy of stdout.  If you
      redirect to a file with `> file` after doing so, then stdout is
      reopened as the file, but stderr (a copy of the original stdout) is
      not affected.
  * To redirect standard output to standard error, use `>&2`.
      For example, `echo "to stderr" >&2`.
  * To send both standard error and standard output through a pipe: `2>&1 |`.
     There are simpler commands in bash, but they don't work in sh.
  * To redirect standard error to a file, use `2>filename`.
     For more details, see <http://tomecat.com/jeffy/tttt/shredir.html>
* In csh/tcsh:
  * To overwrite an existing file, redirect via `>!` instead of `>`.
  * To redirect both standard error and standard output to a file,
    use `>&` (`>` redirects just standard output to the file).
  * To redirect standard error and output through the pipe, use `|&`.


In bash shell scripts, `"$@"` mans all the arguments, and it quotes each argument
individually before concatenating them (separated by spaces).
In bash, to do an extra level of shell expansion on "FOO", use "eval echo FOO".
In csh shell scripts, `$*` means all the arguments.


In bash, interactive shells call `.bashrc`; noninteractive shells call
`.bash_profile`.


In tcsh, a for loop looks like

```csh
  foreach var (a b c d)
    use $var
  end
```

In bash, a for loop looks like

```sh
  for name [ in word ] ; do list ; done
```


In bash, the exit status ("exit code") of a command is stored in variable "$?".
In csh, it is stored in variable "$status".
Zero means success, non-zero means failure.


Command substitution, performed by a subshell, in csh/bash:
enclose in backquotes/backticks (+\`...`+).
In sh, it's better style to use +$(...)+ than +\`...`+, but both have the same effect.


Bash's `hash -r` command is equivalent to csh's `rehash`.


When debugging a bash script, it can be helpful to turn on Bash's strict
error handling and debug options (exit on error, unset variable detection
and execution tracing) to make sure problems are caught early:

```sh
  #!/bin/bash
  set -o errexit -o nounset
  ...
```

For a Posix shell script to halt on error, use:

```sh
  set -e
```

Also consider:

* `set -x` (or `set -o xtrace`): Display commands and their arguments as they are executed.
* `set -v`: Display shell input lines as they are read.

It's also possible to set these when running the script:

```sh
  sh -xv myscript.sh
```


By default, a shell script continues if a command within it fails.  This is
highly error-prone.  To halt/stop on error, almost all shell scripts should start with

```sh
set -e
```

If it's a bash script (bash 3.0 or later), it should also contain

```sh
set -o pipefail
```

If there is a command that is allowed to fail, add `|| true` at its end.


To get bash 3.0 to fail if any command in a pipeline fails, do

```sh
  set -o pipefail
```

or launch bash with

```sh
  bash -o pipefail
```

To give make this semantics, put the following in the Makefile:

```sh
  export SHELL=/bin/bash -o pipefail
```

Alternatives, if you are stuck with bash 2.x:
  `${PIPESTATUS[n]}` where n=0 is the status from the first command in the pipe.
The exact syntax for a Makefile is:

```make
  foo | bar | baz && exit $${PIPESTATUS[0]}
```

or the following simple bash script that preserves exit status

```sh
  export result=$?
  cat | $*
  exit $result
```


The Unix program "timeout" seems to subsume `exec_cpu_limited` (and perhaps
more).
The shell builtin "ulimit" can be used to limit a processes stack size, CPU
time, virtual memory, etc.


In general, a bash script should contain this at the top:

```sh
  set -euo pipefail
```

and optionally

```sh
  set -o xtrace
```


To get a shell in which none of your personal customizations (environment
variables) are set, do:

```sh
  exec -c bash --noprofile --norc
```

(There is not a way to do this directly via ssh, which always reads your
.bashrc file.)
A problem is that with DISPLAY not set, X programs such as xterm do not
work.
I tried

```sh
   echo $DISPLAY > ~/tmp/display
   xauth list > ~/tmp/xauth-list
   exec -c bash --noprofile --norc
   export DISPLAY=`cat ~/tmp/display`
   xauth -f ~/.Xauthority-2 add [relevant a line from ~/tmp/xauth-list]
```

but this did not work; I still got

```text
  X11 connection rejected because of wrong authentication.
```


To create a shell with no environment variables set:

```sh
 /usr/bin/bash --noprofile --norc
```


In Unix/Linux, owner permissions take precedence over group permissions.
Suppose a file has o-w and g+w permissions, and suppose that the owner is
in the group.  Then the owner cannot write the file.


A portable way to obtain the absolute path of a directory:

```sh
dir="$(unset CDPATH && cd "$dir" && pwd)"
```


Diagnostics for shell scripts (`set -o pipefail` is only for bash):

```sh
set -eu
set -o pipefail
```

In more detail:

```sh
# Print each command before executing it
set -x
# Exit the script if any statement returns a non-true value.
# Can temporarily disable within `set +e ... set -e`.
# There are exceptions; for example, commands in a
# pipeline, other than the last one, are immune.
set -e
set -o pipefail
# Warn about unset variables
set -u
```


To suppress a pylint warning, write inline:

```python
# pylint: disable=too-many-locals
```


The `shellcheck` program is a linter for sh and bash scripts.  Run like:

```sh
shellcheck --format=gcc
```

There is also `checkbashisms`.
Here are Makefile rules to run them:

```make
SH_SCRIPTS   := $(shell grep -r -l --exclude='#*' --exclude='*~' --exclude='#*' --exclude='*.tar' --exclude=gradlew --exclude-dir=.git '^\#! \?\(/bin/\|/usr/bin/env \)sh'   | grep -v addrfilter | grep -v cronic-orig | grep -v mail-stackoverflow.sh)
BASH_SCRIPTS := $(shell grep -r -l --exclude='#*' --exclude='*~' --exclude='#*' --exclude='*.tar' --exclude=gradlew --exclude-dir=.git '^\#! \?\(/bin/\|/usr/bin/env \)bash' | grep -v addrfilter | grep -v cronic-orig | grep -v mail-stackoverflow.sh)
CHECKBASHISMS := $(shell if command -v checkbashisms > /dev/null ; then \
   echo "checkbashisms" ; \
 else \
   wget -q -N https://homes.cs.washington.edu/~mernst/software/checkbashisms && \
   mv checkbashisms .checkbashisms && \
   chmod +x ./.checkbashisms && \
   echo "./.checkbashisms" ; \
 fi)
shell-style-fix:
ifneq ($(SH_SCRIPTS)$(BASH_SCRIPTS),)
 @shfmt -w -i 2 -ci -bn -sr ${SH_SCRIPTS} ${BASH_SCRIPTS}
 @shellcheck -x -P SCRIPTDIR --format=diff ${SH_SCRIPTS} ${BASH_SCRIPTS} | patch -p1
endif
shell-style-check:
ifneq ($(SH_SCRIPTS)$(BASH_SCRIPTS),)
 @shfmt -d -i 2 -ci -bn -sr ${SH_SCRIPTS} ${BASH_SCRIPTS}
 @shellcheck -x -P SCRIPTDIR --format=gcc ${SH_SCRIPTS} ${BASH_SCRIPTS}
endif
ifneq ($(SH_SCRIPTS),)
 @${CHECKBASHISMS} -l ${SH_SCRIPTS}
endif
showvars:
 @echo "SH_SCRIPTS=${SH_SCRIPTS}"
 @echo "BASH_SCRIPTS=${BASH_SCRIPTS}"
```

Also consider adding rules to enforce Python style, which appear elsewhere in this file.


Use a directive to disable/ignore/suppress a certain instance of a shellcheck warning/error:

```sh
hexToAscii() {
  # shellcheck disable=SC2059 # Justification goes here.
  printf "\x$1"
}
```


Typical Makefile rules for markdownlint-cli2:

```make
style-fix: markdownlint-fix
markdownlint-fix:
 markdownlint-cli2 --fix "**/*.md" "#node_modules"
style-check: markdownlint-check
markdownlint-check:
 markdownlint-cli2 "**/*.md" "#node_modules"
```


Typical gradle buildfile rules for markdownlint-cli2:

```gradle
/* Validate Markdown files. */
tasks.register("markdownlint", Exec) {
  group = "Verification"
  description = "Run markdownlint-cli2 linter on Markdown files"
  executable = "markdownlint-cli2"
  args(".")
}
check.dependsOn("markdownlint")
```


To create a "here document"

```sh
cat > myfile.txt <<END
... Contents of myfile.txt ...
END
```


To determine the directory containing the currently-executing shell script:
bash:

```bash
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
```

sh:

```sh
SCRIPT_DIR="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd -P)"
```


## C and C++


In C++, an auto_ptr is automatically deleted at the end of its scope.


In C++,
char *const s;   declares a constant pointer to possibly varying data
const char* s;   declares a possibly varying pointer to constant data
char const *s;   is the same as "const char* s"
In other words, const modifies the type-element to its left.
Put another way:  "const" and "int" are declaration specifiers which may
occur in any order; "* [const]" is a type modifier.


Do not use dbmalloc; use dmalloc instead.


The GNU program checker (gccchecker) detects memory use errors in a program.


To run just the GNU C preprocessor (analogous to cpp), do `gcc -E`.
To suppress line markers (line numbers) in the output, use `gcc -E -P`.
To retain comments (`/*...*/`) in the output, use `gcc -E -C`.


When compiling a C program with `cc`, put the `-lLIBNAME` flag at the end of
the line, after the cfile name (the order matters).


Debugging C memory (pointer) corruption problems:

* Electric Fence (efence) is distributed with (some versions of?) Linux, and
   is available from ftp://ftp.perens.com/pub/ElectricFence/.
   It uses the virtual memory hardware to detect the instruction at which a
   bad memory reference occurs.  (I had a problem with it running out of memory.)
  * `setenv MALLOC_CHECK_ 2`
  * compile with `-lefence`
* GNU Checker:  like Purify (includes gc).
   <http://www.gnu.org/software/checker/checker.html>, ftp://alpha.gnu.org/gnu
   It's sometimes called gccchecker or checkergcc.
   It has not been tested on C++ (or updated since August 1998, as of 6/2001).
* Other Purify-like tools:  <http://www.hotfeet.ch/~gemi/LDT/tools_deb.html>
* (libYaMa detects leaks and some other memory errors; is a malloc replacement:
   <http://freshmeat.net/projects/libyama/>)
* Also consider dmalloc (debug malloc); don't use dbmalloc.
   (dmalloc is somewhat distributed with Linux; I had trouble making it work.)


The `c++filt` program demangles (unmangles) mangled overloaded C++
method/function names.


To write a cpp macro which takes a variable number of arguments:
One popular trick is to define the macro with a single argument,
and call it with a double set of parentheses, which appear to
the preprocessor to indicate a single argument

```c
#define DEBUG(args) {printf("DEBUG: "); printf args;}
if(n != 0) DEBUG(("n is %d\n", n))
```


To strip all comments and blank lines from a (Java or C) file, use

```sh
  cpp -P -nostdinc -undef
```

(This also expands any #include directives.)
This can help in computing non-comment non-blank (NCNB) lines of code
(though you may want to remove #include directives before doing that, then
reinsert them afterward).  The script ~jhp/bin/ncnbcode.php accepts
a list of files and reports their ncnb lines of code, all lines, and
a total.

This error:

```text
    Undefined symbol            first referenced in file
    socket                              /usr/X11R6/lib/libX11.so
```

means I should add more "-lsocket" and such flags to my link command.  Do
"man *undefinedsymbol*" to see where the symbol is defined.


Insight:  GUI front end to gdb.
<http://sources.redhat.com/insight/>
Also see DDD.


gdb:

* For wide strings, just print with wstring2string.
* "x/20s wstr" gives characters one per line; look at every third element.
* "print wstr@20" gives characters on one line, but in ASCII.


If having trouble with gdb not being able to step over inlined functions,,
add these arguments to gcc:

```sh
 -O0 -fno-default-inline -fno-inline
```


The single bracket `[` is an alias for the `test` command.
`[` is specified by Posix and works in any implementation of sh.
The double bracket `[[` is a builtin (is syntax) and is desirable because
it is less error-prone and more featureful.  However, `[[` is less
portable; it works in bash, ksh, and zsh.
For more on the difference between `[` and `[[`, see <http://mywiki.wooledge.org/BashFAQ/031>


