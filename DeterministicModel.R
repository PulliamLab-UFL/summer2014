# Functions deterministic model in Dushoff et al. 2004
# Becky Borchering July 2014

## SIRS model for seasonal infection model

library(deSolve)

# Parameter values taken from Fig 1a

parms1a <- c(N=500000,          # total population size
					 L=4,								# average duration of immunity (in years)
					 D=0.02, 						# mean infectious period (in years)
					 beta.0=500,				# R0/D (individuals/year)
					 beta.1=0.02       # scaling factor for contact function
)

parms1b <- c(N=500000,          # total population size
             L=8,								# average duration of immunity (in years)
             D=0.025, 						# mean infectious period (in years)
             beta.0=500,				# R0/D (individuals/year)
             beta.1=0.02				# scaling factor for contact function
)


# Seasonal contact function 
Beta <- function(x,B0,B1){
	B0*(1+B1*cos(2*pi*x))
}

# default constant contact parameter
b = 100

MAXTIME <- 100
TIMESTEP <- 0.005

parms=parms1a   # choose parameter values

# calculate reproduction number 
R.0 = parms["D"]*parms["beta.0"] 

# calculate intrinsic period of oscillation
oscillation.period = 2*pi*sqrt(parms["D"]*parms["L"]/(R.0)) 
names(oscillation.period)="intrinsic period of oscillation"
oscillation.period

sirs.seasonal <- function(t,y,parms){
	with(c(as.list(y),parms),{ 
			
		dSdt <- (N-S-I)/L - Beta(t,beta.0,beta.1)*I*S/N 
		dIdt <- Beta(t,beta.0,beta.1)*I*S/N - I/D
		list(c(dSdt,dIdt))
	})
}

sirs.constant <- function(t,y,parms){
  with(c(as.list(y),parms),{ 
    
    dSdt <- (N-S-I)/L - b*I*S/N 
    dIdt <- b*I*S/N - I/D
    list(c(dSdt,dIdt))
  })
}


# seasonal time series
ts.seasonal <- data.frame(lsoda(c(S=499999,I=1),seq(0,MAXTIME,TIMESTEP),sirs.seasonal,parms1a)) 
plot(ts.seasonal$time,ts.seasonal$I,type="l",xlim=c(10,20),ylim=c(0,4000), main="Number infected", #bty="n",
		 xlab="Time (years)",  ylab="", cex.main=2, cex.lab=1.5, cex.axis=1.25, 
		 lwd =3, col="red")

# disease free equilibrium time series
ts.df <- data.frame(lsoda(c(S=500000,I=0),seq(0,MAXTIME,TIMESTEP),sirs.seasonal,parms1a)) 
plot(ts.df$time,ts.df$I,type="l",xlim=c(10,20),ylim=c(0,4000), main="Number infected", #bty="n",
     xlab="Time (years)",  ylab="", cex.main=2, cex.lab=1.5, cex.axis=1.25, 
     lwd =3, col="red")

# constant contact rate time series
ts.constant <- data.frame(lsoda(c(S=499999,I=1),seq(0,MAXTIME,TIMESTEP),sirs.constant,parms1a)) 
plot(ts.constant$time,ts.constant$I,type="l",xlim=c(10,20),ylim=c(0,4000), main="Number infected", #bty="n",
     xlab="Time (years)",  ylab="", cex.main=2, cex.lab=1.5, cex.axis=1.25, 
     lwd =3, col="red")

# Plot comparing seasonal and constant contact rate models
plot(ts.seasonal$time,ts.seasonal$I,type="l",xlim=c(10,20),ylim=c(0,4000), main="Number infected", #bty="n",
     xlab="Time (years)",  ylab="", cex.main=2, cex.lab=1.5, cex.axis=1.25, 
     lwd =3, col="red")
lines(ts.constant$time, ts.constant$I,type='l',lwd=3)
legend(x="topright",c("Seasonal transmission","Constant transmission"),col=c("red","black"),lty=c(1,1),lwd=3,bty="n")


# constant contact rate time series
b.vector = seq(0,100,20)

for (i in c(1:length(b.vector))){
  if(i==1){
    b <- b.vector[i]
  ts.constant <- data.frame(lsoda(c(S=499999,I=1),seq(0,MAXTIME,TIMESTEP),sirs.constant,parms1a)) 
  plot(ts.constant$time,ts.constant$I,type="l",xlim=c(10,30),ylim=c(0,4000), main="Number infected", #bty="n",
       xlab="Time (years)",  ylab="", cex.main=2, cex.lab=1.5, cex.axis=1.25, 
       lwd =2)
  } else {
    b <- b.vector[i]
    ts.constant <- data.frame(lsoda(c(S=499999,I=1),seq(0,MAXTIME,TIMESTEP),sirs.constant,parms1a)) 
    lines(ts.constant$time,ts.constant$I,type="l",lwd =2)
  }
}
  
  
  
 
