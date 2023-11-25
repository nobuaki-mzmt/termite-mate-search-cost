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


load("data/df_all.rda")
library(ggplot2)
library(viridis)
ggplot(df_MSD, aes(x=tau, y=MSD, color=as.factor(day), group=id))+
  geom_path() + facet_wrap(.~sex) +
  scale_color_viridis(discrete=T)+
  scale_x_log10() + scale_y_log10()

ggplot(df_MSD, aes(x=tau, y=MSD, 
                   color=as.factor(day),
                   fill=as.factor(day)))+
  geom_path(alpha=0.2) + 
  stat_smooth(method = "gam") +
  facet_wrap(.~sex) +
  coord_fixed()+
  scale_color_viridis(discrete=T)+
  scale_fill_viridis(discrete=T)+
  scale_x_log10() + scale_y_log10()

df_pause

ggsurvplot(
  fit = survfit(Surv((log10(1+pause.duration*0.2))) ~as.factor(day), 
                type = "kaplan-meier", 
                data = df_pause[df_pause$sex=="F",]),
  conf.int = F, conf.int.style = "ribbon",
  xlab = "Duration (min)", 
  ylab = "Tandem Prob",
  legend = c(0.8,0.9)
)


ids = unique(df_all$id)
df_sum <- NULL
for(i in 1:length(ids)){
  for(i_day in 0:3){
    df <- subset(df_all, id==ids[i] & day==i_day)
    traveled_dis <- sum(df$step_length)
    mean_moving_speed <- mean(df$step_length[df$pause == 0], na.rm=T)
    pause_duration <- sum(df$pause)
    
    df_msd <- subset(df_MSD, id==ids[i] & day==i_day)
    r <- lm(log10(MSD)~log10(tau), data=df_msd)
    D <- 10^r$coef[1]
    a <- r$coef[2]
    
    angle_cal <- function(X, Y, Length){
      Ax <- (X[3:Length-1] - X[3:Length-2])
      Bx <- (X[3:Length] - X[3:Length-1])
      Ay <- (Y[3:Length-1] - Y[3:Length-2])
      By <- (Y[3:Length] - Y[3:Length-1])
      hugo <- (Ax * By - Ay * Bx + 0.000001)/abs(Ax * By - Ay * Bx + 0.000001)
      cos <- round((Ax * Bx + Ay * By) / ((Ax^2 + Ay^2)*(Bx^2 + By^2))^0.5,14)
      return(acos(cos)*hugo)
    }
    angle <- c(NA,NA, angle_cal(df$x, df$y, dim(df)[1]))
    if (length(na.omit(angle[df$pause==0])) > 0){
      mle_wrpcauchy <- wrpcauchy.ml(na.omit(angle[df$pause==0]), 0, 0, acc=1e-015)
      mu <- as.numeric(mle_wrpcauchy[1])
      rho <- as.numeric(mle_wrpcauchy[2])
    } else{
      mu <- NA
      rho <- NA
    }
    
    df_temp <- data.frame(
      df[1,1:4], traveled_dis, mean_moving_speed, pause_duration,
      D, a, mu, rho
    )
    df_sum <- rbind(df_sum, df_temp)
  }
}

ggplot(df_sum, aes(x=day, y=a, col=sex))+
  geom_point(position = position_dodge(width = 0.1))+
  stat_summary(geom="errorbar", position = position_dodge(width = 0.1),
               width=.1)+
  scale_color_viridis(discrete = T, end=.5)

library(lme4)
library(car)
r = lmer(rho ~ day + sex + (1|colony/id), data=df_sum)
Anova(r)

r = lmer(a ~ day + sex + (1|colony/id), data=df_sum)
Anova(r)

r = lmer(traveled_dis ~ day + sex + (1|colony/id), data=df_sum)
Anova(r)

r = lmer(mean_moving_speed ~ day + sex + (1|colony/id), data=df_sum)
Anova(r)



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



## tandem observation
tandemmean <- tapply(dt$tandem,dt[,3:2],mean)
tandemse <- tapply(dt$tandem,dt[,3:2],se)

par(mfrow=c(1,2), pin=c(3,3))
matplot(tandemmean, type="l",xlim=c(0.5,6.5),ylim=c(0,25),lty=1,las=1,
        ylab="num. of tandem",xlab="time")
arrows(rep(1:6,2),as.vector(tandemmean+tandemse),
       rep(1:6,2),as.vector(tandemmean-tandemse), code=3, angle=90,length=0.1)
par(new=T)
matplot(tandemmean, pch=20,xlim=c(0.5,6.5),ylim=c(0,25),ann=F,axes=F)

