function [ map ] = pf_map_load_qt( ap )
%PF_LOAD_IMAGE Load map image
%   Load a map image and return grid map
%
%       filename    : [string]  Filename of map image
%                               Images should be black/white (indexed or 1-bit)
%
%       map         : [ NxM ]   Array of pixals defining map 

    filename = ap.sim.map_filename;

    [ ~, ~, ext ] = fileparts( filename );

    map = not( imread( filename, ext(2:end) ) );
    
    [rows cols] = size(map);
    
    % padding to bring things up to 2^n for quadtree map
    px = 2^ceil(log2(sx));
    py = 2^ceil(log2(sx));
    
    qt = QuadTreeNode(NaN, maxDepth-1, [py px], [py px]/2);
    for iy = 1:rows
        if ~isempty(map(iy,:))
            for ix = ix:cols
                if map(iy,ix)
                    map.AddObstacle( [ix iy] );
                end
            end
        end
    end

    map = qt;
end

