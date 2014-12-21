function [ map ] = pf_map_hallway_wide( varargin )
%PF_MAP_SMALL_DOTS Summary of this function goes here
%   Detailed explanation goes here

    if length(varargin) == 2
        s_shift = varargin(1);
        t_shift = varargin(2);
    else
        s_shift = [ 0 0 0 ];
        t_shift = [ 0 0 0 ];
    end
    
    % map dimensions
    W = 20;
    H = 20;
    
    hall_width = 10;
    hall_length = H-10;
    leadin_length = (W/2)-(hall_width/2);
    
    map.start       = [ 10  1 0 ]; % need [ x y z ]
    map.target      = [ 10 19 0 ]; % need [ x y z ]
    map.start       = map.start + s_shift;
    map.target      = map.target + t_shift;
    map.has_border  = false; % not implemented yet
    map.scale       = 1;
    map.size        = [ W H ] * map.scale;
    map.objects     =   [  ...
                        ... % Hall Walls
                        pf_map_shape_line( hall_length,   [(W/2)-(hall_width/2) (H/2)],    -pi/2,   map.scale), ...
                        pf_map_shape_line( hall_length,   [(W/2)+(hall_width/2) (H/2)],    pi/2,   map.scale), ...
                        ... % Lead In Walls
                        pf_map_shape_line( leadin_length,   [(W/2)-(leadin_length+hall_width)/2 (H/2)-(hall_length/2)],    0,   map.scale), ...
                        pf_map_shape_line( leadin_length,   [(W/2)+(leadin_length+hall_width)/2 (H/2)-(hall_length/2)],    0,   map.scale), ...
                        ];
%     if map.has_border
%         map.objects(end+1) = pf_map_shape_rectangle( [0.9, 1.0] , [0.5, 0.5], pi, map.scale );
%     end
end

