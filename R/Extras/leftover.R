# #Excess Code
#
#' Building R test functions from cpp compilations
#'

# sourceCpp("/home/cdowd/twosamples/src/rcpp_test_functions.cpp")
# source("/home/cdowd/twosamples/R/permutation_builder.R")

#
#
#
#
#
# #Plotting function which plots and returns test values
# db.plot = function(a,b,boots=2000){
#   t=dt_stat(a,b,1.0)
#   na = 1:length(a)
#   nb = 1:length(b) + length(a)
#   boot_ts = replicate(boots,{d = sample(c(a,b));dt_stat(d[na],d[nb],1.0)})
#   plot(density(boot_ts),xlim = c(0,max(boot_ts,t)),main="Null Areas vs. Sample Area")
#   abline(v=t,col='salmon')
#   out = c(t,1-mean(boot_ts < t))
#   names(out) = c("Test Stat","P-Value")
#   return(out)
# }
#
#
# #Plotting function which plots and returns test values
# dbs.plot = function(a,b,boots=2000){
#   t=dt_stat(a,b,1.0)
#   na = 1:length(a)
#   nb = 1:length(b) + length(a)
#   boot_ts = replicate(boots,{d = sample(c(a,b));dts_stat(d[na],d[nb],1.0)})
#   plot(density(boot_ts),xlim = c(0,max(boot_ts,t)),main="Null Areas vs. Sample Area")
#   abline(v=t,col='salmon')
#   out = c(t,1-mean(boot_ts < t))
#   names(out) = c("Test Stat","P-Value")
#   return(out)
# }
