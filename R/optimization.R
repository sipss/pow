#' Compute validation error.
#'
#' Computes validation error and checks for time inversion in warp function.
#'
#' @param X Matrix with data to be aligned (one sample per row).
#' @param y Reference sample.
#' @param W A matrix with of weights.
#' @param fom figure of merit to use ('rms' or 'cor').
#' @param iv indexes of the points used to validate.
#' @param lambdas a vector with the penalties to test the POW.
#' @param parallel Enable parallelization with BiocParallel
#'
#' @return a list with 2 values 'e_ix' and 'ti_ix'.
#' @export
#'
#' @examples

compute_val_error <- function(X, y, W, fom, iv, lambdas, parallel = TRUE) {
  if (parallel){
    result_parallel <- BiocParallel::bplapply(X = as.list(data.frame(t(X))),
                                              FUN = Align:::val,
                                              y = y,
                                              W = W,
                                              fom = fom,
                                              iv = iv,
                                              lambdas = lambdas)
    e_ix <- t(as.data.frame(lapply(result_parallel, '[', 1)))
    ti_ix <- t(as.data.frame(lapply(result_parallel, '[', 2)))
    rownames(e_ix) <- NULL
    rownames(ti_ix) <- NULL
  } else {
    e_ix <- matrix(nrow = nrow(X), ncol = length(lambdas))
    ti_ix <- matrix(nrow = nrow(X), ncol = length(lambdas))
    for (i in 1:nrow(X)){
      result_val <- val(X[i, ], y, W, fom, iv, lambdas)
      e_ix[i, ] <- result_val$e
      ti_ix[i, ] <- result_val$ti
    }
  }
  return(list(e_ix = e_ix, ti_ix = ti_ix))
}

#' Validation
#'
#' @inheritParams compute_val_error
#'
#' @return list with e and i
#' @keywords internal
#'
#' @examples

val <- function(X, y, W, fom, iv, lambdas){
  e <- rep(0, length(lambdas))
  ti <- rep(0, length(lambdas))
  for (l in 1:length(lambdas)) {
    w <- pow(x = X, y = y, lambda2 = lambdas[l], W = W)
    diff_w <- diff(w)
    ti[l] <- any(diff_w < 0)
    interp <- interpolation(w, X)
    xw <- interp$f
    sel <- interp$s
    sel_x <- intersect(sel, iv)
    sel_xw <- match(sel_x, sel)

    y_norm <- y[sel_x] / norm(y[sel_x],"2")
    xw_norm <- xw[sel_xw] / norm(xw[sel_xw],"2")

    if (fom == 'rms') {
      e[l] <- sqrt(sum((y_norm - xw_norm) * (y_norm - xw_norm)) / length(xw_norm))
    } else if (fom == 'cor') {
      e[l] <- 1 - sum(y_norm * xw_norm)
    }
  }
  return(list(e = e, ti = ti))
}


#' Optimize parameters POW
#'
#' @param n_samples number of samples or signals to be used
#' @param params parameters
#' @param ti_ix matrix with time inversions
#' @param e_ix error matrix
#'
#' @return a list with two values best_params and params_ix
#' @export
#'
#' @examples

optimize_params_pow <- function(n_samples, params, ti_ix, e_ix) {
  params_ix <- matrix(rep(params, each = n_samples), nrow = n_samples, byrow = TRUE)
  e_ix[ti_ix == 1] <- NA
  params_ix[ti_ix == 1] <- NA
  pos_e_ix <- apply(e_ix, 1, which.min)
  best_params <- params[pos_e_ix]

  return(list(best_params = best_params, params_ix = params_ix))
}
