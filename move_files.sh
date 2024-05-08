#!/bin/bash

datadir="IDDAW/train/RAIN/"
cd $datadir
# loop through directory names from 0 to 46
for i in {185..202}
do
    src_dir="gtSeg/$i"
    dest_dir="csTrainIds/$i"

    # check if source directory exists
    if [ -d "$src_dir" ]
    then
        # create destination directory if it doesn't exist
        if [ ! -d "$dest_dir" ]
        then
            mkdir "$dest_dir"
        fi

        # move files from source to destination directory
        for file in "$src_dir"/*csTrainIds.png*
        do
            mv "$file" "$dest_dir"/
        done
    fi
done
