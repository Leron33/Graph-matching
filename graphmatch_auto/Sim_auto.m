% Simulation with the Autonomous Systems graphs
%%
clear;
load auto_sys_mat.mat;
W1=auto_sys_mat{1};
N1=sum(sum(W1)>0);
W1=W1(1:N1,1:N1);
EYE1=sparse(1:N1,1:N1,1,N1,N1);
W21=double((double((W1*W1)>0)-W1-EYE1)>0);
truth=1:N1;

Beta=[0.3:0.3:1];
correct=zeros(9,9);
beta=round(Beta*N1);
Ind=5;
%%
for g=1:9
    g
    W2=auto_sys_mat{g};
    N2=sum(sum(W2)>0);
    W2=W2(1:N2,1:N2);
    
    
    EYE2=sparse(1:N2,1:N2,1,N2,N2);
    W22=double((double((W2*W2)>0)-W2-EYE2)>0);
    
    for ind=1:Ind
        for bi=1:length(beta)
            beta1=beta(bi);
            
            seed=[randperm(N1-beta1),(N1-beta1+1):N1];
            Match=sparse(1:N1,seed,1,N1,N2);
            
            %% 1-hop
            pi_n=zeros(1,N1);
            Match1=Match;
            D1=W1*Match1*W2;
            MatchHop1;
            correct(bi,g)=correct(bi,g)+sum(pi_n==truth)/N1;
            
            %% 2-hop
            pi_n=zeros(1,N1);
            Match1=Match;
            D1=W21*Match1*W22;
            MatchHop1;
            correct(3+bi,g)=correct(3+bi,g)+sum(pi_n==truth)/N1;
            
            %% NoisySeeds
            Match1=Match;
            r1=2-0.1;           % threshold of NoisySeeds
            pi_n=zeros(1,N1);
            pi_n2=zeros(1,N2);
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
                ind1=1:N1;
                ind1(pi_h==0)=[];
                pi_h(pi_h==0)=[];
                Match1=sparse(ind1,pi_h,1,N1,N2);
            end
            correct(6+bi,g)=correct(6+bi,g)+sum(pi_n==truth)/N1;
            
        end
    end
    
    
end
correct=correct/Ind;



%%
Date=["3/31";"4/7";"4/14";"4/21";"4/28";"5/05";"5/12";"5/19";"5/26"];
figure;hold on;
% plot(belta,belta,'--');
plot(correct(6,:),'bo-','LineWidth',1);
plot(correct(5,:),'b*-','LineWidth',1);
plot(correct(4,:),'b-s','LineWidth',1);
plot(correct(3,:),'ro--','LineWidth',1);
plot(correct(2,:),'r*--','LineWidth',1);
plot(correct(1,:),'r--s','LineWidth',1);
plot(correct(9,:),'ko-.','LineWidth',1);
plot(correct(8,:),'k*-.','LineWidth',1);
plot(correct(7,:),'k-.s','LineWidth',1);
legend('2-hop \beta=0.9','2-hop \beta=0.6','2-hop \beta=0.3','1-hop \beta=0.9','1-hop \beta=0.6','1-hop \beta=0.3',...
    'NoisySeeds \beta=0.9','NoisySeeds \beta=0.6','NoisySeeds \beta=0.3');
xlabel('Date');ylabel('Accuracy Rate');

