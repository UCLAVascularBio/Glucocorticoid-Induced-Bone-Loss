#!/bin/bash

module load anaconda3
conda activate
module load homer/4.11.1

## makeTagDirectory

for i in $(ls /data/*.sam|rev|cut -c5-|rev|uniq)
do 

makeTagDirectory ../ChIPseq/Tag/${i} ${i}.sam

done


makeUCSCfile ./Tag/Control-GR/ -o auto
makeUCSCfile ./Tag/Treated-GR/ -o auto

## find peaks in control and treated samples over input

findPeaks Control-GR_S7/ -style factor -i Input-C_S1/ -o control_GR_over_input_peaks.txt
findPeaks Treated-GR_S8/ -style factor -i Input-T_S2/ -o treated_GR_over_inputT_peaks.txt

## find peaks in treated sample over control

findPeaks Treated-GR_S8/ -style factor -i Control-GR_S7/ -o treated_GR_over_control_peaks.txt


## find motif occurrance
findMotifsGenome.pl control_GR_over_input_peaks.txt mm10 Control-GR_Motif/ -size 200 -preparsedDir preparse/

findMotifsGenome.pl treated_GR_over_inputT_peaks.txt mm10 Treated-GR_Motif/ -size 200 -preparsedDir preparse/



