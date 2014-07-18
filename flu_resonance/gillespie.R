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

pars = c(b1 = 0.04, b2 = 1, n = 10000)
yini = c(s = 6000, i = 1000)
delta = 1/365
times = seq(from = 0, to = 20, by = delta)

pars['b0'] = 500
pars['l']  = 4
pars['d']  = 0.02
out1 = ode (times = times, y = yini, func = model, parms = pars)

row_subset = which(times>=10)[[1]]:length(times)

next_event = function(t, y, p) {
    with(as.list(c(y, p)), {
        beta_t = beta(t, b0, b1, b2)
        StoI = beta_t*i*s/n
        ItoR = i/d
        RtoS = (n-s-i)/l
        totalRate = StoI + ItoR + RtoS
        event_time = rexp(1, totalRate)
        r = runif(1)
        if (r < StoI/totalRate) {
        #    print("StoI")
            s = s - 1
            i = i + 1
        } else if (r < (StoI + ItoR)/totalRate) {
        #    print("ItoR")
            i = i - 1
        } else {
        #    print("RtoS")
            s = s + 1
        }
        t = t + event_time
        return( list(time=t, compartments=c(s=s, i=i) ) )
    })
}

time = 0
y = yini
eventTimes = c(time)
prevalence = c(yini['i'])

while (time < 20 & y['i']) {
    output = next_event(time, y, pars)
    time = output$time
    y = output$compartments
    eventTimes = c(eventTimes, time)
    prevalence = c(prevalence, y['i'])
    #print(c(time, y['i']))
}



