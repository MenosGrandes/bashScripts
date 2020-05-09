#!/bin/bash
# USAGE
# $1 -> directory with all source to compare
# $2 -> percent of similarity to check
#
#
compare()
{
wc_j=$(wc -l < $2)
wc_diff=$(diff  --old-group-format='' --new-group-format=''   --changed-group-format='' $1 $2 | wc -l )
a=$((wc_diff*100))
percentage=$(($a/wc_i))
if [ $percentage -gt $siilarityPercent ] ; then
   echo "${1} compared with ${2} gives ${wc_diff} common lines. Which is ${percentage} % with ${1}. ${wc_j} and ${wc_i}"
   echo " "
fi
}

parentDirWithFilesToCompare=$1

siilarityPercent=$2
TEMP_DIR=$( mktemp -d )
echo $TEMP_DIR
# check if tmp dir was created
if [[ ! "$TEMP_DIR" || ! -d "$TEMP_DIR" ]]; then
      echo "Could not create temp dir"
        exit 1
fi
#copy all .asm source code into temp folder
find $parentDirWithFilesToCompare -name '*.asm' -exec cp {} --backup=t $TEMP_DIR  \;
#save current dir
jumpBackDIR=$(pwd)

cd $TEMP_DIR

#remove whitespaces from fles
for f in *\ *; do mv "$f" "${f// /_}"; done
#list all files into variable
filesToCompare=( $( ls $TEMP_DIR ) )

counter=0
for i in "${filesToCompare[@]}"
do :
    wc_i=$(wc -l < "${i}")

    for j in "${filesToCompare[@]}"
    do :
    if [ $i != $j ] ; then
        compare $i $j 2>/dev/null &
    fi
    done
    unset filesToCompare[counter]
    ((counter=counter+1))
done
