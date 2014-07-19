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

pars = c(b1 = 0.04, b2 = 1, n = 500000)

#delta = 1/365
#times = seq(from = 0, to = 20, by = delta)

pars['b0'] = 500
pars['l']  = 4
pars['d']  = 0.02

s_i = endemic_S(pars['n'], pars['b0'], pars['d'])-1
i_i = endemic_I(pars['n'], pars['b0'], pars['d'], pars['l'])+1
yini = c(s = 49999, i = 2240) 
#yini = c(s = s_i, i = i_i) # what the hell is wrong with R?  Why does it change these names?

#out1 = ode (times = times, y = yini, func = model, parms = pars)

next_event = function(t, y, p) {
    with(as.list(c(y, p)), {
        beta_t = beta(t, b0, b1, b2)
        StoI = beta_t*i*s/n
        ItoR = i/d
        RtoS = (n-s-i)/l
        totalRate = StoI + ItoR + RtoS
        event_time = rexp(1, totalRate)
        r = runif(1)
        if (r < StoI/totalRate) { #    print("StoI")
            s = s - 1
            i = i + 1
        } else if (r < (StoI + ItoR)/totalRate) { #    print("ItoR")
            i = i - 1
        } else { #    print("RtoS")
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

#while (time < 20) {
while ((time < 20) & (y['i'] > 0)) {
    output = next_event(time, y, pars)
    time = output$time
    y = output$compartments
    eventTimes = c(eventTimes, time)
    prevalence = c(prevalence, y['i'])
    #print(c(time, y['i']))
}
write.table(data.frame(eventTimes, prevalence), file="r_output")
