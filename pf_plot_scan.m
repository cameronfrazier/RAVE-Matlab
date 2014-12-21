function pf_plot_scan( scan, pose )
%PF_PLOT_MAP Summary of this function goes here
%   Detailed explanation goes here
   


    r = scan(:,1);
    t = scan(:,2);
    
    T = pose(6);
    R = [cos(T) -sin(T); sin(T) cos(T)];
    
    points = [r.*cos(t), r.*sin(t)] * R;
    points = [points(:,1) + pose(1), points(:,2) + pose(2)];
    
    
    plot( points(:,1), points(:,2), '.r' );
end

