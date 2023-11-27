## Data analysis on tired termite project
## N. Mizumoto

## Simulations
load("data/df_all.rda")

d_population <- subset(df_all, day==0)

ids <- unique(d_population$id)
id_nums <- length(ids)

sample(df_num, 1)
sample(1:6000, 1)
