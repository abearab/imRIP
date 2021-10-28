# map to virus genome 
# https://www.ncbi.nlm.nih.gov/nuccore/MN908947?%3Fdb=nucleotide
# STAR --runThreadN 16 \
# --runMode genomeGenerate \
# --genomeDir ../virus/ \
# --genomeFastaFiles ../virus/coronavirus_2_isolate_Wuhan-Hu-1.fasta \
# --sjdbGTFfile ../virus/coronavirus_2_isolate_Wuhan-Hu-1.gff3 \
# --sjdbOverhang 99 --genomeSAindexNbases 8 --sjdbGTFfeatureExon CDS

mkdir -p virus_bam
STAR --genomeLoad LoadAndExit --genomeDir ../virus/

for fq in virus_fastq/*mate1; do
	fq1=`basename $fq`;
	fq2=${fq1/mate1/mate2};
	out=${fq1/_Unmapped.out.mate1/};
	echo 'sample ' $fq1
	STAR \
	--outSAMtype BAM SortedByCoordinate \
	--readFilesCommand cat \
	--runThreadN 16 \
	--genomeDir ../virus/ \
	--readFilesIn virus_fastq/$fq1 virus_fastq/$fq2 \
	--outFileNamePrefix virus_bam/$out \
	--limitBAMsortRAM 1000000000;
done
STAR --genomeLoad Remove --genomeDir ../virus/


