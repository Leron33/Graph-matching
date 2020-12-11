[m, n] = size(D1);
MN = m * n;

x = D1(:);

minSize = min(m, n);
%minSize=N;
usedRows = zeros(m, 1);
usedCols = zeros(n, 1);

maxList = zeros(minSize, 1);
row = zeros(minSize, 1);
col = zeros(minSize, 1);

[y, ix] = sort(x, 'descend');
matched = 1;
index = 1;
while (matched <= minSize)
    ipos = ix(index); % position in the original vectorized matrix
    jc = ceil(ipos / m);   
    ic = ipos - (jc - 1) * m;
    if ic == 0, ic = 1; end
    if (usedRows(ic) ~= 1 && usedCols(jc) ~= 1 ) 
        matched;
        row(matched) = ic;
        col(matched) = jc;
        pi_n(ic)=jc;
		maxList(matched) = x(index);
		usedRows(ic) = 1;
		usedCols(jc) = 1;
		matched = matched + 1;
    end
    index = index + 1;
end
data = ones(minSize, 1);

M = sparse(row, col, data, m, n);

