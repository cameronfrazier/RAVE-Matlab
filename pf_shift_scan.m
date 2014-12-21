function [ shifted_scan ] = pf_shift_scan( scan, shift )
%PF_POINT_SHIFT Shift a scan by some [ x y z ] value
%   Shift a scan [ range bearing ] by some distance defined as [ x y z ]

    % convert [range bearing] into [ x y z ]
    cnt_pts = length(scan(:,1));
    pts = diag(scan(:,1))*[ cos( scan(:,2) ) ,sin( scan(:,2) ) , zeros(cnt_pts,1) ];

    % shift pts
    spts    = pts - ones(cnt_pts,1)*shift;
    sbear   = atan2( spts(:,2), spts(:,1));
    srange  = sum( spts.^2, 2 ).^0.5;
    
    shifted_scan = [ srange sbear ];
end

