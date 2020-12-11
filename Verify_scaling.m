% Simulation to verify scaling
clear;
%% Parameter
NV=[2000,4000,6000,8000];                       % number of vertices
PV=1./NV.^(6/7);
s=0.9;
scale=log(NV)./((NV.^2).*(PV.^2));
Beta=[0:0.05:1];
Ind=10;                          % number of independent experiments
correct=zeros(length(NV),length(Beta));
for ind=1:Ind
    ind
    for ni=1:length(NV)
        N=NV(ni);
        p=PV(ni);
        beta=round(Beta*N);
        pi_n=zeros(1,N);
        for bi=1:length(Beta)
            betai=beta(bi);
            
            Renyimodel;                     % generate correlated ER graphs
            EYE=sparse(1:N,1:N,1,N,N);
            W21=double((double((W1*W1)>0)-W1-EYE)>0);   % 2-hop adjacency matrix
            W22=double((double((W2*W2)>0)-W2-EYE)>0);
            truth=N+1-[1:N];                % the ground true mapping
            
            
            pi_h=[(N+1-(1:betai)),randperm(N-betai)];
            Match=sparse(1:N,pi_h,1,N,N);               % initial seeds
            
            %% algorihtm
            pi_n=zeros(1,N);
            Match1=Match;
            D1=W1*Match1*W2;            %1-hop
            % D1=W21*Match1*W22;       %2-hop
            MatchHop1;
            correct(ni,bi)=correct(ni,bi)+sum(pi_n==truth)/N;
            
        end
    end
end
correct=correct/Ind;
%%
figure;hold on;
plot(Beta,correct(1,:),'ro-');
plot(Beta,correct(2,:),'g*-');
plot(Beta,correct(3,:),'b-s');
plot(Beta,correct(4,:),'c-d');
legend('n=2000','n=4000','n=6000','n=8000');
xlabel('$\beta$','Interpreter','latex');ylabel('Accuracy Rate');
%% scaling
figure;hold on;
% plot(belta,belta,'--');
plot(Beta/PV(1),correct(1,:),'ro-');
plot(Beta/PV(2),correct(2,:),'g*-');
plot(Beta/PV(3),correct(3,:),'b-s');
plot(Beta/PV(4),correct(4,:),'c-d');
legend('n=2000','n=4000','n=6000','n=8000');
xlabel('$\beta/\frac{\log n}{n^2p^2}$','Interpreter','latex');ylabel('Accuracy Rate');