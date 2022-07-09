## usethis namespace: start
#' @useDynLib twosamples, .registration = TRUE
## usethis namespace: end
NULL

# KS test -----------

#' Kolmogorov-Smirnov Test
#'
#' @description A two-sample test using the Kolmogorov-Smirnov test statistic (`ks_stat`).
#' @param a a vector of numbers (or factors -- see details)
#' @param b a vector of numbers
#' @param nboots Number of bootstrap iterations
#' @param p power to raise test stat to
#' @param power power to raise test stat to
#' @param keep.boots Should the bootstrap values be saved in the output?
#' @param keep.samples Should the samples be saved in the output?
#' @return Output is a length 2 Vector with test stat and p-value in that order. That vector has 3 attributes -- the sample sizes of each sample, and the number of bootstraps performed for the pvalue.
#' @details The KS test compares two ECDFs by looking at the maximum difference between them. Formally -- if E is the ECDF of sample 1 and F is the ECDF of sample 2, then \deqn{KS = max |E(x)-F(x)|^p} for values of x in the joint sample. The test p-value is calculated by randomly resampling two samples of the same size using the combined sample.
#'
#' In the example plot below, the KS statistic is the height of the vertical black line.
#'
#' ![](ks.png "Example KS stat plot")
#'
#' Inputs `a` and `b` can also be vectors of ordered (or unordered) factors, so long as both have the same levels and orderings. When possible, ordering factors will substantially increase power.
#' @seealso [dts_test()] for a more powerful test statistic. See [kuiper_test()] or [cvm_test()] for the natural successors to this test statistic.
#' @examples
#' vec1 = rnorm(20)
#' vec2 = rnorm(20,4)
#' out = ks_test(vec1,vec2)
#' out
#' summary(out)
#' plot(out)
#'
#' # Example using ordered factors
#' vec1 = factor(LETTERS[1:5],levels = LETTERS,ordered = TRUE)
#' vec2 = factor(LETTERS[c(1,2,2,2,4)],levels = LETTERS, ordered=TRUE)
#' ks_test(vec1,vec2)
#' @name ks_test
NULL

# Kuiper test ---------

#' Kuiper Test
#'
#' @description A two-sample test based on the Kuiper test statistic (`kuiper_stat`).
#' @param a a vector of numbers (or factors -- see details)
#' @param b a vector of numbers
#' @param nboots Number of bootstrap iterations
#' @param p power to raise test stat to
#' @param power power to raise test stat to
#' @param keep.boots Should the bootstrap values be saved in the output?
#' @param keep.samples Should the samples be saved in the output?
#' @return Output is a length 2 Vector with test stat and p-value in that order. That vector has 3 attributes -- the sample sizes of each sample, and the number of bootstraps performed for the pvalue.
#' @details The Kuiper test compares two ECDFs by looking at the maximum positive and negative difference between them. Formally -- if E is the ECDF of sample 1 and F is the ECDF of sample 2, then \deqn{KUIPER = |max_x E(x)-F(x)|^p + |max_x F(x)-E(x)|^p}. The test p-value is calculated by randomly resampling two samples of the same size using the combined sample.
#'
#' In the example plot below, the Kuiper statistic is the sum of the heights of the vertical black lines.
#'
#' ![](kuiper.png "Example Kuiper stat plot")
#'
#' Inputs `a` and `b` can also be vectors of ordered (or unordered) factors, so long as both have the same levels and orderings. When possible, ordering factors will substantially increase power.
#' @seealso [dts_test()] for a more powerful test statistic. See [ks_test()] for the predecessor to this test statistic, and [cvm_test()] for its natural successor.
#' @examples
#' vec1 = rnorm(20)
#' vec2 = rnorm(20,4)
#' out = kuiper_test(vec1,vec2)
#' out
#' summary(out)
#' plot(out)
#'
#'
#' # Example using ordered factors
#' vec1 = factor(LETTERS[1:5],levels = LETTERS,ordered = TRUE)
#' vec2 = factor(LETTERS[c(1,2,2,2,4)],levels = LETTERS, ordered=TRUE)
#' kuiper_test(vec1,vec2)
#' @name kuiper_test
NULL

# CVM test ------------

