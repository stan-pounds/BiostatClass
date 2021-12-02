library(mclust)

bootstrap.kmeans=function(X,           # matrix with rows as subjects and columns as variables
                          k,           # number of subgroups to define
                          b=100,       # number of bootstrap iterations to perform
                          seed=NULL)   # initial seed for random number generation
                          
  
{
  ##################################################
  # Compute bootstrap iterations of k-means
  
  set.seed(seed)                              # set seed for random number generation
  n=nrow(X)                                   # extract sample size
  boot.index=replicate(b,sample(n,replace=T)) # indices of subjects for each bootstrap cohort
  boot.index=cbind(1:n,boot.index)            # add first column with observed data
  bC.mtx=matrix(NA,n,b+1)                     # initialize result of bootstrap cluster matrix
  for (i in 1:(b+1))                          # begin loop over bootstrap iterations
  {
    bX=X[boot.index[,i],]                       # extract cohort for this iteration
    res=kmeans(bX,k)                            # compute result for this iteration
    dup=duplicated(boot.index[,i])              # identify duplicated indices
    indx=boot.index[!dup,i]                     # extract unique indices
    bC.mtx[indx,i]=res$cluster[!dup]            # store result in bootstrap cluster matrix
  }                                           # end loop over bootstrap iterations
  
  ###################################################
  # Compute adjusted Rand index of each bootstrap iteration with original data set
  
  A=apply(bC.mtx[,-1],2,ari,bC.mtx[,1])
  

  ###################################################
  # Compute reproducibility of cluster assignment of each subject
  R=rep(NA,n)                                 # initialize the result vector
  for (i in 1:n)                              # loop over subjects
  {
    bC.ind=matrix(bC.mtx[i,],n,b+1,byrow=T)     # extract results for this subject
    m=(bC.mtx==bC.ind)                          # determine which individuals are grouped with this subject
    m1=matrix(m[,1],n,b+1)                      # indicates which individuals group with this subject in observed data
    m1[is.na(m)]=NA
    int=colSums(m[-i,]&m1[-i,],na.rm=T)         # assigned to same group as subject i in both bootstrap and observed cohort
    unn=colSums((m[-i,]|m1[-i,]),na.rm=T)       # assigned to same group as subject i in either bootstrap and/or observed cohort
    av=colSums(!is.na(m[-i,]))                  # number of subjects with meaningful data for each bootstrap
    a=int/unn                                   # compute the ratio
    a=a[av>0]                                   # limit to bootstraps with meaningful data
    R[i]=mean(a[-1],na.rm=T)                    # compute mean over bootstraps
  }                                           # end loop over subjects
  
  ######################################################
  # Package and return the result
  
  res=list(X=X,              # input data matrix
           A=A,              # ARI of bootstrap results with original result
           R=R,              # Reproducibility of each subject's assignment across bootstraps
           bC.mtx=bC.mtx)    # Assignment of each subject in original data (column 1) and each bootstrap (later columns)

  class(res)="bootstrap.kmeans"
  
  return(res)

}

######################################
# Visualize the result of bootstrap.kmeans

visualize.bskm=function(bskm.result,
                        method="PC",
                        show.2boots=F,
                        clrs=NULL)
  
{
  k=max(bskm.result$bC.mtx[,1])
  if (is.null(clrs)) clrs=rainbow(k)
  
  if (method=="tsne")
  {
    D.mtx=dist(bskm.result$X,"euclidean")
    viz.res=tsne(D.mtx)
  }
  if (method=="PC") viz.res=prcomp(bskm.result$X)$x[,1:2]
  
  mean.ari=mean(bskm.result$A)
  
  plot(viz.res[,1],viz.res[,2],
       main="Observed Cohort",
       xlab=paste(method,1),ylab=paste(method,2),
       col="darkgray",pch=19,
       sub=paste0("Mean Bootstrap ARI = ",round(mean.ari,4)))

  points(viz.res[,1],viz.res[,2],
         pch=19,cex=bskm.result$R^2,
         col=clrs[bskm.result$bC.mtx[,1]])
  
  if (show.2boots)
  {
    b=ncol(bskm.result$bC.mtx)
    indx=c(2,b)
    
    for (i in indx)
    {
      plot(viz.res[,1],viz.res[,2],
           main=paste0("Bootstrap Cohort ",i-1),
           xlab=paste(method,1),ylab=paste(method,2),
           col=clrs[bskm.result$bC.mtx[,i]],
           pch=19,cex=0.75)
    }    
  }
  
  boxplot(bskm.result$R~bskm.result$bC.mtx[,1],
          horizontal=T,xlab="Reproducibility",
          las=1,ylab="",ylim=c(0,1),
          main="Bootstrap Reproducibility by Subgroup",
          col=clrs)
  

}


###########################################
# Print a summary of the bootstrap.kmeans result

print.bootstrap.kmeans=function(bskm.result)
  
{
  write("Observed Cluster Assignments: ",file="")
  print(table(bskm.result$bC.mtx[,1]),file="")
  
  write("\n Cohort ARI Summary: ",file="")
  print(summary(bskm.result$A))
  
  write("\n Subject Co-assignment Reproducibility: ",file="")
  print(summary(bskm.result$R))
  
  write("\n Mean Reproducibility by Cluster: ",file="")
  res=aggregate(x=bskm.result$R,
                by=list(cluster=bskm.result$bC.mtx[,1]),
                mean)
  names(res)=c("cluster","reproducibility")
  print(res)
}

######################################
# Compute adjusted Rand index after removing NAs

ari=function(x,y)
{
  ok=!(is.na(x)|is.na(y))
  res=adjustedRandIndex(x[ok],y[ok])
  return(res)
}

#####################################
# Compute false discovery rate estimates of Pounds & Cheng (2006)

pc06.fdr=function(p)
{
  pi0.hat=min(2*mean(p,na.rm=1),1)
  q=p.adjust(p,"fdr")
  q=pi0.hat*q
  return(q)
}