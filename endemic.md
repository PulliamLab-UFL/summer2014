---
layout: page
title: Summer 2014 in the Pulliam Lab @ UF
---


The equations from the paper are:

$$
\frac{dS}{dt} = \frac{N-S-I}{L} - \frac{\beta S I}{N}
$$

$$
\frac{dI}{dt} = \frac{\beta S I}{N} - \frac{I}{D}
$$

By definition, the system is at equilibrium when $\frac{dS}{dt} = 0$ and $\frac{dI}{dt} = 0$, which is to say that

\begin{equation}
\frac{N-S^*-I^*}{L} - \frac{\beta S^* I^*}{N} = 0
\end{equation}

\begin{equation}
\frac{\beta S^* I^*}{N} - \frac{I^*}{D} = 0
\end{equation}

We now need to solve these two equations for the two unknowns, $S^*$ and $I^*$. Let's start by looking at the second equation, which can be rewritten as:

$$
I^* \left(\frac{\beta S^*}{N} - \frac{1}{D}\right) = 0
$$

It should be clear that one solution of this equation is $I^*=0$, but we're interested in the other solution (since we're interested in the endemic equilibrium). So, we want to find the value of $S^*$ for which

$$
\left(\frac{\beta S^*}{N} - \frac{1}{D}\right) = 0
$$

To find $S^*$, we can add $1/D$ to both sides of the equation, giving:
$$
\frac{\beta S^*}{N} = \frac{1}{D}
$$

Now, if we multiply both sides by $N/\beta$, we get:

\begin{equation}
S^* = \frac{N}{\beta D}
\end{equation}

We can now substitute the expression for $S^*$ into equation (1) to give
$$
\frac{N-\frac{N}{\beta D}-I^*}{L} - \frac{\beta \frac{N}{\beta D} I^*}{N} = 0
$$


or,

$$
\frac{N-\frac{N}{\beta D}-I^*}{L} = \frac{\beta \frac{N}{\beta D} I^*}{N}
$$

Notice that we can cancel some terms on the right hand side of this equation to get:

$$
\frac{N-\frac{N}{\beta D}-I^*}{L} = \frac{I^*}{D}
$$

And we can re-write the left hand side of this equation to get:

$$
\frac{N}{L}-\frac{N}{\beta D L}-\frac{I^*}{L} = \frac{I^*}{D}
$$

Adding $\frac{I^*}{L}$ to both sides gives

\begin{eqnarray*}
\frac{N}{L}-\frac{N}{\beta D L} &=& \frac{I^*}{L} + \frac{I^*}{D}
&&
&&
 &=& I^* \left( \frac{1}{L} + \frac{1}{D} \right)
\end{eqnarray*}

By dividing both sides by $\left( \frac{1}{L} + \frac{1}{D} \right)$, we have an expression for $I^*$:

$$
I^* = \frac{\frac{N}{L}-\frac{N}{\beta D L}}{\frac{1}{L} + \frac{1}{D}}
$$

But it's not pretty! Let's clean it up a bit by multiplying the numerator and the denominator both by $L$, then canceling terms where we can:

\begin{eqnarray*}
I^* &=& \frac{\frac{LN}{L}-\frac{LN}{\beta D L}}{\frac{L}{L} + \frac{L}{D}}
&&
&&
&=& \frac{N-\frac{N}{\beta D}}{1 + \frac{L}{D}}
\end{eqnarray*}

which can also be written as

$$
I^* = \frac{N-S^*}{1 + \frac{L}{D}}
$$

\end{document}  
