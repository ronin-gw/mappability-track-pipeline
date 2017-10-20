#!/bin/zsh
#$ -S /bin/zsh -o /dev/null -e /dev/null

BASEDIR=$(dirname $0)
source $BASEDIR/config.sh

usage_exit() {
    echo "Usage: $0 Index.gem [length] [N of threads]"
    exit 1
}

if [ -z "$1" ]; then
    usage_exit
else
    NAME=${${1##*/}%.*}
fi
if [ -z "$2" ]; then
    if [ -z "$SGE_TASK_ID" ]; then
        usage_exit
    else
        LENGTH=$SGE_TASK_ID
    fi
else
    LENGTH="$2"
fi
if [ -z "$3" ]; then
    if [ -z "$NSLOTS" ]; then
        THREADS=1
    else
        THREADS=$NSLOTS
    fi
else
    THREADS=$3
fi

OUTDIR=$BASEDIR/$NAME/$LENGTH
mkdir -p $OUTDIR

$GEM_MAPPABILITY -m $MAX_MISMATCHES -T $THREADS -I $1 -o $OUTDIR/$NAME -l $LENGTH
