function pf_plot( ap, scan, pose, force, moment, forces, moments )
%PF_PLOT Summary of this function goes here
%   Detailed explanation goes here

    pf_plot_scan_area( ap, pose );
    hold on;
    pf_plot_map_mfile( ap );   
    
    
    pf_plot_rover( ap, pose);
    
    scan = scan(scan(:,2)<=ap.laser.angle_max,:);
    scan = scan(scan(:,2)>=ap.laser.angle_min,:);
    pf_plot_scan( scan, pose );
    
    % plot net force
    pf_plot_force( pose, force, [0 0], 'k' );
    
        
    % plot forces
    colour = ['r', 'g', 'b', 'y', 'k'];
    for i = 1:length(forces(1,:))
        pf_plot_force( pose, forces(:,i), [0 0], colour(i) );
    end

    axis([ [ -5 5 ]+ pose(1), [ -5 5 ] +  pose(2) ]);
%     axis([ -10 10 -10 10 ]);

    axis square;
    
    hold off
    
end