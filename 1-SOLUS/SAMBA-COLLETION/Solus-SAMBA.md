 Samba tutorial for those needing it

This is another case of me wasting far too much time trying to get this working for me to not document it for anyone and everyone to use later. Today I'll be covering how to utilize Samba with a Solus OS system. I'll first be showing how you can share files from your Solus PC to a Windows PC, and then in the second part I'll show you how to share Windows files with a Solus PC. This tutorial assumes that you have file sharing enabled on your Windows PC (Which can be done from the Network and Sharing Center under Advanced Sharing Settings) and that both the systems you want to share files between are fully up-to-date.

Solus to Windows Share

The first thing you'll need to do is install your version of Solus' File Explorer Sharing package. For Budgie this will be nautilus-share, KDE will use kdenetwork-filesharing, and Mate will use caja-share. Search for these through the Software Center or install them via the terminal like the example below:

sudo eopkg it nautilus-share

You'll next need to start and enable the Samba service so that it activates at startup without your explicit command, like so:

sudo systemctl start smb
sudo systemctl enable --now smb

You'll also need to activate and enable at startup the Web Services Discovery Protocol to advertise your forthcoming shares to the local network:

sudo systemctl start wsdd
sudo systemctl enable --now wsdd

You'll next need to add a username and password for a person to utilize with your Samba share. Assuming this is just two of your personal systems you can just utilize your user account name. Just for example's sake, I'll use 'tom.' Please take note that you can't use capital letters, periods, underscores, plus, or minus signs for your username.

sudo useradd tom
sudo smbpasswd -a tom

Just to cover our bases and make sure that everything will be working now that we've entered these commands, let's restart our Samba server.

sudo systemctl restart smb

At this point, your Solus OS should be able to be discovered by a Windows PC. You'll also be able to share any folder within your Home folder simply by Right-Clicking on the folder of your choice and selecting "Sharing Options" and checkmarking that you wish to share the folder. You'll also be able to decide if you want others to have Read/Write permissions for that folder, and whether others can use guest access via Samba for that folder, meaning they don't need a username or password for that folder.

Let's say however that you have multiple hard drives in your system, or you want to share something that's not in your Home folder. You can either manually create a share with specific permissions one by one, or you can make it so that any folder you wish to share can be done with Right-Click; "Sharing Options."

In the case of the first option, open your text editor at /etc/samba/smb.conf with sudo permissions. Ex:

sudo gedit /etc/samba/smb.conf

Let's say that I have a HDD with videos on it that I want to share.

[Videos]
path = /mnt/HDD/Videos
available = yes
valid users = tom
read only = yes
browsable = yes
public = yes
writable = no

With the above Samba entry the only user who can access this is tom, and the contents of the share can be read but not written to. Save and exit your text editor then restart your Samba service with

sudo systemctl restart smb 

again. The manually added share should be available on your Windows PC now.

If you want to simply share folders via GUI from anywhere, type in the following and add the second part to smb.conf:

sudo gedit /etc/samba/smb.conf

usershare owner only = false

Save and exit your text editor, and restart your Samba service:

sudo systemctl restart smb

Now you can share from any hard drive and folder on your Solus machine!

Solus' implementation of Samba is unusual. While most distros would have their Samba rules present in /etc/samba/smb.conf, no such file exists to start with in Solus. Instead, Solus has a standardized profile for creating shares that make it possible to do the easy GUI sharing that we've just enabled universally, and it is present in /usr/share/defaults/samba/smb.conf. The smb.conf in this folder has a rule in it stating that any customizations made in /etc/samba/smb.conf override everything else present in that location. This means that these customizations are preserved when Samba rolls out an update and don't need to be reapplied. Consequently, this also means that manually added shares in /etc/samba/smb.conf override any behavior or shares created via GUI. If you were to GUI share a folder, then manually create the same share, only to then remove the share via GUI, the manual share would win out and still be present.

Windows to Solus Share

Say you have a NAS running Windows and want to share your files easily with your Solus PC. As mentioned initially, make sure that file sharing and network discovery are enabled in your Network and Sharing Center on the Windows PC. Open File Explorer now, and navigate to whichever folder you wish to share. Right-Click it, and Select Properties. Once in the Properties Pop-Up, go the Sharing tab, and click the Share button.

In the window that appears you should have the option to select a group or user you wish to share the folder as (Administrator, your username, Everyone, or you can create a new unique user.) Once you have determined who you want to share the folder as, go the Security tab of Properties, and you can edit the level of permissions you want this share to have, whether read-only, read/write, or full access. If at any point you wish to stop sharing a folder, Go to the Sharing Tab of the folder's Properties, and click on Advanced Sharing. Uncheck the button allowing the sharing off the folder, and it will no longer be shared.

Our final step in your Windows machine will be finding out it's IP address. Go run cmd.exe with administrative permission, and type in ipconfig. Take note of the IPv4 Address of your machine's network interface.

We'll now go to Solus machine to finalize the share. In Nautilus, Click on the section called "Network Locations." In the "Connect to Server" box, type smb://IPv4 of Windows PC/ and press Connect. Your shared folder should now be present and available for you to use. Click the Down arrow on the Right Side of the "Connect to Server" box, and your previous connection is ready to be accessed again in the future when you need it.

If anyone runs into any trouble or has any pointers they'd like to make to streamline this process, please don't hesitate to comment and let me know, and I'll add it to these instructions here.
