
#' @describeIn ks_test Permutation based two sample Kolmogorov-Smirnov test
#' @export
ks_test = permutation_test_builder(ks_stat,1.0)

#' @describeIn kuiper_test Permutation based two sample Kuiper test
#' @export
kuiper_test = permutation_test_builder(kuiper_stat,1.0)

#' @describeIn cvm_test Permutation based two sample Cramer-Von Mises test
#' @export
cvm_test = permutation_test_builder(cvm_stat,2.0)

#' @describeIn ad_test Permutation based two sample Anderson-Darling test
#' @export
ad_test = permutation_test_builder(ad_stat,2.0)

#' @describeIn wass_test Permutation based two sample test using Wasserstein metric
#' @export
wass_test = permutation_test_builder(wass_stat,1.0)

#' @describeIn two_sample Permutation based two sample test
#' @export
dts_test = permutation_test_builder(dts_stat,1.0)

#' @describeIn two_sample Recommended two-sample test
#' @export
two_sample = dts_test

