# Lab exercises for Summer 2014

### For 27 June

Read and discuss:

> Dushoff, J, Plotkin, JB, Levin, SA, & Earn, DJD. (2004). Dynamical resonance can account for seasonality of influenza epidemics. _Proceedings of the National Academy of Sciences of the United States of America_, 101(48), 16915–6. [doi:10.1073/pnas.0407293101](http://www.pnas.org/content/101/48/16915.full)

### For 3 July

Code the deterministic model in Dushoff et al. 2004. If you want to do this in anything other than R, you're on your own. If you'll be using R, here are some resources to help you get started:

- Complete the [R Studio tutorial and R tutorials 1-3](http://lalashan.mcmaster.ca/theobio/mmed/index.php/Introduction_to_R), if you haven't already done this and are unfamiliar with either of these programs (or if you need a refresher).
- Complete the [lab on ODE's in R](http://lalashan.mcmaster.ca/theobio/mmed/index.php/Lab_1:_ODE_models_in_R)

During the lab meeting we'll discuss issues that arose and troubleshoot each other's code, as needed. We'll also look at some of the issues we discussed today, such as what happens when you initialize at the [endemic equilibrium](http://pulliamlab-ufl.github.io/summer2014/endemic.html) (with and without seasonal forcing).

#### Benchmarks

Your program should allow you to easily do these things:

- Reproduce Figure 1, panels A and B (minus the stochastic model results, of course!)
- Explore the effect of using different initial conditions on the dynamics observed, including what happens if you start at the disease-free equilibrium and what happens if you start at the endemic equlibrium (for the non-seasonal case)
- Explore the effect of using different parameter values on the dynamics observed
- Compare the model trajectory with and without a seasonal contact rate
- Calculate the intrinsic period of oscillation for a given set of parameters

*This doesn't necessarily mean that your code already does these things, but that it would take you a negligible amount of time for you to implement them, if someone were to ask you a specific question that requires any of these things.*

### For 11 July

You should come to lab meeting with a final version of your code that meets the criteria above. Note that, if you're paying attention, you will encounter some difficulty with the first benchmark, _even if your code is working properly_!

Please also review the [endemic equilibrium](http://pulliamlab-ufl.github.io/summer2014/endemic.html) calculations if you found them difficult to follow during lab meeting. 

### For 18 July

Write code for the stochastic model in Dushoff *et al*. 2004. To get started with the Gillespie algorithm, and implementing it in R:

- Review page 6-11 of [this presentation](http://plaza.ufl.edu/pulliam/training/icddrb/Welcome_files/Pulliam_ICDDRB_Day2.pdf) and the references cited therein.
- Follow this [step-by-step guide](http://yushan.mcmaster.ca/theobio/mmed/index.php/Gillespie) to learn how to write a Gillespie implementation of the SIRS model in R; feel free to look at the example code if you get stuck

This week's lab meeting will be a troubleshooting session, guided by [Tom](http://pulliamlab-ufl.github.io/people/hladish.html). Benchmarks to aim for with your code will be added after the meeting, and you should make any necessary modifications to meet them by July 25.

### For 25 July

You should come to lab meeting with a final version of your code that meets the criteria below. Note that, if you have written your code in R, running a simulation with a population of 500,000 inidividuals will take an extremely long time, _even if your code is working properly_! You are not expected to reproduce the blue lines in Figure 1 using your R code!

#### Benchmarks

Your program should allow you to easily do these things:

- Output the time until extinction for a single run of the Gillespie simulation
- Return the amount of time it takes to run a single realization of the Gillespie algorithm
- Explore the effect of using different parameter values on the dynamics observed (for an arbitrary population size)
- Visually compare the ODE model trajectory to a single realization of the Gillespie implementation, with the same parameter values and initial conditions

*Again, this doesn't necessarily mean that your code already does these things, but that it would take you a negligible amount of time for you to implement them, if someone were to ask you a specific question that requires any of these things.*
