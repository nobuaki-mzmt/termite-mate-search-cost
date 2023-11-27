## Data analysis on tired termite project
## N. Mizumoto

## Simulations
load("data/df_all.rda")

## Parameters
L <- 223.6
dis_encounter <- 7
iter <- 10000

sample_trajectory <- function(day, sex){
  d_sub_pop <- subset(df_all, day==day & sex==sex)
  
  ids <- unique(d_sub_pop$id)
  
  sample_id   <- sample(ids, 1)
  sample_time <- sample(1:6000, 1)
  
  d_sub <- subset(d_sub_pop, id == sample_id)[1:1500-1+sample_time,]
  d_sub$time <- d_sub$time - d_sub$time[1]
  d_sub$x <- d_sub$x - d_sub$x[1]
  d_sub$y <- d_sub$y - d_sub$y[1]

  # reflect
  rn <- runif(1,0,1)
  if(rn < 0.5){
    d_sub$x <- -d_sub$x
  }
  if(rn < 0.5){
    d_sub$y <- -d_sub$y
  }
  
  # rotation
  theta <- runif(1,0,1)*2*pi
  rx <- cos(theta)*d_sub$x - sin(theta)*d_sub$y
  ry <- sin(theta)*d_sub$x + cos(theta)*d_sub$y
  df_temp <- data.frame(time = 1:1500, x=rx, y=ry)
  return(df_temp)
}

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
    
    #plot(x1, y1, xlim=c(0,L), ylim=c(0,L))
    #points(x2, y2)
    #Sys.sleep(0.1)
    
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
  
df_sim <- NULL
for(i_day in 0:3){
  sex_list <- c("F", "M")
  for(i_sex in 1:2){
    res_vec <- rep(0, iter)
    for(i_rep in 1:iter){
      print(paste("Sim: sex:",sex_list[i_sex], "day:", i_day, "iter:", i_rep))
      df1 <- sample_trajectory(i_day, sex_list[i_sex])
      df2 <- sample_trajectory(0, sex_list[2-i_sex])
      res_vec[i_rep] <- one_simulation_2(df1, df2)
    }
    df_temp <- data.frame(
      day = i_day, sex = sex_list[i_sex], encounter_time = res_vec
    )
    df_sim <- rbind(df_sim, df_temp)
  }
}


df_sim$cens <- 0
df_sim$cens[is.na(df_sim$encounter_time)] <- 1
df_sim$encounter_time[is.na(df_sim$encounter_time)] <- 1500

library("survminer")
library(survival)
df<-survfit(Surv(encounter_time)~day, type = "kaplan-meier", data=df_sim)
ggsurvplot(fit = df, data = df_sim,
           pval = F, pval.method = TRUE,
           risk.table = F, conf.int = FALSE,
           ncensor.plot = FALSE, size = 1, 
           xlab="Time (min)", ggtheme = theme_bw()  + theme(aspect.ratio = 0.75),
           facet.by = "sex")
