# Information about resources available on the network


// Examples include download locations, ftp sites, web sites, and some
// information on network-specific programs.
// In the brave new Google world of effective searching, it may be somewhat
// less important than it was in the past.


## Email


Anyone may subscribe to the Computing Research Association's <jobs@cra.org>
list, but only organizations that advertise in Computing Research News may
post jobs announcements.
To Subscribe: Send the following mail message to <listproc@cra.org>:
                      subscribe jobs firstname lastname


Any username characters after "+" are ignored by mail delivery systems.
This makes it easy for me to add "+" suffices to simplify sorting of my
mail.


To obfuscate mailto email address links on web pages with Javascript to
avoid spam:  <http://www.u.arizona.edu/~trw/spam/spam.htm>
But this is probably hopeless:  your email address is probably out there
already, and you're probably using spam filtering already.


In Horde mail reader, I must create folders with names like
"INBOX.Daily", not "Daily" (which gives me "Permission denied" errors).


To join a Google Groups mailing list with a Google Apps account (e.g.,
@cs.washington.edu), you have to create your own URL:
  <http://groups.google.com/group/_groupname_/boxsubscribe?email=_email>_


In Google Groups, to permit "reply all" to go to the sender:
  Settings >> Email options >> Post replies: Users decide


When creating a mailman mailing list, some common good options to change:

* General options:
  * A terse phrase
  * Should Mailman replace any existing Message-ID: header: no
* Membership Management >> Mass Subscription
* Privacy options...
  * Sender filters
    * non-member addresses whose postings should be automatically accepted


Throwaway email addresses: simplelogin, maildrop


## AWS Amazon Web services


To download files from Amazon S3, first install via

```sh
    sudo easy_install awscli
    aws configure
```

and then run a command such as

```sh
   aws s3 sync s3://bucketname .
```

For example:

```sh
   mkdir -p ~/tmp/aws-s3
   cd ~/tmp/aws-s3
   aws s3 sync s3://travis-checker-framework .
```

Doing `aws s3 sync s3://travis-checker-framework/typetools/checker-framework/1048/1048.1 .`
copies the contents of that remote directory to the current local directory.
To delete/remove files:

```sh
   aws s3 rm --recursive s3://travis-checker-framework/typetools
```


Amazon Web Services (AWS) tips, from Darioush Jalali:

* Billing is not logged by default. This can be confusing if you are
   trying to figure out how much money you are spending initially.
* If you have jobs that can be restarted easily, spot instances are
   up to 10x cheaper than on-demand instances. Amazon may turn them off
   whenever they choose (this is rare).
* Amazon limits the number of types of certain instances they grant.
   Customer support will increase this, but it takes a couple days.


## Uncategorized


LEDA is the Library of Efficient Data Types and Algorithms, implemented in C++.


The Forsythe list is a list of Ph.D.-granting Computer Science and Computer
Engineering Departments.


The dot/dotty tool is part of AT&T Research's graphviz package:
<http://www.graphviz.org/>
DaVinci is similar, but for X windows:
<http://www.informatik.uni-bremen.de/~inform/forschung/daVinci/>


(What is a comparison between xgrab and graphviz?)
'xgrab' (X graph browser), a graph layout and browser package running under
X11.R4, is available as cs.washington.edu:pub/xgrab.tar.Z.
Xgrab reads a textual specification of a graph, lays out the graph
using heuristics to minimize the number of edge crossings, and displays
the graph as labeled nodes and edges in an X window.  The user can then
edit the graph.  Once happy with the graph layout, xgrab can write a
postscript file or a text file describing the resulting graph.


ACM copyright form is available at
<http://www.acm.org/pubs/copyright_form.html>.


Phil Agre's "Designing Effective Action Alerts for the Internet" is
available at <http://dlis.gseis.ucla.edu/people/pagre/alerts.html>.  Point 15
is "Do not use a chain-letter petition."


To see whether a domain has been registered:
<http://www.networksolutions.com/cgi-bin/whois/whois>


