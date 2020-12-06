MAIN=/rumi/shams/abe/Projects/COVID19_m6A/second_dataset
PEAKS=exomepeak/virus

cd $MAIN
for f in bam/*_IN*.bam; do 
	b=`basename $f`; 
	b=${b/_IN.bam/}; 
	echo -------------------------$b------------------------
        Rscript _sh/exompeak.virus.R $MAIN $PEAKS $b _IN _RIP
	echo 'All done!'
done

