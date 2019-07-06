meta_norm <- function(data){
auxmat <- t(data$joint)
data$p   <- scale(auxmat, center=FALSE, scale=colSums(auxmat))
return(data)
}