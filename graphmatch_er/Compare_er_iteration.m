% Simulation with Synthetic Data and iteration
clear;
%% Parameter
N=10000;                        % number of vertices
p=1/N^(6/7);
s=0.9;
Beta=[0:0.05:1];
beta=round(Beta*N);
Iteration=3;                   % number of iteration
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
        
        
        pi_h=[(N+1-(1:betai)),randperm(N-betai)];
        Match=sparse(1:N,pi_h,1,N,N);               % initial seeds
        
        %%  1-hop
        pi_n=zeros(1,N);
        Match1=Match;
        for it=1:Iteration
            D1=W1*Match1*W2;
            MatchHop1;
            Match1=sparse(1:N,pi_n,1,N,N);
            correct(it,bi)=correct(it,bi)+sum(pi_n==truth)/N;
        end
        %% 2-hop
        
        pi_n=zeros(1,N);
        Match1=Match;
        for it=1:Iteration
            D1=W21*Match1*W22;
            MatchHop1;
            Match1=sparse(1:N,pi_n,1,N,N);
            correct(Iteration+it,bi)=correct(Iteration+it,bi)+sum(pi_n==truth)/N;
        end
        
        %% NoisySeeds
        Match1=Match;        
        r1=2-0.1;           % threshold of NoisySeeds
        for it=1:Iteration
            pi_n=zeros(1,N);
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
            correct(2*Iteration+it,bi)=correct(2*Iteration+it,bi)+sum(pi_n==truth)/N;
        end
       
    end
end

correct=correct/Ind;

%%
 
% figure;hold on;
% plot(beta1/log(2000)^(2/4)*(2000)^(1/4),corr(1,:),'ro-');
% plot(beta1/log(4000)^(2/4)*(4000)^(1/4),corr(2,:),'g*-');
% plot(beta1/log(6000)^(2/4)*(6000)^(1/4),corr(3,:),'b-s');
% plot(beta1/log(8000)^(2/4)*(8000)^(1/4),corr(4,:),'c-d');
% legend('n=2000','n=4000','n=6000','n=8000');
% xlabel('$\beta/\sqrt{np^3\log n}$','Interpreter','latex');ylabel('Accuracy Rate');

%%
figure;hold on;

plot(Beta,correct(4,:),'bo-','LineWidth',1);
plot(Beta,correct(5,:),'b*-','LineWidth',1);
plot(Beta,correct(6,:),'b-s','LineWidth',1);
plot(Beta,correct(7,:),'ko-.','LineWidth',1);
plot(Beta,correct(8,:),'k*-.','LineWidth',1);
plot(Beta,correct(9,:),'k-.s','LineWidth',1);
plot(Beta,correct(1,:),'ro--','LineWidth',1);
plot(Beta,correct(2,:),'r*--','LineWidth',1);
plot(Beta,correct(3,:),'r--s','LineWidth',1);

legend('2-hop L=0','2-hop L=1','2-hop L=2',...
    'NoisySeeds L=0','NoisySeeds L=1','NoisySeeds L=2','1-hop L=0','1-hop L=2','1-hop L=2');
xlabel('\beta');ylabel('Accuracy Rate');