x. switch test
  -x new tests
  -x new permutation fn
  -x new test_stat builder fn
  -x check exports
    -x test_stat fns
    -x test fns
x. inverse fn?
  -x takes old test stat fn, makes it amenable to new perm builder
  -x add docs?
  -x done exclusively inside the perm_test_builder docs.
x. classes
  -x add class to perm fn
  -x add print/summary fns
  -x add boot toggle to perm_fun
  -x add plot fn
  -x add keep.sample toggle to perm_fun
  -x add keep.boot, keep.samples to docs
  -x add print/summary/plot examples to docs.
4. plots2?
  - add ECDF plotting functions? (ugh)
  - add ECDF diff plotting? (ugh ugh)
    - and like... also show nulls? (ugh ugh ugh)
5. check docs
  - readme.Rmd needs most of the work
  - possibly example R code??
  -x dependency changes
  -x could do a quick doc for plot.twosamples
x. combine fn?
  -x add test vals correctly?
  -x basically, test correctness (class, test type, samples/test stat), concat boots, change nboots, recalc pval
  - document
x. switch to cpp11?
  -x easy enough
  -x should i....
  -x should mention in news and readme
8. double check gapvar calc...
9. ditch ggplot??
  - its genuinely an uglier plot at the moment...
  - useful maybe for the future... but worry about that later?
