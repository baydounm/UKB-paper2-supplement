This repository is for the manuscript entitled, *Helicobacter pylori sero-positivity, persistent infection burden and their association with brain volumetric and white matter integrity outcomes*,  which investigates the association of *Helicobacter pylori (Hp)* with dementia pathology and other neurodegenerative diseases. 

Below is the file structure of the repository. 

Figure 2 folder refers to all the files used to create Figure 2, including FSLEYES nii.gz files and xml labels file used for specifying tracts and ROIs. The overlays include all labels and labels used for FA and MD results for Figure 2. *.png files are the image files obtained from FSLEYES after overlaying ROIs on the MNI152 brain template.

Figure 3 folder refers to all the files used for the heatmap of Figure 3, including the R script, the dataset used and the heatmap images *.jpeg. 

STATA_SYNTAX includes the *.do file used for the entire analysis. A directory needs to be specified and a similar UK biobank dataset (with equivalent fields) is needed to run this analysis. 

├── FIGURE2  
│   ├── BRAINIMAGE_ATLAS  
│   │   ├── JHU  
│   │   └── JHU-labels.xml  
│   ├── BRAINIMAGE_MNI152  
│   │   └── MNI152_T1_1mm.nii.gz  
│   ├── BRAINIMAGE_OVERLAYS  
│   │   ├── ALL_LABELS  
│   │   ├── FA  
│   │   └── MD  
│   ├── FIGURE2_ALLROIS.png  
│   ├── FIGURE2_GroeL_FA_SCP_L.png  
│   ├── FIGURE2_OMP_FA_ICP_R.png  
│   ├── FIGURE2_OMP_MD_SEVERALROIs.png  
│   ├── FIGURE2_VacA_FA_SCP_RL.png  
│   ├── FIGURE2_VacA_MD_ICP_L.png  
│   └── FSLEYES_ALL_IMAGES.txt  
├── FIGURE3  
│   ├── FA_hide_unsig.jpeg  
│   ├── HEATMAP_RSCRIPT_UKB2.R  
│   ├── MD_hide_unsig.jpeg  
│   └── zOutputdata_overall_DprimeADPGS_FA_MD.dta  
├── README.md  
└── STATA_SYNTAX  
    └── UKB_PAPER2_HPYLORIMRI_FINAL_GITHUB.do  
  
  




