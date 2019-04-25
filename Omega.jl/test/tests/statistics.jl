using Omega

function test()
  θ = uniform(-1, 1)
  x = normal(θ, 1)
  samplemeanᵣ(x ∥ θ) > 0.5
end

# function samplemean(ω, x, n)
#   ω1 = ω[@uid]
#   x_ = x(ω1)
#   for i = 1:n-1
#     x_ += x(ω[@uid, i])
#   end
#   x_ / n
# end

# What do you want?
# 

# Track or no track?
# If we don't track, we might not know the error associated with the expectation
# That is, if x is conditoned, then in a sense the function is wrong
# Is this the same kind of error as conditioning?
# In a sense,
# OTOH if i want to accumulate error 