function ap = pf_get_waypoints( ap )
%PF_GET_WAYPOINTS Summary of this function goes here
%   Detailed explanation goes here

    ap.waypoints = [ap.map.size(1) * rand(5,1), ap.map.size(2) * rand(5,1), zeros(5,1)];

end

