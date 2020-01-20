# 1010BB_MultisampleVST_Gen
This is a short LUA script meant for REAPER x64 allowing one to convert a single VSTi instrument patch on a track to a series of WAV samples, which are formatted to be used on the 1010 BlackBox Desktop Performance Sampler.
Authored by: John Smith, ca 2020

***DISCLAIMER: I am not a coder by training. While it's almost surely impossible for this script to destroy your computer, inconveniences do happen...
 I am not responsible for anything that happens as a result of this script's use, bad or otherwise!***

This is a script for REAPER, written in Lua, allowing one to "sample" sounds from a
VSTi patch and convert them into Waves fairly quickly. and I made it so I could create multisampled patches for the 1010 Black Box Compact Sampler.
(This is meant to work for the BlackBox)

HOW TO USE:
1). Open new project in REAPER, have one blank track (maybe the first one?) selected
2). Go to Actions. Type in "ReaScript: Run/edit reaScript (EEL or lua)" and run the command.
3). Navigate to the folder where this script is kept, then select it.
4.) Click "Start" at the top right of Reascript Ide window. Watch it go!!!
5.)Now, with all the media items selected simply render your files by clicking File-->Render. Change "Source:" to "Selected Media Items". Uncheck the box that says "Tail."
Set your output directory, and HAVE YOUR FILE NAME BE OF THE FORMAT: "__Your name here__-0$namecount" This step is important, b/c the wildcard on the end of the file name will ensure 
that your wav files' pitches will correctly map to their destination notes on the Black Box!
6). Other recommended settings/ format stuff:
	-WAV, 24 bit PCM, 48000 Hz sample rate
	-Stereo

***IMPORTANT NOTE:***
This will create over 100 files, so make sure you set your render directory to its own dedicated folder so your desktop isn't filled with wavs.
Once it's done, just copy the files that you want to send to the blackbox (you can't use all of them) over to a separate folder, and you're good to go.

***Also, leave usesFullKbd = true !!!***

*** Finally, it is recommended that you turn off the auto-crossfading feature that happens whenver two media items are split, in order to keep the transients on our samples nice and sharp.
To do this, go into Preferences (Ctrl+P), Projects --> Media Item Defaults, then uncheck BOTH "Create automatic fade-in/fade-out for new media items, length" AND
"Overlap and crossfade items when splitting, length" ***
