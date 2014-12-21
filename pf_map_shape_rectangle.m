function [ r ] = pf_map_shape_rectangle( size, center, rotation, scale )
%PF_MAP_SHAPE_RECTANGLE Summary of this funcetion goes here
%   Detailed explanation goes here
    
%     R   = @(t) [cos(t) -sin(t); sin(t) cos(t)];
    
    r = pf_map_shape_poly(size, 4, center, rotation, scale);

%     r.type      = 2;
%     r.size      = size*scale;
%     r.center    = center*scale;
%     r.rotation  = rotation;
% 
%     rect        = [1;-1;-1;1]*(r.size/2)*[1 0;0 -1];
%     rect(2,1)   = -rect(2,1);
%     rect(4,1)   = -rect(4,1);
% 
%     r.zpoints   = rect * R(r.rotation);
%     r.points    = r.zpoints + ones(4,1)*r.center;
% 
%     r.bb_max    = max(r.points,[],1);
%     r.bb_min    = min(r.points,[],1);
% 
%     r.cdist     = 0;
%     r.cdelta    = 0;
%     r.cangle    = 0;
%     r.scan_max  = 0;
%     r.scan_min  = 0;
end

