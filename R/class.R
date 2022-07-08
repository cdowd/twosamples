# Some functions for the twosamples class.

#' @describeIn twosamples_class Print method for objects of class twosamples
#' @export
print.twosamples = function(x,...) {
  print(x[1:2])
  if (x[2] == 1/(2*attr(x,"details")[3])) message("No bootstrap values were more extreme than the observed value. \n p-value = 1/(2*bootstraps) is an imprecise placeholder")
}

#' @describeIn twosamples_class Summary method for objects of class twosamples
#' @export
summary.twosamples = function(object,...) {
  cat(attr(object,"test_type"),"\n") #need to stow test type in attr somehow. function `f` below starts figuring this out.
  print(object[1:2])
  print(attr(object,"details"))
  if (object[2] == 1/(2*attr(object,"details")[3])) message("No bootstrap values were more extreme than the observed value. \n p-value = 1/(2*bootstraps) is an imprecise placeholder")
}

#' Default plots for `twosamples` objects
#'
#' Typically for now this will produce a histogram of the
#' null distribution based on the bootstrapped values,
#' with a vertical line marking the value of the test statistic.
#'
#' @param x an object produced by one of the twosamples `*_test` functions
#' @param plot_type which plot to create? one or multiple of "boots_hist", "ECDF" (not functional yet), and  "ECDF_gap" (not functional yet)
#' @param nbins how many bins (or breaks) in the histogram
#' @param ggplot Should the function use ggplot2 (if available)?
#' @param silent suppress messages?
#'
#' @return Produces a plot (or in the case of ggplot=T, a ggplot object)
#' @seealso [dts_test()], [twosamples_class], [combine.twosamples]
#'
#' @examples
#' out = dts_test(rnorm(10),rnorm(10,1))
#' plot(out)
#'
#' @export
plot.twosamples = function(x,plot_type=c("boots_hist"),nbins=50,ggplot=T,silent=F,...) {
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
    subtitle = paste0("p-val = ",x[2])
    xlab = "Boostrapped Test Stat Values, Test stat in red"
    if (requireNamespace("ggplot2",quietly = TRUE) & ggplot) {
      ggplot2::ggplot(data.frame(boots=boots),ggplot2::aes(x=boots)) +
        ggplot2::geom_histogram(bins=nbins,...)+
        ggplot2::geom_vline(xintercept=test_stat,col="red")+
        ggplot2::labs(title=title,subtitle=subtitle)+
        ggplot2::xlab(xlab)
    } else {
      #`graphics` is in r-base, every R install should have.
     graphics::hist(boots,...,breaks=nbins,
          main = title,
          sub=subtitle,
          xlim=lims,
          xlab=xlab,
          freq=F)
     graphics::abline(v = x[1],col=2)
     if(!silent & ggplot) message("Prettier plots are available if you install `ggplot2`")
    }
  }
}

#' Combine two objects of class `twosamples`
#'
#' @description This function combines two `twosamples` objects -- concatenating bootstraps, recalculating pvalues, etc.
#' It only works if both objects were created with "keep.boots=T" This function is intended for one main purposes: combining parallized null calculations and then plotting those combined outputs.
#' @param x a twosamples object
#' @param y a different twosamples object from the same `*_test` function run on the same data
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
combine.twosamples = function(x,y) {
  if (class(y) != "twosamples" | class(x) != "twosamples")
    stop("One of these test statistics is not from the twosamples package")
  if (attr(x,"test_type") != attr(y,"test_type"))
    stop("These test outputs are not from the same test type")
  if (x[1] != y[1])
    stop("These test statistics are different, probably these objects are not based on the same samples")
  if (!is.null(attr(x,"samples")) & !is.null(attr(x,"samples"))){
    xa = sort(attr(x,"samples")$a)
    xb = sort(attr(x,"samples")$b)
    ya = sort(attr(y,"samples")$a)
    yb = sort(attr(y,"samples")$b)
    if (!identical(list(xa,xb),list(ya,yb)))
      if (!identical(list(xa,xb),list(yb,ya)))
       stop("These test outputs are not from the same samples")
  }
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
