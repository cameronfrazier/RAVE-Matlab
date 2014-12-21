function [ l ] = pf_map_shape_line_pt( pt_start, pt_end, scale )
%PF_MAP_SHAPE_LINE Summary of this function goes here
%   Detailed explanation goes here

    length      = pf_get_range(pt_start, pt_end);

    l.type      = 3;
    l.size      = length*scale;
    l.center    = (pt_start + pt_end)*0.5*scale;
    l.rotation  = 0;
    l.zpoints   = [ pt_start; pt_end];
    l.points    = l.zpoints * scale; 

    l.bb_max    = max(l.points, [], 1);
    l.bb_min    = min(l.points, [], 1); 

    l.cdist     = 0;   
    l.cdelta    = 0;
    l.cangle    = 0;
    l.scan_max  = 0;
    l.scan_min  = 0;
end

