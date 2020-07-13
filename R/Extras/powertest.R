if (F) {
library(twosamples)


# Function that can run power comparisons.
comp.test = function(nobs,f1,f2,nboots = 1000,alpha=0.05,alt.test=NULL) {
  alt.test.bool = !missing(alt.test)
  out = replicate(nboots,{
    a = f1(nobs)
    b = f2(nobs)
    nreps = 500 #This slows things down a lot.
    ks = ks_test(a,b,nreps)[2]
    kuiper = kuiper_test(a,b,nreps)[2]
    ad = ad_test(a,b,nreps)[2]
    cvm = cvm_test(a,b,nreps)[2]
    wass = wass_test(a,b,nreps)[2]
    dts = dts_test(a,b,nreps)[2]
    output = c("ks" = ks,"kuiper" = kuiper,"ad" = ad,"cvm" = cvm,"wass" = wass,"dts" = dts)
    if (alt.test.bool) {
      output = c(output,alt.test(a,b,nreps)[2])
      names(output)[7] = "alt.P-Value"
    }
    output
  })
  rowMeans(out <= alpha)
}


#---------------------------------------------
#         Sequences along N for mu/sig diffs
#---------------------------------------------

d1 = function(n) rnorm(n)
#Mean shift
d2 = function(n) rnorm(n,1)
#Variance inflation (mean-preserving spread)
d3 = function(n) rnorm(n,,2)
#Mean and variance change
d2a = function(n) rnorm(n,0.5,1.5)

#Mixture with mean fixed
d5 = function(n) ifelse(rbinom(n,1,0.2),rnorm(n,1),rnorm(n))-0.2
#Mixture with variance fixed
d6 = function(n) ifelse(rbinom(n,1,0.2),rnorm(n,,2),rnorm(n))/sqrt(1.6)
#Mixture with mean and variance fixed
d7 = function(n) (ifelse(rbinom(n,1,0.2),rnorm(n,1,2),rnorm(n))-0.2)/sqrt(1.7607)



t_test = function(a,b,nreps=1) {
  k = nreps
  par = t.test(a,b,var.equal=T)
  unlist(par[c(1,3)])
}
f_test = function(a,b,nreps=1) {
  k = nreps
  par = var.test(a,b)
  unlist(par[c(1,3)])
}



sample.sizes = floor(2^(seq(3,7,by=0.5)))

test1 = sapply(sample.sizes,comp.test,f1=d1,f2=d2,alt.test=t_test,nboots=10000)
test2 = sapply(sample.sizes,comp.test,f1=d1,f2=d3,alt.test=f_test,nboots=10000)
test2a = sapply(sample.sizes,comp.test,f1=d1,f2=d2a,alt.test=t_test,nboots=10000)
test5 = sapply(sample.sizes,comp.test,f1=d1,f2=d5,nboots=200,alt.test=t_test)
test6 = sapply(sample.sizes,comp.test,f1=d1,f2=d6,nboots=200,alt.test=t_test)
test7 = sapply(sample.sizes,comp.test,f1=d1,f2=d7,nboots=200,alt.test=t_test)


#---------------------------------------------
#       Sequences along mu/sig for fixed N
#---------------------------------------------


# Shifting mean
mu.diffs = seq(0,1,by=0.1)

ms.f = function(x) {
  d4 = function(n) rnorm(n,x)
  comp.test(50,d1,d4,alt.test=t_test,nboots=10000)
}


test3 = sapply(mu.diffs,ms.f)

#Shifting variance
sig.diffs = seq(1,3,by=0.2)

sd.f = function(x) {
  d5 = function(n) rnorm(n,,x)
  comp.test(50,d1,d5,alt.test=f_test,nboots=10000)
}

test4 = sapply(sig.diffs,sd.f)


#---------------------------------------------
#            Data Cleaning
#---------------------------------------------


test1 = as.data.frame(t(test1))
test2 = as.data.frame(t(test2))
test2a = as.data.frame(t(test2a))
test3 = as.data.frame(t(test3))
test4 = as.data.frame(t(test4))
test5 = as.data.frame(t(test5))
test6 = as.data.frame(t(test6))
test7 = as.data.frame(t(test7))

colnames(test1) = c("ks","kuiper","ad","cvm","wass","dts","t.test")
colnames(test2) = c("ks","kuiper","ad","cvm","wass","dts","f.test")

colnames(test2a) =  colnames(test3) = colnames(test1)
colnames(test5) = colnames(test6) = colnames(test7) = colnames(test1)
colnames(test4) = colnames(test2)


test1$nobs  = sample.sizes
test2$nobs  = sample.sizes
test2a$nobs = sample.sizes
test5$nobs  = sample.sizes
test6$nobs  = sample.sizes
test7$nobs  = sample.sizes
test3$mu2 = mu.diffs
test4$sig2 = sig.diffs

#---------------------------------------------
#              Saving
#---------------------------------------------

save.image("dts_sims.RData")
}
