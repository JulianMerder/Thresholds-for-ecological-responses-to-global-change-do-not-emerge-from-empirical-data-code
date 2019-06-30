
## plot function for meta results:
# Data: your meta_pvalues() result
# show: for the original data use 'original'; for the last permuted surrogate use 'surrogate'
# pointsize: size of the points
# weights: should pointsizes be based on weights? TRUE or FALSE, ignores pointsize
# title: your plot title
# xname: your label for x
# yname: your label for y
# showleg: should a legend be shown? TRUE or FALSE
# useyd: should a density in y be added? TRUE or FALSE
# name_blue .._cyan.._darkblue.._green: give names for point levels



meta_plot<-function(Data,show="original",pointsize=7,weights=TRUE,title="title",xname="X",yname="Y",showleg=T,useyd=F,name_darkblue="marine",name_blue="aquatic",name_cyan="freshwater",name_green="terrestrial"){
  
  package <- c("plotly","dplyr")
  install <- package[!(package %in% installed.packages()[,"Package"])]
  if(length(install)) install.packages(install)
  library(plotly)
  library(dplyr)
  if(show=="surrogate"){KK<-Data$surrogate}
  else{KK<-Data$original}
  
  if(isTRUE(weights)){
    #pointsize<-sqrt(((Data$var.LRR-min(Data$var.LRR,na.rm=T))/(max(Data$var.LRR,na.rm=T)-min(Data$var.LRR,na.rm=T)))*72+49)
    KK$points<-KK$points %>%
      mutate(statweight = ntile(statweight, 5))%>%as.data.frame()
    pointsize<-KK$points$statweight+3
    pointsize[is.na(pointsize)]<-3
    
  }
  
  
  b<-KK$pquant[,3]
  a<-KK$pquant[,1]
  c<-KK$pquant[,2]
  ds<-KK$marg$x
  dy<-KK$marg$y
  if(!is.null(a) & !is.null(b) & !is.null(c)){
    legendgr=c('lower quantile marginal','upper quantile marginal','lower quantile','upper quantile','median marginal','median','values blue','values green','values darkblue','values cyan','density')
    p1<-plot_ly() %>% add_trace(x = KK$grid$gx, y = rep(quantile(KK$points$LRR,0.95,na.rm=T),length(KK$grid$gx)), type = 'scatter', mode = 'lines',
                                line = list(color = 'rgba(0,0,255,1)'),
                                showlegend = showleg, name = 'lower quantile marginal',legendgroup=legendgr[1]) %>%
      add_trace(x = KK$grid$gx,y = rep(quantile(KK$points$LRR,0.05,na.rm=T),length(KK$grid$gx)), type = 'scatter', mode = 'lines',
                fill = 'tonexty', fillcolor='rgba(0,0,255,0.1)', line = list(color = 'rgba(0,0,255,1)'),
                showlegend = showleg, name = 'upper quantile marginal',legendgroup=legendgr[2]) %>%
      add_trace(x = KK$grid$gx,y = a, type = 'scatter', mode = 'lines',
                line = list(color = 'rgba(255,0,0,1)'),
                showlegend = showleg, name = 'lower quantile',legendgroup=legendgr[3]) %>%
      
      add_trace(x = KK$grid$gx,y =b, type = 'scatter', mode = 'lines',
                fill = 'tonexty', fillcolor='rgba(255,0,0,0.2)', line = list(color = 'rgba(255,0,0,1)'),
                showlegend = showleg, name = 'upper quantile',legendgroup=legendgr[4])  %>%
      
      add_trace(x= KK$points$X[as.character(KK$points$col)=="blue"],y = KK$points$LRR[as.character(KK$points$col)=="blue"], type="scatter",mode = "markers",
                marker = list(size = pointsize[as.character(KK$points$col)=="blue"],color = 'rgba(0, 0, 255, .5)',line = list(color = 'rgba(0, 0, 255, .8)',
                                                                                         width = 2)),showlegend = showleg, name = name_blue,legendgroup=legendgr[7]) %>%
      
      add_trace(x= KK$points$X[as.character(KK$points$col)=="darkgreen"],y = KK$points$LRR[as.character(KK$points$col)=="darkgreen"], type="scatter",mode = "markers",
                marker = list(size = pointsize[as.character(KK$points$col)=="darkgreen"],color = 'rgba(0, 100, 0, .5)',line = list(color = 'rgba(0, 100, 0, .8)',
                                                                                         width = 2)),showlegend = showleg, name = name_green,legendgroup=legendgr[8]) %>%
      
      add_trace(x= KK$points$X[as.character(KK$points$col)=="darkblue"],y = KK$points$LRR[as.character(KK$points$col)=="darkblue"], type="scatter",mode = "markers",
                marker = list(size = pointsize[as.character(KK$points$col)=="darkblue"],color = 'rgba(0, 0, 139, 0.5)',line = list(color = 'rgba(0, 0, 139, 0.8)',
                                                                                          width = 2)),showlegend = showleg, name = name_darkblue,legendgroup=legendgr[9]) %>%
      
      add_trace(x= KK$points$X[as.character(KK$points$col)=="darkcyan"],y = KK$points$LRR[as.character(KK$points$col)=="darkcyan"], type="scatter",mode = "markers",
                marker = list(size = pointsize[as.character(KK$points$col)=="darkcyan"],color = 'rgba(0, 139, 139, 0.5)',line = list(color = 'rgba(0, 139, 139, 0.8)',
                                                                                            width = 2)),showlegend = showleg, name = name_cyan,legendgroup=legendgr[10]) %>%
      
      add_trace(x = KK$points$X,y = rep(median(KK$points$LRR,na.rm=T),length(KK$points$X)), type = 'scatter', mode = 'lines',
                line = list(dash="dot",color = 'rgba(0,0,255,1)'),
                showlegend = showleg, name = 'median marginal',legendgroup=legendgr[5]) %>%
      add_trace(x = KK$grid$gx,y = c, type = 'scatter', mode = 'lines',
                line = list(dash="dot",color = 'rgba(255,0,0,1)'),
                showlegend = showleg, name = 'median',legendgroup=legendgr[6])
    if(useyd==T){
      p2 <- plot_ly(name="x-density",x = ~KK$grid$gx, y = ~ds, type = 'scatter', mode = 'lines',fillcolor="moccasin", fill = 'tozeroy',line=list(color="moccasin"),legendgroup=legendgr[11],showlegend=showleg) 
      p4 <- plot_ly(name="y-density",x = ~dy[KK$grid$gy<2*max(KK$points$LRR,na.rm=T)&KK$grid$gy>2*min(KK$points$LRR,na.rm=T)], y = ~KK$grid$gy[KK$grid$gy<2*max(KK$points$LRR,na.rm=T)&KK$grid$gy>2*min(KK$points$LRR,na.rm=T)], type = 'scatter', mode = 'lines',fillcolor="green", fill = 'tozeroy',line=list(color="green"),legendgroup=legendgr[11],showlegend=showleg)
      p3<-subplot(p1,p4,p2,plotly_empty(type = 'scatter', mode = 'lines'),nrows = 2, shareX = T,heights = c(0.8,0.2),widths = c(0.8, 0.2),shareY = TRUE, titleX = T, titleY = FALSE)%>%
        layout(title = "",
               xaxis = list(title = xname,
                            #gridcolor = 'rgb(255,255,255)',
                            showgrid = FALSE,
                            showline = FALSE,
                            showticklabels = FALSE,
                            tickcolor = 'rgb(127,127,127)',
                            ticks = 'outside',
                            zeroline = FALSE),
               xaxis2 = list(title = "",
                             #gridcolor = 'rgb(255,255,255)',
                             showgrid = FALSE,
                             showline = FALSE,
                             showticklabels = FALSE,
                             tickcolor = 'rgb(255,255,255)',
                             ticks = 'outside',
                             zeroline = FALSE),
               yaxis = list(title = yname,
                            #gridcolor = 'rgb(255,255,255)',
                            showgrid = FALSE,
                            showline = FALSE,
                            showticklabels = TRUE,
                            tickcolor = 'rgb(127,127,127)',
                            ticks = 'outside',dtick = round((max(KK$points$LRR,na.rm=T)-min(KK$points$LRR,na.rm=T))/3,0),
                            zeroline = FALSE),
               yaxis2 = list(title = "x-density",
                             gridcolor = 'rgb(255,255,255)',
                             showgrid = FALSE,
                             showline = FALSE,
                             showticklabels = FALSE,
                             tickcolor = 'rgb(255,255,255)',
                             ticks = 'outside',
                             zeroline = FALSE),annotations = list(list(text = title,xref = "paper",yref = "paper",yanchor = "bottom",xanchor = "center",align = "center",x = 0.5,y = 1,showarrow = FALSE,font=list(size=20)),list(x=0.95,y=0.2,text="y-density",xref='paper',yref='paper',showarrow=F,font=list(size=13)))) 
      
    }
    else{
      p2 <- plot_ly(name="density",x = ~KK$grid$gx, y = ~ds, type = 'scatter', mode = 'lines',fillcolor="moccasin", fill = 'tozeroy',line=list(color="moccasin"),legendgroup=legendgr[11],showlegend=showleg) 
      p3<-subplot(p1,p2,nrows = 2, shareX = TRUE,heights = c(0.7,0.3))%>%
        layout(
               xaxis = list(title = xname,
                            #gridcolor = 'rgb(255,255,255)',
                            showgrid = FALSE,
                            showline = FALSE,
                            showticklabels = TRUE,
                            tickcolor = 'rgb(127,127,127)',
                            ticks = 'outside',
                            zeroline = FALSE),
               yaxis = list(title = yname,
                            #gridcolor = 'rgb(255,255,255)',
                            showgrid = FALSE,
                            showline = FALSE,
                            showticklabels = TRUE,
                            tickcolor = 'rgb(127,127,127)',
                            ticks = 'outside',dtick = round((max(KK$points$LRR,na.rm=T)-min(KK$points$LRR,na.rm=T))/3,0),
                            zeroline = FALSE),
               yaxis2 = list(title = "",
                             gridcolor = 'rgb(255,255,255)',
                             showgrid = FALSE,
                             showline = FALSE,
                             showticklabels = FALSE,
                             tickcolor = 'rgb(255,255,255)',
                             ticks = 'outside',
                             zeroline = FALSE),annotations = list(text = paste0('<b>',title,'<b>'),xref = "paper",yref = "paper",yanchor = "bottom",xanchor = "center",align = "center",x = 0.5,y = 1,showarrow = FALSE,font=list(size=20))) 
      
    }
    
    return(p3)} else{return(paste0("error some quantiles are NULL"))}
}
