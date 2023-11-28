## Data analysis on tired termite project
## N. Mizumoto

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
    #facet_wrap(.~sex) +
    scale_color_viridis(discrete=T)+
    scale_fill_viridis(discrete=T)+
    #scale_x_log10() + 
    #scale_y_log10()+
    theme_classic()+
    theme(legend.position = "none") +
    theme(strip.text = element_text(size = 7, margin = margin()),
          axis.text=element_text(size=6),)+
    theme(strip.background = element_rect(colour="#00000000", fill="#00000000"))
  ggsave("output/MSD.pdf", width=3, height=4)
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
  ggplot(df_sum, aes(x = (day), y = traveled_dis, fill = sex)) +
    geom_flat_violin(aes(fill = sex),position = position_nudge(x = .1, y = 0), adjust = 1.5, trim = TRUE, alpha = .5, colour = NA)+
    geom_point(aes(x = as.numeric(day)-.15, y = traveled_dis, colour = sex),position = position_jitter(width = .05), size = 1, shape = 20)+
    geom_boxplot(aes(x = day, y = traveled_dis, fill = sex),outlier.shape = NA, alpha = .5, width = .1, colour = "black")+
    scale_colour_brewer(palette = "Dark2")+
    scale_fill_brewer(palette = "Dark2")
  
  r = lmer(traveled_dis ~ day * sex + (1|colony/id), data=df_sum)
  Anova(r)
  
  # pause duration
  ggplot(df_sum, aes(x = (day), y = pause_duration, fill = sex)) +
    geom_flat_violin(aes(fill = sex),position = position_nudge(x = .1, y = 0), adjust = 1.5, trim = TRUE, alpha = .5, colour = NA)+
    geom_point(aes(x = as.numeric(day)-.15, y = pause_duration, colour = sex),position = position_jitter(width = .05), size = 1, shape = 20)+
    geom_boxplot(aes(x = day, y = pause_duration, fill = sex),outlier.shape = NA, alpha = .5, width = .1, colour = "black")+
    scale_colour_brewer(palette = "Dark2")+
    scale_fill_brewer(palette = "Dark2")+
    scale_y_continuous(limits = c(0,1501))
  
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
  
  r = lmer(mean_moving_speed ~ day + sex + (1|colony/id), data=df_sum)
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
  d.foundation <- transform(d.foundation, treat= factor(treat, levels = c("3day", "0day")))
  
  ggplot(d.foundation, aes(x=treat, y=foundation, fill=treat)) +
    stat_summary(fun = "mean", geom = "bar") +
    scale_fill_viridis(discrete = T, alpha=0.5, direction = -1) +
    scale_y_continuous(limits=c(0,1)) + 
    theme_classic()+
    coord_flip()+
    xlab("")+ylab("Prop of colony foundation success")+
    geom_text(aes(x=2, y=0.5, label = "40/45")) +
    geom_text(aes(x=1, y=0.5, label = "28/39"))
  
  ggplot(d.foundation[d.foundation$foundation==1,], aes(x=treat, y=offspring, fill=treat)) +
    geom_flat_violin(position=position_nudge(x=.15,y=0),adjust =2,trim=TRUE)+
    geom_point(position = position_jitter(width = .05), size=.4) +
    geom_boxplot(aes(x=as.numeric(as.factor(treat))+0.15, y=offspring),
                 outlier.shape=NA, alpha=0.3, width=.1, colour="BLACK")+
    ylab('Num offsprings')+xlab('')+
    coord_flip()+
    theme_classic()+
    scale_fill_viridis(discrete = T, alpha=0.5, direction = -1) +
    scale_y_continuous(limits=c(0,30)) 
  
  
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
  
  ggplot(d.weight, aes(x=day, y=fresh, fill=sex, col=sex)) +
    geom_point(position = position_jitterdodge(jitter.width = .05, dodge.width = .5), size=1) +
    geom_boxplot(aes(x=day, y=fresh),
                 outlier.shape=NA, alpha=0.3, width=.1, colour="BLACK")+
    ylab('Fresh weight (mg)')+xlab('')+
    theme_classic()+
    scale_fill_viridis(discrete = T, alpha=0.5, direction = -1) +
    scale_color_viridis(discrete = T, alpha=0.5, direction = -1) +
    scale_y_continuous(limits=c(0,4)) 
  
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
}
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
d.tandem <- data.frame(fread("data/raw/tandem_timedevelopment.csv", header=T))

d.tandem$day = factor(d.tandem$day)
d.tandem$minute = factor(d.tandem$minute)

library(Rmisc)
sumrepdat <- summarySE(d.tandem, measurevar = "tandem", 
                       groupvars=c("day", "minute"))

ggplot(d.tandem, aes(x=minute, y=tandem, col=day))+
  geom_point(aes(x = (minute), y = tandem, colour = day),
             position = position_jitter(width = .05), size = .9, shape = 20)+
  geom_line(data = sumrepdat, 
            aes(x = (minute), y = tandem, group = day, colour = day),
            linetype = 3)+
  geom_point(data = sumrepdat, 
             aes(x = (minute), y = tandem, group = day, colour = day),
             shape = 18) +
  geom_errorbar(data = sumrepdat, 
                aes(x = (minute), y = tandem, 
                    group = day, colour = day, 
                    ymin = tandem-se, ymax = tandem+se), width = .05)+
  scale_colour_viridis(discrete = T, end=.9)+
  scale_fill_viridis(discrete = T)+
  theme_classic()

library(exactRankTests)
dt <- d.tandem
wilcox.exact(dt[dt$minute==30 & dt$day==0,]$tandem, dt[dt$minute==5 & dt$day==0,]$tandem, paired=T)
# V = 21, p-value = 0.03125
wilcox.exact(dt[dt$minute==30 & dt$day==3,]$tandem, dt[dt$minute==5 & dt$day==3,]$tandem, paired=T)
# V = 11, p-value = 1

X <- tapply(dt$tandem, dt[,3:2], sum)
cor.test(1:6, X[,1], method="spearman")
# S = 3.5474, p-value = 0.01489
cor.test(1:6, X[,2], method="spearman")
# S = 26, p-value = 0.6583


d.tandem.sum <- data.frame(fread("data/raw/tandem_sum.csv", header=T))
d.tandem.sum$day <- factor(d.tandem.sum$day)
dts <- subset(d.tandem.sum, 
              type=="heterotandem" | type=="maletandem" | type=="femaletandem" | type=="tandem3")
ggplot(dts, aes(x=type, y=obs, col=day))+
  geom_boxplot()

wilcox.exact(dts[dts$type=="heterotandem"&dts$day==0,]$obs, dts[dts$type=="heterotandem"&dts$day==3,]$obs, paired=T)
#V = 0, p-value = 0.03125
wilcox.exact(dts[dts$type=="maletandem"&dts$day==0,]$obs, dts[dts$type=="maletandem"&dts$day==3,]$obs, paired=T)
#V = 14, p-value = 0.5625
wilcox.exact(dts[dts$type=="femaletandem"&dts$day==0,]$obs, dts[dts$type=="femaletandem"&dts$day==3,]$obs, paired=T)
#V = 1.5, p-value = 0.375
wilcox.exact(dts[dts$type=="tandem3"&dts$day==0,]$obs, dts[dts$type=="tandem3"&dts$day==3,]$obs, paired=T)
#V = 0, p-value = 0.03125


