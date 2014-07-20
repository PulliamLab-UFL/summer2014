# gillespieDushoff2004.R

rm(list=ls())
source("dushoff2004.R")

event <- function(time,S,I,params){
  with(as.list(params),{
    
    rates <- c(transRate = beta.t(time,beta0,beta1)*S*I/N,
               recovRate = I/DD,
               lossRate = (N-S-I)/LL)
    totRate <- sum(rates)
    
    eventTime <- time+rexp(1,totRate)
    
    eventType <- sample(c("Transmission","Recovery","Loss"),1,prob=rates)
    
    switch(eventType,
           "Transmission" = {
             S <- S-1
             I <- I+1
           },
           "Recovery" = {
             I <- I-1
           },
           "Loss" = {
             S <- S+1
           }
    )
    return(data.frame(time=eventTime,S=S,I=I))
  })
}

gsim <- function(t,y,params){
  with(as.list(y),{
    ts <- data.frame(time=min(t),S=round(S),I=round(I))
    nextEvent <- ts
    while(nextEvent$time<max(t)&nextEvent$I>0){
      nextEvent <- event(nextEvent$time,nextEvent$S,nextEvent$I,params)
      ts <- rbind(ts,nextEvent)
    }
    return(ts)
  })
}

testParams <- c(N = 50000,
                LL = 4,
                DD = 0.02,
                beta0 = 500,
                beta1 = 0.04)
testInit <- endemicEq(testParams)

startTime <- Sys.time()
tsTest <- gsim(seq(0,10,.05),endemicEq(testParams),testParams)
endTime <- Sys.time()
print(endTime-startTime)

tsDetTest <- runSIR(testParams,col="red",lwd=3,xmin=0,ymax=500)
lines(tsTest$time,tsTest$I,col="blue",lwd=2)

startTime <- Sys.time()
ts <- gsim(seq(0,.1,.05),endemicEq(fig1A),fig1A)
endTime <- Sys.time()
print(endTime-startTime)
# Time difference of 8.068511 mins

MAXTIME <- 0.1
TIMESTEP <- 0.05
runGillespie <- function(params,init = endemicEq(params), time.out = seq(0,MAXTIME,TIMESTEP),plot=F,browse=F,...){
  if(browse) browser()
  startTime <- Sys.time()
  ts <- gsim(
    times = time.out,             # Timepoints for output
    y = init,                     # Initial conditions for population
    params = params               # Vector of parameters
  )
  endTime <- Sys.time()
  out <- list(ts = data.frame(ts),params = params)
  if(plot){
    plotSIR(out,compare=T,col="blue",...)
  }
  print(endTime-startTime)
  return(out)
}
