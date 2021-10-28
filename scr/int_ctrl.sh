echo '-------m6A pos-------'
bowtie2-build int_ctrl/m6A_pos.fa int_ctrl/m6A_pos

mkdir -p int_ctrl/
mkdir -p int_ctrl/virus/
mkdir -p int_ctrl/virus/m6A_pos
mkdir -p int_ctrl/virus/m6A_neg


for f in virus_fastq/*mate1;
    do f=`basename $f`;
    f2=${f/mate1/mate2};
    o=${f/_S*Unmapped.out.mate1/.bam};
	bowtie2 -p 12 --sensitive \
        -N 1 -x int_ctrl/m6A_pos \
        --no-unal \
        -1 virus_fastq/$f -2 virus_fastq/$f2 | samtools sort -o int_ctrl/virus/m6A_pos/$o;
done

echo '-------m6A neg--------'
bowtie2-build int_ctrl/m6A_neg.fa int_ctrl/m6A_neg

for f in virus_fastq/*mate1;
    do f=`basename $f`;
    f2=${f/mate1/mate2};
    o=${f/_S*Unmapped.out.mate1/.bam};
	bowtie2 -p 12 --sensitive \
        -N 1 -x int_ctrl/m6A_neg \
        --no-unal \
        -1 virus_fastq/$f -2 virus_fastq/$f2 | samtools sort -o int_ctrl/virus/m6A_neg/$o;
done

echo 'All done!'