Contents:



---

# MIT-specific #

MIT medical service personal physicians:
http://web.mit.edu/medical/service/persphys.htm

MIT medical prescription refills:
https://pol.mit.edu/MITWeb/IDXPOL/PSLoginMIT.asp
(used to be https://pol.mit.edu/)

MIT human resources/benefits/personnel:
Benefits office:  E19-215, (617) 253-4251 (x4 for Benefits)
Susan Guralnick (x3-4643):  LCS personnel admin
Scott Runkle in HR was useful about 401(k), x3-0923
401(k): http://netbenefits.non-profits.com/
> (but to change amount taken out of my paycheck, I apparently need to
> call 1-800-343-0860)
403(b): http://web.mit.edu/benefits/www/bentda.htm

To have a copy job (e.g., course notes) performed by Copy Tech, send it to
> ctc-sendfiles@mit.edu
Info required:
```
  Date required:
  Course:
  Description:
  Deliver to name:
  Deliver to room:
  Deliver to phone:
  Copies:
  1/2 sided:
  3 hole punch?:
  stapled?:
  Comments:
  Account number:
```
Use account number 1468100 for course-related copying.
Also see http://web.mit.edu/ctc/www/.
Human contacts in Electronic Media Service:
Don Choate (8-7794) or Scott Perrigo (2-3575)

sciowl@mit.edu: ask questions of a science reference librarian
Include this block in the email:
```
Client:         Michael Ernst
Phone:          3-0945
Dept.:          EECS
MIT Status:     Faculty
MIT Address:    32-G718
Email:          mernst@csail.mit.edu
```

Barker Engineering Library EECS specialist:  Deborah Helman (dhelman@mit.edu)
MIT central libraries CSAIL specialist: Amy Stout (astout@mit.edu)

WEBSIS is the student (and advisor) information system run by the registrar.
http://websis.mit.edu

To avoid paying sales tax on items purchased for MIT, show the ST-2 and
ST-5 forms (online at http://controllers.mit.edu/site/tax/forms). You do
not need to fill anything out.
MIT sales tax exemption number:  E 042-103-594

The MIT Registrar's picture class list (photo sheets of registered students
in a subject, from ID photographs) is available from http://student.mit.edu.
There is some software to manipulate these at
~mernst/class/6170/2005-spring/ST05/administrivia/picture-directories/ .

For hotels that are nearby MIT, see
http://homes.cs.washington.edu/~mernst/contact-csail.html

MIT electronic classrooms:  http://web.mit.edu/acs/eclassrooms.html

Committee on Discipline
FAQ for faculty:  http://web.mit.edu/discipline/academic.html#faq
Checking for prior record:
http://web.mit.edu/discipline/contact.html

Grant proposals may require a conflict-of-interest form for MIT Office of
Sponsored Programs:
> https://coeus.mit.edu/coeus/loginCOI.do

Since Optional Practical Training for international students on
student visa became difficult to obtain, requiring, for example, four
months of advance notice, the department has created a new subject
number, 6.920, that can be used for curricular practical training.  It
is limited to one P/D/F unit and requires an MIT advisor and
department approval before the work is begun.  Students may wait to
register for the subject in the term following the work experience; in
the Fall, for example, after a summer job.

If you are locked out of your office after regular work hours, on
holidays or weekends, please call Campus Police.  They have a
master key, called an "H" key, that will open your office door.
It usually takes about 1/2 hour or so for them to arrive.  Their
number is 253-1212.

To have an abandoned bike removed from a bike rack at MIT, call 3-9755.
MIT Police won't do anything unless they are obstructing a firelane,
railing, etc.

The MIT Libraries' Firefox plug-in, LibX, permits you to get MIT-licensed
scholarly material (journals, conferences, papers) without using Vera.
> http://libraries.mit.edu/libx

UROP Homepage for Faculty:  https://sisapp.mit.edu/uropweb/facultyHome.mit
UROP Homepage for Students:  https://sisapp.mit.edu/uropweb/home.mit



---

# Athena-specific #

<a href='Hidden comment: 
% This section contains information about Athena, the MIT computing system.
'></a>

To find out whether a particular software program is available/installed on
Athena, use
> http://web.mit.edu/acs/www/whereruns.html
It may not list every single program but it provides a good sense
of the lockers that are available.

On athena, map uid to username with
```
  hesinfo UIDNUMBER uid
```
where UIDNUMBER is the uid.
This returns a line in /etc/passwd format.

On athena, ~/OldFiles is a copy of the directory's contents a day ago.
(I guess it's the same as ~/.snapshot on CSAIL.)
Remove it with
```
        fs rmm OldFiles
```
and put it back again at any time using the command
```
        fs mkm OldFiles user.username.backup
```
Files deleted with the 'delete' command can be recovered via 'undelete';
type 'man undelete' for details.

On athena, to check whether a directory was ever used:
```
    athena% vos e course.6.170.se84
    course.6.170.se84                 537323985 RW          2 K  On-line
     ERIS.MIT.EDU /vicepb 
     RWrite  537323985 ROnly          0 Backup  537323987 
     MaxQuota      20000 K 
     Creation    Mon Sep 25 18:57:57 2000
     Last Update Mon Sep 25 19:02:33 2000
```

Athena mailing lists:
http://web.mit.edu/moira or run "listmaint" on Athena.
Also:
expn shows the "live" status of the list at the mailhubs
blanche shows database contents, which will eventually propagate to mailhubs
Updates to moira lists make it to the mail servers about every three hours.
To find out the time of the last update:
```
  add consult
  lastupd
```

To run SAS on Athena, do
```
  add sas
  sas
```
For SAS user messages, see /mit/sas/Athena/messages/
(Further SAS tips in ~/wisdom/programs

Ask a question of an Athena consultant:
olc-unix@mit.edu

Running long jobs on Athena:
Myron Freeman (fletch1@eecs.mit.edu), who goes by "Fletch", is the
sysadmin for eecs-course.mit.edu, which is an Athena machine on which
long-running jobs can be run.

Athena combination:  on Athena, run:  tellme combo

If your Athena dotfiles (.bashrc, .cshrc, .environment) become corrupted,
you can try 'quarantining' your personalized dotfiles (move them aside) and
then copying over the dotfiles found in /usr/prototype\_usr/ .

athena.csail.mit.edu is owned by Frans Kaashoek.

To create a Wiki on Athena:
```
  add scripts
  scripts-start
```
Select 'mediawiki', tell it what URL you want the wiki at, and you're
done.  ( http://scripts.mit.edu/start/ for more details )
(As of 3/31/2008, I can't figure out how to set the "database host" field,
though this had worked for me earlier.)



---

# CSAIL-specific #

CSAIL Personnel Assistant: Rachel Avery
EECS Personnel: Lisa Bella, 253-4611

You can send email to any floor in the Stata Center using the unmoderated
HQ mailing lists, e.g., g7@csail.mit.edu.

FedEx dropoff box in the Stata Center: in the Dreyfoos tower, on the
B-Level, to the left of the elevator.

Various Windows software (including Microsoft and MSDN) is available to the
CSAIL community:  see
http://tig.csail.mit.edu/software/index.html

To create/edit a CSAIL mailing list, follow the directions at
> http://lists.csail.mit.edu/
Common things to change after creation:
  * General options:
    * Public name (case changes only)
    * Terse phrase identifying the list
    * Introductory description
  * Passwords:
    * administrator password
  * Privacy options
    * Subscription rules
      * advertise this list
      * require approval
    * Sender filters
      * action to take for postings from non-members
To delete/remove a mailing list (this script also removes the INQUIR entry):
```
  /afs/csail/group/tig/bin/rmlist <listname>
```

Martin Rinard's group ("program analysis and compilation group", or PACG)
email address:
freepizza@lesser-magoo.csail.mit.edu

Cron jobs:
Ask TIG for an individual crontab account.  The files will be in
/afs/csail.mit.edu/group/tig/keytabs/$USER/$USER.keytab, readable
and deletable by $USER.  These should be stored in a secure (local)
file system on the machine where your cron jobs will run, and should
be readable only by $USER.  I'm assuming it's stored in /etc in the
example below.
The name of the principal is $USER/cron@CSAIL.MIT.EDU, which in AFS
is called $USER.cron.  Your cron job needs to call a script of the
following form:
```
  #!/usr/bin/pagsh
  # Note, using `pagsh' above is important; do not change.
  {
    KRB5CCNAME=/tmp/krb5cc_cron_${USER}
    export KRB5CCNAME
    kinit -k -t /etc/${USER}.keytab ${USER}/cron@CSAIL.MIT.EDU
    aklog
    kdestroy
  }
  # Now running under the UNIX user ${USER} but AFS user ${USER}.cron
  # rest of your cron job here
```
One way to do this is just to make the crontab command be of the form
```
  AFS=/afs/csail.mit.edu/u/m/mernst/bin/share/afs-cron-wrapper
  $AFS COMMAND
```

CSAIL acroread is /afs/csail/i386\_linux24/local/bin/acroread

To run INQUIR on a CSAIL machine:
```
  whois -h inquir.csail.mit.edu mernst
```

CSAIL email:
IMAP (incoming) mail server: imap.csail.mit.edu
SMTP (outgoing) mail server: outgoing.csail.mit.edu
You must also configure your mail client to at least one of SSL/TLS
> encryption or CRAM-MD5 (or DIGEST-MD5) to protect your password from
> traversing the network unsafely.
You may also access your account via the webmail interface.

CSAIL certificates available at:
> https://ca.csail.mit.edu/cgi-bin/query?algo=rsa&type=client&cn=Michael+Ernst&format=browser
or
> https://ca.csail.mit.edu/cgi-bin/query?algo=rsa;type=client;email=mernst%40CSAIL%2eMIT%2eEDU;format=browser
(At one point, it was bad to regenerate, as that action revoked my old
ones.  That is not the case any more.)

MIT CSAIL AFS web logs:
> http://tig.csail.mit.edu/twiki/bin/view/TIG/WebServerStatistics
For www.pag.csail.mit.edu:
> http://www.pag.csail.mit.edu/internal/cgi-bin/log-tail.cgi
The web logs for people live in /var/log/apache2/ on people.csail.mit.edu.
You can just log in to the machine to tail the logs if you need, or you can
adjust your script to look there.

Apache config file for the pag virtual host:
> /afs/csail.mit.edu/proj/www/www.pag.csail.mit.edu/httpd.conf
(By default, Apache configuration files are in /etc/httpd/conf/.)
"AllowOverride" and similar options should be set, per-directory.
[I'm not sure how I get this configuration file to be re-read.]

Error logs for apache webserver are available on the servers.  Servers
are named people.csail.mit.edu, groups.csail.mit.edu, etc.  The error
logs are at /var/log/apache2/error.log

The TIG webservers for csail are people.csail.mit.edu, group.csail.mit.edu

At CSAIL, to use Java 1.4, either by use "javac-1.4" and "java-1.4" instead
of "javac" and "java", or put
> /afs/csail.mit.edu/group/pag/software/pkg/jdk-1.4/bin
at the front of your PATH.

Creating a new CSAIL account (including guest accounts):
> https://inquir.csail.mit.edu/cgi-bin/welcome.cgi

To change CSAIL shell:
> https://inquir.csail.mit.edu/cgi-bin/chsh.cgi

SPEC benchmarks can be found on CAG, in /home/benchmarks.

To close (resolve) a TIG/OPS ticket, click on "reply" in the display and
then set the status when sending the reply.
But TIG prefers to close them itself, so it's better to just send them a
message asking that it be closed.

TWiki web at CSAIL:
(But many folks recommend MediaWiki instead.)
Only TIG can create a new web; ask them for each one to be created.
The PAG web is
> https://projects.csail.mit.edu/cgi-bin/wiki/view/PAG/WebHome
The Web can be configured at
> https://projects.csail.mit.edu/cgi-bin/wiki/view/PAG/WebPreferences
Read https://projects.csail.mit.edu/cgi-bin/wiki/view/TWiki/WelcomeGuest
> to get a quick overview of this collaboration platform.
You should create a "WikiName" for yourself at
> https://projects.csail.mit.edu/cgi-bin/wiki/view/Main/TWikiUsers
then, my personal TWiki topic is located at
> https://projects.csail.mit.edu/cgi-bin/wiki/view/Main/MichaelErnst .

Creating a MySQL database at CSAIL:  Must ask a sysadmin to do so.  They
need a database name, user name, and initial password (send encrypted or
via phone).  All new databases are created on the dedicated database
server, mysql.csail.mit.edu.

Access any O'Reilly book online.
goto libraries.mit.edu and search for the book you want.  From the
correct record, choosoe 'Online Ed. URL'
or go directly to http://library.mit.edu:80/F/SEVDTEY3AA8RXCLBJAPG35KDC2I4X1RPIQNXQSHVXV1KGNSLAE-06114?func=service&doc_library=MIT01&doc_number=001351184&line_number=0002&service_type=MEDIA

Noah Meyerhans has a bicycle truing stand in his office at CSAIL.

Garrett Wollman runs CSAIL's nntp (netnews) servers.
They include a mail->news gateway, but no news->mail gateway.
The names are .lcs.mit.edu rather than .csail.mit.edu
The news servers are only readable from net 18 (MIT).
Other news servers on campus are run by EECS (Fletch) and SIPB
(usenet@mit.edu).

Creating public SVN access:
https://svn.csail.mit.edu:1443/admin/admin.cgi

The Stata stairwell alarm sounds "bong bong bong _stairwell_ 0 _floor_",
indicating where the alarm was triggered.  Stairwells 1 and 2 are in the
Dreyfoos tower; 3 and 4 are in the Gates tower.  For example, if someone
pushes the big red button near HQ, you will hear "bong bong bong, 3 0 4"
throughout all the stairwells in the building.  To turn the alarm off, go
to the appropriate alarm at _stairwell_, _floor_ and press the little black
rocker switch that is hidden in a recession below the big red button.

Creating a CSAIL TR (technical report):
> http://publications.csail.mit.edu/

A notary at CSAIL:
Rachel Avery
Human Resources Assistant
32-G425a
rachel@csail.mit.edu
617-253-3212

A web proxy for accessing MIT resources from home:  see the FAQ at the
bottom of http://nms.lcs.mit.edu/ron/ronweb/mit.html .
(TIG's web proxy is only available from CSAIL.)

At CSAIL, to enable or edit public or private svn https web (WebDAV) access
to a repository, goto the page:
> https://svn.csail.mit.edu:1443/admin/admin.cgi
Instructions from TIG are available at:
> http://tig.csail.mit.edu/twiki/bin/view/TIG/UsingSubversionAtCSAIL
Make sure that each directory gives the user svn rlidwka access.
Don't forget to:
  * create the htpasswd file (I don't know how to set up an ACL file):
> > htpasswd -c /afs/csail/group/pag/projects/annotations-htpasswd _username_
  * set permissions for the repository directory:
> > find . -type d -exec fs sa {} svn rlidwk \;
  * set permissions for the htpasswd file:
> > fs sa _dir-with-htpasswd_ svn rl



---

# CSAIL printing #

CSAIL printer and copier locations:

> http://tig.csail.mit.edu/twiki/bin/view/TIG/ListOfPublicPrinters
A web interface to all printers:
> http://cups.csail.mit.edu:631/printers
Large format (large scale) 42"x60" plotters are conspirator and eetimes (or
others whose model is DesignJet):
> > http://tig.csail.mit.edu/twiki/bin/view/TIG/PrintingToConspirator

Printer options for CSAIL cups printers:
To staple (two at the top) and not print header pages:
```
  lpoptions -p xerox5/psets -o StapleLocation=DualLandscape -o job-sheets=none
  lpr -P xerox5/psets myfile
```
For portrait mode stapling::
```
  lpr -o StapleLocation=SinglePortrait myfile
```
To print single-sided:
```
  lpr -o sides=one-sided myfile
```
For a list of all options:
```
  lpoptions -p xerox7 -l
```

CSAIL xerox7 (7th-floor copier/scanner) can output to files in AFS, via the
"Network Scanning" icon.  The file shows up about 5 minutes later in

> /afs/csail.mit.edu/service/scan-to-file/${USER}/

When a CSAIL printer runs out of ink/toner or paper, send mail to
ops@csail.mit.edu to have it replaced.

Alternate way to print to MIT CSAIL printers from Windows:
Start > Run > \\teem.lcs.mit.edu\windows\printer-drivers\

CSAIL copier codes:
> 6.170: 30500
Perhaps 30500 is a generally-used code?

CSAIL video conference room (32-262):  IP 128.30.30.43
http://tig.csail.mit.edu/twiki/bin/view/OOPS/VideoConference
To call Mike in Germany, use IP 139.19.100.30



---

# EECS-specific #

Info about undergraduate theses (including prizes):
> http://www.eecs.mit.edu/ug/thesis-guide.html#anchor13

Marilyn Pierce (andrea@eecs.mit.edu) can send email to all EECS grad
students (such as advertising a TA position), via
grad-students@altoids.mit.edu .

The Chu Lounge combination (as of 3/24/2006) is is 4-15
(push 4, then push 5 and 1 at the same time)

The "Who is teaching what" or "who's teaching what" list for MIT EECS:
http://www.eecs.mit.edu/WTW_ST07.html
It includes only the in-charge lecturer, not co-lecturers or section leaders.
The HKN undeground guide doesn't include classes that they skipped, and may
not include



---

# PAG-specific #

EDG C front end:
https://www.edg.com/download, user id mit, password saman6398.
Don't download or view the software until you have signed an NDA!
You can find the NDA at $inv/doc/www/mit/edg-nda-noncomm.pdf .

The pag machines allow cross-mounting of /scratch and /scratch2:
```
  cd /var/autofs/net/{pag-client}/scratch  
```
but not:
```
  cd /var/autofs/net/{pag-client}/scratch2
```

Bugzilla database at http://pag.csail.mit.edu/zilla

pag.csail.mit.edu IP address: 128.30.84.11 (?)
manioc.csail.mit.edu IP address: 128.30.84.42

To advertise for UROPs send email to Anne Hunter (anneh@mit.edu).
It seems best to send each announcement separately (one day apart)

The CSAIL "daikonuser" account has PAG-specific customizations (like old
daikongroupmember).  The Daikon overnight regression tests are run as
daikonuser.
The CSAIL "paguser" account has no customizations (like old daikonuser).

On PAG Debian machines, a cron job updates
```
  /afs/csail.mit.edu/group/pag/adm/package-lists/auto
```
Whenever you install a new package on a machine, make an entry for the
package you wanted in /afs/csail.mit.edu/group/pag/adm/debian-pkgs ,
cutting and pasting the output from "dpkg -l" into the appropriate
category.  This will help us distinguish which packages we really want, and
which were installed just as dependencies; packages of the latter type
might need to be removed to accommodate other upgrades.

Samba accounts at pag.lcs.mit.edu:
**all samba accounts must (first) have real unix accounts
> (aka, exist at pag.lcs.mit.edu:/etc/passwd)** use smbpasswd to add a user (as root)
> See ~ts/bin/samba/add-windows-user, which calls
> > /usr/bin/smbpasswd -a -n -d NEWUSERNAME
**use smbpasswd to change password for the user (as root)
The user should now have a valid entry at pag.lcs.mit.edu:/etc/samba/smbpasswd :

> sudo grep ${username} /etc/samba/smbpasswd**

To test the samba connectivity at pag.lcs.mit.edu:
> smbclient -L pag.lcs.mit.edu
The interesting lines are those with Type "Disk", so then do:
> $ smbclient '\\pag.lcs.mit.edu\ts'
> added interface ip=18.24.8.42 bcast=18.24.8.255 nmask=255.255.255.0
> Password:
> Domain=[PROGRAMANALYSIS](PROGRAMANALYSIS.md) OS=[Unix](Unix.md) Server=[2.2.7-security-rollup-fix](Samba.md)
> smb: \> ls
> ;; shows me ~ts



---

# Boston-specific #

Apollo Travel (617-876-4471, 860 Mass. Ave., between Harvard and Central
Squares) knocked 22% off Jeremy Nimmer's ticket price (sometimes requires
being a student, sometimes doesn't), and he has heard similar things from
other friends, so they seem to be a good agent.  I use
Abra Smith (abratravel@yahoo.com) of Council Travel, who has worked similar
or greater miracles.

Boston-area housing/renting/rental apartments/condos:
reuse-housing@mit.edu
boston.craigslist.org/roo/
boston.craigslist.org/hsw/
web.mit.edu/housing/och/
reuse@csail.mit.edu

Can recycle styrofoam packing peanuts ("loose fill") at
  * Mailboxes Etc, 831 Beacon St, Newton Center
  * UPS Store, Davis Square



---

<a href='Hidden comment: 
Please put new content in the appropriate section above, don"t just
dump it all here at the end of the file.
'></a>

<a href='Hidden comment: 
LocalWords:  Guralnick admin Runkle HR FRU Choate Perrigo Helman WEBSIS faq gi
LocalWords:  firelane eetimes DesignJet lpoptions xerox psets StapleLocation
LocalWords:  DualLandscape lpr myfile listname PACG Cron
'></a>