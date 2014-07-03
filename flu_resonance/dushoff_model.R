library(deSolve)

beta = function(b0, b1, t) {
    b0 * (1 + b1 * cos(2*pi*t) );
}

model = function(t, y, p) {
    beta_t = beta(p['b0'], p['b1'], t)
    ds = (p['n']-y[1]-y[2])/p['l'] - beta_t*y[2]*y[1]/p['n']
    di = beta_t*y[2]*y[1]/p['n'] - y[2]/p['d']
    list(c(ds, di))
}


pars = c(b0 = 500, b1 = 0.02, n = 500000, l = 4, d = 0.02)
yini = c(s = pars['n'] - 1, i = 1)
times = seq(from = 0, to = 20, by = 0.01)
out1 = ode (times = times, y = yini, func = model, parms = pars)

pars = c(b0 = 400, b1 = 0.02, n = 500000, l = 8, d = 0.025)
out2 = ode (times = times, y = yini, func = model, parms = pars)
