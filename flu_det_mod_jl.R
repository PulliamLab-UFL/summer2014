# Replication of deterministic model from Dushoff et al (2004)
# JL 09.07.14

library(deSolve)

# Deterministic model
# det.mod is a function with arguments t,y and params.
# the input to argument y is a vector of the state variables-these are variables we are
# interested in and that change over time, so the input of y is a vector containing
# the initial number of: S and I hosts

det.mod<-function(t,y,params){ 
	S <- y[1] # susceptible hosts
	I <- y[2] # infectious hosts
	
	# parameters
	N<-params[1] # total population size
	beta0<-params[2]
	beta1<-params[3]
	dur.inf<-params[4] # d
	dur.imm<-params[5] # l
	
		# time-dependent beta
		beta.t.func<-function(b0,b1,time){
			beta.t<-b0*(1 + b1*cos(2*pi*(time)))
			return(beta.t)
		}
	beta<-beta.t.func(b0=beta0,b1=beta1,time=t)
		
	# ODE's
	dS.dt <- (N-S-I)/dur.imm - beta*I*S/N
	dI.dt <- beta*I*S/N - I/dur.inf
	# list containing the derivatives
	xdot <- c(dS.dt,dI.dt)
	return(list(xdot))
}

flu.sim<-function(N,beta0,beta1,dur.imm,dur.inf,i0=1/N,s0=N-i0*N,t.max=20,ts=0.001){
	I.0<-i0
	S.0<-s0
	# timesteps
	times<-seq(0,t.max,ts) 
	# initial conditions
	init<-c(sus=S.0,inf=I.0)
	return(data.frame(lsoda(init,times,det.mod,c(N,beta0,beta1,dur.inf,dur.imm))))
}

plot.flu.sim<-function(mod,yax=c(0,4000),xax=c(10,20)){
	plot(mod$time, mod$inf,ylim=yax,xlim=xax,type="l",ylab="Number infected",xlab="Time (years)")
}

# a weak resonance
a<-flu.sim(N=500000,dur.imm=4,dur.inf=0.02,beta0=500,beta1=0.02)
plot.flu.sim(a)
# b strong resonance
b<-flu.sim(N=500000,dur.imm=8,dur.inf=0.025,beta0=400,beta1=0.02)
plot.flu.sim(b)

# results using params detailed in the methods qualitatively similar but amplitude of oscillations smaller
# beta1 of 0.02 only produced a contact rate that varies from 490 to 510 giving R0 of 9.8 and 10.2
# not 9.6 and 10.4, need to change beta1:

# a weak resonance
a<-flu.sim(N=500000,dur.imm=4,dur.inf=0.02,beta0=500,beta1=0.04)
plot.flu.sim(a)
# b strong resonance
b<-flu.sim(N=500000,dur.imm=8,dur.inf=0.025,beta0=400,beta1=0.04)
plot.flu.sim(b,xax=c(0,20))

# change in initial conditions to endemic equilibrium
# need to know number of infecteds and number of susceptibles at endemic equilibrium

# Number of infecteds + sus for situations a) and b)
IS.end.eq.func<-function(N,dur.inf,dur.imm,beta){
		R0<-dur.inf*beta
		I.end.eq<-(N-N/R0)/(1+(dur.imm*beta)/R0)
		S.end.eq<-N/R0
	return(c(S.end.eq,I.end.eq))
}

SI.end.eq.a<-IS.end.eq.func(N=500000,dur.inf=0.02,dur.imm=4,beta=500)
SI.end.eq.b<-IS.end.eq.func(N=500000,dur.inf=0.025,dur.imm=8,beta=400)

# endemic equilibrium with forcing as per a
c<-flu.sim(N=500000,dur.inf=0.02,dur.imm=4,beta0=500,beta1=0.04,i0=SI.end.eq.a[2],s0=SI.end.eq.a[1])
plot.flu.sim(c,xax=c(0,20))
# endemic equilirbium without forcing, rest as per a
d<-flu.sim(N=500000,dur.inf=0.02,dur.imm=4,beta0=500,beta1=0,i0=SI.end.eq.a[2],s0=SI.end.eq.a[1])
plot.flu.sim(d,xax=c(0,20))

# endemic equilibrium with forcing as per b
e<-flu.sim(N=500000,dur.inf=0.025,dur.imm=8,beta0=400,beta1=0.04,i0=SI.end.eq.b[2],s0=SI.end.eq.b[1])
plot.flu.sim(e,xax=c(0,20))
# endemic equilirbium without forcing, rest as per b
f<-flu.sim(N=500000,dur.inf=0.025,dur.imm=8,beta0=400,beta1=0,i0=SI.end.eq.b[2],s0=SI.end.eq.b[1])
plot.flu.sim(f,xax=c(0,20))

# oscillations in incidence that variations in R0 would cause if disease dynamics
# responded instantaneously to changes in transmission without resonance
#.......


#  the intrinsic period of oscillation is approximately: 
int.per.func<-function(d,l,R0){
	t= 2*pi*sqrt((d*l)/(R0-1))
	return(t)
}

a.t<-int.per.func(0.02,4,10)

b.t<-int.per.func(0.025,8,10)


