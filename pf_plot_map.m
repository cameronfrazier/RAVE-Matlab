function [ points ] = pf_plot_map( ap, map )
%PF_PLOT_MAP Summary of this function goes here
%   Detailed explanation goes here

    [ lim_y lim_x ] = size( map );
    
    points = zeros(sum(sum(randi(2,5)-1)), 2);
    
    cnt_pts = 0;
    for i = 1:lim_x     % cols
        for j = 1:lim_y % rows
            if map(j,i)
                cnt_pts = cnt_pts + 1;
                points(cnt_pts,:) = [i j];
            end
        end
    end
    
    % Convert to meters
    points = points * ap.sim.map_scale;
end

