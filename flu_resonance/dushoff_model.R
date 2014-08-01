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

endemic_S = function(N, b0, D) { N/(b0*D) }
endemic_I = function(N, b0, D, L) { (N- (N/(b0*D)))/(1+L/D) }

find_peaks = function(x) {which(diff(sign(diff(x)))==-2)+1}

pars = c(b1 = 0.0, b2 = 1, n = 500000)
yini = c(s = 500000 - 1, i = 1)
#s_star = endemic_S(500000, 500, 0.02)
#i_star = endemic_I(500000, 500, 0.025, 8)
#yini = c(s = s_star+1, i = i_star-1)
delta = 1/365
times = seq(from = 0, to = 20, by = delta)

plot_fig = function(x,y,clr='red',...) {
    plot(x, y, ylim=c(0,4000), type='l', col=clr, bty='n', xlab="Time", ylab="I", las=2, ...)
    abline(v=min(x)+find_peaks(y)*delta, col='#00555555')
}

row_subset = which(times>=0)[[1]]:length(times)
t = times[row_subset]

par(mfrow=c(2,1))
par(mar=c(4.5,5,1,1))

pars['b0'] = 500
pars['l']  = 4
pars['d']  = 0.02
out1 = ode (times = times, y = yini, func = model, parms = pars)
Ia = out1[row_subset,3]
plot_fig(t,Ia)
points(t, endemic_I(500000, beta(t, 500, 0.02, 1), 0.02, 4), type='l')

pars['b0'] = 400
pars['l']  = 8
pars['d']  = 0.025
out2 = ode (times = times, y = yini, func = model, parms = pars)
Ib = out2[row_subset,3]

plot_fig(t,Ib)
points(t, endemic_I(500000, beta(t, 400, 0.025, 1), 0.025, 8), type='l')

print(table(diff(find_peaks(Ia))))
print(table(diff(find_peaks(Ib))))

pars['b2'] = 1.2
out3 = ode (times = times, y = yini, func = model, parms = pars)
#points(t, out3[row_subset, 3], ylim=c(0,4000), type='l', col='blue', bty='n', xlab="Time", ylab="I", las=2)
#plot_fig(t, out3[row_subset, 3], clr='blue')

pars['b2'] = 0.8 
out4 = ode (times = times, y = yini, func = model, parms = pars)
#points(t, out4[row_subset, 3], ylim=c(0,4000), type='l', col='green', bty='n', xlab="Time", ylab="I", las=2)
#plot_fig(t, out4[row_subset, 3], clr='green')

period = function(d,l,b0) { 2*pi*sqrt((d*l)/(d*b0-1)) }
