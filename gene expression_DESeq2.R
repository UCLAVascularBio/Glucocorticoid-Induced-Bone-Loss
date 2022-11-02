## script for runing gene counts normalization and differential gene expression analysis
## from DESeq2 vignette page http://bioconductor.org/packages/devel/bioc/vignettes/DESeq2/inst/doc/DESeq2.html
library(DESeq2)
library(ggplot2)
library("EnhancedVolcano")
library("pheatmap")
library("RColorBrewer")

# number of reads per gene were counted along STAR mapping from each sample
countData <- read.csv('STAR_readscounts.csv', header = TRUE, row.names = 1)
metaData <- read.csv('Cells_ctrl_Dx_samples.csv', header = TRUE)

dds <- DESeqDataSetFromMatrix(countData=countData, 
                              colData=metaData, 
                              design= ~ condition)

## Pre-filtering
keep <- rowSums(counts(dds)) >= 3
dds <- dds[keep,]

## run DESEQ function
dds <- DESeq(dds)

resultsNames(dds)
res <- results(dds, name="condition_Dx_vs_Ctrl")
summary(res)

# Log fold change shrinkage for visualization and ranking
library(apeglm)
resLFC <- lfcShrink(dds, coef="condition_Dx_vs_Ctrl", type="apeglm")
plotMA(resLFC,ylim=c(-10,10),main='DE pAdjValue < 0.05', alpha=0.05)

resOrdered <- res[order(res$pvalue),]
de_sig <- subset(res, padj<.05 & abs(log2FoldChange)>1)
summary(de_sig)

# write output file of differential expressed genes
write.csv(as.data.frame(de_sig), 
          file="sig_de_condition_Dx_vs_ctrl_results_01lfc1.csv")

# number of transcripts with adjusted p-values less than 0.05
sum(res$padj < 0.05, na.rm=TRUE)

# Count data transformations
vsd <- vst(dds, blind=FALSE)
rld <- rlog(dds, blind=FALSE)

# Draw volcano plot
EnhancedVolcano(res,
                lab = NA,
                x = "log2FoldChange",
                y = "padj", FCcutoff = 1, pCutoff = 0.05, 
                subtitle = NULL, 
                legendLabSize = 12, 
                caption = 'log2FC cutoff, 1; padj cutoff, 0.05', 
                legendLabels = c("NS", expression(Log[2] ~ FC), "padj", expression(padj ~ and ~ log[2] ~ FC)))

# write normalized counts output file
write.csv(counts(dds, normalized=T),file='normalized_counts.csv')




