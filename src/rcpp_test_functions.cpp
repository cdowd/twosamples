#include <Rcpp.h>
using namespace Rcpp;

//' Order function in C++ using the STL
//'
//' Simply finds the order of a vector in c++. Mostly for internals.
//' @param x numeric vector
//' @return same length vector of integers representing order of input vector
//' @examples
//' vec = c(1,4,3,2)
//' order_stl(vec)
//' @export
// [[Rcpp::export]]
IntegerVector order_stl(NumericVector x) {
  int n = x.size();
  std::vector<std::pair<double, int> > paired(n);
  for (int i = 0; i < n; i++) {
    paired[i] = std::make_pair(x[i], i);
  }
  std::sort(paired.begin(), paired.end());
  IntegerVector indices(n);
  for (int i = 0; i < n; i++) {
    indices[i] = paired[i].second;
  }
  return indices;
}


//' @describeIn ks_test Kolmogorov-Smirnov test statistic
//' @export
// [[Rcpp::export]]
double ks_stat(NumericVector a,NumericVector b, double power=1.0) {
  // Sample Sizes
  double na = a.size();
  double nb = b.size();
  double n = na+nb;
  // Initializing CDF & full sample vectors
  NumericVector d(n);
  NumericVector e(n);
  NumericVector f(n);
  // Filling CDF & full sample vector
  for (double i=0.0;i<n;i++){
    if (i < na) {
      d[i] = a[i];
      e[i] = 1.0/na;
      f[i] = 0.0;
    } else {
      d[i] = b[i-na];
      e[i] = 0.0;
      f[i] = 1.0/nb;
    }
  }
  // Finding proper order
  IntegerVector order = order_stl(d);

  // Sorted cdf & sample vectors
  d = d[order];
  e = e[order];
  f = f[order];

  // Initializing CDF heights & distances
  double height=0.0;
  double ecur = 0.0;
  double fcur = 0.0;
  // Initializing outcome
  double out=0.0;

  // For loop doing actual work
  // Stops at n-1 (b/c at n both are equal)
  for (int i=0;i+1<n;i++){
    // Current height of CDFs
    ecur += e[i];
    fcur += f[i];
    // IF the next value is different
    if (d[i]<d[i+1]){
      // distance between cdfs
      height = ecur-fcur;
      // ensuring positivity of distance
      if (height < 0.0) {
        height *= -1.0;
      }
      // If we should update:
      if (height > out) {
        // Updating outcome
        out = height;
      }
    }
  }
  out = pow(out,power);
  return out;
}

//' @describeIn kuiper_test  Kuiper Test statistic
//' @export
// [[Rcpp::export]]
double kuiper_stat(NumericVector a,NumericVector b, double power=1.0) {
  // Sample Sizes
  double na = a.size();
  double nb = b.size();
  double n = na+nb;
  // Initializing CDF & full sample vectors
  NumericVector d(n);
  NumericVector e(n);
  NumericVector f(n);
  // Filling CDF & full sample vector
  for (double i=0.0;i<n;i++){
    if (i < na) {
      d[i] = a[i];
      e[i] = 1.0/na;
      f[i] = 0.0;
    } else {
      d[i] = b[i-na];
      e[i] = 0.0;
      f[i] = 1.0/nb;
    }
  }
  // Finding proper order
  IntegerVector order = order_stl(d);

  // Filling sorted cdf & sample vectors
  d = d[order];
  e = e[order];
  f = f[order];

  // Initializing CDF heights & distances
  double height=0.0;
  double ecur = 0.0;
  double fcur = 0.0;
  // Initializing outcomes
  double up = 0.0;
  double down = 0.0;

  // For loop doing actual work
  // Stops at n-1 (b/c at n both are equal)
  for (int i=0;i+1<n;i++){
    // Current height of CDFs
    ecur += e[i];
    fcur += f[i];
    // IF the next value is different
    if (d[i]<d[i+1]){
      // distance between cdfs
      height = ecur-fcur;
      // If we should update:
      if (height > up) {
        // Updating maximum positive value
        up = height;
      }
      if (height < down) {
        // Updating minimum negative value
        down = height;
      }
    }
  }
  // Sum and power distances
  down = pow(-1.0*down,power);
  up   = pow(up,power);
  double out = up + down;
  return out;
}


//' @describeIn cvm_test  Cramer-Von Mises Test statistic
//' @export
// [[Rcpp::export]]
double cvm_stat(NumericVector a,NumericVector b, double power=2.0) {
  // Sample Sizes
  double na = a.size();
  double nb = b.size();
  double n = na+nb;
  // Initializing CDF & full sample vectors
  NumericVector d(n);
  NumericVector e(n);
  NumericVector f(n);
  // Filling CDF & full sample vector
  for (double i=0.0;i<n;i++){
    if (i < na) {
      d[i] = a[i];
      e[i] = 1.0/na;
      f[i] = 0.0;
    } else {
      d[i] = b[i-na];
      e[i] = 0.0;
      f[i] = 1.0/nb;
    }
  }
  // Finding proper order
  IntegerVector order = order_stl(d);

  // Filling sorted cdf & sample vectors
  d = d[order];
  e = e[order];
  f = f[order];

  // Initializing CDF heights & distances
  double height=0.0;
  double ecur = 0.0;
  double fcur = 0.0;
  // Initializing outcome
  double out=0.0;

  // For loop doing actual work
  // Stops at n-1 (b/c at n both are equal)
  for (int i=0;i+1<n;i++){
    // Current height of CDFs
    ecur += e[i];
    fcur += f[i];
    // IF the next value is different
    if (d[i]<d[i+1]){
      // distance between cdfs
      height = ecur-fcur;
      // ensuring positivity of distance
      if (height < 0.0) {
        height *= -1.0;
      }
      // Updating outcome
      out += pow(height,power);
    }
  }
  return out;
}


