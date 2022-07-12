# These R functions are based on the v1.0.0 algorithm, which
# re-sorts the test vectors every time. They work fine, but
# are somewhat slow.
# I've left them here this way because I find they are a clearer
# demonstration of how the test stat works.

dts_stat_R = function(vec1,vec2,power=1) {
  n1 = length(vec1)
  n2 = length(vec2)
  n = n1+n2

  joint.sample = c(vec1,vec2)
  e = c(rep(1/n1,n1),rep(0,   n2))
  f = c(rep(0,   n1),rep(1/n2,n2))

  ind = order(joint.sample)
  d = joint.sample[ind]
  e = e[ind]
  f = f[ind]

  out = 0
  Ecur = 0
  Fcur = 0
  Gcur = 0
  height = 0
  width = 0
  for (i in 1:(n-1)) {
    Ecur = Ecur + e[i]
    Fcur = Fcur + f[i]
    Gcur = Gcur+1/n
    sd = (2*Gcur*(1-Gcur)/n)**0.5
    height = abs(Fcur-Ecur)
    width = d[i+1]-d[i]
    out = out + ((height/sd)^power)*width
  }
  out
}

ks_stat_R = function(vec1,vec2,power=1) {
  n1 = length(vec1)
  n2 = length(vec2)
  n = n1+n2

  joint.sample = c(vec1,vec2)
  ee = c(rep(1/n1,n1),rep(0,   n2))
  ff = c(rep(0,   n1),rep(1/n2,n2))

  ind = order(joint.sample)
  d = joint.sample[ind]
  e = ee[ind]
  f = ff[ind]

  out = 0
  Ecur = 0
  Fcur = 0
  height = 0
  for (i in 1:(n-1)) {
    Ecur = Ecur + e[i]
    Fcur = Fcur + f[i]
    if (d[i] != d[i+1]) height = abs(Fcur-Ecur)
    if (height > out) out = height
  }
  out**power
}

kuiper_stat_R = function(vec1,vec2,power=1) {
  n1 = length(vec1)
n2 = length(vec2)
n = n1+n2

joint.sample = c(vec1,vec2)
ee = c(rep(1/n1,n1),rep(0,   n2))
ff = c(rep(0,   n1),rep(1/n2,n2))

ind = order(joint.sample)
d = joint.sample[ind]
e = ee[ind]
f = ff[ind]

up = 0
down = 0
Ecur = 0
Fcur = 0
height = 0
for (i in 1:(n-1)) {
  Ecur = Ecur + e[i]
  Fcur = Fcur + f[i]
  if (d[i] != d[i+1]) height = Fcur-Ecur
  if (height > up) up = height
  if (height < down) down = height
}
abs(down)**power + abs(up)**power
}
cvm_stat_R = function(vec1,vec2,power=2){
  n1 = length(vec1)
  n2 = length(vec2)
  n = n1+n2

  joint.sample = c(vec1,vec2)
  ee = c(rep(1/n1,n1),rep(0,   n2))
  ff = c(rep(0,   n1),rep(1/n2,n2))

  ind = order(joint.sample)
  d = joint.sample[ind]
  e = ee[ind]
  f = ff[ind]

  out = 0
  Ecur = 0
  Fcur = 0
  height = 0
  for (i in 1:(n-1)) {
    Ecur = Ecur + e[i]
    Fcur = Fcur + f[i]
    height = abs(Fcur-Ecur)
    if (d[i] != d[i+1]) out = out + height**power
  }
  out
}
ad_stat_R = function(vec1,vec2,power=2){
  n1 = length(vec1)
  n2 = length(vec2)
  n = n1+n2

  joint.sample = c(vec1,vec2)
  e = c(rep(1/n1,n1),rep(0,   n2))
  f = c(rep(0,   n1),rep(1/n2,n2))

  ind = order(joint.sample)
  d = joint.sample[ind]
  e = e[ind]
  f = f[ind]

  out = 0
  Ecur = 0
  Fcur = 0
  Gcur = 0
  height = 0
  dups = 1

  for (i in 1:(n-1)) {
    Ecur = Ecur + e[i]
    Fcur = Fcur + f[i]
    Gcur = Gcur+1/n
    sd = (2*Gcur*(1-Gcur)/n)**0.5
    height = abs(Fcur-Ecur)
    if (d[i] != d[i+1]) {
      out = out + ((height/sd)^power)*dups
      dups = 1
    } else if (d[i] == d[i+1]) {
      dups = dups+1
    }
  }
  out
}
wass_stat_R = function(vec1,vec2,power=1) {
  n1 = length(vec1)
  n2 = length(vec2)
  n = n1+n2

  joint.sample = c(vec1,vec2)
  ee = c(rep(1/n1,n1),rep(0,   n2))
  ff = c(rep(0,   n1),rep(1/n2,n2))

  ind = order(joint.sample)
  d = joint.sample[ind]
  e = ee[ind]
  f = ff[ind]

  out = 0
  Ecur = 0
  Fcur = 0
  height = 0
  width = 0
  for (i in 1:(n-1)) {
    Ecur = Ecur + e[i]
    Fcur = Fcur + f[i]
    height = abs(Fcur-Ecur)
    width = d[i+1]-d[i]
    out = out + (height**power)*width
  }
  out
}

# This function takes a test statistic function and builds test functions.
# It is not compatible with the current C code, because it passes two random vectors that need sorting.
permutation_test_builder_old = function(test_stat_function,default.p=2.0) {
  #Takes a function which builds test statistics -- gives a function which returns a permutation based p-value.
  #Function input spec: must take a combined vector and a label vector. Must take 2 more numeric arguments -- though it need not use them

  # little function that finds the *_stat name and saves it for later use.
  fun.name = toupper(strsplit(as.character(match.call()[2]),"_")[[1]][1])
  fun = function(a,b,nboots=2000,p=default.p,keep.boots=T,keep.samples=F){
    na = length(a)
    nb = length(b)
    n  = na+nb
    comb = as.numeric(c(a,b))

    test_stat = test_stat_function(a,b,p)			#Finds test stat
    nboots = as.integer(nboots)					#Speeds up comparison below.
    reps = bigger = 0L							  #Initializes Counter
    if (keep.boots) boots = numeric(nboots) #initialize storage of boots
    while (reps < nboots) {						#Loops over vector
      e = sample.int(n,na,F)
      boot_t = test_stat_function(comb[e],comb[-e],p)  #boot strap test stat
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

# Now we can build test functions for each test stat.
ks_test_R     = permutation_test_builder_old(ks_stat_R,    1.0)
kuiper_test_R = permutation_test_builder_old(kuiper_stat_R,1.0)
cvm_test_R    = permutation_test_builder_old(cvm_stat_R,   2.0)
ad_test_R     = permutation_test_builder_old(ad_stat_R,    2.0)
wass_test_R   = permutation_test_builder_old(wass_stat_R,  1.0)
dts_test_R    = permutation_test_builder_old(dts_stat_R,   1.0)


