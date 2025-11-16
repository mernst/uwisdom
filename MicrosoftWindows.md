# Wisdom about using Microsoft Windows on a personal computer (PC)


On github.com, you can view the table of contents of this file by clicking the
menu icon (three lines or dots) in the top corner.


## Windows Subsystem for Linux (WSL)


WSL file reading and writing:

* In WSL, access Windows files at `/mnt/c/`.
* In Windows, access Linux files for a running WSL distro at `\\wsl$\<distro_name>`.
   Never access WSL files at via `C:\Users\mernst\AppData\Local\Packages\...`!


## Microsoft Windows


<kbd>Ctrl-ESC</kbd> opens the "Start" menu.


VPN (virtual private networking) is like ssh, but for Windows.


If someone sends you ms-tnef attachments with a file named `winmail.dat`,
then ask them to:
Please

 1. open your address book
 2. look at the properties for my name
 3. ensure that "Rich Text" is *not* selected for me.  "Plain text" is better, or failing that "HTML".


To merge or split cells in a table in Microsoft Powerpoint (e.g., for a
column header that spans multiple rows):
Click "tables and borders" (icon looks like 4 squares) in the standard
toolbar to display the Tables and Borders Toolbar.


To select the Dvorak keyboard layout in Microsoft Windows:

Control Panel >> Regional & Language >> Languages >> Text services and input
languages >> Installed Services >> Keyboard >> Add >> Keyboard layout/IME


Under Microsoft Windows, if your hard drive is full, try emptying the trash
before removing applications.  And don't remove SQL, because some system
services seem to rely on it.  (It is a bug in Windows that you can remove
it in that case.)


To get a bigger font for notes in Powerpoint presentation dual-screen mode,
use the "zoom" button at the bottom of the notes, to the right of the
current time.


When a USB device is not recognized, you can try uninstalling the USB
device maanger and it will be automatically reinstalled when you plug it in
again.  Go to "Device manager", find it and uninstall it, reboot, and plug
it in again.


Samba's smbclient lets you access your NT files (at UW, Solaris, Linux,
AIX), eg:
`smbclient '\\rfilesrv1\students' -W cseresearch`


Run smbpasswd to set samba passwords (there is a separate password file for
them).


To make Samba work from certain locations, I must first edit
/etc/samba/smb.conf to add those IP addresses in the "hosts allow" section.
Also edit /etc/hosts.allow similarly.


