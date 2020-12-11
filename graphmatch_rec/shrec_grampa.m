%-------------------------------------------------------------------------
% GRAMPA for SHREC 16 data (matching graphs of different sizes)
% generate matching for a pair of two graphs kid i - kid j
% Coded by Jiaming Xu Feb 2020
% Input: indices i and j for shapes to match
%        path_kids: % path to the complete TOPKIDS data set
%        track: % low or high resolution
%---------------------------------------------------------------------------------
function [curve]=shrec_grampa(i,j,path_kids,track)
%% load shapes in low resolution
M = load_off(strcat(path_kids,track, 'kid', num2str(i,'%02d'), '.off'));
N = load_off(strcat(path_kids,track, 'kid', num2str(j,'%02d'), '.off'));

V1=M.VERT;                  % 3-d coordinates of vertices
F1=M.TRIV;                  % face for triangulation
V2=N.VERT;
F2=N.TRIV;

adj1 = triangulation2adjacency(M.TRIV);     % adj after triangulation
adj2 = triangulation2adjacency(N.TRIV);
distances=geodesic_distance(N.TRIV,N.VERT); %Added by JX  
distances=sparse(distances);
n1=size(adj1,1);
n2=size(adj2,1);

%% GRAMPA
tic;
X = sparse(matching_robust_spectral((adj1), (adj2), 1));
P_sp = greedy_match(X);   
run_time_grampa=toc;
if n1<=n2
    init_idx1 = [1:size(adj1,1)]';
    idx2=1:size(adj2,1);
    init_idx2 = P_sp*idx2';   %contains nodes in adj2 corresponding to node i in adj1
    %visualization    
%    PlotResultAfterLocalMinimization(V1',F1',V2',F2',init_idx1,init_idx2,'source','target');
else
    init_idx2=[1:size(adj2,1)]';
    idx1=1:size(adj1,1);
    init_idx1=P_sp'*idx1';
%    PlotResultAfterLocalMinimization(V1',F1',V2',F2',init_idx1,init_idx2,'source','target');
end


%% Read ground truth
gt_M_null = read_correspondence(strcat(path_kids, track, 'kid', num2str(i), '_ref.txt'));
gt_N_null = read_correspondence(strcat(path_kids, track, 'kid', num2str(j), '_ref.txt'));
gt = merge_ground_truth(gt_M_null, gt_N_null);
%% compute matching errors based on Princeton protocol
corr_init=[init_idx1,init_idx2];
errors_init = zeros(size(corr_init,1), 1);
                     
            for m=1:size(corr_init,1)
                
                if (strcmp(track, 'low resolution/'))
                    gt_match = gt(gt(:,1) == corr_init(m,1), 2);
                    match = corr_init(m,2);
                    
                    if ~isempty(gt_match)                                                    
                        % using the geodesic distance of the second graph
                        errors_init(m) = distances(gt_match, match); % TODO include your geodesics here
                    else
                        errors_init(m) = -2;
                    end
                else
                    errors_init(m) = -1;
                end
                
            end

diameters = sqrt(sum(calc_tri_areas(N)));
errors_init = errors_init / diameters;
curve_init = zeros(1, length(thresholds));
for m=1:length(thresholds)
    curve_init(m) = 100*sum(errors_init <= thresholds(m)) / length(errors_init);
end

%% greedy improvement
P_rnd=zeros(n2,n1);
for ind=1:length(gt(:,1))
    P_rnd(gt(ind,2),gt(ind,1))=1;
end
P_rnd=sparse(P_rnd);

corr_sp=full(sum(dot(P_rnd,P_sp'))/length(errors_init));

tic;
iter_max=1;     
corr_spg=zeros(iter_max,1);
            % gradient descent
             r_old=corr_sp;
             S=P_sp';    
             
            for iter_count=1:1:iter_max
                X=adj2*S*adj1;
               
                [S,] = greedy_match(X);              
                r=full(sum(dot(P_rnd,S))/length(errors_init));
                if abs(r-r_old) <1e-6  %convergence criterion
                    break;
                end
                r_old=r;
                corr_spg(iter_count)=r;
            end
run_time_improv=toc;         
%% Store correspondence

if n1<=n2
    final_idx1 = [1:n1]';
    idx2=1:n2;
    final_idx2 = S'*idx2';
%        PlotResultAfterLocalMinimization(V1',F1',V2',F2',final_idx1,final_idx2,'source','target');
else
    final_idx2=[1:n2]';
    idx1=1:n1;
    final_idx1=S*idx1';
%        PlotResultAfterLocalMinimization(V1',F1',V2',F2',final_idx1,final_idx2,'source','target');
end

%% draw CDF plot
corr=[final_idx1,final_idx2];
            
            errors = zeros(size(corr,1), 1);
            
            for m=1:size(corr,1)
                
                if (strcmp(track, 'low_resolution/'))
                    gt_match = gt(gt(:,1) == corr(m,1), 2);
                    match = corr(m,2);
                    
                    if ~isempty(gt_match)                                                    
                        % using the second graph
                        errors(m) = distances(gt_match, match); % TODO include your geodesics here
                    else
                        errors(m) = -2;
                    end
                else
                    errors(m) = -1;
                end
                
            end
errors = errors / diameters;
curve = zeros(1, length(thresholds));
for m=1:length(thresholds)
    curve(m) = 100*sum(errors <= thresholds(m)) / length(errors);
end
%%  save data
save(strcat(path_kids,track, 'kid', num2str(i), '_kid', num2str(j), '.mat'),'corr_init','corr','corr_sp','corr_spg','errors_init','errors','curve_init','curve','run_time_grampa','run_time_improv');
