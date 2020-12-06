###################### pre processing #############################
conda activate deseq 

mkdir -p trim
for fq in fastq/S00*R2*; do
	fq=`basename $fq`;
	out=${fq/_001.fastq.gz/.trim.fastq.gz};
	echo -------------------------$fq------------------------
	cutadapt -j 12 -u 3 -o trim/$out fastq/$fq
done

# map to human genome 
mkdir -p bam

STAR --genomeLoad LoadAndExit --genomeDir /rumi/shams/genomes/hg38/

for fq in fastq/*_R1*; do
	fq1=`basename $fq`;
	fq2=${fq1/R1_001.fastq.gz/R2.trim.fastq.gz};
	out=${fq1/R1_001.fastq.gz/};
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
rm Aligned.out.sam Log*out
rm -r bam/Undetermined_S0*

mkdir -p virus_fastq
mv bam/*_Unmapped.out.mate[1-2] virus_fastq/

mkdir -p qc_star/
mkdir -p qc_star/hg38

mv -v bam/*out qc_star/hg38/
mv -v bam/*tab qc_star/hg38/

for f in bam/*; do r=${f/_S[0-9]*_Aligned.sortedByCoord.out.bam/.bam}; mv -v $f $r; done 

# map to virus genome 
# https://www.ncbi.nlm.nih.gov/nuccore/MN908947?%3Fdb=nucleotide
STAR --runThreadN 16 \
--runMode genomeGenerate \
--genomeDir virus/ \
--genomeFastaFiles virus/coronavirus_2_isolate_Wuhan-Hu-1.fasta \
--sjdbGTFfile virus/coronavirus_2_isolate_Wuhan-Hu-1.gff3 \
--sjdbOverhang 99 --genomeSAindexNbases 8 --sjdbGTFfeatureExon CDS

mkdir -p virus_bam
STAR --genomeLoad LoadAndExit --genomeDir virus/

for fq in virus_fastq/*mate1; do
	fq1=`basename $fq`;
	fq2=${fq1/mate1/mate2};
	out=${fq1/_Unmapped.out.mate1/};
	STAR \
	--outSAMtype BAM SortedByCoordinate \
	--readFilesCommand cat \
	--runThreadN 16 \
	--genomeDir virus/ \
	--readFilesIn virus_fastq/$fq1 virus_fastq/$fq2 \
	--outFileNamePrefix virus_bam/$out \
	--limitBAMsortRAM 1000000000;
done
STAR --genomeLoad Remove --genomeDir virus/

###################### peak calling: human #############################
conda activate exomepeak
for i in `awk 'NR>1{print $1}' RTqPCR.txt`; do 
	Rscript _sh/exompeak.R \
	~/Projects/COVID19_m6A \
	~/Projects/COVID19_m6A/exomepeak/human/ \
	$i _IN _RIP;
done

conda activate guitar
for i in `awk 'NR>1{print $1}' RTqPCR.txt`; do 
	Rscript _sh/guitar.R ./exomepeak/human/$i peak.bed $i
done 

###################### peak calling: virus #############################
for i in `awk 'NR>1{print $1}' RTqPCR.txt`; do 
	echo Rscript _sh/exompeak.virus.R \
	~/Projects/COVID19_m6A/virus_bam/ \
	~/Projects/COVID19_m6A/exomepeak/virus/$i $i _IN _RIP; 
done 

for f in virus_bam/*bam; 
	do base=`basename $f`; 
	out=${base/.bam/.fc}; 
	bamToBed -i $f | intersectBed -split -s -wo -a - -b lowCt_peaks.c.bed | cut -f10 | sort | uniq -c | awk '{ print $2 "\t" $1}' > virus_count/$out; 
done

###################### internal ctrl #############################
conda activate bowtie2

bowtie2-build internal_control/m6A_pos.fa internal_control/index/m6A_pos

for f in virus_fastq/*mate1; 
	do f=`basename $f`; 
	f2=${f/mate1/mate2}; 
	o=${f/_Unmapped.out.mate1/.bam}; 
	bowtie2 -p 12 --sensitive \
	-N 1 -x internal_control/index/m6A_pos \
	--no-unal \
	-1 virus_fastq/$f -2 virus_fastq/$f2 | samtools sort -o internal_control/virus/m6A_pos.$o;
done

bowtie2-build internal_control/m6A_neg.fa internal_control/index/m6A_neg

for f in virus_fastq/*mate1; 
	do f=`basename $f`; 
	f2=${f/mate1/mate2}; 
	o=${f/_Unmapped.out.mate1/.bam}; 
	bowtie2 -p 12 --sensitive \
	-N 1 -x internal_control/index/m6A_neg \
	--no-unal \
	-1 virus_fastq/$f -2 virus_fastq/$f2 | samtools sort -o internal_control/virus/m6A_neg.$o;
done

# count 
for b in internal_control/virus/m6A_neg.S00*bam; do
	base=`basename $b`;
	echo $base;
	bamToBed -i $b | intersectBed -s -wo -a - -b internal_control/m6A_neg.bed | cut -f10 | sort | uniq -c | awk '{ print $2 "\t" $1}' ; 
done

for b in internal_control/virus/m6A_pos.S00*bam; do
	base=`basename $b`;
	echo $base;
	bamToBed -i $b | intersectBed -s -wo -a - -b internal_control/m6A_pos.bed | cut -f10 | sort | uniq -c | awk '{ print $2 "\t" $1}' ; 
done

# result.txt manually created 
nano internal_control/result.txt
