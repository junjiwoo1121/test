---
title: "Predictive Analytics"
subtitle: "Missing Data R Session"  
author: "Zhiyu (Frank) Quan"
institute: "University of Illinois Urbana-Champaign"
#date: "2022/04/01 (updated: `r Sys.Date()`)"
output:
  xaringan::moon_reader:
    css: xaringan-themer.css
    nature:
      slideNumberFormat: "%current%"
      highlightStyle: github
      highlightLines: true
      ratio: 16:9
      countIncrementalSlides: true
---

```{r setup, include=FALSE}
options(htmltools.dir.version = FALSE)
knitr::opts_chunk$set(
  fig.width=9, fig.height=3.5, fig.retina=3,
  out.width = "100%",
  cache = FALSE,
  echo = TRUE,
  message = FALSE, 
  warning = FALSE,
  hiline = TRUE
)
```

```{r xaringan-themer, include=FALSE, warning=FALSE}
library(xaringanthemer)
style_duo_accent(
  primary_color = "#13294B",
  secondary_color = "#DD3403",
  inverse_header_color = "#00000",
  text_font_size = "27px",
)

```


### Load Data

```{r, warning=FALSE}
RNGkind(sample.kind = "Rounding") # Uncomment if running R 3.6.x or later
# Load packages and data

# Load packages
library(plyr)
library(dplyr)
# Load data
data_all <- read.csv(file = "June 16 data.csv")
cat_vars <- c("gender", "age", "race", 
              "weight", "admit_type_id", 
              "metformin", "insulin", "readmitted")
num_vars <- c("num_procs", "num_meds", "num_ip", 
              "num_diags")
data_all$admit_type_id <- as.factor(data_all$admit_type_id)

```

---


### SOA TASK 1 - Edit the data for missing and invalid data

***Most candidates successfully identified and made adjustments to missing and invalid data. To earn full points, candidates had to make appropriate adjustments and provide a clear rationale for their decisions.***

---

### Objective

- The following data adjustments are needed:
  - Remove the unknown/invalid `gender` rows
  - Examine the missing race values further to see if there is evidence they are not missing at random. If not, we could either remove the missing rows or regroup the race variable so `?/other` is in the same category. Otherwise, create a separate category for missing and another for `other` or combine in another way.
  - Remove the `weight` variable
  - `admit_type_id = 4` for some records, which means the admit type was unavailable, similar to a missing value. Examine similarly to race. Change `admit_type_id` to factor variable.

---

#### Removing observations with invalid genders.

```{r}
data_all <- subset(data_all, gender != "Unknown/Invalid")
unique(data_all$gender)
data_all$gender <- as.factor(data_all$gender)
sort(table(data_all$gender), decreasing = TRUE)
```

***There were 3 unknown/invalid values for the gender variable. Because there were only 3 records out of 10,000 total records, these rows were removed from the data.***

---

#### Below, I examine the relationship of missing values for the `race` and `admit_type_id` variables vs the response variable.

```{r}
# race
data_all %>%
    group_by(race) %>%
    summarise(mean = mean(days), 
              median = median(days), n = n())
```

---

#### We do not know if the `race` variable is missing values at random or not. The output above provides further evidence that the missingness may be meaningful because the missing race has one of the highest mean days. Regroup the variable, so Asian, Hispanic, and Other are in the same category.

```{r}
sort(table(data_all$race), decreasing = TRUE)
data_all$race <- as.factor(data_all$race)
```

---

```{r}
var.levels <- levels(data_all$race)
var.levels
data_all$race <- mapvalues(
  data_all$race, var.levels,
  c("Missing","AfricanAmerican", "Other", "Caucasian", "Other", "Other")
)

rm(var.levels)

sort(table(data_all$race), decreasing = TRUE)
```

- Regroup the levels of the `race` variable. Asian, Hispanic, and Other will be in the same category.

---

#### ***The race variable contained 226 missing values. Similar to the admin_type_id missing data, we do not know if these are missing because of a data collection error or if the race is routinely unknown. Because we do not know whether it is missing at random, we should keep the variable and see whether the missing race has predictive power. A new race category was created called “Missing.” I also combined the “Asian”, “Hispanic”, and “Other” levels because they each had somewhat low frequencies and similar relationships to the days variable.***

---

```{r}
# admit_type_id
data_all %>%
    group_by(admit_type_id) %>%
    summarise(
      mean = mean(days),
      median = median(days),
      n = n()
    )

```

