# Functions stochastic model in Dushoff et al. 2004
# Becky Borchering July 2014

## Code for Gillespie algorithm adapted from Aaron A. King's document: 
## Simulation-based inference using mechanistic models 

## SIRS model for seasonal infection model

## Markov chain transition rates:
## Event              Change                Rate
## Infection          (S,I)->(S-1,I+1)      Beta(t)*I*S/N
## Recovery           (S,I)->(S,I-1)        I/D
## Immunity loss      (S,I)->(S+1,I)        (N-S-I)/L     # Is this change right?  

# Parameter values taken from Fig 1a

parms1a <- c(N=5500,          # total population size
             L=4,								# average duration of immunity (in years)
             D=0.02, 						# mean infectious period (in years)
             beta.0=500,				# R0/D (individuals/year)
             beta.1=0.04        # scaling factor for contact function
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

SIRS.onestep <- function (t,x, params, ...){
  with(c(as.list(x),params),{
    
    S <- x[2]                ## susceptibles
    I <- x[3]                ## infectious individuals
    
    rates <- c(
      transmission = Beta(t,beta.0,beta.1)*I*S/N, 
      recovery = I/D, 
      immunity.loss = (N-S-I)/L 
    )
#print(c("compartments",I,S,N))
    ## connect the compartments
    transitions <- list(
      transmission = c(-1,1),
      recovery = c(0,-1),
      immunity.loss = c(1,0)
    )
    
    total.rate <- sum(rates)
    
    if (total.rate>0) {
      dt <- rexp(n=1,rate=total.rate)             # time until next event
      event <- sample.int(n=3,size=1,prob=rates)  # determines what event happens
print(rates)
print(event)
      dx <- c(dt,transitions[[event]])            # updates S and I based on the event
    } else {
      dt <- Inf
      dx <- c(dt,0,0,0)
    }
    dx
  })
}

  
SIRS.sim <- function(params, t0, times, step.fn, ...) {
    result <- matrix(nrow=length(times),ncol=3)
    colnames(result) <- c("time","S","I")
    result[,1] <- times
    t <- t0
    #x <- c(params[c("S.0","I.0")])
    
    x <- c(t0,params[c("S.0","I.0")])
##    print(x)
## time_steps = 0
    for (k in seq_along(times)) { 
   # if(x[3]>0){
      if (t < times[k]) {
        repeat {
          dx <- step.fn(t,x,params,...)
          t <- t+dx[1]
##print(x[length(x)])
##time_steps = time_steps + 1
##if (time_steps > 10) exit()
          if (t >= times[k]) {
            result[k,-1] <- x[-1]
            x <- x+dx
            break
          }
          x <- x+dx
        }
    } else {
      result[k,-1] <- x[-1]
    }  
  }
#else {break}
  result
#}
}

parms <- c(S.0=5000,I.0=220, parms1a)   #parms1a["N"]-1,I.0=1)
x <- SIRS.sim(params=parms,t0=0,times=seq(from=0,to=14),step.fn=SIRS.onestep)
plot(I~time,type='o',data=as.data.frame(x))

