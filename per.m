function y = per(x,f)

    N = length(x);
    Nf = length(f);
    p = zeros(1,Nf);
    n = 0:(N-1);
    
    for i = 1:Nf
        p(i) = (abs(x*exp(-1i*2*pi*f(i)*n')))^2;
    end
    p = p/N;
    
    y = p;

end