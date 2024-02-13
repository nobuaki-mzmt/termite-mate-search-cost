## Data analysis on tired termite project

#------------------------------------------------------------------------------#
# This script displays the results 
# The processed data will be used, so run Preprocess.R before this.
# All the results will be stored at img/
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
{
  library(data.table)
  
  library(lme4)
  library(car)
  library(exactRankTests)
  
  library(Rmisc)
  
  library(ggplot2)
  library(viridis)
  library(PupillometryR)
  
}
#------------------------------------------------------------------------------#

rm(list = ls())

#------------------------------------------------------------------------------#
plot_trajectories <- function(){
  load("data/df_all.rda")
  
  ## show all trajectories
  ggplot(df_all, aes(x=x, y=y, group=day, col=as.factor(day))) +
    geom_path() +
    scale_color_viridis(discrete = T, option = "D")+
    theme(aspect.ratio = 1, legend.position = "none") +
    ylab("y (mm)") +
    xlab("x (mm)") +
    theme_bw()+
    theme(aspect.ratio = 1, legend.position = "bottom") +
    theme(strip.text = element_text(size = 7, margin = margin()),
          axis.text=element_text(size=6),)+
    theme(strip.background = element_rect(colour="#00000000", fill="#00000000"))+
    facet_wrap(.~id, ncol=6) + labs(color = "Day")
  ggsave(paste0("output/trajectories_all.pdf"), width=7.5, height=5)
  
  # step length distribution for each individiaul
  ids = unique(df_all$id)
  for(i in 1:length(ids)){
    df <- subset(df_all, id==ids[i])
    step_length    <- c(0, sqrt( diff(df$x)^2 + diff(df$y)^2 ))
    step_length[df$time==0] = 0
    df$step_length = step_length
    
    ggplot(df, aes(x=step_length, group=day, fill=as.factor(day)))  +
      geom_density(alpha=.3)+
      scale_fill_viridis(discrete = T)+
      scale_x_continuous(limits = c(0,10))+
      theme_classic()+
      ggtitle(ids[i])+
      annotate("segment",x=0.70,xend=0.70,y=2,yend=1, col=2,
               arrow=arrow(ends = "last", angle = 30,length = unit(.2,"cm")))
    
    ggsave(paste0("output/steplength/steplength_",ids[i],".pdf"), width=4, height=4)  
    
    # Specific trajectory
    df_temp <- subset(df_all, id == "Rs_102_M_01")
    ggplot(df_temp, aes(x=x, y=y, group=day, col=as.factor(day))) +
      geom_path() +
      scale_color_viridis(discrete = T, option = "D")+
      theme(aspect.ratio = 1, legend.position = "none") +
      ylab("y (mm)") +
      xlab("x (mm)") +
      theme_classic()+
      scale_x_continuous(limit=c(-1200,1200), expand = c(0,0))+
      scale_y_continuous(limit=c(-1200,1200), expand = c(0,0))+
      theme(aspect.ratio = 1, legend.position = "bottom")  +
      theme(legend.position = c(.25,.8))
    ggsave("output/trajectory_Rs_102_M_01.pdf", width=3, height=3)
      
  }
  
}
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
plot_MSD <- function(){
  load("data/df_all.rda")
  
  df_MSD <- transform(df_MSD, day= factor(day))
  ggplot(df_MSD, aes(x=log10(tau), y=log10(MSD), color=day, fill=day))+
    geom_path(alpha=0.2) + 
    stat_smooth(method = "gam") +
    scale_color_viridis(discrete=T)+
    scale_fill_viridis(discrete=T)+
    coord_cartesian(xlim=c(-0.8,3.2), ylim=c(-1,6))+
    theme_classic()+
    theme(aspect.ratio = 1, legend.position = "none")+
    xlab("τ (sec)") + ylab("Mean squared displacements")
    
  ggsave("output/MSD.pdf", width=3, height=3)
  
  df_MSD_extract <- df_MSD[df_MSD$tau %in% c(.2,.5,1,2,5,10,20,50,100,200,500,1000), ]
  r <- lmer(log10(MSD)~log10(tau)*day*sex+(1|colony/id), data=df_MSD_extract)
  Anova(r)
}
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
plot_summary <- function(){
  load("data/df_sum.rda")
  df_sum = transform(df_sum, day=factor(day))
  df_sum$pause_duration <- df_sum$pause_duration/5
  
  # traveled distances
  sumrepdat <- summarySE(df_sum, measurevar = "traveled_dis", 
                         groupvars=c("day", "sex"))
  dodge_w = .3
  ggplot(df_sum, aes(x=day, y=traveled_dis, col=sex))+
    geom_point(aes(x = (day), y = traveled_dis, colour = sex),
               position = position_jitterdodge(jitter.width = .05, dodge.width = dodge_w),
               size = .9, shape = 20, alpha=.25)+
    geom_line(data = sumrepdat, position = position_dodge(width = dodge_w),
              aes(x = (day), y = traveled_dis, group = sex, colour = sex),
              linetype = 3)+
    geom_point(data = sumrepdat, position = position_dodge(width = dodge_w),
               aes(x = (day), y = traveled_dis, group = sex, colour = sex),
               shape = 1) +
    geom_errorbar(data = sumrepdat, position = position_dodge(width = dodge_w),
                  aes(x = (day), y = traveled_dis, 
                      group = sex, colour = sex, 
                      ymin = traveled_dis-se, ymax = traveled_dis+se), width = .05)+
    scale_colour_viridis(discrete = T, end=.5)+
    scale_fill_viridis(discrete = T)+
    theme_classic()+
    xlab("Day") + ylab("Traveled distance (mm)")
  ggsave("output/traveled_dis.pdf", width = 4, height=3)
  
  r = lmer(traveled_dis ~ day * sex + (1|colony/id), data=df_sum)
  Anova(r)
  
  # pause duration
  sumrepdat <- summarySE(df_sum, measurevar = "pause_duration", 
                         groupvars=c("day", "sex"))
  dodge_w = .3
  ggplot(df_sum, aes(x=day, y=pause_duration, col=sex))+
    geom_point(aes(x = (day), y = pause_duration, colour = sex),
               position = position_jitterdodge(jitter.width = .05, dodge.width = dodge_w),
               size = .9, shape = 20, alpha=.25)+
    geom_line(data = sumrepdat, position = position_dodge(width = dodge_w),
              aes(x = (day), y = pause_duration, group = sex, colour = sex),
              linetype = 3)+
    geom_point(data = sumrepdat, position = position_dodge(width = dodge_w),
               aes(x = (day), y = pause_duration, group = sex, colour = sex),
               shape = 1) +
    geom_errorbar(data = sumrepdat, position = position_dodge(width = dodge_w),
                  aes(x = (day), y = pause_duration, 
                      group = sex, colour = sex, 
                      ymin = pause_duration-se, ymax = pause_duration+se), width = .05)+
    scale_y_continuous(limits = c(0,1501))+
    scale_colour_viridis(discrete = T, end=.5)+
    scale_fill_viridis(discrete = T)+
    theme_classic()+
    xlab("Day") + ylab("Pausing duration (second)")
  ggsave("output/pause_duration.pdf", width = 4, height=3)
  
  r = lmer(pause_duration ~ day * sex + (1|colony/id), data=df_sum)
  Anova(r)
  
  # mean moving speed
  ggplot(df_sum, aes(x = (day), y = mean_moving_speed, fill = sex)) +
    geom_flat_violin(aes(fill = sex),position = position_nudge(x = .1, y = 0), adjust = 1.5, trim = TRUE, alpha = .5, colour = NA)+
    geom_point(aes(x = as.numeric(day)-.15, y = mean_moving_speed, colour = sex),position = position_jitter(width = .05), size = 1, shape = 20)+
    geom_boxplot(aes(x = day, y = mean_moving_speed, fill = sex),outlier.shape = NA, alpha = .5, width = .1, colour = "black")+
    scale_colour_brewer(palette = "Dark2")+
    scale_fill_brewer(palette = "Dark2")+
    scale_y_continuous(limits = c(0, 3.5))
  
  df_sum$mean_moving_speed <- df_sum$mean_moving_speed  * 5
  sumrepdat <- summarySE(df_sum, measurevar = "mean_moving_speed", 
                         groupvars=c("day", "sex"),na.rm = T)
  dodge_w = .3
  ggplot(df_sum, aes(x=day, y=mean_moving_speed, col=sex))+
    geom_point(aes(x = (day), y = mean_moving_speed, colour = sex),
               position = position_jitterdodge(jitter.width = .05, dodge.width = dodge_w),
               size = .9, shape = 20, alpha=.25)+
    geom_line(data = sumrepdat, position = position_dodge(width = dodge_w),
              aes(x = (day), y = mean_moving_speed, group = sex, colour = sex),
              linetype = 3)+
    geom_point(data = sumrepdat, position = position_dodge(width = dodge_w),
               aes(x = (day), y = mean_moving_speed, group = sex, colour = sex),
               shape = 1) +
    geom_errorbar(data = sumrepdat, position = position_dodge(width = dodge_w),
                  aes(x = (day), y = mean_moving_speed, 
                      group = sex, colour = sex, 
                      ymin = mean_moving_speed-se, ymax = mean_moving_speed+se), width = .05)+
    scale_y_continuous(limits = c(0, 20))+
    scale_colour_viridis(discrete = T, end=.5)+
    scale_fill_viridis(discrete = T)+
    theme_classic()+
    xlab("Day") + ylab("Movement speed (mm / sec)") +
    theme(axis.text = element_text(size = 7),
          axis.title = element_text(size = 9),
          legend.position = "none")
  ggsave("output/mean_movement_speed.pdf", width = 2.5, height=2.5)
  
  r = lmer(mean_moving_speed ~ day * sex + (1|colony/id), data=df_sum)
  Anova(r)
  
  # turning patterns
  ggplot(df_sum, aes(x = (day), y = rho, fill = sex)) +
    geom_flat_violin(aes(fill = sex),position = position_nudge(x = .1, y = 0), adjust = 1.5, trim = TRUE, alpha = .5, colour = NA)+
    geom_point(aes(x = as.numeric(day)-.15, y = rho, colour = sex),position = position_jitter(width = .05), size = 1, shape = 20)+
    geom_boxplot(aes(x = day, y = rho, fill = sex),outlier.shape = NA, alpha = .5, width = .1, colour = "black")+
    scale_colour_brewer(palette = "Dark2")+
    scale_fill_brewer(palette = "Dark2")+
    scale_y_continuous(limits = c(0, 1))

  r = lmer(rho ~ day + sex + (1|colony/id), data=df_sum)
  Anova(r)
}
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
plot_colonyfoundation <- function(){
  d.foundation <- data.frame(fread("data/raw/colonyfoundation.csv", header=T))
  
  #table(d.foundation[,c("treat", "foundation")])
  d.foundation <- transform(d.foundation, treat= factor(treat, levels = c("0day", "3day")))
  
  ggplot(d.foundation, aes(x=treat, y=foundation, fill=treat)) +
    stat_summary(fun = "mean", geom = "bar") +
    scale_fill_viridis(discrete = T, alpha=0.5, direction = 1) +
    scale_y_continuous(limits=c(0,1)) + 
    theme_classic()+
    theme(legend.position = "none")+
    xlab("")+ylab("Prop of colony foundation success")+
    geom_text(aes(x=2, y=0.5, label = "40/45")) +
    geom_text(aes(x=1, y=0.5, label = "28/39"))
  ggsave("output/foundation_success.pdf", width=3, height=4)
  
  ggplot(d.foundation[d.foundation$foundation==1,], 
         aes(x=treat, y=offspring, fill=treat, col=treat)) +
    geom_point(position = position_jitter(width = .05), size=1) +
    geom_boxplot(aes(x=as.numeric(as.factor(treat))+0.0, y=offspring),
                 outlier.shape=NA, alpha=0.3, width=.5, colour="BLACK")+
    ylab('Num offsprings')+xlab('')+
    theme_classic()+
    theme(legend.position = "none")+
    scale_fill_viridis(discrete = T, alpha=0.5, direction = 1) +
    scale_color_viridis(discrete = T, alpha=0.5, direction = 1, end=1) +
    scale_y_continuous(limits=c(0,30)) + 
    theme(axis.text = element_text(size = 7),
          axis.title = element_text(size = 9),
          legend.position = "none")
  ggsave("output/foundation_offspring.pdf", width=3, height=4)
  
  r <- glmer(foundation~treat+(1|colony), family="binomial", data=d.foundation)
  Anova(r)
  
  r <- glmer(offspring~treat+(1|colony), family="poisson", data=d.foundation[d.foundation$foundation>0,])
  Anova(r)
}
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
plot_weightchange <- function(){
  d.weight <- data.frame(fread("data/raw/termite_weight.csv", header=T))
  
  d.weight <- transform(d.weight, day= factor(day, levels = c("0day", "3day")))
  d.weight$id <- paste(d.weight$colony, d.weight$sex, d.weight$rep, sep="_")
  
  ggplot(d.weight, aes(x=sex, y=fresh, fill=day, col=day)) +
    geom_point(position = position_jitterdodge(jitter.width = .05, dodge.width = .8), size=.5) +
    geom_boxplot(outlier.shape=NA, alpha=0.3, width=.8, colour="BLACK")+
    ylab('')+xlab('')+
    theme_classic()+
    scale_fill_viridis(discrete = T, alpha=0.5, direction = 1) +
    scale_color_viridis(discrete = T, alpha=0.5, direction = 1) +
    scale_y_continuous(limits=c(0,4)) +
    theme(legend.position = "none")+ 
    theme(axis.text = element_text(size = 8),
          axis.title = element_text(size = 10),
          plot.title = element_text(size = 10),
          legend.position = "none")+
    ggtitle("Fresh weight (mg)")
  ggsave("output/fresh_weight.pdf", width=1.6, height=2.6)
  
  r <- lmer(fresh~day*sex+(1|colony/id), data=d.weight)
  Anova(r)
}
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
mate.choice <- function(){
  # Male, old=19, new=10, NA=6
  binom.test(c(10,19), p=1/2) 
  # Female, old=17, new=12, NA=4
  binom.test(c(12,17), p=1/2) 
  
  df_temp = data.frame(
    win = c(rep("old",19),rep("new",10),rep("old",17),rep("new",12)),
    sex = c(rep("male",29), rep("female", 29))
  )
  
  ggplot(df_temp, aes(x=sex, fill=factor(win))) +
    geom_bar(position = "fill") +
    scale_fill_viridis(discrete = T, option = "E", end=.5)+
    theme_classic()+
    xlab("") + ylab("Proportion")+
    theme(legend.position = "none")+ 
    theme(axis.text = element_text(size = 7),
          axis.title = element_text(size = 9),
          legend.position = "none")
  ggsave("output/mate_choice.pdf", width = 3, height=3)
}
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
tandem_plot <- function(){
  
  d.tandem <- data.frame(fread("data/raw/tandem_timedevelopment.csv", header=T))
  
  d.tandem$day = factor(d.tandem$day)
  d.tandem$minute = factor(d.tandem$minute)
  
  sumrepdat <- summarySE(d.tandem, measurevar = "tandem", 
                         groupvars=c("day", "minute"))
  
  ggplot(d.tandem, aes(x=minute, y=tandem, col=day))+
    geom_point(aes(x = (minute), y = tandem, colour = day),
               position = position_jitter(width = .05),
               alpha=.5, size = .5, shape = 20)+
    geom_line(data = sumrepdat, 
              aes(x = (minute), y = tandem, group = day, colour = day),
              linetype = 3)+
    geom_point(data = sumrepdat, 
               aes(x = (minute), y = tandem, group = day, colour = day),
               shape = 18, size=1.2) +
    geom_errorbar(data = sumrepdat, 
                  aes(x = (minute), y = tandem, 
                      group = day, colour = day, 
                      ymin = tandem-se, ymax = tandem+se),
                  width = .1)+
    scale_colour_viridis(discrete = T, end=.9)+
    scale_fill_viridis(discrete = T)+
    theme_classic()+
    theme(legend.position = "none")+
    xlab("Observation windows (min)") + ylab("Number of tandem runs")+
    scale_x_discrete(labels=c("5" = "0-5", "10" = "5-10", 
                              "15" = "10-15", "20" = "15-20",
                              "25" = "20-25", "30" = "25-30"))+ 
    theme(axis.text = element_text(size = 8),
          axis.title = element_text(size = 10),
          legend.position = "none")
  ggsave("output/tandem_development.pdf", width=3.3, height=3)
  
  dt <- d.tandem
  wilcox.exact(dt[dt$minute==30 & dt$day==0,]$tandem, 
               dt[dt$minute==5 & dt$day==0,]$tandem, paired=T)
  # V = 21, p-value = 0.03125
  wilcox.exact(dt[dt$minute==30 & dt$day==3,]$tandem, 
               dt[dt$minute==5 & dt$day==3,]$tandem, paired=T)
  # V = 11, p-value = 1
  
  X <- tapply(dt$tandem, dt[,3:2], sum)
  cor.test(1:6, X[,1], method="spearman")
  # S = 3.5474, p-value = 0.01489
  cor.test(1:6, X[,2], method="spearman")
  # S = 26, p-value = 0.6583
  
  
  d.tandem.sum <- data.frame(fread("data/raw/tandem_sum.csv", header=T))
  d.tandem.sum$day <- factor(d.tandem.sum$day)
  dts <- subset(d.tandem.sum, 
                type=="heterotandem" | type=="femaletandem" | type=="maletandem" | type=="tandem3")
  dts$type = factor(dts$type, levels = c("heterotandem", "maletandem", "femaletandem", "tandem3"))
  ggplot(dts, aes(x=type, y=obs, fill=day, col=day))+
    geom_point(position = position_jitterdodge(jitter.width = .2, dodge.width = .75), size=1) +
    geom_boxplot(outlier.shape=NA, alpha=0.3, width=.75, colour="BLACK")+
    scale_fill_viridis(discrete = T)+
    scale_color_viridis(discrete = T)+
    theme_classic()+
    scale_x_discrete(labels=c("heterotandem" = "Female-Male",
                              "femaletandem" = "Female-Female", 
                              "maletandem" = "Male-Male",
                              "tandem3" = "> 2 individuals"))+
    xlab("")+ylab("Number of observations")+ 
    theme(axis.text = element_text(size = 8),
          axis.title = element_text(size = 10),
          legend.position = "none")
  ggsave("output/tandem_total.pdf", width=3.3, height=3)
  
  apply(tapply(dts$obs, dts[,2:3], sum), 1, sum)
  tapply(dts$obs, dts[,2:3], sum)
  
  wilcox.exact(dts[dts$type=="heterotandem"&dts$day==0,]$obs, 
               dts[dts$type=="heterotandem"&dts$day==3,]$obs, paired=T)
  #V = 0, p-value = 0.03125
  wilcox.exact(dts[dts$type=="maletandem"&dts$day==0,]$obs, 
               dts[dts$type=="maletandem"&dts$day==3,]$obs, paired=T)
  #V = 14, p-value = 0.5625
  wilcox.exact(dts[dts$type=="femaletandem"&dts$day==0,]$obs,
               dts[dts$type=="femaletandem"&dts$day==3,]$obs, paired=T)
  #V = 1.5, p-value = 0.375
  wilcox.exact(dts[dts$type=="tandem3"&dts$day==0,]$obs, 
               dts[dts$type=="tandem3"&dts$day==3,]$obs, paired=T)
  #V = 0, p-value = 0.03125
}

