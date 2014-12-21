function [ ap ] = pf_setup_calc( ap )
%PF_SETUP_CALC Summary of this function goes here
%   Detailed explanation goes here


%     ap.gain_damping_lin     = 2;
%    gain_damping_lin = ap.rover.vel_max * ap.rover.mass / ap.dmp_dist_stop;
%    ap.gain_damping_lin = gain_damping_lin;
    
%     ap.gain_damping_ang     = 2.5;
%    gain_damping_ang = ap.rover.vel_max * ap.rover.I / ap.dmp_ang_stop;
%    ap.gain_damping_ang     = gain_damping_ang;
    
%     ap.gain_attractor       = 4;
%     gain_attractor = ap.gain_damping_lin * ap.rover.vel_max;
%    gain_attractor = ap.rover.accel_max * ap.rover.mass;
%    ap.gain_attractor       = gain_attractor;
    
%     ap.obs_strength         = 1;
%    obs_strength = ap.gain_attractor * ap.obs_wall / ( pi * ( 1 - ap.gain_risk) );
%    ap.obs_strength         = obs_strength;

    ap.tan_vel_decay        = exp( -0.1 * ap.rover.vel_max );
    ap.tan_eta_tol          = cos(ap.tan_eta_tol*pi/180);
end

