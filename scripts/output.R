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

Step_count <- table(df_pause[,c("pause.duration", "day")])
Step_ratio <- t(t(Step_count)/apply(Step_count, 2, sum))
Step_cums  <- apply(Step_ratio[nrow(Step_ratio):1,], 2, cumsum)[nrow(Step_ratio):1,]

df_fitting <- data.frame(
  day = rep(0:3, each=dim(Step_count)[1]),
  Step_label = rep(as.numeric(rownames(Step_cums)),4),
  Step_count = as.vector(Step_count),
  Step_ratio = as.vector(Step_ratio),
  Step_cums = as.vector(Step_cums)
)
df_fitting <- df_fitting[df_fitting$Step_count>0,]

ggplot(df_fitting, aes(x=Step_label, y=Step_cums, col=as.factor(day)))+
  geom_point()+
  scale_x_log10()+scale_y_log10()+
  scale_color_viridis(discrete = T)

matplot((as.numeric(rownames(Step_cums)))/5, 1-Step_cums, type="p", log="xy", pch=19, cex=0.5)

plot((as.numeric(rownames(Step_cums))), Step_cums[,1])
Step_ratio <- Step_count / sum(Step_count)
Step_cum <- rep(0, length(Step_ratio))


ggplot(df_pause, aes(x=pause.duration, y=cumsum(count), color=as.factor(day)))+
         geom_line()+geom_point()+
         facet_wrap(.~sex)

## Truncated power-law
# r: 0-1
TP <- function(r,myu,xmin,xmax){
  return( ( xmax^(1-myu) - (1-r)*(xmax^(1-myu)-xmin^(1-myu) ) )^(1/(1-myu)) )
}


## Stretched exponention
# r (0-1)
SE <- function(r, lambda, beta, xmin){
  return( (xmin^beta - 1/lambda*log(1-r)  )^(1/beta))
}


TP_bin_LLF <- function(param, data, xmin, xmax){
  j = 1:(max(data)/0.2)
  dj <- j
  for(i in j){
    dj[i] = sum(round(data*5) == i)
  }
  return(-length(data)*log(xmin^(1-param)-xmax^(1-param)) +sum(dj*log( (xmin+(j-1)*0.2)^(1-param) - (xmin+j*0.2)^(1-param) )))
} 

SE_bin_LLF <- function(param, data, xmin){
  j = 1:(max(data)/0.2)
  dj <- j
  for(i in 1:length(j)){
    dj[i] = sum(round(data*5) == i)
  }
  return( length(data)*param[2]*xmin^param[1] + sum( dj*log( exp(-param[2]*(xmin+(j-1)*0.2)^param[1]) - exp(-param[2]*(xmin+j*0.2)^param[1]) ) ) )
} 


## Truncated power-law
TP_CDF <- function(myu, x, xmin, xmax){
  (xmin^(1-myu)-x^(1-myu)) / (xmin^(1-myu)-xmax^(1-myu))
}

## Stretched Exponential
SE_CDF <- function(lambda, beta, x, xmin){
  1-exp(-lambda*(x^beta-xmin^beta))
}

df_fit_model = df_fit_sum <- NULL
for(i_day in 0:3){
  print(i_day)
  StepData <- subset(df_pause, day==i_day)$pause.duration
  min_sec <- min(StepData)
  max_sec <- max(StepData)
  
  idea.x <- seq(0,0.999,0.001)
  # fit with truncated Power-law
  param_TP <- optimize(TP_bin_LLF, interval=c(0,10), data=StepData, xmin=min_sec, xmax=max_sec, maximum=T)
  y1.est_TP <- TP(idea.x, param_TP$maximum[1], min_sec, max_sec)
  AIC1.TP <- -2*TP_bin_LLF(param_TP$maximum[1], StepData, min_sec, max_sec)+2*1
  
  # fit with stretched exponential
  param_SE <- optim(c(0.1,0.1), SE_bin_LLF, data=StepData, xmin=min_sec, control = list(fnscale = -1), method="Nelder-Mead")
  y2.est_SE <- SE(idea.x, param_SE$par[2], param_SE$par[1], min_sec)
  AIC2.SE <- -2*SE_bin_LLF(param_SE$par, StepData, min_sec)+2*2
  
  ## Selection
  AIC <- c(AIC1.TP, AIC2.SE)
  delta <- AIC - min(AIC)
  w1.TP_exp <- exp(-delta[1]/2)/(exp(-delta[1]/2)+exp(-delta[2]/2)) # Akaike weight
  w2.SE_exp <- exp(-delta[2]/2)/(exp(-delta[1]/2)+exp(-delta[2]/2)) # Akaike weight
  
  if(w1.TP_exp > w2.SE_exp){judge <- "TP";}   else { judge <- "SE";}
  
  df_fit_sum <- rbind(df_fit_sum, data.frame(param_TP[1], param_TP[2], AIC1.TP, w1.TP_exp, w2.SE_exp, judge))
  
  df_temp <- data.frame(
    day=i_day,
    idea.x,
    y1.est_TP,
    y2.est_SE
  )
  df_fit_model <- rbind(df_fit_model, df_temp)
}

ggplot(df_fitting, aes(x=Step_label, y=Step_cums, col=as.factor(day)))+
  geom_point()+
  scale_x_log10()+scale_y_log10()+
  scale_color_viridis(discrete = T)+
  geom_path(data=df_fit_model, aes(x=y1.est_TP, y=rev(idea.x)))+
  geom_path(data=df_fit_model, aes(x=y2.est_SE, y=rev(idea.x)))


ggsurvplot(
  fit = survfit(Surv((log10(1+pause.duration*0.2))) ~as.factor(day), 
                type = "kaplan-meier", 
                data = df_pause[df_pause$sex=="F",]),
  conf.int = F, conf.int.style = "ribbon",
  xlab = "Duration (min)", 
  ylab = "Tandem Prob",
  legend = c(0.8,0.9)
)


#
function(){
  load("data/df_sum.rda")
  ggplot(df_sum, aes(x=day, y=traveled_dis, col=sex))+
    geom_point(position = position_dodge(width = 0.1))+
    stat_summary(geom="errorbar", position = position_dodge(width = 0.1),
                 width=.1)+
    scale_color_viridis(discrete = T, end=.5)
  
  install.packages("PupillometryR")
  library(PupillometryR)
  df_sum = transform(df_sum, day=factor(day))
  ggplot(df_sum, aes(x = (day), y = traveled_dis, fill = sex)) +
    geom_flat_violin(aes(fill = sex),position = position_nudge(x = .1, y = 0), adjust = 1.5, trim = TRUE, alpha = .5, colour = NA)+
    geom_point(aes(x = as.numeric(day)-.15, y = traveled_dis, colour = sex),position = position_jitter(width = .05), size = 1, shape = 20)+
    geom_boxplot(aes(x = day, y = traveled_dis, fill = sex),outlier.shape = NA, alpha = .5, width = .1, colour = "black")+
    scale_colour_brewer(palette = "Dark2")+
    scale_fill_brewer(palette = "Dark2")
  
  r = lmer(traveled_dis ~ day * sex + (1|colony/id), data=df_sum)
  Anova(r)
  
  r = lmer(mean_moving_speed ~ day + sex + (1|colony/id), data=df_sum)
  Anova(r)
  
  r = lmer(rho ~ day + sex + (1|colony/id), data=df_sum)
  Anova(r)
  
  r = lmer(a ~ day + sex + (1|colony/id), data=df_sum)
  Anova(r)
  
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

