#!/bin/sh
################################################################################
#
# boot2gif.sh
#
# DESCRIPTION: Convert an Android boot animation to a GIF
#              You will need ImageMagick to run this script.
#
# USAGE:
#
# boot2gif.sh FILE [OPTIONS]...
#
#  --create-gif                Creates a GIF from the boot animation ZIP archive
#                              The GIF will be created at ./animation.gif
#
#  --create-resized-gif=[SIZE] Create a GIF a resize it.
#                              The SIZE is the GIF's width in pixels
#
#  --create-thumbnail          Finds the best option for a preview/thumbnail.
#                              The image will be created at ./thumbnail.jpg
#

get_image_with_most_colors() {
	local images=$@
	local n=0
	local path="";
	for image in $images;
	do
		color_count=$(identify -format %k "$image")
		case $color_count in
			''|*[!0-9]*)
				continue ;;
			*)
				if [ $color_count -gt $n ]
				then
					n=$color_count
					path=$image
				fi
		esac
	done
	echo $path
}

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

create_thumbnail=false
create_gif=false
create_resized_gif=false
gif_size=300
file=$1

# parse args
while [[ $# > 1 ]]
do
	shift
	arg="$1"
	case $arg in
		--create-gif)
			create_gif=true
			;;
		--create-thumbnail)
			create_thumbnail=true
			;;
		--create-resized-gif=*)
			create_resized_gif=true
			gif_size="${arg#*=}"
			;;
		*) # invalid/unknown arg
	esac
done

temp=$(mktemp -d)
unzip -q -o "$file" -d "$temp"

# read the desc.txt file
desc_txt="$temp/desc.txt"
first_line=`head -n 1 $desc_txt | dos2unix`
width=`echo $first_line | awk '{print $1}'` # unused
height=`echo $first_line | awk '{print $2}'` # unused
size=`echo "${width}x${height}"` # unused
fps=`echo $first_line | awk '{print $3}'`
folders=`awk '{print $4}' $desc_txt | dos2unix`
delay=`echo "scale=2; 100/${fps}" | bc` # unused # fps = 1/(delay in seconds) = 100/(delay ticks)

# get the list of images in the correct order
files=""
for folder in $folders
do
	files=$(find "$temp/$folder/" -type f \( -iname \*.png -o -iname \*.jpg -o -iname \*.jpeg \) | sort)
	images="$images $files"
done

if $create_thumbnail
then
	thumbnail=$(get_image_with_most_colors $images)
	extension="${thumbnail##*.}"
	cp "$thumbnail" "./thumbnail.$extension"
fi

if $create_gif || $create_resized_gif
then
	convert -delay $delay -loop 0 $images ./animation.gif
fi

if $create_resized_gif
then
	echo convert ./animation.gif -resize ${gif_size}x -coalesce -layers optimize ./animation_${gif_size}w.gif
	convert ./animation.gif -resize ${gif_size}x -coalesce -layers optimize ./animation_${gif_size}w.gif
	if ! $create_gif; then rm ./animation.gif; fi
fi

# clean up
rm -rf "$temp"
