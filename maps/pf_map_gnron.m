function [ map ] = pf_map_gnron( varargin )
%PF_MAP_SMALL_DOTS Summary of this function goes here
%   Detailed explanation goes here

    if length(varargin) == 2
        s_shift = varargin(1);
        t_shift = varargin(2);
    else
        s_shift = [ 0 0 0 ];
        t_shift = [ 0 0 0 ];
    end
        

    map.start       = [  8  1 0 ]; % need [ x y z ]
    map.target      = [ 10 10 0 ]; % need [ x y z ]
    map.start       = map.start + s_shift;
    map.target      = map.target + t_shift;
    map.has_border  = false; % not implemented yet
    map.scale       = 1;
    map.size        = [ 20 20 ] * map.scale;
    map.objects     =   [pf_map_shape_circle( 1, [10 11], map.scale)  ];
%     if map.has_border
%         map.objects(end+1) = pf_map_shape_rectangle( [0.9, 1.0] , [0.5, 0.5], pi, map.scale );
%     end
end

