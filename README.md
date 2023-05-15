# MYC-related pediatric drug safety profiles

## Background

MYC is an oncoprotein and often implies worse outcomes, however it also seems to have a role in cardiovascular disease. [The Gabriella Miller Kids First Pediatric Research Program](https://kidsfirstdrc.org) has devoted significant resources to collect and standardize next generation sequencing data to investigate MYC in cardiovascular disease. 

[kidSIDES](https://github.com/ngiangre/kidsides) is an R data package contains observation, summary, and model-level data from pediatric drug safety research, including investigating drug safety related to MYC expression. 

## Motivation

The kidSIDES resource has the unique opportunity to enable generating MYC-related pediatric drug safety profiles. Drugs can interact with proteins (e.g. inhibitors, agonists) as well as be substrates for different enzymes. The kidSIDES resource contains linkages between proteins (UniProt IDs) and drugs (ATC IDs). Gene expression results can be linked from genes (HUGO IDs) and proteins (Uniprot IDs). Through these linkages, we can integrate expression of genes with drug interactors/substrates. Then, the resource allows linking with potentially significant side effects across childhood for generating drug safety profiles. 

However, MYC is notorious for being "undruggable" [Ref](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6337544/). We will leverage MYC and related proteins both by sequence as well as interactions to facilitate drug effects potentially perturbed through the MYC gene expression network. 

## Hypotheses

1. Pediatric drug safety profiles based on substrates for interactors in the MYC protein network provide a MYC-related pediatric drug safety profile. 
2. MYC expression profiles across childhood contain mutual information with MYC-related pediatric drug safety profiles. 

## Methodology

1. Identify MYC protein interaction/similarity network. BLASTing a key peptide sequence provides proteins with a similar sequence. STRINGdb provides proteins interactung with MYC. 
2. Identify UniProt IDS for MYC protein network.
3. Identify drug IDs in kidSIDES from UniProt IDs in the `drug_gene` table.
4. Extract drug profiles based on drug IDs in kidSIDES
5. (Optional) Retrieve MYC gene expression data from Kids First platform. 
6. (Optional) Identify MYC-related pediatric drug safety profiles with mutual information with thhe MYC gene expression data. 

## Ideal Output

1. MYC protein network diagram (R notebook)
2. MYC-related pediatric drug safety profiles
