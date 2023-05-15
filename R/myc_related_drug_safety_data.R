library(kidsides)
library(tidyverse)
library(arrow)

myc_related_drugs <- 
    c(21603618, 21603748, 21603641, 21600819, 21602040, 21603732, 21602516, 21603718, 21601436, 21603833, 21601236, 21603941, 21600747, 21601423, 21602623, 21603738, 21600435, 21603151, 21604714, 21603942, 21603831, 21603719, 21602510, 21603332, 21603793, 21604422, 21603809, 21601442, 21603730)

con <- kidsides::connect_sqlite_db()

tbl(con,"ade_nichd") %>% 
    filter(atc_concept_id %in% myc_related_drugs) %>% 
    collect() %>% 
    arrow::write_feather("data/myc_related_drug_safety_data.feather")

tbl(con,"ade_nichd_enrichment") %>% 
    filter(atc_concept_name %in% !!c(
        tbl(con,"drug") %>% 
            filter(atc_concept_id %in% myc_related_drugs) %>% 
            pull(atc_concept_name)
    )) %>% 
    collect() %>% 
    arrow::write_feather("data/myc_related_drug_safety_enrichment_data.feather")

mydrugs= "";
for (i in 1:length(myc_related_drugs)){
    mydrugs = paste(mydrugs,",",myc_related_drugs[i],sep="")
}
mydrugs=substring(mydrugs,2,nchar(mydrugs))
query <- paste("select drug.atc_concept_id,drug.atc_concept_name,drug.atc4_concept_name,
drug.atc3_concept_name,drug.atc2_concept_name,drug.atc1_concept_name,
ade_nichd.meddra_concept_id, ade_nichd.ade_name,ade_nichd.nichd,
event.meddra_concept_name_4, event.meddra_concept_name_3,
event.meddra_concept_name_2,event.meddra_concept_name_1
from drug inner join ade_nichd on drug.atc_concept_id = ade_nichd.atc_concept_id
inner join event on event.meddra_concept_id = ade_nichd.meddra_concept_id
where drug.atc_concept_id in (", mydrugs,")",sep="");

#dplyr::tbl(con, dplyr::sql(query)) %>% collect() %>% View();

mytable<-dplyr::tbl(con, dplyr::sql(query)) %>% collect()

arrow::write_feather(mytable, paste("data/",
                                    "myc_related_drug_safety_metadata",".feather", sep = ""))

kidsides::disconnect_sqlite_db(con)
