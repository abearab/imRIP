
library(GenomicFeatures)
library(exomePeak)

args <- commandArgs(trailingOnly = TRUE)

jobID  <- args[1]
OUTPUT <- args[2]
Sample <- args[3]
INPUT <- args[4]
IP <- args[5]

GTF = '~/Projects/COVID19_m6A/virus/coronavirus_2_isolate_Wuhan-Hu-1.gff3'

######################################## read meta ######################################$


IP_BAM = paste(Sample, IP, '.bam', sep='')
INPUT_BAM = paste(Sample, INPUT, '.bam', sep='')

print (IP_BAM)
print (INPUT_BAM)
print (OUTPUT)
######################################## functions ######################################
txdb <- makeTxDbFromGFF(GTF, organism=NA )

setwd(jobID)
setwd("./virus_bam")


print (txdb)

WINDOW = 15
STEP = 5
LENGTH = 15
FDR = 0.025
ENRICH = 0.2
res <- exomepeak(
        TXDB = txdb,
        IP_BAM=IP_BAM,
        INPUT_BAM=INPUT_BAM,
        OUTPUT_DIR=paste('..',OUTPUT,sep='/'),
        EXPERIMENT_NAME=Sample,
        # options
        WINDOW_WIDTH = WINDOW,
        SLIDING_STEP = STEP,
        FRAGMENT_LENGTH = LENGTH,
        PEAK_CUTOFF_FDR = FDR,
        FOLD_ENRICHMENT = ENRICH
)

saveRDS(res, paste('..', OUTPUT, Sample, 'results.rds', sep='/'))

