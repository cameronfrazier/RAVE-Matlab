function [ force, moment ] = pf_get_forces_dmp( ap, state, pose )
%PF_GET_FORCES_DMP Summary of this function goes here
%   Detailed explanation goes here
    
    if ~ap.dmp_use
        force = [0 0 0]';
        moment = [0 0 0]';
        return;
    end

    t = -pose(6);
    v = state(1);
    w = state(2);

    
    force   = -ap.gain_damping_lin * v * [ 1; 0; 0 ];%[ cos( t ); sin( t ); 0 ] ;
    moment  = -ap.gain_damping_ang * w * [ 0; 0; 1 ];
end

