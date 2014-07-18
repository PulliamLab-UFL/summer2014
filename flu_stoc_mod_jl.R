# Replication of stochastic model from Dushoff et al (2004)
# JL 07.17.14

# Gillespie Algorithm

# In the Dushoff model have S - I, I - R and R - S 'events'
# For S - I   have s- i+ ro
# For I - R   have so i- r+
# For R - S   have s+ io r-

# the rate expressions for these 'events' weights the decision for which event
# goes next- calculate each one based on the current number of each S I R, then 
# pick one randomly based on weighted probabilities, then need to update the values
# based on the above matrix

# rate S - I is beta*I*S/N
# rate I - R is I/dur.inf
# rate R - S is (N-S-I)/dur.imm

# time to the next event is exp(beta*I*S/N + I/dur.inf + (N-S-I)/dur.imm)
# probability event is type i- p_i = lambda_i / sum(lambdai_i)for all i

# initial time
init.time<-0
# end of time
max.time<-20

# params
trans.rate<-500
inf<-0.02
imm<-4
pop<-5000
  
# function with constant beta first to test code works
flu.func<-function(time,S,I,R,beta=trans.rate,dur.inf=inf,dur.imm=imm,N=pop){
s.i<- beta*I*S/N
i.r<- I/dur.inf
r.s<- (N-S-I)/dur.imm

lambda_event<- sum(s.i, i.r, r.s)
tau_event<- rexp(1, rate= lambda_event)

t.next<- time + tau_event
# need to pick an event at random, weighted by the probability 

rand.no<-runif(1)
if(rand.no < s.i/lambda_event){
  S<- S-1
  I<- I+1
}else{
      if(rand.no < (s.i+i.r)/lambda_event){
        I<- I-1
        R<- R+1
      }else{
          R<- R-1
          S<- S+1
  }
}
return(data.frame(time=t.next,S=S,I=I,R=R))
}

flu.time<-data.frame(time=init.time,S=pop-1,I=1,R=0)
t.next<-flu.time
while(t.next$time< max.time & t.next$I>0){
  t.next<-flu.func(time=t.next$time,S=t.next$S,I=t.next$I,R=t.next$R)
  flu.time<-rbind(flu.time,t.next)
  if (t.next$I==0) t.next$I=1
}
# very slow!
plot(flu.time$time,flu.time$I,type="l")

