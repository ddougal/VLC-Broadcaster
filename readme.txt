Created by Dave Dougal v0.01 ddougal2@gmail.com

What is it?  
====================
Allows u to create channels to broadcast your media files over your personal network (no, not the internet). So u could have a movie channel that broadcasts 24/7 movies just like HBO. I set up a few music video channels, some TV channels such as IT crowd seasons 1-4, etc... The programs goal is to make it easy to set up channels and to easily change channels and see a listing of what is on the channels. I used the video mosaic so I can see what is currently on. The mosaic was just meant to get a quick view of what episode is currently playing on that channel or channels. Mosaic is set for 12 video channels. 

VLC must be installed on the PC you run the configuration on and of course on the client PC to view the media
Currently only supports Windows at this time
Assumes a client/server configuration. For example: I use a file server that has all my media files and vlc installed. I use a second computer to view the media using VLC. So VLC must be installed on both the client and server
Will work with loopback on a single computer but I have mainly tested in client/server setup


System requirements:
==============================
Windows only at this time
VLC 2.x installed on the server and client computers
Client IP. The server broadcasts to a specific computer on the network so the client IP is needed for this or use loopback for stand alone PC
WIndows firewall may prompt you to allow the connection, say yes. 
A good CPU


Configuration and Running the program
==================================
1. extract files to broadcaster folder on the PC that has all your media files which we will call the server
2. From your server computer (the computer with all the media files) Run configure.exe from the broadcaster server folder
3. Set your IP address to the client IP address of the computer u will be accessing the media from. U can leave the port as is or change it. If u change the port make sure its not a port that is used by something else so stick with the 1200 and up ports
Note on ports and channels: For each media type like TV shows, audio, misc, etc. U cant use the same range of ports and channels for each type of media. so for TV shows use port 1200 channel 1, for audio use port 1300 and channel 300, etc.......
4. After you are done with the configure program copy the client folder to your client computer and run the broadcaster program to see if it works



caveats/Troubleshooting:
==============================
--If your client computer goes to sleep or you turn off the computer and VLC server is still running it will try to find another IP address to stream to automatically which may cause problems. 
--No coding to turn off the broadcasts yet. Currently, I just end task on the VLC process. 
--Corrupted media files can cause VLC not to work at all and usually there is no warning message. Check log or messages
if u suspect a corrupted media file try dragging it to vlc and see and see if it works and check the vlc messages window
--If it's not working: I recommend turning off the firewall temporarily to see if that is the issue. 
--Check messages in VLC for errors

possible issues that I have not coded or tested for:
=============================================================
what if vlc is not installed
what if vlc installed on drive other than c. I did not code for this yet
Using the same channel numbers for different categories will not work. need to add some code to check for this


Recommendations:
=============================
recommend testing with a few media files:  so maybe add like three folders of tv shows or music and see if it works
recommend media file folder structure be set up like so but doesn't have to be: I have only tested in the following type of structure:

Start with a media folder and have a folder for each type of media you have so you could have music folder, movies folder, TV shows folder, etc
Inside the music folder you would have all the artists in a folder and inside the artists folder you would have albums folder which contains all the songs.  Like so:
media -> music -> artist -> album -> songs

For TV shows: 
media -> TV -> Red Dwarf -> Season 1 -> video files
	    -> IT crowd -> Season 1
			-> season 2  etc.....

todo:
===================
ports and channels: add code to check that the same ports or channels are not being used more than once for each media type




