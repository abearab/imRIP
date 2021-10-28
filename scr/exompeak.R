library(GenomicFeatures)
library(exomePeak)

args <- commandArgs(trailingOnly = TRUE)

jobID  <- args[1]
OUTPUT <- args[2]
Sample <- args[3]
INPUT <- args[4]
IP <- args[5]

######################################## read meta ######################################$

IP_BAM = paste(Sample, IP, '.bam', sep='')
INPUT_BAM = paste(Sample, INPUT, '.bam', sep='')

print (IP_BAM)
print (INPUT_BAM)

######################################## functions ######################################
GTF = '/rumi/shams/genomes/hg38/gencode.v28.annotation.gtf'
organism= 'Homo sapiens'

txdb <- makeTxDbFromGFF(GTF, organism=organism )

setwd(jobID)
setwd("./bam")

print (txdb)

res <- exomepeak(
	TXDB=txdb,
	IP_BAM=IP_BAM,
	INPUT_BAM=INPUT_BAM,
	OUTPUT_DIR=paste('..',OUTPUT,sep='/'),
	EXPERIMENT_NAME=Sample
)
saveRDS(res, paste('..', OUTPUT, Sample, 'results.rds', sep='/'))
