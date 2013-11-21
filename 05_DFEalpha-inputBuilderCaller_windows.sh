#! /bin/bash

#cd /home/sergio/chromatin/analysis/inputs_DFE-alpha/tests/orth/

for file in `ls | grep orth | grep 0y4 | grep -v DFE` #Select all files matching 'orth', select matching '0y4' exclude those matching 'DFE' (DFE files have already been processed by 04_DFEalpha_inputBuilder_2.pl)
do
    echo "Processing file ${file}"
    perl 04_DFEalpha-inputBuilder_2_windows_8.pl -input ${file}
done
