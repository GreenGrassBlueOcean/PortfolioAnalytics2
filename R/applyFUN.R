#' Apply a risk or return function to a set of weights
#' 
#' This function is used to calculate risk or return metrics given a matrix of
#' weights and is primarily used as a convenience function used in chart.Scatter functions
#' 
#' @param R 
#' @param weights a matrix of weights generated from random_portfolios or \code{optimize.portfolio}
#' @param FUN
#' @param ... any passthrough arguments to FUN
#' @author Ross Bennett
#' @export
applyFUN <- function(R, weights, FUN="mean", ...){
  nargs <- list(...)
  
  moments <- function(R){
    momentargs <- list()
    momentargs$mu <- matrix(as.vector(apply(R, 2, "mean")), ncol = 1)
    momentargs$sigma <- cov(R)
    momentargs$m3 <- PerformanceAnalytics:::M3.MM(R)
    momentargs$m4 <- PerformanceAnalytics:::M4.MM(R)
    return(momentargs)
  }
  
  nargs <- c(nargs, moments(R))
  nargs$R <- R
  
  # match the FUN arg to a risk or return function
  switch(FUN,
         mean = {
           fun = match.fun(mean)
         },
         sd =,
         StdDev = { 
           fun = match.fun(StdDev)
         },
         mVaR =,
         VaR = {
           fun = match.fun(VaR) 
           if(is.null(nargs$portfolio_method)) nargs$portfolio_method='single'
           if(is.null(nargs$invert)) nargs$invert = FALSE
         },
         es =,
         mES =,
         CVaR =,
         cVaR =,
         ES = {
           fun = match.fun(ES)
           if(is.null(nargs$portfolio_method)) nargs$portfolio_method='single'
           if(is.null(nargs$invert)) nargs$invert = FALSE
         },
{   # see 'S Programming p. 67 for this matching
  fun <- try(match.fun(FUN))
}
  ) # end switch block
  
  out <- rep(0, nrow(weights))
  .formals  <- formals(fun)
  onames <- names(.formals)
  for(i in 1:nrow(weights)){
    nargs$weights <- as.numeric(weights[i,])
    nargs$x <- R %*% as.numeric(weights[i,])
    dargs <- nargs
    pm <- pmatch(names(dargs), onames, nomatch = 0L)
    names(dargs[pm > 0L]) <- onames[pm]
    .formals[pm] <- dargs[pm > 0L]
    out[i] <- try(do.call(fun, .formals))
  }
  return(out)
}