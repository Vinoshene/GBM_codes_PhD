function [meanMSD,msd]=ROI_MSD(xyt,metadata)
% xyt=trajectories of each ROIs in a cell array
% sp=sampling period
% MSD(tau)=<(x(t+tau)-x(tau))^2+(y(t+tau)-y(t))^2>
sp=1;% 1 minute interval
num_ROIs=length(xyt);
[frames,~]=size(xyt{1});
msd=zeros(frames-1,num_ROIs);
for i= 1:num_ROIs
    temp=xyt{i};
    row=size(temp,1);
    msd_xi=zeros(row-1,1);
     for j=1:(row-1)
        dx=temp(1+j:end,1)-temp(1:end-j,1);
        msd_xi(j)=mean(dx.^2,1);  
     end
    msd_xi=msd_xi(:);
    msd_yi=zeros(row-1,1);
     for k=1:(row-1)
        dy=temp(1+k:end,2)-temp(1:end-k,2);
        msd_yi(k)=mean(dy.^2,1);
     end
    msd_yi=msd_yi(:);
    msd_i=msd_xi+msd_yi; 
    msd(:,i)=msd_i(:);
end
 meanMSD=mean(msd,2);
 stdMSD = std(msd,[],2);
 semMSD = stdMSD/size(msd,2);
 t_frames=[1:length(meanMSD)]'.*sp;
 
 %save data in excel sheet
[filename, pathname] = uiputfile( ...       
                 {'*.xlsx',  'excel files (*.xlsx)'; ...
                   '*.xls','excel file (*.xls)'}, ...             
                   'save MSD results','Mean Squared Displacement.xlsx');
               
%sheet 1 and 2 of the excel workspace                
xlswrite([pathname,filename],[t_frames,msd],'Individual ROI MSD');
xlswrite([pathname,filename],[t_frames,meanMSD],'Mean MSD');

%delete the empty first sheet since its automatically generated
newExcel = actxserver('excel.application');
excelWB = newExcel.Workbooks.Open([pathname,filename],0,false);
newExcel.Visible = true;
newExcel.DisplayAlerts = false;
excelWB.Sheets.Item(1).Delete;
excelWB.Save();
excelWB.Close();
newExcel.Quit();
delete(newExcel);
 
%plot mean ensemble msd (of all ROIs over time)
figure;
% loglog(t_frames,meanMSD,'-ko','LineWidth',1,'MarkerSize',5);
errorbar(t_frames,meanMSD,semMSD,'-ko','LineWidth',1,'MarkerSize',5)
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
grid on
% xlim([1 1e1])
% ylim([5 1e2])
xlabel('Time Lag (s)'); ylabel('MSD (\mum^2)'); title('Mean Ensemble MSD');

end
 