function [ costObj ] = pf_cost_calc( sp, results )
%PF_COST_CALC Calculate the "cost" of a given simulation
%   Detailed explanation goes here
%
    
    [ ~, costObj ] = pf_result_object();
    
    if length(results) > 2
    
        % reset total cost
        costObj.total = 0;

        a_factor = sp.cost.angle_factor;
        l_factor = sp.cost.length_factor;
        t_factor = sp.cost.time_factor;
        r_factor = sp.cost.range_factor;
        i_factor = sp.cost.impact_factor;
        s_factor = sp.cost.success_factor;    

        % Check for impact
        if results(end).flags.hasImpact
            r_factor = r_factor * i_factor;
        end

        % Check for reaching target
        if results(end).flags.hasReachedTarget
            s_factor = 1;
        end

        %% Angle cost
        % as of the third iteration, a difference of travelled angles can be
        % found. This difference is multiplied by the a_factor to get the
        % iteration angluar cost

        travel_angle = 0;

        dxy(1,:) = results(end-1).pose(1:2) - results(end-2).pose(1:2);
        dxy(2,:) = results(end).pose(1:2)   - results(end-1).pose(1:2);

        a = atan2( dxy(:,2), dxy(:,1) );
        travel_angle = travel_angle + abs(a(2,:) - a(1,:));

        costObj.angle = results(2).cost.angle + a_factor * travel_angle;
        costObj.total = costObj.total + costObj.angle;


        %% Length cost
        bline_length    = pf_get_range(sp.map.start, sp.map.target);
        pose = [results(1:end).pose];
        pose = [reshape(pose, 6,length(pose)/6)'];
        travel_length   = sum((pose(2:end,1:2) - pose(1:end-1,1:2)).^2,2).^0.5;

%         seg_length = travel_length(end);
        travel_length = sum(travel_length);

        % Total travelled length as a factor of minium length
        costObj.travel_length = travel_length;
        costObj.length = l_factor * ( travel_length / bline_length);
        costObj.total = costObj.total + costObj.length;

        %% Speed cost
        % average speed as a factor of max_velocity
        
        costObj.time = t_factor * travel_length / results(end).time  / sp.rover.vel_max ;
        costObj.total = costObj.total + costObj.time;

        %% Range cost
        % Goes to 0 as target is approached
        remaining_dist = pf_get_range( sp.map.target(1:2), results(end-1).pose(1:2));
        costObj.remaining_dist = remaining_dist;
        costObj.range = r_factor * (remaining_dist / bline_length);
        costObj.total = costObj.total + costObj.range;

    end

end

