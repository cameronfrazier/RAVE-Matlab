function [ rp ] = pf_properties_rover(  )
%PF_ROVER_PROPERTIES Returns the properties of the rover

    %%% Clearpath Robotics Husky A200 %%%
    
    % Given values
    rp.mass         = 47;                       % [kg]
    rp.width        = 0.550;                    % [m]
    rp.length       = 0.988;                    % [kg]
    rp.vel_max      = 0.5;                     % [m/s]
    rp.accel_lin_max    = 0.1;                     % [m/s^2]
    rp.accel_ang_max    = 2;                     % [rad./s^2]
    
    % Calculated values
    rp.I       = rp.mass*(rp.width^2 * rp.length^2)/12; % [m^4]
    
    % calculated dimensions/positions
    rp.half_width       = rp.width / 2;
    rp.half_length      = rp.length / 2;
    rp.corner_points    = [ 1  0  0;    % front-mid
                            1  1  0;    
                            1/3  1  0;    
                            -1/3  1  0; 
                           -1  1  0; 
                           -1  0  0; 
                           -1 -1  0; 
                            -1/3 -1  0; 
                            1/3 -1  0;  
                            1 -1  0 ];
     rp.corner_points = rp.corner_points * [ rp.half_length 0 0; 0 rp.half_width 0; 0 0 0]; 
     rp.corner_angle = atan( rp.width / rp.length );

end

