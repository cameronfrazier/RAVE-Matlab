function [ ap ] = pf_properties_analysis(  )
%PF_ROVER_PROPERTIES Returns the properties of the analysis
    
    % imported properties
    ap.laser        = pf_properties_laser();    % laser properties
    ap.rover        = pf_properties_rover();    % rover properties
    
    % defined properties
    ap.scan_range   = 2;    % [m]       scan range radius
    ap.target_min   = 0.1;  % [m]       minimum acceptable range to target
    
    % analysis method switches
    ap.method.corner_points     = false;
    ap.method.bounding_box      = false;
    ap.method.bounding_circle   = true;

end

