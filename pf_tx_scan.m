function pf_tx_scan( ap, pose, scan )
%PF_TX_SCAN Summary of this function goes here
%   Detailed explanation goes here
    if ~isempty(scan)
        %% rotate scan to World CS
        T = pose(6);
        R = [cos(T) -sin(T); sin(T) cos(T)];

        points = [scan(:,1).*cos(scan(:,2)), scan(:,1).*sin(scan(:,2))] * R;
        points = [points(:,1) + pose(1), points(:,2) + pose(2)];

        %% publish scan (if existing)
        %fprintf('Publishing points\n');
        % Cell formatting of points as a sincle row
        c = arrayfun(@(x) sprintf('%f %f', x), points', 'uniformoutput',false)';        
        c = int8(char(c(:)))';

        % prepend scan flag
        cdata = [ int8('--110011--') c(:)'];

        % send data to output socket
        ap.os.write(cdata);
    end
end

