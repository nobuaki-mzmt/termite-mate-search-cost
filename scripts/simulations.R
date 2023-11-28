## Data analysis on tired termite project
## N. Mizumoto


require(Rcpp)

rm(list = ls())

## Simulations
load("data/df_all.rda")
sourceCpp("scripts/onesim.cpp")

## Parameters
L <- 223.6
dis_encounter <- 7
iter <- 100

one_simulation_1 <- function(df1, df2){
  PBC <- function(coord, L){
    if(coord >= L){
      coord <- coord - L
    } else if (coord < 0){
      coord <- coord + L
    }
    return(coord)
  }
  
  # initialize
  x1_diff <- diff(df1$x)
  y1_diff <- diff(df1$y)
  x2_diff <- diff(df2$x)
  y2_diff <- diff(df2$y)
  
  x1 <- 0
  y1 <- 0
  x2 <- runif(1,0,1)*L
  y2 <- runif(1,0,1)*L
  
  # run
  for(i_time in 1:1499){
    x1 <- PBC(x1 + x1_diff[i_time], L)
    y1 <- PBC(y1 + y1_diff[i_time], L)
    x2 <- PBC(x2 + x2_diff[i_time], L)
    y2 <- PBC(y2 + y2_diff[i_time], L)
    
    
    xdis <- min(abs(x1 - x2), abs(L - abs(x1 - x2)))
    ydis <- min(abs(y1 - y2), abs(L - abs(y1 - y2)))
    dis <-  sqrt(xdis^2 + ydis*2)
    if(dis <= dis_encounter){
      break
    }
  }
  encounter_time <- i_time
  return(encounter_time)
}

one_simulation_2 <- function(df1, df2){
  # initialize
  x1 <- df1$x - df1$x[1]
  y1 <- df1$y - df1$y[1]
  x2 <- df2$x - df2$x[1] + runif(1,0,1)*L
  y2 <- df2$y - df2$y[1] + runif(1,0,1)*L
  
  # run
  x1 <- x1 %% L
  y1 <- y1 %% L
  x2 <- x2 %% L
  y2 <- y2 %% L
  
  #plot(x1, y1, xlim=c(0,L), ylim=c(0,L), type="l")
  #points(x2, y2, type="l", col=2)
  #Sys.sleep(0.1)
  
  xdis <- apply(cbind(abs(x1 - x2), abs(L - abs(x1 - x2))), 1, min)
  ydis <- apply(cbind(abs(y1 - y2), abs(L - abs(y1 - y2))), 1, min)
  dis <-  sqrt(xdis^2 + ydis*2)
  encounter_time <- which(dis <= dis_encounter)
  if(length(encounter_time)>0){
    encounter_time <- encounter_time[1]
  } else{
    encounter_time <- NA
  }
  return(encounter_time)
}
  
one_simulation_3 <- function(df1, df2){
  # initialize
  x1 <- df1$x - df1$x[1]
  y1 <- df1$y - df1$y[1]
  x2 <- df2$x - df2$x[1] + runif(1,0,1)*L
  y2 <- df2$y - df2$y[1] + runif(1,0,1)*L
  
  encounter_time = one_simulation(x1, y1, x2, y2, L, dis_encounter)
  
  return(encounter_time)
}


df_sim <- NULL
for(i_day in 0:3){
  sex_list <- c("F", "M")
  for(i_sex in 1:2){
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
      print(paste("Sim: sex:",sex_list[i_sex], "day:", i_day, "iter:", i_rep))
      
      d_sub_s <- subset(d_searcher, id == sample_id_s[i_rep])[1:1500-1+sample_time_s[i_rep],]
      result <- randomize_trajectory(d_sub_s$x, d_sub_s$y)
      df1 <- data.frame(time = 1:1500, x=result$x, y=result$y)
      
      d_sub_p <- subset(d_partner, id == sample_id_p[i_rep])[1:1500-1+sample_time_p[i_rep],]
      result <- randomize_trajectory(d_sub_p$x, d_sub_p$y)
      df2 <- data.frame(time = 1:1500, x=result$x, y=result$y)

      res_vec[i_rep] <- one_simulation_3(df1, df2)
    }
    df_temp <- data.frame(
      day = i_day, sex = sex_list[i_sex], encounter_time = res_vec
    )
    df_sim <- rbind(df_sim, df_temp)
  }
  save(df_sim, file="data/df_sim.rda")
}


df_sim$cens <- 0
df_sim$cens[is.na(df_sim$encounter_time)] <- 1
df_sim$encounter_time[is.na(df_sim$encounter_time)] <- 1500

library("survminer")
library(survival)
df<-survfit(Surv(encounter_time/5)~day, type = "kaplan-meier", data=df_sim)
ggsurvplot(fit = df, data = df_sim,
           pval = F, pval.method = TRUE,
           risk.table = F, conf.int = FALSE,
           ncensor.plot = FALSE, size = 1, 
           xlab="Time (sec)", ggtheme = theme_bw()  + theme(aspect.ratio = 0.75),
           facet.by = "sex")
