
# Load libraries ----------------------------------------------------------

library(tidyverse)
library(arrow)
library(ggrepel)

# Plot Setup -------------------------------------------------------------------

theme_set(theme_bw(base_size = 16))


# Load data ---------------------------------------------------------------

myc_related_drug_safety_enrichment_data <- 
    arrow::read_feather("data/myc_related_drug_safety_enrichment_data.feather")
myc_related_drug_safety_enrichment_data <- 
    myc_related_drug_safety_enrichment_data %>% 
    mutate(
        nichd = factor(nichd,
                       unique(nichd)
        )
    )
myc_related_drug_safety_data <- 
    arrow::read_feather("data/myc_related_drug_safety_data.feather")
myc_related_drug_safety_data <- 
    myc_related_drug_safety_data %>% 
    mutate(
        nichd = factor(nichd,
                       unique(nichd)
        )
    )

myc_related_drug_safety_enrichment_data <- 
    arrow::read_feather("data/myc_related_drug_safety_enrichment_data.feather")
myc_related_drug_safety_enrichment_data <- 
    myc_related_drug_safety_enrichment_data %>% 
    mutate(
        nichd = factor(nichd,
                       levels(myc_related_drug_safety_data$nichd)
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
ggsave("imgs/number_of_side_effects_for_myc_related_drug_signals.png",width=14,height=8)

myc_related_drug_safety_data %>% 
    left_join(
        myc_related_drug_safety_metadata %>% 
            distinct(atc_concept_id,atc_concept_name),
        by = join_by(atc_concept_id)
    ) %>% 
    summarise(N = n(),.by=c(atc_concept_id,atc_concept_name,myc_expression)) %>% 
    arrange(desc(N)) %>% 
    ggplot(aes(N,forcats::fct_infreq(atc_concept_name,N))) +
    geom_bar(stat="identity") +
    scale_x_continuous(labels = scales::comma) +
    facet_grid(myc_expression~.,scales = "free_y") +
    labs(x="Number of observed side effects during childhood (birth through 21)",y=NULL,
         title="Number of side effects for drugs with MYC-related gene expression changes")
ggsave("imgs/number_of_side_effects_for_myc_related_drug_signals_by_expression.png",width=14,height=8)

myc_related_drug_safety_data %>% 
    left_join(
        myc_related_drug_safety_metadata %>% 
            distinct(atc_concept_id,atc_concept_name),
        by = join_by(atc_concept_id)
    ) %>% 
    filter(gam_score>gt_null_99) %>% 
    summarise(N = n(),.by=c(atc_concept_id,atc_concept_name,myc_expression)) %>% 
    arrange(desc(N)) %>% 
    ggplot(aes(N,forcats::fct_infreq(atc_concept_name,N))) +
    geom_bar(stat="identity") +
    scale_x_continuous(labels = scales::comma) +
    facet_grid(myc_expression~.,scales = "free_y") +
    labs(x="Number of observed side effects during childhood (birth through 21)",y=NULL,
         title="Number of significant side effects for drugs with MYC-related gene expression changes")
ggsave("imgs/number_of_significant_side_effects_for_myc_related_drug_signals_by_expression.png",width=15,height=8)

# Normalized dGAM scores for MYC-related pediatric drug safety signals --------

myc_related_drug_safety_data %>%
    ggplot(aes(nichd,norm)) +
    geom_line(aes(group=ade,color=cluster_name),alpha=0.01,linewidth=2) +
    labs(y="Normalized dGAM score",x=NULL,
         title="MYC-related pediatric drug safety signals",
         caption=paste0("There are ",
                        n_distinct(myc_related_drug_safety_data$atc_concept_id),
                        " drugs related to MYC gene expression changes via Drugbank")) +
    guides(color=guide_legend(title="Cluster",ncol = 2,title.position = "top",
                              override.aes = list(alpha=1))) +
    facet_wrap(~cluster_name,ncol = 2) +
    scale_color_brewer(palette = "Set2") +
    theme(
        legend.position = "bottom",
        axis.text.x = element_text(angle=45,vjust=1,hjust=1)
    )
ggsave("imgs/normalized_dgam_scores_for_myc_related_signals.png",width=12,height=8)

myc_related_drug_safety_data %>%
    filter(gt_null_99==1) %>% 
    ggplot(aes(nichd,norm)) +
    geom_line(aes(group=ade,color=cluster_name),alpha=0.5,linewidth=2) +
    labs(y="Normalized dGAM score",x=NULL,
         title="MYC-related pediatric drug safety signals",
         ) +
    guides(color=guide_legend(title="Cluster",ncol = 2,title.position = "top",
                              override.aes = list(alpha=1))) +
    scale_color_brewer(palette = "Set2") +
    theme(
        legend.position = "bottom",
        axis.text.x = element_text(angle=45,vjust=1,hjust=1)
    )
ggsave("imgs/significant_dgam_scores_for_myc_related_signals.png",width=12,height=8)


myc_related_drug_safety_data %>%
    ggplot(aes(nichd,norm)) +
    geom_line(aes(group=ade,color=cluster_name),alpha=0.1,linewidth=2) +
    labs(y="Normalized dGAM score",x=NULL,
         title="MYC-related pediatric drug safety signals",
         caption=paste0("There are ",
                        n_distinct(myc_related_drug_safety_data$atc_concept_id),
                        " drugs related to MYC gene expression changes via Drugbank")) +
    guides(color=guide_legend(title="Cluster",ncol = 2,title.position = "top",
                              override.aes = list(alpha=1))) +
    facet_grid(myc_expression~cluster_name) +
    scale_color_brewer(palette = "Set2") +
    theme(
        legend.position = "bottom",
        axis.text.x = element_text(angle=45,vjust=1,hjust=1)
    )
ggsave("imgs/normalized_dgam_scores_for_myc_related_signals_by_expression.png",width=20,height=11)

pos <- position_dodge2(.7)
myc_related_drug_safety_data %>%
    filter(gt_null_99==1) %>% 
    summarise(lwr = mean(norm) - sd(norm),
              mean_norm = mean(norm),
              upr = mean(norm) + sd(norm),
              .by=c(myc_expression,cluster_name,nichd)) %>% 
    ggplot(aes(nichd,mean_norm,color=myc_expression)) +
    geom_pointrange(aes(ymin=lwr,ymax=upr),position = pos) +
    labs(y="Normalized dGAM score",x=NULL,
         title="MYC-related pediatric drug safety signals",
    ) +
    guides(color=guide_legend(title=NULL,ncol = 2,title.position = "top",
                              override.aes = list(alpha=1))) +
    scale_color_brewer(palette = "Set2") +
    facet_grid(.~cluster_name) +
    theme(
        legend.position = "bottom",
        axis.text.x = element_text(angle=45,vjust=1,hjust=1)
    )
ggsave("imgs/significant_dgam_scores_for_myc_related_signals_by_expression.png",width=12,height=6)

# Plot enrichment of MYC-related drugs and side effects -------------------

myc_related_drug_safety_enrichment_data %>% 
    left_join(
        myc_related_drug_safety_metadata %>% 
            distinct(atc_concept_id,atc_concept_name),
        by = join_by(atc_concept_name)
    ) %>% 
    left_join(
        myc_related_drug_safety_data %>% 
            distinct(atc_concept_id,myc_expression),
        by = join_by(atc_concept_id)
    ) %>% 
    arrange(nichd) %>% 
    ggplot(aes(nichd,lwr,
               group=interaction(atc_concept_id,meddra_concept_name))) +
    geom_line(aes(color=myc_expression)) +
    geom_label_repel(
        data = myc_related_drug_safety_enrichment_data %>% 
            filter(lwr>1) %>% 
            left_join(
                myc_related_drug_safety_metadata %>% 
                    distinct(atc_concept_id,atc_concept_name),
                by = join_by(atc_concept_name)
            ) %>% 
            left_join(
                myc_related_drug_safety_data %>% 
                    distinct(atc_concept_id,myc_expression),
                by = join_by(atc_concept_id)
            ) %>% 
            slice(1,.by=c(atc_concept_name,meddra_concept_name)),
        aes(label=stringr::str_wrap(meddra_concept_name,width = 8)),
        force=80
    ) +
    scale_color_brewer(palette = "Set1") +
    guides(color=guide_legend(title=NULL,title.position = "top")) +
    facet_wrap(~atc_concept_name) +
    xlab(NULL) +
    ylab("95% Lower Bound Confidence Interval") +
    ggtitle("MYC-related drug effect enrichments") +
    theme(
        legend.position = "top",
        axis.text.x = element_text(angle=45,vjust=1,hjust=1)
    )
ggsave("imgs/enrichment_of_significant_myc_related_signals_by_expression.png",width=20,height=15)



# Summarise signals into profiles -----------------------------------------

vars <- c("meddra_concept_name_4","atc1_concept_name")
widths=c(40,30)
purrr::walk(1:length(vars),function(i){
    var <- vars[i]
    width <- widths[i]
    myc_related_drug_safety_data %>% 
        left_join(
            myc_related_drug_safety_metadata,
            by = join_by(atc_concept_id, meddra_concept_id, nichd, ade_name)
        ) %>% 
        filter(gt_null_99==1) %>% 
        summarise(
            lwr = quantile(gam_score,0.025,na.rm = T),
            m = mean(gam_score,na.rm = T),
            upr = quantile(gam_score,0.975,na.rm = T),
            .by = c(nichd,myc_expression,rlang::ensym(var))
        ) %>% 
        mutate(
            nichd = factor(nichd,
                           unique(nichd)
            )
        ) %>% 
        ggplot(aes(nichd,m)) +
        geom_point() +
        geom_path(aes(group=1)) +
        facet_grid(eval(expr(myc_expression ~ !!rlang::ensym(var)))) +
        labs(x=NULL,y="Averaage drug safety signal") +
        theme(
            axis.text.x = element_text(angle=45,vjust=1,hjust=1)
        )
    ggsave(paste0("imgs/pediatric_drug_safety_profile_by_",var,"_by_stage.png"),
           height=7,width=width)
    
})


# High than average side effects ------------------------------------------

# myc_related_drug_clean=myc_related_drug_safety_enrichment_data[myc_related_drug_safety_enrichment_data$odds_ratio != Inf,]
# 
# myc_related_drug_clean_grouped = myc_related_drug_clean[,list(mean=mean(odds_ratio)),by=.(meddra_concept_name)];
# 
# top_ten = myc_related_drug_clean_grouped[order(-mean),][1:8]
# 
# barplot(top_ten$mean, main="Side Effects With Highest Ave. odds Ratio", horiz=TRUE, xlab="Side Effects",
#         names.arg=top_ten$meddra_concept_name,las=2)
# 
# ggplot(top_ten,aes(y=meddra_concept_name,x=mean,color=meddra_concept_name))+geom_bar(stat="identity", fill="white") +
#     ggtitle("Side Effects With Highest Ave. odds Ratio") +
#     ylab(NULL) + xlab("Average Odds Ratio")

# Close connection --------------------------------------------------------

kidsides::disconnect_sqlite_db(con)
