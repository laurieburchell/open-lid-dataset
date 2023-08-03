#!/bin/bash

# author: laurie
# up/downsample all the files with temperature. For making the lid201 dataset, this assumes the input directory contains files of cleaned, deduplicated, monolingual data with one file per language and one sentence per line of file.

T=0.3
ROOT="PATH_TO_DATA/datasets/lid"  # change me to path containing datasets
IN_DIR="$ROOT/concat_datasets"  # dir containing files of clean concatenated data
OUT_DIR="$ROOT/sampled_datasets"  # dir for outputting sampled dataset
SCRIPT_DIR=`dirname -- $( readlink -f -- "$0"; )`
TTMP="$SCRIPT_DIR/ttmp"

mkdir -p $TTMP  # for storing intermediate files

echo "counting lines in all files in $IN_DIR"
COUNTOUT="$TTMP/${IN_DIR##*/}.linecounts.csv"
for file in $IN_DIR/*.gz; do
    echo "$file,`pigz -dc $file | wc -l`"
done > $COUNTOUT

# get total lines
LINETOTAL=`awk -F "," '{s+=$2} END {print s}' $COUNTOUT`
echo "There are $LINETOTAL lines in total"

echo "Calculating proportions"
PROPOUT="$TTMP/${IN_DIR##*/}.proportions.csv"
awk -v tot=$LINETOTAL -F "," '{printf "%.19f\n", ($2/tot)^0.3}' $COUNTOUT > $PROPOUT

echo "Normalising proportions"
PROPTOTAL=`awk '{s+=$1} END {print s}' $PROPOUT`
NORMOUT="$TTMP/${IN_DIR##*/}.normedprops.csv"
awk -v tot=$PROPTOTAL '{printf "%.19f\n", $1/tot}' $PROPOUT > $NORMOUT

echo "calculating number of lines to sample"
SAMPLECOUNT="$TTMP/${IN_DIR##*/}.samplecount.csv"
awk -v tot=$LINETOTAL '{printf "%.*f\n", 0, $1*tot}' $NORMOUT > $SAMPLECOUNT
SAMPLELIST="$TTMP/${IN_DIR##*/}.samplelist.csv"
cut -f1 -d"," $COUNTOUT | paste - $SAMPLECOUNT > $SAMPLELIST

echo "creating sampled files"
while read -r infile reqlen; do
    outfile="$OUT_DIR/`echo ${infile##*/} | sed 's/all/sampled/' | sed 's/.gz//'`"
    touch $outfile
    echo "building $outfile"
    pigz -dc $infile > $OUT_DIR/tmp.tsv
    # shuf and append until over needed length 
    while [[ $( wc -l $outfile | cut -f1 -d' ' ) -lt $reqlen ]]; do
        shuf $OUT_DIR/tmp.tsv >> $outfile
    done
    head -n $reqlen $outfile | pigz > $outfile.gz
    rm $outfile $OUT_DIR/tmp.tsv

done < <(cat $SAMPLELIST)

