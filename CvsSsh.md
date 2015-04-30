Contents:


>entry How to use CVS with ssh instead of rsh

Note that all of the below is not necssary if you use Kerberos
authentication, which is an even better method.

If you use the 'pserver' method of authentication (CVSROOT is set
to :pserver:user@machine:/path) and you've done a 'cvs login',
CVS will store your password, trivially encrypted, in ~/.cvspass,
and send it over the wire in that form.
Anyone who can read .cvspass (e.g., anyone with root) or anyone who
intercepts wire traffic can get your passwords.

Instead of using pserver and cvs login, you can set CVSROOT to use
'ext' authentication. By default, ext means rsh, but you can change it
to use ssh:

export CVSROOT=:ext:user@machine.name:/cvsroot
export CVS\_RSH=/usr/bin/ssh

Now, instead of doing cvs login, each cvs command (add, commit, etc.)
will prompt you for your password as it connects via ssh.

Typing your password over and over is hardly ideal; cvs login
was nice and convenient in that you didn't have to type your password
any more. Never fear, though, ssh offers a way around this as well!

Here's the recipe:

# Generate a private and public ssh RSA key pair with "ssh-keygen" (and remember that passphrase!)

# Concatenate the ~/.ssh/identity.pub public key file onto the end of ~/.ssh/authorized\_keys on the machine with the CVS repository.

# At the beginning of each development session, run
```
     ssh-agent bash
     ssh-add
```

<entry