head(dt)
wilcox.exact(dt[dt$minute==30 & dt$day==0,]$tandem, dt[dt$minute==5 & dt$day==0,]$tandem, paired=T)
# V = 21, p-value = 0.03125
wilcox.exact(dt[dt$minute==30 & dt$day==3,]$tandem, dt[dt$minute==5 & dt$day==3,]$tandem, paired=T)
# V = 11, p-value = 1


dts_mean <- tapply(dts$obs, dts[,2:3], mean)[,c(2,3,1,6)] 
dts_se <- tapply(dts$obs, dts[,2:3], se)[,c(2,3,1,6)] 

X <- barplot(dts_mean , beside=T, ylim=c(0,100), las=T)
arrows(X, dts_mean, X, dts_mean+dts_se, angle=90, length=0.05)

wilcox.exact(dts[dts$type=="heterotandem"&dts$day==0,]$obs, dts[dts$type=="heterotandem"&dts$day==3,]$obs, paired=T)
#V = 0, p-value = 0.03125
wilcox.exact(dts[dts$type=="maletandem"&dts$day==0,]$obs, dts[dts$type=="maletandem"&dts$day==3,]$obs, paired=T)
#V = 14, p-value = 0.5625
wilcox.exact(dts[dts$type=="femaletandem"&dts$day==0,]$obs, dts[dts$type=="femaletandem"&dts$day==3,]$obs, paired=T)
#V = 1.5, p-value = 0.375
wilcox.exact(dts[dts$type=="tandem3"&dts$day==0,]$obs, dts[dts$type=="tandem3"&dts$day==3,]$obs, paired=T)
#V = 0, p-value = 0.03125

wilcox.exact(dts[dts$type=="nestmate"&dts$day==0,]$obs, dts[dts$type=="non-nest"&dts$day==0,]$obs, paired=T)
# V = 10, p-value = 1
wilcox.exact(dts[dts$type=="nestmate"&dts$day==3,]$obs, dts[dts$type=="non-nest"&dts$day==3,]$obs, paired=T)
# V = 8, p-value = 0.6875


## ???ԕω?
X <- tapply(dt$tandem, dt[,3:2], sum)
cor.test(1:6, X[,1], method="spearman")
# S = 3.5474, p-value = 0.01489
cor.test(1:6, X[,2], method="spearman")
# S = 26, p-value = 0.6583

## ANTAM data
head(dw)

dmean <- tapply(dw$totalmove/1000, dw[,c(5,3)], mean)
dse <- tapply(dw$totalmove/1000, dw[,c(5,3)], se)

par(pin=c(3,3), mfrow=c(1,1))
matplot(dmean, type="l",col=c(2,1),lty=1,xlim=c(0.5,4.5),ylim=c(2,15),ann=F,axes=F)
arrows(rep(1:4,2),dmean+dse,rep(1:4,2),dmean-dse, angle=90, code =3, length=0.1)
par(new=T)
matplot(dmean, col=c(2,1),lty=1,xlim=c(0.5,4.5),ylim=c(2,15),type="p",pch=20,
        xlab="day", ylab="moved distance (m)",las=1)

r <- lmer(totalmove~day*sex+(1|colony/name),data=dw)
Anova(r)
# Analysis of Deviance Table (Type II Wald chisquare tests)
# Response: totalmove
# Chisq Df Pr(>Chisq)    
#  day     89.2541  1    < 2e-16 ***
#  sex      4.5546  1    0.03283 *  
#  day:sex  0.3393  1    0.56026    



## 
head(d)
r <- lmer(fresh~as.factor(day)*sex+(1|colony),data=d)
Anova(r)
dataMeans <-tapply(d$fresh,d[,3:2],mean)
datasd <- tapply(d$fresh,d[,3:2],se)
fugo <- dataMeans / abs(dataMeans)#abs()?͐??Βl
Col <- gray(seq(0,1,length.out=length(levels(d[,2]))))	#?O???[?X?P?[???ō쐬
XonFig <- barplot(dataMeans, beside=T, ylim=c(0,3.5), col=Col, family="sans",
                  xlab="sex", ylab="???d (mg)",las=1)  #?}?����??āA?Ђ????????ׂ??ꏊ???ۊ?
arrows(XonFig , dataMeans, XonFig , dataMeans+ fugo*datasd, angle=90,length=((XonFig[2,1]-XonFig[1,1])/10)) #?{?b?N?X?̏??ɂ????Ђ?????




r <- glm(suceed~as.factor(treat)+comb,data=d,family=binomial)
Anova(r)


fisher.test(matrix(c(30,0,25,5),ncol=2,byrow=T))



binom.test(c(10,19), p=1/2) 
binom.test(c(12,17), p=1/2) 
binom.test(c(22,36), p=1/2) 





head(d)

