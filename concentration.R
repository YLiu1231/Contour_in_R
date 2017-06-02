library(tidyverse)
library(ggplot2)
library(png)
library(reshape2)
library(xlsx)
library(parallel)
library(scales)

# read a png file.
jslake <- readPNG("lakewithbranch.png") 

# print the size of this plot.
dim(jslake)

# use rgb values and divide the whole data 
# ( an array actually.) into three parts.
red.lake <- jslake[,,1]
green.lake <- jslake[,,2]
blue.lake <- jslake[,,3]

# save this plot to local for checking the correctness.
writePNG(jslake,"try.png")

# load our core data. 35 observations with 4 variables.
observation<-read.csv("observation.csv",header = TRUE)

#######################################################
############ if we can find a good function ###########
#######################################################

discal<-function(vec){
  vec<-as.numeric(vec)
  z0/log(log(sqrt((x0-vec[2])^2+(y0-vec[1])^2)+exp(1))+exp(1))
}

A<-c(0)
for(i in 1:35){
  x0<-observation[i,2]
  y0<-observation[i,3]
  z0<-observation[i,4]
  bigmatrix<-matrix(0,1014,2518)
  bigmatrix1<-melt(bigmatrix)
  dis1<-(x0-1)^2+(y0-1)^2
  dis2<-(x0-1)^2+(y0-1014)^2
  dis3<-(x0-2518)^2+(y0-1)^2
  dis4<-(x0-2518)^2+(y0-1014)^2
  maxdis<-sqrt(max(dis1,dis2,dis3,dis4))
  A<-A+apply(bigmatrix1,MARGIN = 1,FUN = discal)
}
A<-A/35
C<-(A-min(A))/(max(A)-min(A))*70
bigmatrix1[,3]<-C

quan<-C
qquan<-quantile(quan,probs = seq(0,1,0.05))
c5<-seq(1,1014,by=5)
r5<-seq(1,2518,by=5)
bigmatrix2<-filter(bigmatrix1,Var1%in%c5&Var2%in%r5)
Contour<-ggplot(bigmatrix2,aes(x=Var2,y=1014-Var1,z=value))+
  geom_tile(aes(fill=value))+
  scale_fill_gradientn(colours = rainbow(21))+
  stat_contour(breaks=qquan)+
  # stat_contour(aes(colour= ..level..))+
  labs(x="X",y="Y",fill="concentration",title="Contour")

############ use 2 variables polynomial##################
coeffmatrix<-matrix(0,35,35)

coecal<-function(x,y){
  return(c(1,y,y^2,y^3,y^4,x,x*y,x*y^2,x*y^3,x*y^4,
           x^2,x^2*y,x^2*y^2,x^2*y^3,x^2*y^4,
           x^3,x^3*y,x^3*y^2,x^3*y^3,x^3*y^4,
           x^4,x^4*y,x^4*y^2,x^4*y^3,x^4*y^4,
           x^5,x^5*y,x^5*y^2,x^5*y^3,x^5*y^4,
           x^6,x^6*y,x^6*y^2,x^6*y^3,x^6*y^4))
}
for(i in 1:35){
  coeffmatrix[i,]<-coecal(observation[i,2]/2518,observation[i,3]/1014)
}
coez<-observation[,4][1:35]
coepara<-solve(coeffmatrix)%*%coez
sum(coecal(observation[12,2]/2518,observation[12,3]/1014)*coepara)

lastcal<-function(vec){
  vec<-as.numeric(vec)
  sum(coecal(vec[2]/2518,vec[1]/1014)*coepara)
}
bigmatrix3<-matrix(0,1014,2518)
bigmatrix3<-melt(bigmatrix3)
B<-apply(bigmatrix3,MARGIN = 1,FUN = lastcal)
bigmatrix3[,3]<-B

quan<-B
qquan<-quantile(quan,probs = seq(0,1,0.1))
c5<-seq(1,1014,by=5)
r5<-seq(1,2518,by=5)
bigmatrix4<-filter(bigmatrix3,Var1%in%c5&Var2%in%r5)
Contour<-ggplot(bigmatrix4,aes(x=Var2,y=Var1,z=value))+
  geom_tile(aes(fill=value))+
  scale_fill_gradientn(colours = rainbow(11))+
  stat_contour(breaks=qquan)+
  # stat_contour(aes(colour= ..level..))+
  labs(x="X",y="Y",fill="concentration",title="Contour")
