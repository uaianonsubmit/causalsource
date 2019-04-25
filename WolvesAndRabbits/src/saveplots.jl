"Make and save all plots"
function makeplots(; save = true, fname = joinpath(PLOTSPATH, "allfigs.pdf"))
  @show fname
  @show @__DIR__
  plts_ea = plot_effect_action()
  # plts = [sample() for i = 1:6]
  plt = plot(plts_ea..., plot_inc_pred()..., plot_treatment_action(), plot_treatment(),
             layout = (3,2),
             legend = false)
  display(plt)
  save && savefig(plt, fname)
end

# end