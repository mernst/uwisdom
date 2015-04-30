Brief comparison of Mercurial (Hg) and Subversion (SVN):

Pros of Mercurial:
  * faster
  * more robust.
> > I've had SVN repositories get wedged because of using
> > different client versions.  Also, Yoav Zibin reports that in SVN, if I
> > changed a file (but haven't committed yet), and you deleted that file,
> > then my changes are lost forever; it should create a conflict instead.
  * distributed (in the sense of "distributed version control")
    * Possibility to have a private branch.
> > > You commit chonges without making those changes public immediately.
> > > (But, you can also always make your changes public by pushing
> > > immediately, if you so desire.)
    * Can operate offline.
    * More flexible than centralized version control in other respects.
  * easier to manage and merge conflicts.

> > Mercurial decouples the actions of updating and merging.  This does make
> > the user model a bit more complicated.  You have to check in or undo any
> > changes before updating.  On the plus side, this gives you a permanent
> > record of your state before the merge, which is useful if you have
> > trouble with the merge or later when examining the merge history.
  * does not permit inconsistent checkouts.
> > A user may apply all or none of a changeset, but not part of it.
> > (Subversion allows you to update only part of your checkout, such as a
> > single file or directory.  This could cause your checkout to be
> > internally inconsistent.)
  * List of files to ignore is .hgignore in the repository.
> > (Subversion forces you to remember the arcane command "svn propedit
> > svn:ignore .", and properties are not versioned or, it seems, even
> > stored in the repository -- only in the working copy.)  Also, only one
> > .hgignore file is necessary rather than setting the svn:ignore on each
> > directory.
  * Better merging
> > It is sometimes said that Mercurial has better merging algorithms than
> > SVN.  That is true only in a limited sense.  Both will require human
> > intervention if there are ever simultaneous edits to the same line of a
> > file.  However, once it has been resolved, Mercurial will let it stay
> > resolved as you continue to work.  With SVN, you may have to repeatedly
> > re-resolve the same problem as you continue to work.

Pros of Subversion:
  * more widely used at present, and familiar to more developers
  * less flexible, and therefore less complicated.
> > This can simplify the user's mental model.
  * you don't have to check in or shelve changes before committing.
> > This can lead to problems, but it does remove one step.
  * you can check out or update only a part of a repository.
> > With Mercurial, you have to check out the entire repository, which may
> > lead to a style with more separate repositories rather than one big
> > repository that holds multiple loosely-related projects.
  * checkout takes less space.
> > The checkout a copy of the current state of the repository but not the
> > entire history.  The entire history can be significant, especially if
> > you have used bad style and checked in generated files such as binaries.