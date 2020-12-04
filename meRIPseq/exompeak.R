library(tidyverse)
library(argparse)
library(GenomicFeatures)
library(exomePeak)

parser <- ArgumentParser()
parser$add_argument('-i', '--input_dir', nargs=1, type='character', help='Absolute path to the input directories')
parser$add_argument('-s', '--species', nargs=1, type='character', help='Species hg19, hg38 (default), or mm10', default='hg38')

args <- parser$parse_args()
indir <- args$input_dir
setwd(indir)

######################################## functions ########################################
if (args$species == 'hg38') {
  txdb <- makeTxDbFromGFF('/rumi/shams/genomes/hg38/Homo_sapiens.GRCh38.87.gtf', organism='Homo sapiens')
  tag <- '.bam$'
#} else if (args$species == 'mm10') {
  #
# } else if (args$species == 'HIV') {
#   txdb <- makeTxDbFromGFF('./HIV/HIV.gtf',
#                           organism='Human immunodeficiency virus 1')
#   tag <- '.HIV.bam$'
}

setwd("./bam")
print (txdb)

run_exomepeak <- function (){
	res <- exomepeak(
		TXDB=txdb,
		IP_BAM=,
		INPUT_BAM=
		OUTPUT_DIR=paste('../exomepeak/', args$species, sep=''),
		EXPERIMENT_NAME='control'
	)
	saveRDS(res, paste('../exomepeak',args$species, 'control', 'results.rds', sep='/'))
	return (res)
}
######################################## run script ########################################
run_exomepeak()
