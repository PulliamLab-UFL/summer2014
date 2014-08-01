# Functions stochastic model in Dushoff et al. 2004
# GillespieSSA version
# Becky Borchering August 2014

require(GillespieSSA)
??gillespiessa
demo(sir)

 #===============================================================================
 #  SIR model (Dushoff, 2004)
 #===============================================================================
 
## SIRS model for seasonal infection model

  ## Markov chain transition rates: 
  ## Event              Change                Rate
  ## Infection          (S,I)->(S-1,I+1)      Beta(t)*I*S/N
  ## Recovery           (S,I)->(S,I-1)        I/D
  ## Immunity loss      (S,I)->(S+1,I)        (N-S-I)/L     

   # This model consists of three events with the following per capita rates,
   # transmission: Beta(t)*I*S/N
   # recovery:     I/D
   # immunity loss: (N-S-I)/L
   
   # Define parameters
  parms1a <- c(N=50000,          # total population size
             L=4,  							# average duration of immunity (in years)
             D=0.02, 						# mean infectious period (in years)
             beta.0=500,				# R0/D (individuals/year)
             beta.1=0.04       # scaling factor for contact function
  )

  # Seasonal contact function 
    Beta <- function(x,B0,B1){
    B0*(1+B1*cos(2*pi*x))
    }

  # default constant contact parameter
  b = 400  

  # Define system
   #x0 <- c(S=5000, I=140, R=parms1a["N"]-S-I)                      # Initial state vector
   x02 <- c(S=5000,I=224)

  # nu <- matrix(c(-1,0,1,1,-1,0,0,1,-1),nrow=3,byrow=T) # State-change matrix
   nu2 <- matrix(c(-1,0,1,1,-1,0),nrow=2,byrow=T) # State-change matrix

  # a  <- c("Beta(t,beta.0,beta.1)*I*S/N", "I/D","(N-S-I)/L")                # Propensity vector
  a  <- c("b*I*S/N", "I/D","(N-S-I)/L")  
  a2  <- c("b*I*S/N", "I/D","(N-S-I)/L")  
# rates <- c(
#   transmission = Beta(t,beta.0,beta.1)*I*S/N, 
#   recovery = I/D, 
#   immunity.loss = (N-S-I)/L 
# )

   tf <- 100                                     # Final time

   simName <- "Dushoff SIR"

  # Run the simulations
  nf <- layout(matrix(c(1,2,3,4),ncol=2, byrow=T))
  
   # Optimized tau-leap method
     set.seed(2)

   #out <- ssa(x0,a,nu,parms1a,tf,method="OTL",simName,verbose=TRUE,consoleInterval=1)
   out2 <- ssa(x02,a,nu2,parms1a,tf,method="BTL",simName,verbose=TRUE,consoleInterval=1)

dat<-out2$dat  

  # ssa.plot(out2,show.title=FALSE,show.legend=FALSE) 
  
    plot(dat[,1],dat[,3],type='l',xlim=c(0,10))#,show.title=FALSE,show.legend=FALSE) 
