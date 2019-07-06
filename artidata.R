artidata <- function(set=1, np=150, isnr=0, r="n", p="y"){
  # set:  type of dataset (1: sn bifurcation=default, 2: neutral, 3: plain trend, 4: gradual,  5: strict threshold
  #                        6: variable threshold, 7: thresh. & intermed., 8: var.threshold + var.response)
  # np:   number of data points (default=150)
  # isnr: inverse snr = 1/snr = noise-to-signal ratio (nsr) (default: 0)
  # r:    "n" (normal distribution=default) OR 'u'  (uniform distribution) of stressor samples
  # p:    produce a plot: "y" (yes=default), "n" (no)
  #
  ##################################################################################################################################
  # 1: sn bifurcation
  ##################################################################################################################################
  if(set==1){
    #c: centre (reponse value halfway between tipping points)
    #g: gap (response difference between tipping points)
    #w: width (of the bistable regime)
    #v: var of norm. noise (N(0,v))
    c <- 0
    g <- 1
    w <- 1
    v <- isnr*g^2/2
    ymi<- -1.5
    yma<- +1.5
    xmi  <- w/4*(ymi-c)/(g/2)*( ((ymi-c)/(g/2))^2 - 3 )
    xma  <- w/4*(yma-c)/(g/2)*( ((yma-c)/(g/2))^2 - 3 )    
    y0  <- seq(ymi,yma, length.out=10000)
    x0  <- w/4*(y0-c)/(g/2)*( ((y0-c)/(g/2))^2 - 3 )
    #
    if (r=='u')       # select np equidistributed sample of x values
    {x <- runif(np,min=-1,max=1)}
    else              # select np normally distributed sample of x values
    {
      x <- numeric(0)
      nr <- np
      while(nr>0){
        buf <- rnorm(10*np, mean = c, sd = w/2)
        buf <- buf[buf>=xmi & buf<=xma]
        x <- c(x,buf[1:min(nr,length(buf))])
        nr <- length(x)-np
      }
    }
    xl <- x[x <= -w/2]
    yl <- c + g * sign(xl) * cosh( acosh(abs(xl)/(w/2))/3)
    xm <- x[-w/2 < x & x < w/2]
    ym <- c + g * sign(xm) * cos( acos(abs(xm)/(w/2))/3 + round(runif(length(xm)))*2*pi/3 )
    xu <- x[w/2 <= x]
    yu <- c + g * sign(xu) * cosh( acosh(abs(xu)/(w/2))/3)
    x <- c(xl,xm,xu)
    y <- c(yl,ym,yu) + rnorm(length(x),sd=sqrt(v))
  }
  #
  ##################################################################################################################################
  # 2: neutral  
  ##################################################################################################################################
  if(set==2){
    #g: gap (response difference between upper and lower level )
    #w: width (of the stressor range)
    #v: var of norm. noise (N(0,v))
    g  <- 1
    w  <- 1
    v  <- isnr*g^2/2
    x0 <- seq(-w,w, length.out=200)
    y0 <- cbind(rep(-g/2,length(x0)),rep(+g/2,length(x0)))
    if (r=='u')
    {x <- runif(np,min=-w/2,max=w/2)}               # select np equidistributed sample of x values
    else
    {x <- rnorm(np, mean = 0, sd = w/6)}            # select np normally distributed sample of x values
    rand <- runif(np) 
    y  <- -0.5*g + (rand>0.5)*g + rnorm(length(x),sd=sqrt(v))
  }
  
  ##################################################################################################################################
  # 3: plain trend (proportionate response)
  ##################################################################################################################################
  if(set==3){
    #g: gap (response difference between upper and lower level )
    #w: width (of the stressor range)
    #v: var of norm. noise (N(0,v))
    g  <- 1
    w  <- 1
    v  <- isnr*g^2/2
    x0 <- seq(-1,1,len=1000)
    y0 <- x0
    if (r=='u')
    {x <- runif(np,min=-w/2,max=w/2)}               # select np equidistributed sample of x values
    else
    {x <- rnorm(np, mean = 0, sd = w/6)}            # select np normally distributed sample of x values
    y <- x + rnorm(np,sd=sqrt(v))
  }
  #
  ##################################################################################################################################
  # 4: gradual
  ##################################################################################################################################
  if(set==4){
    #g: gap (response difference between upper and lower level )
    #w: width (of the stressor range)
    #v: var of norm. noise (N(0,v))
    g  <- 1
    w  <- 1
    v  <- isnr*g^2/2
    alpha <- 1/2
    beta <- 2
    a <- 2^alpha/(3^alpha-1)
    x0 <- seq(-w,w, length.out=200)
    y0 <- a*((1+x0)^alpha-1)
    if (r=='u')
    {x <- runif(np,min=-w/2,max=w/2)}               # select np equidistributed sample of x values
    else
    {x <- rnorm(np, mean = 0, sd = w/6)}            # select np normally distributed sample of x values
    y <- a*((1+x)^alpha-1) + sqrt(v)*(1+x)^beta * rnorm(length(x))
  }
  #
  ##################################################################################################################################
  # 5: strict threshold
  ##################################################################################################################################
  if(set==5){
    #g: gap (response difference between upper and lower level )
    #w: width (of the stressor range)
    #v: var of norm. noise (N(0,v))
    g  <- 1
    w  <- 1
    v  <- isnr*g^2/2
    x1 <- seq(-w,0, length.out=200)
    x2 <- seq(0,+w, length.out=200)
    x0 <- cbind(x1,x2)
    y1 <- rep(-g/2, length(x1))
    y2 <- rep(+g/2, length(x2))
    y0 <- cbind(y1,y2)
    if (r=='u')
    {x <- runif(np,min=-w/2,max=w/2)}               # select np equidistributed sample of x values
    else
    {x <- rnorm(np, mean = 0, sd = w/6)}            # select np normally distributed sample of x values
    y  <- g/2*( (x>0) - (x<0) ) + rnorm(length(x),sd=sqrt(v)) 
  }
  #
  ##################################################################################################################################
  # 6: variable thrreshold
  ##################################################################################################################################
  if(set==6){
    #g: gap (response difference between upper and lower level )
    #w: width (of the stressor range)
    #v: var of norm. noise (N(0,v))
    g  <- 1
    w  <- 1
    v  <- isnr*g^2/2
    xb <- seq(-w,w/5, length.out=200)
    yb <- rep(-g/2,length(xb))
    xt <- seq(-w/5,w, length.out=200)
    yt <- rep(g/2,length(xt))
    x0 <- cbind(xb,xt)
    y0 <- cbind(yb,yt)
    if (r=='u')
    {x <- runif(np,min=-w/2,max=w/2)}               # select np equidistributed sample of x values
    else
    {x <- rnorm(np, mean = 0, sd = w/6)}            # select np normally distributed sample of x values
    thresh <- seq(-w/5, w/5, length.out=np)
    y  <- g/2*( (x>thresh) - (x<thresh) ) + rnorm(length(x),sd=sqrt(v)) 
  }
  #
  ##################################################################################################################################
  # 7: threshold & intermediate
  ##################################################################################################################################
  if(set==7){
    #g: gap (response difference between upper and lower level )
    #w: width (of the stressor range)
    #v: var of norm. noise (N(0,v))
    g  <- 1
    w  <- 1
    v  <- isnr*g^2/2
    alpha <- 1/2
    beta <- 2
    a <- 2^alpha/(3^alpha-1)
    xb <- seq(-w,w/5, length.out=200)
    yb <- rep(-g/2,length(xb))
    xt <- seq(-w/5,w, length.out=200)
    yt <- rep(g/2,length(xt))
    xg <- seq(-w,w, length.out=200)
    yg <- a*((1+xg)^alpha-1)
    x0 <- cbind(xb,xt,xg)
    y0 <- cbind(yb,yt,yg)
    if (r=='u')
    {x <- runif(np,min=-w/2,max=w/2)}               # select np equidistributed sample of x values
    else
    {x <- rnorm(np, mean = 0, sd = w/6)}            # select np normally distributed sample of x values
    nt <- round(np/2)
    thresh <- seq(-w/5, w/5, length.out=nt)
    yt <- g/2*( (x[1:nt]>thresh) - (x[1:nt]<thresh) ) + rnorm(nt, sd=sqrt(v))
    yg <-  a*((1+x[(nt+1):np])^alpha-1) + sqrt(v)*(1+x[(nt+1):np])^beta * rnorm(np-nt)
    y <- c(yt,yg)
  }
  #
  ##################################################################################################################################
  # 8: variable threshold & variable response
  ##################################################################################################################################
  if(set==8){
    #g: gap (response difference between upper and lower level )
    #w: width (of the stressor range)
    #v: var of norm. noise (N(0,v))
    g  <- 1
    w  <- 1
    v  <- isnr*g^2/2
    alpha <- 1/2
    xb <- seq(-w,w/5, length.out=200)
    yb <- rep(-g/2,length(xb))
    xl <- seq(-w/5,w, length.out=200)
    yl <- g* ( 1/2 - ((1+w/2)^alpha-(1+xl)^alpha)/((1+w/2)^alpha-(1-w/5)^alpha) )
    xr <- seq(w/5,w, length.out=200)
    yr <- g* ( 1/2 - ((1+w/2)^alpha-(1+xr)^alpha)/((1+w/2)^alpha-(1+w/5)^alpha) )
    x0 <- cbind(xb,xl,xr)
    y0 <- cbind(yb,yl,yr)
    if (r=='u')
    {x <- runif(np,min=-w/2,max=w/2)}               # select np equidistributed sample of x values
    else
    {x <- rnorm(np, mean = 0, sd = w/6)}            # select np normally distributed sample of x values
    thresh <- seq(-w/5, w/5, length.out=np)
    y <- numeric(np)
    y[x<=thresh] <- -g/2 + rnorm(sum(x<=thresh),sd=sqrt(v))
    y[x>thresh]  <- g* ( 1/2 - ((1+w/2)^alpha-(1+x[x>thresh])^alpha)/((1+w/2)^alpha-(1+thresh[x>thresh])^alpha) ) + 
      rnorm(sum(x>thresh),sd=sqrt(v))
  }
  #
  ##################################################################################################################################
  # create plot
  ##################################################################################################################################
  if (p=='y'){
    # plot deterministic backbone (red curve) and sample points (blue circles)
    facx <- 1
    facy <- 1.1
    xl <- mean(x) - facx*(mean(x)-min(x))
    xu <- mean(x) + facx*(max(x)-mean(x))
    yl <- mean(y) - facy*(mean(y)-min(y))
    yu <- mean(y) + facy*(max(y)-mean(y))
    xl <- min(c(xl,-w/2,-xu))
    xu <- max(c(xu,+w/2,-xl ))
    yl <- min(c(yl,-1.2*g,-yu))
    yu <- max(c(yu,+1.2*g),-yl)
    plot(x,y, xlim=c(xl,xu), ylim=c(yl,yu), type='p', col='blue', lwd=2, xlab = 'X', ylab = 'LRR')
    if(exists("y0")){
      if(is.null(ncol(y0))){
        lines(x0,y0, col='red', lwd=2)
      }
      else{
        for (i in 1:ncol(y0)){
          if(is.null(ncol(x0))){
            lines(x0,y0[,i], col='red', lwd=2)
          }
          else{
            lines(x0[,i],y0[,i], col='red', lwd=2)        
          }
        }
      }
    }
  }
  #
  ##################################################################################################################################
  # prepare data frame 'points' to be used for further analyses
  ##################################################################################################################################
  points <- data.frame(x,y,rep(1,np),rep('blue',np),rep(1,np))
  names(points) <- c('X','LRR','var.LRR','col','scale')
  #
  return(points)
}