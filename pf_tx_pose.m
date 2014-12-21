function pf_tx_pose( ap, pose )
%PF_TX_POSE Publish pose to output socket 
%   Publish pose to output socket listeners for parallel processing

    %% publish pose
    %fprintf('Publishing pose\n');
    c = arrayfun(@(x) sprintf('%f ', x), pose', 'uniformoutput',false)';      
    c = int8(char(c(:)))';

    % prepend pose flag
    cdata = [ int8('--001100--') c(:)'];

    % send data to output socket
    ap.os.write(cdata);
end

