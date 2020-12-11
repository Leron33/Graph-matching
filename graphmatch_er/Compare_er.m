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
            r1=r-0.1;
            pi_n=zeros(1,N);
            pi_n2=zeros(1,N);
            flag=1;
            while (flag)
                flag=0;
                D1=W1*Match1*W2;
                [pos_i,pos_j]=find(D1>r1);
                for match=1:length(pos_i)
                    if pi_n(pos_i(match))==0&&pi_n2(pos_j(match))==0
                        flag=1;
                        pi_n(pos_i(match))=pos_j(match);
                        pi_n2(pos_j(match))=pos_i(match);
                    end
                end
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
