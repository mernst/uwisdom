# AFS and Kerberos


On github.com, you can view the table of contents of this file by clicking the
menu icon (three lines or dots) in the top corner.


## Kerberos


For jobs running longer than 8 days that need Kerberos tickets, see
  /afs/csail/group/lis/bin/lislongjob
Also see "longsession" command.
Finally, see the "longjob" command.  The syntax for this one is

```sh
  longjob <your job>
```

longjob -h shows other options.


To renew a Kerberos ticket (without having to type a password):

```sh
  kinit -R
```

To see the result:

```sh
  klist
```

On AFS, the appropriate commands are:

```sh
  renew -r 8d
  authloop &
```

To run a detached long job, you can do

```sh
  authloop &
  <your job>
```

but "longjob" may be more convenient.


kpasswd:  change Kerberos password
(I may need to do `kinit` before `kpasswd`.)


Cross-realm Kerberos authentication:
To get athena tickets:

```sh
  setenv KRB5CCNAME /tmp/krb5cc_$$.athena
  kinit -5 $USER@ATHENA.MIT.EDU
  aklog -cell athena
```

To get CSAIL tickets:

```sh
  setenv KRB5CCNAME /tmp/krb5cc_$$.csail
  kinit -5 $USER@CSAIL.MIT.EDU
  aklog -cell csail.mit.edu
```

To get UW CSE tickets:

```sh
  setenv KRB5CCNAME /tmp/krb5cc_$$.uwcse
  kinit -5 $USER@CS.WASHINGTON.EDU
```

Also see:  <http://tig.csail.mit.edu/twiki/bin/view/TIG/CrossCellHowto>
Also see:  ~mernst/bin/share/csail-athena-tickets.bash


## AFS


To modify AFS directory/file permissions/acls/access control lists, see

* <http://www-2.cs.cmu.edu/~help/afs/afs_quickref.html>
* <http://openafs.org/>
* <http://web.mit.edu/answers/unix/unix_chmod.html>

To view AFS permissions:

```sh
  fs listacl directory
```

To set permissions:

```sh
  fs setacl directory [id rights]*
```

where id is a user or "system:groupname".
To make a directory world-readable:

```sh
  fs sa directory system:anyuser rl
```

To make a directory and all subdirectories world-readable:

```sh
  find . -type d -exec fs sa {} system:anyuser rl \;
  find . -type d -exec fs sa {} mernst.cron rlidw \;
```


Seven rights/permissions are predefined by AFS: four control access to
a directory and three to all of the files in a directory.
The four directory rights are:

* lookup (l) -- list the contents of a directory
* insert (i) -- add files or subdirectories to a directory
* delete (d) -- delete entries from a directory
* administer (a) -- modify the ACL

The three rights that affect all of the files in a directory are:

* read (r) -- read file content and query file status
* write (w) -- write file content and change the Unix permission modes
* lock (k) -- use full-file advisory locks

The following are shortcuts:

* all : gives all rights - rlidwka
* write : gives rlidwk rights
* read : gives rl rights
* none : removes all rights


In AFS, (only) the user mode bits of regular files retain their function;
they are applied to anyone who can access the file.


AFS groups:
(On Athena, don't use these commands.
Instead, use blanche, listmaint, or <http://web.mit.edu/moira>.)
Add a user to an AFS group:

```sh
  pts adduser USERNAME GROUPNAME
```

List users in a group, or groups a user belongs to

```sh
  pts mem GROUPNAME
  pts mem USER
```

Create a group:

```sh
  pts creategroup GROUPNAME
  pts creategroup pag-admin:daikondevelopers -owner pag-admin
```

(If you belong to a group, you can add members if its fourth privacy flag
is the lowercase letter a.)


To determine how much AFS (e.g., Athena) quota is available/free and used
(i.e., to determine disk space usage), do
fs lq /mit/6.170


The command

```sh
  zgrep 'Lost contact' /var/log/messages*
```

on a CSAIL Debian box will show you all the times in the last month that
your machine noticed the AFS servers being down.


To test AFS latency performance (when the file system is sluggish), run
(bash syntax):

```sh
  for i in `seq 1 10`; do /usr/bin/time -f "%E" mkdir foo; rmdir foo; done
```

(To test AFS bandwidth, use pv to copy a large file; but we've never seen
such problems.)


