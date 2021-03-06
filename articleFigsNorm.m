clear;close all;clc;
FS=20;%Font size for figures
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Printing options
printfigures=1;% 1 - "print"; 0 - "do not print";
frmt='-dpdf';
res=300;%resolution in dpi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Funstions
Verhults=@(t,r,tm,K) K./(1+exp(-r*(t-tm)));

load allarticledata

N=40;
jinit=5;
tend=300;

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

figure
subplot(2,1,1)
plot(t(indj),log(K./u(indj)-1),'o','color','red','LineWidth',1)
hold on

p=polyfit(t(indj),log(K./u(indj)-1),1);
r=-p(1);
tm=p(2)/r;
tlin=linspace(t(indj(1))-10,t(indj(end))+10,100);

plot(tlin,polyval(p,tlin),'-','color','black','LineWidth',1.5)

xlim([t(1)-10 t(end)+10])
ylim([polyval(p,tlin(end))*1.25 polyval(p,tlin(1))*1.5])
xlabel('t, h')
ylabel('ln(K/u-1)')
set(gca,'FontSize',FS)

subplot(2,1,2)
plot(t,u,'.','color','green')
hold on
plot(t(indj),u(indj),'o','color','red')
tp=linspace(t(indj(1)),t(end),100);
plot(tp,Verhults(tp,r,tm,K),'--','color','black','LineWidth',1.5)

xlim([t(1)-10 t(end)+10])
ylim([0 K*1.1])
xlabel('t, h')
ylabel('u, u_{fit}, g.u.')
set(gca,'FontSize',FS)
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 10 8],'PaperSize',[10 8])

%% Printing figures
if printfigures==1

figure(1)
    print('NormUdiff',frmt,['-r',num2str(res)])    
figure(2)
    print('NormVerh',frmt,['-r',num2str(res)])
end
