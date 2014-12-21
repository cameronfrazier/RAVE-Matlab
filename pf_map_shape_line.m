function [ l ] = pf_map_shape_line( length, center, rotation, scale )
%PF_MAP_SHAPE_LINE Summary of this function goes here
%   Detailed explanation goes here

    R   = @(t) [cos(t) -sin(t); sin(t) cos(t)];
    
    if length == 0
        l = pf_map_shape_point( center, scale );
    else
        l.type      = 3;
        l.size      = 0.5*length*scale; % Half length (radius of circle)
        l.center    = abs(center*scale);
        l.rotation  = rotation;
        l.zpoints   = ( [ -1 0; 1 0]*l.size ) * R(l.rotation);
        l.points    = abs(l.zpoints + [ 1; 1 ]*[ l.center ]); 
                
        l.bb_max    = max(l.points, [], 1);
        l.bb_min    = min(l.points, [], 1); 
        
    	l.cdist     = 0;   
        l.cdelta    = 0;
        l.cangle    = 0;
        l.scan_max  = 0;
        l.scan_min  = 0;
    end
end

