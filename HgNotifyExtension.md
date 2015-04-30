For email notification at cs.washington.edu, add the following to the
.hg/hgrc in the repository root.  This simplifies and makes more concrete
the instructions that appear elsewhere on the web.

```
[hooks]
# One email per changeset/commit, not one email per push
changegroup.notify = python:hgext.notify.hook

[smtp]
host = mailhost.cs.washington.edu

[email]
from = typelessj@cs.washington.edu

[web]
## If not accessed through the web:
baseurl = 
## If accessed through the web:
# allow_push = COMMA, SEPARATED, USER, NAMES

[notify]
sources = serve push pull bundle
test = False
# Don't send notifications for merge changesets
merge = False
# [reposubs] is in this file
config = 
# you can override the changeset template here, if you want.
# If it doesn't start with \n it may confuse the email parser.
# here's an example that makes the changeset template look more like hg log:
template = \ndetails:   {baseurl}{webroot}/rev/{node|short}\nchangeset: {rev}:{node|short}\nuser:      {author}\ndate:      {date|date}\ndescription:\n{desc}\n
# max lines of diffs to include (0=none, -1=all)
maxdiff = 300
# to strip off "/projects/swlab1/typelessj/"
strip = 4

# key is glob pattern to repo root, value is comma-separated list of subscriber emails
[reposubs]
/projects/swlab1/typelessj/oopsla-2010 = COMMA, SEPARATED, EMAIL, ADDRESSES
```


Remote users may also need to add a `[trusted]` section to their Mercurial
init file (`~/.hgrc` on Unix or `C:\Mercurial\Mercurial.ini` on Windows).

Unfortunately, the notify extension doesn't support using patterns to match
particular files.