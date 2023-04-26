# Load packages

library(tidyverse)
library(NHANES)

# Looking at data
glimpse(NHANES)

# Selecting different columns within the NHANES dataset. First argument is the dataset, subsequent arguments are the columns you want.
select(NHANES, Age)

select(NHANES, Age, Weight, BMI)

# using - removes every column except the one selected.
select(NHANES, -HeadCirc)

# Using tidyselect
select(NHANES, starts_with("BP"))

select(NHANES, ends_with("Day"))

select(NHANES, contains("Age"))

# Creating smaller NHANES dataset
nhanes_small <- select(
  NHANES, Age, Gender, BMI, Diabetes,
  PhysActive, BPSysAve, BPDiaAve, Education
)

# Renaming columns. Nice function to rename all columns at the same time: rename_with and snakecase::to_snake_case.So all snakecase does is tidy up the column names to small cases and using _ ; it basically just makes them easier to work with.
# When you provide a function in another function, you MUST NOT use parentheses (which is the case with snakecase)
nhanes_small <- rename_with(
  nhanes_small,
  snakecase::to_snake_case
)

# Renaming specific columns, You write the name you want = the name you're changing.
nhanes_small <- rename(nhanes_small, sex = gender)

# Trying out the pipe
colnames(nhanes_small)

nhanes_small %>%
  colnames()

nhanes_small %>%
  select(phys_active) %>%
  rename(physically_active = phys_active)

# Doing exercise 7.8
nhanes_small %>%
  select(bp_sys_ave, education)

nhanes_small %>%
  rename(
    bp_sys = bp_sys_ave,
    bp_dia = bp_dia_ave
  )

# Rewriting this code to contain a pipe
select(nhanes_small, bmi, contains("age"))

nhanes_small %>%
  select(bmi, age)

# Rewrite this with the pipe
blood_pressure <- select(nhanes_small, starts_with("bp_"))
rename(blood_pressure, bp_systolic = bp_sys_ave)

nhanes_small %>%
  rename(bp_systolic = bp_sys_ave)
