Contents:




---

# UW (non-CSE-specific) #

UW Travel Card rules, from http://www.washington.edu/admin/procsrvcs/ecommerce/cta/travelcardpolicy.html:
You may use the UW Travel Card only for expenses related to the following
official UW business while on travel status.
  * UW business related travel expenses
> > such as airfare, lodging, meals, registration, car rental, ground transportation and miscellaneous travel expenses.
  * Meals associated with hosting and entertaining, and employee recruitment meals.
> > (Reimbursement is based on department approval and funding source.)
  * UW business related expenses such as photocopying and faxing.

Taxi stands near UW:
  * Hotel Deca, 4507 Brooklyn
  * UW Hospital
Or call Orange Cab, 206-522-8800.  For CSE, specify Paul G. Allen Center
for CSE - **not** Paul Allen Library - (technical address is 185 Stevens way
south of the Hub, but the dispatchers seem to have assigned an address
plotted within the grid surrounding campus:  3815 Stevens Way.

Career center, for prospective employers who want to hire a student:

> http://careers.washington.edu/employers

To enter grades online:  https://catalyst.uw.edu/gradepage

Final exam times can be predicted from weekly meeting times.
See http://www.washington.edu/students/reg/calendar.html

UW grading guidelines are
> http://depts.washington.edu/grading/practices/guidelines.html
Which is linked from here:
> http://depts.washington.edu/grading/practices/index.html

For off-campus access to the ACM digital library and similar UW-licensed
collections of content, three options:
  * Go to lib.washington.edu and click the off-campus login button at the
> > top right (or go directly to http://offcampus.lib.washington.edu/).
> > Then, restricted links should work.
  * Add offcampus.lib.washington.edu to the end of the hostname.

Getting study approval from IRB (run by HSD, Human Subjects Division):
  * Exempt studies:  usually interviews, questionnaires, and use of existing data
  * Non-emempt studies:
> > For the purposes of a grant proposal, you file an "approval in principle".
> > It's an IRB application for expedited review, but without consent forms
> > or other materials. The IRB generates a human subjects application #,
> > but not actual approval to do the study.  NSF only needs a box checked by
> > UW OSP, and UW OSP only needs an IRB application #.
Another option is to use Western IRB, in Olympia (contact:  Elaine Weakley).
UW apparently has an arrangement with Western IRB whereby Western IRB can
handle the IRB function for at least some subset of UW studies.  As with
other for-profit IRB organizations, they tend to be more
customer-service-oriented than the UW IRB.

To get to Microsoft Research (MSR) from UW by public transit, it's a
15-minute ride and runs every 10-15 minutes, depending on time of day.
Take bus 545 from the 520 freeway station at Montlake (on Google Maps, this
is "Montlake Frwy Sta, Seattle, WA"), or bus 542 (during
rush hour:  3-4 hours in the morning and afternoon) from the U district,
UWMC, or the Montlake station above 520.  Exit the bus at the "NE 40th St
freeway station" (aka "Overlake TC"?); on Google Maps this is "SR 520 Ramp
& NE 40th St".  From there, take a Microsoft
shuttle, or walk.  A relevant Microsoft campus map is:
![http://members.microsoft.com/careers/mslife/locations/images/west_campus.jpg](http://members.microsoft.com/careers/mslife/locations/images/west_campus.jpg)

To access the ACM digital library (or other content licensed by the UW
libraries) from an IP address that is not at washington.edu:
  * bookmark the following javascript URL:
> > javascript:void(location.href=%22http://offcampus.lib.washington.edu/login?url=%22+location.href)
To get access, visit the ACM DL, then visit the bookmark.

In UW Hires (https://uwhires.admin.washington.edu/eng/hm/default.cfm?szcat=hm):
  * to remove an individual from your main homepage (doesn't remove the
> > applicant from the position's homepage), click "complete evaluation
> > form" and enter "yes".
  * to see the cover letter, select the position (not the specific
> > applicant), then click on the percentage in the "score" column.

Cheap ($10) Microsoft Office/Project/Visio for home use, for UW faculty and
staff:  https://www.washington.edu/itconnect/wares/uware/microsoft/hup.html
Be sure to copy down the license key, as it is only temporarily saved on the
Microsoft server.

To approve spending:
  * Visit https://ucs.admin.washington.edu/MyFD/UWNetID/ReconciliationDashboard/ReconciliationDashboard
  * Click on "Reports >> Reconciliation Status"
  * Choose list: My PI Budgets (dynamic)
  * Click on "Go"
  * Click on any red "PI review" text (you cannot right-click to open it in another tab)
  * Click on green "Change Status/Audit Trail" button
  * In the popup window:
    * Select the "Sign off" radio button
    * Click "Save and close"
  * Repeat until there is no more red "PI review" text



---

# CSE #

UW CSE printer: ps581
  * One-sided (single-sided):
> > ps581/noduplex
  * No header pages:
> > ps581/nobanner
Color printer: psc581
> > I can't seem to create
> > > psc581/noduplex
Too often landscape PDF comes out rotated (& scaled down).  A solution is
to print from Acrobat Reader, and to check the "landscape" button.

At UW CSE, Melody Kadenko is a notary.

PL/SE lab is room 315 (phone 206-543-2053).
jicama.cs.washington.edu is a machine in that room.

An undergrad instructional linux server: attu

Printing enscript and cedilla output at CSE:
ced2:
  * .pdf: prints portrait (small)
  * .ps: one-sided, otherwise fine
  * .ps --ps2pdf-> .pdf  on ps581: prints portrait (small)
ens2f:
  * .ps on ps581: does not work
  * .pdf (converted from .ps with ps2pdf) on ps581:  prints portrait (small)
  * .pdf --pdf2ps-> .ps  on ps581: blank pages
  * .pdf --pdftops-> .ps  on ps581:  WORKS!
  * .ps on psc581: one-sided, otherwise fine
  * .pdf (converted from .ps with ps2pdf) on psc581:  prints portrait (small), one-sided
ens1f:
  * .ps on ps581: sometimes works, sometimes cuts off left margin
  * all other combinations work
ens1:
  * directly on ps581:  cut off left margin

To create press releases about UW/CSE research:
Hannah Hickey (hickeyh@u.washington.edu)

To set up a wiki at UW CSE, see
http://www.cs.washington.edu/lab/www/MediaWiki.shtml

To apply for a new UW CSE computer account at cs.washington.edu,
fill out the form at

> http://www.cs.washington.edu/lab/support/accountapp20.pdf
and then scan & email it, or fax it back.
You probably want a "guest, research account".
A guest account is only permitted to use 25 MB of space, so:
  * Always log into the same machine.
  * On that machine, create a directory /scratch/${USER} and store your
> > bigger files there.
  * make symbolic links from your home directory so you don't even notice
> > the disk quota limitation.

/cse/www2/types/ contains the content served at
http://types.cs.washington.edu/
/cse/web/research/plse/ contains the content served at
http://plse.cs.washington.edu/
/cse/web/courses/cse331/13sp contains the content served at
http://courses.cs.washington.edu/courses/cse331/13sp/

Incoming anonymous ftp:
You can upload files here via anonymous ftp:

> [ftp://ftp.cs.washington.edu/incoming](ftp://ftp.cs.washington.edu/incoming)
You won't be able to see the files (but that directory is readable by me as
/cse/ftp/incoming).  Let me know when the files are there so I can retrieve
them.

The /uns Maintainers' unFAQ:
http://dada.cs.washington.edu/uns/faq/uns-maintainer-faq.html

Remote desktop from Linux workstation to Windows Terminal Server:
```
  xfreerdp -u mernst aqua.cs.washington.edu
  xfreerdp -u mernst -g 1028x768 aqua.cs.washington.edu
```
(xfreerdp replaces rdesktop, but with rdesktop you would need to log in
with CSERESEARCH\mernst rather than AQUA\mernst.)
For vdilab access, see a list of available machines at http://vdi.cs.washington.edu/vdi/

To create a directory for a new project, such as to store a version control
repository, do so under /projects/swlab1 (or swlab2, etc.), such as
/projects/swlab1/typlessj/.  Please do not create a /projects/swlab1/$USER
directory, which is less informative.  And don't put this under your home
directory, which will get reaped eventually when you graduate or leave UW.

In the UW CSE visitor reservation schedule system (mvis):
  * To not show your name, prefix a description with "-" , e.g., "-Lunch at Canlis".
> > http://reserve.cs.washington.edu/visitor/help.php?#SEC25
  * To blackout some periods, prefix with "--", e.g., "--unavailable".
> > http://reserve.cs.washington.edu/visitor/help.php?#SEC22

How to sign up for undergrad research for credit in the UW CSE department:
1. Go to http://www.cs.washington.edu/students/ugrad/research#registration

> (Also available via: cs.washington.edu -> Current Students -> Information for
> > Current Undergrads -> MyCSE -> 'Ugrad Research' tab)
2. Fill out and submit the form on that page
3. It will send the professor the approval email
4. When the professor approves, it sends the student an SLN and add code.

Typical instructions for installing a package in /uns (see
http://dada.cs.washington.edu/uns/faq/uns-maintainer-faq.html#q3.2 ):
```
  source /uns/src/generic-builder.sh
  PKG=graphviz-2.20.3
  install_generic $PKG http://www.graphviz.org/pub/graphviz/stable/SOURCES/$PKG.tar.gz
```

nest.cs.washington.edu has 8gb (and 8 processors).  It is several years old
and usually idle.  It is a Windows machine.  To access the machine, Windows
Remote Desktop Connection is the easiest route.

To serve a Mercurial (hg) repository via the web (https:), first add
something like the following to its `.hg/hgrc` file:
```
  [web]
  allow_push = mdb, mernst, rcook, rose
```
Then, ask webmaster@cs.washington.edu something like the following:
```
  Can you make the https: Mercurial server serve
  /projects/swlab1/ductile/paper-2010, as
  https://dada.cs.washington.edu/hgweb/ductile-paper-2010/
  (Don't forget to change the directory ownership to prohibit access
  through the file system.)
  Please use the existing password file, but ensure it has entries for
  these users:  mdb, mernst, rcook
  One of:
    Please make the repository world-readable.
    Please issue a basic auth challenge on any access.
  Thanks a lot!
```
After this operation, it is only possible to access the repository via https:.
Direct file URLs will not work, because Apache (I think) will own the file.
The Hg repositories served by https are listed at
https://wasp.cs.washington.edu/Internal/hg.html

/cse/www is not mounted for attu.cs and other undergrad-accessible servers.
An undergrad (such as a TA) who wants to change such files must log in
through vole.cs.washington.edu.

Petitions for non-majors to take a UW CSE majors-only class:
http://www.cs.washington.edu/education/ugrad/academics/petition.html

If Google Chrome (chromium-browser) complains about an out-of-date version
of the Flash plugin, then copy a new libflashplayer.so to
/usr/lib/chromium-browser/plugins (I have write access, on godwit only).

If Google Chrome (chromium-browser) hangs, then complains about
unresponsive pages, try:  `rm -rf ~/.cache`.
Alternately, clear the relevant cookies from within Chromium (Wrench icon in the upper right of Chromium-> Preferences-> "Under the Hood" in the left menu bar-> "Content Settings..." button-> "All cookies and site data...")

A cycle server for WASP is nest.cs.washington.edu.

When CSE lab support upgrades the Java in /usr/java/current (which happens
without warning), then Hudson jobs may fail with the error message:
```
  Caused by: java.util.MissingResourceException: Can't find bundle for base name com.sun.org.apache.xerces.internal.impl.msg.SAXMessages, locale en_US
```
Stopping and re-starting Hudson seems to fix the problem.

To reserve seminar rooms 305 and Gates Commons, ask Tracy Erbeck or Heidi
Dlubac.

UW CSE intustrial affiliates program:  key contact is Kay Beck-Benton.
Stock reply for people trying to recruit/hire students:
Good luck on your project!
The best way to get access to UW's excellent students is via the UW CSE industrial affiliates program:  http://www.cs.washington.edu/affiliates/

UW CSE technical reports (TRs) are handled by Lindsay Michimoto.

To solve "Product Activation Failed" red titlebar for Microsoft Office 2010
(no activation key, KMS):
http://www.cs.washington.edu/lab/sw/windows/office2010/

To add a visitor's talk to the CSE colloquium talk calendar, send to eithe
Connie Ivey-Pasche or Kay Beck-Benton:

> name, affiliation, title and abstract, date, room, time,
> visitor schedule in MVIS if available

After a user has been added to a group using the GrpAdmin tool
(https://weblogin.cs.washington.edu/cgi-bin/grpadmin.cgi), it is generally
necessary for the user to do one of the following:
  * wait an hour
  * log out and log back in
  * use chgrpsh
after which the user will have access to the group.
Another potential complication is that each user can have only 20 login
groups -- those are the ones that are active at any time.  To change login
groups permanently, use
https://weblogin.cs.washington.edu/cgi-bin/grpadmin.cgi?screen=logingroups
.  To change effective groups temporarily, use chgrpsh.

For read permissions/access to the UW CSE grad student and advising
database, ask Dan Boren.  Then, access it via the Web:
> https://norfolk.cs.washington.edu/ssl-php/phpPgAdmin/
or from the command line (you need postgres, and you need to be on the CSE network):
> psql --dbname=cse\_admin --host=norfolk.cs.washington.edu --username=suciu

Instructions for maintaining UW CSE Drupal webpages/website:
https://wasp.cs.washington.edu/Internal/plse-webpages.html

If you want to send a message to UW CSE undergrads, send it to
cs-ugrads@cs.  It will be posted to the blog within 24 hours.
If you have a time-sensitive message, you should send that to
cs-ugrads-urgent@cs.

Jenkins setup:
  1. Created a jenkins user with the same uid as before and
> > /scratch/secs-jenkins/jenkins-home/ as home directory.

> 2. Installed the latest Jenkins.
> 3. Edited /etc/sysconfig/jenkins to set the home directory.
> 4. Started it.
> 5. Added it to runtime startup.
> 6. Visited http://buffalo.cs.washington.edu:8080/
> 7. Waited.
Try this for file .hgrc in ~jenkins (/var/lib/jenkins):
```
[trusted]
users = mernst, wmdietl, jenkins, apache
groups = pl_gang
[diff]
git = 1
[extensions]
fetch=
mq=
progress=
```

Card key access to rooms in the CSE building (the Allen Center):
cardkey@cs.washington.edu

Files of the form
> /cse/www/education/courses/503/11au
have become
> /cse/web/courses/cse503/11au
To fix, use:
> (replace-string "/cse/www/education/courses/" "/cse/web/courses/cse")

If I get
```
  CSE Web Login
  Fatal error: unable to get username and password from the form; contact the administrator
```
this may be due to a slow or laggy connection.  Try going directly to
https://weblogin.cs.washington.edu/cgi-bin/wlogin.cgi



---

# Seattle #

Options for short-term Seattle housing/rentals/apartments/sublets:
  * Craigslist: http://seattle.craigslist.org/sub/
  * UW Visiting Personnel and Visiting Students: stay in a dorm
> > http://www.hfs.washington.edu/conferences/planners.aspx?id=141
  * Visiting Faculty Housing Service: http://depts.washington.edu/uwfacaux/vfhs.html
  * J-1 Scholar Guide (see Housing, and also the complete guide):
> > http://iso.uw.edu/jfirst.html#Arrival_in_Seattle
  * Seattle Times: http://marketplace.nwsource.com/realestate/rentals/
  * Belltown Inn: http://www.belltown-inn.com/
> > (Fausto Spoto says it is very nice, but a touch more expensive than other options.)
  * Radford Court: http://radfordcourt.com/
  * UW Daily: http://dailyuw.com/classifieds/
> > (UW Daily mostly has offers of sharing with students, which is probably
> > too much of a risk, but it has some furnished apartments/houses too.)
Be sure to check where the apartment or house is in relation to the
university.  Sites include
  * hotpads.com
  * padmapper.com
I am happy to help out with logistics in Seattle (such as visiting an
apartment or helping with signing contracts).

Visitors should get on the wasp and 590n mailing lists.
  * WASP (programming languages): https://mailman.cs.washington.edu/mailman/listinfo/wasp
  * 590n (software engineering): https://mailman.cs.washington.edu/mailman/listinfo/cse590n



---

<a href='Hidden comment: 
Please put new content in the appropriate section above, don"t just
dump it all here at the end of the file.
'></a>