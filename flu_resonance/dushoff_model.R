library(deSolve)

beta = function(t, b0, b1, b2) {
    b0 * (1 + b1 * cos(b2*2*pi*t) );
}

model = function(t, y, p) {
    with(as.list(c(y, p)), {
        beta_t = beta(t, b0, b1, b2)
        ds = (n-s-i)/l - beta_t*i*s/n
        di = beta_t*i*s/n - i/d
        list(c(ds, di))
    })
}

pars = c(b1 = 0.04, b2 = 1, n = 500000)
yini = c(s = 500000 - 1, i = 1)
times = seq(from = 0, to = 20, by = 0.01)

pars['b0'] = 500
pars['l']  = 4
pars['d']  = 0.02
out1 = ode (times = times, y = yini, func = model, parms = pars)

pars['b0'] = 400
pars['l']  = 8
pars['d']  = 0.025
out2 = ode (times = times, y = yini, func = model, parms = pars)

plot_fig = function(x,y) {
    plot(x, y, ylim=c(0,4000), type='l', col='red', bty='n', xlab="Time", ylab="I", las=2)
}

row_subset = 1001:2001
t = times[row_subset]
Ia = out1[row_subset,3]
Ib = out2[row_subset,3]

par(mfrow=c(2,1))
plot_fig(t,Ia)
plot_fig(t,Ib)

pars['b2'] = 1.05
out3 = ode (times = times, y = yini, func = model, parms = pars)
points(t, out3[row_subset, 3], ylim=c(0,4000), type='l', col='blue', bty='n', xlab="Time", ylab="I", las=2)

pars['b2'] = 0.95 
out4 = ode (times = times, y = yini, func = model, parms = pars)
points(t, out4[row_subset, 3], ylim=c(0,4000), type='l', col='green', bty='n', xlab="Time", ylab="I", las=2)
