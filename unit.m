function [ e, m ] = unit( vec )
%UNIT Unit vector of a given vector
%   Return the unit vector, and optionally the magnitude, of the given
%   vector

    m = sum(vec.^2)^0.5;
    e = vec/m;

end

