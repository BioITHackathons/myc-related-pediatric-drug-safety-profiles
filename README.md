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

1. Identify MYC protein interaction/similarity network. Drugbank's pharmaco-transcriptomics tool has possible expression-related changes by drugs for MYC. [Link](https://go.drugbank.com/pharmaco/transcriptomics?q%5Bg%5B0%5D%5D%5Bm%5D=or&q%5Bg%5B0%5D%5D%5Bdrug_approved_true%5D=all&q%5Bg%5B0%5D%5D%5Bdrug_nutraceutical_true%5D=all&q%5Bg%5B0%5D%5D%5Bdrug_illicit_true%5D=all&q%5Bg%5B0%5D%5D%5Bdrug_investigational_true%5D=all&q%5Bg%5B0%5D%5D%5Bdrug_withdrawn_true%5D=all&q%5Bg%5B0%5D%5D%5Bdrug_experimental_true%5D=all&q%5Bg%5B1%5D%5D%5Bm%5D=or&q%5Bg%5B1%5D%5D%5Bdrug_available_in_us_true%5D=all&q%5Bg%5B1%5D%5D%5Bdrug_available_in_ca_true%5D=all&q%5Bg%5B1%5D%5D%5Bdrug_available_in_eu_true%5D=all&commit=Apply+Filter&q%5Bdrug_precise_names_name_cont%5D=&q%5Bgene_symbol_eq%5D=MYC&q%5Bgene_id_eq%5D=&q%5Bchange_eq%5D=&q%5Binteraction_cont%5D=&q%5Bchromosome_location_cont%5D=). The drug IDs were found in kidsides based on the atc_concept_name name.
2. Extract drug profiles based on drug IDs in kidSIDES (myc_related_drug_safety_data.R).
3. Visualize safety profiles overall, by side effect, and drug (myc_related_drug_safety_plots.R).
4. (Optional) Retrieve MYC gene expression data from Kids First platform. 
5. (Optional) Identify MYC-related pediatric drug safety profiles with mutual information with thhe MYC gene expression data. 

## Ideal Output

1. MYC protein network diagram (R notebook)
2. MYC-related pediatric drug safety profiles


## Medication Data

|OMOP CONCEPT | NAME | Mode |
:--------------:|:----| :---|
|21603618|dexamethasone|ophthalmic (corticosteroids, plain)|
|21603748|cisplatin|inhalant, parenteral|
|21603641|diclofenac|ophthalmic|
|21600819|calcitriol|systemic|
|21602040|calcitriol|topical|
|21603732|doxorubicin|parenteral, topical|
|21602516|ethinylestradiol|oral (natural and semisynthetic estrogens, plain)|
|21603718|etoposide|systemic|
|21601436|fluorouracil|systemic|
|21603833|fulvestrant|parenteral|
|21601236|hemin|systemic, topical|
|21603941|indometacin|systemic, rectal|
|21600747|metformin|oral|
|21601423|methotrexate|systemic (folic acid analog.)|
|21602623|mifepristone|oral|
|21603738|mitoxantrone|parenteral|
|21600435|nitroprusside|parenteral|
|21603151|ritonavir| oral|
|21604714|sertraline| oral|
|21603942|sulindac|systemic, rectal
|21603831|tamoxifen|oral|
|21603719|teniposide|parenteral|
|21602510|testosterone|systemic, rectal, sublingual, transdermal|
|21603332|theophylline|systemic, rectal|
|21603793|[U] tretinoin|systemic|
|21604422|valproic acid|systemic, rectal|
|21603809|[U] vorinostat| oral|
|21601442|decitabine| systemic|
|21603730|dactinomycin|parenteral|


