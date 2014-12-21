function pf_test_scan_mapper(  )
%PF_TEST_SCAN_MAPPER Summary of this function goes here
%   Detailed explanation goes here

    close all;

    ap = pf_properties_sim();
    
    
    % TCP Comms Paths setup
    comms_path = '/home/cameron/Dropbox/MATLAB/TCP_comms';
    addpath(genpath(comms_path));
    javaaddpath(comms_path);

    %% Open sockets
    % Output socket
    ap.os = MatlabOutputSocket(ap.comms.mapper.port);

    % Input socket
    ap.is = MatlabInputSocket(ap.comms.sim.host, ap.comms.sim.port);
    
    hold on
    axis([-2.5 22.5 -2.5 22.5]);
    
    %% read loop
    while true
        ap.is.read();
        
        % see if anything was read
        if ap.is.m_bytes_read
            % check if the message was a shutdown flag
            if length(ap.is.m_last_message) == 10 
                if int8(ap.is.m_last_message) == int8('--000000--')
                    fprintf('Termination received\n');
                    break;
                end
            end
            
            % if we're still here then we received data, let's parse it!
            cdata = ap.is.m_last_message;
            
            % get the data type flag
            flag = cdata(1:10);
            
            if flag == int8('--110011--')
                %fprintf('Scan received\n');
                
                data = str2num(cdata(11:end));
                ld = length(data);
                if ~mod(ld,2)
                    data = reshape(data, ld/2, 2);
                    plot(data(:,1), data(:,2), 'b.');
                else
                    %fprintf('Malformed scan data, skipping\n');
                    continue;
                end
            end
            
            if flag == int8('--001100--')
                %fprintf('Pose received\n');
                data = str2num(cdata(11:end));
                ld = length(data);
                if ld == 6
                    plot(data(1), data(2), 'r.');
                else
                    %fprintf('Malformed pose data, skipping\n');
                    continue;
                end
            end
            
            axis square
            axis equal
            
        end
    end
    hold off
    
    
    
    ap.os.close();
    ap.is.close();
end