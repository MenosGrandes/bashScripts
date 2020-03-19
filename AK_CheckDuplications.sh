#!bin/bash

compare()
{
wc_j=$(wc -l < $j)
wc_diff=$(diff  --old-group-format='' --new-group-format=''   --changed-group-format='' $1 $2 | wc -l )
 a=$((wc_diff*100))
 percentage=$(($a/wc_i))
if [ $percentage -gt 50 ] ; then
   echo "${i} compared with ${j} gives ${wc_diff} common lines. Which is ${percentage} % with ${i}. ${wc_j} and ${wc_i}"
fi
}
declare -a array=( $( ls -N ) )
for i in "${array[@]}"
do : 
    wc_i=$(wc -l < $i)
    
    for j in "${array[@]}"
    do :
    if [ $i != $j ] ; then
        compare $i $j 2>/dev/null &
    fi
    done
done
