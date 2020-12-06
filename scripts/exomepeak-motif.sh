MAIN=/rumi/shams/abe/Projects/COVID19_m6A/second_dataset
PEAKS=exomepeak/human
MOTIF=/rumi/shams/abe/Projects/COVID19_m6A/motifs.txt

cd ${MAIN}/${PEAKS}
for sam in *; do
	cd $sam
	# step 1: extract mRNA sequences 
	cat peak.bed | sort -k1,1 -k2,2n peak.bed | cgat bed2bed --method=merge --merge-by-name |  awk '! /#/' | bedtools getfasta -name -s -fi /rumi/shams/genomes/hg38/hg38.fa -bed - -split -fo peak.fa
        # step 2: prepare inputs for FIRE
	perl $TEISERDIR/prep_seqs_for_teiser_run.pl peak.fa peaks
	# step 3: run FIRE for known m6A motifs (non-discovery mode)
	perl $FIREDIR/fire.pl --expfile=peaks_teiser.txt --exptype=discrete --fastafile_rna=peaks_teiser.fa \
	--nodups=1 --dodna=0 --dodnarna=0 --species=human --doskipdiscovery=1 --motiffile_rna=$MOTIF --oribiasonly=0
	mv -v peaks_teiser.txt_FIRE/ non-discovery_FIRE
	# step 4: run FIRE discovery mode
	perl $FIREDIR/fire.pl --expfile=peaks_teiser.txt --exptype=discrete --fastafile_rna=peaks_teiser.fa \
	--nodups=1 --dodna=0 --dodnarna=0 --species=human --oribiasonly=0
        mv -v peaks_teiser.txt_FIRE/ discovery_FIRE
	cd ../
done
