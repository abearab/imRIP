library("RADAR")

radar.1 <- countReads(
  samplenames = c("D0.r1","D0.r2","D25.r1","D25.r2"),
  gtf = "/rumi/shams/genomes/hg38/hg38_genes.gtf",
  bamFolder = "./",
  modification = "m6A",
  strandToKeep = "opposite",
  outputDir = "D25vD0",
  threads = 16
)
radar.1 <- normalizeLibrary(radar.1)
radar.1 <- adjustExprLevel(radar.1)
variable(radar.1) <- data.frame( Group = c(rep("D0",2),rep("D25",2)) )
radar.1 <- filterBins(radar.1,minCountsCutOff = 15)
radar.1 <- diffIP_parallel(radar.1, thread = 8)
top_bins <- extractIP(radar.1,filtered = T)[order(rowMeans( extractIP(radar.1,filtered = T) ),decreasing = T)[1:1000],]
radar.1 <- reportResult(radar.1, cutoff = 0.1, Beta_cutoff = 0.5, threads=16)
result.1 <- results(radar.1)
saveRDS(radar.1, file = "radar1.D25vD0.rds")