Contents:



---

# Debian #

Debian installation:  see ~/wisdom/setup/setup-debian

Documentation on installing OpenAFS and kerberos on a Debian machine:
See file ~/wisdom/debian-kerberos.mail (or just see my installation notes).

Debian installation and package maintenance with APT:
IMPORTANT NOTE:
> On a Linux/Debian/Ubuntu VMware guest, may need to reinstall VMware tools
> after an update/upgrade that requires a reboot, lest guest has no network.
To install a new package on debian:
```
  sudo apt-get install <package-name>
  sudo apt-get build-dep <package-name>
```
(and also install anything reasonable that the latter suggests).
To upgrade all packages on debian (first command updates list of packages):
```
  sudo apt-get update
  sudo apt-get -u dist-upgrade
  # Or "apt-get -u upgrade" to not automatically resolve dependencies, which
  # might *remove* a package -- this is better if running "unstable".
```
or just
```
  update-manager -c
```
Download source code ("-b" auto-builds) into **current directory**:
```
  apt-get [-b] source PACKAGENAME
```
Search through the available packages:
```
  apt-cache search <string>
```
Find package containing a file:
```
  dpkg -S stdio.h
  apt-file search FILENAME
```
List all installed packages:
```
  dpkg -l
```
Install from a .deb package file:
```
  dpkg -i filename.deb
```
More info on APT (Debian installer): $pag/adm/debian-pkgs
APT HOWTO: http://www.debian.org/doc/manuals/apt-howto/index.en.html
APT users guide: /usr/doc/apt/users-guide.txt.gz (isn't installed for me?)

To reboot a Linux PC:
```
  sudo shutdown -r now
```
To shutdown a Linux PC:
```
  sudo shutdown -h now
```
To reboot a Linux PC:  Ctrl-Alt-F6 to get to a Virtual Terminal Console,
> then Ctrl-Alt-Delete.  When it says it's rebooting, you may power down.
To stop debian Linux, run "halt" (as root), which itself invokes "shutdown".

To upgrade your kernel you must first choose the kernel most appropriate
for your subarchitecture.  A list of kernels can be found with:
```
  apt-cache search ^kernel-image
```
Install as usual with
```
  apt-get install ...
```
The new kernel will be run by default after the next reboot.

"alien" converts Redhat .rpm files and Debian .deb files to .tar.gz files.
Example:
```
  alien *.rpm
  dpkg -i *deb 
```

To create a new account under Unix or Linux:
```
  sudo useradd -m USERNAME
  sudo passwd USERNAME
```
To remove a user's account, do
```
  sudo userdel -r USERNAME
  # Only necessary on some systems
  (cd /var/yp; sudo make)
```
`useradd` is standard; `adduser` is a wrapper around it.
% After running useradd or userdel (or userdel -r), always do
%   cd /var/yp
%   sudo make



To figure out the version of Ubuntu you are running, do
> System Settings >> System Information >> Overview
In previous versions of Ubuntu:
> System >> About Ubuntu

Firefox 3.0 on etch requires gtk2-10.  A version of this exists
at: peanut:/usr/local/firefox3.0/gtk2-10/usr/lib.  To enable
printing, you must add a link from the normal spot for gtk2-10
back to the new version:
> /usr/lib/gtk-2.0/2.10.0 -> /usr/local/firefox3.0/gtk2-10/usr/lib/gtk-2.0/2.10.0/.
Your LD\_LIBRARY\_PATH must include gtk1-10.  If you put it in the firefox
script, it will get overwritten each time firefox upgrades.  But if it
is somewhere else, you won't be able to start firefox from thunderbird.

To find out the host address (id) use the ifconfig command

There are many descriptions of how to create a Debian or Ubuntu package.
Most are confusing and unhelpful, failing to give high-level explanations
and too focused on long, detailed lists of commands.  The most coherent
ones I have found are:
  * http://www.debian-administration.org/articles/336 and http://www.debian-administration.org/articles/337
  * https://wiki.ubuntu.com/PackagingGuide/Complete

To make the Caps Lock key an additional Control/Ctrl key under Linux:
> Keyboard Layout > Options > Ctrl key position



---

# Ubuntu #

It is a bug in Ubuntu 13.10 that pdflatex produces A4 output.
Editing /usr/share/texlive/texmf-dist/tex/generic/config/pdftexconfig-paper.tex does not help.
Putting this in each LaTeX file fixes the problem:
```
\pdfpagewidth=8.5 in
\pdfpageheight=11 in
```
No other workaround is known.
It seems I need to wait a while before the fix arrives in Ubuntu:
https://bugs.launchpad.net/ubuntu/+source/texlive-base/+bug/1242914

Ubuntu release names:
Ubuntu 4.10 (Warty Warthog)
Ubuntu 5.04 (Hoary Hedgehog)
Ubuntu 5.10 (Breezy Badger)
Ubuntu 6.06 LTS (Dapper Drake)
Ubuntu 6.10 (Edgy Eft)
Ubuntu 7.04 (Feisty Fawn)
Ubuntu 7.10 (Gutsy Gibbon)
Ubuntu 8.04 LTS (Hardy Heron)
Ubuntu 8.10 (Intrepid Ibex)
Ubuntu 9.04 (Jaunty Jackalope)
Ubuntu 9.10 (Karmic Koala)
Ubuntu 10.04 LTS (Lucid Lynx)
Ubuntu 10.10 (Maverick Meerkat)
Ubuntu 11.04 (Natty Narwhal)
Ubuntu 11.10 (Oneiric Ocelot)
Ubuntu 12.04 LTS (Precise Pangolin)
Ubuntu 12.10 (Quantal Quetzal)
Ubuntu 13.04 (Raring Ringtail)
Ubuntu 13.10 (Saucy Salamander)
Ubuntu 14.04 LTS (Trusty Tahr)
Ubuntu 14.10 (Utopic Unicorn)



---

# Devices #

When using a USB stick under Linux, give it plenty of time to finish
writing a file.
To mount a USB stick drive or CD-ROM on Ubuntu:
> Just insert it, and it appears under /run/media/${USER}/ or /media
To eject it, first do
> umount /run/media/${USER}/DISKNAME
> umount /media/DISKNAME

To use a floppy under Linux, either dd or mtools is probably all you need.
(Just use the "m**" commands such as "mdir", "mcopy", etc.)
To use a CD-ROM/DVD drive under Linux, mount it.  (The same may go for ZIP
drives, but some weirdnesses apply, so use a /dev/zip link instead to get
all that right.)**

A better solution for using a floppy is mtools:  use mdir, mcopy, etc.
On 7/12/2001, these commands mounted the meoptiplex zip drive:
```
  /sbin/modprobe ide-scsi
  mount /dev/zip /mnt/zip
```
but a configuration option will be changed to make at least the first
unnecessary.
To mount the floppy, make sure /mnt/floppy exists, then do
```
  mount /dev/fd0 /mnt/floppy
```
then use /mnt/floppy; to unmount,
```
  umount /mnt/floppy
```
(Be sure to umount before ejecting the floppy!)
To use the devices, I appear to need to be root on the local machine.  But
that root doesn't necessarily have read-access to my private files!

When an Amazon Kindle is plugged into Ubuntu Linux, it is mounted not at
/mnt but at /media/${HOME}/Kindle .



---

# Everything else #

SSH timeouts seem to be controlled in a variety of ways.  The
file /etc/ssh/sshd\_config contains a number of setups.  It
was suggested to set KeepAlive (possibly TCPKeepAlive) to
avoid the firewall dropping an inactive connection.  Also
ClientAliveInterval which causes the daemon to periodically
poll the client to see if it is still alive.

DMA settings on the hard disks make a significant (10X) difference
in performance.  The command '/sbin/hdparm /dev/hda' will (on most
machines, those with IDE disks) show whether or not DMA is
turned on.  '/sbin/hdparm -d 1 /dev/hda' will turn DMA on.  This
may cause a hang/crash if done while the disk is being used.

Linux system messages can be found in /var/log/messages**Look at the man pages on dmesg and syslogd as well.**

You can get a simple list of all of the subscribers to a mailing
list by sending mail to _list_-request@lists.csail.mit.edu and
putting 'who _password_' on a line by itself.  It will mail back
a list of subscribers.  This is not easily available via the
web interface.

To enable NFS access, edit the /etc/exports file on each machine.
For example, to grant access to 128.30.65.238, change the line to
```
  /scratch        128.30.84.0/24(rw) 128.30.65.238(rw)
```
'man exports' for more detail.  After changing the file, execute
```
  sudo /etc/rc5.d/S20nfs-kernel-server restart
```
to reread the file.

Debian backports (of packages not yet available on stable) can be found at
backports.org.  Instructions on how to use backports are available at:
http://www.backports.org/dokuwiki/doku.php?id=instructions.  If you
want to install on all pag machines, consider copying the .deb files
from /var/cache/apt/archives to $pag/adm/extra-debs and then intall
them elsewhere using 'dpkg -i' directly.  This needs to be done separately
for the 64 bit package.

To get a list of SSIDs of all wireless networks in range:
```
  sudo iwlist scan
```

To make all CUPS based printing clients spool through CSAIL servers, and
get theirs PPDs from there as well, create the file /etc/cups/client.conf
containing the single line:
ServerName cups.csail.mit.edu

If a system log file (messages, kern.log, syslog) grows too large, it
can be compress or removed (delete,rm) by the following commands:
```
  sudo /etc/init.d/sysklogd stop
  sudo rm /var/log/{syslog,kern.log,messages}
  sudo /etc/init.d/sysklogd start
```

File /etc/debian\_version gives the version number of Debian that you are
running.  Versionnumber-to-codename correspondence:
> http://en.wikipedia.org/wiki/Debian#Releases
```
  4.0 = Etch (released April 2007)
  5.0 = Lenny (released Feb 2009)
  unstable is always codenamed "sid"
```
As of 4/2010:
> stable = lenny (5.0)
> testing = squeeze (6.0)

I disabled ipv6 by editing /etc/modprobe.d/aliases:
```
  -alias net-pf-10 ipv6
  +# alias net-pf-10 ipv6
  +alias net-pf-10 off
  +alias ipv6 off
```
because "dmesg" said:
> [758.258184](.md) eth0: no IPv6 routers present

To recompile the Debian package "foobar" from source code:
```
  # Install any packages needed for the compile
  sudo apt-get build-dep foobar
  # Download the source code
  apt-get source foobar
  cd foobar-1.42
  # Compile:
  debian/rules build
  # Make .deb package:
  fakeroot debian/rules binary
```
You'll then have a foobar\_1.42-12\_i386.deb file in the directory you
**started in**, which you can install with "dpkg -i". The version of the
source that apt-get gets is controlled by the /etc/apt/sources.list
file.  You can often "backport" an updated package from a newer
release to an older release by fetching the newer source and compiling
it on a machine running the older release. This tends to work well for
small, slowly changing, and optional packages, and not so well for
ones that are large or have a lot of dependencies.

Segmentation faults or memory errors reported by glibc's malloc/free
generally represent a serious bug in a program that needs to be
fixed. But what if you just want the program to keep running so you
can get your real work done? Depending on the failure, one or more of
the following might allow execution to continue:
  * Run the program under valgrind (Memcheck)
  * Run with the environment variable `MALLOC_CHECK_` (note trailing underscore) set to 0
  * Run the program under gdb, and give gdb the command
```
    handle sigsegv nostop nopass
```

To check the Debian package version for a program you're running,
first find the package name with "dpkg -S", then get information about
the installed package with "dpkg -s". A Debian package number
generally consists of the upstream package version, then a "-", then
the Debian package version, which might reflect changes in the
packaging or extra bug fixes. For instance, suppose you're interested
in Emacs:
```
  > readlink -f `which emacs`
  /usr/bin/emacs21-x
  > dpkg -S /usr/bin/emacs21-x
  emacs21
  > dpkg -s emacs21 | fgrep Version:
  Version: 21.4a+1-3etch1
  # For comparison:
  > emacs --version | head +1
  GNU Emacs 21.4.1
```

To determine which shell you are running, do one of these:
```
  echo $0
  ps -p $$
```

For a list of installed fonts under Linux (X windows), run "xlsfonts".
Also see xfontsel.

The X Windows display server is the local machine.
The client is the machine on which the application is running.

To view the launcher in Ubuntu:
> Alt-F1
To get the search box:
> Click the Ubuntu logo in the upper left corner, then press ESC

To update the date on Ubuntu Linux:
> date ; sudo ntpdate -s time.nist.gov ; date
or alternately:
> date ; sudo service ntp stop ; sudo ntpdate -s time.nist.gov ; sudo service ntp start ; date
> date ; sudo service ntp stop ; sudo ntpd -gq ; sudo service ntp start ; date



---

# long entries below #

>entry bsh/csh/tsh quote arbitrary string with single quotes

> Single quotes quote anything but other single quotes.  A single quote
> can be quoted by a backslash, but NOT within single quotes.  Thus, to
> quote a string with single quotes, terminate the string, escape the single
> quote, and start a new single quoted string.

> For example, to quote: Jeff's toy

> 'Jeff'\''s toy'

> The replace strings are: "'" and "'\\''"

>entry changing display

> get-edid and parse-edid programs will get information about
> a monitor.  Execute

> sudo get-edid | parse-edid

> to get a section that can be plugged into the /etc/X11/XF86Config-4
> file.  Add the new resolution (if necessary) onto the appropriate
> mode lines and change the 'Monitor' setting under 'Screen' to point
> to the new Monitor entry.

> The X server needs to be restarted to do this.  Use
> ctrl-alt-backspace while the login box is displayed to
> reset the server

>entry X11 problems monitor logfile XF86Config-4

> If the X11 server doesn't start, look at the log file it creates.
> The log file is:  /var/log/XFree86.0.log.  Older version of the
> log file should also be present.

>entry resolution and/or font problems

> Sometimes the problem is simply that the display has screwed up when
> it autoadjusts.  Try logging in and out.  If that doesn't work play
> with the buttons on the front of the screen to make sure it is correct
> (peanut currently has a 1920x1200 monitor).

> To see what X thinks, use xdpyinfo | grep -i pixel  or
> xrandr (with no arguments) will print out the choices.

>entry fonts on debian

> Most fonts under kde are controlled from the kde control panel (available
> on the panel or through the K)

> Some fonts, however, are controlled by the gnome font chooser.  This
> is gnome-font-properties.  In particular the mozilla menus and text outside
> of browser pages/mail are controlled by the application font choice here.
> A good choice seems to be Aria 9, but others are good as well.

> Note that under Lenny, there is no longer a gnome-font-properties.  There
> is a gnome-control-center which has similar capabilities.  But, it
> relies on the gnome-settings-daemon which I can't get to run under
> KDE.  I did find that you can edit the file .gtkrc-2.0 with the
> following lines:

> gtk-icon-theme-name = "Human"
> gtk-theme-name = "Human"
> gtk-font-name = "Arial 9"
> style "font"
> {
> font\_name = "Tahoma 8"
> }
> widget\_class **" style "font"**

> I think the critical line is gtk-font-name.  Creating this file does
> seem to control the gtk fonts

> Jeff likes the following fonts in gnome-font-properties:

> Application font:     Arial 9
> Document font:        Sans 10
> Desktop font:         URW Palladio L Roman 10
> Windows Title Font:   Sans Bold 10
> Fixed width font:     MiscFixedSC613

> Newer applications use truetype or postscript fonts.  These are the
> only ones that will show up in their lists.  Older applications (emacs,
> xterm, etc) use standard X fonts and -fixed still seems to be an excellent
> choice.  If you need a good monospace font that is truetype use
> MiscFixedSC613 which is very smilar to the old fixed font.  As of
> the new release of Debian (9/2007), the 'neep' font seems pretty
> good for a fixed width font, it you don't want to install special
> fonts (instruction to do so are below).

> Some information from David:

> debian boxes by default run KDE.  Also, by default, the gnome desktop
> is rather broken, with the window list unoperational.  So, KDE seems
> a fine choice as a desktop.  However, there are several problems:

  1. Eclipse looks bad under KDE: Among other problems, there is no
> > highlighting in context menus, making keyboard-only operations
> > painful.

> 2) Eclipse chooses huge fonts for UI elements, under KDE and Gnome.
> 3) Even if you could get fonts normal-sized, the available TrueType fonts
> > under Linux are severely restricted


