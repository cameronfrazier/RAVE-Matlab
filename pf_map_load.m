function [ map ] = pf_map_load( ap )
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

end

