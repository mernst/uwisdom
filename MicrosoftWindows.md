Contents:



---

# VMware #

Do not switch between VMware regular and virtual console while the mouse is
moving, because the switch might occur between packets that the mouse is
sending, throwing off synchronization.

Ctrl-Alt-Space is the VMware escape:  the next key (such as Ctrl-Alt-ESC)
goes to the guest, rather than being interpreted by VMware.

In VMware, press Ctrl-Alt to take mouse/keyboard focus away from the guest.

MAC address of VMware (discovered via "/usr/sbin/arp"): 00:0C:29:C1:70:EF
Spoof MAC address under Linux:
```
  sudo /sbin/ifdown eth0
  sudo ifconfig eth0 hw ether 00:0C:29:C1:70:EF
  sudo /sbin/ifup eth0
```



---

# Microsoft Windows #

Ctrl-ESC opens the "Start" menu.

VPN (virtual private networking) is like ssh, but for Windows.

The current version of SSH wants to use an authentication
mechanism called "keyboard interactive" rather than "password".
To configure SecureCRT 3.4.8 to use this type of authentication:
  1. Select "Connect..." from the File menu. The Connect Dialog will appear.
  1. Right-click on the session and select "Properties" from the context menu. The Session Options dialog will appear.
  1. Select the "Connection" Category
  1. Select "Keyboard Interactive" as the primary authentication type.
Vandyke (the makers of secureCRT) makes a secure ftp (sftp)
implementation.  It costs money.

Questions about things I don't know how to do under Microsoft Windows:
  * how to make a soft link (to put things like tar and gzip in a single
> > directory on my path)?  Windows apparently doesn't have this capability.
  * how to bind a key to a window action (eg, bury or iconify or "raise Emacs")?

If you exited Microsoft Word without saving your file, it probably puts a file
in

> C:\Documents and Settings\jdunham\Local Settings\Temp
The file is probably something like ~WRD0012.doc
You might be able to retrieve it with a program like
> http://www.r-tt.com/RUndelete.shtml
or
> http://www.uneraser.com/undelete.htm
You can also go to your C: (or whatever) drive, and change folder options
to "Show Hidden Files" (and turn off "hide file extensions").  Then Search
for all files modified recently.

To print a chart from Excel:
> Right-click
> Chart window
> Right-click on title bar
> Print
> PSE2CS
> > If "margins bad", it didn't print.
> > Just try again; or cancel out of margins box

> use chart name for file name; send them to my home directory
To fix it up:
  1. Remove HPLJ stuff.
> 2. Fix bounding box.
> 3. Run excel-ps-to-eps.

To get rid of excel's tendency to put a white background in eps files, change
```
  %%Page: 1 1
  %%BeginPageSetup
  userdict begin /pagesave save def end mysetup concat colspRefresh : 1.000 1.000 1.000 sco 0 0 5100 6600 rf ; 
  %%EndPageSetup
```
to
```
  %%Page: 1 1
  %%BeginPageSetup
  userdict begin /pagesave save def end mysetup concat colspRefresh : 1.000 1.000 1.000 sco 0 0 0 0 rf ;
  %%EndPageSetup
```
The zeroes seem to make everyhing happy.

