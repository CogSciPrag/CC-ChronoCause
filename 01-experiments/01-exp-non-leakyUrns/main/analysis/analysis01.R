## Exp1 non-leaky urns

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
raw <- read.csv("01-experiments/01-exp-non-leakyUrns/main/data/results_150.csv")
glimpse(raw)

# Check if someone submitted more than once (32 is the max num. of rows per response)
raw %>%
  count(prolific_pid) %>%
  filter(n > 32)

# Preprocessing
full <- raw

# recode response left and right according to which urn was prompted first
# full <- full %>%
#   mutate(
#     tmp = responseLeft,
#     responseLeft = if_else(whichUrnPromptedFirst == "left", responseLeft, responseRight),
#     responseRight = if_else(whichUrnPromptedFirst == "left", responseRight, tmp)) %>%
#   select(-tmp)
#
# code early and late and the delta between the two ($\Delta$ of ‘causal rating of later-occurring event’ - ‘causal rating of earlier-occurring event’)
full <- full %>% mutate(responseEarly = ifelse(delayedUrn == "none", NA, ifelse(delayedUrn == "left", responseRight, responseLeft)))
full <- full %>% mutate(responseLate = ifelse(delayedUrn == "none", NA, ifelse(delayedUrn == "left", responseLeft, responseRight)))
full <- full %>% mutate(delta = responseLate - responseEarly)
full <- full %>% mutate(combo = paste(earlyBall, lateBall, sep = "-"))

full$delay <- factor(full$delay, levels = c("simult", "short", "medium", "long"))

# Exlusion
# must pass at least 3 attention checks (out of 4)
attentionThreshold <- 3
# Multiple responses
# more than X responses would be double responses

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

# N before exlusion
full %>% distinct(prolific_pid) %>% nrow()

# Final DF
final_sample <- full %>% filter(!excluded)

# N after exclusion
final_sample %>%
  distinct(prolific_pid) %>%
  nrow()

# Visualisations
# long-form dataframe for analyses grouping by early/late
full_long <- pivot_longer(final_sample, cols = c("responseEarly", "responseLate"), names_to = "which_ball_EL", values_to = "causal_val")
# long-form dataframe for analyses grouping by left/right
full_long_LR <- pivot_longer(final_sample, cols = c("responseLeft", "responseRight"), names_to = "which_ball_LR", values_to = "causal_val")

# conjunctive/disjunctive-only versions
conj <- final_sample %>% filter(structure == "conjunctive")
disj <- final_sample %>% filter(structure == "disjunctive")

conj_long <- full_long %>% filter(structure == "conjunctive")
disj_long <- full_long %>% filter(structure == "disjunctive")
conj_LR <- full_long_LR %>% filter(trialType == "critical" & structure == "conjunctive")
disj_LR <- full_long_LR %>% filter(trialType == "critical" & structure == "disjunctive")

## Conjunctive
conj_long %>%
  filter(trialType == "critical") %>%
  filter(delay != "simult") %>%
  ggplot(aes(x = delay, y = delta, fill = delay)) +
  stat_summary(fun = mean, geom = 'bar', width = 1.0) +
  scale_y_continuous(breaks = -7:7) +
  stat_summary(fun.data = "mean_se", geom = "errorbar", width = 0.5, linewidth = 0.6, colour = project_colors[2]) +
  scale_fill_manual(values = c(project_colors[1], project_colors[3], project_colors[4]), name = 'delay length') +
  facet_wrap(~combo) +
  labs(y = 'Delta (late - early)', title = "Conjunctive", subtitle = 'CORRECT VISUALISATION')+
    theme(
    plot.subtitle = element_text(color = "green")
  )


xx <- conj %>% filter(combo=='solid-solid')

xyGrid <- expand.grid(sort(unique(xx$responseEarly)), sort(unique(xx$responseLate)))
xyGrid.freq <- as.numeric(xtabs(~responseEarly + responseLate, data = xx))

# xyFreq <- as.data.frame(xtabs(~responseEarly + responseLate + group, data = conj))

xyFreq <- data.frame(r_early = xyGrid[, 1], r_late = xyGrid[, 2], freq = xyGrid.freq)

xyFreq %>%
  ggplot(aes(r_early, r_late)) +
  geom_point(aes(size = freq)) +
  scale_size_area(max_size = 20) +
  scale_x_continuous(breaks = 1:7) +
  scale_y_continuous(breaks = 1:7) +
  geom_segment(aes(x = 0, y = 0, xend = 7, yend = 7),
               color = project_colors[2], linetype = "dashed", size = 1)


conj %>%
  ggplot(aes(responseEarly, responseLate)) +
  stat_sum(aes(size = after_stat(n))) +
  scale_size_area(max_size = 20) +
  scale_x_continuous(breaks = 1:7) +
  scale_y_continuous(breaks = 1:7) +
      labs(subtitle = 'WRONG VISUALISATION WITH THE BUG')+
    theme(
    plot.subtitle = element_text(color = "red")
    )+
  geom_segment(
    x = 0, y = 0, xend = 7, yend = 7,
    color = project_colors[2],
    linetype = "dashed",
    linewidth = 1,
    inherit.aes = FALSE
  ) +
  facet_wrap(~ combo) +
  coord_fixed()




## Disjunctive


## Statistical Analysis