function [ child ] = pf_ga_mate( sp, fit_set, factor )
%PF_GA_MATE Summary of this function goes here
%   Detailed explanation goes here

    num_fit = length(fit_set);

    function noise = n()
        if rand() > (1-sp.ga.mate_thresh) 
            noise = factor;
        else
            noise = 1;
        end
    end

    % get parent ids
    id_mom = randi(num_fit);
    id_dad = randi(num_fit);
    while num_fit > 1 && id_dad ~= id_mom
        id_dad = randi(num_fit);
    end
    
    mom = fit_set(id_mom);
    dad = fit_set(id_dad);
    
    % get base parameters
    child = mom;
    
    % update genes
    % average mom and dad genes, and randomly add some variation noise
    child.sp.tan_eta_tol       = 0.5 * (mom.sp.tan_eta_tol          + dad.sp.tan_eta_tol)       * n();
    child.sp.tan_vel_tol       = 0.5 * (mom.sp.tan_vel_tol          + dad.sp.tan_vel_tol)       * n();
    child.sp.obs_power         = 0.5 * (mom.sp.obs_power            + dad.sp.obs_power)         * n();
    child.sp.obs_wall          = 0.5 * (mom.sp.obs_wall             + dad.sp.obs_wall)          * n();
    child.sp.dmp_dist_stop     = 0.5 * (mom.sp.dmp_dist_stop        + dad.sp.dmp_dist_stop)     * n();
    child.sp.dmp_ang_stop      = 0.5 * (mom.sp.dmp_ang_stop         + dad.sp.dmp_ang_stop)      * n();
    child.sp.gain_tangent      = 0.5 * (mom.sp.gain_tangent         + dad.sp.gain_tangent)      * n();
    child.sp.gain_risk         = 0.5 * (mom.sp.gain_risk            + dad.sp.gain_risk)         * n();
    child.sp.att_force_max_sat = 0.5 * (mom.sp.att_force_max_sat    + dad.sp.att_force_max_sat) * n();
    child.sp.att_force_min_sat = 0.5 * (mom.sp.att_force_min_sat    + dad.sp.att_force_min_sat) * n();
    
    % Apply value limits
    if child.sp.gain_risk >= 1
        child.sp.gain_risk = .99;
    end
end