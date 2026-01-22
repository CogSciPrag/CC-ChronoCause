library(dplyr)
library(tidyr)
library(ggplot2)

df <- read_csv("/Users/karlmulligan/Documents/chrono_cause/CC-ChronoCause/01-experiments/01-exp-non-leakyUrns/data/results_36_CC-ChronoCause-01-exp-non-leakyUrns-pilot1_EZ%2C+KM%2C+MF.csv")

# CHRONOCAUSE

conj %>%
  filter(trialType=="critical") %>%
  ggplot(aes(x=which_ball_EL, y=causal_val, color=delay)) +
  stat_summary(fun='mean', position=position_dodge()) +
  stat_summary(fun='mean', geom='line', aes(group=delay), position=position_dodge()) + 
  stat_summary(fun.data='mean_se', position=position_dodge()) +
  geom_jitter(aes(), position = position_jitterdodge(jitter.width = 0.05,
                                                                         jitter.height = .2,
                                                                         dodge.width = dodgewidth),
              color='black', alpha=.2) +
  scale_color_manual(values=c('blue', 'darkgreen', 'red'),
                     name='delay length') + 
  facet_wrap(~combo) +
  labs(title="Conjunctive")

disj %>%
  filter(trialType=="critical") %>%
  ggplot(aes(x=which_ball_EL, y=causal_val, color=delay)) +
  stat_summary(fun='mean', position=position_dodge()) +
  stat_summary(fun='mean', geom='line', aes(group=delay), position=position_dodge()) + 
  stat_summary(fun.data='mean_se', position=position_dodge()) +
  geom_jitter(aes(), position = position_jitterdodge(jitter.width = 0.05,
                                                     jitter.height = .2,
                                                     dodge.width = dodgewidth),
              color='black', alpha=.2) +
  scale_color_manual(values=c('blue', 'darkgreen', 'red'),
                     name='delay length') + 
  facet_wrap(~combo) +
  labs(title="Disjunctive")

# conjunctive conditions
conj %>% mutate(combo = ifelse((leftColor == "red") & (rightColor == "yellow"), "solid-solid", ifelse((leftColor == "blue") & (rightColor == "green"), "striped-striped", ifelse((leftColor == "blue") & (rightColor == "yellow"), "striped-solid", ifelse((leftColor == "red") & (rightColor == "green"), "solid-striped", NA)))))

# disjunctive conditions
disj %>% mutate(combo = ifelse((leftColor == "red") & (rightColor == "yellow"), "solid-solid", ifelse((leftColor == "blue") & (rightColor == "green"), "striped-striped", ifelse((leftColor == "blue") & (rightColor == "yellow"), "striped-solid", ifelse((leftColor == "red") & (rightColor == "green"), "solid-striped", NA)))))


# graph:
conj %>%
  filter(trialType=="critical") %>%
  ggplot(aes(x=delay, y=delta, color=delay)) +
  stat_summary(fun='mean', position=position_dodge()) +
  stat_summary(fun='mean', geom='line', aes(group=delay), position=position_dodge()) + 
  stat_summary(fun.data='mean_se', position=position_dodge()) +
  geom_jitter(aes(), position = position_jitterdodge(jitter.width = 0.05,
                                                     jitter.height = .2,
                                                     dodge.width = dodgewidth),
              color='black', alpha=.2) +
  scale_color_manual(values=c('blue', 'darkgreen', 'red'),
                     name='delay length') + 
  facet_wrap(~combo) + 
  ggtitle("Conjunctive") + 
  ylab("delta (absolute value)")

disj %>%
  filter(trialType=="critical") %>%
  ggplot(aes(x=delay, y=delta, color=delay)) +
  stat_summary(fun='mean', position=position_dodge()) +
  stat_summary(fun='mean', geom='line', aes(group=delay), position=position_dodge()) + 
  stat_summary(fun.data='mean_se', position=position_dodge()) +
  geom_jitter(aes(), position = position_jitterdodge(jitter.width = 0.05,
                                                     jitter.height = .2,
                                                     dodge.width = dodgewidth),
              color='black', alpha=.2) +
  scale_color_manual(values=c('blue', 'darkgreen', 'red'),
                     name='delay length') + 
  facet_wrap(~combo) + 
  ggtitle("Disjunctive")


# left-right bias
conj_LR %>%
  filter(trialType=="critical") %>%
  ggplot(aes(x=which_ball_LR, y=causal_val)) +
  stat_summary(fun='mean', position=position_dodge()) +
  stat_summary(fun='mean', geom='line', aes(y=causal_val), position=position_dodge()) + 
  stat_summary(fun.data='mean_se', position=position_dodge()) +
  geom_jitter(aes(), position = position_jitterdodge(jitter.width = 0.05,
                                                     jitter.height = .2,
                                                     dodge.width = dodgewidth),
              color='black', alpha=.2) +
  facet_wrap(~delay)

disj_LR %>%
  filter(trialType=="critical") %>%
  ggplot(aes(x=which_ball_LR, y=causal_val)) +
  stat_summary(fun='mean', position=position_dodge()) +
  stat_summary(fun='mean', geom='line', aes(y=causal_val), position=position_dodge()) + 
  stat_summary(fun.data='mean_se', position=position_dodge()) +
  geom_jitter(aes(), position = position_jitterdodge(jitter.width = 0.05,
                                                     jitter.height = .2,
                                                     dodge.width = dodgewidth),
              color='black', alpha=.2) +
  facet_wrap(~delay)

full_long_LR %>%
  filter(trialType=="critical") %>%
  ggplot(aes(x=which_ball_LR, y=causal_val)) +
  stat_summary(fun='mean', position=position_dodge()) +
  stat_summary(fun='mean', geom='line', aes(y=causal_val), position=position_dodge()) + 
  stat_summary(fun.data='mean_se', position=position_dodge()) +
  geom_jitter(aes(), position = position_jitterdodge(jitter.width = 0.05,
                                                     jitter.height = .2,
                                                     dodge.width = dodgewidth),
              color='black', alpha=.2) +
  facet_wrap(~structure)

