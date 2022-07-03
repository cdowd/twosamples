# Couple of utility functions
# 1. Takes test statistic function, makes a full bootstrap function
# 2. Takes a test stat function, makes a useable test stat function
#    - i.e. consistent with pre-existing test_stat fns syntax

#' @describeIn permutation_test_builder Takes a test statistic, returns a testing function.
permutation_test_builder = function(test_stat_function,default.p=2.0) {
  #Takes a function which builds test statistics -- gives a function which returns a permutation based p-value.
  #Function input spec: must take a combined vector and a label vector. Must take 2 more numeric arguments -- though it need not use them

  # little function that finds the *_stat name and saves it for later use.
  fun.name = toupper(strsplit(as.character(match.call()[2]),"_")[[1]][1])
  fun = function(a,b,nboots=2000,p=default.p,keep.boots=T,keep.samples=F){
    na = length(a)
    nb = length(b)
    n  = na+nb
    comb = c(a,b)
    vec_labels = c(rep(T,na),rep(F,nb))
    ord_inds = order(comb)
    comb = comb[ord_inds]
    vec_labels = vec_labels[ord_inds]

    test_stat = test_stat_function(comb,vec_labels,p,na)			#Finds test stat
    nboots = as.integer(nboots)					#Speeds up comparison below.
    reps = bigger = 0L							  #Initializes Counter
    if (keep.boots) boots = numeric(nboots) #initialize storage of boots
    while (reps < nboots) {						#Loops over vector
      vec_labels = rep(F,n)
      vec_labels[sample.int(n,na,F)] = T #Samples indexes
      boot_t = test_stat_function(comb,vec_labels,p,na) #boot strap test stat
      if(boot_t >= test_stat) bigger = 1L+bigger #if new stat is bigger, increment
      reps = 1L+reps
      if (keep.boots) boots[reps] = boot_t #avoid storing if not using.
    }
    out = c(test_stat,bigger/nboots)
    if (out[2]==0) out[2] = 1/(2*nboots)
    details = c(na,n-na,nboots)
    names(details) = c("n1","n2","n.boots")
    attributes(out) = list(details=details,
                           test_type = paste0(fun.name," Test"))
    if (keep.boots) attr(out,"bootstraps") = boots
    if (keep.samples) attr(out,"samples") = list(a=a,b=b)
    names(out) = c("Test Stat","P-Value")
    class(out) = "twosamples"
    return(out)
  }
  return(fun)
}

# Test stat builder
# This function helps maintain syntax stability between v1.2.0 (and prior) and v2.0.0 onwards
stat_fn_builder = function(presort_stat_fn,def_power) {
  output = function(a,b,power=def_power) {
    joint = c(a,b)
    na = length(a)
    nb = length(b)
    labs = c(rep(T,na),rep(F,nb))
    inds = order(joint)
    joint = joint[inds]
    labs = labs[inds]
    presort_stat_fn(joint,labs,power,na)
  }
  output
}