#' Cramer-von Mises Test
#'
#' @description A two-sample test based on the Cramer-Von Mises test statistic (`cvm_stat`).
#' @param a a vector of numbers (or factors -- see details)
#' @param b a vector of numbers
#' @param nboots Number of bootstrap iterations
#' @param p power to raise test stat to
#' @param power power to raise test stat to
#' @param keep.boots Should the bootstrap values be saved in the output?
#' @param keep.samples Should the samples be saved in the output?
#' @return Output is a length 2 Vector with test stat and p-value in that order. That vector has 3 attributes -- the sample sizes of each sample, and the number of bootstraps performed for the pvalue.
#' @details The CVM test compares two ECDFs by looking at the sum of the squared differences between them -- evaluated at each point in the joint sample. Formally -- if E is the ECDF of sample 1 and F is the ECDF of sample 2, then \deqn{CVM = \sum_{x\in k}|E(x)-F(x)|^p}{CVM = SUM_(x in k) |E(x)-F(x)|^p} where k is the joint sample. The test p-value is calculated by randomly resampling two samples of the same size using the combined sample. Intuitively the CVM test improves on KS by using the full joint sample, rather than just the maximum distance -- this gives it greater power against shifts in higher moments, like variance changes.
#'
#' In the example plot below, the CVM statistic is the sum of the heights of the vertical black lines.
#'
#' ![](cvm.png "Example CVM stat plot")
#'
#' Inputs `a` and `b` can also be vectors of ordered (or unordered) factors, so long as both have the same levels and orderings. When possible, ordering factors will substantially increase power.
#' @seealso [dts_test()] for a more powerful test statistic. See [ks_test()] or [kuiper_test()] for the predecessors to this test statistic. See [wass_test()] and [ad_test()] for the successors to this test statistic.
#' @examples
#' vec1 = rnorm(20)
#' vec2 = rnorm(20,4)
#' out = cvm_test(vec1,vec2)
#' out
#' summary(out)
#' plot(out)
#'
#' # Example using ordered factors
#' vec1 = factor(LETTERS[1:5],levels = LETTERS,ordered = TRUE)
#' vec2 = factor(LETTERS[c(1,2,2,2,4)],levels = LETTERS, ordered=TRUE)
#' cvm_test(vec1,vec2)
#' @name cvm_test
NULL


# AD test ------------------

#' Anderson-Darling Test
#'
#' @description A two-sample test based on the Anderson-Darling test statistic (`ad_stat`).
#' @param a a vector of numbers (or factors -- see details)
#' @param b a vector of numbers
#' @param nboots Number of bootstrap iterations
#' @param p power to raise test stat to
#' @param power power to raise test stat to
#' @param keep.boots Should the bootstrap values be saved in the output?
#' @param keep.samples Should the samples be saved in the output?
#' @return Output is a length 2 Vector with test stat and p-value in that order. That vector has 3 attributes -- the sample sizes of each sample, and the number of bootstraps performed for the pvalue.
#' @details The AD test compares two ECDFs by looking at the weighted sum of the squared differences between them -- evaluated at each point in the joint sample. The weights are determined by the variance of the joint ECDF at that point, which peaks in the middle of the joint distribution (see figure below). Formally -- if E is the ECDF of sample 1, F is the ECDF of sample 2, and G is the ECDF of the joint sample then \deqn{AD = \sum_{x \in k} \left({|E(x)-F(x)| \over \sqrt{2G(x)(1-G(x))/n} }\right)^p }{AD =  SUM_(x in k) (|E(x)-F(x)|/sqrt(2G(x)*(1-G(x)))/n)^p} where k is the joint sample. The test p-value is calculated by randomly resampling two samples of the same size using the combined sample. Intuitively the AD test improves on the CVM test by giving lower weight to noisy observations.
#'
#' In the example plot below, we see the variance of the joint ECDF over the range of the data. It clearly peaks in the middle of the joint sample.
#'
#' ![](var.png "Plot of Variance of joint ECDF")
#'
#' In the example plot below, the AD statistic is the weighted sum of the heights of the vertical lines, where weights are represented by the shading of the lines.
#'
#' ![](ad.png "Example AD stat plot")
#'
#' Inputs `a` and `b` can also be vectors of ordered (or unordered) factors, so long as both have the same levels and orderings. When possible, ordering factors will substantially increase power.
#' @seealso [dts_test()] for a more powerful test statistic. See [cvm_test()] for the predecessor to this test statistic. See [dts_test()] for the natural successor to this test statistic.
#' @examples
#' vec1 = rnorm(20)
#' vec2 = rnorm(20,4)
#' out = ad_test(vec1,vec2)
#' out
#' summary(out)
#' plot(out)
#'
#' # Example using ordered factors
#' vec1 = factor(LETTERS[1:5],levels = LETTERS,ordered = TRUE)
#' vec2 = factor(LETTERS[c(1,2,2,2,4)],levels = LETTERS, ordered=TRUE)
#' ad_test(vec1,vec2)
#' @name ad_test
NULL


# Wass test ---------------

