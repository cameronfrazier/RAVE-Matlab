function [ p ] = pf_map_shape_point( center, scale )
%PF_MAP_SHAPE_POINT Summary of this function goes here
%   Detailed explanation goes here

    p.type      = 4;
    p.size      = 0;
    p.center    = center*scale;
    p.rotation  = 0;
    p.zpoints   = p.center;
    p.points    = p.center;
    p.bb_max    = p.center;
    p.bb_min    = p.center;
        
    p.cdist     = 0;
    p.cdelta    = 0;
    p.cangle    = 0;
    p.scan_max  = 0;
    p.scan_min  = 0;
end

