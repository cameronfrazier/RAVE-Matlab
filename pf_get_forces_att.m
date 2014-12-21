function [ force, moment ] = pf_get_forces_att( ap, pose )
%PF_GET_FORCES_ATT Calculate attractor forces in Rover CS

    if ~ap.att_use
        force = [0 0 0]';
        moment = [0 0 0]';
        return;
    end
    
    % initialize output
    force       = [ 0 0 0 ]';
    moment      = [ 0 0 0 ]';
    
    % Rotation matrix
    t = -pose(6);
    r = [cos(t) -sin(t); sin(t) cos(t)];
    
    % set output
    delta = (ap.current_target(1:2)' - pose(1:2))';
    force(1:2)  = ((ap.gain_attractor * delta) * r)';
    
    fmag = sum( force.^2 )^0.5;
    
    if fmag > ap.att_force_max_sat
        force = (force/fmag) * ap.att_force_max_sat;
    elseif fmag < ap.att_force_min_sat
        force = (force/fmag) * ap.att_force_min_sat;
    end
    
    moment(3) = ap.rover.half_length*force(2); %cross( [ap.rover.half_length;0;0], force);
end

