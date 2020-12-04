# imRIP 
## Integrated methods for meRIP-seq data analysis
Multiple conda environments involved to use all these tools together.
## 1. Pre-processing
- Starting from raw Fastq files 
- Trimming task using cutadapt
- Alignment task using STAR 
- Check raw data quality using MultiQC

## 2. Peak-calling [+ Differential methylation analysis]
- Using **RADAR** package
	- It only works for peak-calling and differential methylation analysis at once (samples at two conditions)
	- (it has multiprocessing option then it works faster)
- Gene level methylation enrichment and pathway analysis using iPAGE 
If study design has no differential analysis:
- Using exomePeak package
	- It also works with samples which are only at one condition

## 3. Validating meRIP experiment success 
- Draw metagene plots using Guitar package 
- Motif analysis to check DRACH & RGAC motif presentation using FIRE algorithm 

## 4. Test global hyper/hypo methylation shift 
- Draw histogram using ggplot2 package (easy!)
- Using wilcox-test and t-test to confirm global hyper or hypo methylation among significant peaks 

## 5. Enrichment analysis of condition-induced methylated sites in other datasets
- Select hyper/hypo gene sets (genes with logFC above/under a threshold) using awk command (easy!)
- Evaluate enrichment within other high-throughput datasets using a module from TIESER algorithm
	- It works through Mutual Information (MI) evaluation same as FIRE and iPAGE 

