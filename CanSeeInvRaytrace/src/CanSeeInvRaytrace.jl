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

# using JLD2
# const DATADIR = ENV["DATADIR"]
# @load "theres.jld2"

"Generate 500 samples using inverse graphics"
generatedata() = InvRayTrace.sampleposterior_noi(500; noi = false, alg = SSMH, gamma = 100.0)

"High resolution render of scene"
highresrender(sc) = RayTrace.rgb.(RayTrace.render(sc; width = 1024, height = 1024))

# ### Actual Causation
# In this example we use counterfactuals to determine whether a is the cause of b.
# In particular, to determine whether the position of some object a is the cause of us not being able to see object b
# We will solve two problems
# 1. Inverse Graphics, figure out what hte 3d scene is that created a 2d image
# 2. The actual causation question described above

# In principle we could do these simultaneously as one big inference query but to save computation time here we will solve the 1 first and use that data data in the second

# ### 1. Inverse Graphics

# Sample from the posterior of scenes
samples = generatedata()

# Visualize a single sample from the posterior
ls = samples[end]
ImageView.imshow(highresrender(ls))

# From a copy of the scene take a single object, Remove object with id gid from scene
ls2 = deepcopy(ls)
gid = 1
ls3 = RayTrace.ListScene([g for (i, g) in enumerate(ls2.geoms) if i!=gid])

k = ls.geoms[gid]

# We will add a white ball into the scene inside of k 

# Define the material colour white
white = RayTrace.Material(Vec3(1.0, 1.0, 0.0), 0.5, 0.0, Vec3(0.0, 0.0, 0.0))

# Create a new white sphere `mg` at position of `k` but a fraction `frac` of the size
frac = 0.8
mg = RayTrace.MaterialGeom(Sphere(k.center, k.r*frac), white)

# Add the new sphere to the scene
push!(ls2.geoms, mg)

"For each element in scene determine if it can be seen"
canseein(scene) = [Bool(CanSee.cansee(scene, scene.geoms[i])) for i = 1:length(scene.geoms)]

canseein(ls2)

# ### 2. Actual Causality

# Is fact that object a is where it is,  reason we can't see object b?
objacenter = constant(k.center)
obja = ciid(ω -> RayTrace.MaterialGeom(Sphere(objacenter(ω), k.r), k.material))
objb = mg

sc = ciid(ω -> RayTrace.ListScene([[g for (i, g) in enumerate(ls2.geoms) if i != gid] ; obja(ω)] ))
cantseeb = ciid(ω -> !CanSee.cansee(sc(ω), objb))

# Check is fact that in some world ω, is fact that obja where it is cause that we can't see object b
ω = defΩ()()
# CanSee.iscausebf(ω, objacenter ==ₛ objacenter(ω), cantseeb, [objacenter];
#                  sizes = [3],
#                  proj = v -> Point(v[1], v[2], v[3]), init = () -> [k.center.data...])