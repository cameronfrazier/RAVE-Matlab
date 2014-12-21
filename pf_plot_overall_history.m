function pf_plot_overall_history( history )

    hold on
    

    for h = history
        % plot the map
        pf_plot_map_mfile( h.ap );
        
        result_size = length(h.res);
        r = reshape([h.res.pose], 6, result_size)';
        r = r(:,1:2);
        v = [h.res.velocity]';
        for idx = 1:result_size-1
            red = [0 1 0] * (abs(v(idx,1))/0.5);
            grn = [1 0 0] * (1 - abs(v(idx,1))/0.5);
            plot(r(idx:idx+1,1), r(idx:idx+1,2) ...
                , 'Color', red+grn ...
                ... % , 'LineWidth', 10*2*abs(v(idx,1)) ...
                 );
        end
    end

    % shape axes
    axis([-2.5 2.5 -2.5 2.5] + [ 0 history(1).ap.map.size(1) 0 history(1).ap.map.size(2) ]);
    axis square;
    
    hold off
end