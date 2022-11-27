library(MASS)
library(pracma)
library(VGAM)
source("rdnn.R")
#######2d#######
####################Cauchy##################################
d=2; n=100; N=c(10,10); L=1;p=500;s=0.5;epoch=100;batch=256
error=0.5*rcauchy(n,location = 0, scale = 0.5)+0.5*rnorm(n)

Grid=list()
Grid[[1]]=seq(0,1,length.out = N[1])
Grid[[2]]=seq(0,1,length.out = N[2])
x_data=array(NA, c(N[1], N[2], 2))
for(j in 1:(N[1])){
  for(k in 1:(N[2])){
    x_data[j,,1]=Grid[[2]]
    x_data[,k,2]=Grid[[1]]
  }
}
x_data.1=as.vector(x_data[,,1])
x_data.2=as.vector(x_data[,,2])
#Adjust true function here 
y_train.true=(-8)/(1+exp(cot(x_data.1^2)*cos(2*pi*x_data.2)))
#y_train.true=log(sin(2*pi*x_data.1)+2*abs(tan(2*pi*x_data.2))+2)

cov=array(NA, c(N[1]*N[2], N[1]*N[2], 2))
for(j in 1:(N[1]*N[2])){
  for(k in 1:(N[1]*N[2])){
    #Adjust covariance structure here
    cov[j,k,1]=cos(2*pi*(x_data.1[j] - x_data.1[k]))
    cov[j,k,2]=cos(2*pi*(x_data.2[j] - x_data.2[k]))
  }
}

for(i in 1:n){
  #Adjust error process here
   e_p=mvrnorm(1, rep(0, N[1]*N[2]), (cov[,,1]+cov[,,2])) + error[i]
   Data[[i]]=array(e_p, c(N[1], N[2]))+array(y_train.true, c(N[1], N[2]))
}

r=rFDADNN(Data, d, Grid, N, n, L, p, s, epoch, batch, "huber", quantile=NULL)

#L2 loss
mean((r$estimation-y_train.true)^2)


####################Slash##################################
d=2; n=100; N=c(10,10); L=1;p=500;s=0.5;epoch=100;batch=256
error=0.5*rslash(n, mu = 0, sigma = 0.5)+0.5*rnorm(n)

Grid=list()
Grid[[1]]=seq(0,1,length.out = N[1])
Grid[[2]]=seq(0,1,length.out = N[2])
x_data=array(NA, c(N[1], N[2], 2))
for(j in 1:(N[1])){
  for(k in 1:(N[2])){
    x_data[j,,1]=Grid[[2]]
    x_data[,k,2]=Grid[[1]]
  }
}
x_data.1=as.vector(x_data[,,1])
x_data.2=as.vector(x_data[,,2])
#Adjust true function here 
y_train.true=(-8)/(1+exp(cot(x_data.1^2)*cos(2*pi*x_data.2)))
#y_train.true=log(sin(2*pi*x_data.1)+2*abs(tan(2*pi*x_data.2))+2)

cov=array(NA, c(N[1]*N[2], N[1]*N[2], 2))
for(j in 1:(N[1]*N[2])){
  for(k in 1:(N[1]*N[2])){
    #Adjust covariance structure here
    cov[j,k,1]=cos(2*pi*(x_data.1[j] - x_data.1[k]))
    cov[j,k,2]=cos(2*pi*(x_data.2[j] - x_data.2[k]))
  }
}

for(i in 1:n){
  #Adjust error process here
  e_p=mvrnorm(1, rep(0, N[1]*N[2]), (cov[,,1]+cov[,,2])) + error[i]
  Data[[i]]=array(e_p, c(N[1], N[2]))+array(y_train.true, c(N[1], N[2]))
}
r=rFDADNN(Data, d, Grid, N, n, L, p, s, epoch, batch, "huber", quantile=NULL)

#L2 loss
mean((r$estimation-y_train.true)^2)