- We do not know if the `admit_type_id` variable is missing values at random or not. The output above provides evidence that the missingness may be meaningful because `admit_type_id = 4` (4 = Not available) has the lowest mean days.

---

#### ***The admin_type_id variable was coded as a numeric variable. Since the numeric values are codes representing categorical data, the variable was changed to a factor variable. There were 1,021 records where the admission type was unavailable, which could be viewed as missing. We do not know if these are missing because of a data collection error or if the admission type is routinely unavailable. Because we do not know whether it is missing at random, we should keep it and see whether it being unavailable has predictive power.***

---

```{r}
data_all$weight <- NULL
```

- Removing the weight variable.

***There were 9,691 records with missing values for the weight variable. Because most of the weight data was missing, the variable was removed from the dataset.***


---

```{r}
str(data_all)

cat_vars = cat_vars[!cat_vars %in% c("weight")]
cat_vars

```

---

```{r}
data_all = data_all %>% mutate_if(is.character, as.factor)
str(data_all)
```

---

```{r}
summary(data_all)
```

---

#### Relevel factor variables, including admit_type_id.

***The factor variable levels were reordered so that the most frequent level was first.***

```{r}
vars <- c("gender", "age", "race",
          "metformin", "insulin",
          "readmitted", "admit_type_id")
# Change list of factor variables to relevel as needed
for (i in vars) {
  table <- as.data.frame(table(data_all[, i]))
  max <- which.max(table[, 2])
  level.name <- as.character(table[max, 1])
  data_all[, i] <- relevel(data_all[, i], ref = level.name)
}
```

---

```{r}
summary(data_all)
```

---

```{r}
rm(vars)
```

Clean code and maintain good habits.

---

***The num_meds variable had values ranging from 1 to 67. It seems unlikely that in a large dataset there would be no individuals that took 0 medications in the prior year. This is suspicious and should be investigated because it could be an indicator of invalid data, but the values look reasonable aside from that, so I will use the variable without alterations.***

***After the changes 9,997 records remained in the dataset.***

---

## Missing Data


```{r}
library(finalfit)
data_raw <- read.csv(file = "June 16 data.csv")
data_raw$admit_type_id <- as.factor(data_raw$admit_type_id)
data_raw = data_raw %>% mutate_if(is.character, as.factor)

levels(data_raw$gender)[levels(data_raw$gender)=='Unknown/Invalid'] <- NA
levels(data_raw$race)[levels(data_raw$race)=='?'] <- NA
levels(data_raw$weight)[levels(data_raw$weight)=='?'] <- NA
levels(data_raw$admit_type_id)[levels(data_raw$admit_type_id)== 4] <- NA

sum(is.na(data_raw))

ResponseName  <-  "days"
ExplanatoryNames = names(data_raw)[names(data_raw) != ResponseName]
MissingExplanatoryNames = c("gender", "race", "weight", "admit_type_id")
```

---

```{r}
data_raw %>%
  ff_glimpse(ResponseName, ExplanatoryNames)
```

---

#### It doesn’t present well if you have factors with lots of levels, so you may want to remove these.

---

```{r}
data_raw %>%
  select(gender, race, weight, admit_type_id) %>%
  ff_glimpse()
```

---

```{r}
data_raw %>%
  select(gender, race, weight, admit_type_id) %>%
  missing_plot()
```

---

In detecting patterns of missingness, this plot is useful. Row number is on the x-axis and all included variables are on the y-axis. Associations between missingness and observations can be easily seen, as can relationships of missingness between variables. Check out other packages like `naniar` and `mice` for visualizations for missing data.

---

```{r}
data_raw %>%
  missing_pattern(ResponseName, ExplanatoryNames)
```

---

This produces a table and a plot showing the pattern of missingness between variables. This allows us to look for patterns of missingness between variables. The number and pattern of missingness help us to determine the likelihood of it being random rather than systematic.

---

```{r}
data_raw %>%
  summary_factorlist(ResponseName, ExplanatoryNames,
  na_include=TRUE, p=TRUE)
```

---

This function provides a useful summary of a response variable against explanatory variables. `na_include=TRUE` ensures missing data from the explanatory variables (but not response) are included. Note that any p-values are generated across missing groups as well, so run a second time with `na_include=FALSE` if you wish a hypothesis test only over observed data.

---

```{r}
data_raw %>%
  summary_factorlist(ResponseName, MissingExplanatoryNames,
  na_include=TRUE, p=TRUE)
```

---

```{r}
data_raw %>%
  summary_factorlist(ResponseName, MissingExplanatoryNames,
  na_include=FALSE, p=TRUE)
```

---

