# Lab exercises for Summer 2014

### For 27 June

Read and discuss:

> Dushoff, J, Plotkin, JB, Levin, SA, & Earn, DJD. (2004). Dynamical resonance can account for seasonality of influenza epidemics. _Proceedings of the National Academy of Sciences of the United States of America_, 101(48), 16915–6. [doi:10.1073/pnas.0407293101](http://www.pnas.org/content/101/48/16915.full)

### For 3 July

Code the deterministic model in Dushoff et al. 2004. If you want to do this in anything other than R, you're on your own. If you'll be using R, here are some resources to help you get started:

- Complete the [R Studio tutorial and R tutorials 1-3](http://lalashan.mcmaster.ca/theobio/mmed/index.php/Introduction_to_R), if you haven't already done this and are unfamiliar with either of these programs (or if you need a refresher).
- Complete the [lab on ODE's in R](http://lalashan.mcmaster.ca/theobio/mmed/index.php/Lab_1:_ODE_models_in_R)

During the lab meeting we'll discuss issues that arose and troubleshoot each other's code, as needed. We'll also look at some of the issues we discussed today, such as what happens when you initialize at the [endemic equilibrium](endemic.html) (with and without seasonal forcing).

#### Benchmarks

Your program should allow you to easily do these things:

- Reproduce Figure 1, panels A and B (minus the stochastic model results, of course!)
- Explore the effect of using different initial conditions on the dynamics observed, including what happens if you start at the disease-free equilibrium and what happens if you start at the endemic equlibrium (for the non-seasonal case)
- Explore the effect of using different parameter values on the dynamics observed
- Compare the model trajectory with and without a seasonal contact rate
- Calculate the intrinsic period of oscillation for a given set of parameters

*This doesn't necessarily mean that your code already does these things, but that it would take you a negligible amount of time for you to implement them, if someone were to ask you a specific question that requires any of these things.*
