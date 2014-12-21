function pf_plot_final_costs( res )
%PF_PLOT_FINAL_COSTS Summary of this function goes here
%   Detailed explanation goes here


    cost    = [res.cost];
    
    total   = [cost.total];
    angle   = [cost.angle];
    length  = [cost.length];
    time   = [cost.time];
    range   = [cost.range];
    
    s   = 4;
    e   = size(res,2);
    figure(80)
    plot(s:e, [length(s:e)' time(s:e)' range(s:e)' angle(s:e)']);
    legend('length','time', 'range', 'angle');
end

