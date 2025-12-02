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


# import data
df <- read.csv('01-experiments/01-exp-non-leakyUrns/data/results_01-exp-non-leakyUrns-pilot1.csv')

# sanity check - number of participants
df %>% distinct(prolific_pid) %>% count()

# sanity check for trial types
df_comprehension <- df %>% filter(grepl('comprehension',trialType))
df_trials <- df %>% filter(trialType=='critical' | trialType =='training')
df_attention <- df %>% filter(trialType=='critical-attention' | trialType =='training-attention')


# identify if response to comprehension and attention questions is correct
df <- df %>%
  mutate(correctComprehension =
                  ifelse(is.na(correctResponse), 1,
                         correctResponse==response)) %>%
    mutate(correctAttention =
                  ifelse(is.na(correctResponseAttention), 1,
                         correctResponseAttention==responseAttention))

# identify participants failing comprehension questions
# 0 - passed comprehension questions
# 1 - failed first round
# 2 failed both rounds

# TODO

# getCorrectness <- function(id){
#   g <- d %>% filter(prolific_pid==id)
#   if(sum(g$correct)==nrow(g)){return(1)}
#   else{return(0)}
#
# }
# d <- d %>% mutate(participantCorrect = unlist(
#   pmap(
#     list(prolific_pid),
#     getCorrectness
#   )
# ))