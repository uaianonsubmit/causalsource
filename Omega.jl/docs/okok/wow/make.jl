using Documenter
using Omega

makedocs(
    sitename = "Omega",
    format = :html,
    modules = [Omega]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
