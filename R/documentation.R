#' @useDynLib twosamples, .registration = TRUE
#' @importFrom Rcpp sourceCpp
NULL


#' Kolmogorov-Smirnov Test
#'
#' @description A two-sample test using the Kolmogorov-Smirnov test statistic (`ks_stat`).
#' @param a a vector of numbers (or factors -- see details)
#' @param b a vector of numbers
#' @param nboots Number of bootstrap iterations
#' @param p power to raise test stat to
#' @param power power to raise test stat to
#' @return Output is a length 2 Vector with test stat and p-value in that order. That vector has 3 attributes -- the sample sizes of each sample, and the number of bootstraps performed for the pvalue.
#' @details The KS test compares two ECDFs by looking at the maximum difference between them. Formally -- if E is the ECDF of sample 1 and F is the ECDF of sample 2, then \deqn{KS = max |E(x)-F(x)|^p} for values of x in the joint sample. The test p-value is calculated by randomly resampling two samples of the same size using the combined sample.
#'
#' In the example plot below, the KS statistic is the height of the vertical black line. ![](ks.png "Example KS stat plot")
#'
#' Inputs `a` and `b` can also be vectors of ordered (or unordered) factors, so long as both have the same levels and orderings. When possible, ordering factors will substantially increase power.
#' @seealso [dts_test()] for a more powerful test statistic. See [kuiper_test()] or [cvm_test()] for the natural successors to this test statistic.
#' @examples
#' vec1 = rnorm(20)
#' vec2 = rnorm(20,4)
#' ks_test(vec1,vec2)
#'
#' # Example using ordered factors
#' vec1 = factor(LETTERS[1:5],levels = LETTERS,ordered = T)
#' vec2 = factor(LETTERS[c(1,2,2,2,4)],levels = LETTERS, ordered=T)
#' ks_test(vec1,vec2)
#' @name ks_test
NULL

#' Kuiper Test
#'
#' @description A two-sample test based on the Kuiper test statistic (`kuiper_stat`).
#' @param a a vector of numbers (or factors -- see details)
#' @param b a vector of numbers
#' @param nboots Number of bootstrap iterations
#' @param p power to raise test stat to
#' @param power power to raise test stat to
#' @return Output is a length 2 Vector with test stat and p-value in that order. That vector has 3 attributes -- the sample sizes of each sample, and the number of bootstraps performed for the pvalue.
#' @details The Kuiper test compares two ECDFs by looking at the maximum positive and negative difference between them. Formally -- if E is the ECDF of sample 1 and F is the ECDF of sample 2, then \deqn{KUIPER = |max_x E(x)-F(x)|^p + |max_x F(x)-E(x)|^p}. The test p-value is calculated by randomly resampling two samples of the same size using the combined sample.
#'
#' In the example plot below, the Kuiper statistic is the sum of the heights of the vertical black lines. ![](kuiper.png "Example Kuiper stat plot")
#'
#' Inputs `a` and `b` can also be vectors of ordered (or unordered) factors, so long as both have the same levels and orderings. When possible, ordering factors will substantially increase power.
#' @seealso [dts_test()] for a more powerful test statistic. See [ks_test()] for the predecessor to this test statistic, and [cvm_test()] for its natural successor.
#' @examples
#' vec1 = rnorm(20)
#' vec2 = rnorm(20,4)
#' kuiper_test(vec1,vec2)
#'
#' # Example using ordered factors
#' vec1 = factor(LETTERS[1:5],levels = LETTERS,ordered = T)
#' vec2 = factor(LETTERS[c(1,2,2,2,4)],levels = LETTERS, ordered=T)
#' kuiper_test(vec1,vec2)
#' @name kuiper_test
NULL

#' Cramer-von Mises Test
#'
#' @description A two-sample test based on the Cramer-Von Mises test statistic (`cvm_stat`).
#' @param a a vector of numbers (or factors -- see details)
#' @param b a vector of numbers
#' @param nboots Number of bootstrap iterations
#' @param p power to raise test stat to
#' @param power power to raise test stat to
#' @return Output is a length 2 Vector with test stat and p-value in that order. That vector has 3 attributes -- the sample sizes of each sample, and the number of bootstraps performed for the pvalue.
#' @details The CVM test compares two ECDFs by looking at the sum of the squared differences between them -- evaluated at each point in the joint sample. Formally -- if E is the ECDF of sample 1 and F is the ECDF of sample 2, then \deqn{CVM = \sum_{x\in k}|E(x)-F(x)|^p}{CVM = SUM_(x in k) |E(x)-F(x)|^p} where k is the joint sample. The test p-value is calculated by randomly resampling two samples of the same size using the combined sample. Intuitively the CVM test improves on KS by using the full joint sample, rather than just the maximum distance -- this gives it greater power against shifts in higher moments, like variance changes.
#'
#' In the example plot below, the CVM statistic is the sum of the heights of the vertical black lines. ![](cvm.png "Example CVM stat plot")
#'
#' Inputs `a` and `b` can also be vectors of ordered (or unordered) factors, so long as both have the same levels and orderings. When possible, ordering factors will substantially increase power.
#' @seealso [dts_test()] for a more powerful test statistic. See [ks_test()] or [kuiper_test()] for the predecessors to this test statistic. See [wass_test()] and [ad_test()] for the successors to this test statistic.
#' @examples
#' vec1 = rnorm(20)
#' vec2 = rnorm(20,4)
#' cvm_test(vec1,vec2)
#'
#' # Example using ordered factors
#' vec1 = factor(LETTERS[1:5],levels = LETTERS,ordered = T)
#' vec2 = factor(LETTERS[c(1,2,2,2,4)],levels = LETTERS, ordered=T)
#' cvm_test(vec1,vec2)
#' @name cvm_test
NULL

