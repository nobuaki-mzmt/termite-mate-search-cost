## Data analysis on tired termite project
## N. Mizumoto

#------------------------------------------------------------------------------#
# This file is for preprocess all data for statistical analysis and plot
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
{
  library(data.table)
  library(stringr)
  
  library(CircStats)
}
{
  data.convert(7500)
}
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# Convert csv files to single rda file + df_MSD and df_pause
#------------------------------------------------------------------------------#
data.convert <- function(msd_max = 5000){
  
  f.namesplace <- list.files("data/raw/ANTAM_4day", pattern=".csv",full.names=T)
  f.names <- list.files("data/raw/ANTAM_4day", pattern=".csv",full.names=F)
  
  df_all = df_MSD = df_pause <- NULL
  for(i_files in 1:length(f.namesplace)){
    print(paste(i_files, "/", length(f.names), " ", f.names[i_files]))
    
    # prep data
    d <- data.frame(fread(f.namesplace[i_files], header=F))[,c(6,4,5)]
    colnames(d) = c("time", "x", "y")
    
    colony <- str_split(f.names[i_files], "_")[[1]][3]
    sex <- str_split(f.names[i_files], "_")[[1]][4]
    ind <- str_split(f.names[i_files], "_")[[1]][5]
    day <- as.numeric(str_sub(str_split(f.names[i_files], "_")[[1]][6], 1, 1))-1
    id <- paste("Rs", colony, sex, ind, sep="_")
    
    d[,2:3] <-d[,2:3] * 0.023725 # scale
    d <- (d[d$time>60*5,])  # remove first 5 min data
    
    d[,1] <- d[,1] - d[1,1]	
    d[,2] <- d[,2] - d[1,2]
    d[,3] <- d[,3] - d[1,3]
    
    d$x = runmed(d$x, 5)
    d$y = runmed(d$y, 5)

    time = seq(0, 1500, 0.2)
    x = approx(d$time, d$x, xout=time)$y
    y = approx(d$time, d$y, xout=time)$y
    step_length = c(0, sqrt( diff(x)^2 + diff(y)^2))
    
    # computeMSD is the function from the library "flowcatchR."
    # I could not load it for some reasons, so pasted here as it is.
    computeMSD <- function(sx,sy,until=4){ 
      msd.t <- rep(0,until)
      for (dt in 1:until){
        displacement.x <- as.vector(na.omit(sx[(1+dt):length(sx)]) - sx[1:(length(sx)-dt)])
        displacement.y <- as.vector(na.omit(sy[(1+dt):length(sy)]) - sy[1:(length(sy)-dt)])
        sqrdispl <- (displacement.x^2 + displacement.y^2)
        msd.t[dt] <- mean(sqrdispl)
      }
      return(msd.t)
    }
    
    pause = step_length < 0.70 # Mizumoto and Dobata 2019 Sci Adv
    pause.start  = which(pause)[c(T, diff(which(pause))>1)]
    pause.end    = which(pause)[c(diff(which(pause))>1,T)]
    frame.zero = which(df$time == 0)
    frame.end  = which(df$time == max(df$time))

    pause.duration = pause.end - pause.start + 1
    pause.censor   = pause.start %in% frame.end
    
    d.temp <- data.frame(
      colony, sex, day, id,
      time, x, y, step_length,
      pause, 
      cum_travel_dis = cumsum(step_length)
    )
    
    df_all <- rbind(df_all, d.temp)
    
    d.temp <- data.frame(
      colony, sex, day, id,
      MSD = computeMSD(x, y, msd_max),
      tau = (1:msd_max)/5
    )
    df_MSD <- rbind(df_MSD, d.temp)
    
    d.temp <- data.frame(
      colony, sex, day, id,
      pause.duration, pause.censor
    )
    df_pause <- rbind(df_pause, d.temp)
    
    
  }
  save(df_all, df_MSD, df_pause, file = "data/df_all.rda")
}
#------------------------------------------------------------------------------#



