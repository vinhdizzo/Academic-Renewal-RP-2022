# Dependencies
library(dplyr)
library(readr)

# Assumptions
## Term: YYYYS, S=1, 2, 3 refers to spring, summer, fall
current_term <- 20221 # spring 2022
academic_renew_up_to_term <- 20212 # 2 terms must have past since non-satisfactory grades, so anything sooner than summer 2021
recent_earned_units_satisfactory <- 12
recent_satisfactory_gpa <- 2.5
grades_in_gpa_calc <- c('A', 'B', 'C', 'D', 'F', 'FW')
non_satisfactory_grades <- c('D', 'F', 'FW')
academic_renewal_unit_cap <- 30

# Ingest Data
d_transcript <- read_csv('Sample Transcript.csv')
dim(d_transcript)
head(d_transcript) %>% as.data.frame
table(d_transcript$Student_ID)

# Determine recent term for which each student is making satisfactory progress
d_term_eligible <- d_transcript %>%
  filter(IsExcludedFromCumulatives==0) %>%
  group_by(Student_ID, BK_TermCode) %>%
  summarize(Term_EarnedUnits=sum(EarnedUnits)
            , Term_GradePoints=sum(GradePoints)
            , Term_AttemptedUnits=sum(AttemptedUnits)
            ) %>%
  ungroup %>%
  arrange(Student_ID, desc(BK_TermCode)) %>%
  group_by(Student_ID) %>%
  mutate(
    rev_Cum_AttemptedUnits=cumsum(Term_AttemptedUnits)
    , rev_Cum_EarnedUnits=cumsum(Term_EarnedUnits)
    , rev_Cum_GradePoints=cumsum(Term_GradePoints)
    , rev_Cum_GPA=rev_Cum_GradePoints / rev_Cum_AttemptedUnits
    , Flag_Term_Earned_X_Units_Recent=ifelse((rev_Cum_EarnedUnits >= recent_earned_units_satisfactory) & (lag(rev_Cum_EarnedUnits, 1) < recent_earned_units_satisfactory | is.na(lag(rev_Cum_EarnedUnits, 1))), 1, 0)
    , Flag_Term_Qualify_Academic_Renewal_X_Units=ifelse(Flag_Term_Earned_X_Units_Recent == 1 & rev_Cum_GPA >= recent_satisfactory_gpa, 1, 0)
  ) %>%
  ungroup %>%
  filter(Flag_Term_Qualify_Academic_Renewal_X_Units == 1)

d_term_eligible %>% as.data.frame
## Note: only 2 students qualify meet the criteria of satisfactory progress on GPA and units earned in their latest terms.


# Flag eligible courses, incorporating the cap on academic renewal units
d_eligible_courses <- d_transcript %>%
  # Append the recent satisfactory progress term as only courses prior to this are eligible
  left_join(
    d_term_eligible %>%
    filter(Flag_Term_Qualify_Academic_Renewal_X_Units==1) %>% 
    select(Student_ID, BK_TermCode, rev_Cum_AttemptedUnits, rev_Cum_EarnedUnits, rev_Cum_GradePoints, rev_Cum_GPA) %>%
    rename(Qualify_TermCode=BK_TermCode)
  ) %>%
  mutate(Academic_Renewal_Qualify_Flag_Initial=ifelse(BK_GradeCode %in% non_satisfactory_grades & IsExcludedFromCumulatives==0 & BK_TermCode < Qualify_TermCode & BK_TermCode <= academic_renew_up_to_term, 1, 0) # This flags nonsatisfactory courses in eligible terms
         , Academic_Renewal_Qualify_Flag_Initial=ifelse(is.na(Academic_Renewal_Qualify_Flag_Initial), 0, Academic_Renewal_Qualify_Flag_Initial)
         ) %>% 
  group_by(Student_ID) %>%
  mutate(Past_Academic_Renewal_Units=sum(AttemptedUnits[Past_Academic_Renewal_Flag==1])) %>%
  arrange(Past_Academic_Renewal_Flag, desc(Academic_Renewal_Qualify_Flag_Initial), desc(BK_GradeCode), BK_TermCode) %>% # Prioritize: non academic renewal courses, eligible academic renewal courses, F before D, and earlier terms
  group_by(Student_ID, Past_Academic_Renewal_Units) %>%
  mutate(Future_Academic_Renewal_Limit=academic_renewal_unit_cap - Past_Academic_Renewal_Units # New limit accounting for past academic renewal units
        , Academic_Renewal_Qualify_Units_CumSum=cumsum(ifelse(Academic_Renewal_Qualify_Flag_Initial==1, AttemptedUnits, 0))
       , Academic_Renewal_Qualify_Flag=(Academic_Renewal_Qualify_Flag_Initial==1 & Academic_Renewal_Qualify_Units_CumSum <= Future_Academic_Renewal_Limit) * 1
    ) %>%
  ungroup %>%
  arrange(Student_ID, BK_TermCode, CourseID)
  

# Export flagged transcript
write.csv(d_eligible_courses, 'Sample Transcript With Academic Renewal.csv', row.names=FALSE, na='')
