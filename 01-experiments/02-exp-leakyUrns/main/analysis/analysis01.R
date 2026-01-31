## Exp2 leaky urns

# CSP preamble

# load packages
library(tidyverse)
library(ggbeeswarm)
library(brms)
library(tidyboot)
library(tidyjson)
library(tidybayes)
library(patchwork)
library(GGally)
library(cowplot)
library(BayesFactor)
library(aida)   # custom helpers: https://github.com/michael-franke/aida-package
library(faintr) # custom helpers: https://michael-franke.github.io/faintr/index.html
library(cspplot)
library(knitr)
library(ggplot2)
library(ggstance)

##################################################

# these options help Stan run faster
options(mc.cores = parallel::detectCores(),
        brms.backend = "cmdstanr")

# use the CSP-theme for plotting
theme_set(theme_csp())

# global color scheme from CSP
project_colors = cspplot::list_colors() |> pull(hex)

# setting theme colors globally
scale_colour_discrete <- function(...) {
  scale_colour_manual(..., values = project_colors)
}

scale_fill_discrete <- function(...) {
  scale_fill_manual(..., values = project_colors)
}

##################################################

# Data
raw <- read.csv("01-experiments/02-exp-leakyUrns/pilot1/data/test_data.csv")
glimpse(raw)

# Preprocessing
full <- raw

full$delay <- factor(full$delay, levels = c("short", "medium", "long"))

# Exlusion
# must pass at least 2 attention checks (out of 3)
attentionThreshold <- 2
# Multiple responses
# more than 23 responses would be double responses

# Comprehension & Attention
full <- full %>% mutate(comprehensionCorrect = ifelse(is.na(comprehensionCorrectResponse), NA, comprehensionCorrectResponse == comprehensionResponse))
full <- full %>% mutate(attentionCorrect = ifelse(is.na(attentionCorrectResponse), NA, attentionCorrectResponse == attentionResponse))

getComprehensionPass <- function(id) {
  participant <- full %>% filter(prolific_pid == id)

  comprehensionChecks <- participant %>%
    filter(trialType %in% c("comprehension-1", "comprehension-2")) %>%
    group_by(trialType) %>%
    summarise(all_correct = all(comprehensionCorrect, na.rm = TRUE), .groups = "drop") %>%
    arrange(trialType) %>%
    pull(all_correct)

  trainingAttentionCheck <- participant %>%
    filter(trialType == "training-attention") %>%
    summarise(all_correct = sum(attentionCorrect), .groups = "drop") %>%
    pull(all_correct)

  criticalAttentionCheck <- participant %>%
    filter(trialType == "critical-attention") %>%
    summarise(all_correct = sum(attentionCorrect), .groups = "drop") %>%
    pull(all_correct)

  tibble(
    comprehensionCheck = if (comprehensionChecks[1]) TRUE else comprehensionChecks[2],
    trainingAttentionCheck = trainingAttentionCheck,
    criticalAttentionCheck = criticalAttentionCheck,
    excluded = ifelse((if (comprehensionChecks[1]) TRUE else comprehensionChecks[2]) & criticalAttentionCheck >= attentionThreshold, FALSE, TRUE)
  )
}

correct_df <- map_dfr(full$prolific_pid, getComprehensionPass)
full <- bind_cols(full, correct_df)
glimpse(full)

## Comprehension check
# How many didn't pass at least one round of the comprehension check?
full %>%
  filter(!comprehensionCheck) %>%
  distinct(prolific_pid) %>%
  nrow()

## Attention check
# How many failed more than one attention check?
full %>%
  filter(!(criticalAttentionCheck >= attentionThreshold)) %>%
  distinct(prolific_pid) %>%
  nrow()

# Final DF
final_sample <- full %>% filter(!excluded)

# N after exclusion
final_sample %>% distinct(prolific_pid) %>% nrow()


# Visualisations
conj <- final_sample %>% filter(structure == "conjunctive")
disj <- final_sample %>% filter(structure == "disjunctive")

## Conjunctive

## Disjunctive


## Statistical Analysis