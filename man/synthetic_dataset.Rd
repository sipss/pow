% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/synthetic.R
\name{synthetic_dataset}
\alias{synthetic_dataset}
\title{Create Synthetic dataset.}
\usage{
synthetic_dataset(
  n_samples,
  n_peaks,
  length_out,
  mov_peaks,
  intensity = 1000,
  random_intensity = NULL
)
}
\arguments{
\item{n_samples}{number of chromatograms to be generated}

\item{n_peaks}{number of peaks in each chromatogram}

\item{length_out}{length of chromatograms}

\item{mov_peaks}{random movement of the position of the peaks}

\item{intensity}{intensity of the peaks}

\item{random_intensity}{random variation for the intensity of the peaks}
}
\value{
synthetic dataset.
}
\description{
Create Synthetic dataset.
}
\examples{
synthetic_dataset(10, 10, 1000, 5)
synthetic_dataset(n_samples = 20,
                         n_peaks = 7,
                         length_out = 100,
                         mov_peaks = 10)
}
