# Some functions for the twosamples class.

#' @export
print.twosamples = function(x,...) {
  print(x[1:2])
  if (x[2] == 1/(2*attr(x,"details")[3])) message("No bootstrap values were more extreme than the observed value. \n p-value = 1/(2*bootstraps) is an imprecise placeholder")
}

#' @export
summary.twosamples = function(object,...) {
  cat(attr(object,"test_type"),"\n") #need to stow test type in attr somehow. function `f` below starts figuring this out.
  print(object[1:2])
  print(attr(object,"details"))
  if (object[2] == 1/(2*attr(object,"details")[3])) message("No bootstrap values were more extreme than the observed value. \n p-value = 1/(2*bootstraps) is an imprecise placeholder")
}

#' @importFrom graphics abline hist
#' @export
plot.twosamples = function(x,boothist=T,ECDF=F,...) {
  if (class(x) != "twosamples") {
      stop("This function is for use with an object produced by a *_test function in the twosamples package.")
  }
  if (ECDF) {
    stop("ECDF plots have not yet been implemented. \n This feature is coming soon")
  }
  if (boothist) {
    if (is.null(attr(x,"bootstraps"))) stop("When you run ",attr(x,"test_type"),", `keep.boots` must be TRUE to plot a histogram")
    boots = attr(x,"bootstraps")
    test_stat = x[1]
    lims = range(c(boots,test_stat))
    test_type = attr(x,"test_type")
    title = paste0(test_type,": Boostrap Distribution + Test Stat")
    subtitle = paste0("p-val = ",x[2])
    xlab = "Boostrapped Test Stat Values, Test stat in red"
    hist(boots,...,breaks=50, main = title,sub=subtitle,xlim=lims,xlab=xlab,freq=F)
    abline(v = x[1],col=2)
  }
}

