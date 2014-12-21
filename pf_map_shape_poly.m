function [ p ] = pf_map_shape_poly( bounding_box, nSides, center, rotation, scale )
%PF_MAP_SHAPE_POLY Generate a set of lines that define a polygon
%   Polygons are split up into a series of equal iosceles triangles with a
%   primary angle 'alpha'. This then defines the polygon as a series of
%   circle chords which are returned as an array of pf_map_shape_line()
%   objects.
%
%   The polygon is initially defined as inscribed upon a circle with radius
%   1, rotated, and then is scaled by the dimensions of the bounding box. 
%   The map scaling factor is passed through to pf_map_shape_line().
%
%   The bounding_box is defined as a rectangle centered at [0 0] with some
%   length and width. Eg: bounding_box = [3 4] for a shape scaled to fit
%   within a box that is +/- 1.5 units in X and +/- 2.0 units in the Y axis

    p = [];

    R   = @(t) [cos(t) -sin(t); sin(t) cos(t)];
    
    % Check for point (not supporting this anymore)
    if nSides < 3
        return;
    end 
        
    epoints = zeros(nSides,2);
    
    % triangle primary angle
    alpha   = 2*pi/nSides;  % [2.0944    1.5708    1.2566] rad OR [120 90 72] deg
    
    % Find the segment end points
    for i = 1:nSides
        % Line segment endpoints, 
        epoints(i,:)    = [ cos(alpha*(i - 0.5 ) )/cos(alpha/2) sin(alpha*(i - 0.5 ))/sin(alpha/2) ];
    end
    
    % scale to bounding box
    epoints = epoints * [bounding_box(1) 0; 0 bounding_box(2) ]/2;%
    
    % Loop endpoint list and rotate for center point calculation
    epoints = [ epoints; epoints(1,:) ];
    epoints = (R(rotation)*epoints' )';
    epoints = epoints + ones(nSides+1,1)*center;

    % line angles
    y = (epoints(2:end,2)-epoints(1:end-1,2));
    x = (epoints(2:end,1)-epoints(1:end-1,1));
    rot = -atan2(y,x);
    length = pf_get_range( epoints(1:end-1,:), epoints(2:end,:) );
    
    % Find center point
    for i = 1:nSides
        % segment midpoint
        cpoint  = 0.5 * sum( epoints(i:i+1,:), 1 );
        % list of line objects
        p       = [ p, pf_map_shape_line( length(i), cpoint, rot(i), scale) ]; %#ok<AGROW>
    end
end