SourceForge (<http://sourceforge.net/>) is a free open-source developer
support service that provides, among other things, CVS repositories and
access to compile farms.
Savannah is the GNU/FSF alternative.


Register domain names:  joker.com is cheap; also dotearth.com.


BSD calendar program:
// old: ftp://sunsite.unc.edu/pub/Linux/distributions/redhat/contrib/libc5/SRPMS/calendar-8.4-3.src.rpm
// old: ftp://metalab.unc.edu/pub/Linux/distributions/redhat/contrib/libc5/i386/calendar-8.4-3.i386.rpm
ftp://ftp.cs.uni-frankfurt.de/pub/linux/Mirror/ftp.redhat.com/contrib/libc5/SRPMS/calendar-8.4-3.src.rpm
Or, use "qalendar", but it doesn't permit comment lines.
Install:

```sh
  rpm -Uvh -vv ftp://ftp.cs.uni-frankfurt.de/pub/linux/Mirror/ftp.redhat.com/contrib/libc5/SRPMS/calendar-8.4-3.src.rpm
```


To donate used inkjet printer cartriges:  <www.donateinkjets.com>


The Elements of Style by Strunk and White is online (do a search for it).


NSF GPG (Grant Proposal Guide):
<http://www.nsf.gov/publications/pub_summ.jsp?ods_key=GPG>


wget is a command-line utility to fetch web pages and save them to the
local disk.  <http://www.gnu.org/software/wget/wget.html>
To download a single file, only if it's newer than the on-disk version:

```sh
  wget -N URL
```

wget is also useful for web site mirroring.
To download everything below a current point:

```sh
  wget -r -k -np URL
```

To get just a single file and its dependencies, converted for local viewing:

```sh
  wget -pk -nH -nd -Pdownload-dir URL
```

Or, an easy way to do the latter is just to view the URL in Firefox, then
choose "save as"!


Andreas Zeller recommends EasyChair (<www.easychair.org>) as the best
conference management system he has used.
Many others recommend HotCRP, especially the systems community.


Paperdyne conference management system:

* To view all abstracts, the key is to log in as reviewer (not PCC).
   Then, go to "Papers" and click "show abstracts' bodies".  (Click on
   "printer-friendly" version if printing.)
* In Paperdyne the submission phase is not cloased automatically.
   Paperdyne closes if you switch to the next phase (see
   <http://www.paperdyne.com/faq/p1_2.html>).


VistaPrint.com: cheap business cards


Shimano road bicycle components, as explained by
<http://www.epinions.com/content_957259908>:

* Sora
   Like the Deore mountain bike parts, the Sora is entry-level components.
* Tiagra
   Like the LX side of Shimano.
* 105
   The 105 component group is somewhere between an LX component group and
   an XT component group in the mountain biking division.
* Ultegra
   This product line will be most comparable to the XT product line in the
   mountain division of Shimano.
* Dura-Ace
   Like the XTR component group in the mountain bike division.


Buy clip art and photos:  <http://istockphoto.com>


When having networking problems in a Linux/Debian/Ubuntu VMware guest (e.g,
"no network connection" when hovering over icon), reinstall VMware tools.


To get a printable version of a blogger webblog, apply these diffs:
1:

```html
   #content {
-    width:660px;
     margin:0 auto;
```

2:

```html
   #main {
-    width:410px;
     float:left;
```


// To run NetMeeting on Windows XP,
//   Start -> Run -> conf.exe


The plume-bib README instructions are available in these (identical) files:

* <https://github.com/mernst/plume-bib>
* <https://raw.githubusercontent.com/mernst/plume-bib/master/README.md>


Neither of these redirect:

* <http://rawgit.com/mernst/randoop/master/doc/index.html>
* <https://rawgit.com/mernst/randoop/master/doc/index.html>

even though the second one of these two does redirect:

* <http://rawgit.com/mernst/plume-bib/master/README>
* <https://rawgit.com/mernst/plume-bib/master/README>

Weird.


For PC remote control:

* logmein.com,
* If they are running Windows 7, its extremely easy to walk them through
  * Hitting the start button,
  * Typing 'Windows Remote Assistance' in the search bar
  * Clicking 'Invite someone you trust to help you,'
  * Clicking Easy Connect and having them recite the letters on their screen.
* <www.mikogo.com>
* teamviewer
* ultraVNC single click
* Meraki Systems Manager
* Chrome Remote Desktop: <https://chrome.google.com/webstore/detail/chrome-remote-desktop/gbchcmhmhahfdphkhkmpfmihenigjmpp>


For a Google spreadsheets survey, be sure to ask for repsondents' name,
because the user ID is not recorded by default.


Web polls:

* doodle.com
* surveymonkey.com


For scheduling a meeting:

* Doodle contains iCalendar integration (for $40/year).  WhenIsGood/When2Meet does not.
* Doodle supports "if-need-be" (ifneedbe) responses.  WhenIsGood premium has this.
   When2Meet does not.  
* Doodle only permits 20 possibilities per poll.  For a weekly meeting, I had to make 5 different polls, one per day.
* Outlook supports "preferred" and "yes" (similar to "yes" and "ifneedbe", which is terminology I prefer).
* WhenIsGood/When2Meet has a nicer interface.  With Doodle, you need to create
   many 30-minute proposals even to schedule a 1-hour meeting.  Each one
   takes multiple clicks to create and to answer.  WhenIsGood/When2Meet just lets you
   quickly paint over the relevant times.
* WhenIsGood has accounts.  When2Meet does not.
* When2Meet can do days of the week, WhenIsGood does not.

(Tungle.me combined the best of both, but it is no longer supported as of
December 3, 2012.)
Other possibilities, none of which seems great

* Framadate: Not bad, but no calendar integration
* Dudle:  by default gives just by-hour; slightly clunky interface.  No calendar integration
* schedule once: has Google Calendar integration; $5+/month; not really for group meetings?
* meetomatic.com: advanced is $20/year; without that, only per-day, not per-hour, control over times
* gathergrid.com: only by hour; no calendar integration
* whenshouldwe.com: terribly basic; not acceptable
* selectthedate.com: selects a date, not among multiple times on one date


Two tips about Doodle polls:

* For a 1-hour meeting, give 30-minute timeslots.  That lets participants  communicate that they could make 1:30-2:30 but not 1-2 or 2-3.  It's especially important at UW since standard classes start on the half hour.
* Consider permitting "if-need-be" as a response.  It can give more scheduling flexibiliity.


Briticizer:  <http://us2uk.eu/>
also: <http://www.translatebritish.com/reverse.php>


If someone asks a question whose answer can be easily Googled, you can supply them a link from the "Let me Google that for you" website, such as
<http://lmgtfy.com/?q=UI+Chicago>


To save a URL to Pocket, email one link at a time, in the body of mail to
<add@getpocket.com>.


Trello is a popular task management system (a to-do list).  I don't see
what makes it compelling, though.  It doesn't support the most important
things that I want to do, such as sorting items, seeing an overview of all
the issues, integrating with my existing toolchain (version control system,
editor, etc.), working offline, etc.


Coveralls (<https://coveralls.io/>) reports test coverage.
For Java, it requires Maven.


To search for source code (in approximate order of preference):

* SearchCode
* GitHub search
* <http://code.openhub.net/> (was Koders.com; by Black Duck)


To avoid waiting on hold:
<http://www.lucyphone.com/>
<http://www.fastcustomer.co/mf>


Outsourcing companies (I have no particular reason to prefer one over the other):

* Freelancer (was vWorker)
* oDesk (Panos Ipeirotis is on sabbatical there)
* Elance
* others? TaskRabbit, Guru, TopCoder, Craigslist, rentacoder
For designs: 99designs.com, dribbble.com
Advice on hiring: <https://news.ycombinator.com/item?id=2539892> .  Key: ask
a simple domain-knowledge type question in the posting, or how they would
go about the project. Ask for references. Ask them to restate what you want,
in their own words. Do a Skype interview. Be
willing to pay (say, $50/hour instead of $25). Give a small test
project before moving forward. Hire multiple people for that first project.
Say there may be more work after the initial bit.
<http://www.keithmander.com/?p=243> says:
* Use uTest to perform QA of the code.
* Always make sure you have a clear agreement in place that spells out how owns the finished output and what the rights are for the contractor.


Creating a new Maven Central ("the Central Repository") project:
<http://central.sonatype.org/pages/ossrh-guide.html>
Example issues:
<https://issues.sonatype.org/browse/OSSRH-28628>
<https://issues.sonatype.org/browse/OSSRH-37810>


SPL (Seattle Public Library) suggestions for purchane:
<https://www.spl.org/library-collection/suggestions-for-purchase/purchase-suggestion-form-for-books-and-music-scores>


SPL (Seattle Public Library) access to Consumer Reports and more databases:
<http://www.spl.org/library-collection/articles-and-research/databases-a-z>


A tip about combining sections in Canvas.
Suppose in your Canvas Dashboard (canvas.uw.edu) you see

* multiple Canvas "courses" as CSE XXX A  Sp 18,  CSE XXX B Sp18, CSE
XXX C Sp18, each of which has multiple sections, AA, AB, BA, BB, CA, CB.
* or a cross-listed course with two "courses" CSE XXX A Sp 18 and CSEM
XXX A Sp18.

*

1. Select one of these from your Dashboard and click on it.  You are
going to use this one as the "home course" where all the other sections
are moved to.
2. Look at the URL for this page
"<https://canvas.uw.edu/courses/YYYYYYYY>" and copy the "YYYYYYYY"
number.  This is the Canvas "ID" that you will use to copy things into
this "home course".
3. On the very bottom left just to the right of the purple column click
on "Settings".  This will bring up the "Course Details" tab for that
"course".   Change the "Name" field to whatever name you that you think
covers all the sections of your course in Canvas.  (You can also change
the "Course Code" field if you want; I am not sure if it matters.   You
can't change the SIS ID but you don't need to.)
4. Now go to the Canvas Dashboard and click on one of the *other*
Canvas "courses" associated with your course.
5. On the very bottom left just to the right of the purple column click
on "Settings".  This will bring up the "Course Details" tab for that
"course" as before.
6. Click on the "Sections" tab near the top of the page to list the
sections.  This will list all sections of this *other* course.
7. Click on one of these sections, which will bring up a list of
current enrollees.   At the right side of the page then click on
"Cross-List this Section".  This will be bring up a dialog box. Enter
the Canvas ID "YYYYYYYY" number which you copied from step 2, in the ID
field of this box.   It will bring up the name of the "home course".
Then click that you accept this.  This will cause your section to jump
to the "home course" and your view will be teleported to the inside of
the "home course".
8. Go back to your Canvas Dashboard.

*

If *other* Canvas "courses" associated with your course still show up
then they still have sections that you haven't moved so go back to Step 4.
If all of their sections have been moved then the Canvas courses will
have disappeared from your Dashboard.   Do one final check via
"Settings" on your "home course" and the "Sections" tab to make sure
that everything is there.  If so, you are done!


I don't have permission to edit the calendar event (in Google Calendar).  I personally use this Chrome extension to make that the default
<https://chrome.google.com/webstore/detail/google-calendar-guests-mo/hjhicmeghjagaicbkmhmbbnibhbkcfdb?hl=en>


Charlie Garrett's perferred C++ references:
The C++ Standard Library by Josuttis
C++ Templates by Vandevoorde, Josuttis and Gregor
C++ for the Impatient by Overland


Cloud credits for research from AWS and EC2, for experiments:
<https://aws.amazon.com/research-credits/>


To import an ical file into Google Calendar:
<https://support.google.com/calendar/answer/37118?co=GENIE.Platform%3DDesktop&hl=en&oco=0>


To report a problem with the ACM Digital Library:
<dl-team@hq.acm.org>


Why shouldn't we use words such as 'here' and 'this' in textlinks?
<https://ux.stackexchange.com/questions/12100/why-shouldnt-we-use-words-such-as-here-and-this-in-textlinks>


To download files from scribd without joining:
<https://docdownloader.com/>


<http://cacycle.altervista.org/wikEd-diff-tool.html>
An online diff tool with block move highlighting.


To test a website for mobile usability issues, according to Google Search:
<https://search.google.com/test/mobile-friendly/>
To make sure your site is indexed:
<https://support.google.com/webmasters/answer/7474347>


To change the default guest permissions in Google Calendar:
In the Settings menu, click Settings.
Under General > Event Settings, choose Default guest permissions.


Anonymize a GitHub repo, for example for double-blind submission:
<https://anonymous.4open.science/>


12ft.io alternative:  <https://archive.is/>


Handwriting practice worksheets:
allkidsnetwork.com
worksheetworks.com


To report malicious/abusive Bitbucket repositories: <abuse@atlassian.com>


Gradescope for exams is well worthwhile.

You should scan the exams exam by exam. That is, staple the exam together for the students and then unstaple them for scanning without any reordering. Don't make the piles of scanned exams too big, because sometimes the students have mangled them and they will get stuck in the feeder. It is very easy to upload many separate files of scanned exams.

If your exam is one-sided (which I recommend for ease of students taking the exam and also for ease of scanning), do not under any circumstances permit students to write on the back of pages.

You will also scan, separately, a single example exam. Then you will choose, with a mouse, the area of the page that is related to each "Question". You want each Gradescope question to be as small as possible. For instance, if you have question 22 on the exam that is "select all of the following four that apply", then you almost certainly want to split it into separate Gradescope questions, each one treated like a true false question by gradescope. Don't make the tas do any mental arithmetic in their heads. I made this mistake.

There is a specific graphical format that you want to use for true false questions. It is shown on some Gradescope web pages, and I can also help you with it. For multiple choice, I think it isn't as important. That is, I think that circling a letter or filling in a Scantron style are both acceptable. I would need to double check that.

One nice thing about Gradescope grading is that it will cluster answers. For example, it will show you one example of all the students who marked question 22.B, and one example of all the students who didn't mark it. Thus, it is not necessary to look at each m exam individually. Except for written answers, that is.

One advantage of gradescope is that it reduces cheating. You have a photocopy of the exam before it was graded. Students can't change it and then come to you saying, isn't it odd how the TA marked this question as incorrect even though it is actually correct (now, in the version the student is showing you)?


ChatGPT prompting:
(I don't like ChatGPT because it tends to elide details, making writing more vague and general.  The text becomes more politic and polished, but omitting facts is bad and the rephrasing can change the meaning.)

THIS WAS SUCCESSFUL, for only correcting errors:
I have attached a text that was generated by speech-to-text.  Speech-to-text resulted in a number of errors in the document.  Please correct errors in spelling, capitalization, and grammar.  Do not paraphrase to remove details, and do not remove any paragraphs.  Please process the whole document without asking for confirmation of each portion of the document.

THIS DID NOT WORK AS I WISHED, because only part of the document was output:
Please perform light copy-editing of the attached document.  Output a slightly changed version of the entire document (not just part of the document).  Do not paraphrase: retain all content.

I HAVE NOT TRIED THIS:
I have attached a draft of feedback to writers.  Please perform light copy-editing.  Do not make major changes, and do not remove details. Process the whole document without asking for confirmation of each portion of the document.


Tailscale is a way to get a public IP address within the Allen School.


To create a favicon from text:
<https://onlinetools.com/image/generate-image-from-text>


Installing Renovate would prevent the need for pull requests like this.  To onboard Renovate, browse to <https://github.com/apps/renovate>, click "Install" or "Configure" (whichever button appears in the upper right corner), choose a GitHub org, and select specific repositories.


Pangram.com is the best AI text detector, as of 2025-11.