//' @describeIn ad_test  Anderson-Darling Test statistic
//' @export
// [[Rcpp::export]]
double ad_stat(NumericVector a,NumericVector b, double power=2.0) {
  // Sample Sizes
  double na = a.size();
  double nb = b.size();
  double n = na+nb;
  // Initializing cdf & full sample vectors
  NumericVector d(n);
  NumericVector e(n);
  NumericVector f(n);
  // Filling CDF & full sample vectors
  for (double i=0.0;i<n;i++){
    if (i < na) {
      d[i] = a[i];
      e[i] = 1.0/na;
      f[i] = 0.0;
    } else {
      d[i] = b[i-na];
      e[i] = 0.0;
      f[i] = 1.0/nb;
    }
  }
  // Finding proper order
  IntegerVector order = order_stl(d);

  // Filling sorted CDF & sample vectors
  d = d[order];
  e = e[order];
  f = f[order];
  // Initializing cdfs (each & joint), diff, outcome, sd
  double height = 0.0;
  double ecur = 0.0;
  double fcur = 0.0;
  double gcur = 0.0;
  double sd = 1.0;
  double out=0.0;

  // For loop doing actual work
  for (int i=0;i+1<n;i++){
    // Current height of each sample cdf, joint cdf
    ecur += e[i];
    fcur += f[i];
    gcur += 1.0/n;
    // If next value is different
    if (d[i]<d[i+1]){
      // Difference between sample CDFs
      height = ecur-fcur;
      // Absolute value
      if (height < 0.0) {
        height *= -1.0;
      }
      // SD of quantile
      sd = pow(n*gcur*(1-gcur),0.5);
      // If we won't divide by 0
      if (sd > 0) {
        // update outcome by height to power divided by SD
        out += pow(height/sd,power);
      }
    }
  }
  return out;
}


//' @describeIn wass_test Wasserstein metric between two ECDFs
//' @export
// [[Rcpp::export]]
double wass_stat(NumericVector a,NumericVector b,double power=1.0) {
  // Sample Sizes
  double na = a.size();
  double nb = b.size();
  double n = na+nb;

  //Initializing CDF vectors & full sample vector
  NumericVector d(n);
  NumericVector e(n);
  NumericVector f(n);

  // Filling CDF & Full sample vectors
  for (double i=0.0;i<n;i++){
    if (i < na) {
      d[i] = a[i];
      e[i] = 1.0/na;
      f[i] = 0.0;
    } else {
      d[i] = b[i-na];
      e[i] = 0.0;
      f[i] = 1.0/nb;
    }
  }
  // Finding proper order
  IntegerVector order = order_stl(d);

  // Filling ordered cdf, sample vectors
  d = d[order];
  e = e[order];
  f = f[order];

  // Initializing current distances
  double ecur = 0.0;
  double fcur = 0.0;
  // Initializing heights and widths
  double height = 0.0;
  double width = 0.0;
  // Initializing outcome value
  double out=0.0;

  // For loop doing the actual work
  for (int i=0;i+1<n;i++){
    // Height of each cdf at current point
    ecur += e[i];
    fcur += f[i];
    // Distance between the two
    height = ecur-fcur;
    // Taking absolute Value
    if (height < 0.0) {
      height *= -1.0;
    }
    // Width of current step
    width = d[i+1]-d[i];
    // Updating outcome
    out += (pow(height,power)*width);
  }
  return out;
}

//' @describeIn two_sample Test statistic based on a weighted area between ECDFs
//' @export
// [[Rcpp::export]]
double dts_stat(NumericVector a,NumericVector b,double power=1.0) {
  // Sample Sizes
  double na = a.size();
  double nb = b.size();
  double n = na+nb;
  // Initializing CDF & full sample vectors
  NumericVector d(n);
  NumericVector e(n);
  NumericVector f(n);
  // Filling CDF & full sample vectors
  for (double i=0.0;i<n;i++){
    if (i < na) {
      d[i] = a[i];
      e[i] = 1.0/na;
      f[i] = 0.0;
    } else {
      d[i] = b[i-na];
      e[i] = 0.0;
      f[i] = 1.0/nb;
    }
  }
  // Finding order for vectors
  IntegerVector order = order_stl(d);

  // Filling ordered cdf, sample vectors
  d = d[order];
  e = e[order];
  f = f[order];

  // Initializing CDFs, width, outcome, sd, cdf diff
  double height = 0.0;
  double width = 0.0;
  double ecur = 0.0;
  double fcur = 0.0;
  double gcur = 0.0;
  double out=0.0;
  double sd = 1.0;

  // For loop doing work
  for (int i=0;i+1<n;i++){
    // Height of joint cdf, individual cdfs at point
    gcur += 1/n;
    ecur += e[i];
    fcur += f[i];
    // Difference in CDFs
    height = ecur-fcur;
    // Absolute value of height
    if (height < 0.0) {
      height *= -1.0;
    }
    // SD of joint CDF here
    sd = pow(n*gcur*(1-gcur),0.5);
    // Distance to next observation
    width = d[i+1]-d[i];
    // If we won't divide by 0
    if (sd > 0.0) {
      // Update outcome by height/sd to the power times the width
      out += pow(height/sd,power)*width;
    }
  }
  return out;
}

