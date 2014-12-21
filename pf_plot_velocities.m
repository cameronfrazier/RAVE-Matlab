function pf_plot_velocities( history )
%PF_PLOT_VELOCITIES Summary of this function goes here
%   Detailed explanation goes here
    ap          = history.ap;
    res         = history.res;
    velocity    = [res.velocity];
    pose        = reshape([res.pose],6,length(res));
    
    VX = velocity(1,:);
    WZ = velocity(2,:);
    X  = pose(1,:);
    
    s   = 1;
    e   = size(res,2);
    figure(95)
%     plot([s:e]/10, [VX; WZ]' );
    plot(X', VX' );
%     plot(X', [VX; WZ]' );
%     legend('Forward Velocity, v_x');
    title('Velocities');
    xlabel('timestep, x [m]')
    ylabel('velocity, v_x [m/s]')
    axis([-2.5 2.5 0 .1] + [ 0 ap.map.size(1) 0 ap.rover.vel_max ]);

end

