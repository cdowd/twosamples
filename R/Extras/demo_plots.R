library(twosamples)
library(tidyverse)

#---------------------------------------------
#              Data Generation
#---------------------------------------------
set.seed(123424)
n = 50
x = rnorm(n)
y = rnorm(n,0.5,2)

dfx = data.frame(sort(x),cumsum(rep(1/n,n)),"x")
dfy = data.frame(sort(y),cumsum(rep(1/n,n)),"y")
colnames(dfx) = colnames(dfy) = c("point","ecdf","sample")
df = rbind(dfy,dfx)

combined = sort(c(x,y))
midpoints = combined[-(2*n)]+diff(combined)/2
fhat = ehat = dhat = width = numeric(2*n-1)
for (i in 1:(2*n-1)) {
  point = midpoints[i]
  width[i] = (point-combined[i])*2
  fhat[i] = mean(y < point)
  ehat[i] = mean(x < point)
  dhat[i] = mean(combined < point)
}
gap = fhat-ehat

#---------------------------------------------
#              KS Test
#---------------------------------------------

ind1 = which.max(abs(gap))
point1 = midpoints[ind1]

p1 = ggplot()+geom_step(data=df,aes(x=point,y=ecdf,color=sample)) + geom_segment(aes(x = point1,xend = point1,y=ehat[ind1],yend=fhat[ind1]),inherit.aes=F)


#---------------------------------------------
#              Kuiper
#---------------------------------------------

ind = c(which.max(gap),which.min(gap))
point = midpoints[ind]
p2 = ggplot()+geom_step(data=df,aes(x=point,y=ecdf,color=sample)) + geom_segment(aes(x = point,xend = point,y=ehat[ind],yend=fhat[ind]),inherit.aes=F)


#---------------------------------------------
#              CVM
#---------------------------------------------
p3 = ggplot()+geom_step(data=df,aes(x=point,y=ecdf,color=sample)) + geom_segment(aes(x = midpoints,xend = midpoints,y=ehat,yend=fhat),inherit.aes=F)


#---------------------------------------------
#              Variances
#---------------------------------------------
p4.1 = ggplot()+geom_step(aes(x=midpoints,y=(dhat*(1-dhat))),direction="mid")

#---------------------------------------------
#              AD
#---------------------------------------------
p4 = ggplot()+geom_step(data=df,aes(x=point,y=ecdf,color=sample)) + geom_segment(aes(x = midpoints,xend = midpoints,y=ehat,yend=fhat,alpha=log(1/(dhat*(1-dhat)))-2),lwd=1,inherit.aes=F)

#---------------------------------------------
#              Wasserstein
#---------------------------------------------

x1 = midpoints-0.5*width
x2 = midpoints+0.5*width
y1 = ehat
y2 = fhat
block = 1:(2*n-1)
alpha = 1/(dhat*(1-dhat))

df3.1 = cbind(x1,y1,block,alpha)
df3.2 = cbind(x1,y2,block,alpha)
df3.3 = cbind(x2,y2,block,alpha)
df3.4 = cbind(x2,y1,block,alpha)

df3 = rbind(df3.1,df3.2,df3.3,df3.4)
colnames(df3) = c("point","ecdf","block","weights")
df3 = as_tibble(df3) %>% arrange(block)

p5 = ggplot()+geom_polygon(data=df3,aes(x=point,y=ecdf,group=block),alpha=0.7)+geom_step(data=df,aes(y=ecdf,x=point,col=sample))

#---------------------------------------------
#              DTS
#---------------------------------------------

df3 = df3 %>% mutate(weights = log(log(log(weights))))

p6 = ggplot()+geom_polygon(data=df3,aes(x=point,y=ecdf,group=block,alpha=weights))+geom_step(data=df,aes(y=ecdf,x=point,col=sample))




#---------------------------------------------
#              Showing plots
#---------------------------------------------



p1 + ylab("ECDF") + xlab("Value")+
  theme(legend.position="none")
p2+ ylab("ECDF") + xlab("Value")+
  theme(legend.position="none")
p3+ ylab("ECDF") + xlab("Value")+
  theme(legend.position="none")
p4+ ylab("ECDF") + xlab("Value")+
  theme(legend.position="none")
p4.1+ ylab("Variance Estimate") + xlab("Value")+
  theme(legend.position="none")
p5+ ylab("ECDF") + xlab("Value")+
  theme(legend.position="none")
p6+ ylab("ECDF") + xlab("Value")+
  theme(legend.position="none")





