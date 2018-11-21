#' @useDynLib twosamples, .registration = TRUE
#' @importFrom Rcpp sourceCpp
NULL


#' Kolmogorov-Smirnov Test
#'
#' Performs a permutation based two sample test using the Kolmogorov-Smirnov test statistic (ks_stat).
#' @param a a vector of numbers
#' @param b a vector of numbers
#' @param nboots Number of bootstrap iterations
#' @param p power to raise test stat to
#' @param power power to raise test stat to
#' @return Output is a length 2 Vector with test stat and p-value in that order. That vector has 3 attributes -- the sample sizes of each sample, and the number of bootstraps performed for the pvalue.
#' @details The KS test compares two ECDFs by looking at the maximum difference between them. Formally -- if E is the ECDF of sample 1 and F is the ECDF of sample 2, then KS = max |E(x)-F(x)| for values of x in the joint sample. The test p-value is calculated by randomly resampling two samples of the same size using the combined sample.
#' @examples
#' vec1 = rnorm(20)
#' vec2 = rnorm(20,4)
#' ks_test(vec1,vec2)
#' @name ks_test
NULL

#' Kuiper Test
#'
#' Performs a permutation based two sample test using the Kuiper test statistic (kuiper_stat).
#' @param a a vector of numbers
#' @param b a vector of numbers
#' @param nboots Number of bootstrap iterations
#' @param p power to raise test stat to
#' @param power power to raise test stat to
#' @return Output is a length 2 Vector with test stat and p-value in that order. That vector has 3 attributes -- the sample sizes of each sample, and the number of bootstraps performed for the pvalue.
#' @details The Kuiper test compares two ECDFs by looking at the maximum positive and negative difference between them. Formally -- if E is the ECDF of sample 1 and F is the ECDF of sample 2, then KUIPER = max_x E(x)-F(x) + max_x F(x)-E(x). The test p-value is calculated by randomly resampling two samples of the same size using the combined sample.
#' @examples
#' vec1 = rnorm(20)
#' vec2 = rnorm(20,4)
#' kuiper_test(vec1,vec2)
#' @name kuiper_test
NULL

#' Cramer-vonMises Test
#'
#' @param a a vector of numbers
#' @param b a vector of numbers
#' @param nboots Number of bootstrap iterations
#' @param p power to raise test stat to
#' @param power power to raise test stat to
#' @return Output is a length 2 Vector with test stat and p-value in that order. That vector has 3 attributes -- the sample sizes of each sample, and the number of bootstraps performed for the pvalue.
#' @details The CVM test compares two ECDFs by looking at the sum of the squared differences between them -- evaluated at each point in the joint sample. Formally -- if E is the ECDF of sample 1 and F is the ECDF of sample 2, then CVM = SUM_(x in k) (E(x)-F(x))^2 where k is the joint sample. The test p-value is calculated by randomly resampling two samples of the same size using the combined sample. Intuitively the CVM test improves on KS by using the full joint sample, rather than just the maximum distance -- this gives it greater power against shifts in higher moments, like variance changes.
#' @examples
#' vec1 = rnorm(20)
#' vec2 = rnorm(20,4)
#' cvm_test(vec1,vec2)
#' @name cvm_test
NULL

#' Anderson-Darling Test
#'
#' @param a a vector of numbers
#' @param b a vector of numbers
#' @param nboots Number of bootstrap iterations
#' @param p power to raise test stat to
#' @param power power to raise test stat to
#' @return Output is a length 2 Vector with test stat and p-value in that order. That vector has 3 attributes -- the sample sizes of each sample, and the number of bootstraps performed for the pvalue.
#' @details The AD test compares two ECDFs by looking at the weighted sum of the squared differences between them -- evaluated at each point in the joint sample. The weights are determined by the variance of the joint ECDF at that point. Formally -- if E is the ECDF of sample 1, F is the ECDF of sample 2, and G is the ECDF of the joint sample then CVM = SUM_(x in k) (E(x)-F(x))^2/(G(x)*(1-G(x))) where k is the joint sample. The test p-value is calculated by randomly resampling two samples of the same size using the combined sample. Intuitively the AD test improves on the CVM test by giving lower weight to noisy observations.
#' @examples
#' vec1 = rnorm(20)
#' vec2 = rnorm(20,4)
#' ad_test(vec1,vec2)
#' @name ad_test
NULL


#' Wasserstein Distance Test
#' A two-sample test based on Wasserstein's distance.
#' @param a a vector of numbers
#' @param b a vector of numbers
#' @param nboots Number of bootstrap iterations
#' @param p power to raise test stat to
#' @param power power to raise test stat to
#' @return Output is a length 2 Vector with test stat and p-value in that order. That vector has 3 attributes -- the sample sizes of each sample, and the number of bootstraps performed for the pvalue.
#' @details The Wasserstein test compares two ECDFs by looking at the Wasserstein distance between the two. This is of course the area between the two ECDFs. Formally -- if E is the ECDF of sample 1 and F is the ECDF of sample 2, then WASS = Integral |E(x)-F(x)| across all x. The test p-value is calculated by randomly resampling two samples of the same size using the combined sample. Intuitively the Wasserstein test improves on CVM by allowing more extreme observations to carry more weight. At a higher level -- CVM/AD/KS/etc only require ordinal data. Wasserstein gains its power because it takes advantages of the properties of interval data -- i.e. the distances have some meaning.
#' @examples
#' vec1 = rnorm(20)
#' vec2 = rnorm(20,4)
#' wass_test(vec1,vec2)
#' @name wass_test
NULL


#' Two Sample Test
#'
#' @param a a vector of numbers
#' @param b a vector of numbers
#' @param nboots Number of bootstrap iterations
#' @param p power to raise test stat to
#' @param power also the power to raise the test stat to
#' @return Output is a length 2 Vector with test stat and p-value in that order. That vector has 3 attributes -- the sample sizes of each sample, and the number of bootstraps performed for the pvalue.
#' @details The DTS test compares two ECDFs by looking at the reweighted Wasserstein distance between the two. If the wass_test extends cvm_test to interval data, then DTS extends ad_test to interval data. Formally -- if E is the ECDF of sample 1, F is the ECDF of sample 2, and G is the ECDF of the combined sample, then DTS = Integral |E(x)-F(x)|/(G(x)(1-G(x))) across all x. The test p-value is calculated by randomly resampling two samples of the same size using the combined sample. Intuitively the DTS test improves on AD by allowing more extreme observations to carry more weight. At a higher level -- CVM/AD/KS/etc only require ordinal data. DTS gains its power because it takes advantages of the properties of interval data -- i.e. the distances have some meaning. This is the same argument as Wasserstein vs AD/CVM/KS. However, DTS, like Anderson-Darling (AD) also downweights noisier observations relative to WASS, thus (hopefully) giving it extra power.
#' @examples
#' vec1 = rnorm(20)
#' vec2 = rnorm(20,4)
#' dts_stat(vec1,vec2)
#' dts_test(vec1,vec2)
#' two_sample(vec1,vec2)
#' @name two_sample
NULL


#' Permutation Test Builder
#'
#' This function takes a simple two-sample test statistic and produces a function which performs permutation tests using that test stat.
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
NULL
