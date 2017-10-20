# mappability-track-pipeline
Generate mappability tracks as BigWig file from genome fasta with GEM

## Requirements
- `gem-indexer`, `gem-mappability` and `gem-2-wig` from [the GEM library](http://algorithms.cnag.cat/wiki/The_GEM_library "The GEM library").
- Python2 (>=2.6)
- `bedGraphToBigWig` from [UCSC Kent utilities](http://hgdownload.soe.ucsc.edu/downloads.html#source_downloads "UCSC Genome Browser Downloads").

## Settings
Edit `config.sh` to specify paths to the required binaries and a number of max mismatches to calculate mappability (default=2, following [UCSC mappability tracks](http://genome.ucsc.edu/cgi-bin/hgFileUi?db=hg19&g=wgEncodeMapability#TRACK_HTML "Mappability Downloadable Files")).

## wig-filter
`wig-filter.py` filters Wig variableStep tracks which have scores lower than specified score and output a Wig or bedGraph format file.  
__By default, this script passes only score=1 (uniquely mappable) regions.__

## Work with Sun/Univa Grid Engine
> `01-make-gem-index.sh`, `02-make-mappability.sh`

If a number of threads is not specified, these scripts use `NSLOTS` variable as the number of threads.
> `02-make-mappability.sh`

If a read length is not specified, this script uses `SGE_TASK_ID` variable as the read length.
