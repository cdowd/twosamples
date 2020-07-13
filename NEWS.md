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
