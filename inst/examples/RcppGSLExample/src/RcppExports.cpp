// This file was generated by Rcpp::compileAttributes
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <RcppGSL.h>
#include <Rcpp.h>

using namespace Rcpp;

// colNorm
Rcpp::NumericVector colNorm(Rcpp::NumericMatrix M);
RcppExport SEXP RcppGSLExample_colNorm(SEXP MSEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< Rcpp::NumericMatrix >::type M(MSEXP);
    __result = Rcpp::wrap(colNorm(M));
    return __result;
END_RCPP
}
