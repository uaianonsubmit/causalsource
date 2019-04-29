module CanSeeInvRaytrace

include("common.jl")

using Callbacks
using InvRayTrace: img, img_obs, nointersect, scene
using InvRayTrace: Vec3, Sphere
import InvRayTrace
import RayTrace
import ImageView
using Lens
using Omega
using Omega.Space
using CanSee
using Images
using Plots

"Generate 500 samples using inverse graphics"
generatedata() = InvRayTrace.sampleposterior_noi(500; noi = false, alg = SSMH, gamma = 100.0);

"High resolution render of scene"
highresrender(sc) = RayTrace.rgb.(RayTrace.render(sc; width = 1024, height = 1024));

# ### Actual Causation
# In this example we use counterfactuals to determine whether a is the cause of b.
# In particular, to determine whether the position of some object a is the cause of us not being able to see object b
# We will solve two problems
# 1. Inverse Graphics, figure out what hte 3d scene is that created a 2d image
# 2. The actual causation question described above

# In principle we could do these simultaneously as one big inference query but to save computation time here we will solve the 1 first and use that data data in the second

# ### 1. Inverse Graphics

# Sample from the posterior of scenes
samples = generatedata();

# Visualize a single sample from the posterior
scene_sample = samples[end]
highresrender(scene_sample)

# From a copy of the scene take a single object, Remove object with id gid from scene
scene_sample2 = deepcopy(scene_sample)
gid = 1

# Create a new scene `scene_sample3` which has object which has the gid'th object removed
scene_sample3 = RayTrace.ListScene([g for (i, g) in enumerate(scene_sample2.geoms) if i!=gid])
k = scene_sample.geoms[gid];

# We will add a white ball into the scene inside of k 

# Define the material colour white
white = RayTrace.Material(Vec3(1.0, 1.0, 0.0), 0.5, 0.0, Vec3(0.0, 0.0, 0.0));

# Create a new white sphere `objb` at position of `k` but a fraction `frac` of the size
frac = 0.8
objb = RayTrace.MaterialGeom(Sphere(k.center, k.r*frac), white)

# Add the new sphere to the scene
push!(scene_sample2.geoms, objb);

# Inspect which element of the scene are visible

# The module [CanSee](https://github.com/uaianonsubmit/causalsource/blob/master/CanSee/src/CanSee.jl) defines the predicate `cansee(scene, obj)` which returns a (soft) Boolean over whether `obj` is visible in `scene`
# It projects rays from the viewpoint of the observer and tests for each object whether there is a ray which hits it 

"For each element in scene determine if it can be seen"
canseein(scene) = [Bool(CanSee.cansee(scene, scene.geoms[i])) for i = 1:length(scene.geoms)]
canseein(scene_sample2)

# ### 2. Actual Causality

# Is fact that object a is where it is,  reason we can't see object b?
objacenter = constant(k.center)
obja = ciid(ω -> RayTrace.MaterialGeom(Sphere(objacenter(ω), k.r), k.material))

sc = ciid(ω -> RayTrace.ListScene([[g for (i, g) in enumerate(scene_sample2.geoms) if i != gid] ; obja(ω)] ))
cantseeb = ciid(ω -> !CanSee.cansee(sc(ω), objb))

# Check is fact that in some world ω, is fact that obja where it is cause that we can't see object b
ω = defΩ()()

# Now we will check for but-for cause.
# This is defined in our extension of Omega [here](https://github.com/uaianonsubmit/causalsource/blob/master/Omega.jl/src/causal/causes.jl)

# CanSee.iscausebf(ω, objacenter ==ₛ objacenter(ω), cantseeb, [objacenter];
#                  sizes = [3],
#                  proj = v -> Point(v[1], v[2], v[3]), init = () -> [k.center.data...])
end