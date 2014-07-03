#Dushoff et al. deterministic model: Luke - summer 2014 
library(deSolve)

flu_parms  <- c(n=500000, #population size
               L=4, #duration of immunity (years)
               D=0.02, #mean infectious period (years)
               B0=500, #contacts per year
               B1=0.02 #scaler 
)

flu_parms_too  <- c(n=500000, #population size
                L=8, #duration of immunity (years)
                D=0.025, #mean infectious period (years)
                B0=400, #contacts per year
                B1=0.02 #scaler 
)


#contact rate function
beta_t  <- function(tx, B_0, B_1){
    B_0*(1+B_1*cos(2*pi*tx))
}

MAXTIME  <- 100
TIMESTEP  <- 0.005

#SIRS function

flu_sirs  <- function(t,y,flu_parms){
  with(c(as.list(y),flu_parms),{
    
    dS_dt <- (n-S-I)/L-beta_t(t,B0,B1)*I*S/n
    dI_dt <- beta_t(t,B0,B1)*I*S/n-I/D
    list(c(dS_dt,dI_dt))
  })
}  
flu_sirs_too  <- function(t,y,flu_parms_too){
    with(c(as.list(y),flu_parms_too),{
      
      dS_dt <- (n-S-I)/L-beta_t(t,B0,B1)*I*S/n
      dI_dt <- beta_t(t,B0,B1)*I*S/n-I/D
      list(c(dS_dt,dI_dt))
    })
}
#setting run time (time series)
rt  <- data.frame(lsoda(c(S=499999,I=1),seq(0,MAXTIME,TIMESTEP),flu_sirs,flu_parms))
rt2  <- data.frame(lsoda(c(S=499999,I=1),seq(0,MAXTIME,TIMESTEP),flu_sirs_too,flu_parms_too))
par(mfrow=c(1,2))
plot(rt$time,rt$I,type="l",xlim=c(0,10), ylim=c(0,60000), main="Flu seasonality", xlab="Time(years)", 
     ylab="Infected individuals", cex.lab=1.5, cex.axis=1.25, col="green")

plot(rt2$time,rt2$I,type="l",xlim=c(0,10), ylim=c(0,60000), main="Flu seasonality", xlab="Time(years)", 
     ylab="Infected individuals", cex.lab=1.5, cex.axis=1.25, col="pink")

