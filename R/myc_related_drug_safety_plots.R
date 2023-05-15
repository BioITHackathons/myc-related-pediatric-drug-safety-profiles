library(tidyverse)
library(arrow)

myc_related_drug_safety_data <- 
    arrow::read_feather("data/myc_related_drug_safety_data.feather")


myc_related_drug_safety_enrichment_data <- 
    arrow::read_feather("data/myc_related_drug_safety_enrichment_data.feather")

