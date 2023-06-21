
# Internals
test_that("permutation_builder outputs a function", {
  f = function(vec1,vec2,p=2) (mean(vec1^p)-mean(vec2^p))^(1/p)
  expect_type(permutation_test_builder(f),"closure")
})

test_that("test_stat_builder outputs a function", {
  f = function(vec1,vec2,p=2) (mean(vec1^p)-mean(vec2^p))^(1/p)
  expect_type(stat_fn_builder(f),"closure")
})

# stats calculations are correct
test_that("stat calculations are correct",{
  vec1 = c(0,2,3)
  vec2 = c(1,1,2)
  expect_equal(ks_stat(vec1,vec2),  1/3)
  expect_equal(abs(kuiper_stat(vec1,vec2)), 2/3)
  expect_equal(cvm_stat(vec1,vec2), 5*(1/3)^2)
  expect_equal(ad_stat(vec1,vec2),
               ((1/3/sqrt(1/6*5/6))^2+
                (1/3/sqrt(0.25))^2*2+
                (1/3/sqrt(5/6*1/6))^2*2)*sqrt(6/2)^2)
  expect_equal(wass_stat(vec1,vec2), 1)
  expect_equal(dts_stat(vec1,vec2),
               (1/3/sqrt(1/6*5/6)+
                1/3/sqrt(0.25)+
                1/3/sqrt(5/6*1/6))*sqrt(6/2))
})

# stat calculations maintain symmetry
test_that("symmetry maintained",{
  vec1 = rnorm(10)
  vec2 = rnorm(10)
  vec3 = c(rep(1,7),rep(2,4))
  vec4 = c(rep(c(1,2),6))
  expect_equal(ks_stat(vec1,vec2),ks_stat(vec2,vec1))
  expect_equal(ks_stat(vec3,vec4),ks_stat(vec4,vec3))

  expect_equal(kuiper_stat(vec1,vec2),kuiper_stat(vec2,vec1))
  expect_equal(kuiper_stat(vec3,vec4),kuiper_stat(vec4,vec3))

  expect_equal(cvm_stat(vec1,vec2),cvm_stat(vec2,vec1))
  expect_equal(cvm_stat(vec3,vec4),cvm_stat(vec4,vec3))

  expect_equal(ad_stat(vec1,vec2),ad_stat(vec2,vec1))
  expect_equal(ad_stat(vec3,vec4),ad_stat(vec4,vec3))

  expect_equal(wass_stat(vec1,vec2),wass_stat(vec2,vec1))
  expect_equal(wass_stat(vec3,vec4),wass_stat(vec4,vec3))

  expect_equal(dts_stat(vec1,vec2),dts_stat(vec2,vec1))
  expect_equal(dts_stat(vec3,vec4),dts_stat(vec4,vec3))
})

# have power when really ought to.
test_that("power against obvious null rejection",{
  vec1 = rnorm(1000)
  vec2 = rnorm(1000,1)
  expect_lt(ks_test(vec1,vec2)[2],0.05)
  expect_lt(kuiper_test(vec1,vec2)[2],0.05)
  expect_lt(cvm_test(vec1,vec2)[2],0.05)
  expect_lt(ad_test(vec1,vec2)[2],0.05)
  expect_lt(wass_test(vec1,vec2)[2],0.05)
  expect_lt(dts_test(vec1,vec2)[2],0.05)
})

#Class functions are quasi functional
test_that("Classes are working",{
  vec1 = rnorm(100)
  vec2 = rnorm(100,0.2)
  out  = dts_test(vec1,vec2,keep.samples = T)
  out2 = dts_test(vec1,vec2)
  expect_s3_class(out,"twosamples")
  expect_length(attr(out,"bootstraps"),2000)
  expect_equal(attr(out,"samples"),list(a=vec1,b=vec2))
  expect_null(attr(out2,"samples"))
  comb = combine.twosamples(out,out2)
  expect_s3_class(comb,"twosamples")
  expect_length(attr(comb,"bootstraps"),4000)
  expect_equal(unname(attr(comb,"details")[3]),4000)
  explicit_pval_comb = unname(ifelse(comb[2] == 1/8000,0,comb[2]))
  explicit_pval_both = mean(ifelse(c(out[2],out2[2]) == 1/4000,0,c(out[2],out2[2])))
  expect_equal(explicit_pval_comb,explicit_pval_both)
  out3 = ks_test(vec1,vec2)
  expect_error(combine.twosamples(out,out3))
  out4 = dts_test(vec1,vec1)
  expect_error(combine.twosamples(out,out4))
  out5 = dts_test(vec1,vec2,keep.boots=F)
  expect_null(attr(out5,"bootstraps"))
  expect_error(combine.twosamples(out,out5))
})



