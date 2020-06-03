clear;close all;clc;
% pkg load io % For Octave only

%% Reading Excel file
% Open file dialog form for the output file after readprocbactec.m
[fname,fpath,~]=uigetfile('*.xlsx');
% Read xls
xlsdat=xlsread([fpath,fname]);

for j=1:length(xlsdat(3,:))/2;
   t{j}=xlsdat(2:end,2*j-1);
   u{j}=xlsdat(2:end,2*j);
   ind{j}=find(u{j}>0);
   ind0{j}=find(not(u{j}>0));
   t1{j}=t{j}(2:end);
   un=u{j};
   un(ind0{j})=NaN;
   du{j}=diff(un);
   t1{j}=t1{j}(isfinite(du{j}));
   du{j}=du{j}(isfinite(du{j}));   
   t2{j}=t{j}(2:end-1);
   d2u{j}=diff(un,2);
   t2{j}=t2{j}(isfinite(d2u{j}));
   d2u{j}=d2u{j}(isfinite(d2u{j})); 

   std2u=std(d2u{j});
   jumps=find(d2u{j}>2*std2u);
   djumps=diff(jumps);
   
   dind=diff(ind{j});
   dindj=find(dind>1);
   Tdiv=[];
   for k=1:length(dindj);
       for m=1:length(jumps)-1;
           if not((dindj>jumps(m))&(dindj<jumps(m+1)))
               Tdiv=[Tdiv;jumps(m+1)-jumps(m)];
           end
       end
   end
   meanTdiv=mean(Tdiv);
   
   figure(j)
   FntSz=12;
   subplot(3,1,1)
   plot(t{j}(ind{j}),u{j}(ind{j}),'.')
   ylim([0,1.2*max(u{j}(ind{j}))])
   xlabel('t, hours')
   ylabel('u, g.u.')
   title(['Sample #',num2str(j),'; <T>=',num2str(meanTdiv),' hours'])
   set(gca,'FontSize',FntSz)
   subplot(3,1,2)
   plot(t1{j},du{j},'.')
   ylim([0,1.2*max(du{j})])
   xlabel('t, hours')
   ylabel('du/dt, g.u./hour')
   set(gca,'FontSize',FntSz)
   subplot(3,1,3)
   plot(t2{j},d2u{j},'.')
   hold on
   plot(t2{j}(jumps),d2u{j}(jumps),'o')
   ylim([-2*std2u,1.2*max(d2u{j}(jumps))])
   xlabel('t, hours')
   ylabel('d^2u/dt^2, g.u./hour^2')
   set(gca,'FontSize',FntSz)
   
   figname=['fig_jumps',fname,'_Sample',num2str(j)','.png'];
   print(figname,'-dpng')
end
