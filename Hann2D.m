function [H2D] = Hann2D(cols,rows,mrg)

n1 = floor(rows*mrg);
n2 = floor(cols*mrg);
H = sym_hanning(n1);
W = sym_hanning(n2); 

A = [H(1:floor(size(H,1)/2))' ones(rows-size(H,1),1)' H(floor(size(H,1)/2)+1:end)']';
B = [W(1:floor(size(W,1)/2))' ones(cols-size(W,1),1)' W(floor(size(W,1)/2)+1:end)'];
H2D = A*B;
end

function w = sym_hanning(n)
if ~rem(n,2)
   % Even length window
   half = n/2;
   w = calc_hanning(half,n);
   w = [w; w(end:-1:1)];
else
   % Odd length window
   half = (n+1)/2;
   w = calc_hanning(half,n);
   w = [w; w(end-1:-1:1)];
end
end

function w = calc_hanning(m,n)
w = .5*(1 - cos(2*pi*(1:m)'/(n+1))); 
end