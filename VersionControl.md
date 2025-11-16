# Wisdom about version control systems


On github.com, you can view the table of contents of this file by clicking the
menu icon (three lines or dots) in the top corner.


## Line breaks


When working with a line-based version control system such as Git, please don't
write very long lines, such as one line containing the content of an entire
paragraph.  Instead, insert line breaks within each paragraph to keep the file's
lines to a limited length, by convention 80 columns.  These line breaks serve no
purpose in organizing the text or in editing it, but they do help to prevent
merge conflicts when multiple people edit different parts of a paragraph.


When working with a line-based version control system such as Git and a text
markup language such as LaTeX or Markdown, please don't refill paragraphs.
Doing so causes merge conflicts and massive, unreadable diffs.  Instead, insert
or delete text without changing any line breaks outside the edit.  This can lead
to paragraphs in LaTeX or Markdown files that look a bit funny because some
lines are short and some are long, but that file doesn't matter because readers
will see a rendered version.


## Git


Typical operation on a stash:

```sh
  git stash pop
```

To display a stash as a diff/patch:

```sh
  git stash show -p stash@{0}
```


To revise a commit before pushing it -- similarly to what "hg rollback" enables -- without rewriting the commit message:

* do more edits
* `git commit --amend`
* or, to keep the current commit message: `git commit --amend --no-edit`

`git revert` is different:  it makes a new, opposite commit.


In git:

* HEAD^ or HEAD^1 will be resolved to the first parent of HEAD.
* HEAD^2 will resolve to the second parent
* HEAD~ or HEAD~1 will resolve to the first parent of head
* HEAD~2 will resolve to the first parent of the first parent of HEAD. This would be the same as HEAD^^


The git equivalent to `hg outgoing` is:

```sh
  git fetch && git log FETCH_HEAD..master
```

The git equivalent to `hg incoming` is:

```sh
  git fetch && git log master..FETCH_HEAD
```


To see the changes in a single git commit, as a diff, do either of these:

```sh
  git diff COMMIT^ COMMIT
  git show COMMIT
```


To make a bundle of all changes:

```sh
  git bundle create ../yourRepo.bundle master     # for all changes
```

To make a bundle of just some changes:

```sh
  git bundle create ../yourRepo.bundle TAG-OR-REVSPEC
  git bundle create ../yourRepo.bundle SOMECOMMIT..master
  git bundle create ../yourRepo.bundle master~1....master
  git bundle create ../yourRepo.bundle --since=x.days.ago --all
```

Then to get the contents:

```sh
   git clone repo.bundle -b master repo
```


To obtain the repository state as of a particular moment in time, do

```sh
  git checkout `git rev-list -1 --before="Jan 17 2014" master`
```

on't use `git checkout 'HEAD@{Jan 17 2014}'` because that will give you a newer version for code whose history doesn't go back that far in the history.


To compare two branches in Git:

* To see changes in branch2 without seeing changes that have been done on
   branch1 (which might be "master") in the meanwhile, do either of these
   (their effect is identical, but the first is much simpler):

```sh
  git diff branch1...branch2
  git diff `git merge-base branch1 branch2`..branch2
```

* With two dots, `git diff` shows what is in branch1 XOR branch2 (either b1
   or b2 but not both), so `git diff b1...b2` is the opposite patch as
   `git diff b2...b1`.


