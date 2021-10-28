MAIN=$1
MOTIF=/rumi/shams/abe/GitHub/imRIP/motifs.txt

cd ${MAIN}
for sam in *; do
	cd $sam
	echo "__________________________________________________________________________________________"
	echo $sam
	echo "step 1: extract mRNA sequences"
	cat peak.bed | sort -k1,1 -k2,2n peak.bed | cgat bed2bed --method=merge --merge-by-name |  awk '! /#/' | bedtools getfasta -name -s -fi /rumi/shams/genomes/hg38/hg38.fa -bed - -split -fo peak.fa
	echo "--- DONE! ---"

	echo "step 2: prepare inputs for FIRE"
	# perl $TEISERDIR/prep_seqs_for_teiser_run.pl peak.fa peaks
	/rumi/shams/abe/anaconda3/envs/cgat/bin/python $TEISERDIR/prep_fasta_for_fire_run.py peak.fa
	echo "--- DONE! ---"

	echo "step 3: run FIRE for known m6A motifs (non-discovery mode)"
	perl $FIREDIR/fire.pl --expfile=peak_fire.txt --exptype=discrete --fastafile_rna=peak_fire.fa \
	--nodups=1 --dodna=0 --dodnarna=0 --species=human --doskipdiscovery=1 \
	--motiffile_rna=$MOTIF --oribiasonly=0 > non-discovery_FIRE.log
	rm -rv non-discovery_FIRE 
	mv -v peak_fire.txt_FIRE/ non-discovery_FIRE 
	echo "--- DONE! ---"

	echo "step 4: run FIRE discovery mode"
	perl $FIREDIR/fire.pl --expfile=peak_fire.txt --exptype=discrete --fastafile_rna=peak_fire.fa \
	--nodups=1 --dodna=0 --dodnarna=0 --species=human --oribiasonly=0 > discovery_FIRE.log 
	rm -rv discovery_FIRE 
	mv -v peak_fire.txt_FIRE/ discovery_FIRE
	echo "--- DONE! ---"

	cd ../
done