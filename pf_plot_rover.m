function pf_plot_rover( ap, pose )
%PF_PLOT_MAP Summary of this function goes here
%   Detailed explanation goes here

    t = pose(6);
    R = [cos(t) -sin(t); sin(t) cos(t)];

    cpoints = ap.rover.corner_points(:,1:2);
    points = [cpoints; cpoints(1,:); 0 0; 2 0 ];
    points = points * R;
    points = points + ones(length(points(:,1)),1)*pose(1:2)';
   
    
    for i = 1:length(cpoints)
        THETA=linspace(0,2*pi,16);
        RHO=ones(1,16)*ap.obs_dist_buf;
        [X,Y] = pol2cart(THETA,RHO);
        X=X + points(i,1);
        Y=Y + points(i,2);
        fill(X,Y,'r');
    end
    
    plot( points(:,1), points(:,2), 'k-*'); 
end

