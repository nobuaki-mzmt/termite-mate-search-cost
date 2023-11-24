## Data analysis on tired termite project
## N. Mizumoto

#------------------------------------------------------------------------------#
# This file is for preprocess all data for statistical analysis and plot
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
{
  library(car)
  library(lme4)
  library(exactRankTests)
}




## function
se  <-  function(x){
  y  <-  x[!is.na(x)]  #  remove  the  missing  values
  sqrt(var(as.vector(y))/length(y))
}

## data
# colony foundation 2017
d17 <- read.delim("clipboard", header=T)

# tandem observation 2016
dt <- read.delim("clipboard", header=T)
dts <- read.delim("clipboard", header=T)

# ANTAM analysis
dw<- read.delim("clipboard", header=T)

## main

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



