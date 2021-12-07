function y = per_sr(x,k,f)
    
    L = floor(length(x)/k);
    p = zeros(k, length(f));

        for i = 1:k
            a = L*(i-1)+1;
            b = L*i;
            u = x(a:b);
            p(i,:) = per(u,f);
        end
       
        y = zeros(1,length(f));    
        for i = 1:k
            y = y + p(i,:);
        end
       y = y/k;    
    end


