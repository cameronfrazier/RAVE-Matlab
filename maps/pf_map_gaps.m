function [ map ] = pf_map_gaps( varargin )
%PF_MAP_SMALL_DOTS Summary of this function goes here
%   Detailed explanation goes here

    if length(varargin) == 2
        s_shift = varargin(1);
        t_shift = varargin(2);
    else
        s_shift = [ 0 0 0 ];
        t_shift = [ 0 0 0 ];
    end
        

    map.start       = [  0  10 0 ]; % need [ x y z ]
    map.target      = [ 20 10 0 ]; % need [ x y z ]
    map.start       = map.start + s_shift;
    map.target      = map.target + t_shift;
    map.has_border  = false; % not implemented yet
    map.scale       = 1;
    map.size        = [ 20 20 ] * map.scale;
    
%     doors=[ 2.25 2.0 1.75 1.5, 1.25 ];
    doors=[ 2.25 2.0 1.75 1.5 ];
    
    map.objects = [];
    
%     for idx = 1:length(doors)
%         top = pf_map_shape_line( (20 - doors(idx))/2,    [(18/(length(doors)+1))*idx  20-(20 - doors(idx))/4],    pi/2,  map.scale);
%         bot = pf_map_shape_line( (20 - doors(idx))/2,    [(18/(length(doors)+1))*idx     (20 - doors(idx))/4],    pi/2,  map.scale);
%         map.objects = [ map.objects, top, bot ];
%     end

    for idx = 1:length(doors)
        top = pf_map_shape_circle( 1, [(18/(length(doors)+1))*idx,  10+(doors(idx)/2+1)], map.scale);
        bot = pf_map_shape_circle( 1, [(18/(length(doors)+1))*idx,  10-(doors(idx)/2+1)], map.scale);
        map.objects = [ map.objects, top, bot ];
    end

end

