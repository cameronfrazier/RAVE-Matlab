function pf_publish_scan( ap, scan, pose )
%PF_PUBLISH_SCAN Publish scan data in Inertial CS to external socket
%connection

    if ap.comms.use_comms
        r = scan(:,1);
        t = scan(:,2);

        T = pose(6);
        R = [cos(T) -sin(T); sin(T) cos(T)];

        points = [r.*cos(t), r.*sin(t)] * R;
        points = [points(:,1) + pose(1), points(:,2) + pose(2)];
        
        %% publish pose
        %fprintf('Publishing pose\n');
        c = arrayfun(@(x) sprintf('%f ', x), pose', 'uniformoutput',false)';      
        c = int8(char(c(:)))';
        
        % prepend pose flag
        cdata = [ int8('--001100--') c(:)'];
        
        % send data to output socket
        ap.os.write( cdata, ap);
        cdata = [];
        
        %% publish scan (if existing)
        if ~isempty(points)
            %fprintf('Publishing points\n');
            % Cell formatting of points as a sincle row
            c = arrayfun(@(x) sprintf('%f %f', x), points', 'uniformoutput',false)';        
            c = int8(char(c(:)))';

            % prepend scan flag
            cdata = [ int8('--110011--') c(:)'];

            % send data to output socket
            ap.os.write( cdata, ap);
            cdata = [];
        end
    end
end

