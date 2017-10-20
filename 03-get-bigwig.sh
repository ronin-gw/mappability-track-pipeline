#!/bin/zsh
#$ -S /bin/zsh -pe def_slot 2

BASEDIR=$(dirname $0)
source $BASEDIR/config.sh

usage_exit() {
    echo "Usage: $0 Index.gem Map.mappability"
    exit 1
}

if [ -z "$1" ]; then
    usage_exit
else
    INDEX="$1"
fi
if [ -z "$2" ]; then
    usage_exit
else
    MAPPABILITY="$2"
    OUTPUT=${2%mappability}bigwig
    TEMPNAME=${2%.mappability}_temp
fi

# mappability to bedGraph
mkfifo $TEMPNAME.wig
($PYTHON $BASEDIR/wig-filter.py --bedgraph $TEMPNAME.wig > $TEMPNAME.filtered.bedGraph) &
$GEM_2_WIG -I $INDEX -i $MAPPABILITY -o $TEMPNAME

# sort chrom names (position is already sorted)
if [ -e $TEMPNAME.sorted.bedGraph ]; then
    rm $TEMPNAME.sorted.bedGraph
fi
for chrom in $(cut -f 1 $TEMPNAME.sizes | sort); do
    grep "$chrom	" $TEMPNAME.filtered.bedGraph >> $TEMPNAME.sorted.bedGraph
done

# bedGraph to BigWig
$BEDGRAPH2BIGWIG $TEMPNAME.sorted.bedGraph $TEMPNAME.sizes $OUTPUT

# clean up
rm $TEMPNAME.wig $TEMPNAME.filtered.bedGraph $TEMPNAME.sorted.bedGraph $TEMPNAME.sizes
