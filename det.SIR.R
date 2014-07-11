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

compare.plots<-function(params, ts, y0, tkeep) {
  res <- lapply(params, function(p) { ode(y0, ts, sir, p)[,"I"] })
  res <- Reduce(cbind, res)
  matplot(ts, res, type="l", xlim=c(tkeep,max(ts)), ylim=c(0, 1.1*max(res[ts > tkeep,])), xlab="years", ylab="I")
}

compare.plots.y0<-function(params, ts, y0, tmax) {
  res <- lapply(y0, function(y) { ode(y, ts, sir, params)[,"I"] })
  res <- Reduce(cbind, res)
  matplot(ts, res, type="l", xlim=c(0, tmax), ylim=c(0, 1.1*max(res)), xlab="years", ylab="I")
}

compare.plots(list(parmsA,parmsB), seq(0,20,0.1), y0, 10)

vs.non.seasonal <- function(params, ...) {
  non.seasonal <- params
  non.seasonal["b1"] <- 0
  compare.plots(list(params, non.seasonal), ...)
}

vs.non.seasonal(parmsA, seq(0,20,0.1), y0, 0)

star <- function(params) with(as.list(params),{
  S <- N/(b0*D)
  return(c(S=S,I=(N-S)/(1+L/D)))
})

period <- function(params) with(as.list(params), 2*pi*sqrt(D*L/(D*b0-1)))

vs.eq.df <- function(params, ts, y0, ...) {
  y0.df <- c(params["N"]-0.1, 0.1)
  names(y0.df) <- c("S","I")
  y0.eq <- star(params)
  compare.plots.y0(params, ts, list(y0, y0.df, y0.eq), ...)
}

vs.eq.df(parmsA, seq(0,20,0.1), y0, 5)

