MAIN=/rumi/shams/abe/Projects/COVID19_m6A/second_dataset
PEAKS=exomepeak/human

cd $MAIN
for f in bam/*_IN*.bam; do 
	b=`basename $f`; 
	b=${b/_IN.bam/}; 
	echo -------------------------$b------------------------
        Rscript _sh/exompeak.R $MAIN $PEAKS $b _IN _RIP
	echo 'All done!'
done
