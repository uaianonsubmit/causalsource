# Source code

Please find the attached source code

- Counterfactual inverse planning model: [notebook](https://github.com/uaianonsubmit/causalsource/blob/master/IslandDispute/src/IslandDispute.ipynb) / [source](https://github.com/uaianonsubmit/causalsource/blob/master/IslandDispute/src)
- Actual causation mdoel: [notebook](https://github.com/uaianonsubmit/causalsource/blob/master/CanSeeInvRaytrace/src/CanSeeInvRaytrace.ipynb) / [source](https://github.com/uaianonsubmit/causalsource/blob/master/CanSeeInvRaytrace)
- Predator Prey model [notebook](https://github.com/uaianonsubmit/causalsource/blob/master/WolvesAndRabbits/src/WolvesAndRabbits.ipynb) / [source](https://github.com/uaianonsubmit/causalsource/blob/master/WolvesAndRabbits)

# Running experiments

To actually run the experiments yourself you may need to add dependencies (included in this submissiong)

```julia
] add Omega#master Spec#master
] develop repohome/Callbacks
] develop repohome/RayTrace.jl
```