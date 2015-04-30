Contents:




---

# Other ways to RCS #

My ideas about using version control (VC) vs. rsync vs. Unison:
  * VC is essential when others will collaborate.
  * Unison is useful when the files are very large and/or change frequently, or I wish to update them automatically on the central host without logging in to that host.
  * VC is useful when I only want to include certain files, not all files (for instance, my "dots" directory).
  * VC is useful when I expect the files to change in multiple places.

To mirror one directory to another (including deletions), you can use:
```
  rsync --omit-dir-times --recursive --quiet --delete DIR1 DIR2
  # This one sets directory times too, which can be a problem
  rsync -Cavz --quiet --delete DIR1 DIR2
```



---

# RCS #

To set up RCS, create a subdirectory called RCS in the directory with the files.
To add a file:
```
  chgrp medics <filename>
  ci -u <filename>              check in the file
  rcs -a<namelist> <filename>   add <namelist> (eg: mernst,todd) to access list
  rcs -L <filename>             add owner of file (eg comp212) as well
```
When you check in an RCS file via Emacs, type  C-c C-c  to finish the comment.



---

# CVS #

File cvs-intro in this directory is a quick beginner's guide to the CVS
version control system.

CVS update: get from repository
In update output, my version comes first, latest repository second.
-q means somewhat quietly; suppress informational messages
```
 cvs -q update
 # really quiet:
 cvs -q update |& egrep -e "^C "
 # even more quiet:
 cvs -q update | grep -v '^U ' | grep -v '^retrieving revision' | grep -v '^RCS' | grep -v "^Merging differences" | grep -v "^cvs update: conflicts found" | grep -v "^rcsmerge: warning: conflicts during merge"
```

CVS diff: show differences
```
 cvs diff
 cvs diff -b  -- ignore whitespace changes
 cvs diff -u  -- use unidiff format
 cvs diff -u -r BASE -r HEAD  (what have others changed since I last updated?)
 cvs diff -D "1 week ago"     (or various other date formats)
 cvs diff -r 1.8 -r 1.9
 cvs diff --brief             only list names of changed files
```

