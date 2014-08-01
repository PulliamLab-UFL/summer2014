# Replication of stochastic model from Dushoff et al (2004)
# JL 08.01.14

# Using Gillespie SSA
library("GillespieSSA")

# params
ptm<-proc.time()
parms<-c(beta=400,inf=0.025,imm=4,N=50000) # parameters
x0<-c(S=5000,I=140,R=0) # initial state
a<-c("beta*I*S/N","I/inf","(N-S-I)/imm") # character vector of propensity functions
nu<-matrix(c(-1,0,1,1,-1,0,0,1,-1),nrow=3,byrow=TRUE)
out<-ssa(x0,a,nu,parms,tf=20,method="BTL")

dat<-out$dat
plot(dat[,1],dat[,3],type="l",xlim=c(0,20))
proc.time() -ptm



