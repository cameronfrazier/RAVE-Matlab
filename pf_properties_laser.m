function [ lp ] = pf_properties_laser(  )
%PF_ROVER_PROPERTIES Returns the properties of the laser

    %%% Hokuyo URG-04LX-UG01 %%%
    
    % Given values
    lp.resolution   =  0.5*pi/180;     % [rad]
    lp.angle_min    = -120*pi/180;     % [rad]
    lp.angle_max    =  120*pi/180;     % [rad]
    
    % Calculated values
    lp.count        = ceil ( ( lp.angle_max - lp.angle_min ) / lp.resolution );

end

