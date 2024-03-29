% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pow.R
\name{pow}
\alias{pow}
\title{Penalized Optimized Warping}
\usage{
pow(
  x,
  lambda2,
  y,
  lambda1 = 10^6,
  W = NULL,
  max_it = 100,
  min_drms = 1e-06,
  verbose = FALSE
)
}
\arguments{
\item{x}{Signal to fit.}

\item{lambda2}{Penalty for negative values of first derivative of warp}

\item{y}{Reference signal.}

\item{lambda1}{Regularization parameter for second derivative of warp}

\item{W}{A 'diagonal matrix' with weights.}

\item{max_it}{Maximum amount of iterations.}

\item{min_drms}{minimum difference in absolute value of RMS.}

\item{verbose}{by default 'FALSE' to provide information in the console}
}
\value{
warp
}
\description{
Alignment with POW method.
}
\details{
POW like PTW but without a fix polynomial, it will work
}
\examples{
x <- synthetic_chromatogram(n_peaks = 7,
                            intensity = 100,
                            mov_peaks = 5)
y <- synthetic_chromatogram(n_peaks = 7,
                            intensity = 100,
                            mov_peaks = 5)
lambda2 <- 1
pow(x, lambda2, y)
}
