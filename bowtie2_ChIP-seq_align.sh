#!/bin/bash

JOBname="AlnBowtie2"
NUMcores="8"
JOBperCoreGB="4"

module load bowtie2/2.4.2

for i in $(ls /ChIPseq/data/*.fastq|rev|cut -c14-|rev|uniq)
do 

bowtie2 -p 8 -x /genome/Bowtie2/mm10/mm10  -U ${i}_R1_001.fastq -S ${i}.sam

done
