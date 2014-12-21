function [ force, moment ] = pf_get_forces_tan( ap, state, force_obs, force_att, pose )
%PF_GET_FORCES_TAN Calculate tangent forces generated
%   Calculate tangent forces generated
%

    if ~ap.tan_use
        force = [0 0 0]';
        moment = [0 0 0]';
        return;
    end
        
    moment = [ 0 0 0 ]';

   % internal variables
    A   = [ 0 -1  0; 
            1  0  0; 
            0  0  0 ];
    
    % Calculate net forces
    force_tan   = ap.gain_tangent * A * force_obs;
    
    % Attractive Force Locality factor
    %   Logistic function to reduce the effect of the tangential force as
    %   the target approaches, helping in GNRON conditions
    norm_att = ( norm( ap.current_target - pose(1:3)') ) / ap.rover.length; % distance to target in units of rover length
    factor_att = max(0,2./(1+exp(-((norm_att-ap.rover.length)^3)))-1);
    
    norm_vel = state(1) / ap.rover.vel_max^2;
    factor_vel = max(0,max(0,2./(1+exp(-(norm_vel^3)))-1));
    
%     disp([factor_att factor_vel]);
    
    % precalc some values
    sign_vel    = sign( state(1) );
    unit_x      = [ 1; 0; 0 ];
    unit_obs    = force_obs / norm( force_obs );
    unit_tan    = force_tan / norm( force_tan );
    unit_att    = force_att / norm( force_att );
    
    % Heading direction parameter
    eta = -dot( unit_x, unit_obs );

    % Tangent force bias direction parameter;
    lambda = sign_vel * dot( unit_x, unit_tan ) * dot( unit_x, unit_att );
    
    % Tangent force bias direction sign parameter
    if eta <= ap.tan_eta_tol && ...
        abs( state(1) ) < ap.tan_vel_tol && ...
        factor_att > 0.5 
    
        Gamma = sign(2*rand() - 1); % random Gamma
        
%         Verbose(ap,'Random tan_dir [%i]\n', Gamma);
        
    else
        Gamma = sign(lambda);
%     elseif ap.tan_gamma_cnt < 15 && ap.tan_gamma_cnt > 0
%         Gamma = ap.tan_dir;
%         ap.tan_gamma_cnt = ap.tan_gamma_cnt + 1;
%     elseif ap.tan_gamma_cnt == 15
%         % reset counter
%         ap.tan_gamma_cnt = 0;
    end
    
    % calculate forces
    if ~norm(force_obs)
        force = [0 0 0]';
    else
%         force = 4 * ap.epsilon * Gamma * force_tan * factor_att;
        force = ap.epsilon * Gamma * force_tan * factor_att;
    end
    
    moment(3)   = ap.rover.half_length*force(2); %cross( [ap.rover.half_length;0;0], force);
end