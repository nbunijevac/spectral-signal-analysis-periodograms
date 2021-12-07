clc
clear all;
close all;

x = load('x3.csv');
%x = randn(256);
f = linspace(0,0.5,1000);
N = 256;
Nf = length(f);

%% zahtev 2

for i = 1:5
    k = ceil(50*rand(1));
    y = per(x(k,:),f);
    %mean(y);
    figure(1)
    title('Periodogrami za 5 nasumicno odabranih realizacija');
    plot(f,y); xlim([0 0.5]); ylabel('procena sgs'); xlabel('f');
    hold on;
end
%plot(f,mm,'k','Linewidth','2'); hold off;
    
%primecujemo da je signal visokoffrekventan, sa znacajnim vrednostima na
%|f|>0.3Hz/odb 

%% zahtev 3

k = [2 4 8 16 32];
pp= x(30,:);
y1 = per_sr(pp,k(1),f);
y2 = per_sr(pp,k(2),f);
y3 = per_sr(pp,k(3),f);
y4 = per_sr(pp,k(4),f);
y5 = per_sr(pp,k(5),f);
Kopt = 8;

figure(2)
plot(f,10*log10(y1)); hold on;
%plot(f,10*log10(y2)); hold on;
plot(f,10*log10(y3)); hold on;
%plot(f,10*log10(y4)); hold on;
plot(f,10*log10(y4)); hold off;
legend('K = 2','K = 8','K = 32'); xlim([0 0.5]);
title('Zatvaranje prozora'); 
xlabel('f'); ylabel('Per[dB]')

%% zahtev 4

M = floor([N/2 N/3 N/5 N/7 N/10]);
yb1 = bt(x(1,:),f,M(1));
yb2 = bt(x(1,:),f,M(3));
yb3 = bt(x(1,:),f,M(5));
Mopt = M(3);
%yb3 = per(x(1,:),f);

figure(3)
plot(f,10*log10(yb1),f,10*log10(yb2),f,10*log10(yb3));
legend('M = N/2','M = N/5','M = N/10'); title('Nalazenje optimalne vr. param. M');
xlabel('f'); ylabel('Per[dB]'); xlim([0 0.5]);

%% zahtev 5

%varijansa periodograma
per1 = zeros(50,Nf);
per2 = per1;
per3 = per2;
for i = 1:50
    per1(i,:) = per(x(i,:),f);
    per2(i,:) = per_sr(x(i,:),Kopt,f);
    per3(i,:) = bt(x(i,:),f,Mopt);
end
var1 = zeros(1,Nf);
var2 = zeros(1,Nf);
var3 = zeros(1,Nf);
%provera
%mm = zeros(1,Nf);
%meddi = zeros(1,Nf);
for i = 1:Nf
    var1(i) = var(per1(:,i));
    var2(i) = var(per2(:,i));
    var3(i) = var(per3(:,i));
%    mm(i) = sum(per1(:,i));
%    meddi(i) = median(per1(:,i));
end
%mm = mm/Nr;
%mm je pomocna promenljiva koja predstavlja srednju vrednost svih
%realizacija periodograma po frekvencijama

figure(4)
plot(f,var1,f,var2,f,var3); 
xlabel('f'); ylabel('varijanse');
title('Varijanse sva 3 periodograma');
legend('per', 'per.sr', 'bt'); xlim([0 0.5]);

med1 = median(var1);
med2 = median(var2);
med3 = median(var3);

%% zahtev 6

Nr = 50;
mean_p = zeros(1,Nf); 
for i = 1:Nf
    mean_p(i) = mean(per1(:,i));
end
var_ter = mean_p.^2;
%for i = 2:(Nf-1)
%    var_ter(i) = mean_p(i)^2*(1+sin(2*pi*N*f(i))/(N*sin(2*pi*f(i))));
%end
%DA LI OVAKO TREBA
%**********************************
figure(6)
plot(f,var_ter,f,var1); xlim([0 0.5]); legend('var analiticki','var usrednjavanjem','Location','northwest');

%% zahtev 7

Psr = per2(49,:);
a = 1-0.95;
Psrd = (2*Kopt/(chi2inv((1-(a/2)),2*Kopt)));
Psrg = (2*Kopt/(chi2inv((a/2),2*Kopt)));
p1 = 10*log10(Psr) + 10*log10(Psrd);
p2 = 10*log10(Psr) + 10*log10(Psrg);
figure(7)
for i = 1:50
    plot(f,10*log10(per2(i,:)),'b'); hold on; xlim([0 0.5]);
end
plot(f,10*log10(per2(49,:)),'g','LineWidth',2); hold on;
plot(f,p1,'r','LineWidth',2); hold on;
plot(f,p2,'r','LineWidth',2); hold off;
title('Interval poverenja usrednjenog periodograma');
xlabel('f'); ylabel('Per_sr[dB]'); xlim([0 0.5]);

%% zahtev 8

Pb = per3(20,:);
a = 1-0.95;
ni = 3*N/Mopt;
Pbd = 10*log10(ni/(chi2inv((1-(a/2)),ni)));
Pbg = 10*log10(ni/(chi2inv((a/2),ni)));
p1 = 10*log10(Pb) + 10*log10(Psrd);
p2 = 10*log10(Pb) + 10*log10(Psrg);
%p3 = 10*log10(Pb) - 10*log10(Psrd);
%p4 = 10*log10(Pb) - 10*log10(Psrg);
figure(8)
for i = 1:50
    plot(f,10*log10(per3(i,:)),'b'); hold on; xlim([0 0.5]);
end
plot(f,10*log10(per3(20,:)),'g','LineWidth',2); hold on; 
%plot(f,p3,'k','LineWidth',2); hold on;
%plot(f,p4,'k','LineWidth',2); hold on;
plot(f,p2,'r','LineWidth',2); hold on;
plot(f,p1,'r','LineWidth',2); hold off;
title('Interval poverenja BT');
xlabel('f'); ylabel('bt[dB]'); xlim([0 0.5]);

%% zahtev 9

z = zeros(50,64);
for i = 1:50
    z(i,:) = x(i,1:64);
end

per164 = zeros(50,Nf);
for i = 1:50
    per164(i,:) = per(z(i,:),f);
end
var164 = zeros(1,Nf);
for i = 1:Nf
    var164(i) = var(per164(:,i));
end

figure(9)
plot(f,var164,f,var1); 
xlabel('f'); ylabel('varijanse'); xlim([0 0.5]);
title('Varijanse periodograma');
legend('N = 64', 'N = 256');

%figure(10)
%plot(f,10*log10(per1(1,:)),f,10*log10(per164(1,:)));
%xlim([0 0.5]);
%figure(11)
%plot(f,per1(1,:),f,per164(1,:));xlim([0 0.5]);
%plot(f,10*log10(per164(1,:)),f,10*log10(per264(1,:)),f,10*log10(per364(1,:)));
%legend('per', 'per_sr', 'bt','per64', 'per_sr64', 'bt64'); xlim([0 0.5]);

med164 = median(var164);