#' Anderson-Darling Test
#'
#' @description A two-sample test based on the Anderson-Darling test statistic (`ad_stat`).
#' @param a a vector of numbers (or factors -- see details)
#' @param b a vector of numbers
#' @param nboots Number of bootstrap iterations
#' @param p power to raise test stat to
#' @param power power to raise test stat to
#' @return Output is a length 2 Vector with test stat and p-value in that order. That vector has 3 attributes -- the sample sizes of each sample, and the number of bootstraps performed for the pvalue.
#' @details The AD test compares two ECDFs by looking at the weighted sum of the squared differences between them -- evaluated at each point in the joint sample. The weights are determined by the variance of the joint ECDF at that point, which peaks in the middle of the joint distribution (see figure below). Formally -- if E is the ECDF of sample 1, F is the ECDF of sample 2, and G is the ECDF of the joint sample then \deqn{AD = \sum_{x \in k} {|E(x)-F(x)|^p \over G(x)(1-G(x)) } }{AD = SUM_(x in k) |E(x)-F(x)|^p/(G(x)*(1-G(x)))} where k is the joint sample. The test p-value is calculated by randomly resampling two samples of the same size using the combined sample. Intuitively the AD test improves on the CVM test by giving lower weight to noisy observations.
#'
#' In the example plot below, we see the variance of the joint ECDF over the range of the data. It clearly peaks in the middle of the joint sample. ![](var.png "Plot of Variance of joint ECDF")
#'
#' In the example plot below, the AD statistic is the weighted sum of the heights of the vertical lines, where weights are represented by the shading of the lines. ![](ad.png "Example AD stat plot")
#'
#' Inputs `a` and `b` can also be vectors of ordered (or unordered) factors, so long as both have the same levels and orderings. When possible, ordering factors will substantially increase power.
#' @seealso [dts_test()] for a more powerful test statistic. See [cvm_test()] for the predecessor to this test statistic. See [dts_test()] for the natural successor to this test statistic.
#' @examples
#' vec1 = rnorm(20)
#' vec2 = rnorm(20,4)
#' ad_test(vec1,vec2)
#'
#' # Example using ordered factors
#' vec1 = factor(LETTERS[1:5],levels = LETTERS,ordered = T)
#' vec2 = factor(LETTERS[c(1,2,2,2,4)],levels = LETTERS, ordered=T)
#' ad_test(vec1,vec2)
#' @name ad_test
NULL


#' Wasserstein Distance Test
#' @description A two-sample test based on Wasserstein's distance (`wass_stat`).
#' @param a a vector of numbers (or factors -- see details)
#' @param b a vector of numbers
#' @param nboots Number of bootstrap iterations
#' @param p power to raise test stat to
#' @param power power to raise test stat to
#' @return Output is a length 2 Vector with test stat and p-value in that order. That vector has 3 attributes -- the sample sizes of each sample, and the number of bootstraps performed for the pvalue.
#' @details The Wasserstein test compares two ECDFs by looking at the Wasserstein distance between the two. This is of course the area between the two ECDFs. Formally -- if E is the ECDF of sample 1 and F is the ECDF of sample 2, then \deqn{WASS = \int_{x \in R} |E(x)-F(x)|^p}{WASS = Integral |E(x)-F(x)|^p} across all x. The test p-value is calculated by randomly resampling two samples of the same size using the combined sample. Intuitively the Wasserstein test improves on CVM by allowing more extreme observations to carry more weight. At a higher level -- CVM/AD/KS/etc only require ordinal data. Wasserstein gains its power because it takes advantages of the properties of interval data -- i.e. the distances have some meaning.
#'
#' In the example plot below, the Wasserstein statistic is the shaded area between the ECDFs. ![](wass.png "Example Wasserstein stat plot")
#'
#' Inputs `a` and `b` can also be vectors of ordered (or unordered) factors, so long as both have the same levels and orderings. When possible, ordering factors will substantially increase power. `wass_test` will assume the distance between adjacent factors is 1.
#' @seealso [dts_test()] for a more powerful test statistic. See [cvm_test()] for the predecessor to this test statistic. See [dts_test()] for the natural successor of this test statistic.
#' @examples
#' vec1 = rnorm(20)
#' vec2 = rnorm(20,4)
#' wass_test(vec1,vec2)
#'
#' # Example using ordered factors
#' vec1 = factor(LETTERS[1:5],levels = LETTERS,ordered = T)
#' vec2 = factor(LETTERS[c(1,2,2,2,4)],levels = LETTERS, ordered=T)
#' wass_test(vec1,vec2)
#' @name wass_test
NULL


