#!/bin/sh
################################################################################
#
# youtube2boot.sh
#
# DESCRIPTION: Download a YouTube video and convert it into a simple Android boot animation.
#              You need youtube-dl and ffmpeg to run this script.
#
#
# USAGE:
#
# youtube2boot.sh VIDEOID [DESTINATION]
#
#
#  VIDEOID     The video id at the end of a YouTube URL
#
#  DESTINATION The output file
#
#  Example usage: youtube2boot.sh Ynm6Vgyzah4
#

case $1 in
	-h|--help) # never done this before ༽つ۞﹏۞༼つ
		println=false; echo
		while read line; do
			case $line in 
				\#*DESCRIPTION*) println=true; echo ${line:1} ;;
				\#*) if $println; then echo ${line:1}; fi ;;
				*) break;
			esac;
		done < "$0"
		exit 0
esac

video_id=$1
destination=${2:-./${video_id}.zip}
url="https://www.youtube.com/watch?v=$video_id"
temp=./$video_id
out="$temp/out.mp4"

# Use youtube-dl to download the video
# https://github.com/rg3/youtube-dl
youtube-dl -o "$out" "$url"

# Make the directory for the frames to be extracted to
mkdir -p "$temp/part0"

# Use ffmpeg to extract frames from the video
ffmpeg -i "$out" "$temp/part0/00%05d.jpg"

size=`identify -format '%w %h' $temp/part0/0000001.jpg`

# Create the desc.txt file
echo "$size 30" > "$temp/desc.txt"
echo "p 1 0 part0" >> "$temp/desc.txt"

# Create the bootanimation
pwd=$(pwd)
cd "$temp"
zip -0r bootanimation part0 desc.txt
cd "$pwd"

echo $pwd
cp "$temp/bootanimation.zip" "$destination"

rm -rf "$temp"
