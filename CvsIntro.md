Contents:


```
This file contains instructions about using CVS that I have sometimes sent
to people, to introduce them to the concept of version control and the CVS
tool.  There are probably good tutorials that I could now point people at.

===========================================================================

To check out a CVS project (that is, to obtain your own private copy of the
files which you can edit), select a directory where you want a "code"
subdirectory containing all the files to appear, and do the following

  cvs -d ~mernst/class/573/project/.CVS-medics checkout code

----------------

To check out a CVS project (that is, to obtain your own private copy of the
files which you can edit):

 1. Log into june.cs.washington.edu and put an line of the form
    "myhost.aero.org gorlick" (with no quotes) in your ~/.rhosts file.
 2. Verify that this worked by executing (at Aero)
      rsh -l gorlick june.cs.washington.edu 'echo $PATH'
      rsh -l gorlick june.cs.washington.edu 'which cvs'
    If cvs isn't found, then you need to either:
      * at Washington, add the appropriate directory (/usr/bin) to your
        path (in ~/.bashrc, ~/.cshrc, etc., not in ~/.login), or
      * at Aero, set environment variable CVS_SERVER to /usr/bin/cvs
 3. Select a directory where you want an "invariants/dasada" subdirectory
    containing all the files to appear, and execute:
      cvs -d :ext:gorlick@june.cs.washington.edu:/projects/se/people/mernst/.CVS-research co invariants/dasada
    In the future, from the dasada/ directory, you won't need to specify
    the "-d ..." argument to cvs; cvs will remember that value.

===========================================================================

You will do all your editing in this private subdirectory of your own.  You
have control over all files.  You do not need to check files in or out.  I
will have my own version of the files, which I can edit simultaneously.
There is a separate "repository" containing the master version, which
neither of us edits directly.

To update your code from the repository, merging in any changes made to the
repository since you last updated from it, do

  cvs update

(I personally use   cvs -q update   which gives slightly less output.)
Alternately, you may use  M-x cvs-update  in Emacs if you use pcl-cvs.el.

You might wish to update from my changes even if you're not ready to commit
your own changes because 
 * if there are conflicts, you would like to find out about them sooner
   rather than later, because the more irreconcilable editing we do the
   harder the merging will be (for both of us)
 * if I have added functionality, you may wish to take advantage of it

If some of the changes I've made conflict with changes you have made, "cvs
update" will tell you so, and the source file will be changed to include
both versions (yours and the one from the repository), in this format:

  <<<<<<< filename
  YOUR VERSION
  =======
  REPOSITORY VERSION
  >>>>>>> version_number

You resolve the conflict by editing the file, removing the markers and
leaving whichever version of the code you prefer (or merging them by hand).

To commit your changes -- that is, to replace whatever is in the repository
with your versions -- do

  cvs commit

You are not allowed to commit until you have updated to the most recent
version.  Whenever a group member commits changes, you will receive a
notification by email.

To add a file, do 2 things:
 cvs add FILENAME
 cvs commit FILENAME
To see what has changed, do (optional filename arg says diff only that file):
 cvs diff

The CVS manual is available online (via the Web, the Info documentation
system, etc.), as are additional tutorials.

You may wish to create a ~/.cvsrc file containing the following two lines:
diff -u
update -d -P
```