In deciding whether data is MCAR or MAR, one approach is to explore patterns of missingness between levels of included variables. This is particularly important for a primary outcome measure / response variable.

---

```{r}
data_raw %>%
  missing_pairs(ResponseName, ExplanatoryNames)
```

---

```{r}
data_raw %>%
  missing_pairs(ResponseName, MissingExplanatoryNames)
```

---

- It produces pairs plots to show relationships between missing values and observed values in all variables.
- For continuous variables, the distributions of observed and missing data can be visually compared.
- For discrete, data, counts are presented by default. It is often easier to compare proportions:

---

```{r}
data_raw %>%
  missing_pairs(ResponseName, MissingExplanatoryNames, position = "fill")
```

---

```{r}
explanatory = c("num_diags", "insulin")
dependent = "race"
data_raw %>%
  missing_compare(dependent, explanatory) %>%
    knitr::kable(row.names=FALSE, align = c("l", "l", "r", "r", "r"))
```

---

- It takes `dependent` and `explanatory` variables, but in this context `dependent` just refers to the variable being tested for missingness against the `explanatory` variables.
- Comparisons for continuous data use a Kruskal Wallis and for discrete data a chi-squared test.
- `race` is not MCAR respect to `insulin` and `num_diags`


---

```{r}
# library(finalfit)
# library(dplyr)
# library(MissMech)
# explanatory = c("num_diags", "insulin")
# dependent = "race"
#
# data_raw %>%
#   select(explanatory) %>%
#   MissMech::TestMCARNormality()

```


---

If you work predominately with numeric rather than categorical data, you may find these tests from the `MissMech` package useful. The package and output is well documented, and provides two tests that can be used to determine whether data are MCAR.

---

#### MCAR vs MAR

- Depending on the number of data points that are missing, we may have sufficient power with complete cases to examine the relationships of interest.
- Complete case analysis will be performed by default in standard regression analyses including `finalfit`.

---

```{r}
data_raw %>%
  finalfit(ResponseName, ExplanatoryNames) %>%
    knitr::kable(row.names=FALSE, align = c("l", "l", "r", "r", "r", "r"))
```

---

#### Other considerations

- Sensitivity analysis
- Omit the variable
- Factors with new level for missing data
- Imputation
- Model the missing data

---

#### Sensitivity analysis

If the variable in question is thought to be particularly important, you may wish to perform a sensitivity analysis. A sensitivity analysis in this context aims to capture the effect of uncertainty on the conclusions drawn from the model. Thus, you may choose to re-label all missing values as one of the existing level, and see if that changes the conclusions of your analysis.

---

#### Imputation

`mice` is our go to package for multiple imputation. Imputation is not usually appropriate for the explanatory variable of interest or the response variable. In both cases, the hypothesis is that there is a meaningful association with other variables in the dataset, therefore it doesn’t make sense to use these variables to impute them.

---

#### Omit or Imputation

`finalfit::missing_predictorMatrix()` provides an easy way to include or exclude variables to be imputed or to be used for imputation.

```{r}
library(finalfit)
library(dplyr)
library(mice)

data_raw %>%
  select(ResponseName, ExplanatoryNames) %>%
    missing_predictorMatrix(
        drop_from_imputed = c("weight", "days" )
        ) -> predM
```

---

```{r}
fits = data_raw %>%
  select(ResponseName, ExplanatoryNames) %>%
  mice(m = 10, predictorMatrix = predM) %>%
  # Run regression on each imputed set
  with(glm(formula(ff_formula(ResponseName, ExplanatoryNames)),
    family="gaussian"))
```

---

```{r}
fits %>%
    getfit() %>%
    purrr::map(AIC)
```

---

```{r}
fits_pool = fits %>%
  pool()
```

---

```{r}
data_raw %>%
    coefficient_plot(ResponseName, ExplanatoryNames, glmfit = fits_pool, table_text_size=3.5)
```


---


- As above, if the variable does not appear to be important, it may be omitted from the analysis. A sensitivity analysis in this context is another form of imputation. But rather than using all other available information to best-guess the missing data, we simply assign the value as above. Imputation is therefore likely to be more appropriate.

- There is an alternative method to model the missing data for the categorical in this setting – just consider the missing data as a factor level. This has the advantage of simplicity, with the disadvantage of increasing the number of terms in the model. Multiple imputation is generally preferred.

---

#### MNAR vs MAR

There is no easy way to handle this. If at all possible, try to get the missing data. Otherwise, take care when drawing conclusions from analyses where data are thought to be missing not at random.



