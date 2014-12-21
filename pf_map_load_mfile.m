function [ map ] = pf_map_load_mfile( ap )
%PF_LOAD_IMAGE Load map
%   Load a map function and return map structure object
%
%       filename    : [string]  Filename of map function
%
%       map         : [ struct ]  Structure containing map data 

    filename = ap.map_filename;
    
    %% set up the RNG
    
    % Store RNG
    rngSettings = rng;

    if ap.use_seed
        if ap.seed == -1
%             fprintf('Randomizing map RNG... seed: ');
            rngen = rng('shuffle');
%             fprintf('%i\n', rngen.Seed);
        else
            rng(ap.seed);
%             fprintf('Using supplied map RNG seed: %i\n', ap.seed);
        end
    else
%         fprintf('Not altering map RNG seed settings\n');
    end
    
    %% Load Map
    map = eval(filename);
    
    % restore RNG
    rng(rngSettings);
    
    map.start = map.start + ap.start;
    map.target = map.target + ap.target;

end

