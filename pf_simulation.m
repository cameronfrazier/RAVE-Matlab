function [ results, ap ] = pf_simulation( ap )
%PF_SIMULATION Run a single PF nav simuation
%   Detailed explanation goes here

close all


%% ensure proper file inclusions
% maps, settings, etc
addpath(genpath(pwd));


%% Check for standalone operation

if nargin ~= 1
    ap = false;
end

if ~isstruct(ap)
    % Generate Algorithm Properties if they are not supplied
    rng('shuffle', 'twister');
    ap = pf_properties_sim();
    
    ap.verbose = true;
    
    ap.test_series = 2;
    ap.break_on_local_minima = true;
        
    % Show the live map, default: false
    ap.disp.live = true;
    % ap.disp.live_cost = true;
    ap.disp.overall = true;
    
    % map override
%     ap.map_filename = 'pf_map_one_wall';
%     ap.seed = 1707631487;
%     ap.map_filename = 'pf_map_gaps';
    ap.seed = 1000; % Easy with narrow gap
%       ap.seed = 2000; % Hard, but should be passable
%     ap.seed = 2; % Easy
%     ap.seed = 1927093343; % Medium, nice spacing
%     ap.seed = 1307975238; % Easy
% else
%     RandStream.setGlobalStream(ap.rng_stream);
%     RandStream.getGlobalStream()
end


%% Series Test Settings
if isfield(ap, 'test_series')
    % random number between [ x y ]
    U = @(x,y) min([x y]) + ((max([x y]) - min([x y]))*rand()); 
    
    Tests = struct;
    tIdx = 0;

    % for `door frame' #1
    tIdx = tIdx + 1;
    Tests(tIdx).map_filename = 'pf_map_doors';
    Tests(tIdx).start        = [ U(0,5) U(0,5) 0 ];
    
    % for `door frame' #2
    tIdx = tIdx + 1;
    Tests(tIdx).map_filename = 'pf_map_gaps';
    Tests(tIdx).start        = [ U(-1,0) U(-2.25,2.25) 0 ];
    
    % for GNRON
    tIdx = tIdx + 1;
    Tests(tIdx).map_filename = 'pf_map_one_wall';
    Tests(tIdx).start        = [ U(-1,0) U(-5,5) 0 ];

    % for pf_map_hallway_narrow
    tIdx = tIdx + 1;
    Tests(tIdx).map_filename    = 'pf_map_hallway_narrow';
    Tests(tIdx).start           = [ U(-5,5) U(-1,0) 0];
    
    % for pf_map_hallway_wide
    tIdx = tIdx + 1;
    Tests(tIdx).map_filename = 'pf_map_hallway_wide';
    Tests(tIdx).start        = [ U(-5,5) U(-1,0) 0];
    
    % for pf_map_single_obs
    tIdx = tIdx + 1;
    Tests(tIdx).map_filename = 'pf_map_single_obs';
    Tests(tIdx).start        = [ U(-2,2) U(-1,0) 0];
    
    % for pf_map_trees
    tIdx = tIdx + 1;
    Tests(tIdx).map_filename = 'pf_map_trees';
    if randi(2)-1
        Tests(tIdx).start = [ 25*rand()-1 2*rand()-1 0];
    else
        Tests(tIdx).start = [ 2*rand()-1 25*rand()-1 0];
    end
    
    ap.map_filename = Tests(ap.test_series).map_filename;
    ap.start = Tests(ap.test_series).start;

end

%% Main

% Calculate analysis terms
ap = pf_setup_calc( ap );

% Waypoints

% Load map if not supplied
if ~isfield( ap, 'map' )
    Verbose(ap, 'No map loaded. Now loading: %s\n', ap.map_filename);
    ap.map = pf_map_load_mfile( ap );
    ap.map;
end

Verbose(ap, 'Starting at [%.3f %.3f %.3f]\n', ap.map.start);

% initialize system
pose    = [ ap.map.start ap.init.roll ap.init.pitch ap.init.yaw ]';
state   = [ 0 0 ]';

% initialize results matrix [ idx [pose]' cost ]
results(1) = pf_result_object();
results(ap.iteration_max) = pf_result_object();

% create live map window
if ap.disp.live
    figure(ap.idx*2 - 1);
end


% Wall impact flag
% is_sim_error = false;
% msg_sim_error = '';

% Iteration counter
cnt_iter = 0;

% Minima counter
%  This provides the buffer in iteration counts before
%  the local minima check is made, allowing a chance for 
%  new targets to pull the rover out of its stuck position
cnt_minima = 50;
   

if isfield( ap.map, 'waypoints')
    ap.waypoints = ap.map.waypoints;
end

% Set the current target to be either the next waypoint or final
if isempty(ap.waypoints)
    ap.current_target = ap.map.target;
else
    ap.current_target = ap.waypoints(1,:);
    ap.waypoints(1,:) = [];
end



figure(1);
pf_plot_overall( ap , [] );%, iter_costs );

%% Simulation


% run simulation until minimum distance to target is reached
tic;

