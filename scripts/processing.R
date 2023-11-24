## Data analysis on tired termite project
## N. Mizumoto

#------------------------------------------------------------------------------#
# This file is for preprocess all data for statistical analysis and plot
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
{
  library(data.table)
  library(stringr)
}

#------------------------------------------------------------------------------#
# Convert csv files to single rda file
#------------------------------------------------------------------------------#
data.convert <- function(){
  
  f.namesplace <- list.files("data/raw/ANTAM_4day", pattern=".csv",full.names=T)
  f.names <- list.files("data/raw/ANTAM_4day", pattern=".csv",full.names=F)
  
  df_all <- NULL
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
    
    time = seq(0, 1500, 0.2)
    x = approx(d$time, d$x, xout=time)$y
    y = approx(d$time, d$y, xout=time)$y
    step_length = c(0, sqrt( diff(x)^2 + diff(y)^2))
    
    d.adjust <- data.frame(
      colony, sex, day, id,
      time, x, y, step_length,
      pause = step_length < 0.70, # Mizumoto and Dobata 2019 Sci Adv
      diffusion_dis = sqrt(x^2 + y^2),
      cum_travel_dis = cumsum(step_length)
    )
    
    df_all <- rbind(df_all, d.adjust)
  }
  save(df_all, file = "data/df_all.rda")
}
#------------------------------------------------------------------------------#

load("data/df_all.rda")

step_length <- c(0, sqrt( diff(df_all$x)^2 + diff(df_all$y)^2  ))
step_length[df_all$time==0] = 0
pause <- step_length < 0.70 # Mizumoto and Dobata 2019 Sci Adv
diffusion_dis  <- sqrt(df_all$x^2 + df_all$y^2)
cum_travel_dis <- cumsum(step_length)

truehist(step_length)

    # for msd
    step_length    <- c(0, sqrt( diff(d$x)^2 + diff(d$y)^2 ))
    diffusion_dis  <- sqrt(d$x^2 + d$y^2)
    cum_travel_dis <- cumsum(step_length)
    
    plot(cum_travel_dis, diffusion_dis, log="xy")
    
    msd2 <- log10(diffusion_dis)[-1]
    tau2 <- log10(cum_travel_dis)[-1]
    r <- lm(msd2~tau2)
    D <- 10^r$coef[1]
    a <- r$coef[2]
    
    # 
  }
  
}


### msd analysis
tau <- matrix(0, ncol=length(f.namesplace), 100)
msd <-  matrix(0, ncol=length(f.namesplace), length(tau[,1]))
name = colony = sex = rep = day  <- rep(0,length(f.namesplace))
D = a <- rep(0,length(f.namesplace)) 
Xrange <- c(1,5000)
Yrange <- c(1,10^6)
par(mfrow=c(4,5),pin=c(1.5,1.5))
for(num in 1:length(f.namesplace)){
  
  d <- read.csv(f.namesplace[num],sep=",",header=F)[,c(6,4,5)]
  namebegin <- regexpr("mouselog_",f.namesplace[num]) + 9
  nameend <- regexpr(".csv",f.namesplace[num]) - 1
  
  name[num] <- substring(f.namesplace[num],namebegin, nameend)
  colony[num] <- substring(f.namesplace[num],namebegin, namebegin+5)
  sex[num] <- substring(f.namesplace[num],namebegin+7, namebegin+7)
  rep[num] <- substring(f.namesplace[num],namebegin+8, namebegin+8)
  day[num] <- (substring(f.namesplace[num],nameend, nameend))
  
  d <- cut(d)
  
  ds <- length(d[,1])
  dis <- c(0, ((d[2:ds,2]-d[2:ds-1,2])^2 + (d[2:ds,3]-d[2:ds-1,3])^2)^0.5)
  tau[,num] <- seq(floor(sum(dis)/1000)*1000/1000, floor(sum(dis)/1000)*1000/10,length=100)
  if(sum(tau[,num])==0){
    tau[,num] <- seq(floor(sum(dis)/100)*100/100, floor(sum(dis)/100)*100,length=100)
  }
  if(sum(tau[,num])==0){
    next
  }
  
  for(j in 1:length(tau[,1])){
    displacement <- rep(0,sum(dis)/tau[j,num])
    count <- 1
    moved <- 0
    move <- 0
    cycle <- 0
    beginX <- d[1,2]
    beginY <- d[1,3]
    for(i in 2:ds){
      at.moved <- dis[i]
      moved <- moved + at.moved
      if(moved >= tau[j,num]+0.00000000001){
        while(moved >= tau[j,num]+0.00000000001){
          cycle = 0
          # ?O?Տ??̓_?̊Ԃ̈ړ??͓????????^???Ɖ??肵?Atau?ɓ??B???_?̓_(ax,ay)???z??
          ax <- d[i-1,2] + (d[i,2]-d[i-1,2]) * ((tau[j,num]-(moved-at.moved)+cycle)/at.moved)
          ay <- d[i-1,3] + (d[i,3]-d[i-1,3]) * ((tau[j,num]-(moved-at.moved)+cycle)/at.moved)
          displacement[count] <- ((ax-beginX)^2 + (ay-beginY)^2)^0.5
          count <- count +1
          beginX <- ax
          beginY <- ay 
          moved <- (((d[i,2]-ax)^2 + (d[i,3]-ay)^2))^0.5
          cycle = cycle + 1
        }	
      }
    }
    msd[j,num] <- mean(displacement^2)
  }
  
  
  if(as.numeric(day[num])>1){
    par(new=T)
    plot(tau[,num],msd[,num],log="xy",xlim=c(0.9,10000),ylim=c(0.9,10^7),col=as.numeric(day[num]),ann=F,axes=F)
  }else{
    plot(tau[,num],msd[,num],log="xy",xlim=c(0.9,10000),ylim=c(0.9,10^7),col=as.numeric(day[num]),main=paste(colony[num],sex[num],rep[num],sep=""))
  }
  
  msd2 <- log10(msd[,num])#[tau<101]
  tau2 <- log10(tau[,num])#[tau<101]
  r <- lm(msd2~tau2)
  D[num] <- 10^r$coef[1]
  a[num] <- r$coef[2]
  
  abline(log10(D[num]),a[num],col=as.numeric(day[num]))
  print(name[num]);print(a[num])
}

