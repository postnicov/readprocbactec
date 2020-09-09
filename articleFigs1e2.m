clear;close all;clc;
FS=20;%Font size for figures
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Printing options
printfigures=1;% 1 - "print"; 0 - "do not print";
frmt='-dpdf';
res=300;%resolution in dpi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Funstions
Gompertz=@(t,r,tm,K) K*exp(-exp(-r*(t-tm)));
Verhults=@(t,r,tm,K) K./(1+exp(-r*(t-tm)));

load allarticledata

N=46;
jinit=5;
tend=560;

    ind=find((xlsdat(:,N)>75)&(xlsdat(:,N-1)<tend));
    t=xlsdat(ind,N-1);
    u=xlsdat(ind,N);
K=max(u);
du=u*0;
d2u=u*0;
du(1:end-1)=diff(u,1);
d2u(2:end-1)=diff(u,2);
inddu0=find(du>1);

figure
subplot(3,1,2)
plot(t,du,'.-')

xlim([t(1)-10 t(end)+10])
%ylim([0 K*1.1])
xlabel('t, h')
ylabel('du/dt, g.u./h')
set(gca,'FontSize',FS)


subplot(3,1,3)
n=1:length(t);
indj=find((d2u(n(2:end-1))>d2u(n(1:end-2)))&(d2u(n(2:end-1))>d2u(n(3:end)))&(d2u(2:end-1)>10));
indj=indj(jinit:end)+1;
plot(t,d2u,'.-')
hold on
plot(t(indj),d2u(indj),'o')

xlim([t(1)-10 t(end)+10])
ylim([1.6*min(d2u) max(d2u)*1.6])
xlabel('t, h')
ylabel('d^2u/dt^2, g.u./h^2')
set(gca,'FontSize',FS)


subplot(3,1,2)
hold on
plot(t(indj),du(indj),'o')
subplot(3,1,1)
plot(t,u,'.')
hold on
plot(t(indj),u(indj),'o')

xlim([t(1)-10 t(end)+10])
ylim([0 K*1.1])
xlabel('t, h')
ylabel('d, g.u.')
set(gca,'FontSize',FS)
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 8 8],'PaperSize',[8 8])

figure(2)
subplot(3,1,2)
plot(t(1:5:end),log(log(K./u(1:5:end))),'x','color','blue','LineWidth',1)
hold on

indG=find(t<240);
p=polyfit(t(indG),log(log(K./u(indG))),1);
r=-p(1);
tm=p(2)/r;
tlin=linspace(t(1)-10,t(end)+10,100);

plot(tlin,polyval(p,tlin),'-','color','red','LineWidth',1.5)

xlim([t(1)-10 t(end)+10])
ylim([polyval(p,tlin(end))*1.25 polyval(p,tlin(1))*1.5])
xlabel('t, h')
ylabel('ln(ln(K/u))')
set(gca,'FontSize',FS)

subplot(3,1,1)
plot(t(1:5:end),log(K./u(1:5:end)-1),'x','color','blue','LineWidth',1)
hold on

indG1=find((t>240)&(t<320));
p=polyfit(t(indG1),log(K./u(indG1)-1),1);
r1=-p(1);
tm1=p(2)/r1;
tlin=linspace(t(1)-10,t(end)+10,100);

plot(tlin,polyval(p,tlin),'-','color','black','LineWidth',1.5)

xlim([t(1)-10 t(end)+10])
%ylim([polyval(p,tlin(end))*1.25 polyval(p,tlin(1))*1.5])
xlabel('t, h')
ylabel('ln(K/u-1)')
set(gca,'FontSize',FS)


subplot(3,1,3)
plot(t,u,'.','color','green')
hold on
plot(t,Gompertz(t,r,tm,K),'-.','color','red','LineWidth',1.5)
plot(t,Verhults(t,r1,tm1,K),'--','color','black','LineWidth',1.5)

xlim([t(1)-10 t(end)+10])
ylim([0 K*1.1])
xlabel('t, h')
ylabel('u, u_{fit}, g.u.')
set(gca,'FontSize',FS)
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 8 8],'PaperSize',[8 8])

%% Printing figures
if printfigures==1

figure(1)
    print('Dil1e2Udiff',frmt,['-r',num2str(res)])    
figure(2)
    print('Dil1e2VerhGomp',frmt,['-r',num2str(res)])
end