#' DTS Test
#'
#' @description A two-sample test based on the DTS test statistic (`dts_stat`). This is the recommended two-sample test in this package because of its power. The DTS statistic is the reweighted integral of the distance between the two ECDFs.
#' @param a a vector of numbers (or factors -- see details)
#' @param b a vector of numbers
#' @param nboots Number of bootstrap iterations
#' @param p power to raise test stat to
#' @param power also the power to raise the test stat to
#' @return Output is a length 2 Vector with test stat and p-value in that order. That vector has 3 attributes -- the sample sizes of each sample, and the number of bootstraps performed for the pvalue.
#' @details The DTS test compares two ECDFs by looking at the reweighted Wasserstein distance between the two. See the companion paper at [arXiv:2007.01360](https://arxiv.org/abs/2007.01360) or <https://codowd.com/public/DTS.pdf> for details of this test statistic, and non-standard uses of the package (parallel for big N, weighted observations, one sample tests, etc).
#'
#' If the [wass_test()] extends [cvm_test()] to interval data, then [dts_test()] extends [ad_test()] to interval data. Formally -- if E is the ECDF of sample 1, F is the ECDF of sample 2, and G is the ECDF of the combined sample, then \deqn{DTS = \int_{x\in R} {|E(x)-F(x)|^p\over G(x)(1-G(x))}}{DTS = Integral |E(x)-F(x)|^p/(G(x)(1-G(x)))} for all x.
#' The test p-value is calculated by randomly resampling two samples of the same size using the combined sample. Intuitively the DTS test improves on the AD test by allowing more extreme observations to carry more weight. At a higher level -- CVM/AD/KS/etc only require ordinal data. DTS (and Wasserstein) gain power because they take advantages of the properties of interval data -- i.e. the distances have some meaning. However, DTS, like Anderson-Darling (AD) also downweights noisier observations relative to Wass, thus (hopefully) giving it extra power.
#'
#' In the example plot below, the DTS statistic is the shaded area between the ECDFs, weighted by the variances -- shown by the color of the shading. ![](dts.png "Example Wasserstein stat plot")
#'
#' Inputs `a` and `b` can also be vectors of ordered (or unordered) factors, so long as both have the same levels and orderings. When possible, ordering factors will substantially increase power. The dts test will assume the distance between adjacent factors is 1.
#' @seealso [wass_test()], [ad_test()] for the predecessors of this test statistic. [arXiv:2007.01360](https://arxiv.org/abs/2007.01360) or <https://codowd.com/public/DTS.pdf> for details of this test statistic
#' @examples
#' vec1 = rnorm(20)
#' vec2 = rnorm(20,4)
#' dts_stat(vec1,vec2)
#' dts_test(vec1,vec2)
#' two_sample(vec1,vec2)
#'
#' # Example using ordered factors
#' vec1 = factor(LETTERS[1:5],levels = LETTERS,ordered = T)
#' vec2 = factor(LETTERS[c(1,2,2,2,4)],levels = LETTERS, ordered=T)
#' dts_test(vec1,vec2)
#' @name two_sample
NULL


#' Permutation Test Builder
#'
#' @description This function takes a simple two-sample test statistic and produces a function which performs randomization tests (sampling with replacement) using that test stat.
#' @param test_stat_function a function of two vectors producing a positive number, intended as the test-statistic to be used.
#' @param default.p This allows for some introduction of defaults and parameters. Typically used to control the power functions raise something to.
#' @return  This function returns a function which will perform permutation tests on given test stat.
#' @details test_stat_function must be structured to take two separate vectors, and then a third value. i.e. (fun = function(vec1,vec2,val1) ...). See examples.
#' @examples
#' mean_stat = function(a,b,p) abs(mean(a)-mean(b))**p
#' myfun = permutation_test_builder(mean_stat,2.0)
#' vec1 = rnorm(20)
#' vec2 = rnorm(20,4)
#' myfun(vec1,vec2)
#' @name permutation_test_builder
#' @seealso [two_sample()]
NULL
