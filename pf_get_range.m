function [ range, delta ] = pf_get_range( point1, point2 )
%PF_GET_RANGE Calculate euclidian distance between sets of two points
    delta   = point2 - point1;
    range   = sum( delta.^2, 2 ).^0.5;
end