To pull recent changes to master into a branch
(don't do this unless I know master is the upstream of that branch!):

```sh
  GITBRANCH=`git rev-parse --abbrev-ref HEAD`
  git checkout master
  git pull
  git checkout $GITBRANCH
  git pull
  git pull origin master
  git push
```

(optionally add `--rebase` argument to `git pull origin mybranch`,
if the branch has never been shared with anyone else).
To synch a GitHub fork with upstream:
First, you must have at some point in the past done:

```sh
  git remote add upstream https://github.com/ORIGINAL_OWNER/ORIGINAL_REPOSITORY.git
```

Then, do:

```sh
  git fetch upstream
  git checkout master
  git merge upstream/master
  git push
```

It's also possible to just do

```sh
  git pull https://github.com/ORIGINAL_OWNER/ORIGINAL_REPOSITORY.git
  git push
```


To determine changes on a fork:

```sh
  git remote add upstream https://github.com/typetools/checker-framework.git
  git fetch upstream
  # changes on your local branch that do not exist on upstream:
  git diff upstream/master...HEAD
  # changes on upstream since last merge with fork:
  git diff HEAD...upstream/master
```

Here are some commands that are not as helpful to me:

```sh
  # All differences (including my changes and theirs)
  git diff master upstream/master
  # differences in upstream since we diverged (not including my own changes)
  git diff upstream/master..
  # differences between my branch and upstream (including my changes and theirs)
  # (note: three dots)
  git diff ...upstream/master
```


To clone a repository into directory `repo/`, or update it if it already exists in `repo/`:

```sh
  git -C repo pull || git clone https://server/repo repo
```


To diff two revisions/commits:

```sh
  git diff <commit> <commit> [<path>...]
```


In git, to cat or checkout a specific revision/version of a file, do:

```sh
git show REV:FILE
```

where FILE is relative to the repository root.


In git, to pull and push to different remote URLs, use this syntax
in the `.git/config` file:

```gitconfig
[remote "origin"]
 url = https://github.com/typetools/checker-framework.git
 pushurl = git@github.com:typetools/checker-framework.git
```


To create a branch from someone else's fork:

```sh
export THEIRUSERNAME=...
export REPONAME=...
export THEIRBRANCH=...
git remote add $THEIRUSERNAME git@github.com:$THEIRUSERNAME/$REPONAME.git
git fetch $THEIRUSERNAME
git checkout -b $THEIRUSERNAME-$THEIRBRANCH $THEIRUSERNAME/$THEIRBRANCH
git push origin $THEIRUSERNAME-$THEIRBRANCH
git checkout master
```

This leaves regular "push" sending to the remote, so you should
possibly remove the new `[branch ...`` section in`.git/config` and
do a regular checkout of $THEIRUSERNAME-$THEIRBRANCH.


To get the first line of a git commit message, with the commit id:

```sh
git log --oneline -n 1 HEAD
```

To get the first line of a git commit message, WITHOUT the commit id:

```sh
git log --oneline --format=%B -n 1 HEAD | head -n 1
```


To see the dates that annotated tags were created:

```sh
git for-each-ref --format="%(refname:short) | %(taggerdate)" refs/tags/*
```

To see the dates of the annotated commits:

```sh
git for-each-ref --format="%(refname:short) | %(creatordate)" refs/tags/*
```

To determine whether a tag is annotated (printed as "tag") or lightweight (printed as "commit"):

```sh
git for-each-ref refs/tags
```


To fetch a branch on someone else's fork:

```sh
git remote add theirusername git@github.com:theirusername/reponame.git
git fetch theirusername
git checkout -b mynamefortheirbranch theirusername/theirbranch
```


To get a diff between a branch and master, but not including unmerged master commits:

```sh
git diff master...branch
```

(don't switch the order of the arguments).
Equivalently:

```sh
git diff $(git merge-base master branch)..branch
```

Merge base is the point where branch diverged from master.


If you get an error when running `git commit`:

```text
error: invalid object 100644 13da...8114 for 'FILENAME'
error: Error building trees
```

then run

```sh
git hash-object -w FILENAME
```


In the `.gitattributes` file, using

```gitattributes
*.bat text eol=crlf
```

means that `.bat` files are stored with line feeds in the repository, but
crlf in the working tree.  I find this a bit messy and typically just
make sure the file has the right line endings when I create and edit it.
Local settings like `core.autocrlf` are an anti-pattern, best left to false.


If a `.git/` directroy is taking too much hard disk space, a quick hack is:

```sh
  git gc --aggressive --prune=now
  # To see the gains as you run the command:
  du -c | tail -1 && git gc --aggressive --prune=now && du -c | tail -1
```

This reduces a git repository's size the right way, but may need to be run overnight:

```sh
  git repack -a -d --depth=250 --window=250
```


I avoid using `--filter` with `git clone`.

To reduce the time spent cloning a repository, and to reduce its disk space, use

```sh
git clone --filter=blob:none
```

Disadvantages:

* It is impossible to pull from that clone.
* Git commands are slower (sometimes much slower) because they will inefficiently
  retrieve information from the remote repo (once ever per piece of information).
  For example, running `git annotate` (= `git blame`) on such a repository takes a
  very long time.

GitHub recommends against `--filter=tree:0`, and against `--depth=1` except for
CI when the clone will be immediately discarded.


The user-level (aka "global") git attributes are by default read from
`$XDG_CONFIG_HOME/git/attributes`, or (if (`$XDG_CONFIG_HOME` is either not set
or empty) `$HOME/.config/git/attributes`.  This behavior can be overridden by
setting the `core.attributesfile` configuration option to a file, which is used
instead.  To set it to `~/.gitattributes`:
`git config --global core.attributesfile '~/.gitattributes'`


List unmerged files:

```sh
git diff --name-only --diff-filter=U --relative
```

This might also stage files with no conflict markers, which is handy:

```sh
git diff --check
```


To clone submodules or set them to the version in the latest commit:

```sh
git submodule update --init --recursive
```

To update submodules to their latest version from their own upstream:

```sh
git submodule update --recursive --remote
```


To obtain all pull request branches from a GitHub repository:

```sh
git pull origin 'refs/pull/*/head:refs/remotes/origin/pull/*'
```


These are the files that git thinks have a conflict (are they the same?)

```sh
git diff --name-only --diff-filter=U
git ls-files -u
```

These are the files that contain a conflict marker:

```sh
git diff --check | cut -f 1 -d: | sort -u
```


To remove all non-committed files (like `make clean` or `./gradlew clean`):

```sh
git clean -fdx
```


In `git diff`, to see the containing Java method names along with each hunk,
add this line to a git attributes file:

```gitattributes
*.java diff=java
```


A repository's git attributes file is top-level `.gitattributes`.  You can also
use `.git/info/attributes` file, in which case it won't be committed with the
project -- that is, it will affect only you, not other people using the repository.

The user-level git attributes file file is by default
`$XDG_CONFIG_HOME/git/attributes`. You can change the user-level file to be
`~/.gitattributes` by running the following command, once ever per computer:
`git config --global core.attributesfile ~/.gitattributes`


To use `git diff` on arbitrary files, use:

```sh
git diff --no-index ...
```

`git diff` is recursive by default.


### The git staging area


Modalities of running `git commit`:

* `git commit` without filename arguments only commits the files that are staged (in the staging area).  To put a file in the staging area, `git add FILENAME`.
* `git commit FILE1 FILE2 ...` only commits files that are mentioned on the command line.
* `git commit -a` commits all changed files.


To undo a `git add` command before doing a commit, do `git reset <file>`.
To undo changes in your working copy (like `hg revert`) do
`git checkout filename`; for the whole tree, `git checkout -f`.
A different command that undoes all uncommitted changes in the working tree
is `git reset --hard`, but some people discourage its use because it's "dangerous".



### Git branches


In Git, to list branches:

```sh
  git branch -a
```

Note that `git branch` only shows *local* branches.
Periodically remove branches that have been deleted from the remote repository:

```sh
  git remote prune origin
```

You can also see the branches in GitHub, for example at
<https://github.com/typetools/checker-framework/branches/all>
together with how old, who last changed, whether there is a pull request open.
You can see diffs by clicking "create pull request", which gets you to a
page showing the diffs (actually creating the pull request requires another
click -- don't do that).


In Git, to create a branch and switch to it
(just `git branch newbranch` doesn't switch to the new branch):

```sh
  git checkout -b new_branch_name
```

In Git, to delete a local branch:

```sh
  git branch -d the_local_branch
```

To remove a remote branch (if you know what you are doing!)

```sh
  git push origin --delete the_remote_branch
```

(or, equivalently but with more obscure syntax: `git push origin :the_remote_branch`).


In Git, to clone a particular branch:

```sh
  git clone -b <branch> --single-branch <remote_repo>
```




### Git merging


`git merge` always writes a file with merge conflict markers (if there
is a conflict); it never asks the user to resolve the conflict.
The user is expected to run `git mergetool` to resolve the conflict.


To abandon/abort a git merge:

```sh
git merge --abort
```


In git, after resolving the conflicts in the appropriate files:

* `git add` all of the conflicted files

* `git commit`

  (which will automatically fill in the message with something about
  resolving conflicts between the appropriate revisions)


Git merge terminology:

* merge strategy: A merge strategy is about performing three-way merge at the
  tree level, figuring out which three variants of contents to hand to a merge
  driver that handles the content-level three-way merge.  However, if two of
  {parent1,parent2,base} are the same, then the merge driver is never called.
  The merge strategy is responsible for detecting and handling renames.  You
  rarely have to write a new merge strategy.
* merge driver: A merge driver is called whenever no two of
  {base,parent1,parent2} are the same.  It is run on one file at a time.  It is
  run on temporary files, but you can get the path of the conflicting file
  using the %P parameter.  It observes the original version of the parent and
  base files; no conflict markers exist.  It overwrites its input named `%A`
  with the merge result, which may contain conflict markers.  You can use Git
  attributes to use different merge strategies for files whose names match
  given patterns.
* merge tool (mergetool):  A merge tool never runs automatically.  If a user
  issues the command `git mergetool`, then the mergetool is run on all
  conflicted files (one at a time), getting a chance to redo the merge.  The
  merge tool is invoked with $BASE, $LOCAL, and $REMOTE set to temporary files,
  and $MERGED set to the file with the conflict markers (which is also where to
  write the merge tool's result).  A git mergetool is never invoked on a file
  that contains no merge conflict.  It assumes that if the merge driver didn't
  output a merge conflict, then the merge was correct.  This means that a git
  mergetool will never reduce the number of clean-but-incorrect merged files.
  By default, if a mergetool returns a non-zero status, git discards any edits
  done by the mergetool, reverting to the state before the mergetool was run
  from a backup file.  To work around this, such a tool can write partial
  results to a **BACKUP** file (named analogously to **LOCAL**, **BASE**, etc.).
  A merge tool can be run explicitly on files: `git mergetool file file...`.
  However, the merge tool does nothing if the file has no conflict markers.


### Searching the git history


To search for for all commits in the git history that match the given regular
expression:

```sh
  git log -G"ANY_OCCURRENCE.*"
```


To search for for all commits in the git history with a different number of
occurrences of the search string before and after (ie, removals or additions of
the search string, but it would not match in-file moves or other patches that
don't add or remove the string); add `--pickaxe-regex:` to treat the string as a
regex:

```sh
  git log -S"DIFFERENT_NUMBER_OF_OCCURRENCES"
```


To search for for all commits in the git history that touch a given function:

```sh
  git log -L :function:file
```

To see the commit's diff as well, supply the `-p` option.
Use `--all` to search all branches.


### Rewriting history


For the Git equivalent of `hg rollback` which uncommits or undoes or reverts a commit,
do one of these:

* `git reset HEAD^`: resets the index but not the working tree
* `git reset --soft HEAD^`: does not touch the index or the working tree.
* `git reset --hard HEAD~ && git push -f`

The commit will still appear in other clones, if anyone has pulled from remote
while the commit was there.


To unpush a commit, leaving no trace in the version control history:

```sh
  git reset --hard DESIRED-COMMIT
  git push -f REMOTE BRANCH
```

where `DESIRED-COMMIT` is something like HEAD~1 or a SHA hash,
and `REMOTE` and `BRANCH` are optional.
The commit will still exist in any clones of the repository,
so it must be removed from each one individually.


To delete/remove a commit in a local git repository, use one of these:

```sh
git reset --hard HEAD~1
git reset --hard <sha>
```

Then, to delete in a remote branch, use one of these

```sh
git push -f
git push origin HEAD --force
```


If merging works perfectly then rebasing simplifies the history.
If there is a problem, then rebasing can cause confusion and can make debugging
harder in the future, because you can't get back to the exact same codebase as
you had during development.
So really one should rebase only if there is no merge conflict, and the code
continues to compile and all the tests pass.

In the very most simple case of no collisions:

* `git pull --rebase`: rebases your local commits ontop of remote HEAD and does not create a merge/merge commit
* `git pull`: merges and creates a merge commit
  If there is a textual conflict in file modified-file, you will get asked to resolve them manually and then
* continue:
  * with rebase: `git add modified-file; git rebase --continue`
  * with merge: `git add modified-file; git commit`


To squash multiple commits into one (say, the last 3 commits):

```sh
  git reset --soft HEAD~3
  git commit
```


It is a good practice to keep the `master` or `main` branch of a fork
identical to the corresponding branch upstream.  If the fork's branch has
become different (say, there are a lot of extraneous merges in it), here is
how to correct that problem.  (This affects only your `master` or `main`
branch, not any other branch in your repository:  you will not lose any work.)

* Find some commit that is before the two branches diverged, by running
   `git log --graph`.  The very first commit is an acceptable choice, but
   causes some extra network traffic.
* Check out that commit: `git checkout def11847c05324c26dda93ac59b4f3d6aca245f5`
* `git pull --ff-only THE_UPSTREAM_REPO`
   where THE_UPSTREAM_REPO is something like "<https://github.com/codespecs/daikon.git>".
* `git push -f origin HEAD:master`
   (or use some other branch name such as `main`)
* Now, the master branch of the repository is correct on GitHub), but
   this and other clones/checkouts/enlistments may still retain the extraneous commits.
   For *every* clone on every machine (regardless of what branch it has checked out):
  * delete it and re-clone (easiest), after ensuring it has no uncommitted or unpushed work


Please do not force-push to GitHub.  Force-pushing has no benefit, since we squash-and-merge pull requests.  Force-pushing has negative consequences, such as removing code review comments on any deleted commits.


Rebasing is evil because it modifies the history and can lead to unnecessary merge conflicts.  The history of the branch in a pull request should never matter.  The pull request should be squash-and-merged, which results in a single commit on the mainline, corresponding to the pull request which should contain a single logical change (no matter how many iterations of bug fixes and code reviews it has gone through).


To make a squashed commit out of all the differences on a branch, run this in a *different* branch.

```sh
git merge --squash origin/BRANCHNAME
```



## GitHub (Git-specific items go above)


For GitHub, to link directly to files in the repository, use rawgit.com.
Examples:
  <https://rawgit.com/mernst/bibtex2web/master/bibtex2web.html>
This does not seem to work for wiki files.
For GitLab at UW, an example is:
  <https://gitlab.cs.washington.edu/plse/verdi-papers/blob/master/doc/MSR.md>
but GitLab will not permit direct viewing of HTML files -- GitLab sets the headers so that the browser shows the HTML code, as in
  <https://gitlab.cs.washington.edu/randoop/toradocu-evaluation/raw/master/docs/index.html>
For Bitbucket, an example is:
  <http://htmlpreview.github.io/?https://bitbucket.org/typetools/jsr308-langtools/raw/tip/doc/README-jsr308.html>


In GitHub, just

```asciidoc
:toc:
```

doesn't produce a table of contents.  Instead, you need

```asciidoc
:toc:
:toc-placement: manual
...
toc::[]
```


GitHub wikis:

* in a separate wiki repository
* can write in AsciiDoc and other formats
* other people can theoretically edit

GitHub pages:  e.g., <http://mernst.github.io/randoop>

* in a separate branch in the main repo
* HTML only
* if using automatic page generator:
  * can paste in Markdown, but it gets converted to .html
  * attractive themes:  Modernist, Leap Day, Cayman, Architect (?)

Both are in a separate branch from the code proper, which is a negative.
Jekyll seems like a mess that I would like to avoid getting entangled in.


GitHub Issues (GitHub's issue tracker) supports sorting only on creation
date, date of last update, and number of comments.  To find high-priority
issues, it is necessary to use labels or milestones.  An advantage of
milestones is that it is possible to search for issues without a milestone,
but it's not possible to search for issues without a given set of labels
(only for issues with no label at all).  The search syntax does not support
disjunction ("or" queries).


The blue vertical bar at the left of a GitHub pull request or issue indicates
that something in it is new or unread -- you haven't clicked on it before.


To search GitHub, using their public API: <https://developer.github.com/v3/>

```sh
curl -H "Authorization: token `cat git-personal-access-token`" 'https://api.github.com/search/code?q="com.amazonaws.services.ec2.model.DescribeImagesRequest"+language:java&page=3'
```

for each page (above, `3`).


If you reply to GitHub comments using your email client, don't quote the message you are replying to, or it will clutter the conversation history.


### Automatic updates


To disable dependabot on a fork, either:

* delete and re-create the fork, or
* click "Disable" on the forked repo's /settings/security_analysis page.


To install Mend Renovate on a GitHub organization: <https://github.com/apps/renovate> .
To configure Renovate for a repository (maybe I can only do this if I have permissions for the organization, but not if I have permissions for one repository in an organization where I don't have access?):
  <https://github.com/apps/renovate> , then "Install", then the organization, then "Repository Access",
  select a repository, "Save", and wait for the pull request.
I like to put the configuration file in .github/renovate.json
rather than at the top level of the repository, to reduce clutter.
You can find an example configuration file at
<https://github.com/typetools/checker-framework/blob/master/.github/renovate.json>
but you probably don't need the "packageRules" section.


How I edit a Renovate pull request to make the configuration changes I prefer~

```sh
DIR=~/java/plume-lib/require-javadoc
(cd $DIR && \
git pull && \
gcb renovate/configure && \
cd $DIR-branch-renovate-configure && \
mkdir -p .github && \
cp -pf ~/java/plume-lib/html-pretty-print/.github/renovate.json .github/renovate.json && \
git add .github/renovate.json && \
rm -f .github/dependabot.yml && \
rm -f renovate.json && \
git commit -a -m "Move renovate configuration file" && \
git push)
```


### GitHub pull requests


The standard way to collaborate on GitHub-based projects is for you to fork
the project on GitHub, and then commit your changes to your clone, and then
on the GitHub page describing your commit there is a button whereby you can
submit a "pull request" which lets the owner know that you want a patch to
be merged.


Here is how to create a GitHub pull request for a single git commit, if I
have already committed more than 1 commit to my local repository.  I do
that because it is more convenient during development to put all commits in
a single working copy; then I make a sequence of commits, all in a single
branch.  But I seem to need one commit per branch to submit a proper GitHub pull
request.

```sh
  ## <mybranchname> is by convention "upstream"
  ## <git repository> is, for example, git@github.com:mernst/asciidoctor.org.git
  git remote add <mybranchname> <git repository>
  # "git remote update" would also work
  git fetch <mybranchname>
  ## If I did my work on a named branch:
  git checkout -b <mybranchname> <mybranchname>/master
  ## else if I did my work in master (of my repository) and the commit I want is right after those in the central repo:
  git checkout -B <mybranchname> <mycommithash>
  ## else if I did my work in master (of my repository) and the commit I want is not right after those in the central repo:
  git checkout -B <mybranchname> <commithash-of-last-commit-on-master>
  git cherry-pick <mycommithash>
  ## endif
  git push origin <mybranchname>
```

Finally, at the parent's GitHub webpage, submit a pull request for <mybranchname>


GitHub doesn't support pull requests for the wiki repository, only the main
repository, according to <http://stackoverflow.com/questions/10642928/>.


To pull a GitHub pull request into my local clone/copy,
click on "command line instructions" at the bottom of the pull request.
Also see <https://help.github.com/articles/checking-out-pull-requests-locally/>


To ignore whitespace changes in a GitHub code review diff or a commit,
add "?w=1" at the end of the URL.


In GitHub, adding a CONTRIBUTING file to the root of your repository will add a
link to your file when a contributor creates an Issue or opens a Pull Request.


I suggest that you use GitHub's squash-and-merge feature when committing pull requests.  It leads to a cleaner version control history.  A pull request usually represents one concept, so it can be represented as a single commit.  There is no need to record all the iterations from debugging or code review.
In the repository's settings, you can unselect "Allow merge commits" and "Allow rebase merging", and change the default commit message for squash merging to "Pull request title".


In GitHub, you can squash a pull request into a single commit and then merge the
single commit (<https://github.com/blog/2141-squash-your-commits>).
To do so:

* Click "Merge pull request"
* Click the down arrow next to "Confirm merge"
* Select "Squash and merge"
* Edit the one-line commit message, and edit or remove the
   multi-line optional explanation
* Click "Confirm squash and merge"
This keeps the original author, but makes the person doing the squashing the
committer.  You can also do the squash on the command line:

```sh
git checkout master
git merge --squash branch
git commit --author "Real Author <ra@email.com>"
```


To view a GitHub pull request as a diff/patch file, just add `.diff` or `.patch`
to the end of the URL.


If you enable “Automatically delete head branches” in the repository settings of your GitHub fork (and whoever merges the pull request has write permission to your repository), then you don't have to manually delete the branch after your pull request is merged.


When making a GitHub pull request, if you do work in your own GitHub fork, then continuous integration will complete faster.  The reason is that the "branch" continuous integration job will run against your personal CI quota, and the "pull request" continuous integration job will run against the upstream project's CI quota.


## Pull requests


When you address a code review comment, you don't need to reply within the pull
request or describe what you did.  You can just click "resolve conversation".
The next iteration of the code review will examine your new code or comments.
On the other hand, if you disagree with a suggestion or more discussion is
needed, then continuing the conversation in the pull request thread is great.


CodeRabbit comments on every push to a pull request.  CodeRabbit only comments
on new changes in the pull request If you want a fresh review of an entire pull
request (for example, if you have lost track of the CodeRabbit comments or you
didn't want to address them as you made incremental commits), then you should
make a new branch and a new pull request, with the same contents as the original
PR branch but with a different history.  You can do this by:

```sh
# In a new branch (created from main/master, not from the PR branch):
git merge --squash PR-BRANCH
git commit
git push
# Browse to the URL to create a new pull request.
```

Now, you have a choice:

* Replace the original PR by the new one, or
* Continue to use the original PR.  Address the comments on the new PR in
   either of the two branches and pull changes into the other branch.  Repeat
   this until there are no more CodeRabbit comments on the new PR.


## GitLab (Git-specific and GitHub-specific items go above)


To enable GitLab commit/push notifications by email:
Settings >> integrations >> emails on push


In GitLab, only users with the Master role are allowed to push a merge to a "protected branch".
The master branch is protected by default.
If you get this error:

```output
  remote: GitLab: You are not allowed to push code to protected branches on this project.
   ! [remote rejected] master -> master (pre-receive hook declined)
```

then there are two ways to solve it:

* Unprotect the branch:  go to the project >> settings (gear icon) >> protected branches >> unprotect.
* Make the user a Master:  go to the project >> settings (gear icon) >> members >> (fill in name, and "Master" for Project Access) >> Add Users to project


## Bitbucket


For email notifications of changesets in Bitbucket, use Admin >> Services;
then, for each email address: Email >> Add service.
Or, maybe now it's just:  Settings >> Hooks >> Email.
For email notifications of issue tracker changes, use Admin >> Issue
Tracker Settings >> Notifications.
I'm not sure whether all this works for the wiki repository...


I can't seem to use SSH authentication to bitbucket.org any more.  Instead, use
an API token.  Must create "api token WITH SCOPES", with permissions
"read:repository:bitbucket" and "write:repository:bitbucket".


<!--
// Please put new content in the appropriate section above, don't just
// dump it all here at the end of the file.
-->


<!--
// LocalWords:  RCS toc VC rsync dir DIR1 DIR2 Cavz
-->
