## Data analysis on tired termite project
## N. Mizumoto

#------------------------------------------------------------------------------#
# simulations.R
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
{
  require(Rcpp)
  
  library(ggplot2)
  library(viridis)
  library("survminer")
  library(survival)
}
#------------------------------------------------------------------------------#

rm(list = ls())

#------------------------------------------------------------------------------#
{
  run.simulation(iter = 10000)
  plot.simulations()
}
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# Simulations
#------------------------------------------------------------------------------#
run.simulation <- function(L = 223.6, dis_encounter = 7, iter = 10000){
  load("data/df_all.rda")
  sourceCpp("scripts/onesim.cpp")
  
  df_sim <- NULL
  for(i_day in 0:3){
    sex_list <- c("F", "M")
    for(i_sex in 1:2){
      print(paste("Sim: sex:",sex_list[i_sex], "day:", i_day))
      
      res_vec <- rep(0, iter)
      d_searcher <- subset(df_all, day==i_day & sex==sex_list[i_sex])
      d_partner  <- subset(df_all, day==0 & sex==sex_list[3-i_sex])
      
      ids <- unique(d_searcher$id)
      sample_id_s   <- sample(ids, iter, replace = T)
      sample_time_s <- sample(1:6000, iter, replace = T)
      
      ids <- unique(d_partner$id)
      sample_id_p   <- sample(ids, iter, replace = T)
      sample_time_p <- sample(1:6000, iter, replace = T)
      
      for(i_rep in 1:iter){
        #print(paste("Sim: sex:",sex_list[i_sex], "day:", i_day, "iter:", i_rep))
        
        d_sub_s <- subset(d_searcher, id == sample_id_s[i_rep])[1:1500-1+sample_time_s[i_rep],]
        result <- randomize_trajectory(d_sub_s$x, d_sub_s$y)
        df1 <- data.frame(time = 1:1500, x=result$x, y=result$y)
        
        d_sub_p <- subset(d_partner, id == sample_id_p[i_rep])[1:1500-1+sample_time_p[i_rep],]
        result <- randomize_trajectory(d_sub_p$x, d_sub_p$y)
        df2 <- data.frame(time = 1:1500, x=result$x, y=result$y)
        
        x1 <- df1$x
        y1 <- df1$y
        x2 <- df2$x + runif(1,0,1)*L
        y2 <- df2$y + runif(1,0,1)*L
        
        res_vec[i_rep] = one_simulation(x1, y1, x2, y2, L, dis_encounter)
        #print(res_vec[i_rep])
        
      }
      df_temp <- data.frame(
        day = i_day, sex = sex_list[i_sex], encounter_time = res_vec
      )
      df_sim <- rbind(df_sim, df_temp)
    }
  }
  save(df_sim, file="data/df_sim.rda")
  
}
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# output
#------------------------------------------------------------------------------#
plot.simulations <- function(){
  load("data/df_sim.rda")
  
  df_sim$cens <- 0
  #df_sim$cens[df_sim$encounter_time==1501] <- 1
  df_sim$cens[df_sim$encounter_time == 1501] <- 1
  df_sim$encounter_time[df_sim$encounter_time == 1501] <- 3000
  
  df<-survfit(Surv(encounter_time/5)~day, type = "kaplan-meier", data=df_sim)
  ggsurvplot(fit = df, data = df_sim, fun = "event",
             pval = F, pval.method = TRUE,
             risk.table = F, conf.int = FALSE,
             ncensor.plot = FALSE, size = 1, 
             xlab="Time (sec)", 
             ylab="Encounter rate",
             palette = viridis(4),
             ggtheme = theme_classic() + theme(aspect.ratio = 1) +
               theme(strip.background = element_rect(colour="#00000000", fill="#00000000")),
             facet.by = "sex") + 
    coord_cartesian(ylim=c(0,.7), xlim = c(0,300), clip = 'on', expand=FALSE) 
  ggsave("output/simulation.pdf", width=6, height=3)  
}
#------------------------------------------------------------------------------#

