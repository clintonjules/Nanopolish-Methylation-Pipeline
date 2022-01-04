#!/bin/bash
set -e
set -u
set -o pipefail

# User input path variables
# A directory containing signal-level FAST5 files
fast5_path="$1"
# The chromsome 20 reference sequence
ref_path="$2"
# The subset of the basecalled reads
index_path="$3"
# Output directory
output_path="$4"

# Start program timer
start=$SECONDS

# Creates a directory to store all of the outputs
echo "Creating an output directory \"nanopolish_output_files\" within the home directory"
cd /
mkdir nanopolish_output_files
echo "Directory \"nanopolish_output_files\" created in the home directory"

# Output file path variables
sam_file="../nanopolish_output_files/output.sam"
sorted_file="../nanopolish_output_files/albacore_output.sorted.bam"
runtime_file="../nanopolish_output_files/runtime.txt"

touch $sam_file
touch $sorted_file
touch $runtime_file

# Creates an index file that links read ids with their signal-level data in the FAST5 files
echo "------------------------------Nanopolish Indexing------------------------------"
"/nanopolish/nanopolish" index -d $fast5_path $index_path

# Align the basecalled reads to the reference genome
echo "------------------------------Minimap Mapping------------------------------"
"/minimap2/minimap2" -a -x map-ont $ref_path $index_path > $sam_file

# Creates a sorted binary sequence alignment map
echo "------------------------------Samtools Sorting------------------------------"
cat $sam_file | samtools sort -T tmp -o $sorted_file
echo "------------------------------Samtools Indexing------------------------------"
samtools index $sorted_file

# Uses nanopolish to detect methylated bases
# What reads to use - "output.fastq"
# Where the alignments are - "output.sorted.bam"
# The reference genome - "reference.fasta"
echo "------------------------------Calling Methylation------------------------------"
bash -c "'/nanopolish/nanopolish' call-methylation -t 8 -r $index_path -b $sorted_file -g $ref_path --progress > /nanopolish_output_files/methylation_calls.tsv"

# Output total runtime
if (( $SECONDS > 3600 )) ; then
    let "hours=SECONDS/3600"
    let "minutes=(SECONDS%3600)/60"
    let "seconds=(SECONDS%3600)%60"
    echo "Completed in $hours hour(s), $minutes minute(s) and $seconds second(s)"
    echo "Completed in $hours hour(s), $minutes minute(s) and $seconds second(s)" > $runtime_file  
elif (( $SECONDS > 60 )) ; then
    let "minutes=(SECONDS%3600)/60"
    let "seconds=(SECONDS%3600)%60"
    echo "Completed in $minutes minute(s) and $seconds second(s)"
    echo "Completed in $minutes minute(s) and $seconds second(s)" > $runtime_file
else
    echo "Completed in $SECONDS seconds"
    echo "Completed in $SECONDS seconds" > $runtime_file
fi

cp -r ../nanopolish_output_files $output_path
