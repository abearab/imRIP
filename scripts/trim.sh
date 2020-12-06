mkdir -p trim
for fq in fastq/S00*R2*; do
	fq=`basename $fq`;
	out=${fq/_001.fastq.gz/.trim.fastq.gz};
	echo -------------------------$fq------------------------
	cutadapt -j 12 -u 3 -o trim/$out fastq/$fq
done
