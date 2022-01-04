# Nanopolish Methylation Pipeline

This is a pipeline to call methylation using nanopolish.

## Dockerfile
To begin, pull the docker file.
```
docker pull clintonjules/nanopolish_methylation
```

Here's an example docker run.
```
docker run -it -v /nano_meth:/nano_meth -v /HG002/fast5:/fast5_files -v /genomes/hg38.fa:/reference -v /HG002/basecalled.fastq:/basecalls clintonjules/nanopolish_methylation
```

## Inputs
Example pipeline execution:
```
./pipeline.sh /fast5_files /reference /basecalls /nano_meth_output
```

The first input should be the directory containing signal-level FAST5 files.  
The second input is the chromsome reference sequence.  
The third input is the subset of the basecalled reads.  
The fourth input is your specified output directory.
