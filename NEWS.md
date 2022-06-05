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
- Fixed an error in the documention describing `ad_stat` and `dts_stat` -- in which a square root term was dropped
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
