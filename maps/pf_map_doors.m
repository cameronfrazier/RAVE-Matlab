function [ map ] = pf_map_doors( varargin )
%PF_MAP_SMALL_DOTS Summary of this function goes here
%   Detailed explanation goes here

    if length(varargin) == 2
        s_shift = varargin(1);
        t_shift = varargin(2);
    else
        s_shift = [ 0 0 0 ];
        t_shift = [ 0 0 0 ];
    end
        

    map.start       = [  1  1 0 ]; % need [ x y z ]
    map.target      = [ 19 19 0 ]; % need [ x y z ]
    map.start       = map.start + s_shift;
    map.target      = map.target + t_shift;
    map.has_border  = false; % not implemented yet
    map.scale       = 1;
    map.size        = [ 20 20 ] * map.scale;
    map.objects     = [ ...
                        pf_map_shape_line( (50^0.5 - 1.5),  [ 5.25 10.75],    pi/4,  map.scale), ...
                        pf_map_shape_line( (50^0.5 - 1.5),  [10.75  5.25],    pi/4,  map.scale), ...
                        pf_map_shape_line( (50^0.5 - 1.0),  [ 8.25 13.75],    pi/4,  map.scale), ...
                        pf_map_shape_line( (50^0.5 - 1.0),  [13.75  8.25],    pi/4,  map.scale), ...
                        pf_map_shape_line( (50^0.5 - 0.5),  [11.25 16.75],    pi/4,  map.scale), ...
                        pf_map_shape_line( (50^0.5 - 0.5),  [16.75 11.25],    pi/4,  map.scale), ...
                      ];
end

