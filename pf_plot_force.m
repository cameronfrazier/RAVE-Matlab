function [ points ] = pf_plot_force( pose, force, shift, format )

    x = force(1)/ 10;
    y = force(2)/ 10;

    t = pose(6);
    r = [cos(t) -sin(t); sin(t) cos(t)];
    
    T = -atan2( y, x );
    R = [cos(T) -sin(T); sin(T) cos(T)];
    m = norm([x y]);
    
    
    
    points = [  0       0 ;
                m       0 ;
                m-0.1  -0.1;
                m-0.1   0.1 ;
                m       0 ; ] * R * r;
            
    points = [ points(:,1)+pose(1)+shift(1) , points(:,2)+pose(2)+shift(2) ];
    
    plot( points(:,1), points(:,2), format); 
end