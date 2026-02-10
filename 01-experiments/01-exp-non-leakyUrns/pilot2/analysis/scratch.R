knitr::opts_chunk$set(echo = TRUE)
knitr::opts_chunk$set(warning = FALSE, message = FALSE)

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
# set working directory if needed
# setwd("ADD_YOUR_PATH/CC-ChronoCause")
raw <- read.csv("01-experiments/01-exp-non-leakyUrns/pilot2/data/results01.csv")
glimpse(raw)
full <- raw

# define order for plotting purposes
full$delay <- factor(full$delay, levels = c("simult", "short", "medium", "long"))

# code early and late and the delta between the two ($\Delta$ of ‘causal rating of later-occurring event’ - ‘causal rating of earlier-occurring event’)
full <- full %>% mutate(responseEarly = ifelse(delayedUrn == "none", NA, ifelse(delayedUrn == "left", responseRight, responseLeft)))
full <- full %>% mutate(responseLate = ifelse(delayedUrn == "none", NA, ifelse(delayedUrn == "left", responseLeft, responseRight)))
full <- full %>% mutate(delta = responseLate - responseEarly)

# long-form dataframe for analyses grouping by early/late
full_long <- pivot_longer(full, cols = c("responseEarly", "responseLate"), names_to = "which_ball_EL", values_to = "causal_val")
# long-form dataframe for analyses grouping by left/right
full_long_LR <- pivot_longer(full, cols = c("responseLeft", "responseRight"), names_to = "which_ball_LR", values_to = "causal_val")

# conjunctive/disjunctive-only versions
conj <- full_long %>% filter(structure == "conjunctive")
disj <- full_long %>% filter(structure == "disjunctive")
conj_LR <- full_long_LR %>% filter(trialType == "critical" & structure == "conjunctive")
disj_LR <- full_long_LR %>% filter(trialType == "critical" & structure == "disjunctive")
conj %>%
  filter(trialType == "critical") %>%
  filter(delay != "simult") %>%
  ggplot(aes(x = which_ball_EL, y = causal_val, color = delay)) +
  stat_summary(fun = 'mean', position = position_dodge()) +
  stat_summary(fun = 'mean', geom = 'line', aes(group = delay), position = position_dodge()) +
  stat_summary(fun.data = 'mean_se', position = position_dodge()) +
  geom_jitter(aes(), position = position_jitterdodge(jitter.width = 0.4,
                                                     jitter.height = .2,
                                                     dodge.width = 0.8),
              color = 'black', alpha = .1) +
  scale_y_continuous(breaks = 1:7) +
  facet_wrap(~combo) +
  scale_color_manual(values = c(project_colors[1], project_colors[3], project_colors[4]), name = 'delay length') +
  labs(title = "Conjunctive")
conj %>%
  filter(trialType == "critical") %>%
  filter(delay != "simult") %>%
  mutate(delay = factor(delay, levels = c("short", "long"))) %>%
  ggplot(aes(x = which_ball_EL, y = causal_val, color = delay, group = delay)) +
  geom_point(size = 3, position = position_dodgev(height = 0.2)) +
  geom_line(size = 1, position = position_dodgev(height = 0.2)) +
  scale_y_continuous(breaks = 1:7) +
  facet_grid(combo ~ as.integer(factor(prolific_pid))) +
  scale_color_manual(values = c(project_colors[1], project_colors[4]), name = 'delay length') +
  labs(title = "Conjunctive")
conj %>%
  filter(trialType == "critical") %>%
  filter(delay != "simult") %>%
  ggplot(aes(x = delay, y = delta, fill = delay)) +
  scale_y_continuous(breaks = seq(-1, 1, by = 0.2)) +
  stat_summary(fun = mean, geom = 'bar', width = 1.0) +
  stat_summary(fun.data = "mean_se", geom = "errorbar", width = 0.5, linewidth = 0.6, colour = project_colors[2]) +
  scale_fill_manual(values = c(project_colors[1], project_colors[3], project_colors[4]), name = 'delay length') +
  facet_wrap(~combo) +
  labs(y = 'Delta (late - early)', title = "Conjunctive")
disj %>%
  filter(trialType == "critical") %>%
  ggplot(aes(x = which_ball_EL, y = causal_val, color = delay)) +
  stat_summary(fun = 'mean', position = position_dodge()) +
  stat_summary(fun = 'mean', geom = 'line', aes(group = delay), position = position_dodge()) +
  stat_summary(fun.data = 'mean_se', position = position_dodge()) +
  geom_jitter(aes(), position = position_jitterdodge(jitter.width = 0.4,
                                                     jitter.height = .2,
                                                     dodge.width = 0.8),
              color = 'black', alpha = .1) +
  facet_wrap(~combo) +
  scale_color_manual(values = c(project_colors[1], project_colors[3], project_colors[4]), name = 'delay length') +
  labs(title = "Disjunctive")

disj %>%
  filter(trialType == "critical") %>%
  filter(delay != "simult") %>%
  ggplot(aes(x = delay, y = delta, fill = delay)) +
  scale_y_continuous(breaks = seq(-1, 1, by = 0.2)) +
  stat_summary(fun = mean, geom = 'bar', width = 1.0) +
  stat_summary(fun.data = "mean_se", geom = "errorbar", width = 0.5, linewidth = 0.6, colour = project_colors[2]) +
  scale_fill_manual(values = c(project_colors[1], project_colors[3], project_colors[4]), name = 'delay length') +
  facet_wrap(~combo) +
  labs(y = 'Delta (late - early)', title = "Disjunctive")