while true
    cnt_iter = cnt_iter + 1;
    results(cnt_iter) = pf_result_object();
    results(cnt_iter).time = cnt_iter*ap.timestep;
    
    % Update some needed parameters
    ap.epsilon = exp( -ap.tan_vel_decay*abs( state( 1 ) )*10 );

    % Grab scan of area
    try
        scan = pf_get_scan_mfile( ap, pose );
    catch ME
        if strcmp(ME.identifier, 'PFSimulation:scanViolation')
            msg_sim_error = ME.message;
            results(cnt_iter).flags.hasScanViolation = true;
            break;
        else 
            rethrow(ME);
        end
    end

    
    % Check for obstacle impact
    [impact, impact_point] = pf_check_impact( ap, scan );
    
    if impact
        msg_sim_error = sprintf('Buffer distance violated at [%.3f %3f]!', ...
            impact_point(1), impact_point(2));
        results(cnt_iter).flags.hasImpact = true;
        break;
    end
    
    % Calculate forces
    [ force, moment, forces, moments, fObj, mObj ] = pf_get_forces( ap, state, scan, pose );  
    results(cnt_iter).force = fObj;
    results(cnt_iter).moment = mObj;
    
    % Update state
    state = pf_control_law( ap, state, force, moment );
    results(cnt_iter).velocity = state;
    
    % Update Costs
    results(cnt_iter).cost = pf_cost_calc(ap, results(1:cnt_iter));
    
    
    % Display live map
    if ap.disp.live || ap.print.live
        
        %iter_results = results(results(:,1)>0,:);
        if length(results) > 1
            results(cnt_iter).cost = pf_cost_calc(ap, results(1:cnt_iter));
        end
               
        if ap.disp.live_cost
            figure(2);
            subplot(1,2,1),
            pf_plot(ap, scan, pose, force, moment, forces, moments);
        else
            figure(2);
            pf_plot(ap, scan, pose, force, moment, forces, moments);
        end
        getframe();

        
        % Display print livemap 
        if ap.print.live
            fname = sprintf( ap.print.live_name, cnt_iter );
            print(ap.print.format, fname, gcf);
        end
        
    end
    
    % Get delta motion
    motion = zeros(6,1);
    motion(1)   = state(1) * cos(-pose(6));
    motion(2)   = state(1) * sin(-pose(6));
    motion(6)   = -state(2);

    % Update pose with integrated motion
    pose    = pose + motion * ap.timestep;
    
    % verify pose rotational domain
    pose(6) = mod(pose(6)+pi,2*pi) - pi;
   
    % Store results for later processing
    results(cnt_iter).pose = pose';
    
    % Check for local minima
    if ap.break_on_local_minima
        if (cnt_iter > cnt_minima)
            results(cnt_iter).flags.hasMinima = pf_detect_local_minima( ap, results(cnt_iter-49:cnt_iter));
%             is_sim_error = is_sim_error | results(cnt_iter).flags.hasMinima;
            cnt_minima = cnt_iter + 50;
        end
    end
    
    % If we get this far the timestep was a valid on
    results(cnt_iter).isValid = true;
    
    % exit conditions
    if isempty(ap.waypoints)
        if  pf_get_range( pose(1:3), ap.map.target' ) < ap.target_min
            % Success! Set Success flag!
            results(cnt_iter).flags.hasSuccess = true;
            results(cnt_iter).flags.hasReachedTarget = true;
            Verbose(ap, 'Reached target, breaking\n');
            break;
        elseif results(cnt_iter).flags.hasMinima
            Verbose(ap, 'Minima found, breaking\n');
            break;
        elseif cnt_iter > ap.iteration_max
            results(cnt_iter).flags.hasIterationLimit = true;
            Verbose(ap, 'Iteration limit, breaking\n');
            break;
        end
    end
        
    % For realtime simulation
%     while toc < ap.timestep
%         % Do nothing, try
%     end
        
end

%% Post Processing

% filter out unused results 
%   ~=0 is used to ensure we capture the various flags
% size(results)
results = results([results.isValid]==true);


% Find the final cost
% size(results)
if size(results,2) == 0
    results = 0;
else
    results(end).cost = pf_cost_calc(ap, results);
end

% figure(1);
% pf_plot_overall( ap, results);%, iter_costs );

% Display overall map and path
if ap.disp.overall
    figure(ap.idx*2);
    pf_plot_overall( ap, results);
    
    % Display print overall map 
    if ap.print.overall
        print(ap.print.format, ap.print.overall_name, gcf);
    end    
end
 
% if is_sim_error
%     % Failed due to sim crash, set flag

results(end).flags.hasSimCrash = ...
    results(end).flags.hasImpact | ...
    results(end).flags.hasScanViolation | ...
    results(end).flags.hasMinima | ...
    results(end).flags.hasIterationLimit;

%     % Failure message
%     fprintf(1,'\n   Gen: %3i, Sim: %3i, Iteration: %i ... Failed!\n     %s\n', ...
%         ap.gen, ap.idx, cnt_iter-1, msg_sim_error);
% else
%     % Completion message
%     fprintf(1,'\n   Gen: %3i, Sim: %3i, Iteration: %i ... Done!\n', ...
%         ap.gen, ap.idx, cnt_iter-1);
% end


end
