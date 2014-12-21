function [ state_k ] = pf_control_law( ap, state, force, moment )
%PF_CONTROL_LAW Executes potential fields control law
%   Executes potential fields control law
%                                   
%       ap              : [struct]  Holds analysis parameters
%       state           : [ 2x1 ]   Holds current velocity and omega
%       force           : [ 2x1 ]   Holds calculated x and y forces
%       moment          : [ 2x1 ]   Holds calculated moment torque
%
%       state_k         : [ 2x1 ]   Holds calculated velocity and omega


    % Get the vehicle parameters needed
    m   = ap.rover.mass; % rover mass
    I   = ap.rover.I;    % rover second moment of area
    
    % Get the current state
    v   = state(1);           % rover forward speed
    w   = state(2);           % rover rotational velocity
    
    if v < 0.0001
        v = 0.0001;
    end
    
    % define the A matrix and u vector
    A   = diag([ 1/m , 1/(m*v) , 1/I ]);
    u   = [ force(1:2); moment(3) ];
    
    % get the delta state
    dS  = A*u;
    
    % integrate vDot and tDotDot, average tDot
    dv  = dS(1)*ap.timestep;
    dw  = dS(3)*ap.timestep;
    
    % scale acceleration to match limits
    if abs(dv) > ap.rover.accel_lin_max
        dw = dw*ap.rover.accel_lin_max/abs(dv);
        dv = sign(dv) * ap.rover.accel_lin_max;
    end
    
    if abs(dw) > ap.rover.accel_ang_max
        dv = dv*ap.rover.accel_ang_max/abs(dw);
        dw = sign(dw) * ap.rover.accel_ang_max;
    end
    
    vk  = dv + v;
    wk  = ( dS(2) + dw + w ) / 2;
    
    % scale v and w to match limits
    if abs(vk) > ap.rover.vel_max
        wk = wk*ap.rover.vel_max/abs(vk);
        vk = sign(vk) * ap.rover.vel_max;
    end
    
    if abs(wk) > ap.rover.vel_max
        vk = vk*ap.rover.vel_max/abs(wk);
        wk = sign(wk) * ap.rover.vel_max;
    end
    
    % clip velocity to wheel limits
    vLeft  = vk - wk * ap.rover.half_width;
    vRight = vk + wk * ap.rover.half_width;
        
    if abs(vLeft) > ap.rover.vel_max
        vRight  = vRight * ap.rover.vel_max / abs(vLeft);
        vLeft   = sign(vLeft) * ap.rover.vel_max;
    end
    
    if abs(vRight) > ap.rover.vel_max
        vLeft  = vLeft * ap.rover.vel_max / abs(vRight);
        vRight   = sign(vRight) * ap.rover.vel_max;
    end
    
    vk = (vLeft + vRight) / 2;
    wk = (vRight - vLeft) / ap.rover.half_width;
    
    state_k = [vk wk]';
%     fprintf('State [v w]: [ %6.3f %6.3f ]\n',[vk wk])

end

