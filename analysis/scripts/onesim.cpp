// Data analysis on tired termite project

/*------------------------------------------------------------------------------
 onesim.cpp, 
 a additional code for simulations.R, 
 includes functions for calculations
------------------------------------------------------------------------------*/

#include <Rcpp.h>

using namespace Rcpp;
using namespace std;

// Random sampling
#include <random>
#include <time.h>
#include <cmath>

// [[Rcpp::export]]
NumericVector one_simulation(NumericVector x1, NumericVector y1,
                             NumericVector x2, NumericVector y2, 
                             double L, double detection) {
  NumericVector endtime(1);
  endtime[0]  = 1501;
  double X1, Y1, X2, Y2, xdis, ydis, sepdis;
  for(int i =0; i<1500; ++i){
    X1 = fmod(x1[i], L);
    Y1 = fmod(y1[i], L); 
    X2 = fmod(x2[i], L); 
    Y2 = fmod(y2[i], L); 
    xdis = min(abs(X1 - X2), abs(L - abs(X1 - X2)));
    ydis = min(abs(Y1 - Y2), abs(L - abs(Y1 - Y2)));
    sepdis = sqrt(xdis*xdis + ydis*ydis);
    if (sepdis <= detection) {
      endtime[0] = i + 1;
      break;
    }
  }
  return endtime;
}

// [[Rcpp::export]]
List randomize_trajectory(NumericVector x, NumericVector y) {
  double rx, ry;
  std::uniform_real_distribution<double> distribution(0.0, 1.0);
  std::random_device seed_gen;
  std::mt19937 engine(seed_gen());
  auto rnd = [&] { return distribution(engine); };
  
  int rn1 = (rnd() < 0.5) ? -1 : 1;
  int rn2 = (rnd() < 0.5) ? -1 : 1;
  double theta = rnd()*3.1415926535*2;
  double cos_theta = cos(theta);
  double sin_theta = sin(theta);
  
  for(int i=1499; i>-1; --i){
    x[i] = x[i] - x[0];
    y[i] = y[i] - y[0];
  }
  
  for(int i=0; i<1500; ++i){
    // reflection
    x[i] = x[i] * rn1;
    y[i] = y[i] * rn2;

    // rotation
    rx = cos_theta * x[i] - sin_theta * y[i];
    ry = sin_theta * x[i] + cos_theta * y[i];
    x[i] = rx;
    y[i] = ry;
  }
  Rcpp::List result;
  result["x"] = x;
  result["y"] = y;
  return result;
}

