#!/bin/zsh
#$ -S /bin/zsh

BASEDIR=$(dirname $0)
source $BASEDIR/config.sh

usage_exit() {
    echo "Usage: $0 genome_FASTA [N of threads]"
    exit 1
}

if [ -z "$1" ]; then
    usage_exit
else
    FASTA="$1"
    NAME=${${FASTA##*/}%.*}
fi

if [ -z "$2" ]; then
    if [ -z "$NSLOTS" ]; then
        THREADS=1
    else
        THREADS=$NSLOTS
    fi
else
    THREADS=$2
fi

OUTDIR=$BASEDIR/$NAME
mkdir -p $OUTDIR
$GEM_INDEXER -i $FASTA -o $OUTDIR/$NAME -T $THREADS
