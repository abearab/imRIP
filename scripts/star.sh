cd ~/Projects/COVID19_m6A/second_dataset
mkdir -p bam

STAR --genomeLoad LoadAndExit --genomeDir /rumi/shams/genomes/hg38/
for fq in fastq/*R1*; do
    fq1=`basename $fq`
    fq2=${fq1/_R1_/_R2_}
    fq2=${fq2/.fastq.gz/.trim.fastq.gz}
    out=${fq1/_R1_001.fastq.gz/}
    STAR \
    --outSAMtype BAM SortedByCoordinate \
    --readFilesCommand zcat \
    --runThreadN 16 \
    --genomeDir /rumi/shams/genomes/hg38/ \
    --readFilesIn fastq/$fq1 trim/$fq2 \
    --outFileNamePrefix bam/$out \
    --outReadsUnmapped Fastx; 
done
STAR --genomeLoad Remove --genomeDir /rumi/shams/genomes/hg38/
