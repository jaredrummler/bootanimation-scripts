# bootanimation-scripts
Create GIFs from Android boot animations | Convert YouTube videos to boot animations

![TEST GIF](test/animation.gif "Boot Animation")

# boot2gif.sh

DESCRIPTION: Convert an Android boot animation to a GIF
You will need ImageMagick to run this script.

USAGE:

boot2gif.sh FILE [OPTIONS]...

--create-gif Creates a GIF from the boot animation ZIP archive
The GIF will be created at ./animation.gif

--create-resized-gif=[SIZE] Create a GIF a resize it.
The SIZE is the GIF's width in pixels

--create-thumbnail Finds the best option for a preview/thumbnail.
The image will be created at ./thumbnail.jpg

# youtube2boot.sh

DESCRIPTION: Download a YouTube video and convert it into a simple Android boot animation.
You need youtube-dl and ffmpeg to run this script.


USAGE:

youtube2boot.sh VIDEOID [DESTINATION]


VIDEOID The video id at the end of a YouTube URL

DESTINATION The output file

Example usage: youtube2boot.sh Ynm6Vgyzah4

