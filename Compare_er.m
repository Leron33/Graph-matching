% Simulation with Synthetic Data
clear;
%% Parameter
N=10000;                        % number of vertices
p=1/N^(6/7);
s=0.9;
Beta=[0:0.05:1];
beta=round(Beta*N);
Ind=10;                          % number of independent experiments
correct=zeros(9,length(Beta));
%%
for ind=1:Ind
    ind
    for bi=1:length(Beta)
        betai=beta(bi);
        
        Renyimodel;                     % generate correlated ER graphs
        EYE=sparse(1:N,1:N,1,N,N);
        W21=double((double((W1*W1)>0)-W1-EYE)>0);   % 2-hop adjacency matrix
        W22=double((double((W2*W2)>0)-W2-EYE)>0);   
        truth=N+1-[1:N];                % the ground true mapping
        
        
        seed=[(N+1-(1:betai)),randperm(N-betai)];
        Match=sparse(1:N,seed,1,N,N);               % initial seeds
        
        %%  1-hop
        pi_n=zeros(1,N);
        Match1=Match;
        D1=W1*Match1*W2;
        MatchHop1;
        pi_h=pi_n;
        correct(1,bi)=correct(1,bi)+sum(pi_n==truth)/N;
        
        %% 2-hop
        
        pi_n=zeros(1,N);
        Match1=Match;
        D1=W21*Match1*W22;
        MatchHop1;
        pi_h=pi_n;
        correct(2,bi)=correct(2,bi)+sum(pi_n==truth)/N;
        
        %% NoisySeeds
        for r=2:4
            Match1=Match;
            pi_n=zeros(1,N);
            r1=r-0.1;           % threshold of NoisySeeds
            flag=1;
            while (flag)
                flag=0;
                NoisySeeds;
                pi_h=pi_n;
                ind1=1:N;
                ind1(pi_h==0)=[];
                pi_h(pi_h==0)=[];
                Match1=sparse(ind1,pi_h,1,N,N);
            end
            correct(r+1,bi)=correct(r+1,bi)+sum(pi_n==truth)/N;
        end
       
    end
end

correct=correct/Ind;

%%
figure;hold on;
plot(Beta,correct(2,:),'bo-');
plot(Beta,correct(3,:),'k-.s');
plot(Beta,correct(4,:),'k-.d');
plot(Beta,correct(5,:),'k-.o');
plot(Beta,correct(1,:),'r--o');
legend('2-hop','NoisySeeds r=2','NoisySeeds r=3','NoisySeeds r=4','1-hop');
xlabel('\beta');ylabel('Accuracy Rate');
%% 
% figure;hold on;
% plot(beta1/log(2000)^(2/4)*(2000)^(1/4),corr(1,:),'ro-');
% plot(beta1/log(4000)^(2/4)*(4000)^(1/4),corr(2,:),'g*-');
% plot(beta1/log(6000)^(2/4)*(6000)^(1/4),corr(3,:),'b-s');
% plot(beta1/log(8000)^(2/4)*(8000)^(1/4),corr(4,:),'c-d');
% legend('n=2000','n=4000','n=6000','n=8000');
% xlabel('$\beta/\sqrt{np^3\log n}$','Interpreter','latex');ylabel('Accuracy Rate');

%%
% figure;hold on;
% % plot(belta,belta,'--');
%
% % plot(beta1,corr(4,:),'bo-','LineWidth',1);
% % plot(beta1,corr(5,:),'b*-','LineWidth',1);
% % plot(beta1,corr(6,:),'b-s','LineWidth',1);
% % plot(beta1,corr(7,:),'ko-.','LineWidth',1);
% % plot(beta1,corr(8,:),'k*-.','LineWidth',1);
% % plot(beta1,corr(9,:),'k-.s','LineWidth',1);
% % plot(beta1,corr(1,:),'ro--','LineWidth',1);
% % plot(beta1,corr(2,:),'r*--','LineWidth',1);
% % plot(beta1,corr(3,:),'r--s','LineWidth',1);
%
% legend('2-hop L=0','2-hop L=1','2-hop L=2',...
%     'NoisySeeds L=0','NoisySeeds L=1','NoisySeeds L=2','1-hop L=0','1-hop L=2','1-hop L=2');%,'2-hop+ \beta=0.3','2-hop+ \beta=0.6','2-hop+ \beta=0.9');
% xlabel('\beta');ylabel('Accuracy Rate');