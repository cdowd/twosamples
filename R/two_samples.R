# This file builds the *_stat and *_test functions from the _stat_presort

# Build *_test functions ---------

#' @describeIn ks_test Permutation based two sample Kolmogorov-Smirnov test
#' @export
ks_test = permutation_test_builder(ks_stat_presort,1.0)

#' @describeIn kuiper_test Permutation based two sample Kuiper test
#' @export
kuiper_test = permutation_test_builder(kuiper_stat_presort,1.0)

#' @describeIn cvm_test Permutation based two sample Cramer-Von Mises test
#' @export
cvm_test = permutation_test_builder(cvm_stat_presort,2.0)

#' @describeIn ad_test Permutation based two sample Anderson-Darling test
#' @export
ad_test = permutation_test_builder(ad_stat_presort,2.0)

#' @describeIn wass_test Permutation based two sample test using Wasserstein metric
#' @export
wass_test = permutation_test_builder(wass_stat_presort,1.0)

#' @describeIn two_sample Permutation based two sample test
#' @export
dts_test = permutation_test_builder(dts_stat_presort,1.0)

#' @describeIn two_sample Recommended two-sample test
#' @export
two_sample = dts_test


# Build *_stat functions ----

#' @describeIn two_sample Permutation based two sample test
#' @export
dts_stat    = stat_fn_builder(   dts_stat_presort,1)

#' @describeIn wass_test Permutation based two sample test using Wasserstein metric
#' @export
wass_stat   = stat_fn_builder(  wass_stat_presort,1)

#' @describeIn kuiper_test Permutation based two sample Kuiper test
#' @export
kuiper_stat = stat_fn_builder(kuiper_stat_presort,1)

#' @describeIn ks_test Permutation based two sample Kolmogorov-Smirnov test
#' @export
ks_stat     = stat_fn_builder(    ks_stat_presort,1)

#' @describeIn cvm_test Permutation based two sample Cramer-Von Mises test
#' @export
cvm_stat    = stat_fn_builder(   cvm_stat_presort,2)

#' @describeIn ad_test Permutation based two sample Anderson-Darling test
#' @export
ad_stat     = stat_fn_builder(    ad_stat_presort,2)
