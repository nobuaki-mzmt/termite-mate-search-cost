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
}
#------------------------------------------------------------------------------#

rm(list = ls())

load("data/df_all.rda")

ggplot(df_all, aes(x=x, y=y, group=day, col=as.factor(day))) +
  geom_path() +
  scale_color_viridis(discrete = T, option = "D")+
  theme_classic()+
  facet_wrap(~id, scales = "free")+
  theme(aspect.ratio = 1, legend.position = "none") 

ids = unique(df_all$id)

for(i in 1:length(ids)){
  df <- subset(df_all, id==ids[i])
  step_length    <- c(0, sqrt( diff(df$x)^2 + diff(df$y)^2 ))
  step_length[df$time==0] = 0
  df$step_length = step_length
  
  ggplot(df, aes(x=x, y=y, group=day, col=as.factor(day))) +
    geom_path() +
    scale_color_viridis(discrete = T, option = "D")+
    theme_classic()+
    coord_fixed()+
    ggtitle(ids[i])
  ggsave(paste0("output/trajectories_",ids[i],".pdf"), width=4, height=4)
  
  ggplot(df, aes(x=step_length, group=day, fill=as.factor(day)))  +
    geom_density(alpha=.3)+
    scale_fill_viridis(discrete = T)+
    scale_x_continuous(limits = c(0,10))+
    theme_classic()+
    ggtitle(ids[i])+
    annotate("segment",x=0.70,xend=0.70,y=2,yend=1, col=2,
             arrow=arrow(ends = "last", angle = 30,length = unit(.2,"cm")))
    
  ggsave(paste0("output/steplength_",ids[i],".pdf"), width=4, height=4)  
}

#------------------------------------------------------------------------------#
colonyfoundation <- function(){
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


