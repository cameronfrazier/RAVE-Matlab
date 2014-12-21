function [ map ] = pf_map_trees( varargin )
%PF_MAP_SMALL_DOTS Generate map of random "trees"
%   Detailed explanation goes here

    if length(varargin) == 2
        s_shift = varargin(1);
        t_shift = varargin(2);
    else
        s_shift = [ 0 0 0 ];
        t_shift = [ 0 0 0 ];
    end
   
    map.scale       = 1;
    map.size        = [ 50 50 0 ] * map.scale;
    map.start       = [  1  1 0 ] * map.scale; % need [ x y z ]
    map.target      = [ 49 49 0 ] * map.scale; % need [ x y z ]
    map.start       = map.start + s_shift;
    map.target      = map.target + t_shift;
    map.has_border  = false; % not implemented yet
    map.objects     = [];
    

    r_min = 0.1; % minimum obstacle radius
    
    r = @(n,scale) (scale*rand() + (1-scale)/2 )*map.size(n);
    obsCnt = 0;
    while obsCnt < 100
        scale = 0.9; % random obstacle area and size scaling
        x = r( 1, scale );
        y = r( 2, scale );
        radius = (scale^2)*abs(randn());
        n           = pf_map_shape_circle( radius, [x y], map.scale);
        r_start     = pf_get_range([n.center 0], map.start);
        r_target    = pf_get_range([n.center 0], map.target);
        
        % Ensure a buffer around start and end points
        % skip this circle if it is too close to the buffer
        if ( r_start - n.size ) < 1.5 || ( r_target - n.size ) < 1.5 
            continue;
        elseif (x+radius) > -(map.size - 2*map.target)
            continue;
        elseif (x-radius) < 2*map.start
            continue;
        else
            % Skip if this circle is too small
            if n.size < r_min
                continue;
            else
                obsCnt = obsCnt+1;
                map.objects = [ map.objects, n ];
            end
        end 
    end
%     if map.has_border
%         map.objects(end+1) = pf_map_shape_rectangle( [0.9, 1.0] , [0.5, 0.5], pi, map.scale );
%     end
end