To create a new repository (this is not the same as creating a
project/module!):
```
  cvs -d ~/mydir/.CVS init
```
Then, you must ensure the appropriate group can read/write it.  (Entire CVS
repository must be readable, and CVSROOT/history must be readable and
writeable, by all repository users.  Files with ",v" counterparts (and the
",v" files themselves) shouldn't be writeable, however.)
```
  # NFS
  chgrp -R grants ~/mydir/.CVS
  chmod g+s `find ~/mydir/.CVS -type d`
  # AFS
  ... [need to write these instructions]
```
To create a project (aka module):
```
  mkdir ~/mydir/.CVS/new-module-name
```
> then possibly edit the loginfo file to have mail sent (or some other
> action taken) whenever a checkin occurs.

To check out a module (aka project) from a CVS repository:
```
  cvs -d REPOSITORY-LOCATION checkout MODULE-NAME
```
Examples:
```
  cvs -d ~gjb/.CVS-macros checkout macros
  cvs -d ~mernst/class/573/project/.CVS-medics checkout code
  cvs -d :ext:mernst@pag.csail.mit.edu:/g4/projects/invariants/.CVS checkout papers/esc-annotate-paper
  cvs -d :ext:mernst@palpatine.mit.edu:/home/adbirka/.cvs checkout anstatic
  cvs -d :ext:onion.csail.mit.edu:/afs/csail.mit.edu/u/m/mernst/prof/grants/.CVS co 2005-10-darpa-appcommunities
  cvs -d :pserver:ernst@oss.software.ibm.com:/usr/cvs/jikes login
  cvs -d :pserver:ernst@oss.software.ibm.com:/usr/cvs/jikes checkout -ko jikes
```
Another way to use a remote repository:
```
  setenv CVSROOT :pserver:anoncvs@CVS.Sourcery.Org:/cvs/jikes
  cvs login
  paswsd anoncvs
  cvs checkout -ko jikes
```
From Windows:
```
  cvs -d //pag.csail.mit.edu/mernst/.CVS/.CVS-mernst checkout -ko emacs
```
To check out an old version (from a specific date, as of a given date), run
this from ~/tmp:
```
  cvs -d ~gjb/.CVS-macros checkout -D "1 Jan 1998" macros
```

In CVS, to add a file, do 2 things:
```
 cvs add FILENAME
 cvs commit FILENAME
```
When adding binary files to CVS, use the -kb flag:
```
  cvs add -kb filename
```
To add the -kb flag to a file that is already in CVS:
```
  cvs admin -kb filename
```
To commit changes
```
 cvs commit  -- commits all changed files in current directory
```
To quit working and delete your personal copy
```
 cvs release -d
```
To obtain a lock (aka watch),
```
 cvs edit paper.tex
```
To see the change logs:
```
 cvs log evilmacros
```
To get new directories, do "cvs update -d" instead of "cvs update".
> To avoid the need for this, one should really have
```
    diff -u
    update -d -P
```
> in one's .cvsrc file

To create a branch in CVS (this from Dave Grove via Jake Cockrell):
```
  cd fromdir; tar cf - . | (cd todir; tar xfBp -)
    cvs tag <branch_point_tag>
    cvs rtag -b -r <branch_point_tag> <branch_tag> module
    cvs update -r <branch_tag>
  cvs commit
```

To make the HEAD and BASE tags work in CVS, add to directory CVSROOT (in
the true repository) a file val-tags containing:
```
HEAD y
BASE y
```

For email or other notification whenever a CVS
checkin occurs, add the actions to the CVSROOT/loginfo file in the
repository.  For example, you might add this line to the CVSROOT/loginfo file:
```
  ^my-module-name    mail -s "CVS checkin my-module-name" me@mymail.com,you@yourmail.com
```
As another example, this is in Scwm's loginfo file (unindented):
```
  ^scwm-web /usr/local/bin/cvslog scwm-web; ( date; ( sleep 2; \
  cd /home/httpd/html/scwm; cvs update -dP ) &) \
  >> /usr/local/home/gjb/cvslog/err-scwm-web 2>&1
```
The cvslog command just mails the other devs on a commit, but the rest
does an auto-update of the web page to the place where it is served.
This happens on each commit, and the output goes to a file.
On AFS, use something similar to the following to auto-update on commit:
```
  ^bib (cd /afs/csail.mit.edu/group/pag/www/bib; fs sa . pag rlidwka; \
        cvs -q up >/dev/null; fs sa . pag rla)
```

In inetd.conf, the cvspserver notation must be all on one line!
(At least on redhat-release-6.2-1.)

Anonymous cvs server:
After editing /etc/inetd.conf, cause inetd to reread the file with "killall
-HUP inetd".
Make sure repository is readable (and directory is writeable) by anonymous user.
Add "passwd" and "readers" files in CVSROOT.

cvs diff does not permit specifying both the -D "date" and the -r "tag"
options for its arguments; each argument gets to use at most one of those
two options.  (This means, for example, that you cannot use cvs diff to
determine what has changed in a branch since a particular date.)  To work
around this problem, make a new checkout with the appropriate date and
tags, and then use ordinary diff to compare that to another checkout
(perhaps your current one).
> For instance, to see what has changed in Daikon V2 since a particular
date, do (in a temporary directory):
```
  cvs -d /g4/projects/invariants/.CVS co -r ENGINE_V2_PATCHES -D 2003/06/09 invariants/java/daikon
```
and then diff that directory against your daikon.ver2 directory.

If CVS says
```
  cvs checkout: Updating module
  cvs checkout: failed to create lock directory for `/some/path/module' (/some/path/module/#cvs.lock): Permission denied
  cvs checkout: failed to obtain dir lock in repository `/some/path/module'
  cvs [checkout aborted]: read lock failed - giving up
```
Then the problem is typically that the person who created the CVS
repository has left it (as default) manipulable only by that person.
NFS:
> The directory's group should be changed, and the group should be
> given permission for all the files in the directory.
```
    chgrp -R groupname .
    find . -type d | xargs chmod g+s
```
AFS:
> [be written.](To.md)

To determine who has made a cvs checkin since a particular date, use "cvs
log" or "cvs history"; "cvs history" is the better way.  For example,
```
  cvs history -a -c -D "2003/12/22 02:05"
```
(Is the time local or GMT?)

By default, it is not easy to give read-only access to a CVS repository.
Just to do a checkout, CVS wants to create a read lock file "#cvs.lock" in
each directory of the CVS repository; and the ability to create and delete
files essentially gives all write privileges.
> You can patch CVS to add a "-u" option to allow checkouts without read
locks.  The intent is to allow read-only operations such as "checkout"
to succeed for users who do not have write access to the repository.
The patch is at
> http://ximbiot.com/cvs/cvshome/dev/patches/readlock
and is potentially dangerous, but generally seems to work.
It's installed on Athena, so you can try it with
```
  /afs/athena.mit.edu/project/gnu/arch/i386_linux24/bin/cvs -u -d path/to/root co module
```

In CVS/SVN, "reserved checkout" or "file locking" is the name for user locks
that permit only one user to edit a file at once, forbidding simultaneous
editing.
"advisory locks" are a distinct mechanism that serves a similar purpose.
Also, the
svn:needs-lock property signifies that the file it's attached to ought to
be locked before editing (by running "svn lock"). The value of the property
is irrelevant.
.
SVN locking avoids conflicts when two people edit the same file unknowingly.
http://svnbook.red-bean.com/en/1.2/svn.advanced.locking.html
Before you can edit a file, do
```
 svn lock filename -m"comment"
```
(or in Eclipse, do Team > Lock).
When you commit, that releases the lock.

In CVS, to get a copy (cat) of a specific revision of a file (the version
as of a given date), without setting any sticky tags:
```
  cvs update -p -r <version> file > file-old
  cvs update -p -D 2008-11-27 file > file-20081127
```
To check out an old version (from a specific date, as of a given date), run
this from ~/tmp:
```
  cvs -d ~gjb/.CVS-macros checkout -D "1 Jan 1998" macros
```



---

# SVN #

To make a new, empty SVN repository:
```
  svnadmin create --fs-type fsfs DIR
```
CSE requires this flag also, as of 6/15/2009:  --pre-1.5-compatible
(DIR must be a path, not a URL.)
(DIR is often a subdirectory named for the project of a directory named
.SVNREPOS .  Or it could just be .SVNREPOS if there will never be more than
one repository needed in that place.  Users can always just check out part
of the repository.)
Examples:
```
  svnadmin create --fs-type fsfs --pre-1.5-compatible $HOME/prof/grants/.SVNREPOS
  chmod -R g+w $HOME/prof/grants/.SVNREPOS
```
Now, you may immediately check it out with a command
```
  svn checkout URL
```
where URL is of the form
```
  file:///homes/gws/mernst/prof/grants/.SVNREPOS/myproj
  svn+ssh://login.csail.mit.edu/afs/csail/group/pag/projects/.SVNREPOS/igj
```
.
The simple approach above does not set up the "trunk, tags, branches"
structure, but I'm not entirely sure how to do that or even what the point
is.

To make SVN ignore a file or files, like the ".cvsignore" file does, do
```
  svn propedit svn:ignore .
```
(where "." is the directory to edit).

To make SVN update the `$Id: ...$` text in a file, use
```
  svn propset svn:keywords "Id" filename...
```

"svn ls URL" tells which modules are in that repository.

(Isn't there a single script that does all this, too?)
From Seth Teller: how to recover a repos "papers" created with BDB
(doesn't mix with AFS), and convert it to FSFS:
```
# correct any errors in place
svnadmin recover /afs/csail.mit.edu/group/rvsn/papers
# dump all svn actions to a log
svnadmin dump /afs/csail.mit.edu/group/rvsn/papers > svn.dump
# move existing repos out of the way
cd /afs/csail.mit.edu/group/rvsn/
mv papers papers.bdb
# recreate repos; default type is FSFS
svnadmin create papers
# replay the log
svnadmin load /afs/csail.mit.edu/group/rvsn/papers < svn.dump
# if everything worked
rm svn.dump
rm -rf papers.bdb
```

To retrieve a specific version (revision) of a file under Subversion control:
```
  svn update -r 140 introduction.tex
  svn update -r {2008-10-01} introduction.tex
```

To receive email notification on each SVN commit/checkin, edit file
`hooks/post-commit` in the SVN repository.  Add a line like this (the full
filename to mailer.py seems important; prefix with /usr/bin/python if
necessary):
```
  /usr/share/doc/subversion-1.4.6/tools/hook-scripts/mailer/mailer.py commit "$REPOS" "$REV"
```
It uses file `conf/mailer.conf` in the SVN repository.
Only two edits to that file are necessary:
  * uncomment the `mail_command` line
  * change the `to_addr` line (the separator is whitespace (no commas))
.
(A previous script (buggy, and now deprecated) was commit-email.pl.)

If "svnadmin verify" gives output like:
```
  ...
  * Verified revision 535.
  svnadmin: Unexpected end of svndiff input
```
then version 536 must be corrupted.  You can fix it by running:
```
   fsfsverify.py -f REPOS/db/rev/536
```
.
To fix svn repository error/crash (eg, read chunk size: connection truncated)
use fsfsverify.py to repair the broken revision.  First execute
```
  svnadmin verify <repository-path>
```
to find out the broken revision (one past the last good revision).
Then execute fsfsverify on that revision
```
  fsfsverify.py -f <repository-path>/db/revs/<revision>
```
Its best to copy your repository before trying this.  Its easy to
find fsfsverify on the web, and a local copy is available at
/var/autofs/net/peanut/scratch2/jhp/fsfsverify/fsfsverify.py

If svn errors of the following sort occur:
```
  $ svn commit -m 'attendance 2007' attendance 
  svn: Commit failed (details follow):
  svn: OPTIONS request failed on '/jhp_general/public_html/dirt'
  svn: Can't open file 
  '/afs/csail.mit.edu/u/j/jhp/REPOS/general/db/revs/10': Permission denied
```
AFS has incorrectly cached the permissions on the new revision. Execute
```
  fs flushv /afs/csail/u/j/jhp/REPOS/general
```
to fix the problem.

An error like
```
  svn: Can't open file .../myrepos/db/revs/1': Permission denied
```
is probably a svn interaction with a bug in the afs client that
causes it to incorrectly cache permissions.   You can clear it with:
```
  fs flushv /afs/csail/group/pag/projects/testrepos/
```
on the machine running the svn backend/server (e.g., onion).

A command that performs regular expression replacement on an entire
directory is dangerous for Subversion, since that makes changes to the
files in the .svn directory!
The solution is to make a fresh new checkout and copy either the changed
files into there, or copy its .svn directories into the old copy.

Add a password to an svn password file with a command like the following:
```
  htpasswd /cse/www2/oigj/.svn_htpasswd <username>
  htpasswd $pag/projects/<name>/password <username>
```
or have users run one of these commands locally:
```
  htpasswd -n -d <username>
  htdigest -c /dev/fd/1 Subversion <username>
```
or use an online tool like
http://home.flash.net/cgi-bin/pw.pl
http://www.4webhelp.net/us/password.php
http://www.htaccesstools.com/htpasswd-generator/

To checkout an svn repository over http:
```
  svn co https://svn.csail.mit.edu/<name> <name>
```
All of PAG's repositories can be found at:
> https://svn.csail.mit.edu:1443/admin/admin.cgi

To diff a file ignoring whitespace use
```
  svn diff -x -w <file>
```
To diff two revisions/versions/commits, use
```
  svn diff -r 63:64
```


Editing a file on multiple different operating systems (Unix/Linux,
Windows, Macintosh) can cause problems with end-of-line conventions.  To
work around this, add to the bottom of ~/.subversion/config :
```
  [miscellany]
  enable-auto-props = yes
```
.
```
  [auto-props]
  *.c = svn:eol-style=native
  *.cpp = svn:eol-style=native
```
For more examples, see:
  * http://www.apache.org/dev/svn-eol-style.txt
  * http://www.bioperl.org/wiki/Svn_auto-props

To see all changes to a Subversion repository since a certain date, use
```
  svn log -r "{2010-06-01}:HEAD"
```

Here is how to relocate a version control repository when the repository has
changed but you want to keep your local clone/checkout without making a new one.
Don't forget to commit and push all local changes first.
In Subversion:
> svn relocate
In Mercurial:
> just edit the .hg/hgrc file
In git, you need to do this if you get the message "remote: This repository moved. Please use the new location:".
Possible git gommands (but at least the latter didn't work for me, so just rename the old clone and create a new one):
> git remote set-url origin NEWURL
Or:
> git remote show origin
> git remote rm origin
> git remote add origin NEWURL
> git remote show origin



---

# Mercurial (Hg) #

To a first approximation, Git and Hg (Mercurial) have the same
capabilities.  Hg is easier to use, because it has better IDE support and a
more cohesive command line interface.  Git is more idiosyncratic, faster on
very large projects, and integrated with the popular social programming
website Github; the latter is the most compelling reason to choose it.

If you want to use Mercurial similarly to CVS or SVN, then you can use this
mapping:
```
  svn update  =>  hg fetch
  svn commit  =>  hg commit; hg push
```
This is a reasonable way to start; later, you will better appreciate how
Mercurial lets you do things that CVS and SVN do not permit.

In Mercurial, each checkout has its own private repository.  These commands
affect the local repository only:
```
 hg update
 hg commit
```
For instance, after running `hg commit`, there is no effect on any outside
repository, and your collaborators won't see the change.  But there are
benefits to you.
<p>
These commands communicate changes between your repository and its parent:<br>
<pre><code> hg pull<br>
 hg push<br>
</code></pre>
They have no effect on your local working copy.<br>
<p>
The command <code>hg fetch</code> automates the common sequence <code>hg pull; hg update</code>.<br>
(Actually, <code>hg fetch</code> does even more than that, which is nice.)<br>
To enable the <code>hg fetch</code> command, add the following to your <code>~/.hgrc</code> file:<br>
<pre><code> [extensions]<br>
 fetch =<br>
</code></pre>
A Mercurial tutorial can be found at <a href='http://hginit.com/top/'>http://hginit.com/top/</a>.<br>
<br>
In Mercurial, you cannot do an update (or fetch) if you have any<br>
uncommitted changes.  If you have uncommitted changes, you should commit<br>
your changes first:<br>
<pre><code>  hg commit<br>
  hg fetch<br>
</code></pre>
Alternately, you can save away your changes as a diff, then update and apply them:<br>
<pre><code>  hg shelve<br>
  hg fetch<br>
  hg unshelve<br>
</code></pre>
The first option tends to lead to fewer problems with merging, and less<br>
likelihood of lost work.  Also, your original work is permanently reflected<br>
in the version control history.  And, to use <code>hg shelve</code> requires<br>
installing the shelve extension, which has <a href='https://bitbucket.org/tksoh/hgshelve/issue/11/unshelve-is-not-restoring-file-changes'>a few glitches</a>.<br>
<br>
Here are two ways to have Mercurial remember/cache your password so you<br>
don't have to type it every time.<br>
Technique 1:<br>
<pre><code>  hg clone https://michael.ernst:my-password-here@jsr308-langtools.googlecode.com/hg/ jsr308-langtools<br>
</code></pre>
Technique 2:<br>
In .hgrc:<br>
<pre><code>  # The below only works in Mercurial 1.3 and later<br>
  [auth]<br>
  jsr308langtools.prefix = jsr308-langtools.googlecode.com/hg/<br>
  jsr308langtools.username = michael.ernst<br>
  jsr308langtools.password = my-password-here<br>
  jsr308langtools.schemes = https<br>
</code></pre>
<p>
SVN (Subversion) does this automatically.  You have to type the password<br>
only the first time.<br>
<br>
The Mercurial command "hg bisect" does binary search over the revision<br>
history to find the point at which an error/bug was introduced (or<br>
eliminated).<br>
<br>
To make Mercurial print the full commit message (aka changelog entry), do<br>
either of these:<br>
<pre><code>  hg log -v<br>
  hg log --style changelog<br>
</code></pre>
To show a patch for a single already-committed changeset, do either of these<br>
(the first ignores whitespace changes):<br>
<pre><code>  hg diff -b -c REVISIONNUMBER<br>
  hg log -p -r REVISIONNUMBER<br>
</code></pre>
To show diffs between two arbitrary revisions:<br>
<pre><code>  hg diff -b -r REVNO -r REVNO<br>
</code></pre>

It is officially considered good Mercurial practice (but done much less<br>
often in practice) to make a clone in a new repository before<br>
making any changes.<br>
<pre><code>  hg clone my-hello my-hello-new-output<br>
</code></pre>
(I guess when I do this, I should swing a pointer so that my tests and such<br>
use the new repository.)<br>
<br>
In Mercurial, <code>hg outgoing</code> tells which changesets will be transmitted by<br>
the next <code>hg push</code>.<br>
<br>
Typical .hgignore file:<br>
<pre><code>  ### glob syntax rules<br>
  syntax: glob<br>
  TAGS<br>
  *~<br>
  tests/**/*.class<br>
  tests/**/*.log<br>
  tests/**/*.diff<br>
  tests/*.log<br>
  tests/*.diff<br>
  bin/**/*.class<br>
  ### regexp syntax rules<br>
  syntax: regexp<br>
  # Not a glob because it starts with # which looks like a comment.<br>
  (.*/)?\#[^/]*\#$<br>
  (.*/)?\.\#.*<br>
</code></pre>
The glob part supports the <code>**</code> syntax for "in any subdirectory".<br>
<br>
To undo a commit or other transaction in Mercurial (before pushing to<br>
anywhere public),<br>
<pre><code>  hg rollback<br>
</code></pre>
For more details, do:  hg help rollback<br>
<br>
For help on Mercurial's date format, do<br>
<pre><code>  hg help dates<br>
</code></pre>
(but the curly braces <code>{}</code> around <i>datetime</i> in the help message are not literal).<br>
Example:<br>
<pre><code>  hg log --style changelog --date '&gt;2009-05-14' design.tex jsr308-faq.html<br>
</code></pre>

In Mercurial, for a list of all files under version control:<br>
<pre><code>  hg manifest<br>
  hg locate<br>
  hg status --all<br>
</code></pre>

In Mercurial, for a list of deleted file names:<br>
<pre><code>  hg log --template "{rev}: {file_dels}\n" | grep -v ':\s*$'<br>
</code></pre>

In Mercurial (Hg), to have your software re-built every time you do an<br>
update, add this to .hg/hgrc in every local copy:<br>
<pre><code>  [hooks]<br>
  update.make = make<br>
</code></pre>
The first ".make" is an arbitrary identifier to distinguish among all<br>
update hooks.  What comes after the "=" is a shell command.<br>
<br>
Setting up email notification on each commit/push for Mercurial is a bit<br>
involved.  Documentation is at<br>
<blockquote><a href='http://mercurial.selenic.com/wiki/NotifyExtension'>http://mercurial.selenic.com/wiki/NotifyExtension</a>
with a tutorial at<br>
<a href='http://morecode.wordpress.com/2007/08/03/setting-up-mercurial-to-e-mail-on-a-commit/'>http://morecode.wordpress.com/2007/08/03/setting-up-mercurial-to-e-mail-on-a-commit/</a>
For a version that works at cs.washington.edu, see HgNotifyExtension.wiki<br>
in this directory.</blockquote>

The diffs in Mercurial's email notifications can be confusing.  When<br>
sending one message per push (that is, when using the<br>
<code>changegroup.notify</code> setting), the diff in the email shows all the<br>
differences in all the changesets that you pushed.  However, some of these<br>
changesets might be merge changesets resulting from <code>hg merge</code> or<br>
<code>hg fetch</code>.  The changes in a merge changeset were already seen by<br>
the mailing list when the original author pushed his/her changes, and<br>
combining them all together obscures the new changes that appear for the<br>
first time in this push (which is, to a first approximation, everything but<br>
merges).<br>
<p>
To solve this problem, configure the repository's <code>hgrc</code>
file as follows:<br>
<blockquote><a href='hooks.md'>hooks</a>
</blockquote><ol><li>One email per changeset/commit, not one email per push<br>
</li></ol><blockquote>incoming.notify = python:hgext.notify.hook<br>
<a href='notify.md'>notify</a>
</blockquote><ol><li>Don't send notifications for merge changesets<br>
</li></ol><blockquote>merge = False<br>
It is not sufficient just to add the above without using <code>incoming.notify</code>.<br>
If you are using <code>changegroup.notify</code>, then "merge = False" just means that<br>
if you push 3 changesets, one of which is a merge, the notification email<br>
will only list two of them, but the single diff included in the email will<br>
still include all those changes.  That's confusing, too.<br>
<p>
Google Code shows per-revision diffs instead of one big diff, and no diff<br>
for a merge.  There isn't a way to do this in Mercurial now, but for a<br>
discussion of the feature, see<br>
<a href='http://selenic.com/pipermail/mercurial/2012-June/043214.html'>http://selenic.com/pipermail/mercurial/2012-June/043214.html</a> .<br>
I think it would be even nicer to have an option for a single diff, but<br>
also ignore the merges.<br>
<p>
Possible issue:  does this show any edits that the user made in the merge<br>
operation, if the merge required human intervention?  It ought to do so,<br>
since the email recipients want to see all the changes that they haven't<br>
seen already.</blockquote>

By default, Mercurial runs an interactive merging program whenever "hg<br>
merge" detects a conflict.  For instance, to use Emacs as the merging<br>
program, put in <code>~/.hgrc</code>:<br>
<pre><code>  [ui]<br>
  merge = emacs<br>
  [merge-tools]<br>
  emacs.args = -q --eval "(ediff-merge-with-ancestor \"$local\" \"$other\" \"$base\" nil \"$output\")"<br>
</code></pre>
To instead use the <code>merge</code> program, which writes a file containing the results<br>
of merging (the file may contain conflict markers), either pass<br>
<pre><code>  --config ui.merge=merge<br>
</code></pre>
to hg, or else edit <code>~/.hgrc</code> to contain<br>
<pre><code>  [ui]<br>
  merge = merge<br>
</code></pre>
or else set the HGMERGE environment variable to a program name such as <code>merge</code>.<br>
<br>
Brief comparison of Mercurial (Hg) and Subversion (SVN):<br>
see file MercurialVsSubversion.wiki in this directory.<br>
<br>
If you get messages like<br>
<pre><code>  Not trusting file ... from untrusted user mernst, group pl_gang<br>
</code></pre>
then you need add, to <code>~/.hgrc</code> (on Unix) or<br>
<code>C:\Mercurial\Mercurial.ini</code> (on Windows):<br>
<pre><code>[trusted]<br>
users = mernst<br>
</code></pre>
This tells your copy of Mercurial to run commands found in a <code>.hg/hgrc</code>
file (typically in the master repository) that is owned by that user.<br>
For example, you need to do this to have mail sent when you do a commit.<br>
If the warning message is prefixed by "remote", then you need to add the<br>
<code>[trusted]</code> section on the remote machine.<br>
<br>
In Mercurial, to share your changes with another user without pushing to a<br>
parent directory, do the following:<br>
<pre><code>  hg bundle ~/mychanges.hg default<br>
</code></pre>
and then send the <code>~/mychanges.hg</code> file (called a "bundle") to the other user.<br>
<br>
To see the diffs in a Mercurial bundle,<br>
<pre><code>  hg -R bundle.hg diff -r 'ancestor(tip,.)' -r tip<br>
</code></pre>
Also see: <a href='http://mercurial.selenic.com/wiki/LookingIntoBundles'>http://mercurial.selenic.com/wiki/LookingIntoBundles</a>

To get the fingerprint to put in the .hgrc file:<br>
<pre><code>  openssl s_client -connect &lt;host&gt;:443 &lt; /dev/null 2&gt;/dev/null | openssl x509 -fingerprint -noout -in /dev/stdin<br>
</code></pre>

In Mercurial, to restore a deleted file that has been removed from the<br>
working copy but not committed to the local repository:<br>
<pre><code>  hg revert filename<br>
</code></pre>
You can also give a revision number to revert from.<br>
<br>
To configure a changehook to trigger a Jenkins build, add the following to the<br>
project's .hg/hgrc file:<br>
<pre><code>  [hooks]<br>
  changegroup = curl --silent -d "" http://mydomain.com:8080/job/my-job-name/build?delay=0sec<br>
</code></pre>

When there is a Mercurial merge conflict, you can "accept theirs" or "accept mine" using one of the merge-tools.<br>
To merge choosing your own or the other version,<br>
<pre><code>  hg merge --tool internal:other<br>
  hg merge --tool internal:local<br>
</code></pre>
The "other" and "local" seem to be with respect to what changeset is updated to, and might not be what you expected.<br>
.<br>
Furthermore, see <a href='http://mercurial.selenic.com/wiki/TipsAndTricks'>http://mercurial.selenic.com/wiki/TipsAndTricks</a>, section<br>
'Keep "My" or "Their" files when doing a merge', for caveats about why the<br>
internal:local and internal:other merge tools only work if both branches<br>
have changed the content of the file.<br>
<br>
If you already did a partial merge that resulted in a file with markers<br>
in your working copy such as<br>
<pre><code>  &lt;&lt;&lt;&lt;&lt;&lt;&lt; local<br>
    version = 0.2<br>
  =======<br>
    version = 0.1<br>
  &gt;&gt;&gt;&gt;&gt;&gt;&gt; other<br>
</code></pre>
then you can use <code>hg resolve</code> to "accept theirs" or "accept mine":<br>
<pre><code>  hg resolve --tool internal:other --all<br>
  hg resolve --tool internal:local --all<br>
</code></pre>

To make Mercurial use Kerberized rsh instead of ssh, add this to a<br>
repository's <code>.hgrc</code> file:  [ui]<br>
  ssh = rsh<br>
}}<br>
<br>
A way to review patches against a Mercurial repository (such as from ReviewBoard RBCommons reviews or GitHub):<br>
{{{<br>
  cd ~/research/types<br>
  DIFFNAME=rb440<br>
  cp -pR checker-framework checker-framework-${DIFFNAME}<br>
  cd checker-framework-${DIFFNAME}<br>
  patch -p1 < ~/tmp/${DIFFNAME}.patch<br>
  hg addremove<br>
  hg commit -m "${DIFFNAME} as of `date +%Y-%m-%d`"<br>
  # make changes, and send back the results of "hg diff"<br>
}}}  <br>
Alternate approach:<br>
{{{<br>
  cp -pR checker-framework checker-framework-${DIFFNAME}-base<br>
  cd checker-framework-${DIFFNAME}-base<br>
  # remove generated files to avoid spurious diffs<br>
  make clean<br>
  cp -pR checker-framework checker-framework-${DIFFNAME}-edited<br>
  # make changes<br>
  # now compare the *-base and *-edited versions<br>
}}}  <br>
If you get a bundle:<br>
{{{<br>
  cd ~/research/types<br>
  BUNDLENAME=rb440<br>
  cp -pR checker-framework checker-framework-${BUNDLENAME}<br>
  cd checker-framework-${BUNDLENAME}<br>
  hg unbundle -u ~/tmp/${BUNDLENAME}.bundle<br>
  # make changes, commit<br>
  hg bundle ~/tmp/${BUNDLENAME}-additional.bundle ../checker-framework<br>
}}}<br>
<br>
---------------------------------------------------------------------------<br>
=Git=<br>
<br>
In git,<br>
{{{<br>
  git commit<br>
}}}<br>
only commits the files mentioned on the command line; without commands, it<br>
commits only the files explicitly added via a previous command.  To commit<br>
all changed files, use<br>
{{{<br>
  git commit -a<br>
}}}<br>
<br>
To display a stash as a diff/patch:<br>
{{{<br>
  git stash show -p stash@{0}<br>
}}}<br>
<br>
When running git under Emacs, to disable the pager when viewing help (& see<br>
the help topics in a new Emacs buffer), do this:<br>
{{{<br>
  git config --global man.viewer woman<br>
}}}<br>
Or, to see them in a web browser:<br>
{{{<br>
  apt-get install git-doc<br>
  git config --global man.viewer firefox<br>
  git config --global man.firefox.cmd firefox<br>
  git config --global help.format web<br>
}}}<br>
To undo the change:<br>
{{{<br>
  git config --global man.viewer man<br>
}}}<br>
<br>
In git, to unadd an accidentally-added file, do<br>
{{{git reset FILE}}}<br>
<br>
In git, after resolving the conflicts in the appropriate files:<br>
 # `git add` all of the conflicted files<br>
 # `git commit`<br>
   (which will automatically fill in the message with something about<br>
   resolving conflicts between the appropriate revisions)<br>
<br>
To undo a `git add` command before doing a commit, do `git reset <file>`.<br>
To undo changes in your working copy (like `hg revert`) do<br>
`git checkout filename`; for the whole tree, `git checkout -f'.<br>
A different command that undoes all uncommitted changes in the working tree<br>
is `git reset --hard`, but some people discourage its use because it's "dangerous".<br>
<br>
Git equivalent of `hg rollback`:<br>
{{{<br>
  git reset HEAD^<br>
  git reset --soft HEAD^<br>
}}}<br>
I'm not sure exactly what is the distiction between these.<br>
To revise a commit before pushing it -- similarly to what "hg rollback" enbales:<br>
 * do more edits<br>
 * `git commit --amend`<br>
`git revert' is different:  it makes a new, opposite commit.<br>
<br>
In git:<br>
 * HEAD^ or HEAD^1 will be resolved to the first parent of HEAD.<br>
 * HEAD^2 will resolve to the second parent<br>
 * HEAD~ or HEAD~1 will resolve to the first parent of head<br>
 * HEAD~2 will resolve to the first parent of the first parent of HEAD. This would be the same as HEAD^^<br>
<br>
The git equivalent to `hg outgoing` is:<br>
{{{<br>
  git fetch && git log FETCH_HEAD..master<br>
}}}<br>
The git equivalent to `hg incoming` is:<br>
{{{<br>
  git fetch && git log master..FETCH_HEAD<br>
}}}<br>
<br>
Here is how to create a GitHub pull request for a single git commit, if I<br>
have already committed more than 1 commit to my local repository.  I do<br>
that because it is more convenient during development to put all commits in<br>
a single working copy; then I make a sequence of commits, all in a single<br>
branch.  But I seem to need one commit per branch to submit a proper GitHub pull<br>
request.<br>
{{{<br>
  ## <mybranchname> is by convention "upstream"<br>
  ## <git repository> is, for example, git@github.com:mernst/asciidoctor.org.git<br>
  git remote add <mybranchname> <git repository><br>
  # "git remote update" would also work<br>
  git fetch <mybranchname><br>
  ## If I did my work on a named branch:<br>
  git checkout -b <mybranchname> <mybranchname>/master<br>
  ## else if I did my work in master (of my repository) and the commit I want is right after those in the central repo:<br>
  git checkout -B <mybranchname> <mycommithash><br>
  ## else if I did my work in master (of my repository) and the commit I want is not right after those in the central repo:<br>
  git checkout -B <mybranchname> <commithash-of-last-commit-on-master><br>
  git cherry-pick <mycommithash><br>
  ## endif<br>
  git push origin <mybranchname><br>
}}<br>
Finally, at the parent's GitHub webpage, submit a pull request for <mybranchname><br>
<br>
In Git, to list branches:  `git branch`.<br>
In Git, to delete a local branch:<br>
{{{<br>
  git branch -d the_local_branch<br>
}}}<br>
To remove a remote branch (if you know what you are doing!)<br>
{{{<br>
  git push origin --delete the_remote_branch<br>
}}}<br>
(or, equivalently but with more obscure syntax: `git push origin :the_remote_branch`).<br>
<br>
To see the changes in a single git commit, as a diff, do either of these:<br>
{{{<br>
  git diff COMMIT^ COMMIT<br>
  git show COMMIT<br>
}}}<br>
<br>
To make a bundle of unpushed changes:<br>
{{{<br>
  git bundle create ../yourRepo.bundle --since=x.days.ago --all<br>
  git bundle create ../yourRepo.bundle master     // for unpushed changes<br>
}}}<br>
Then to get the contents:<br>
{{{<br>
   git clone repo.bundle -b master repo<br>
}}}<br>
<br>
---------------------------------------------------------------------------<br>
=bzr bazaar=<br>
<br>
To create a bzr (Bazaar) repository for a project using the normal pag<br>
directories, the following:<br>
{{{<br>
  setenv PDIR <name of your project, eg, 'inv' or 'ac'><br>
  bzr init-repo $pag/projects/$PDIR/BZR_REPOS<br>
  bzr init $pag/projects/$PDIR/BZR_REPOS/trunk<br>
  bzr checkout $pag/projects/$PDIR/BZR_REPOS/trunk ~/research/$PDIR<br>
  # populate ~/research/$PDIR<br>
  cd ~/research/$PDIR<br>
  bzr add *<br>
  bzr commit -m 'initial version of ...'<br>
}}}<br>
<br>
To install a relatively recent version of bzr on debian stable, execute<br>
the following commands on a pag machine:<br>
{{{<br>
  sudo dpkg -i bzr_1.5-1~bpo40+1_i386.deb<br>
}}}<br>
you will also need python-parmiko in order to use sftp, to install that,<br>
execute:<br>
{{{<br>
  sudo apt-get install python-paramiko<br>
}}}<br>
To install a relatively recent version of bzr on cygwin, it is simply necessary<br>
to update cygwin and select python-paramiko, and python-crypto as a packages<br>
(they are not selected by default)<br>
<br>
If<br>
{{{<br>
  bzr branch lp:...<br>
}}}<br>
fails with<br>
  Permission denied (publickey).<br>
then add a new ssh key.  From your personal page in Launchpad, follow<br>
"Change details" and then "SSH Keys".<br>
<br>
The standard way to collaborate on Github-based projects is for you to fork<br>
the project on Github, and then commit your changes to your clone, and then<br>
on the Github page describing your commit there is a button whereby you can<br>
submit a "pull request" which lets the owner know that you want a patch to<br>
be merged.<br>
<br>
---------------------------------------------------------------------------<br>
=Bitbucket=<br>
<br>
For email notifications of changesets in Bitbucket, use Admin >> Services;<br>
then, for each email address: Email >> Add service.<br>
For email notifications of issue tracker changes, use Admin >> Issue<br>
Tracker Settings >> Notifications.<br>
I'm not sure whether all this works for the wiki repository...<br>
<br>
<br>
---------------------------------------------------------------------------<br>
<wiki:comment><br>
Please put new content in the appropriate section above, don't just<br>
dump it all here at the end of the file.<br>
</wiki:comment><br>
</code></pre>