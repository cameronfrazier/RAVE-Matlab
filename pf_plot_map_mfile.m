function pf_plot_map_mfile( ap )
%PF_PLOT_MAP Summary of this function goes here
%   Detailed explanation goes here

    % Plot all the map objects
    for o = ap.map.objects
        format = 'k-';
        if o.type == 1      % circle
            t = linspace(-pi,pi,100*o.size)';
            points = [cos(t) sin(t)]*o.size + ones(length(t),1)*o.center;
        elseif o.type == 2  % rectangle
            points = [o.points; o.points(1,:)];
        elseif o.type == 3  % line
            points = o.points;
        elseif o.type == 4  % points
            points = o.points;
            format = '*';
        end
        
        plot( points(:,1), points(:,2), format );
    end    
    
    % plot waypoints
    for w = ap.waypoints'
        pf_plot_point( w', 'co' );
    end
    
    % Plot start and end points
    pf_plot_point( ap.map.start, 'go');
    pf_plot_point( ap.map.target, 'ro'); 
end

