function [ has_impact, impact_point ] = pf_check_impact( ap, scan )
%PF_CHECK_IMPACT Check for Rover-Obstacle buffer distance violations
%   Check for rover impact with environment obstacles. This is in the Rover
%   CS!
%
%   Impacts are defined as violation of the defined buffer distance
%

% preload default return values
has_impact      = false;
impact_point    = [0 0];


% The general radius is the rover bounding circle + buffer distance.
% This covers the entirety of the rovers space, and provides a quick check
% through radiusMax. RadiusMin is the range inside which can not be a
% violation.
radiusMax  = sum([ap.rover.half_width ap.rover.half_length].^2)^0.5 + ap.obs_dist_buf;
radiusMin  = ap.rover.half_width + ap.obs_dist_buf;

% list of corner points
cpoints = ap.rover.corner_points;

%% Using scan data
% 
% Since we have a full collection of scan data already, simply start
% looking at only those points which are closer than radius

% collection of close points
p = scan(scan(:,1)<=radiusMax,:);
q = scan(scan(:,1)<=radiusMin,:);

if isempty(q)
    if ~isempty(p)
        for pIdx = 1:length(p(:,1))
            pt = p(pIdx,1)*[cos(p(pIdx,2)), sin(p(pIdx,2)), 0];
            [d, di] = min(sum((cpoints - ones(size(cpoints,1),1)*pt ).^2,2).^.5);
            
            if d < ap.obs_dist_buf
                has_impact = true;
                impact_point = pt;
                return;
            end
        end
    end
else
    [~, qi] = min(q(1,:));
    has_impact = true;
    impact_point = q(qi,1)*[cos(q(qi,2)), sin(q(qi,2))];
end

end

