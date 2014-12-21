function pf_plot_forces( res )
%PF_PLOT_VELOCITIES Summary of this function goes here
%   Detailed explanation goes here
    forces      = [res.force];
    moments     = [res.moment];
    
    MAG = @(x) sum(x.^2,1).^0.5;
    Z = @(x) sum(x,1);
    
%     f_att       = [forces.att];
%     f_obs       = [forces.obs];
%     f_rsk       = [forces.rsk];
%     f_dmp       = [forces.dmp];
%     f_tan       = [forces.tan]; 
%     
%     f_net = f_att + f_obs + f_rsk + f_dmp + f_tan;
    
    
    f_net       = MAG([forces.att] + [forces.obs] + [forces.rsk] +[forces.dmp] + [forces.tan]);
    f_att       = MAG([forces.att]);
    f_obs       = MAG([forces.obs]);
    f_rsk       = MAG([forces.rsk]);
    f_dmp       = MAG([forces.dmp]);
    f_tan       = MAG([forces.tan]);  
    %f_corners   = [forces.corners];  
   
    m_net       = Z([moments.net]);
    m_att       = Z([moments.att]);
    m_obs       = Z([moments.obs]);
    m_rsk       = Z([moments.rsk]);
    m_dmp       = Z([moments.dmp]);
    m_tan       = Z([moments.tan]);
    %m_corners   = [moments.corners];
    
    s   = 1;
    e   = size(res,2);
    figure(90)
    
    subplot(2,1,1),
    plot(s:e, [f_net(s:e)' f_att(s:e)' f_obs(s:e)' f_rsk(s:e)' f_dmp(s:e)' f_tan(s:e)']);
    legend('Net','Attractive', 'Obstacle', 'Risk', 'Drag', 'Tangent');
    title('Forces');
    
    subplot(2,1,2),
    plot(s:e, [m_net(s:e)' m_att(s:e)' m_obs(s:e)' m_rsk(s:e)' m_dmp(s:e)' m_tan(s:e)']);
    legend('Net','Attractive', 'Obstacle', 'Risk', 'Drag', 'Tangent');
    title('Moments');

end

