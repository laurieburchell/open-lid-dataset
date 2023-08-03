#!/bin/bash

# author: laurie
# cleans (already fairly OK) monolingual data and adds it to a training data tsv file
# usage: bash clean_monolingual.sh INFILE COL LANG SOURCE

# contains links to moses perl scripts
TOOLS="tools"

if [ $# -ne 4 ]; then
    echo "usage is $0 INFILE TEXT_COL LANG_CODE SOURCE"
    exit 1
fi

INFILE=$1
COL=$2
LANG_CODE=$3
SOURCE=$4

# some langs have short codes for perl
L="en"
case ${LANG_CODE%_*} in 
    "asm")
        L="as";;
    "ben")
        L="bn";;
    "cat")
        L="ca";;
    "ces")
        L="cs";;
    "deu")
        L="de";;
    "eng")
        L="en";;
    "spa")
        L="es";;
    "est")
        L="et";;
    "fin")
        L="fi";;
    "fra")
        L="fr";;
    "gle")
        L="ga";;
    "guj")
        L="gu";;
    "hin")
        L="hi";;
    "hun")
        L="hu";;
    "isl")
        L="is";;
    "ita")
        L="it";;
    "kan")
        L="kn";;
    "lit")
        L="lt";;
    "lvs")
        L="lv";;
    "mal")
        L="ml";;
    "mni")
        L="mni";;
    "mar")
        L="mr";;
    "nld")
        L="nl";;
    "ory")
        L="or";;
    "pan")
        L="pa";;
    "pol")
        L="pl";;
    "por")
        L="pt";;
    "ron")
        L="ro";;
    "rus")
        L="ru";;
    "slk")
        L="sk";;
    "slv")
        L="sl";;
    "swe")
        L="sv";;
    "tam")
        L="ta";;
    "tel")
        L="te";;
    "yue")
        L="yue";;
    "zho")
        L="zh";;
esac
echo "long code is $LANG_CODE; short code is $L (for perl scripts)"

# put output in same dir as input
OUTDIR=$(cd `dirname $INFILE` && pwd)
PREFILTER="$OUTDIR/prefilter.$SOURCE.$LANG_CODE.tsv.gz"
OUTFILE="$OUTDIR/cleaned.$SOURCE.$LANG_CODE.tsv.gz"

echo "cleaning $INFILE"
pigz -dc $INFILE | cut -f$COL \
    | parallel --no-notice --pipe -k -j16 --block 50M \
    "perl $TOOLS/remove-non-printing-char.perl | perl $TOOLS/detokenizer.perl -l $L | perl $TOOLS/split-sentences.perl -l $L -k" \
    | LC_ALL=C sort -u --parallel=16 | pigz > $PREFILTER

echo "filtering based on script"
case ${LANG_CODE#*_} in
    "Arab")
        SCRIPT="Arabic";;
    "Armn")
        SCRIPT="Armenian";;
    "Beng")
        SCRIPT="Bengali";;
    "Cyrl")
        SCRIPT="Cyrillic";;
    "Deva")
        SCRIPT="Devanagari";;
    "Ethi")
        SCRIPT="Ethiopic";;
    "Geor")
        SCRIPT="Georgian";;
    "Grek")
        SCRIPT="Greek";;
    "Gujr")
        SCRIPT="Gujarati";;
    "Guru")
        SCRIPT="Gurmukhi";;
    "Hang")
        SCRIPT="Hangul";;
    "Hans"|"Hant")
        SCRIPT="Han";;
    "Hebr")
        SCRIPT="Hebrew";;
    "Jpan")
        SCRIPT="Japanese";;
    "Khmr")
        SCRIPT="Khmer";;
    "Knda")
        SCRIPT="Kannada";;
    "Laoo")
        SCRIPT="Lao";;
    "Latn")
        SCRIPT="Latin";;
    "Mlym")
        SCRIPT="Malayalam";;
    "Mymr")
        SCRIPT="Myanmar";;
    "Orya")
        SCRIPT="Oriya";;
    "Sinh")
        SCRIPT="Sinhala";;
    "Taml")
        SCRIPT="Tamil";;
    "Telu")
        SCRIPT="Telugu";;
    "Tfng")
        SCRIPT="Tifinagh";;
    "Thai")
        SCRIPT="Thai";;
    "Tibt")
        SCRIPT="Tibetan";;
esac

echo "$SCRIPT"

# japanese uses three scripts so I'm not running a filter
if [[ $SCRIPT != "Japanese" ]]; then
    # check each line contains at least one character in the right script
    pigz -dc $PREFILTER | grep -P "\p{$SCRIPT}+" \
        | sed "s/$/\t${LANG_CODE}\t${SOURCE}/" | pigz > $OUTFILE 
else
    pigz -dc $PREFILTER | grep -P "(\p{Hiragana}|\p{Katakana}|\p{Han})+" \
        | sed "s/$/\t${LANG_CODE}\t${SOURCE}/" | pigz > $OUTFILE
fi

