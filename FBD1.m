function  f = FBD1(A,x,y,absi)
m = size(A,2); n = size(A,3) ;
f = zeros(m,n);
if absi ==1
    A = abs(A);
end

for i =1:m
    for j = 1:n   
        f(i,j) = sum (A(x:y,i,j));
    end
end
            
end