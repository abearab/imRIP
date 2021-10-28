for f in bam/*_IN*.bam; do
	b=`basename $f`;
	b=${b/_IN.bam/};
	echo -------------------------$b------------------------;
	Rscript _sh/guitar.R exomepeak/human/$b peak.bed $b;
done
