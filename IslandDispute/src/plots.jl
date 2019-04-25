"Get State Rewards as a Matrix"
function rewardmat(sgw)
  mat = Array{Float64}(undef, sgw.size...)
  for s  in POMDPs.states(sgw)
    x, y = s
    mat[x, y] = POMDPs.reward(sgw, s)
  end
  mat
end

function normat(x)
  mx = maximum(x)
  mn = minimum(x)
  (x .- mn) ./ (mx - mn)
end


function plotbeliefs(samples)
  xs = ntranspose(samples)
  StatsPlots.density(xs)
end

destructure(samples, i) = map(x->x[i, :], samples)

function plotmigration(amap, save = true)
  plt = Plots.heatmap(["S", "N", "E", "B", "W"], ["S", "N", "E"], amap,
                aspect_ratio = 1, label = false,
                colorbar = false, color = :grays,
                tickfontsize = 32)
end

function plotfinallevels(amap, save = true)
  plt = Plots.heatmap(amap',
                aspect_ratio = 1, label = false,
                colorbar = false, color = :grays,
                tickfontsize = 32)
end


function makeheatmap(allstates)
  mat = zeros(7,6)
  for (x,y) in allstates
    mat[x,y] += 1
  end
  mat
end

function makeplots(; n = 4, path)
  for i = 1:n
    (m, allseqs, allstates) = runmodel()
    plt = plotmigration(m)
    Plots.savefig(plt, joinpath(path, "prior$i.pdf"))

    plt2 = plotfinallevels(makeheatmap(allstates))
    Plots.savefig(plt2, joinpath(path, "priorfinal$i.pdf"))
  end
  for i = 1:n
    (m, allseqs, allstates) = runmodel(; usereplmap = true, replmap =  Dict(addwall => true))
    plt = plotmigration(m)
    Plots.savefig(plt, joinpath(path, "withwall$i.pdf"))

    plt2 = plotfinallevels(makeheatmap(allstates))
    Plots.savefig(plt2, joinpath(path, "withwallfinal$i.pdf"))
  end
  for i = 1:n
    (m, allseqs, allstates) =  runmodel(; usereplmap = true, replmap = Dict(addwall => true, 
                                      terraincostsmatrv => constant(terraincostsmat2)))

    plt = plotmigration(m)
    Plots.savefig(plt, joinpath(path, "cf$i.pdf"))

    plt2 = plotfinallevels(makeheatmap(allstates))
    Plots.savefig(plt2, joinpath(path, "cffinal$i.pdf"))
  end
end