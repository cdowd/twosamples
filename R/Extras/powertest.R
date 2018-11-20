if(F) {
mean_stat = function(a,b,p) abs(mean(a)-mean(b))**p
mean_test = permutation_test_builder(mean_stat,1.0)


power = function(n) {
  obs = replicate(400,{
    a = rnorm(n)
    b = rnorm(n,,4)
    d = dts_test(a,b)[2]
    e = mean_test(a,b)[2]
    f = wass_test(a,b)[2]
    c(d,e,f)
    })
  rowMeans(obs<0.05)
}

sample.sizes = 1:20
powers = sapply(sample.sizes,power)

plot(powers[1,]~sample.sizes,type='l')
lines(sample.sizes,powers[2,],col="salmon")
lines(sample.sizes,powers[3,],col="lightblue")
abline(h=0.05,col="lightgrey",lty=2)
}
