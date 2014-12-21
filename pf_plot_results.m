function pf_plot_results( results_set, doPrint, generations )
%PF_PLOT_RESULTS Animated plot of results from simulation
%   Plot the results of a single or multipel simulation analysis

if nargin == 1
    doPrint = false;
    generations = 1:length(results_set(:,1));
end

if nargin == 2
    generations = 1:length(results_set(:,1));
end

close all;

% only plot selected 

% plot the map
iter_max = results_set(1).sp.iteration_max;

% start parallel processing threads
if  matlabpool('size') == 0
    matlabpool open;
end

figure('Visible', 'off');

parfor set_idx = 1:length(results_set(:,1))
    if ~sum(generations == set_idx)
        continue;
    end
    
    fig = figure(1000+set_idx);
    
    
    set = results_set(set_idx,:);   % each generation
    
    [~, set_best_idx ] = min([set(:).cost]);
    
    max_set_len = 0;
    for ss = set
        l = length(ss.result( ss.result( ss.result(:,1)<intmax,1)>0,1));
        max_set_len = max([ l, max_set_len]);
    end
    
    % plot the map
    cla( fig );
    
    xlim([-2.5 22.5]);
    ylim([-2.5 22.5]);
    
    hold on;
    pf_plot_map_mfile( set(1).sp );
    axis square;
    
    
        
    plot_set_order = 1:length(set);
    plot_set_order(set_best_idx) = [];
    plot_set_order = [plot_set_order set_best_idx];
    
    cnt_success = 0;
    cnt_failure = 0;
        
    cnt_iter = 1;
    while cnt_iter < iter_max
        cnt_iter = cnt_iter + 1;
        
        len = 0;
        cnt_finished = 0;
        
        for sp_idx = plot_set_order    % each simulation
            sp = set(sp_idx);
            len = length(sp.result(sp.result(sp.result(:,1)<intmax,1)>0,1));

            if len < cnt_iter
                cnt_finished = cnt_finished + 1;
                continue;
            end
            
            fmt = 'b';
            if sp_idx == set_best_idx
                fmt = 'r';
            end
            
            if len > cnt_iter
                plot( sp.result(cnt_iter-1:cnt_iter,2), sp.result(cnt_iter-1:cnt_iter,3), fmt );
            end
            
            if len == cnt_iter
                if sp.result(end,1) == -intmax     % success flag
                    cnt_success = cnt_success + 1;
                    continue;
                elseif sp.result(end,1) == intmax  % failure flag
                    cnt_failure = cnt_failure + 1;
                    plot( sp.result(end-1,2), sp.result(end-1,3), 'rx' );
                else
                    plot( sp.result(end-1:end,2), sp.result(end-1:end,3), fmt );
                end
            end 
        end
        
        if cnt_finished == length(set)
            break;
        end
        
        title(sprintf('Generation #%3i - Iteration %4i/%-4i S: %2i F: %2i R: %2i/%i', ...
            set_idx, cnt_iter, max_set_len, cnt_success, cnt_failure, length(set)-cnt_finished, length(set)));
        xlabel('[meters]');
        ylabel('[meters]');
        getframe(fig);
        
        if doPrint
           fname = sprintf('~/.tmp/matlab/ga_results/gen%03i_iter%04i.fig', set_idx, cnt_iter);
           saveas(fig,fname);
           %fname = sprintf('~/.tmp/matlab/ga_results/gen%03i_iter%04i.eps', set_idx, cnt_iter);
           %print( '-depsc2', fname, fig );
        end
        
    end
    
    hold off;
end

if matlabpool('size') > 0
    matlabpool close;
end

end