d <- data.frame(colony=colony, sex=sex, rep=rep, id = paste(colony,sex,rep,sep=""),day=as.numeric(day),  D=D, a=a)

par(pin=c(3,3))
Xrange <- c(10,1000)
Yrange <- c(10,10^5)
plot(0,log="xy",xlim=Xrange,ylim=Yrange,ann=F,axes=F,type="n")
for( i in 47:50){
  par(new=T)
  plot(tau,msd[,i],log="xy",xlim=Xrange,ylim=Yrange,col=as.numeric(day[i]))
}

r <- lmer(a~day*sex+(1|colony/id)+(0+day|colony/id),data=d)
summary(r)
Anova(r)




## general data

## analysis condition
FPS <- 5	## FPS using in analysis
secper <- 1/FPS	## 1?R?}????????sec
steps <- FPS * 60 *25	## 25???̃R?}??

## reading parameters
x = y = sec = time <-  matrix(0, ncol=length(f.namesplace), steps)
name = colony = sex = rep = day = totaldis <- rep(0,length(f.namesplace))
angle = dis = move = speed = acceleration <- matrix(0, ncol=length(f.namesplace), steps)

for(num in 1:length(f.namesplace)){
  
  d <- read.csv(f.namesplace[num],sep=",",header=F)[,c(6,4,5)]
  namebegin <- regexpr("mouselog_",f.namesplace[num]) + 9
  nameend <- regexpr(".csv",f.namesplace[num]) - 1
  
  name[num] <- substring(f.namesplace[num],namebegin, nameend)
  colony[num] <- substring(f.namesplace[num],namebegin, namebegin+5)
  sex[num] <- substring(f.namesplace[num],namebegin+7, namebegin+7)
  rep[num] <- substring(f.namesplace[num],namebegin+8, namebegin+8)
  day[num] <- (substring(f.namesplace[num],nameend, nameend))
  
  d <- cut(d)
  
  point <- 1:steps * (1/FPS)
  count <- 1
  for(i in 1:length(d[,1])){
    if(count > length(point)){ break }
    if(d[i,1] > point[count]){
      time[count,num] <- point[count]
      x[count,num] <- d[i-1,2] + (d[i,2]-d[i-1,2]) * ((point[count]-d[i-1,1])/(d[i,1]-d[i-1,1]))
      y[count,num] <- d[i-1,3] + (d[i,3]-d[i-1,3]) * ((point[count]-d[i-1,1])/(d[i,1]-d[i-1,1]))
      count <- count + 1
    }
  }
  
  sec[,num] <- c(0, time[2:steps,num] - time[2:steps-1,num])
  dis[,num] <- c(0, ((x[2:steps,num]-x[2:steps-1,num])^2 + (y[2:steps,num]-y[2:steps-1,num])^2)^0.5)
  speed[,num] <- dis[,num]/sec[,num]
  acceleration[,num] <- c(0, speed[2:steps,num] - speed[2:steps-1,num])
  
  Ax <- (x[3:steps-1,num] - x[3:steps-2,num])
  Bx <- (x[3:steps,num] - x[3:steps-1,num])
  Ay <- (y[3:steps-1,num] - y[3:steps-2,num])
  By <- (y[3:steps,num] - y[3:steps-1,num])
  hugo <- (Ax * By - Ay * Bx + 0.000001)/abs(Ax * By - Ay * Bx + 0.000001)
  cos <- (Ax * Bx + Ay * By) / ((Ax^2 + Ay^2)*(Bx^2 + By^2))^0.5
  angle[,num] <- c(0,0,acos(cos) * hugo)
  
  totaldis[num] <- sum(dis[,num])
  
  print(name[num])
}

