library(kidsides)
library(tidyverse)

myc_related_drugs <- 
    c(21603618, 21603748, 21603641, 21600819, 21602040, 21603732, 21602516, 21603718, 21601436, 21603833, 21601236, 21603941, 21600747, 21601423, 21602623, 21603738, 21600435, 21603151, 21604714, 21603942, 21603831, 21603719, 21602510, 21603332, 21603793, 21604422, 21603809, 21601442, 21603730)

con <- kidsides::connect_sqlite_db()

tbl(con,"ade_nichd") %>% 
    filter(atc_concept_id %in% myc_related_drugs) %>% 
    collect() %>% 
    write_tsv("data/myc_related_drug_safety_data.tsv")
