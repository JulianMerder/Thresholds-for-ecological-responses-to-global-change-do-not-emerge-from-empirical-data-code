meta_quant <- function(data){
nx <- length(data$grid$gx)
srange <- data$crange[3:4]
#firstly, for all p distributions  
p <- data$p
pgrid <- data$grid$gy
pquant <- array(0,c(nx,3))
pcdf <- apply(p, 2, cumsum)
for (i in 1:nx){
  pf <- approxfun(pgrid, pcdf[,i])
  pquant[i,1] <- uniroot(function(x) pf(x)-0.05, srange)$root
  pquant[i,2] <- uniroot(function(x) pf(x)-0.50, srange)$root
  pquant[i,3] <- uniroot(function(x) pf(x)-0.95, srange)$root
}
#add this to the data structure
data$pcdf <- pcdf
data$pquant <- pquant
#
#now the same for refrence distribution q
q <- data$q
qgrid <- pgrid
qquant <- array(0,3)
qcdf <- cumsum(q)
qf <- approxfun(qgrid, qcdf)
qquant[1] <- uniroot(function(x) qf(x)-0.05, srange)$root
qquant[2] <- uniroot(function(x) qf(x)-0.50, srange)$root
qquant[3] <- uniroot(function(x) qf(x)-0.95, srange)$root
#add this to the data structure
data$qcdf <- qcdf
data$qquant <- qquant
#
return(data)
}