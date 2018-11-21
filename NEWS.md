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
