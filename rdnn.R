#Data: List of n, each element is a d dimension array.
#d: Dimension of data.
#Grid: List of d, each gives a vector of selected grid points on [0,1].
#N: Vector of length d, the ith element is the number of grid points in the ith dimension, no more than 4. 
#n: sample size.
#p: Vector for widths, each layer has the same width.
#L: Vector for number of hidden layers.
#s: Vector for dropout rate, from 0 to 1.
#epoch: Number of epochs.
#batch: Batch size.
#loss: Character of Loss function, "l1", "l2", "huber" or "check".
#quantile: Numerical value between 0 and 1, when loss function is "check".

library(keras)
library(tensorflow)
rFDADNN=function(Data, d, Grid, N, n, L, p, s, epoch, batch, loss, quantile=NULL){
  #Process grid points
  if(d==1){
    x_train=Grid[[1]]
  }else if(d==2){
    x1=rep(rep(Grid[[1]],N[2]))
    x2=rep(Grid[[2]],each=N[1])
    x_train=cbind(x1,x2)
  }else if(d==3){
    x1=rep(Grid[[1]],N[2]*N[3])
    x2=rep(rep(Grid[[2]],each=N[1]),N[3])
    x3=rep(Grid[[3]],each=N[1]*N[2])
    x_train=cbind(x1,x2,x3)
  }else if(d==4){
    x1=rep(rep(Grid[[1]],N[2]*N[3]*N[4]))
    x2=rep(rep(Grid[[2]],each=N[1]),N[3]*N[4])
    x3=rep(rep(Grid[[3]],each=N[1]*N[2]), N[4])
    x4=rep(Grid[[4]],each=N[1]*N[2]*N[3])
    x_train=cbind(x1,x2,x3, x4)
  }
  y_train.raw=matrix(NA, n, base::prod(N))
  for(i in 1:n){
    y_train.raw[i, ]=as.vector(Data[[i]])
  }
  y_train=base::colMeans(y_train.raw)
  
  
  
  if(loss=="l1"){
    LOSS="mean_absolute_error"
  }else if(loss=="l2"){
    LOSS="mean_squared_error"
  }else if (loss=="huber"){
    LOSS="huber_loss"
  }else if (loss=="check"){
    LOSS="check"
    tilted_loss <- function(q,y,f){
      e <- y-f
      k_mean(k_maximum(q*e, (q-1)*e), axis=2)
    }  
  }
  
  
  
  model <- keras::keras_model_sequential() 
  
  model %>% 
    keras::layer_dense(units=p, activation = "relu", input_shape = c(d), kernel_initializer = "normal")%>%
    keras::layer_dropout(rate = s) 
  for(xx in 1:L){
    model %>% 
      keras::layer_dense(units=p, activation = "relu", kernel_initializer = "normal")%>%
      keras::layer_dropout(rate = s) 
  }
  model %>% keras::layer_dense(units=1)
  
  if(loss=="check"){
    model %>% keras::compile(
      optimizer = keras::optimizer_adam(),
      loss = function(y_true, y_pred)
        tilted_loss(quantile, y_true, y_pred),
      metrics = list("mse")
    )
  }else{
    model %>% keras::compile(
      loss = LOSS,
      optimizer = keras::optimizer_adam(),
      metrics = list("mse")
    )
  }
  
  
  
  history <- model %>% keras::fit(
    x_train, y_train, 
    epochs = epoch, batch_size = batch
  )
  y.reg=model %>% stats::predict(x_train)
  if(d==1){
    estimation=array(y.reg, N)
  }else if(d==2){
    estimation=array(y.reg, c(N[1], N[2]))
  }else if(d==3){
    estimation=array(y.reg, c(N[1], N[2], N[3]))
  }else if(d==4){
    estimation=array(y.reg, c(N[1], N[2], N[3], N[4]))
  }
  pse=mean((y.reg-y_train)^2)
  if(d==1){
    plot.dnn=plot(x_train, y.reg, main="DNN estimation of 1d curve", type="l", xlab="Grids", ylab="Estimation")
  }else if(d==2){
    plot.dnn=plotly::plot_ly(
      x = Grid[[1]], 
      y = Grid[[2]], 
      z = matrix(y.reg, N[1], N[2]), 
      type = "contour",
      colorbar=list(tickfont=list(size=18)))
  }else if(d==3){
    plot.dnn=plot3D::scatter3D(x_train[,1],x_train[,2],x_train[,3],colvar = y.reg, pch=16, phi=0, theta=30, colkey=FALSE, xlab="x1", ylab="x2", zlab="x3")
  }
  list(plot.dnn=plot.dnn, estimation=estimation, pse=pse)
}