#' Wasserstein Distance Test
#' @description A two-sample test based on Wasserstein's distance (`wass_stat`).
#' @param a a vector of numbers (or factors -- see details)
#' @param b a vector of numbers
#' @param nboots Number of bootstrap iterations
#' @param p power to raise test stat to
#' @param power power to raise test stat to
#' @param keep.boots Should the bootstrap values be saved in the output?
#' @param keep.samples Should the samples be saved in the output?
#' @return Output is a length 2 Vector with test stat and p-value in that order. That vector has 3 attributes -- the sample sizes of each sample, and the number of bootstraps performed for the pvalue.
#' @details The Wasserstein test compares two ECDFs by looking at the Wasserstein distance between the two. This is of course the area between the two ECDFs. Formally -- if E is the ECDF of sample 1 and F is the ECDF of sample 2, then \deqn{WASS = \int_{x \in R} |E(x)-F(x)|^p}{WASS = Integral |E(x)-F(x)|^p} across all x. The test p-value is calculated by randomly resampling two samples of the same size using the combined sample. Intuitively the Wasserstein test improves on CVM by allowing more extreme observations to carry more weight. At a higher level -- CVM/AD/KS/etc only require ordinal data. Wasserstein gains its power because it takes advantages of the properties of interval data -- i.e. the distances have some meaning.
#'
#' In the example plot below, the Wasserstein statistic is the shaded area between the ECDFs.
#'
#' ![](wass.png "Example Wasserstein stat plot")
#'
#' Inputs `a` and `b` can also be vectors of ordered (or unordered) factors, so long as both have the same levels and orderings. When possible, ordering factors will substantially increase power. `wass_test` will assume the distance between adjacent factors is 1.
#' @seealso [dts_test()] for a more powerful test statistic. See [cvm_test()] for the predecessor to this test statistic. See [dts_test()] for the natural successor of this test statistic.
#' @examples
#' vec1 = rnorm(20)
#' vec2 = rnorm(20,4)
#' out = wass_test(vec1,vec2)
#' out
#' summary(out)
#' plot(out)
#'
#' # Example using ordered factors
#' vec1 = factor(LETTERS[1:5],levels = LETTERS,ordered = TRUE)
#' vec2 = factor(LETTERS[c(1,2,2,2,4)],levels = LETTERS, ordered=TRUE)
#' wass_test(vec1,vec2)
#' @name wass_test
NULL


# DTS test ----------------------

#' DTS Test
#'
#' @description A two-sample test based on the DTS test statistic (`dts_stat`). This is the recommended two-sample test in this package because of its power. The DTS statistic is the reweighted integral of the distance between the two ECDFs.
#' @param a a vector of numbers (or factors -- see details)
#' @param b a vector of numbers
#' @param nboots Number of bootstrap iterations
#' @param p power to raise test stat to
#' @param power also the power to raise the test stat to
#' @param keep.boots Should the bootstrap values be saved in the output?
#' @param keep.samples Should the samples be saved in the output?
#' @return Output is a length 2 Vector with test stat and p-value in that order. That vector has 3 attributes -- the sample sizes of each sample, and the number of bootstraps performed for the pvalue.
#' @details The DTS test compares two ECDFs by looking at the reweighted Wasserstein distance between the two. See the companion paper at [arXiv:2007.01360](https://arxiv.org/abs/2007.01360) or <https://codowd.com/public/DTS.pdf> for details of this test statistic, and non-standard uses of the package (parallel for big N, weighted observations, one sample tests, etc).
#'
#' If the [wass_test()] extends [cvm_test()] to interval data, then [dts_test()] extends [ad_test()] to interval data. Formally -- if E is the ECDF of sample 1, F is the ECDF of sample 2, and G is the ECDF of the combined sample, then \deqn{DTS = \int_{x\in R} \left({|E(x)-F(x)| \over \sqrt{2G(x)(1-G(x))/n}}\right)^p}{DTS =  Integral (|E(x)-F(x)|/sqrt(2G(x)(1-G(x))/n))^p} for all x.
#' The test p-value is calculated by randomly resampling two samples of the same size using the combined sample. Intuitively the DTS test improves on the AD test by allowing more extreme observations to carry more weight. At a higher level -- CVM/AD/KS/etc only require ordinal data. DTS (and Wasserstein) gain power because they take advantages of the properties of interval data -- i.e. the distances have some meaning. However, DTS, like Anderson-Darling (AD) also downweights noisier observations relative to Wass, thus (hopefully) giving it extra power.
#'
#' In the example plot below, the DTS statistic is the shaded area between the ECDFs, weighted by the variances -- shown by the color of the shading.
#'
#' ![](dts.png "Example Wasserstein stat plot")
#'
#' Inputs `a` and `b` can also be vectors of ordered (or unordered) factors, so long as both have the same levels and orderings. When possible, ordering factors will substantially increase power. The dts test will assume the distance between adjacent factors is 1.
#' @seealso [wass_test()], [ad_test()] for the predecessors of this test statistic. [arXiv:2007.01360](https://arxiv.org/abs/2007.01360) or <https://codowd.com/public/DTS.pdf> for details of this test statistic
#' @examples
#' vec1 = rnorm(20)
#' vec2 = rnorm(20,4)
#' dts_stat(vec1,vec2)
#' out = dts_test(vec1,vec2)
#' out
#' summary(out)
#' plot(out)
#' two_sample(vec1,vec2)
#'
#' # Example using ordered factors
#' vec1 = factor(LETTERS[1:5],levels = LETTERS,ordered = TRUE)
#' vec2 = factor(LETTERS[c(1,2,2,2,4)],levels = LETTERS, ordered=TRUE)
#' dts_test(vec1,vec2)
#' @name two_sample
NULL


