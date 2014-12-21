function [ force, moment ] = pf_get_forces_rsk( ap, force_obs, moment_obs )
%PF_GET_FORCES_RSK Summary of this function goes here
%   Detailed explanation goes here
   
    if ~ap.rsk_use
        force = [0 0 0]';
        moment = [0 0 0]';
        return;
    end

    force   = -ap.gain_risk * ap.epsilon * force_obs;
    moment  = -ap.gain_risk * ap.epsilon * moment_obs;
end

