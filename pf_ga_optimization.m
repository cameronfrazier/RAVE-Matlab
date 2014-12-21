%
% Genetic Optimization of Potential Field Navigation Parameters
% 
%   Author: Cameron Frazier
%           2013-03-05
%

clear all;
close all;

% process timer
t.start = clock();

% Max number of generations
num_gens = 4;

% Number of simulations per generation
num_sims = 16;

% number of overall best genes
num_best    = ceil(num_sims/10);

% number of fit genes to mate between generations
num_fit     = ceil(num_sims/4);

% number of costs (total + length(ele_cost(1,:)) )
num_costs   = 5;

% ramdomizing parameters
% normal distribution with mean and std.dev of sigma 
mean = 1.0;
sigma = 0.25;

% get sim settings
sp = pf_properties_sim();


% turn off per step/simulation displays (for speed and sanity)
sp.disp.live    = false;
sp.disp.overall = true;
sp.print.generation = false;
sp.verbose = false;


params = {  'tan_eta_tol', ...
            'tan_vel_tol', ...
            'obs_power', ...
            'obs_wall', ...
            'dmp_dist_stop', ...
            'dmp_ang_stop', ...
            'gain_tangent', ...
            'gain_risk', ...
            'att_force_max_sat', ...
            'att_force_min_sat', ...
            };
num_param = length(params);
        
% initialize overall best performing sim
best.sp = sp;
[ ~, best.cost ] = pf_result_object();
best.ele_cost = Inf*[1 1 1 1];
best.result = 0;


best_set(num_best)  = best;
for i = 1:num_best
    best_set(i) = best;
end

fit_set(num_fit)    = best;
for i = 1:num_fit
    fit_set(i) = best;
end

psp(num_sims)       = best;
for i = 1:num_sims
    psp(i) = best;
end

results_set(num_gens,num_sims) = best;
for i = 1:num_gens
    for j = 1:num_sims
        results_set(i,j) = best;
    end
end

% Initialize data storage
gene_history_best   = zeros(num_gens, num_param + num_costs);
gene_history_fit    = zeros(num_gens, num_param + num_costs);
gene_history_avg    = zeros(num_gens, num_param + num_costs);

% start parallel processing threads
if  matlabpool('size') == 0
    matlabpool open;
end

% initialize generation counter
gen = 0;

for gen = 1:num_gens
    
    % zero out generation costs
    costs   = zeros(num_sims,1);
    
    % random yaw for generation 
    sp.init.yaw = pi*(2*rand()-1);
    
    % initialize seed to be equal over all simulaitons
    sp.seed = 1000; %randi(intmax);
    sp.use_seed = true;
    
    % random shift to start point for generation
    sp.start  = [ randn() rand() 0 ]*3;   % 3-sigma coverage of [-1 1]
    sp.target = [ randn() rand() 0 ]*3;   % 3-sigma coverage of [-1 1]
    
    % load sim map
    % this allows for random map per generation if supported
%     sp.map = pf_map_load_mfile( sp );
    
    % info on this generation
    fprintf(1,'Generation %3i:\n', gen);
    fprintf(1,' Setting psp(*).init.yaw: %.2f\n', sp.init.yaw);
    
    % set half of children to the fitest set
    % note, here, fit_set(1:2) == best_set
    % mutate the rest via random mating via averaging+noise
    for i = 1:num_sims
        % update random factor (must be positive)
        factor = abs( mean + sigma .* randn() );

        % generate a child
        if gen == 1
            % generate variant children for first generation
            psp(i) = pf_ga_mate(sp, psp, factor);
        elseif gen ~= 1 && i > length(fit_set)
            % generate variants from fit_set 
            psp(i) = pf_ga_mate(sp, fit_set, factor);
        else
            % load fittest (including overal best)
            psp(i)	= fit_set(i);
        end

        psp(i).sp.idx       = i;
        psp(i).sp.gen       = gen;
        psp(i).sp.init.yaw  = sp.init.yaw;
        psp(i).sp.start     = sp.start;
        psp(i).sp.target    = sp.target;
%         psp(i).sp.map       = sp.map;
        psp(i).sp.use_seed  = sp.use_seed;
        psp(i).sp.seed      = sp.seed;

    end
    
    status = zeros(1,num_sims);
    
    parfor i = 1:num_sims
        [ psp(i).result, psp(i).sp ]      = pf_simulation(psp(i).sp);
        [ psp(i).cost ] = pf_cost_calc(psp(i).sp, psp(i).result);
    end
    
    %% Artifical Selection
    
    % filter out bad simulations
%     for p = psp
%         psp = psp( [psp(:).isValid] );
%     end
    
    % if the whole generation failed, create new children from 
    % old fit_set
    if isempty(psp)
        continue;
    end
    
    % sort psp to find the fittest, independant from the overall best
    sorted_psp = sortByCost(psp);
    
    % append best to psp, sort based on cost, take top num_fit elements
    % this will maintain the overall best, and take the fittest from the
    % simulations
    fit_psp = psp;
    for i = fit_set(1:num_best)
        fit_psp(end+1) = i;
    end
    
    fit_psp = sortByCost(fit_psp);
    
    for i = 1:num_fit
        % if fit_psp is shorter than old fit_set
        if i > length(fit_psp)
            % if we've reached the end of a short fit_set
            if i > length(fit_set)
                break;
            end
            % remove extra fit_set
            fit_set(i) = [];
        else
            % or assign to fit_set
            fit_set(i) = fit_psp(i);
        end
    end
    
    %% Display Generation plots
    
    % Calculate gene limits and averages for plotting
%     [ overall_best, gen_fittest, gen_avg ] = pf_ga_gene_summary( sorted_psp, fit_psp );
%     
%     gene_history_best(gen,:)  = overall_best;
%     gene_history_fit(gen,:)   = gen_fittest;
%     gene_history_avg(gen,:)   = gen_avg;
%
%     gene_history_norm_best(gen)
%     gene_history_norm_fit(gen)
%     gene_history_norm_avg(gen)
%
%
    
    % plot generation/printing
    if sp.disp.generation || sp.print.generation
        figure(100+gen);
        clf;
        
%         subplot(1,2,1),
        hold on
        % plot the map
        ap = sorted_psp(1).sp;
        pf_plot_map_mfile( ap );

        % plot the non-fittest simulations
        for i = sorted_psp(2:end)
            r = reshape([i.result.pose],6,length([i.result.pose])/6)';
            plot(r(:,1), r(:,2), 'b');
        end

        % plot the fittest simulation
        r = reshape([sorted_psp(1).result.pose],6,length([sorted_psp(1).result.pose])/6)';
        plot(r(:,1), r(:,2), 'g');

        % plot the overall best simulation thus far
        r = reshape([fit_set(1).result.pose],6,length([fit_set(1).result.pose])/6)';
        plot(r(:,1), r(:,2), 'r');

        hold off
        title_str = sprintf('Generation %i', gen);
        title(title_str)
        axis([-2.5 ap.map.size(1)+2.5 -2.5 ap.map.size(2)+2.5]);
        axis square;
        
        
%         subplot(1,2,2),
%         pf_ga_plot_history(gene_history_best, gene_history_fit, gene_history_avg);
        
        getframe();

        if sp.print.generation
            file_name = sprintf(sp.print.generation_name, gen);
            print(sp.print.format, file_name, gcf);
        end
    end
    
    % Store generation results
    results_set(gen,1:length(psp)) = psp;
    
end

if matlabpool('size') > 0
    matlabpool close;
end


% Elapsed Time
t.end = clock();
fprintf('GA finished in %.1fs\n', etime(t.end, t.start));