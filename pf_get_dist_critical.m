function [ critical_distance ] = pf_get_dist_critical( ap )
%PF_GET_DIST_CRITICAL Return the critical distance(s) 
%   Return the critical distances for the various analysis configurations

    % using corner_points method
    if ap.method.corner_points
        critical_distance   = 0;
    
    % Using bounding shape method, either box or circle
    elseif ap.method.bounding_box
            critical_distance = zeros( ap.laser.count );
            
        for i = 1:ap.laser.count
            angle = ap.laser.angle_min + i*ap.laser.angle_inc;
            
            if abs( angle ) > ap.rover.corner_angle
                critical_distance = ap.rover.half_width / sin( abs( angle ) );
            else
                critical_distance = ap.rover.half_length / cos( abs( angle ) );
            end 
        end

    elseif ap.method.bounding_circle
        critical_distance = ( ap.rover.half_width^2 + ap.rover.half_length^2 )^0.5;
    end

    critical_distance = critical_distance + ap.obs_dist_buf;
end

