function [ force, moment, forces, moments, forceObj, momentObj ] = pf_get_forces( ap, state, scan, pose )
%PF_GET_FORCES Calculate various forces
%   Detailed explanation goes here
    
    [ ~, ~, ~, forceObj, momentObj] = pf_result_object();

    % Only need to calculate these once
    ap.distance_critical        = pf_get_dist_critical( ap );
    
    %% Attractor forces
    [ force_att, moment_att ]    = pf_get_forces_att( ap, pose );
    forceObj.att = force_att;
    momentObj.att = moment_att;
    

    %% Obstacle and Tangent forces
    if ap.method.corner_points
        shift   = ap.rover.corner_points;
    else
        shift   = [ 0 0 0 ];    % Using any bounding shape method
    end
    [ force_obs, moment_obs ]    = pf_get_forces_obs( ap, scan, shift );
    forceObj.corners = force_obs;
    forceObj.obs = sum(force_obs,1);
    momentObj.corners = moment_obs;
    momentObj.obs = sum(moment_obs,1);

    %% Risk Forces
    [ force_rsk, moment_rsk ]   = pf_get_forces_rsk( ap, force_obs, moment_obs );
    forceObj.tan = force_rsk;
    momentObj.tan = moment_rsk;
    
    %% Tangent Forces
    [ force_tan, moment_tan ]    = pf_get_forces_tan( ap, state, force_obs, force_att, pose );
    forceObj.tan = force_tan;
    momentObj.tan = moment_tan;
    
    %% Damping Forces
    [ force_dmp, moment_dmp ]    = pf_get_forces_dmp( ap, state, pose );
    forceObj.dmp = force_dmp;
    momentObj.dmp = moment_dmp;
    
    %% Summate all forces and moments
    
    forces  =   [ ...
                force_obs, ...
                force_tan, ...
                force_att, ...
                force_dmp, ...
                force_rsk, ...
                ];
            
    moments =   [ ...
                moment_obs, ...
                moment_tan, ...
                moment_att, ...
                moment_dmp, ...
                moment_rsk, ...
                ];
    
    force       = sum( forces, 2 );
    moment      = sum( moments, 2 );
    
%     disp([force moment]);

end