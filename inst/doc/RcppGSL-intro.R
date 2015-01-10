### R code from vignette source 'RcppGSL-intro.Rnw'

###################################################
### code chunk number 1: setup
###################################################
require(inline)
library(RcppGSL)
options("width"=65)
rcppgsl.version <- packageDescription( "RcppGSL" )$Version
prettyDate <- format(Sys.Date(), "%B %e, %Y")


###################################################
### code chunk number 7: inlineex1
###################################################
fx <- cxxfunction(
    list( sum_gsl_vector_int = signature( vec_ = "integer" ) ),
    c( sum_gsl_vector_int = '
  RcppGSL::vector<int> vec = as< RcppGSL::vector<int> >(vec_) ;
  int res = std::accumulate( vec.begin(), vec.end(), 0 ) ;
  vec.free() ;  // we need to free vec after use
  return wrap( res ) ;
' ), plugin = "RcppGSL" )


###################################################
### code chunk number 8: callinlineex1
###################################################
.Call( "sum_gsl_vector_int", 1:10 )


###################################################
### code chunk number 10: inlinexex2
###################################################
fx2 <- cxxfunction( list( gsl_vector_sum_2 = signature( data_ = "list" ) ),
c( gsl_vector_sum_2 = '
    List data(data_) ;

  // grab "x" as a gsl_vector through the RcppGSL::vector<double> class
  RcppGSL::vector<double> x = data["x"] ;

  // grab "y" as a gsl_vector through the RcppGSL::vector<int> class
  RcppGSL::vector<int> y = data["y"] ;
  double res = 0.0 ;
  for( size_t i=0; i< x->size; i++){
    res += x[i] * y[i] ;
  }

  // as usual with GSL, we need to explicitely free the memory
  x.free() ;
  y.free() ;

  // return the result
  return wrap(res);
' ), plugin = "RcppGSL" )


###################################################
### code chunk number 11: callinlineex2
###################################################
data <- list( x = seq(0,1,length=10), y = 1:10 )
.Call( "gsl_vector_sum_2", data )


###################################################
### code chunk number 21: RcppGSL-intro.Rnw:690-694
###################################################
colNorm <- function(M) {
    stopifnot(is.matrix(M))
    res <- .Call("colNorm", M, package="RcppGSLExample")
}


###################################################
### code chunk number 22: RcppGSL-intro.Rnw:712-739
###################################################
require(inline)

inctxt='
   #include <gsl/gsl_matrix.h>
   #include <gsl/gsl_blas.h>
'

bodytxt='
  RcppGSL::matrix<double> M = sM;     // create gsl data structures from SEXP
  int k = M.ncol();
  Rcpp::NumericVector n(k);           // to store results

  for (int j = 0; j < k; j++) {
    RcppGSL::vector_view<double> colview = gsl_matrix_column (M, j);
    n[j] = gsl_blas_dnrm2(colview);
  }
  M.free() ;
  return n;                           // return vector
'

foo <- cxxfunction(
    signature(sM="numeric"),
    body=bodytxt, inc=inctxt, plugin="RcppGSL")

## see Section 8.4.13 of the GSL manual: create M as a sum of two outer products
M <- outer(sin(0:9), rep(1,10), "*") + outer(rep(1, 10), cos(0:9), "*")
foo(M)


###################################################
### code chunk number 23: RcppGSL-intro.Rnw:745-746 (eval = FALSE)
###################################################
## package.skeleton( "mypackage", foo )


###################################################
### code chunk number 25: RcppGSL-intro.Rnw:799-800 (eval = FALSE)
###################################################
## sourceCpp("gslNorm.cpp")


