#' Calculate Euclidean distance from origin
#' @param x Vector of x-axis values
#' @param y Vector of y-axis values
#' @param ydominant Logical, if TRUE, larger influence will be given to the y-axis values
#' @return Vector of distances
Euclid.dist = function(x, y, ydominant = FALSE){
  if(ydominant){
    xw = max(abs(x))    # derive scale for x-values
    yw = max(abs(y))    # derive scale for y-values
    D = (x/xw)^2 + abs(y/yw)
    D / max(D)
  }
  else{
    sqrt(x^2 + y^2)
  }
}

hOlkin.adj <- function(Data, b.raw, xbeta, xse, G1.class)
{
  Dat <- subset(Data, Fitclass == G1.class)
  Vx  <- var(Dat[[xbeta]])
  cVx <- Vx - (mean(Dat[[xse]])^2)
  b.raw * Vx / cVx
}

std <- function(beta, se)
{
  Mu <- mean(beta, na.rm = TRUE)
  Sigma <- sd(beta, na.rm = TRUE)
  beta.std <- (beta-Mu)/Sigma
  se.std <- se/Sigma
  return(list(beta.std=beta.std, se.std=se.std, Mu=Mu, Sigma=Sigma))
}

#' Plotting model for Slope-Hunter clustering
#'
#' @param x Output from \code{slopehunter}.
#' @param what A string specifying the type of graph requested. Available choices are:
#' "clusters": showing clusters. The plot can display membership probabilities of each variable (e.g. SNP) to the target cluster (G1) by hovering over the points.
#' "classification": A plot showing point assigned to each cluster (class).
#' "uncertainty": A plot of classification uncertainty.
#' "density": A plot of estimated density.
#' @export
plot.SH <- function(x, what= c("clusters", "classification", "uncertainty", "density"),
                    dimens = NULL, xlab = NULL, ylab = NULL, addEllipses = TRUE, main = FALSE,
                    ...){
  object <- x
  if(!inherits(object, "SH"))
    stop("x is not of class \"SH\"!")

  if(interactive() & length(what) > 1){
    title <- "Slope-Hunter fitting plots:"
    # present menu waiting user choice
    choice <- menu(what, graphics = FALSE, title = title)
    while(choice != 0){
      if(what[choice] == "clusters")       print(object$plot.clusters)
      if(what[choice] == "classification") mclust::plot.Mclust(object$Model, what = "classification")
      if(what[choice] == "uncertainty")    mclust::plot.Mclust(object$Model, what = "uncertainty")
      if(what[choice] == "density")        mclust::plot.Mclust(object$Model, what = "density")
      # re-present menu waiting user choice
      choice <- menu(what, graphics = FALSE, title = title)
    }
  } else {
    if(any(what == "clusters"))       print(object$plot.clusters)
    if(any(what == "classification")) mclust::plot.Mclust(object$Model, what = "classification")
    if(any(what == "uncertainty"))    mclust::plot.Mclust(object$Model, what = "uncertainty")
    if(any(what == "density"))        mclust::plot.Mclust(object$Model, what = "density")
  }
  invisible()
}
