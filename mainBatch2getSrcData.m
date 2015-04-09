function [BPs, PWFs] = mainBatch2getSrcData(paths,needPlot,selectedPWFNames)
        BPs = [];
        PWFs = [];
        for i=1:length(paths)
             [bps,pwfs] = mainFunc2(paths{i},needPlot,selectedPWFNames);
            if isempty(BPs)
                 BPs = bps;
            else
                 BPs = [BPs bps];
            end
            if isempty(PWFs)
                PWFs=pwfs;
            else
                PWFs=[PWFs,pwfs];
            end
        end
end