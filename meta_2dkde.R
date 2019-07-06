meta_2dkde <- function(data,tbw=2.5){
  source('my_kde2d.R')
  rho_xy <- my_kde2d( data$points$X, data$points$LRR, data$grid, data$points$statweight,tbw)
  dx <- median(diff(data$grid$gx)) # because of tiny numerical deviations from uniform grid
  dy <- median(diff(data$grid$gy)) # because of tiny numerical deviations from uniform grid
  data$joint <- rho_xy*dx*dy
  data$jointsum <- sum(data$joint)
  #persp(data$joint, phi = 50, theta = 20, d = 5, xlab="x", ylab="y", zlab='density')
  return(data)
}