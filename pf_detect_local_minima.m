function [ is_minima, fraction, fractions ] = pf_detect_local_minima( ap, result_set )
%PF_DETECT_LOCAL_MINIMA Check is rover is stuck
%
%     Notes:
%     1) use a sample set of about 5 seconds (50 steps in the general case)
%     2) Comparisons can be done with the dVelocity values; here we 
%         compare the min/max vs the avg. Large overalls with an average of 
%         zero indicate oscillation.
%
    
    % sample size
    sample_size = length(result_set);
    
    % Position set
    pose_set = reshape([result_set.pose], 6, sample_size)';
    pose_set = pose_set(:,1:2);
    
    % Velocity set
%     vel_set = reshape([result_set.velocity], 2, sample_size)';
    
    % limits
    zero_tol = 0.001;
%     max_peak_tol = 2*zero_tol;
%     max_peak_fraction = 0.25;
    minima_limit = 0.75;
    
    % position Deltas
%     D = pose_set(2:end,:) - pose_set(1:end-1,:);
    displacement = pose_set(end,:) - pose_set(1,:);
    velocity = displacement / (ap.timestep * sample_size);
    
    maxVelocity = ap.rover.vel_max;
    maxDisplacement = ap.timestep * sample_size * maxVelocity;
    
    disFraction = abs(displacement) / maxDisplacement;
    velFraction = abs(velocity) / maxVelocity;
    
    
    % Velocities
%     V = vel_set;
%     avgV = sum(vel_set,2)/sample_size;
    
    % velocity deltas
%     dV = V(2:end,:) - V(1:end-1,:);

    % average velocity delta
%     adV = sum(dV,1)/sample_size;
%     zero_fraction = 1 - ( abs(adV) / zero_tol );
%     isAvgZero = (abs(adV) <= zero_tol);
    
    % peaks
%     peak_count = sum( abs(dV) > max_peak_tol );
%     peak_fraction = peak_count / sample_size;
%     isOverPeakLimit = (peak_fraction > max_peak_fraction);
    
    % Calculate
%     fractions = [( isAvgZero .* zero_fraction ) , ( isOverPeakLimit .* peak_fraction )];
    fractions = [velFraction disFraction]/zero_tol;
    fraction = sum( fractions ) / length(fractions);
    if result_set(end).cost.remaining_dist > ap.rover.length
        is_minima = fraction < minima_limit;
    else
        is_minima = false;
    end
    
end

