#!/bin/bash
for file in `ls *.txt -1`
do
echo "$file"
#new_csv=$(sed 's/.txt/.csv/g' $file)
#echo $new_csv
./parser.sh $file > $file.csv 
done