<a href='Hidden comment: 
% To produce Encapsulated PostScript (.eps) from Visio, pre-2007:
%  1. Select the desired elements on a page.
%  2. File >> Save As
%      * save only the selection
%      * save as Encapsulated PostScript
%  3. Edit to remove cruft before "%!PS-Adobe" or after "%%EOF".
%     Also remove any blank lines near top of file.
%  4. excel-ps-to-eps file.eps
%     (Yuriy says just ps2epsi will work here.)
% (There"s no need to use bbfig.)
'></a>

To crop whitespace while converting from PostScript to Encapsulated PostScript:
```
  ps2eps -B -C < infile.ps > outfile.eps
```
-B ignores original bounding box
-C inserts postscript code to clip white space

To get kinit and other Kerberos programs for Cygwin:
> http://people.csail.mit.edu/rahimi/csail-cygwin-krb.tgz
You have to do a separate kinit in cygwin (it
doesn't access your leash tickets).
Or, just ge tthe binaries (with instructions):
> /afs/csail.mit.edu/u/d/dalleyg/public/ssh-krb5.zip
In addition to following the directions, I had to do
> chmod +x /opt/krb5/bin/**/opt/ssh/bin/**
Also, in the directions, I had trouble with the "~" in the remote filename;
just remove "~/", and use "onion.csail.mit.edu" instead of "ted".
In Dec 2006, after all that, I am getting "preauthentication failed while
> getting initial credentials", which may indicate clock skew (?).  Anyway,
> this seems not to work for me.

To create labels in Microsoft Word using a Microsoft Excel file of adresses:
  * create a .xls (not merely .csv, though you will probably go through that format first
    * the first line of the .xls file should be column headings, or else be careful when getting addresses from that file.
  * open Microsoft Word
    * Tools >> Letters >> Mail Merge
    * Follow the instructions, but don't insert "address block" lest the first line be slightly indented.  Instead, insert fields F1 through F5 with line breaks between.

If someone sends you ms-tnef attachments with a file named winmail.dat,
then ask them to:
Please
  * open their address book
  * look at the properties for my name
  * ensure that "Rich Text" is **not** selected for me.  "Plain text" is better, or failing that "HTML".

To run a Windows program from cygwin, use $inv/scripts/java-cygwin.sh (for
javac) or $inv/scripts/cygwin-runner.pl .

This webpage explains the "unable to access jarfile" error that you may get
from attempting to run a Java program under Cygwin:
> http://www.cygwin.com/ml/cygwin/2008-01/msg00083.html

To convert PostScript created by PowerPoint to good PostScript (probably
works in general):
  1. from powerpoint, print to file.
> 2. run distiller on the resulting ".prn" file, giving a ".pdf" file.
> 3. copy the PDF over to some flavor of unix (linux works for me), and
> > run acroread on it to view it.

> 4. from acroread, print to file.  The file you get will be clean
> > postscript, which can be psnup'd.
An alternative is to use OpenOffice and its export-to-PDF feature.

To merge or split cells in a table in Microsoft Powerpoint (e.g., for a
column header that spans multiple rows):
  * Click "tables and borders" (icon looks like 4 squares) in the standard
> > toolbar to display the Tables and Borders Toolbar.

To put a shortcut on the start menu, first navigate via Windows Explorer to
one of these:
```
  C:\Documents and Settings\All Users\Start Menu\Programs .
  C:\Documents and Settings\YOURUSERNAME\Start Menu\Programs .
```

To select the Dvorak keyboard layout in Microsoft Windows:

> Control Panel >> Regional & Language >> Languages >> Text services and input languages
> >> Installed Services >> Keyboard >> Add >> Keyboard layout/IME

Under Microsoft Windows, if your hard drive is full, try emptying the trash
before removing applications.  And don't remove SQL, because some system
services seem to rely on it.  (It is a bug in Windows that you can remove
it in that case.)

Windows 7 shortcut keys:
> Again right-click on the shortcut and select Properties, Shortcut key.
> In the box below, you can set whether you want it to open in a “normal”
> > window, full screen or minimized (I believe that’s new too).

> There are no pre-assigned Ctrl-Alt-(alpha) combos that you might trample.
Nice comprehensive list of existing Windows hotkeys (including those new to
Win7, near the  bottom):
http://www.justusleeg.com/2009/10/27/hot-key-haven-for-windows-7/

To get a bigger font for notes in Powerpoint presentation dual-screen mode,
use the "zoom" button at the bottom of the notes, to the right of the
current time.

When a USB device is not recognized, you can try uninstalling the USB
device maanger and it will be automatically reinstalled when you plug it in
again.  Go to "Device manager", find it and uninstall it, reboot, and plug
it in again.