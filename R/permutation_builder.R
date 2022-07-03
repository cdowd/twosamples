#' @describeIn permutation_test_builder Takes a test statistic, returns a testing function.
#' @export
permutation_test_builder = function(test_stat_function,default.p=2.0) {
  #Takes a function which builds test statistics -- gives a function which returns a permutation based p-value.
  #Function input spec: must take two different vectors. Must take 3rd argument -- though it need not use it.
  fun = function(a,b,nboots=2000,p=default.p){
    test_stat = test_stat_function(a,b,p)			#Finds test stat
    na = length(a)										#Finds length of A
    nb = length(b)
    n = nb+na 									#Finds total length
    comb = c(a,b)											#Combined vector
    nboots = as.integer(nboots)					#Speeds up comparison below.
    reps = bigger = 0L							  #Initializes Counters
    while (reps < nboots) {						#Loops over vector
      e = sample.int(n,na,F)
      boot_t = test_stat_function(comb[e],comb[-e],p) #boot strap test stat
      if(boot_t >= test_stat) bigger = 1L+bigger #if new stat is bigger, increment
      reps = 1L+reps
    }
    out = c(test_stat,bigger/nboots)
    if (out[2]==0) out[2] = 1/(2*nboots)
    details = c(na,n-na,nboots)
    names(details) = c("n1","n2","n.boots")
    attributes(out) = list(details=details)
    names(out) = c("Test Stat","P-Value")
    return(out)
  }
  return(fun)
}


#' Building Permutation Tests
#' Takes a function which generates a test statistic from two samples
#' Builds a function which generates permutation tests with that
#' test statistic.
#' Returns that function.




# #Takes output from above -- gives various information -- relies on attributes being intact
# permutation_test_interpreter = function(output,sig.threshold=0.05) {
#   p = output[2]
#   details = attributes(output)[[1]]
#   n1 = details[1]
#   n = details[2]+n1
#   boots = details[3]
#   multiple = choose(n,n1)
#   sig.pvalue = pbinom(p*boots,boots,sig.threshold)
#   nextup = ceiling(p*multiple)/multiple
#   nearest = round(p*multiple)/multiple
#   prob.nearest = dbinom(p*boots,boots,nearest)
#   out = c(sig.pvalue,nextup,nearest,prob.nearest)
#   cat("Returning the probability that this p-value is actually insignificant based on a binomial test statistic. We also return the next biggest possible p-value and the nearest possible p-value. We estimate the density of probability at the nearest possible p-value. This is relative -- Would not integrate to 1.\n")
#   names(out) = c("P.Insig","Cons Poss Est","Near Poss Est","Probability of Nearest P-est")
#   return(out)
# }
#

