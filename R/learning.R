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
  select(starts_with("bp")) %>%
  rename(bp_systolic = bp_sys_ave)

# Filtering. You have to use logical operators, which are listed on the website.

nhanes_small %>%
  filter(phys_active != "No")

nhanes_small %>%
  filter(bmi >= 25)

# Combining logical operators
nhanes_small %>%
  filter(bmi >= 25 & phys_active == "No")

nhanes_small %>%
  filter(bmi >= 25 | phys_active == "No")

# Arrange data. You can use the desc() function for descending, and just arrange for ascending.
nhanes_small %>%
  arrange(desc(age))

nhanes_small %>%
  arrange(education, age)

# Transforming data. The mutate() function does this. In this case you transform a column that already exists, here it's age * 12, which changes the column age to months.
nhanes_small %>%
  mutate(
    age = age * 12,
    logged_bmi = log(bmi)
  )

nhanes_small %>%
  mutate(old = if_else(age >= 30, "Yes", "No"))


# Exercise 7.12 -----------------------------------------------------------


# Doing exercise 7.12 - Just a note. I named it mean_bp instead of mean_arterial_pressure.
nhanes_small
# 1. BMI between 20 and 40 with diabetes
nhanes_small %>%
    # Format should follow: variable >= number or character
    filter(bmi >= 20 & bmi <= 40 & diabetes == "Yes")

# Pipe the data into mutate function and:
nhanes_modified <- nhanes_small %>% # Specifying dataset
    mutate(
        # 2. Calculate mean arterial pressure
        mean_bp = ((2 * bp_dia_ave) + bp_dia_ave/3),
        # 3. Create young_child variable using a condition
        young_child = if_else(age <= 6, "Yes", "No"))


nhanes_modified


# Back to code-alongs -----------------------------------------------------

# Create summary statistics. Very importantly is to tell the function to ignore the missing values, which is the na.rm = TRUE argument.
nhanes_small %>%
    summarise(max_bmi = max(bmi, na.rm = TRUE),
              min_bmi = min(bmi, na.rm = TRUE))

# the filtering function in the following code takes everything that is NOT (!) NA-values from the diabetes column, before the following functions (the group and statistical arguments, in this case the means)

nhanes_small %>%
    filter(!is.na(diabetes)) %>%
    group_by(diabetes) %>%
    summarize(mean_age = mean(age, na.rm = TRUE),
              mean_bmi = mean(bmi, na.rm = TRUE)) %>%
    ungroup()

# The ungroup() function at the end of the code, doesn't do anything for this particular code, but IT'S GOOD PRACTICE!
# You should always do it.

# Saving data
readr::write_csv(nhanes_small,
                 here::here("data/nhanes_small.csv"))