d <- data.frame(colony=colony, sex=sex, rep=rep, id = paste(colony,sex,rep,sep=""),day=as.numeric(day),
                D=D, a=a, totaldis=totaldis, meanangle=meanangle, stop=stop, meanspeed = meanspeed)

r <- lmer(totaldis~day*sex+(1|colony/id),data=d)
summary(r)
Anova(r)
plot(totaldis~day,data=d,col=3-as.numeric(sex))

r <- lmer(meanangle~day*sex+(1|colony/id),data=d)
summary(r)
Anova(r)
plot(meanangle~day,data=d,col=3-as.numeric(sex))

r <- glmer(stop~day*sex+(1|colony/id),data=d,family=poisson)
summary(r)
Anova(r)
plot(stop~day,data=d,col=3-as.numeric(sex))

plot(totaldis~stop,data=d,col=3-as.numeric(sex))

S <- as.vector(speed)
meanspeed <- tapply(S[S>0 & !(is.na(S))],rep(name,each=7500)[S>0 & !(is.na(S))],mean)
r <- lmer(meanspeed ~day*sex+(1|colony/id),data=d)
summary(r)
Anova(r)
plot(meanspeed ~day,data=d,col=3-as.numeric(sex))

plot(totaldis ~a,data=d[d$a>0,],col=3-as.numeric(sex))
r <- lmer(totaldis~a+day*sex+(1|colony/id),data=d[d$a>0,])
Anova(r)

stop <- apply(na.omit(speed)==0,2,sum)

meanangle <- tapply(abs(na.omit(as.vector(angle))),rep(name,each=7500)[!(is.na(as.vector(angle)))],mean)



#write.table(d,"res.txt")



## ?O??plot
# ?S??
Day <- as.numeric(day)
par(mfrow=c(4,5),pin=c(1.5,1.5))
range <- 2000
for(num in 1:length(f.namesplace)){
  if(sex[num] == "F"){Col=2}else{Col=1}
  if(Day[num] == 1){
    plot(x[,num],y[,num],xlim=c(-range,range),ylim=c(-range,range),col=Day[num],type="l",main=paste(colony[num],sex[num],rep[num],sep=""))
  }else{
    par(new=T)
    plot(x[,num],y[,num],xlim=c(-range,range),ylim=c(-range,range),col=Day[num],type="l",ann=F,axes=F)
  }
}








## L?vy?@walk ??
par(mfrow=c(3,3),pin=c(2,2))
for(num in c(2,8,10,12,14,29,44,50,54)){
  range <- c(min(c(x[,num],y[,num])),max(c(x[,num],y[,num])))
  plot(x[,num],y[,num],col=1,type="l",xlim=range,ylim=range,main=paste(colony[num],sex[num],rep[num],sep=""))
}

## ???܂???
par(mfrow=c(3,3),pin=c(2,2))
for(num in c(18,20,21,27,28,41,49,56,60)){
  range <- c(min(c(x[,num],y[,num])),max(c(x[,num],y[,num])))
  plot(x[,num],y[,num],col=1,type="l",xlim=range,ylim=range,main=paste(colony[num],sex[num],rep[num],sep=""))
}



## ???܂???
par(mfrow=c(7,8),pin=c(1,1))
for(num in setdiff( setdiff(1:72, c(2,8,10,12,14,29,44,50,54)), c(18,20,21,27,28,41,49,56,60))){
  range <- c(min(c(x[,num],y[,num])),max(c(x[,num],y[,num])))
  plot(x[,num],y[,num],col=1,type="l",xlim=range,ylim=range,main=paste(colony[num],sex[num],rep[num],sep=""))
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



