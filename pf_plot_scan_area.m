function pf_plot_scan_area( ap, pose )

    t = pose(6);
    r = [cos(t) -sin(t); sin(t) cos(t)];
    
    a_min = ap.laser.angle_min;
    a_max = ap.laser.angle_max;
    
    R = ap.scan_range;    
    T = linspace( a_min, a_max )';
    
    points = [ 0 0 ; R*cos(T) R*sin(T)] * r;
    points = [ points(:,1)+pose(1) , points(:,2)+pose(2) ];
    
    fill(   points(:,1), points(:,2), [0.8, 0.8, 0.8]);
end