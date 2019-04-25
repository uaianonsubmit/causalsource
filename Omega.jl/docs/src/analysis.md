# Analysis

More often that not we are interested in several properties

- How much time is left until the simulation finishes
- Convergence properties of the Markov Chains
- Periodically save results to disk

Currently most packages deal with these demands using callbacks.  Callback functions are passed to other functions.

There are a number of limitations to this approach.

Instead, in Omega we uses Lenses.


```julia
using Callbacks, Lens
x = ciid(ω -> (sleep(0.001); normal(ω, 0, 1)))
@leval Loop => showprogress(10000) rand(x, 10000) 
```

```julia
using Omega.Inference: plotloss
@leval Loop => plotloss() rand(x, x >ₛ 0.0, 10000; alg = SSMH)
```