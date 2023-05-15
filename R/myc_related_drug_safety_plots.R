
# Load libraries ----------------------------------------------------------

library(tidyverse)
library(arrow)
library(ggrepel)

# Plot Setup -------------------------------------------------------------------

theme_set(theme_bw(base_size = 16))


# Load data ---------------------------------------------------------------

myc_related_drug_safety_enrichment_data <- 
    arrow::read_feather("data/myc_related_drug_safety_enrichment_data.feather")

myc_related_drug_safety_data <- 
    arrow::read_feather("data/myc_related_drug_safety_data.feather")
myc_related_drug_safety_data <- 
    myc_related_drug_safety_data %>% 
    mutate(
        nichd = factor(nichd,
                       unique(nichd)
        )
    )

myc_related_drug_safety_metadata <- 
    arrow::read_feather("data/myc_related_drug_safety_metadata.feather")


# Number of side effects per MYC-related drug -----------------------------

myc_related_drug_safety_data %>% 
    left_join(
        myc_related_drug_safety_metadata %>% 
            distinct(atc_concept_id,atc_concept_name),
        by = join_by(atc_concept_id)
    ) %>% 
    summarise(N = n(),.by=c(atc_concept_id,atc_concept_name)) %>% 
    arrange(desc(N)) %>% 
    ggplot(aes(N,forcats::fct_infreq(atc_concept_name,N))) +
    geom_bar(stat="identity") +
    scale_x_continuous(labels = scales::comma) +
    labs(x="Number of observed side effects during childhood (birth through 21)",y=NULL,
         title="Number of side effects for drugs with MYC-related gene expression changes")
ggsave("imgs/number_of_side_effects_for_myc_related_drug_signals.pdf",width=14,height=6)

# Normalized dGAM scores for MYC-related pediatric drug safety signals --------

myc_related_drug_safety_data %>%
    ggplot(aes(nichd,norm)) +
    geom_line(aes(group=ade),alpha=0.01) +
    labs(y="Normalized dGAM score",x=NULL,
         title="MYC-related pediatric drug safety signals",
         caption=paste0("There are ",
                        n_distinct(myc_related_drug_safety_data$atc_concept_id),
                        " drugs related to MYC gene expression changes via Drugbank")) +
    theme(
        axis.text.x = element_text(angle=45,vjust=1,hjust=1)
    )
ggsave("imgs/normalized_dgam_scores_for_myc_related_signals.pdf",width=8,height=5)

# Plot enrichment of MYC-related drugs and side effects -------------------

palette <- 
    colorRampPalette(
        RColorBrewer::brewer.pal(9,name = 'Set1')
    )(
        length(unique(myc_related_drug_safety_enrichment_data$atc_concept_name))
    )


myc_related_drug_safety_enrichment_data %>% 
    ggplot(aes(pvalue,lwr,fill=atc_concept_name)) +
    geom_point(position = position_jitter(),pch=21) +
    geom_label_repel(
        data = myc_related_drug_safety_enrichment_data %>% 
            filter(lwr>1.5),
        aes(label=paste0(atc_concept_name,"\n",meddra_concept_name)),
        force=20
    ) +
    scale_fill_manual(values = palette) +
    guides(fill=guide_legend(title="MYC-related drugs")) +
    xlab("P-value") +
    ylab("95% Lower Bound Confidence Interval") +
    ggtitle("MYC-related drug effect enrichments")

myc_related_drug_safety_data_summary <- 
    myc_related_drug_safety_data %>% 
    summarise(
        mean = mean(gam_score_90mse,na.rm=T),
        .by = c(nichd,meddra_concept_id)
    ) %>% 
    left_join(
        myc_related_drug_safety_metadata %>% 
            distinct(meddra_concept_name_4,meddra_concept_id, meddra_concept_name_1, nichd),
        by = join_by(meddra_concept_id, nichd)
    ) %>% 
    mutate(
        nichd = factor(nichd,
                       unique(nichd)
        )
    )


# MYC-related pediatric drug cardiac side effect signals ------------------

myc_related_drug_safety_data_summary %>%
    filter(grepl("Cardi",meddra_concept_name_4)) %>% 
    arrange(desc(mean))

myc_related_drug_safety_data_summary %>%
    filter(grepl("Cardi",meddra_concept_name_4)) %>% 
    ggplot(aes(nichd,mean)) +
    geom_line(position = pos,aes(group=meddra_concept_id)) +
    facet_wrap(~meddra_concept_name_4,scales = "free_y") +
    theme(
        axis.text.x = element_text(angle=45,vjust=1,hjust=1)
    ) +
    coord_cartesian(ylim=c(0,NA))
