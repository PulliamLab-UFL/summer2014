require(deSolve)

sir <- function(t, y, parms) with( as.list(c(y, parms)), {
  xfer <- b0 * (1 + b1*cos(2*pi*t)) * S * I / N
  dSdt <- (N - S - I)/L - xfer
  dIdt <- xfer - I/D
  return(list(c(dSdt, dIdt)))
})

N0 <- 500000; I0 <- 2250
y0 <- c(S=N0-I0, I=I0)
parmsA <- c(N=N0, L=4, D= 0.02,  b0=500, b1=0.02)
parmsB <- c(N=N0, L=8, D= 0.025, b0=400, b1=0.02)
# N, total pop.
# L, immunity time scale
# D, infectious time scale
# b0, time-average transmission coeff
# b1, time-varying coeff amplitude

plotter<-function(parms) {
  out <- ode(y0, seq(0,20,0.1), sir, parms)
  ymax <- 2*mean(out[which(out[,'time'] > 10),'I'])
  plot(out[,'time'], out[,'I'], type = "l", xlim=c(10,20), ylim=c(0,ymax), ylab="I", xlab="year")
}

plotter(parmsA)
plotter(parmsB)
