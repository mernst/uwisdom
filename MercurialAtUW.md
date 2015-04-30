Create a file `~/.hgrc` with the following contents (customize to your
username, etc.), on **both** the UW file
system and on any other machine (such as a laptop or a departmental VM)
where you want to run Mercurial.
```
[ui]
username = My Full Name <username@cs.washington.edu>
# If you are not an Emacs user, then replace the following line by "merge = merge"
merge = emacs
[merge-tools]
emacs.args = -q --eval "(ediff-merge-with-ancestor \"$local\" \"$other\" \"$base\" nil \"$output\")"
[extensions]
# There is nothing after the equal sign, for built-in extensions like 'fetch'.
fetch =
[trusted]
users = mernst, apache
```

Then, for a few tips on using Mercurial, see
http://code.google.com/p/uwisdom/wiki/VersionControl#Mercurial_(Hg)

To avoid having to type your password for every version control operation
(and when logging in to other machines, etc.), see
http://code.google.com/p/uwisdom/wiki/Programs#ssh_(secure_shell)