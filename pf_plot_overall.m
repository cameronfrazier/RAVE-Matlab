function pf_plot_overall( ap, results )

    hold on
    
    % plot the map
    pf_plot_map_mfile( ap );

    if ~isempty(results)
        result_size = length(results);
        r = reshape([results.pose], 6, result_size)';
        r = r(:,1:2);
        
        plot(r(:,1), r(:,2), 'b');
    end
    
    % shape axes
    axis([-2.5 2.5 -2.5 2.5] + [ 0 ap.map.size(1) 0 ap.map.size(2) ]);
    axis square;

%     fmt_title = '%-6s Cost ( %6.3f )';
%     legend_string = sprintf(fmt_title, 'Total', cost);    
%     legend(legend_string, 'Location','NorthWest');
%     text(0,0, sprintf(fmt_title, 'Total', cost));
    hold off
end