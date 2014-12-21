function [ points ] = pf_plot_moment( pose, moment )

    m = abs(moment(3));
    s = sign(moment(3));

    t = pose(6);
    r = [cos(t) -sin(t); sin(t) cos(t)];
    
    T = moment(3);
    R = [cos(T) -sin(T); sin(T) cos(T)];
    
    points = linspace(-m, 0)';
    
    points = [ cos(points) sin(points) ];
    
    points = [  points       ;
                1.1     -0.1 ;
                0.9     -0.1 ;
                1        0   ; ] * [1 0; 0 s];
            
    points = points * R * r ;
            
    points = [ points(:,1)+pose(1) , points(:,2)+pose(2) ];
    
end