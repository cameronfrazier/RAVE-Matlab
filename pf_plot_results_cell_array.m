function intSuccess = pf_plot_results_cell_array(results_set)
%PF_PLOT_RESULTS Animated plot of results from simulation
%   Plot the results of a single or multipel simulation analysis

close all

if nargin >= 1
    set_size = length(results_set);
end


close all;

% only plot selected 

figure('visible','off');
hold on;

intSuccess = 0;

for i=1:set_size
    res_set = cell2mat(results_set{i}(1));
    ap_set = cell2mat(results_set{i}(2));
    if ~isstruct(res_set)
        continue
    end
    
    ff = [res_set(end).flags];
    intSuccess = intSuccess + ff.hasSuccess;
    
    pose = reshape([res_set.pose], 6, length(res_set))';
    
    pf_plot_map_mfile(ap_set);
    plot (pose(:,1), pose(:,2));
end

pf_plot_rover(ap_set, pose(end,:)');

axis auto
axis([-2 22 -2 22])

end

