# Wisdom about Linux


On github.com, you can view the table of contents (outline) of this file by
clicking the menu icon (three lines or dots) in the top corner.  It's next to
the pencil "edit" icon and below the word "History".


## Debian


Debian installation and package maintenance with `apt`:
(IMPORTANT NOTE:
On a Linux/Debian/Ubuntu VMware guest, may need to reinstall VMware tools
after an update/upgrade that requires a reboot, lest guest has no network.)
To install a new package on debian:

```sh
  sudo apt install <package-name>
  sudo apt build-dep <package-name>
```

(and also install anything reasonable that the latter suggests).


To upgrade Ubuntu itself:
```sh
sudo apt update
sudo apt upgrade -qyy
# For a new installation, edit /etc/update-manager/release-upgrades to set "Prompt=normal"
sudo do-release-update
```


To upgrade all packages on Debian or Ubuntu (first command updates list of packages):

```sh
  sudo apt update && sudo apt -u -qyy dist-upgrade && echo "Success: upgraded"
  # Or "apt -u upgrade" to not automatically resolve dependencies, which
  # might *remove* a package -- this is better if running "Debian unstable".
```

or just

```sh
  update-manager -c
```

Download source code ("-b" auto-builds) into *current directory*:

```sh
  apt [-b] source PACKAGENAME
```

Search through the available packages to find a package name:

```sh
  apt-cache search <string>
```

Find package containing a file:

```sh
  dpkg -S stdio.h
  apt-file search FILENAME
```

List all installed packages:

```sh
  dpkg -l
```

Install from a .deb package file:

```sh
  dpkg -i filename.deb
```

More info on APT (Debian installer):

