## Test environments
- Github actions: 
  - macOS-latest   (r-release)
  - windows-latest (r-release)
  - ubuntu-latest  (r-release)
  - ubuntu-latest  (r-devel)
  - ubuntu-latest  (r-oldrel)
  - ubuntu-latest  (r-oldrel-1)


## R CMD check results
0 errors | 0 warnings | 1 note

NOTE: Specified C++11: please drop specification unless essential
  
- This package relies on the package cpp11 for compilation, which requires C++11 to be available. I cannot remove that specification at this time. 


## Downstream dependencies: revdepcheck results

We checked 5 reverse dependencies, comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages



