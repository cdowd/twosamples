#include <Rcpp.h>
using namespace Rcpp;

// Notes:
// 1. Using `abs` instead of `if(height<0) height*=-1.0;` breaks on some systems
// 2. `sqrt` != `sqrtf`. `sqrt` is untested on non-local systems.
//      - may also break.
//      - can always revert to `pow(x,0.5)`
// 3. Should double check gapvar calc is _correct_

// Internal function to grab sample size of sample A when not provided explicitly.
// Should never really be used in default use.
double sample_a_size(LogicalVector labs){
  // calculate sample size using labels
  double n  = labs.size(); // Find joint sample size
  double na = 0.0;         // Initialize na
  for (int i=0;i<n;i++){   // for each observation
    if (labs[i]){          //   If labeled TRUE
      na += 1.0;           //     add 1 to tally
    }
  }
  return na;               // output
}

// [[Rcpp::export]]
double ks_stat_presort(NumericVector joint,LogicalVector labs,double power=1.0,double na=0.0) {
  // Getting sample Sizes
  if (na == 0) {              // If na is default val
    na = sample_a_size(labs); //  calculate using labels.
  }
  double n  = joint.size();   // Joint Sample
  double nb = n-na;           // subtraction for n_b.

  // Pre-calculating inverses of sample sizes
  double diva = 1/na;  // for ecur
  double divb = 1/nb;  // for fcur

  // Initializing multiple variables
  double ecur    = 0.0; // mean a < point
  double fcur    = 0.0; // mean b < point
  double out     = 0.0; // max(height)
  double height  = 0.0; // ecur-fcur

  // For loop doing work. For each observation...
  for (int i=0;i+1<n;i++){
    // Individual ECDFs at observation.
    if (labs[i]) {  // If sample a
      ecur += diva; //  add 1/na
    } else {        // If sample b
      fcur += divb; //  add 1/nb
    }

    if (joint[i+1] != joint[i]) {  // If not a dup spot
      height = ecur-fcur;          //  grab diff
      if (height > out) {          //  If bigger,
        out = height;              //   replace
      } else if (-height > out) {  //  If negative is bigger,
        out = -height;             //   replace
      }
    }
  }
  // raise to power, return
  out = pow(out,power);
  return out;
}

// [[Rcpp::export]]
double kuiper_stat_presort(NumericVector joint,LogicalVector labs,double power=1.0,double na=0.0) {
  // Getting sample Sizes
  if (na == 0) {             // If na is default val
    na = sample_a_size(labs); // calculate using labels.
  }
  double n  = joint.size();   // Joint Sample
  double nb = n-na;           // subtraction for n_b.

  // Pre-calculating inverses of sample sizes
  double diva = 1/na;  // for ecur
  double divb = 1/nb;  // for fcur

  // Initializing multiple variables
  double ecur    = 0.0; // mean a < point
  double fcur    = 0.0; // mean b < point
  double up      = 0.0; // largest positive value seen
  double down    = 0.0; // largest negative value seen
  double height  = 0.0; // ecur-fcur

  // For loop doing work. For each observation...
  for (int i=0;i+1<n;i++){
    // Individual ECDFs at observation.
    if (labs[i]) {  // If sample a
      ecur += diva; //  add 1/na
    } else {        // If sample b
      fcur += divb; //  add 1/nb
    }

    if (joint[i+1] != joint[i]) { // If not a dup spot
      height = ecur-fcur;         //  grab diff
      if (height < down) {        //  If gap is smallest value
        down = height;            //   down is gap
      } else if (height > up) {   //  If gap is largest value
        up = height;              //   up is gap
      }
    }
  }
  // -down and up to powers, sum, return.
  double out = pow(up,power)+pow(-down,power);
  return out;
}

// [[Rcpp::export]]
double cvm_stat_presort(NumericVector joint,LogicalVector labs,double power=2.0,double na=0.0) {
  // Getting sample Sizes
  if (na == 0) {              // If na is default val
    na = sample_a_size(labs); //  calculate using labels.
  }
  double n  = joint.size();   // Joint Sample
  double nb = n-na;           // subtraction for n_b.

  // Pre-calculating inverses of sample sizes
  double diva = 1/na;  // for ecur
  double divb = 1/nb;  // for fcur

  // Bools indicating if power is a convenient number.
  bool pow1 = power == 1.0; // when power=1, height^power = height

  // Initializing multiple variables
  double height  = 0.0; // abs(ecur-fcur)
  double dups    = 1.0; // counter for dups
  double ecur    = 0.0; // mean a < point
  double fcur    = 0.0; // mean b < point
  double out     = 0.0; // output
  double summand = 0.0; // height^power

  // For loop doing work. For each observation...
  for (int i=0;i+1<n;i++){
    // Individual ECDFs at observation.
    if (labs[i]) {  // If sample a
      ecur += diva; //  add 1/na
    } else {        // If sample b
      fcur += divb; //  add 1/nb
    }

    // Absolute value of gap
    height = ecur-fcur; // grab diff
    if (height < 0.0) { // If diff is negative
      height *= -1.0;   //  flip sign
    }

    // Find Summand
    // If we can simplify calc, do it
    if (pow1) {                    // If power=1,
      summand = height;            //  height^power = height
    } else {                       // Else
      summand = pow(height,power); //  height^power
    }

    if (joint[i+1] != joint[i]) { // If not a dup spot
      out += summand*dups;        //  summand*num dups
      dups = 1.0;                 //  reset dups counter
    } else {                      // Else
      dups += 1.0;                //  increment dups counter
    }
  }
  return out;
}

// [[Rcpp::export]]
double ad_stat_presort(NumericVector joint,LogicalVector labs,double power=1.0,double na=0.0) {
  // Getting sample Sizes
  if (na == 0) {              // If na is default val
    na = sample_a_size(labs); //  calculate using labels.
  }
  double n  = joint.size();   // Joint Sample
  double nb = n-na;           // subtraction for n_b.

  // Pre-calculating inverses of sample sizes
  double divn = 1/n;   // for gcur
  double diva = 1/na;  // for ecur
  double divb = 1/nb;  // for fcur

  // Bools indicating if power is a convenient number.
  bool pow1 = power == 1.0; // If pow=1, height^power = height
  bool pow2 = power == 2.0; // If pow=2, (height/sqrt(var))^power = height^2/var


  // Initializing multiple variables
  double height  = 0.0; // abs(ecur-fcur)
  double dups    = 1.0; // counter for dups
  double ecur    = 0.0; // mean a < point
  double fcur    = 0.0; // mean b < point
  double gcur    = 0.0; // mean j < point
  double out     = 0.0; // output
  double gapvar  = 1.0; // var(height)
  double summand = 0.0; // (height/sqrt(gapvar))^power

  // For loop doing work. For each observation...
  for (int i=0;i+1<n;i++){
    // Height of joint ecdf at observation
    gcur += divn;
    // Individual ECDFs at observation.
    if (labs[i]) {  // If sample a
      ecur += diva;//   add 1/na
    } else {        // If sample b
      fcur += divb;//   add 1/nb
    }

    // Absolute value of gap
    height = ecur-fcur; // grab diff
    if (height < 0.0) { // If diff is negative
      height *= -1.0;  //   flip sign
    }

    // Find Summand
    // Variance of gap between ECDFs = 2*var(ECDF) at point.
    gapvar = 2*gcur*(1-gcur)/n; //double check again.. rats.
    // If we can simplify calc, do it
    if (pow2) {                                 // If pow=2
      summand = pow(height,2.0)/gapvar;         //  height^2/var
    } else if (pow1) {                          // Else If pow=1
      summand = height/sqrt(gapvar);            //  height/sqrt(var)
    } else {                                    // Else
      summand = pow(height/sqrt(gapvar),power); //  (height/sqrt(var))^power
    }

    if (joint[i+1] != joint[i]) { // If not a dup spot
      out += summand*dups;        //  summand*num dups
      dups = 1.0;                 //  reset dups counter
    } else {                      // Else
      dups += 1.0;                //  increment dups counter
    }
  }
  return out;
}

