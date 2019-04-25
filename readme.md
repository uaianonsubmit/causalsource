# Source code

Please find the attached source code

- Counterfactual inverse planning model: [notebook](https://github.com/uaianonsubmit/causalsource/blob/master/IslandDispute/src/IslandDispute.ipynb) / [source](https://github.com/uaianonsubmit/causalsource/blob/master/IslandDispute/src)
- Actual causation mdoel: [notebook](https://github.com/uaianonsubmit/causalsource/blob/master/CanSeeInvRaytrace/src/CanSeeInvRaytrace.ipynb) / [source](https://github.com/uaianonsubmit/causalsource/blob/master/CanSeeInvRaytrace)
- Predator-Prey model: [notebook](https://github.com/uaianonsubmit/causalsource/blob/master/WolvesAndRabbits/src/WolvesAndRabbits.ipynb) / [source](https://github.com/uaianonsubmit/causalsource/blob/master/WolvesAndRabbits)

# Running experiments

To actually run the experiments you may need to add dependencies.  Tthey are included in this repository

1. Install Julia

2. From repl execute

```julia
]
add Omega#master Spec#master
develop repohome/Callbacks
develop repohome/RayTrace.jl  
```

Note that `repohome` here corresponds to whether the repoistory was closed.
and `]` is the julia repl command to change into the package manager mode.