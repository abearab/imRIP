cd ~/Projects/COVID19_m6A/second_dataset

mkdir -p fastq/
mkdir -p _sh/
mkdir -p _sh/bcl2fastq/

bcl2fastq --create-fastq-for-index-reads \
--runfolder-dir 200527_NS500257_0113_AH2VKLBGXF \
-r 18 -p 18 \
-o fastq/ \
--sample-sheet 200527_NS500257_0113_AH2VKLBGXF/200527_meRIPseq.csv \
--no-lane-splitting \
--stats-dir _sh/bcl2fastq/ \
--reports-dir _sh/bcl2fastq/