// [[Rcpp::export]]
double wass_stat_presort(NumericVector joint,LogicalVector labs,double power=1.0,double na=0.0) {
  // Getting sample Sizes
  if (na == 0) {              // If na is default val
    na = sample_a_size(labs); //  calculate using labels.
  }
  double n  = joint.size();   // Joint Sample
  double nb = n-na;           // subtraction for n_b.

  // Pre-calculating inverses of sample sizes
  double diva = 1/na;  // for ecur
  double divb = 1/nb;  // for fcur

  // Bools indicating if power is a convenient number.
  bool pow1 = power == 1.0; // when power=1, height^power = height

  // Initializing multiple variables
  double height  = 0.0; // abs(gap)
  double width   = 0.0; // joint[i+1]-joint[i]
  double ecur    = 0.0; // mean a < point
  double fcur    = 0.0; // mean b < point
  double out     = 0.0; // output
  double summand = 0.0; // height^power

  // For loop doing work. For each observation...
  for (int i=0;i+1<n;i++){
    // Individual ECDFs at observation.
    if (labs[i]) {  // If sample a
      ecur += diva;//   add 1/n_a to F_a
    } else {        // If sample b
      fcur += divb;//   add 1/n_b to F_b
    }

    // Absolute value of gap
    height = ecur-fcur; // grab diff
    if (height < 0.0) { // If diff is negative
      height *= -1.0;   //  flip sign
    }

    //Find Summand
    // If we can simplify calc, do it
    if (pow1) {                    // If pow=1
      summand = height;            //  height
    } else {                       // Else
      summand = pow(height,power); //  height^power
    }

    // Distance to next observation
    width = joint[i+1]-joint[i];

    //Add summand to output
    out += summand*width; // width for "integration" instead of summing.
  }
  return out;
}

// [[Rcpp::export]]
double dts_stat_presort(NumericVector joint,LogicalVector labs,double power=1.0,double na=0.0) {
  // Getting sample Sizes
  if (na == 0) {              // If na is default val
    na = sample_a_size(labs); //  calculate using labels.
  }
  double n  = joint.size();   // Joint Sample
  double nb = n-na;           // subtraction for n_b.

  // Pre-calculating inverses of sample sizes
  double divn = 1/n;   // for gcur
  double diva = 1/na;  // for ecur
  double divb = 1/nb;  // for fcur

  // Bools indicating if power is a convenient number.
  bool pow1 = power == 1.0; // If pow=1, height^power = height
  bool pow2 = power == 2.0; // If pow=2, (height/sqrt(var))^power = height^2/var

  // Initializing multiple variables
  double height  = 0.0; // abs(ecur-fcur)
  double width   = 0.0; // joint[i+1]-joint[i]
  double ecur    = 0.0; // mean a < point
  double fcur    = 0.0; // mean b < point
  double gcur    = 0.0; // mean j < point
  double out     = 0.0; // output
  double gapvar  = 1.0; // var(height)
  double summand = 0.0; // (height/sqrt(gapvar))^power

  // For loop doing work. For each observation...
  for (int i=0;i+1<n;i++){
    // Height of joint ecdf at observation
    gcur += divn;
    // Individual ECDFs at observation.
    if (labs[i]) {  // If sample a
      ecur += diva; //  add 1/na
    } else {        // If sample b
      fcur += divb; //  add 1/nb
    }

    // Absolute value of gap
    height = ecur-fcur; // grab diff
    if (height < 0.0) { // If diff is negative
      height *= -1.0;   //  flip sign
    }

    // Find Summand
    // Variance of gap between ECDFs = 2*var(ECDF) at point.
    gapvar = 2*gcur*(1-gcur)/n; //double check again.. rats.
    // If we can simplify calc, do it
    if (pow1) {                                 // If pow=1
      summand = height/sqrt(gapvar);            //  height/sqrt(var)
    } else if (pow2) {                          // Else If pow=2
      summand = pow(height,2.0)/gapvar;         //  height^2/var
    } else  {                                   // Else
      summand = pow(height/sqrt(gapvar),power); //  (height/sqrt(var))^power
    }

    // Distance to next observation
    width = joint[i+1]-joint[i];
    // Add summand to output
    out += summand*width; // width for "integration" instead of summing.
  }
  return out;
}
