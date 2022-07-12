# Some functions for the twosamples class.

#' @describeIn twosamples_class Print method for objects of class twosamples
#' @export
print.twosamples = function(x,...) {
  print(x[1:2])
  if (x[2] == 1/(2*attr(x,"details")[3])) message("No bootstrap values were more extreme than the observed value. \n p-value = 1/(2*bootstraps) is an imprecise placeholder")
  return(invisible(NULL))
}

#' @describeIn twosamples_class Summary method for objects of class twosamples
#' @export
summary.twosamples = function(object,alpha=0.05,...) {
  cat(attr(object,"test_type"),"\n") #need to stow test type in attr somehow. function `f` below starts figuring this out.
  cat("=========================\n")
  cat("Test Statistic:",object[1],"\n")
  cat("       P-Value:",object[2],ifelse(object[2]<alpha,"*\n","\n"))
  cat("- - - - - - - - - - - - -\n")
  print(attr(object,"details"))
  cat("=========================\n")
  if (!is.null(attr(object,"bootstraps"))) {
    q95 = stats::quantile(attr(object,"bootstraps"),1-alpha)
    cat("Test stat rejection threshold for alpha =",alpha,"is:",q95,"\n")
  }
  if (object[2] < alpha) {
    cat("Null rejected: samples are from different distributions")
  } else {
    cat("Null not rejected: samples may be from same distribution")
  }
  if (object[2] == 1/(2*attr(object,"details")[3])) {
    cat("\n Max observed bootstrap value:",max(attr(object,"bootstraps")), "\n")
    message("No bootstrap values were more extreme than the observed value. \n p-value = 1/(2*bootstraps) is an imprecise placeholder")
  }
  return(invisible(NULL))
}



#' Default plots for `twosamples` objects
#'
#' Typically for now this will produce a histogram of the
#' null distribution based on the bootstrapped values,
#' with a vertical line marking the value of the test statistic.
#'
#' @param x an object produced by one of the twosamples `*_test` functions
#' @param plot_type which plot to create? only current option is "boots_hist",
#' @param nbins how many bins (or breaks) in the histogram
#' @param ... other parameters to be passed to plotting functions
#'
#' @return Produces a plot
#' @seealso [dts_test()], [twosamples_class], [combine.twosamples]
#'
#' @examples
#' out = dts_test(rnorm(10),rnorm(10,1))
#' plot(out)
#'
#' @export
plot.twosamples = function(x,plot_type=c("boots_hist"),nbins=50,...) {
  if ("ECDF" %in% plot_type) {
    stop("ECDF plots have not yet been implemented. \n This feature may be coming soon")
  }
  if ("ECDF_gap" %in% plot_type) {
    stop("ECDF gap plots have not yet been implemented. \n This feature may be coming soon.")
  }
  if ("boots_hist" %in% plot_type) {
    if (is.null(attr(x,"bootstraps"))) stop("When you run ",attr(x,"test_type"),", `keep.boots` must be TRUE to plot a histogram")
    boots = attr(x,"bootstraps")
    test_stat = x[1]
    lims = range(c(boots,test_stat))
    test_type = attr(x,"test_type")
    title = paste0(test_type,": Boostrap Distribution + Test Stat")
    subtitle = paste0("p-val = ",x[2]," | Test stat =~",signif(x[1],3))
    xlab = "Boostrapped Test Stat Values, Test stat at red line"
    #`graphics` is in r-base, every R install should have.
    if (test_stat > max(boots)) lims[2] = lims[2]*1.1
    graphics::hist(boots,...,breaks=nbins,
          main = title,
          sub=subtitle,
          xlim=lims,
          xlab=xlab,
          freq=F)
    graphics::abline(v = x[1],col=2)
  }
  return(invisible(NULL))
}

#' Combine two objects of class `twosamples`
#'
#' @description This function combines two `twosamples` objects -- concatenating bootstraps, recalculating pvalues, etc.
#' It only works if both objects were created with "keep.boots=T" This function is intended for one main purposes: combining parallized null calculations and then plotting those combined outputs.
#' @param x a twosamples object
#' @param y a different twosamples object from the same `*_test` function run on the same data
#' @param check.sample check that the samples saved in each object are the same? (can be slow)
#'
#' @return a twosamples object that correctly re-calculates the p-value and determines all the other attributes
#' @examples
#' vec1 = rnorm(10)
#' vec2 = rnorm(10,1)
#' out1 = dts_test(vec1,vec2)
#' out2 = dts_test(vec1,vec2)
#' combined = combine.twosamples(out1,out2)
#' summary(out1)
#' summary(out2)
#' summary(combined)
#' plot(combined)
#' @seealso [twosamples_class], [plot.twosamples], [dts_test]
#' @export
combine.twosamples = function(x,y,check.sample=T) {
  if (!inherits(y, "twosamples") | !inherits(x,"twosamples"))
    stop("One of these test statistics is not from the twosamples package")
  if (attr(x,"test_type") != attr(y,"test_type"))
    stop("These test outputs are not from the same test type")
  if (x[1] != y[1])
    stop("These test statistics are different, probably these objects are not based on the same samples")
  if (!is.null(attr(x,"samples")) & !is.null(attr(y,"samples")) & check.sample){
    xa = sort(attr(x,"samples")$a)
    xb = sort(attr(x,"samples")$b)
    ya = sort(attr(y,"samples")$a)
    yb = sort(attr(y,"samples")$b)
    if (!identical(list(xa,xb),list(ya,yb)))
      if (!identical(list(xa,xb),list(yb,ya)))
       stop("These test outputs are not from the same samples")
  }
  if (is.null(attr(x,"bootstraps")) | is.null(attr(y,"bootstraps")))
    stop("One of these test statistics does not have bootstraps, combined simply by using a weighted average p-value and updating nboots")

  out = x
  bootstraps = c(attr(x,"bootstraps"),attr(y,"bootstraps"))
  out[2] = mean(bootstraps >= out[1])
  attr(out,"bootstraps") = bootstraps
  nboot = length(bootstraps)
  if (out[2] == 0) out[2] = 1/(2*nboot)
  attr(out,"details")[3] = nboot
  if (is.null(attr(x,"samples")) & !is.null(attr(y,"samples")))
    attr(out,"samples") = attr(y,"samples")
  out
}


