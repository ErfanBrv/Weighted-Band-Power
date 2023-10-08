function hanned_data = HannLAMB(data)
    [k,m,n] = size(data); % Note that the data should be normalized with the function you wrote
    hanned_data = zeros(k,m,n);
    for i = 1:m
        for j = 1:n
            hanned_data(:,i,j) = data(:,i,j).*hann(k);
        end
    end
end
