#!/bin/bash

#$ -cwd
#$ -l h_data=4G,highp -pe shared 12
# Email address to notify
#$ -M $USER@mail
# Notify when
#$ -m bea
JOB_ID="STAR mapping"

# echo job info on joblog:
echo "Job $JOB_ID started on:   " `hostname -s`
echo "Job $JOB_ID started on:   " `date `

for i in $(ls ./data/*.fastq.gz|rev|cut -c22-|rev|uniq)
do 

./STAR --runThreadN 12 --genomeDir ./genome/ --readFilesCommand zcat --readFilesIn ${i}_L002_R1_001.fastq.gz ${i}_L002_R2_001.fastq.gz --quantMode GeneCounts --outSAMtype BAM SortedByCoordinate --outFileNamePrefix ./STARmapping/${i}_

done

# echo job info on joblog:
echo "Job $JOB_ID ended on:   " `hostname -s`
echo "Job $JOB_ID ended on:   " `date `

echo "@@@ Script reached end  $(hostname) $(date)"
