meta_prepare <- function(data, nx=100, ny=512, facx=1, facy=1.2){
  x <- data$points$X
  y <- data$points$LRR
  #compute the statistical weight of points from reported variance
  w <- data$points$statweight <-log(1+1/data$points$var.LRR)
  #set the range for the 2d-density
  xl <- max(x) - facx*(max(x)-min(x))
  xu <- min(x) + facx*(max(x)-min(x))
  yl <- max(y) - facy*(max(y)-min(y))
  yu <- min(y) + facy*(max(y)-min(y))
  data$crange <- r <- c(xl,xu,yl,yu)
  #define the 2d-grid (nx times ny)
  data$grid$gx <- seq.int(r[1],r[2], length.out = nx)
  data$grid$gy <- seq.int(r[3],r[4], length.out = ny)
  return(data)
}
