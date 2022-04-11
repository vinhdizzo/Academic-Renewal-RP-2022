# Background

Title 5 regulations [stipulates](https://govt.westlaw.com/calregs/Document/I8220807006CC11E3AAD4AB9A1743D04A?contextData=(sc.Search)&rank=1&originationContext=Search+Result&navigationPath=Search%2Fv3%2Fsearch%2Fresults%2Fnavigation%2Fi0ad600560000014b9f22cb1db422319d%3FstartIndex%3D1%26Nav%3DREGULATION_PUBLICVIEW%26contextData%3D(sc.Default)&list=REGULATION_PUBLICVIEW&transitionType=SearchItem&listSource=Search&viewType=FullText&t_T1=5&t_T2=55046&t_S1=CA+ADC+s) that California community colleges must adopt policies on academic renewal.

The following are eligibility requirements for academic renewal at one district:

1. A petition must be filed in the Office of Admissions and Records. The Registrar or Dean of Enrollment Services is the designated authority for approval of academic renewal.
2. Accompanying the petition must be evidence that the previous substandard work does not reflect the student’s current performance or capabilities.
3. Previous substandard work will be disregarded. Substandard grades are defined as "D," "F," "FW," or "NP."
4. No more than 30 units of coursework can be considered for academic renewal.
5. A period of at least two terms must have elapsed since the work to be alleviated was completed.
6. The student must have completed 18 units with a 2.00 GPA, 15 units with a 2.25 GPA or 12 units with a 2.5 GPA or higher in sessions subsequent to the substandard work. No units may be excluded for coursework that has previously been used to fulfill degree, certificate, or transfer certification requirements. Work from other accredited colleges will be considered for calculating their GPA.
7. When coursework is disregarded in the computation of the cumulative GPA, the student’s academic record will be annotated; all coursework remains on record, ensuring a true and complete academic history. Academic renewal actions are irreversible.

# Repo Description: Data and Code

This repo includes sample transcript data and code that illustrates the logic for identifying courses and students eligible for academic renewal:

- `01_Determine_Academic_Renewal.R`: R code that ingests the sample transcript data, determines eligible courses for academic renewal, and exports an annotated transcript data set.
- `Sample Transcript.csv`: sample transcript data.
- `Sample Transcript With Academic Renewal.csv`: sample annotated transcript data.  The variable `Academic_Renewal_Qualify_Flag` indicates (`=1`) which courses are eligible for academic renewal.

# Comments

The sample code implements the policy described in the background section, with one caveat.  For bullet 6, the code only considers the 12 units with a 2.5 GPA scenario instead of all 3 scenarios in order to simplify the tutorial.

The R code presented worked with with an R session with the following packages and versions:
```{r}
> sessionInfo()
R version 4.0.2 (2020-06-22)
Platform: x86_64-w64-mingw32/x64 (64-bit)
Running under: Windows 10 x64 (build 19042)

Matrix products: default

locale:
[1] LC_COLLATE=English_United States.1252 
[2] LC_CTYPE=English_United States.1252   
[3] LC_MONETARY=English_United States.1252
[4] LC_NUMERIC=C                          
[5] LC_TIME=English_United States.1252    

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
[1] readr_1.3.1          dplyr_1.0.8          RevoUtils_11.0.2    
[4] RevoUtilsMath_11.0.0

loaded via a namespace (and not attached):
 [1] Rcpp_1.0.5       fansi_1.0.2      utf8_1.2.2       crayon_1.5.0    
 [5] R6_2.3.0         lifecycle_1.0.1  magrittr_2.0.2   pillar_1.7.0    
 [9] rlang_1.0.1      cli_3.2.0        vctrs_0.3.8      generics_0.1.2  
[13] ellipsis_0.3.2   tools_4.0.2      glue_1.6.1       purrr_0.3.4     
[17] hms_0.5.3        compiler_4.0.2   pkgconfig_2.0.3  tidyselect_1.1.2
[21] tibble_3.1.6    
```