> 4) Apps started under KDE do not inherit your environment from
> > .bashrc (or whatever).  If you run, for example, TeX under
> > Emacs, this is annoying.


> Depending on your preferences, these might not all feel like problems.

> Here, then, is my setup:

  1. I have the following in my .xsession:

  1. /bin/bash
> source ~/.bashrc
> startkde

> 2) At the login screen, I set my session type to Default.  This
> > will invoke the .xsession, which will set my environment
> > variables, and then start KDE.


> 3) I executed the following command:

> ln -s /usr/bin/gnome-settings-daemon ~/.kde/Autostart/

> This lets Gnome take over font selection and UI elements.

> 4) I added some better fonts.  If you copy over from turnip
> > /usr/share/fonts/truetype/msttcorefonts/**,
> > /etc/defoma/hints/tahoma.hints, and
> > /etc/defoma/hints/msttcorefonts.hints, then you can install the
> > fonts with**


> defoma-font register-all /etc/defoma/hints/tahoma.hints
> defoma-font register-all /etc/defoma/hints/msttcorefonts.hints

> 5) I selected the fonts I wanted.  This requires settings in several
> > places:
> > a) The KDE control panel
> > b) The Gnome control panel: /usr/bin/gnome-font-properties
> > c) Eclipse's internal fonts: Window > Preferences > Colors and Fonts


> My personal favorites are Tahoma for UI elements, and 6x13 for
> monotype text, but your mileage may vary.  I strongly recommend, when
> using gnome-font-properties, that you go into the Details... pane and
> select Full Hinting.  Other settings are up to you.

> Share and Enjoy,

> David Saff

>entry Berkeley DB database

> The Berkeley DB is a simple hash or B tree database that correlates
> keys and values.  It can be saved in a file.  There are many versions
> of the database.  The following describes some of it.

> We have a number of different versions installed.  The utilities are
> named with their version number.  For example we have db\_dump, db3\_dump,
> db4.2\_dump, db\_dump185.  The 4.2 versions are used by perl.  The
> documentation for the 4.2 versions are at
> /usr/share/doc/db4.2-doc/utility/**.html**

> Oh boy.  Welcome to the world of pain that is Berkeley DB.

> We have the API changes (1.85, 2, 3.0, 3.1, 3.2, 3.3, 4.0, 4.1, ...)
> Then there are the on-disc database format versions

> 4.1 changed:
> > Btree/Recno: version 8 to version 9
> > Hash: version 7 to version 8
> > Queue: version 3 to version 4

> 4.0 changed the on-disc log format
> 3.3 did not change any on-disc formats.
> 3.2 changed:
> > Queue: version 2 to version 3

> 3.1 changed:
> > Btree/Recno: version 7 to version 8
> > Hash: version 6 to version 7.

> 3.0 changed:
> > Btree/Recno: version 6 to version 7
> > Hash: version 5 to version 6.


> (fwiw, Debian's db3 is db3.2.  other distributions vary.)

> So far, all versions of Berkeley DB support the 1.85 interface.
> However none, that I'm aware of, support the previous version's
> interfaces.  There's some hope since db4.1's on-disc formats are
> backwards-compatible with 4.0's, and do not require upgrades.

> There's no tool to _downgrade_ a db to an older version so going
> backwards is kind of hard.

> Changing what version of DB you use is a major pain.

> > I'm in the middle of building an application that uses BerkeleyDB but
> > I'd prefer to use a newer version, and I'd prefer to use
> > libberkeley-db-perl under mod\_perl ... but that's impossible, since
> > Apache (and its whole dependency tree) are linked against libdb2.

> Trust me, I don't like it any more than you do.

> > It's clear that libdb3 is handy, since there are 315 packages that
> > Depend: on it.  Thank heavens libdb4 hasn't made it in yet (altho
> > -utils has),  or it'd be worse ...

> both libdb4.0 and libdb4.1 are in sid.

>entry installing vmware workstation tools on a linux guest

In version 6.0 and above of vmware workstation, the installation
is supposed to occur automatically when you choose 'install vmware
tools' from the VM menu.  However, that does not seem to work.
Follow the instructions for release 5.5 at:

> http://www.vmware.com/support/ws55/doc/ws_newguest_tools_linux.html

>entry Installing VMWare 6.0 on linux

0. If you have a previous version installed, uninstall it with
> the vmware-uninstall.pl script.  That script is usually
> found in /usr/vmware/bin, or the original vmware-distrib/bin
> directory.

1. Get the download from tig.  It is available on TIGs list of
> of software (https://tig.csail.mit.edu/software/) or directly
> at: https://tig.csail.mit.edu/software/software_title/show/87.

2. Untar the distribution

> tar -xvzf VMware-workstation-6.0.0-45731.i386.tar.gz

3. Run "cd vmware-distrib; sudo ./vmware-install.pl":

  * Choose to install in /usr/vmware.
  * You will need to build a module for your kernel. When it asks for
> > the location of your kernel include files, on a 32 bit machine say:


> /var/autofs/net/peanut/scratch2/jhp/vmware6/linux-source-2.6.18.8-csail-32/include
> on a 64 bit machine say:

> /var/autofs/net/peanut/scratch2/jhp/vmware6/linux-source-2.6.18.8-csail-64/include

4. Now, you can say /usr/vmware/bin/vmware to start VMware.

5. You'll need a license key (serial number) to actually do
> anything. You can get a 30-day evaluation for free from VMware's
> web site in return for agreeing to receive spam, or you can request
> a permanent key from TIG (from the same place where you downloaded
> the software).

The include directory in step 3 is generated as follows.  Note that
the name specified in the append-to-version switch of the make-kpkg
command must match the csail name you see in 'uname -rv'.

> tar xvjf /usr/src/linux-source-2.6.18.8-csail.tar.bz2
> cd linux-source-2.6.18.8-csail/
> copy /boot/config-2.6.18.8-csail .config
> make-kpkg --append-to-version=-csail configure
> make scripts

[from smcc, updated for 6.0 by jhp on Sept 26 2007](Instruction.md)

>entry Installing windows and other setup in VMWare

> - You can install windows from an ISO disk image.  The image is available
> > on the TIG software page.  From vmware, select
> > vm->removable-devices->cd-rom->edit and then attach the CD to the
> > image.  Don't use a dell re-install disk or the like.  The license key
> > from TIG will not work with it.


> - Install vmware tools.  This vastly improves performance that mouse
> > operation.  From the VMware menu, choose vm->install-vmware-tools.


> - Get the MIT certificates into your new windows browser.  First
> > download the certificate that identifes MIT.  Then import your
> > identification certificate.  This is done from tools->internet-options.
> > On that page choose 'Content'.  Under 'Certificates' you can import
> > certificates.  I also found that I had to click on the 'advanced'
> > button on that page and select 'client authentication' which wasn't
> > initially selected.


> Export your certificates from Mozilla from edit->preferences.  Then
> expand 'Privacy & Security'->certificates.  Under 'Manage Certificates'
> you can export/backup a certificate.

> - Install MicroSoft office.  This is available from TIG as a download.

> - Install Visual Studio C++ version 6.0.  The ID number is:

> 335-3353356

> - Install cygwin.  See http://www.cygwin.com for more info.  Basically
> > download and run setup.exe (which is referenced on that page).
