library(Guitar)

args <- commandArgs(trailingOnly = TRUE)

jobID <- args[1]
bed_file <- args[2]
plot_prefix <- args[3]

setwd(jobID)
list.files()
print (bed_file)

txdb <- makeTxDbFromGFF('/rumi/shams/genomes/hg38/gencode.v28.annotation.gtf',organism='Homo sapiens')

GuitarPlot(txTxdb=txdb,stBedFiles=list(bed_file),miscOutFilePrefix=plot_prefix)
