#!/bin/bash
readarray -d '' array < <(find . -name "*.png" -print0)
for f in "${array[@]}"
do
    echo $f
    file_without_suffix=${f%".png"}
    echo $file_without_suffix
    converted_file="$file_without_suffix.jpeg"
    echo $converted_file
    echo "converting..."
    magick convert $f $converted_file
    echo "moving original png image to /tmp"
    mv $f /tmp
done
