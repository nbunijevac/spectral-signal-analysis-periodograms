function y = bt(x,f,M)
    N = length(x);
    rxx2 = zeros(1,N);
    for k = 1:N
        sum = 0;
        for n = 1:(N-k)
         sum = sum + conj(x(n))*x(n+k-1);
        end
        rxx2(k) = sum/N;
    end
    rxx1 = fliplr(conj(rxx2));
    rxx = [rxx1(1:(N-1)) rxx2];

    w = zeros(1,2*N-1);
    for k = -M:M
        w(N+k) = 1 - (abs(k))/M;
    end

    xx = zeros(1,2*N-1);
    xx = rxx.*w;

    Nf = length(f);
    p = zeros(1,Nf);
    n = -(N-1):(N-1);
    
    for i = 1:Nf
        p(i) = abs(xx*exp(-1i*2*pi*f(i)*n'));
    end
    
    y = p;

end

