D1=W1*Match1*W2;
[pos_i,pos_j]=find(D1>r1);
for match=1:length(pos_i)
    if pi_n(pos_i(match))==0
        flag=1;
        pi_n(pos_i(match))=pos_j(match);
    end
end

