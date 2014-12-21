function [ scan X Y ] = pf_get_scan( ap, map, pose )
%PF_GET_SCAN Return scan points within scan_range
%   NB: scan is returned in ROVER coordinates!
%   
%       map     : [ NxM ]   Boolean array representing overall map [pixal]
%       pose    : [ 6x1 ]   Holds position and orientation information
%                           [ x y z roll pitch yaw ]'
%       ap      : [struct]  Holds various analysis properties
%
%       scan    : [ Nx2 ]   Returns a set of [ range bearing ] values
    
    radius  = ap.scan_range;        % [m]
    scale   = ap.sim.map_scale;     % [m/pixal]
    
    a_min   = ap.laser.angle_min;   % [rad]
    a_max   = ap.laser.angle_max;   % [rad]
    a_cnt   = ap.laser.count;       % [-]
    
    x       = pose(1);              % [m]
    y       = pose(2);              % [m]
    t       = -pose(6);              % [rad]
    
    
    % Initial slicing to limit processing
    [ lim_y lim_x ] = size(map);
    x_max = floor(  min( [ ( x+radius )/scale-1, lim_x ] ) );
    x_min = ceil(   max( [ ( x-radius )/scale, 1     ] ) );
    
    y_max = floor(  min( [ ( y+radius )/scale-1, lim_y ] ) );
    y_min = ceil(   max( [ ( y-radius )/scale, 1     ] ) );
    
    X = [ x_min x_max ];
    Y = [ y_min y_max ];
    
    % radius in image scale
    ss = ceil(radius/scale);
    
    % 2Rx2R map slice to account for when rover is within R of the edge of
    % the image map
    m = zeros(2*ss);
    
    deltaX = x_max - x_min;
    deltaY = y_max - y_min;
    
    %  calculate slice padding
    padX = floor(2*ss - deltaX - 1);
    padY = floor(2*ss - deltaY - 1);
    
    if ~padX || x_max == lim_x
        padX = 1;
    end
    
    if ~padY || y_max == lim_y
        padY = 1;
    end
    
    % slice out map
    sY = padY;
    eY = sY + deltaY;
    sX = padX;
    eX = sX + deltaX;
    
    m(sY:eY, sX:eX ) = map( y_min:y_max, x_min:x_max );
    [ lim_y lim_x ] = size(m);

    
    % get a count of total points in this set
    cnt_pt = sum(sum(m));
    
    % list of valid points ( [ range bearing x y] )
    vpt = zeros(cnt_pt, 4);
    cnt_vpts = 1;
    
    for i = 1:lim_x % cols    
        for j = 1:lim_y % rows
            if m(j,i)
                vpt(cnt_vpts,3:4) = [ i j ];
%                 vpt(cnt_vpts,4) = j;
                cnt_vpts = cnt_vpts + 1;
            end
        end
    end
    
    % scale points and shift origin to rover
    vpt(:,3:4)  = scale * ( vpt(:,3:4) - ss ); % x y
    %vpt(:,4)    = scale * ( vpt(:,4) - ss ); % y
    
    % rotate points to align with rover CS
    vpt(:,3:4)  = vpt(:,3:4) * [ cos(t), -sin(t); sin(t), cos(t) ];
    
    % calculate range and bearing
    vpt(:,1)    = ( vpt(:,3).^2 + vpt(:,4).^2 ).^0.5;
    vpt(:,2)    = atan2( vpt(:,4), vpt(:,3) );
    
    % sort on bearing and filter for laser sweep
    vpt = sortrows(vpt,2);
    
    i_min = find( vpt(:,2) > a_min, 1, 'first' );
    i_max = find( vpt(:,2) < a_max, 1, 'last' );
    
    vpt = vpt(i_min:i_max,:);
    
    % now we should have all valid points
    % sort them into bins by angle, and find the min of each
    %  angular bin, also removing points for r > scan_radius
    [c bin] = hist(vpt(:,2),a_cnt);
        
    scan = zeros( length( c ), 2 );
    
    cnt_scan = 0;
    for i = 1:length(c)
        r = 0;
        if c(i)
            is = sum( c( 1:i-1 ) ) + 1;
            ie = sum( c( 1:i ) );
            r = min( vpt( is:ie,1 ) );
        else
            if i > 1 && i < length(c)
                if c(i-1) && c(i+1)
                    is = sum( c( 1:i-2 ) ) + 1;
                    ie = sum( c( 1:i-1 ) );
                    r1 = min( vpt( is:ie,1 ) );
                    is = sum( c( 1:i ) ) + 1;
                    ie = sum( c( 1:i+1 ) );
                    r2 = min( vpt( is:ie,1 ) );
                    r = 0.5*(r1+r2);
                end
            end
        end
        
        if r <= radius && r
            cnt_scan = cnt_scan + 1;
            scan(cnt_scan,:) = [ r , bin(i) ];
        end
    end
    
    % trim scan
    scan((cnt_scan+1):end, :) = [];
%     fprintf(1,'%3i points detected, %3i used (r_max: %5.2f) \n', cnt_pt, length(scan(:,1)), max(scan(:,1)));
end

