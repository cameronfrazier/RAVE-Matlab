function [ scan ] = pf_get_scan_mfile( ap, pose )
%PF_GET_SCAN Return scan points within scan_range
%   NB: scan is returned in ROVER coordinates!
%   
%       pose    : [ 6x1 ]       Holds position and orientation information
%                               [ x y z roll pitch yaw ]'
%       ap      : [struct]      Holds various analysis properties
%
%       scan    : [ Nx2 ]       Returns a set of [ range bearing ] values
    
    radius  = ap.scan_range;        % [m]
    
    a_min   = ap.laser.angle_min;   % [rad]
    a_max   = ap.laser.angle_max;   % [rad]
    a_cnt   = ap.laser.count;       % [-]
    a_inc   = ap.laser.resolution;  % [-]
    
    x       = pose(1);              % [m]
    y       = pose(2);              % [m]
    t       = pose(6);              % [rad]
    
    R = [cos(t) -sin(t); sin(t) cos(t)];
    
    scan    = zeros(a_cnt, 2);
    cnt_b   = 0;
    
    cnt_used_obj = 1;
    
    % Preprocess some object limits
    for o = ap.map.objects;
        
        % range from rover to object center
        o.cdelta = o.center - [x y];
        o.cdist  = sum(o.cdelta.^2)^0.5;

        % angle from rover_x to object center
        o.cangle    = atan2( o.cdelta(2), o.cdelta(1) ) + t;
        o.cangle    = mod(o.cangle+pi,2*pi) - pi;
        
        try
        if o.type == 1      % circle
            
            % Do we need to check this object for hits?
            % The range to the center must be less then the scan radius plus object size 
            if o.cdist > (radius + o.size)
                continue;
            end
            
            if (o.cdist - o.size ) < ap.obs_dist_buf
                ME = MException('PFSimulation:scanViolation', ...
                                'Scan violation at [%.3f %3f]!', pose(1), pose(2));
                throw(ME);
            end
            
            % min and max scanning bearing of laser
            o.scan_max  = o.cangle + 2*asin(0.5*o.size/o.cdist);
            o.scan_max  = mod(o.scan_max+pi,2*pi) - pi;
            o.scan_min  = o.cangle - 2*asin(0.5*o.size/o.cdist);
            o.scan_min  = mod(o.scan_min+pi,2*pi) - pi;
            
        elseif o.type == 3 % line
            
            
            % Do we need to check this object for hits?
            % Check range to closest point to the rover
            
            % Are we completely outside the bounding box?
            if sum(abs([x y] - max(o.points)) > radius) > 1 && sum(abs([x y] - min(o.points)) > radius) > 1
                continue;
            else
                % are we within the line endpoints?
                rRover = [x y] -o.points(1,:);
                rLine =  (o.points(2,:) - o.points(1,:));
                proj =  sum( rLine/norm(rLine) .* rRover ); % dot product projection to unit vector
            
                if proj > 0 && proj < sum((o.points(2,:)-o.points(1,:)).^2)^0.5
                    % find range to nearest (normal) point on line
                    % from http://www.mathworks.com/matlabcentral/newsreader/view_original/423879
                    range = abs(det([o.points(2,:)-o.points(1,:);[x y]-o.points(1,:)]))/norm(o.points(2,:)-o.points(1,:)); % for row vectors.
                else
                    % we are within scan distance of an endpoint but not normal
                    % to a line, so just find the closest endpoint
                    range = min( pf_get_range( ones(2,1)*[x y], o.points ) );
                end
            end
            
            if range > radius
                continue;
            elseif range < ap.obs_dist_buf
                ME = MException('PFSimulation:scanViolation', ...
                                'Scan violation at [%.3f %3f] |r| = %f!', pose(1), pose(2), range);
                throw(ME);
            end
            
            % if we get to this point, then we need to get the line
            % endpoints relative to the rover
            [~, dxy]    = pf_get_range( ones(2,1)*[x y], o.points );
            
            % min and max scanning bearing of line
            ang         = atan2( dxy(:,2), dxy(:,1) ) + t;
            limits = [  mod(max(ang)+pi,2*pi)-pi, ...
                        mod(min(ang)+pi,2*pi)-pi ];
            
            if o.cangle > limits(1) || o.cangle < limits(2)
                limits = limits*[0 1;1 0];
            end
            o.scan_max  = limits(1);
            o.scan_min  = limits(2);
        end
        
        catch ME
            if strcmp(ME.identifier, 'MATLAB:mod:complexArgument')
                ME = MException('PFSimulation:scanViolation', ...
                                'Scan violation at [%.3f %3f]!', pose(1), pose(2));
                % Throw an error 
                throw(ME);
            else 
                rethrow(ME);
            end
        end
        
        used_objects(cnt_used_obj) = o;
        cnt_used_obj = cnt_used_obj + 1;
    end
    
    
    if exist('used_objects', 'var')
%         for b = a_min : a_inc : a_max
        for b = -pi : a_inc : pi
            cnt_b = cnt_b + 1;

            % create unit ray, scale, shift, rotate to inertial
            ray = [ 0 0; cos(b) sin(b)]*radius;
            ray = ray * R;
            ray = ray + [ 1; 1 ]*[ x y ];

            point = [ 2*radius b ];
            
            for o = used_objects
                if b >= o.scan_min
                    if b <= o.scan_max
                        if o.type == 1      % circle
                            % angle from x to circle center
                            beta    = abs( o.cangle - b );
                            % perpndicular distance from circle center to ray
                            d       = o.cdist*sin(beta);
                            % find range at impact points
                            r = o.cdist * cos(beta) - o.size*sin(acos(d/o.size));
                            if r < point(1)
                                point(1) = r;
                            end
                        elseif o.type == 3  % line
                            
                            % find intersection points
                            [pt, ~] = pf_line_line_intersect([ray ; o.points;]);
                            
                            % calculate range
                            if ~isempty(pt)
                                r = pf_get_range([x y], pt);
                                % is this the closest point to the rover?
                                if r < point(1)
                                    point(1) = r;
                                end
                            end
                        end
                    end
                end
            end
            scan(cnt_b, :) = point;
        end
    end
    scan = scan(scan(:,1)>0,:);
    scan = scan(scan(:,1)<=radius,:);
end

