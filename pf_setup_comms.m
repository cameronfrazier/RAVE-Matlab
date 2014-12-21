function ap = pf_setup_comms( ap )
%PF_SETUP_COMMS Configure TCP Communications
%   Detailed explanation goes here

if ap.comms.use_comms
    % TCP Comms Paths setup
    comms_path = '/home/cameron/Dropbox/MATLAB/TCP_comms';
    addpath(genpath(comms_path));
    javaaddpath(comms_path);

    % Output socket
    ap.os = MatlabOutputSocket(ap.comms.sim.port);

    % Input socket
    ap.is = MatlabInputSocket(ap.comms.mapper.host, ap.comms.mapper.port);
end

end

