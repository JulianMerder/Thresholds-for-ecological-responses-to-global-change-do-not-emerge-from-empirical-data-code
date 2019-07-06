meta_marginal <- function(data, tbw=2.5, np="original"){
  source("my_kde1d.R")
  #
  rho_x <- my_kde1d(data = data$points$X, grid = data$grid$gx, weights = data$points$statweight,tbw)
  dx <- median(diff(data$grid$gx)) # because of tiny numerical deviations from uniform grid
  data$marg$x <- rho_x * dx        # convert density to probability
  data$marg$xsum <- sum(data$marg$x) 
  rho_y <- my_kde1d(data = data$points$LRR, grid = data$grid$gy, weights = data$points$statweight,tbw)
  dy <- median(diff(data$grid$gy)) # because of tiny numerical deviations from uniform grid
  data$marg$y <- rho_y * dy        # convert density to probability
  data$marg$ysum <- sum(data$marg$y) 
  #
  if (data$marg$ysum >= 0.99){
    data$checkfacy="passed"
  }
  else{
    data$facy=data$facy+0.3
    cat(paste0("increased y range factor in run ",np," to ",data$facy,"!","\n"))
  }
  return(data)
}