function [ sp ] = pf_properties_sim(  )
%PF_ROVER_PROPERTIES Returns the properties of the analysis
    
    %% imported properties
    sp.laser        = pf_properties_laser();    % laser properties
    sp.rover        = pf_properties_rover();    % rover properties
    
    %% Simulation settings
    sp.gen  = 1;    % Generation index
    sp.idx  = 1;    % Simulation index, used when running multiple sims
    sp.seed = -1;   % Set to a known seed for predictable random results (mostly for random map generation)
    sp.use_seed = true;
    
    %% Local Minima Control
    % Truth Table of effects
    %   break_on_local_minima   resolve_minima  Result
    %   false                   false           Run out iteration counter (Default)
    %   true                    true/false      Fail out on Local Minima detection
    %   false                   true            Run Waypoint planner
    %
    sp.break_on_local_minima    = false; % Reaction to Local Minima.   
    sp.resolve_minima           = false; % Do we want to try to resolve local minima issues. Usually false unless testing path planner
    
    

    %% defined properties
    sp.start            = [ 0 0 0 ];    % [ x y z ] Start position [ m m m ]
    sp.target           = [ 0 0 0 ];    % [ x y z ] Target position [ m m m ]
    sp.current_target   = [ 0 0 0 ];    % [ x y z ] Current Target position [ m m m ]
    sp.waypoints        = [];
    sp.timestep         = 0.1;          % [sec]     Iteration timestep
    sp.iteration_max    = 2000;         % [-]       Iteration max count
    
    %% map definitions
%     sp.map_filename     = 'pf_map_canal';% [string]  Map image filename
%     sp.map_filename     = 'pf_map_empty';% [string]  Map image filename
%     sp.map_filename     = 'pf_map_office';% [string]  Map image filename
%     sp.map_filename     = 'pf_map_doors';% [string]  Map image filename
    sp.map_filename     = 'pf_map_trees';% [string]  Map image filename
%     sp.map_scale        = 0.01;                  % [m/pixal] map image to real size ratio

    
    %% defined properties
    sp.scan_range           = 2.5;    % [m]       scan range radius
    sp.target_min           = 0.2;  % [m]       minimum acceptable range to target
    sp.current_target_min   = 0.5;  % [m]       minimum acceptable range to target
    
    %% analysis method switches
    sp.method.corner_points     = true;
    sp.method.bounding_box      = false;
    sp.method.bounding_circle   = false;
    
    
    
    %% initialize roll, pitch and yaw
    sp.init.roll    = 0;                % assuming flat terrain
    sp.init.pitch   = 0;                % assuming flat terrain
    sp.init.yaw     = 0; %(rand()-.5)*pi;   % random starting direction
%     sp.init.yaw     = -pi/4;   % random starting direction
    

    %% tangent force parameters
    sp.tan_use          = true;
    sp.tan_eta_tol      = 2;        % [deg] Heading tolerance
    sp.tan_vel_tol      = 0.0194;   % [m/s] Rover speed tolerance
    sp.tan_dir          = 0;        % [-]   Latching tangent direction
    sp.tan_gamma        = 1;
    sp.tan_gamma_cnt    = 0;
    
    %% obstacle force parameters
    sp.rsk_use          = true;
    sp.obs_use          = true;
    sp.obs_dist_buf     = 0.15;      % [m] Additional obstacle buffer distance
    sp.obs_power        = 2.1;   % [-] Obstacle Force Power
    sp.obs_wall         = 0.1;      % Equilibrium distance to wall 
    sp.obs_gain         = 60;      % [-] Proportional gain

    %% drag forces
    sp.dmp_use          = true;
%     sp.dmp_dist_stop    = 0.0851;      % Free coast stopping distance
%     sp.dmp_ang_stop     = 0.0620;      % Free spin stopping angle
    sp.dmp_dist_stop    = .25;      % Free coast stopping distance
    sp.dmp_ang_stop     = .5;      % Free spin stopping angle

    %% attractor forces
    sp.att_use          = true;
    sp.att_force_max_sat     = 90;
    sp.att_force_min_sat     = 10;
    
    %% force gain parameters
    sp.gain_damping_lin = 2;     % [-] Damping Force Linear Gain
    sp.gain_damping_ang = 10;     % [-] Damping Force Angular Gain
    sp.gain_tangent     = 0.05;      % [-] Tangential Force Gain
    sp.gain_risk        = 0.96;     % [-] Risk Force Gain
    sp.gain_attractor   = 2.5;        % [-] Target Force Gain
    
    %% Cost properties
    sp.cost.angle_factor    = 0.02;     % [-] Cost per rad of direction change
    sp.cost.length_factor   = 0.5;      % [-] Cost per normalized length
    sp.cost.time_factor     = 0.5;      % [-] Cost per normalized timestep
    sp.cost.range_factor    = 1;        % [-] Cost per normalized remaining range
    sp.cost.impact_factor   = 50;        % [-] Range factor modifier due to rover impact
    sp.cost.success_factor  = 0.5;
    
    %% Genetic Algorithm Parameters
    sp.ga.mate_thresh = 0.2; % 20% chance of random variation 
    
    %% Print/Display options
    sp.verbose          = 0; % [1|0] Display runtime logs or not
    sp.screen_size      = get(0, 'ScreenSize');
    sp.disp.live        = false;     % Display live tracing map
    sp.disp.live_cost   = false;
    sp.disp.overall     = false;     % Display final overal map
    sp.disp.generation  = true;
    
    sp.print.dir        = '~/.tmp/matlab'; % Output image dir
    sp.print.format     = '-depsc2';        % Output formatframes?
    
    sp.print.live       = false;            % Print out live map 
    sp.print.live_name  = sprintf('%s/gen-%%03_sim-%%03i_livemap_frame-%%04i.eps', sp.print.dir) ;
    sp.print.overall    = false;            % Print out overall map?
    sp.print.overall_name  = sprintf('%s/gen-%%03_sim-%%03i_overall.eps', sp.print.dir);
    sp.print.generation = false;
    sp.print.generation_name  = sprintf('%s/gen-%%03i_summary.eps', sp.print.dir);
    
    %% Comms Setup
    sp.comms.use_comms = false;
    sp.comms.sim.port = 2001;
    sp.comms.sim.host = 'localhost';
    sp.comms.mapper.port = 2002;
    sp.comms.mapper.host = 'localhost';
    
end