* APT HOWTO: <http://www.debian.org/doc/manuals/apt-howto/index.en.html>
* APT users guide: /usr/doc/apt/users-guide.txt.gz (isn't installed for me?)


To reboot a Linux PC:

```sh
  sudo shutdown -r now
```

To shutdown a Linux PC:

```sh
  sudo shutdown -h now
```

To reboot a Linux PC:  <kbd>Ctrl-Alt-F6</kbd> to get to a Virtual Terminal Console,
  then <kbd>Ctrl-Alt-Delete.</kbd>  When it says it's rebooting, you may power down.
To stop debian Linux, run "halt" (as root), which itself invokes "shutdown".


To upgrade your kernel you must first choose the kernel most appropriate
for your subarchitecture.  A list of kernels can be found with:

```sh
  apt-cache search ^kernel-image
```

Install as usual with

```sh
  apt install ...
```

The new kernel will be run by default after the next reboot.


"alien" converts Redhat .rpm files and Debian .deb files to .tar.gz files.
Example:

```sh
  alien *.rpm
  dpkg -i *deb
```


To create a new account under Unix or Linux:

```sh
  sudo useradd -m USERNAME -s /bin/bash
  sudo passwd USERNAME
```

To log in as that user, do:

```sh
  su - USERNAME
```

This variant is less desirable, because it leaves my environment (such as PATH)
despite changing the username:

```sh
  sudo -u USERNAME bash
```

To remove a user's account, do

```sh
  sudo userdel -r USERNAME
  # Only necessary on some systems
  (cd /var/yp; sudo make)
```

`useradd` is standard; `adduser` is a wrapper around it.


To figure out the version of Ubuntu you are running, do

```text
  System Settings >> System Information >> Overview
```

In previous versions of Ubuntu:

```text
  System >> About Ubuntu
```

From the command line:

```sh
  lsb_release -a
```

If the `lsb_release` command is not installed, run

```sh
apt update && apt -qqy install lsb-release && apt clean all && lsb_release -a
```


To determine which version of RedHat/Fedora/CentOS I am running:

```sh
  cat /etc/redhat-release
```


To find out the host address (ID) use the ifconfig command


There are many descriptions of how to create a Debian or Ubuntu package.
Most are confusing and unhelpful, failing to give high-level explanations
and too focused on long, detailed lists of commands.  The most coherent
ones I have found are:

* <http://www.debian-administration.org/articles/336> and <http://www.debian-administration.org/articles/337>
* <https://wiki.ubuntu.com/PackagingGuide/Complete>


To make the <kbd>Caps Lock</kbd> key an additional <kbd>Control/Ctrl</kbd> key under Linux:
  Keyboard Layout > Options > Ctrl key position


Debian backports (of packages not yet available on stable) can be found at
backports.org.  Instructions on how to use backports are available at:
<http://www.backports.org/dokuwiki/doku.php?id=instructions>.
To install, consider copying the .deb files
from /var/cache/apt/archives to $pag/adm/extra-debs and then intall
them elsewhere using `dpkg -i` directly.


File `/etc/debian_version` gives the version number of Debian that you are
running.  Versionnumber-to-codename correspondence:
  <http://en.wikipedia.org/wiki/Debian#Releases>
Unstable is always codenamed "sid".


## Ubuntu


Ubuntu's equivalent of /usr/bin/dict is
/usr/share/dict/american-english


## Devices


To mount a USB stick drive or CD-ROM on Ubuntu or Rocky Linux,
just insert it, and it appears under `/media/${USER}/` or `/run/media/${USER}/`.
When using a USB stick under Linux, give it plenty of time to finish
writing a file.
To eject it, first do one of these

```sh
  umount /media/${USER}/DISKNAME
  umount /run/media/${USER}/DISKNAME
```


To use a floppy under Linux, either dd or mtools is probably all you need.
(Just use the "m*" commands such as "mdir", "mcopy", etc.)
To use a CD-ROM/DVD drive under Linux, mount it.  (The same may go for ZIP
drives, but some weirdnesses apply, so use a /dev/zip link instead to get
all that right.)


A better solution for using a floppy is mtools:  use mdir, mcopy, etc.
On 7/12/2001, these commands mounted the meoptiplex zip drive:

```sh
  /sbin/modprobe ide-scsi
  mount /dev/zip /mnt/zip
```

but a configuration option will be changed to make at least the first
unnecessary.
To mount the floppy, make sure /mnt/floppy exists, then do

```sh
  mount /dev/fd0 /mnt/floppy
```

then use /mnt/floppy; to unmount,

```sh
  umount /mnt/floppy
```

(Be sure to umount before ejecting the floppy!)
To use the devices, I appear to need to be root on the local machine.  But
that root doesn't necessarily have read-access to my private files!


An Amazon Kindle plugged into Ubuntu Linux via USB has its books mounted at
/media/$USER/Kindle/documents/ (not at /mnt).


## X Windows and the display

The X Windows display server is the local machine.
The client is the machine on which the application is running.


X11 problems monitor logfile XF86Config-4:
If the X11 server doesn't start, look at the log file it creates.
The log file is:  /var/log/XFree86.0.log.  Older version of the
log file should also be present.


Resolution and/or font problems:
Sometimes the problem is simply that the display has screwed up when
it autoadjusts.  Try logging in and out.  If that doesn't work play
with the buttons on the front of the screen to make sure it is correct
(peanut currently has a 1920x1200 monitor).
To see what X thinks, use `xdpyinfo | grep -i pixel`  or
`xrandr` (with no arguments) will print out the choices.


For a list of installed fonts under Linux (X windows), run "xlsfonts".
Also see xfontsel.


Debian Linux screen resolution:
Applications >> Desktop Preferences >> Screen Resolution


X Windows initialization depends on .Xdefaults and .xsession files, among others.
(.Xdefaults, aka .Xresources, is used by xrdb.)


xmodmap:  modify keymaps in X


xlock:  screen-locking + screen-saving program


xterm windows:  use control + mouse to get VT/VT100 menus.


X fonts are in /usr/local/lib/X11/fonts, aka /usr/lib/X11/fonts, among
other places; xlsfonts lists all available X fonts.


Linux key bindings:

* <kbd>M-C-F7</kbd> = return to X session after accidentally hitting <kbd>M-C-F[26]</kbd> or some such
* <kbd>M-C-F2</kbd> = tty mode (also <kbd>M-C-F1</kbd>)
* <kbd>M-C-n,p,?</kbd> = change terminal mode (??)
* <kbd>M-C-backspace</kbd> = reset X server
* <kbd>F1</kbd> instead of enter = safe login


`editres` lets you inspect and modify X application resources.


`xwininfo` gives information about an X Window (eg size, location, etc.)


`xev`: X event tester (report to stdout all X events sent to it)


<kbd>Ctrl-Alt-"+"</kbd> and <kbd>Ctrl-Alt-"-"</kbd> switch between resolutions on debian;
and see /etc/X11/XF86Config.  Or run "anXious" to reset X configuration
parameters.
<kbd>Ctrl-Alt-Backspace</kbd> kills the X server.
To turn that off, in /etc/X11/XF86Config-4 (or /etc/X11/xorg.conf) add to "ServerLayout":
  Option "DontZap"  "true"
(Also do "man XF86Config")


<kbd>LeftAlt-Fn</kbd> switches to a new "virtual console", where <kbd>"Fn"</kbd> is <kbd>F1</kbd> for the
main one, <kbd>F3</kbd> for the third one, etc.


/usr/lib/X11/ is directory with rgb.txt, which is names of X11 colors.


Sawfish window manager themes (list of problems with them)

* brushed-metal
    slightly goofly looking window title bar
* CoolClean
    window title bar has gradient
* mono
    default blue focused window color is unreadable, can't drag border to resize
* simple
    can't drag border to resize
    doesn't have all the standard buttons at the top of the window


"xlock -mode blank" locks the screen without running a compute-intensive
screensaver.


## Red Hat Enterprise Linux (RHEL)


Red Hat Enterprise Linux or RHEL, is the most popular commercially supported Linux distribution.
Rocky Linux is downstream of Red Hat, and is nearly identical to it.
Fedora Linux is upstream of Red Hat, and tends to be more up-to-date.


There's no perfectly reliable way to determine the version of Red Hat Linux
is being run, but you can try:

```sh
  rpm -q redhat-release
  cat /etc/redhat-release  # the single file that the above package installs
```


## Everything else


Linux system messages can be found in `/var/log/messages*`.
Look at the man pages on dmesg and syslogd as well.


You can get a simple list of all of the subscribers to a mailing
list by sending mail to <list-request@lists.csail.mit.edu> and
putting 'who *password*' on a line by itself.  It will mail back
a list of subscribers.  This is not easily available via the
web interface.


To enable NFS access, edit the `/etc/exports` file on each machine.
For example, to grant access to 128.30.65.238, change the line to

```text
  /scratch        128.30.84.0/24(rw) 128.30.65.238(rw)
```

'man exports' for more detail.  After changing the file, execute

```sh
  sudo /etc/rc5.d/S20nfs-kernel-server restart
```

to reread the file.


To get a list of SSIDs of all wireless networks in range:

```sh
  sudo iwlist scan
```


To make all CUPS based printing clients spool through CSAIL servers, and
get theirs PPDs from there as well, create the file `/etc/cups/client.conf`
containing the single line:

```conf
[source]
./etc/cups/client.conf
ServerName cups.csail.mit.edu
```


If a system log file (messages, kern.log, syslog) grows too large, it
can be compress or removed (delete,rm) by the following commands:

```sh
  sudo /etc/init.d/sysklogd stop
  sudo rm /var/log/{syslog,kern.log,messages}
  sudo /etc/init.d/sysklogd start
```


I disabled ipv6 by editing /etc/modprobe.d/aliases:

```text
  -alias net-pf-10 ipv6
  +# alias net-pf-10 ipv6
  +alias net-pf-10 off
  +alias ipv6 off
```

because "dmesg" said:
  [  758.258184] eth0: no IPv6 routers present


To recompile the Debian package "foobar" from source code:

```sh
  # Install any packages needed for the compile
  sudo apt build-dep foobar
  # Download the source code
  apt source foobar
  cd foobar-1.42
  # Compile:
  debian/rules build
  # Make .deb package:
  fakeroot debian/rules binary
```

You'll then have a `foobar_1.42-12_i386.deb` file in the directory you
*started in*, which you can install with `dpkg -i`. The version of the
source that `apt` gets is controlled by the `/etc/apt/sources.list`
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

  ```gdb
      handle sigsegv nostop nopass
  ```


To check the Debian package version for a program you're running,
first find the package name with `dpkg -S`, then get information about
the installed package with `dpkg -s`. A Debian package number
generally consists of the upstream package version, then a "-", then
the Debian package version, which might reflect changes in the
packaging or extra bug fixes. For instance, suppose you're interested
in Emacs:

```sh
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

```sh
  echo $0
  ps -p $$
```


To view the launcher in Ubuntu:
  <kbd>Alt-F1</kbd>
To get the search box:
  Click the Ubuntu logo in the upper left corner, then press <kbd>ESC</kbd>


To update the date on Ubuntu Linux

```sh
date ; sudo ntpdate -s time.nist.gov ; date
```

or alternately

```sh
date ; sudo service ntp stop ; sudo ntpdate -s time.nist.gov ; sudo service ntp start ; date
date ; sudo service ntp stop ; sudo ntpd -gq ; sudo service ntp start ; date
```


bsh/csh/tsh quote arbitrary string with single quotes:
Single quotes quote anything but other single quotes.  A single quote
can be quoted by a backslash, but NOT within single quotes.  Thus, to
quote a string with single quotes, terminate the string, escape the single
quote, and start a new single quoted string.
For example, to quote: "Jeff's toy"

```sh
    'Jeff'\''s toy'
```

The replace strings are: `"'"` and `"'\\''"`.


To edit PDF on Linux or Ubuntu:

* online: <https://www.ilovepdf.com/edit-pdf> ; can insert .jpg but not .eps or .pdf files.
* online: <https://www.scanwritr.com/app/#!/gallery>
* LibreOffice (or OpenOffice) Draw
   The default file format is ODG, not PDF, so do "export (directly) as PDF".
* Foxit reader (not updated for Linux since Sep 2018, as of Dec 2023)
* Okular is designed for KDE, so installing it on Ubuntu installs hundreds of megs of KDE modules.  I should probably try it anyway.
* Gimp (only one page at a time, and converts to lossy image format)
* Online PDF editor: <http://www.pdfescape.com/>
   I couldn't get this to resize images I inserted.
* online: <https://smallpdf.com/edit-pdf> -- only one file per 7 hours or so; I don't see a way to insert an image (the "sign" feature is not what I want)
* Master PDF Editor (version 4+ only), <http://code-industry.net/masterpdfeditor/>
   Version 4 had no way to scale an image while retaining aspect ratio, but version 5 does.
   Don't use the free release of Version 5, which adds an ugly watermark to the output file.
* PDF Studio works with Ubuntu 15.04, but it's commercial software (their misleading webpage "PDF Studio 10 Free Download" means it's free to download a trial version that watermarks your documents with a huge diagonal "Qoppa Software" across its content, not that it's free to use!)
* not PDFedit (not updated since January 2014, isn't available in Ubuntu 15.04 Vivid Vervet; also based on old Qt 3 toolkit; once corrupted my file)
* not evince, it only reads


To find circular symbolic links
(to solve "Too many levels of symbolic links" error):

```sh
  find -L $HOME -mindepth 25
```

(but note that this may produce huge output, and also that it cannot be pruned).


To print a PDF document one-sided (single-sided, non-duplex):

```sh
lpr -o sides=one-sided
```

This didn't work for me at UW CSE, though.
So instead I could extract each page individually and print them all.


Here is a typical use of `tee`:

```sh
java randoop.Main arg1 arg2 2>&1 | tee stdout.txt
```


To install an RPM, do  `rpm -Uvh foo.rpm`


To update/upgrade all snaps (all snap packages) on an Ubuntu system:

```sh
sudo snap refresh
```


To resolve Ubuntu popup
"please update the application snap-store"
or
"Pending Update of Snap-Store, Close the App to Avoid Disruption"
do one of these:

```sh
sudo snap-store --quit && sudo snap refresh
sudo killall snap-store && sudo snap refresh
```


