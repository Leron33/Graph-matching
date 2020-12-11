W1=zeros(N,N);
W2=zeros(N,N);
for i=1:N
    for j=i+1:N
        if rand<p
            if rand<s
                W1(i,j)=1;
                W2(j,i)=1;
            end  
            if rand<s
                W1(N+1-i,N+1-j)=1;
                W2(N+1-j,N+1-i)=1;
            end  
        end
    end
end

W1=sparse(W1);
W2=sparse(W2);