# Perm Builder ---------------------

#' Permutation Test Builder
#'
#' @description (**Warning!** This function has changed substantially between v1.2.0 and v2.0.0) This function takes a two-sample test statistic and produces a function which performs randomization tests (sampling with replacement) using that test stat. This is an internal function of the `twosamples` package.
#' @param test_stat_function a function of the joint vector and a label vector producing a positive number, intended as the test-statistic to be used.
#' @param default.p This allows for some introduction of defaults and parameters. Typically used to control the power functions raise something to.
#' @return  This function returns a function which will perform permutation tests on given test stat.
#' @details test_stat_function must be structured to take two vectors -- the first a combined sample vector and the second a logical vector indicating which sample each value came from, as well as a third and fourth value. i.e. (fun = function(jointvec,labelvec,val1,val2) ...). See examples.
#'
#' ### Conversion Function
#' Test stat functions designed to work with the prior version of `permutation_test_builder` will not work.
#' E.g. If your test statistic is
#' ```
#' mean_diff_stat = function(x,y,pow) abs(mean(x)-mean(y))^pow
#' ```
#' then `permutation_test_builder(mean_diff_stat,1)` will no longer work as intended, but it will if you run the below code first.
#' ```
#' perm_stat_helper = function(stat_fn,def_power) {
#'   output = function(joint,vec_labels,power=def_power,na) {
#'     a = joint[vec_labels]
#'     b = joint[!vec_labels]
#'     stat_fn(a,b,power)
#'   }
#'   output
#' }
#'
#' mean_diff_stat = perm_stat_helper(mean_diff_stat)
#' ```
#' @examples
#' mean_stat = function(joint,label,p,na) abs(mean(joint[label])-mean(joint[!label]))**p
#' myfun = twosamples:::permutation_test_builder(mean_stat,2.0)
#' vec1 = rnorm(20)
#' vec2 = rnorm(20,4)
#' out = myfun(vec1,vec2)
#' out
#' summary(out)
#' plot(out)
#'
#' @name permutation_test_builder
#' @seealso [two_sample()]
NULL

# twosamples-class ---------------------

#' twosamples_class
#'
#' @description Objects of Class twosamples are output by all of the `*_test` functions in the `twosamples` package.
#'
#' @details
#' By default they consist of:a length 2 vector, the first item being the test statistic, the second the p-value.
#' That vector has the following attributes:
#'
#' 1. details: length 3 vector with the sample sizes for each sample and the number of bootstraps
#' 2. test_type: a string describing the type of the test statistic
#'
#' It may also have two more attributes, depending on options used when running the `*_test` function. These are useful for plotting and combining test runs.
#'
#' 1. bootstraps: a vector containing all the bootstrapped null values
#' 2. samples: a list containing both the samples that were tested
#'
#' and by virtue of being a named length 2 vector of class "twosamples" it has the following two attributes:
#' 1. names: c("Test Stat","P-Value")
#' 2. class: "twosamples"
#'
#' Multiple Twosamples objects made by the same `*_test` routine being run on the same data can be combined (getting correct p-value and correct attributes) with the function `combine_twosamples()`.
#'
#' @param x twosamples object
#' @param object twosamples-object to summarize
#' @param alpha  Significance threshold for determining null rejection
#' @param ... other parameters to be passed to print or summary functions
#'
#' @returns
#' - `print.twosamples()` returns nothing
#' - `summarize.twosamples()` returns nothing
#' @seealso [plot.twosamples()], [combine.twosamples()]
#' @name twosamples_class
NULL
