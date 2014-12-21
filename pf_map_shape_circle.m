function [ c ] = pf_map_shape_circle( radius, center, scale )
%PF_MAP_SHAPE_CIRCLE Summary of this function goes here
%   Detailed explanation goes here

    if radius == 0
        c = pf_map_shape_point( center, scale );
    else
        c.type      = 1;
        c.size      = radius*scale;
        c.center    = center*scale;
        c.rotation  = 0;
        c.zpoints   = c.center;
        c.points    = c.center;
        c.bb_max    = c.center + c.size;
        c.bb_min    = c.center - c.size;
        
        c.cdist     = 0;
        c.cdelta    = 0;
        c.cangle    = 0;
        c.scan_max  = 0;
        c.scan_min  = 0;
    end
end