#######3d#######
####################Cauchy##################################
d=3; n=100; N=c(5, 5, 5); L=1;p=500;s=0.5;epoch=100;batch=256
error=0.5*rcauchy(n,location = 0, scale = 0.5)+0.5*rnorm(n)
Grid=list()
Grid[[1]]=seq(1/N[1],1,length.out = N[1])
Grid[[2]]=seq(1/N[2],1,length.out = N[2])
Grid[[3]]=seq(1/N[3],1,length.out = N[3])
x1=rep(rep(Grid[[1]],N[2]*N[3]))
x2=rep(rep(Grid[[2]],each=N[1]),N[3])
x3=rep(Grid[[3]],each=N[1]*N[2])
x_train=cbind(x1,x2,x3)
#Adjust true function here 
y_train.true=exp(1/3*sin(2*pi*x1)+1/2*x2+sqrt(x3+0.1))
cov=array(NA, c(N[1]*N[2]*N[3], N[1]*N[2]*N[3], 3))
for(i in 1:(N[1]*N[2]*N[3])){
for(j in 1:(N[1]*N[2]*N[3])){
  #Adjust covariance structure here
  cov[i,j,1]=cos(2*pi*(x1[i] - x1[j]))
  cov[i,j,2]=cos(2*pi*(x2[i] - x2[j]))
  cov[i,j,3]=cos(2*pi*(x3[i] - x3[j]))
 }
}
Data=list()
for(i in 1:n){
  #Adjust error process here
e_p=mvrnorm(1, rep(0, N[1]*N[2]*N[3]), (cov[,,1]+cov[,,2]+cov[,,3]))+rnorm(1, 0, 1)
Data[[i]]=array(e_p, c(N[1], N[2], N[3]))+array(y_train.true, c(N[1], N[2], N[3]))
}
r=rFDADNN(Data, d, Grid, N, n, L, p, s, epoch, batch, "huber", quantile=NULL)

#L2 loss
mean((r$estimation-y_train.true)^2)





####################Slash##################################
d=3; n=100; N=c(5, 5, 5); L=1;p=500;s=0.5;epoch=100;batch=256
error=0.5*rcauchy(n,location = 0, scale = 0.5)+0.5*rnorm(n)
Grid=list()
Grid[[1]]=seq(1/N[1],1,length.out = N[1])
Grid[[2]]=seq(1/N[2],1,length.out = N[2])
Grid[[3]]=seq(1/N[3],1,length.out = N[3])
x1=rep(rep(Grid[[1]],N[2]*N[3]))
x2=rep(rep(Grid[[2]],each=N[1]),N[3])
x3=rep(Grid[[3]],each=N[1]*N[2])
x_train=cbind(x1,x2,x3)
#Adjust true function here 
y_train.true=exp(1/3*sin(2*pi*x1)+1/2*x2+sqrt(x3+0.1))
cov=array(NA, c(N[1]*N[2]*N[3], N[1]*N[2]*N[3], 3))
for(i in 1:(N[1]*N[2]*N[3])){
  for(j in 1:(N[1]*N[2]*N[3])){
    #Adjust covariance structure here
    cov[i,j,1]=cos(2*pi*(x1[i] - x1[j]))
    cov[i,j,2]=cos(2*pi*(x2[i] - x2[j]))
    cov[i,j,3]=cos(2*pi*(x3[i] - x3[j]))
  }
}
Data=list()
for(i in 1:n){
  #Adjust error process here
  e_p=mvrnorm(1, rep(0, N[1]*N[2]*N[3]), (cov[,,1]+cov[,,2]+cov[,,3]))+rnorm(1, 0, 1)
  Data[[i]]=array(e_p, c(N[1], N[2], N[3]))+array(y_train.true, c(N[1], N[2], N[3]))
}

r=rFDADNN(Data, d, Grid, N, n, L, p, s, epoch, batch, "huber", quantile=NULL)

#L2 loss
mean((r$estimation-y_train.true)^2)
