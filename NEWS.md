# version 2.0.1
This update contains two minor bugfixes. 

#### Summary
1. Some of the unit tests use random numbers, one of those unit tests looking at 
the function `combine.twosamples` failed  to consider default (desired) behavior 
for some possible values of those random numbers, and would occasionally fail. 
This was a minor issue that would not negatively impact any users, _except_ that
it would occasionally cause a CRAN check to fail, which could cause trouble. 
This update aims to fix the _test_, leaving all actual functionality unchanged, 
so that there should not be further CRAN check failures from this issue. 
2. Removed "C++11" from "System Requirements" -- as per current CRAN guidelines. 
The presence of C++11 as a requirement caused a note for R-CMD-Check in R4.3.0 and up.
Currently, the lack of such a requirement does not affect compilation on any tested systems. 

# version 2.0.0
This is a large update. Three big changes:

1. Substantial speed improvements -- should improve both absolute speed and scaling
2. Added generics for plot, summary, print.
3. Switched from the package `Rcpp` to `cpp11` for the backend. This removes a runtime dependency on `Rcpp`, but adds one on `C++11` and adds a compile time dependency on `cpp11`.

Together, all this lead to many changes under the hood. As a consequence, `permutation_test_builder` is substantially different (and no longer exported), and `order_stl` no longer exists. 

#### Speed
Each run of a *_test function now only sorts the data one time. Denoting the joint sample size N and the number of bootstraps K, this update moves the code from $O(KN\log(N))$ to $O(KN)+O(N \log(N))$. 

- Particularly for large samples or large numbers of bootstraps, this means a substantial improvement in speed. 
- This required reworking the underlying C++ `_stat` functions as well as the `permutation_test_builder`. 
  - Instead of breaking code in unpredictable ways, this function is no longer exported. If you used it, archived copies can be found on github (particularly under the example R code versions), or by emailing me. 
- Functions `*_stat` that are syntactically identical to the old ones still exist, but are no longer what is used by `permutation_test_builder`.
- These changes likely reduced memory requirements for most users, though this is offset by the new default of storing bootstrap outputs. 

#### Classes
There is now a 'twosamples' class, and generics for `print`, `summary`, and `plot`, as well as a function for combining outputs correctly. This should make the printed behavior much better. As well as making it easy to see a fair bit of information using summary. 

- plotting currently shows a histogram of the bootstrap values and a red line where the test-statistic is.
  - This required making the `*_test` functions export the bootstrap values. If you have memory intensive applications, this can be turned off with a toggle `keep.boots`, at the cost of no longer being able to use the plotting. 
  - In the future I may add the ability to plot the ECDFs and the test stat images. This is the main reason for the `keep.samples` toggle which is turned off by default.

#### Possible breaking changes
- In order to only sort once, this is now a proper permutation test again. This should also resolve some classes of potential validity issues. Proofs in the associated paper are (at the moment) not relevant to this for the same reason.
- `order_stl` no longer exists. I do not believe anybody used this function outside its internal package use. 
- `permutation_test_builder` is no longer exported. I am not aware of anyone using this function outside its internal package use. A similar function is still available, but will require changing the syntax of functions for its inputs.
- Dependency switch from `Rcpp` to `cpp11` and an additional system requirement of `C++11`. 


# version 1.2.0
This version is primarily bug fixes and documentation updates. **These bug fixes may affect outputs users see**. 

#### Summary

I expect this update to be purely cosmetic for the vast majority of users.
- For a few users of `ad_test` or `cvm_test` it is possible that re-running code will make significant differences to conclusions. 
- For the rare users of `ad_test` or `dts_test` (aka `two_sample`) who relied on the scale of the test stat (rather than merely the p-value), this update will change outputs substantially. In principal this change is merely re-scaling everything by $(n^p)/(2^{p/2})$. 


#### Main code changes:

- Fixed a major bug in how `ad_stat` and `cvm_stat` treated duplicates. This bug lead to excessive power in some situations. Re-running code, p-values and test stats may change.
- Fixed a minor bug in how `ad_stat` and `dts_stat` calculated standard deviations. Re-running code this will change the scale/location of the test stat, but should not affect p-values. 
- Some minor performance improvements: e.g. eliminated some unnecessary comparisons `if (sd >0)`. 
- renamed a functions internal variables to prevent an unlikely namespace conflict. 

#### Some documentation changes: 

- Website using pkgdown now exists at https://twosampletest.com
- link to website in description
- Fixed an error in the documentation describing `ad_stat` and `dts_stat` -- in which a square root term was dropped
- updated discussion of order_stl
- added some notes about ability to use factors (ordered or not)

#### Some development oriented changes:
- added some automated testing of the basic functions
- added reverse dependency testing
- added automated R-CMD-CHECK for each github commit


# version 1.1.1
This update is only fixing up documentation. Fixes a bug that lead to poor formatting, improves formatting of equations, adds graphs for test statistics, adds links between help pages. See v1.1.0 for recent improvements to codebase. 

# version 1.1.0
This update is primarily fixing a bug which meant that the test stat sorting routine was O(N^2), not O(Nlog(N)). 

#### Major Updates
* order_cpp was using an O(N^2) sort routine that was supposed to be ditched before package release. It is now deprecated.
* order_stl replaces order_cpp, using the STL sort function to run the required sorting routine.

#### Minor Updates
* All test stat calculations were using 3 more length N vectors than necessary. This has been fixed.
* A paper demonstrating package components was posted to arXiv, and linked to throughout the documentation.
* The folder R/Extras was updated to use the code for the simulations in the arXiv paper.
* permutation_test_builder is now sampling with replacement.

# version 1.0.0
The package has been released.
The package includes test statistic functions (written in C++) for the following two-sample distance measures:

* Kolmogorov-Smirnov
* Kuiper
* Cramer-Von Mises
* Anderson-Darling
* Wasserstein Metric
* An updated Wasserstein -- referred to as DTS

Each test statistic also has a corresponding permutation test function.

In addition there are two functions:

* permutation_test_builder
* order_cpp
These are primarily intended for internal use, but there was no reason to not export them for other's use.
