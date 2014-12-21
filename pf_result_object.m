function [ obj, cost, flags, forces, moment ] =  pf_result_object()

obj.isValid = false;        % flag to indicate process status

obj.time = 0;               % SIMULATION TIME
obj.walltime = clock();     % REAL WALL CLOCK TIME
obj.pose = [0 0 0 0 0 0];   % [ x y z roll pitch yaw ] 
obj.velocity = [0 0];       % [ Vx Omega ]

cost.total = 9999;         % total cost as of this iteration, large default
cost.angle = 0;         % angular cost
cost.length = 0;        % travel length cost
cost.time = 0;          % travel time cost
cost.range = 0;         % range to target cost
cost.travel_length = 0; % accumulated travel length
cost.remaining_dist = 9999; % remaining bee-line distance to goal 

flags.hasReachedTarget  = false;
flags.hasSuccess        = false;
flags.hasImpact         = false;
flags.hasScanViolation  = false;
flags.hasMinima         = false;
flags.hasSimCrash       = false;
flags.hasIterationLimit = false;

forces.net  = [0 0 0];
forces.att  = [0 0 0];
forces.obs  = [0 0 0];
forces.corners = [];
forces.rsk  = [0 0 0];
forces.dmp  = [0 0 0];
forces.tan  = [0 0 0];
 
moment.net  = [0 0 0];
moment.att  = [0 0 0];
moment.obs  = [0 0 0];
moment.corners = [];
moment.rsk  = [0 0 0];
moment.dmp  = [0 0 0];
moment.tan  = [0 0 0];

obj.flags = flags;
obj.cost = cost;
obj.force = forces;
obj.moment = moment;
 
end