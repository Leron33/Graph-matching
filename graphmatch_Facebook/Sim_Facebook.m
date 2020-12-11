% Simulation with the Facebook
%%
clear
load Stanford3.mat;
s=0.9;alpha=0.8;
Beta=[0:0.1:1];
N=length(A(:,1));
correct=zeros(5,length(Beta));
Ind=10;
beta=round(Beta*N);
%% subsampling
sample=zeros(N,N);
for i=1:N
    for j=i+1:N
        g=rand<s;
        sample(i,j)=g;
        sample(j,i)=g;
    end
end
W1=A.*sample;
t1=rand(1,N)<alpha;
W1(t1==0,:)=0;W1(:,t1==0)=0;
W1=sparse(W1);

t2=rand(1,N)<alpha;
sample=zeros(N,N);
for i=1:N
    for j=i+1:N
        g=rand<s;
        sample(i,j)=g;
        sample(j,i)=g;
    end
end
W2=A.*sample;
W2(t2==0,:)=0;W2(:,t2==0)=0;
W2=sparse(W2);

t=t1.*t2;
N1=sum(t);
truth=(1:N).*t;

EYE=sparse(1:N,1:N,1,N,N);
W21=double(((double(W1*W1)>0)-W1-EYE)>0);
W22=double(((double(W2*W2)>0)-W2-EYE)>0);
%%

for ind=1:Ind
    ind
    for bi=1:length(Beta)
        beta1=beta(bi)
        
        seed=[randperm(N-beta1),(N-beta1+1):N];
        Match=sparse(1:N,seed,1,N,N);               % initial seeds
        
        %%  1-hop
        pi_n=zeros(1,N);
        Match1=Match;
        D1=W1*Match1*W2;
        MatchHop1;
        correct(1,bi)=correct(1,bi)+sum((pi_n==truth).*(pi_n>0))/N1;
        
        %% 2-hop
        
        pi_n=zeros(1,N);
        Match1=Match;
        D1=W21*Match1*W22;
        MatchHop1;
        correct(2,bi)=correct(2,bi)+sum((pi_n==truth).*(pi_n>0))/N1;
        
        %% NoisySeeds
        for r=2:4
            Match1=Match;
            r1=(r-1)*5-0.1;
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
            correct(r+1,bi)=correct(r+1,bi)+sum((pi_n==truth).*(pi_n>0))/N1;
        end
        
    end
end
%%
correct=correct/Ind;
%%
figure;hold on;
plot(Beta,correct(2,:),'b-o');
plot(Beta,correct(1,:),'ro--');
plot(Beta,correct(3,:),'k--s');
plot(Beta,correct(4,:),'k--d');
plot(Beta,correct(5,:),'k-o');

legend('2-hop','1-hop','NoisySeeds r=5','NoisySeeds r=10','NoisySeeds r=15');
xlabel('\beta');ylabel('Accuracy Rate');