clear;close all;clc;
% pkg load io % For Octave only

%% Reading Excel file
% Open file dialog form
[fname,fpath,~]=uigetfile('*.xlsx');
% Read xls
xlsdat=xlsread([fpath,fname]);
outName=['PROCESSED',fname];
% Delete NaN rows
ind=isfinite(xlsdat(:,1));
xlsdat=xlsdat(ind,:);
% Delete NaN columns
ind=isfinite(xlsdat(1,:));
data=xlsdat(:,ind);
%% Converting time
% Number of sample
for n=1:length(data(1,:))/5;
    %
    tfull=data(:,1+5*(n-1))*24+data(:,2+5*(n-1));% Time in hours
    ind=find(data(:,5+5*(n-1))>=data(1,3));%>= "Positivity Threshold" in the input file
    t=tfull(ind);
    u=data(ind,5+5*(n-1));
    ufull=data(:,5+5*(n-1));
    t0ind=find(ufull>0);
    t0=tfull(t0ind(1));
    %% Determining the final stationary state
    ind=(diff(u)==0);
    % Delete intermediate stationary states
    ifs=find(diff(ind)~=0);
    if ~isempty(ifs)
        ind=ind*0;
        ind(ifs(end)+1:end)=1;
        ind=[0;ind];
        % Indices of the final stationary state
        indfs=find(ind==1);
        % The final stationary value
        K=mean(u(indfs));
        % Time moment of approaching a stationary state
        Ts=t(indfs(1));

        %% Gompertz's loglet parametrization
        U=-log(log(K./u));
%         indfin=isfinite(U);
%         U=U(indfin);
%         tU=t(indfin);
        % A part for fitting
        indg=find(U<=1);
        % Linear logfit fo the Gompertz model
        p=polyfit(t(indg),U(indg),1);
        % Gompertz's parameters
        r=p(1); % Growth rate
        td=-p(2)/r; % Shift
        % Gompertz function
        gompertz=@(t,K,r,td) K*exp(-exp(-r*(t-td)));

        %% Plots
        figure
        FntSz=12;
        plot(tfull,ufull,'.','color','blue','LineWidth',1)
        hold on
        plot(t0,ufull(t0ind(1)),'x','color','green','LineWidth',2,'MarkerSize',8)
        plot(Ts,u(indfs(1)),'x','color','red','LineWidth',2,'MarkerSize',8)
        tfit=t0:tfull(end);
        g=gompertz(tfit,K,r,td);
        plot(tfit,g,'-','color','black','LineWidth',1.5)
        plot(t(end),K,'color','white')% "Virtual curve" added to write in paramters in the legend
        plot(td,gompertz(td,K,r,td),'o','color','red','LineWidth',2)% "Virtual curve" added to write in paramters in the legend
        l=legend({'Experimental points',['t_0=',num2str(t0,2),' [u(t>t_0)>0]'],...
                  ['T_s=',num2str(Ts,3),', K=',num2str(K)],...
                  'Gompertz`s curve:',... 
                  'u=K*exp(-exp[-r*(t-t`)])',...    
                  ['r=',num2str(r,3),', t`=',num2str(td,3)]});
        set(l,'Location','southeast','FontSize',FntSz);
        xlabel('t, hours')
        ylabel('u(t), BACTEC growth units')
        title(['Sample #',num2str(n)])
        set(gca,'FontSize',FntSz)

        figname=['fig',fname,'_Sample',num2str(n)','.png'];
        print(figname,'-dpng')
        %% Processed experimental data for output

        % Generating Excel's numbered range
        flet(n)=floor(n/13);
        mlet(n)=mod(n,13);
        if mlet(n)==0
            mlet(n)=13;
            flet(n)=flet(n-1);
        end
        if flet(n)==0
            intlet1=char(63+2*mlet(n));
            intlet2=char(64+2*mlet(n));
        else
                intlet1=[char(64+flet(n)),char(63+2*mlet(n))];
                intlet2=[char(64+flet(n)),char(64+2*mlet(n))];
        end

        outData=[[0;0;tfull],[0;0;ufull]];
        outCell=num2cell(outData);
        outCell{1,1}='Sample #';
        outCell{1,2}=n;
        outCell{2,1}='t (hours)';
        outCell{2,2}='u (bactec u.)';
        outDataL=length(tfull)+2;
        outrangeData=['''',intlet1,num2str(1),':',intlet2,num2str(outDataL),''''];
        xlswrite(outName,outCell,1,outrangeData(2:end-1));
        %% Gompertz curve
        outDataG=[[0;0;tfit'],[0;0;g']];
        outCellG=num2cell(outDataG);
        outCellG{1,1}='Sample #';
        outCellG{1,2}=n;
        outCellG{2,1}='t (hours)';
        outCellG{2,2}='u(Gompertz) (bactec u.)';
        outGL=length(tfit)+2;
        outrangeG=['''',intlet1,num2str(1),':',intlet2,num2str(outGL),''''];
        xlswrite(outName,outCellG,2,outrangeG(2:end-1));

        %% Parameters
        outCellPar{1,1}='Sample #';
        outCellPar{1,2}=n;
        outCellPar{2,1}='Time of growth`s start:';
        outCellPar{2,2}=t0;
        outCellPar{3,1}='Time of reaching stationarity:';
        outCellPar{3,2}=Ts;
        outCellPar{4,1}='Maximal growth speed (r):';
        outCellPar{4,2}=r;
        outCellPar{5,1}='Moment of maximal growth (t`):';
        outCellPar{5,2}=td;
        outCellPar{6,1}='Stationary state (K):';
        outCellPar{6,2}=K;

        outrangePar=['''',intlet1,num2str(1),':',intlet2,num2str(6),''''];
        xlswrite(outName,outCellPar,3,outrangePar(2:end-1));
    end

end



