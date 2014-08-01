# Functions stochastic model in Dushoff et al. 2004
# Becky Borchering July 2014

## Code for Euler-multinomial approximation method
## adapted from Aaron A. King's document: 
## Simulation-based inference using mechanistic models 

## SIRS model for seasonal infection model

## Markov chain transition rates:
## Event              Change                Rate
## Infection          (S,I)->(S-1,I+1)      Beta(t)*I*S/N
## Recovery           (S,I)->(S,I-1)        I/D
## Immunity loss      (S,I)->(S+1,I)        (N-S-I)/L  

require(pomp)

parms1a <- c(N=500000,          # total population size
             L=4,								# average duration of immunity (in years)
             D=0.02, 						# mean infectious period (in years)
             beta.0=500,				# R0/D (individuals/year)
             beta.1=0.04       # scaling factor for contact function
)

SI.eulerstep <- function (x, params, dt){
  with(c(as.list(x),params),{
    
    t <- x[1]            
    S <- x[2]
    I <- x[3]
  
    S.to.I <- reulermultinom(n=1,size=S,rate=Beta(t,beta.0,beta.1)*I/N,dt=dt)
    I.recover <- reulermultinom(n=1,size=I,rate=1/D,dt=dt)
    R.loss <- reulermultinom(n=1,size=(N-S-I),rate=1/L,dt=dt)
    c(
      dt,
      R.loss-S.to.I,
      S.to.I-I.recover
      )
})
}

SI.proc.sim <- function (x, t, params, delta.t,...){
  with(c(as.list(x),params),{
  c(  
    S.to.I <- reulermultinom(n=1,size=S,rate=Beta(t,beta.0,beta.1)*I/N,dt=dt),
    I.recover <- reulermultinom(n=1,size=I,rate=1/D,dt=dt),
    R.loss <- reulermultinom(n=1,size=(N-S-I),rate=1/L,dt=dt)) -> trans
  x[c("S","I")] + c(
    R.loss-S.to.I,
    S.to.I-I.recover
    )
  })
}

SI.sim = euler.sim(SI.proc.sim,delta.t=1/20)
SI.sim

require(GillespieSSA)
