function figures = recordFeatureIfNeeded(figs, fig, ifNeeded)
    if ifNeeded
        figures = [figs; fig];
    else
        figures = figs;
    end
end