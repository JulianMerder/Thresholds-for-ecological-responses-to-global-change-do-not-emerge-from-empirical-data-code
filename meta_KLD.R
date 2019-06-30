meta_KLD <- function(data, eps=0){
  p <- data$p
  q <- data$q
  p[p<eps] <- eps     # for numerical stability
  q[q<eps] <- eps     # for numerical stability
  mx <- data$marg$x
  nrows <- dim(p)[1]
  ncols <- dim(p)[2]
  if (length(q) != nrows) stop('error in meta_KL: dimensions of p and q not compatible ')
  KLD <- 0
  for (s in 1:ncols){
    for (n in 1:nrows){
      if (q[n] > 0 & p[n,s] > 0){
        KLD <- KLD + mx[s]*p[n,s]*log(p[n,s]/q[n])
      }
      else if (p[n,s]==0){
        KLD <- KLD
      }
      else{
        stop('check distributions p and q!')
      }
    }
  }
  return(KLD)
}