#######################################################################
#######  Heat map for H. pylori antigen sero-intensities and measures of white matter integrity across Alzheimer's Disease polygenic risk level
#######  Mission: Plot the betas   
#######  Programmer: Yi-Han Hu
#######  Date: Dec. 2 2022
#######  Final Update: Jan. 26 2023
#######  Revision based on reviewer: Mar. 28 2024
#######################################################################

op <- options(nwarnings = 10000)
# --------------------------------------
# Specify working directory where the script and data files are
# --------------------------------------
WorkingDirectory = "your directory"

# --------------------------------------
# Set working directory
# --------------------------------------
setwd(WorkingDirectory)

# --------------------------------------
# Turn off scientific notation
# --------------------------------------
options(scipen=999)

# --------------------------------------
# Install/load the packages
# --------------------------------------
library(readxl) #read excel file.
library(readr) # read SAS file.
library(haven) # read SAS, DTA file.
library(tidyr) 
library(dplyr)
library(janitor) #Making two-way table
library(stringr)
library(broom)
library(stats)
library(ggplot2)
library(RColorBrewer)
library(purrr)
library(data.table)

# ---------------------------------------------------------------------------------------------#
# ---------------------------------------------------------------------------------------------#
# ---------------------------------- Part 1 Data preprocess -----------------------------------#
# ---------------------------------------------------------------------------------------------#
# ---------------------------------------------------------------------------------------------#
# --------------------------------------
# Load data:
# --------------------------------------
DprimeADPGS_FA_MD <- read_dta("Data/zOutputdata_overall_DprimeADPGS_FA_MD.dta")
dim(DprimeADPGS_FA_MD)
head(DprimeADPGS_FA_MD)

DprimeADPGS_FA_MD <- DprimeADPGS_FA_MD %>% 
  rowwise() %>% 
  mutate(ROI = gsub("regr z...(.+) z.*", "\\1",command),
         predictor = gsub("zLnhpylori(.+)", "\\1",parm))


# ---------------------------------------------------------------------------------------------#
# ---------------------------------------------------------------------------------------------#
# ------------------------------------- Part 2 Heat maps --------------------------------------#
# ---------------------------------------------------------------------------------------------#
# ---------------------------------------------------------------------------------------------#
# --------------------------------------
# Heatmap for FA and MD
# --------------------------------------
heatmap <- function(data, FA.outcome = 1, hide.unsig = TRUE){
  myPalette <- colorRampPalette(rev(brewer.pal(11, "Spectral")))
  if (FA.outcome == 1){
    outcome = "FA"
    } else if(FA.outcome == 0){
      outcome = "MD"
    }
  
  data.long <-data %>% 
    mutate(ap=ifelse(p < 0.01, 1,
                     ifelse(p >= 0.01 & p < 0.05, 2, 3)),
           term_new = paste("PGS", AD_PGStert, "_", predictor, sep = ""),
           aq=ifelse(p < 0.05 , "Pass", "insig"),
           bg.line=ifelse(AD_PGStert==1, "Dark Grey",
                          ifelse(AD_PGStert==3, "Dark Grey", "White")),
           bg.color=ifelse(AD_PGStert==1, "White",
                           ifelse(AD_PGStert==3, "White", "Dark Grey")))%>% 
    arrange(desc(ROI), AD_PGStert, predictor) %>% 
    filter(FA == FA.outcome)
  
  if (hide.unsig == TRUE){
    p.plot <- ggplot(data = data.long, aes(x = factor(term_new), y = factor(ROI)))+
      geom_tile(color = data.long$bg.line, fill = data.long$bg.color)+
      geom_point(aes(shape=factor(aq),
                     size=factor(ap), 
                     fill=estimate))+
      scale_shape_manual(values=c(1, 21), guide = "none")+
      scale_fill_gradientn(colours = myPalette(100), aesthetics = c("colour","fill"))+
      scale_size_manual(values=c(6, 4, 2), labels = c("< 0.01", "< 0.05", "\u2265 0.05"))+
      labs(title=paste("Heatmap (H. pylori and ", outcome,")", sep = ""),
           subtitle=paste("Stratified by PGS tertiles", "", sep = ""),
           x="H. pylori antigen sero-intensities by PGS strata",
           y="Brain ROI (48 tracts + global)",
           size=paste("p-value"), fill=(expression(paste(beta," coefficients"))))+
      #, caption="any caption")+
      theme(plot.title = element_text(color="Dark blue", size=15, face="bold", hjust = 0.5),
            plot.subtitle=element_text(size=14, hjust=0.5,  color="Dark blue"),
            plot.caption=element_text(size=10, hjust=0.5, color="Dark grey"),
            axis.title.x = element_text(color="deepskyblue", size=13, face="bold"),
            axis.text.x = element_text(angle = 45, vjust = 1, size = 12, hjust = 1),
            aspect.ratio=7/4)+
      coord_fixed()
  } else if (hide.unsig == FALSE){
    p.plot <- ggplot(data = data.long, aes(x = factor(term_new), y = factor(ROI)))+
      geom_tile(color = data.long$bg.line, fill = data.long$bg.color)+
      geom_point(aes(size=factor(ap), 
                     fill=estimate),shape=21)+
      scale_fill_gradientn(colours = myPalette(100), aesthetics = c("colour","fill"))+
      scale_size_manual(values=c(6, 4, 2), labels = c("< 0.01", "< 0.05", "\u2265 0.05"))+
      labs(title=paste("Heatmap (H. pylori and ", outcome,")", sep = ""),
           subtitle=paste("Stratified by PGS tertiles", "", sep = ""),
           x="H. pylori antigen sero-intensities by PGS strata",
           y="Brain ROI (48 tracts + global)",
           size=paste("p-value"), fill=(expression(paste(beta," coefficients"))))+
           #, caption="any caption")+
      theme(plot.title = element_text(color="Dark blue", size=15, face="bold", hjust = 0.5),
            plot.subtitle=element_text(size=14, hjust=0.5, color="Dark blue"),
            plot.caption=element_text(size=10, hjust=0.5, color="Dark grey"),
            axis.title.x = element_text(color="deepskyblue", size=13, face="bold"),
            axis.text.x = element_text(angle = 45, vjust = 1, size = 12, hjust = 1),
            aspect.ratio=7/4)+
      coord_fixed()
  }
  return(p.plot)
}

FA.hide.unsig <- heatmap(data = DprimeADPGS_FA_MD, FA.outcome = 1, hide.unsig = TRUE)
FA <- heatmap(data = DprimeADPGS_FA_MD, FA.outcome = 1, hide.unsig = FALSE)
MD.hide.unsig <- heatmap(data = DprimeADPGS_FA_MD, FA.outcome = 0, hide.unsig = TRUE)
MD <- heatmap(data = DprimeADPGS_FA_MD, FA.outcome = 0, hide.unsig = FALSE)


ggsave(paste(WorkingDirectory,"Output//plot//FA_hide_unsig_forRevision.jpeg",sep=""), FA.hide.unsig, width = 8.5, height = 11, units = "in", dpi = 300)
ggsave(paste(WorkingDirectory,"Output//plot//FA_forRevision.jpeg",sep=""), FA, width = 8.5, height = 11, units = "in", dpi = 300)
ggsave(paste(WorkingDirectory,"Output//plot//MD_hide_unsig_forRevision.jpeg",sep=""), MD.hide.unsig, width = 8.5, height = 11, units = "in", dpi = 300)
ggsave(paste(WorkingDirectory,"Output//plot//MD_forRevision.jpeg",sep=""), MD, width = 8.5, height = 11, units = "in", dpi = 300)
