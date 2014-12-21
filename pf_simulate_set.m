clear all; 
close all; 

showBars = false;

testCount = 4;          % Number of sims to run on each map
mapCount = 7;

% start parallel processing threads
if  matlabpool('size') ~= 0
    matlabpool('close');
end

matlabpool('open', 4);

TestMatrix = [ ...
     1 1 1 0 0 0; % PSP# obs att rsk dmp tan
     1 1 1 1 1 1;
     1 1 1 1 1 0;
    10 1 1 0 0 0;
    10 1 1 1 1 1;
    10 1 1 1 1 0;
    ];

if showBars
    multiWaitBar( 'CloseAll' );
    multiWaitBar( 'Simulation', 0, 'Color', [0.8 0 0]);
end

for TestSeriesIdx = 1:size(TestMatrix,1)
    if showBars
        multiWaitBar( 'Simulation', 'Increment', 1/size(TestMatrix,1) );
        multiWaitBar( 'Test Series', 0, 'Color', [0 0.8 0] );
    end
    
    fprintf(1,'TEST SERIES %i\n', TestSeriesIdx);
    
    % Set test series parameters
    sp = pf_properties_sim();
    sp.seed = 1000;
    sp.break_on_local_minima = true;

    sp.obs_use = TestMatrix(TestSeriesIdx,2);
    sp.att_use = TestMatrix(TestSeriesIdx,3);
    sp.rsk_use = TestMatrix(TestSeriesIdx,4);
    sp.dmp_use = TestMatrix(TestSeriesIdx,5);
    sp.tan_use = TestMatrix(TestSeriesIdx,6);

    % sp.gain_attractor   = 2.5;
    
    if TestMatrix(TestSeriesIdx,1) == 1
        sp.rover.corner_points = [0 0 0];
        sp.obs_dist_buffer = sum([ sp.rover.half_width sp.rover.half_length ].^2).^0.5;
    end


    for mapIdx = 1:mapCount
        if showBars
            multiWaitBar( 'Test Series', 'Increment', 1/mapCount);
        end
        fprintf(1,'  Map %i\n', mapIdx);
        res = {};
        sp.test_series = mapIdx;
        intNumStreams = mapCount*testCount;
        
        parfor resIdx=1:testCount
            ssp = sp;
            tStart = clock;
            fprintf(1,'    Running Simulation %i\n', resIdx);
            rng(randi(2^32-1));
            [rr, ap] = pf_simulation(ssp); 
            res{resIdx} = {rr,ap,etime(clock, tStart)};
        end
        
    
        % plot 
        intSuccess = pf_plot_results_cell_array(res); 

        xlabel 'X'; ylabel 'Y';
        
        if mapIdx == mapCount
            axis([-5 55 -5 55]);
        else
            axis([-5 25 -5 25]);
        end
        axis square;

        ap = cell2mat(res{1}(2));

        if ~(sp.att_use && sp.obs_use && sp.rsk_use && sp.dmp_use && sp.tan_use)
            if ~sp.att_use; fs_att = 'no_att_'; else fs_att = ''; end;
            if ~sp.obs_use; fs_obs = 'no_obs_'; else fs_obs = ''; end;
            if ~sp.rsk_use; fs_rsk = 'no_rsk_'; else fs_rsk = ''; end;
            if ~sp.dmp_use; fs_dmp = 'no_dmp_'; else fs_dmp = ''; end;
            if ~sp.tan_use; fs_tan = 'no_tan_'; else fs_tan = ''; end;
            fs = sprintf('%s%s%s%s%s', fs_att, fs_obs, fs_rsk, fs_dmp, fs_tan);
            fs = fs(1:end-1);
        else
            fs = 'all_forces';
        end

        fn = sprintf('images/series_test_%i_%s_%ipoint_%s_%i_%i', ...
                TestSeriesIdx, ...
                ap.map_filename(8:end), ...
                size(ap.rover.corner_points,1), ...
                fs, ...
                intSuccess, ...
                testCount );
        
        % set filenames
        fnMAT = [fn '.mat'];
        fnEPS = [fn '.eps'];
        fnPDF = [fn '.pdf'];
        fnPNG = [fn '.png'];
        
        % Save test results
        save(fnMAT, 'res');
        
        % Save plot as EPS
        print( gcf, '-deps2c', fnEPS );

        % Convert EPS to PDF as a matlab PDF is crap
        cmd = ['epstopdf ' fnEPS];
        [~, ~] = unix(cmd);
        
        % Convert PDF to PNG as a matlab PNG is crap
        cmd = ['convert -density 150 -geometry 100% ' fnPDF ' ' fnPNG];
        [~, ~] = unix(cmd);
        
    end
    
    if showBars
        multiWaitBar( 'Test Series', 'Close');
    end
end

if showBars
    multiWaitBar( 'Simulation', 'Close');
end

% shutdown parallel processing threads 
matlabpool('close');