function [ objects ] = pf_map_get_objects( ap, map )
%PF_MAP_GET_OBJECTS Return point struct of map object points

    cnt_obj     = length(map.objects);

    
    
    for o = 1:cnt_obj
        if o.type == 1      % circle
            obj
        elseif o.type == 2  % rectangle
        elseif o.type == 3  % line
        elseif o.type == 4  % points
        end
    end
    
end

