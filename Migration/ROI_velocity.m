function [velocity]=ROI_velocity(xyt,metadata)
% xyt=trajectories of each ROIs in a cell array
% sp=sampling period
sp=1; % 1 minute interval
velocity=[];
for i=1:length(xyt)
    temp=xyt{i};
    %distance moved at each time frame
    dxy=temp(2:end,1:end)-temp(1:end-1,1:end); 
    %convert the xy cartesian coordinates to radial coordinate,
    %distance from the origin to a point in the x-y plane.
    [~,rad_coor]=cart2pol(dxy(:,1),dxy(:,2)); 
    temp1=rad_coor./sp;
    velocity=[velocity,temp1];
end

avg_velocity=mean(velocity,2);
avg_velocity_eachcell=mean(velocity,1);
max_velocity=max(max(avg_velocity_eachcell));
min_velocity=min(min(avg_velocity_eachcell));
mean_velocity=mean(avg_velocity_eachcell);
std_velocity = std(avg_velocity_eachcell,[],2);

% save data in excel sheet
[filename, pathname] = uiputfile( ...       
                 {'*.xlsx',  'excel files (*.xlsx)'; ...
                   '*.xls','excel file (*.xls)'}, ...             
                   'save average velocity profile','velocity of ROIs over time.xlsx');
               
%sheet 1 and 2 of the excel workspace                
xlswrite([pathname,filename],[velocity],'velocity over time');
xlswrite([pathname,filename],[avg_velocity],'mean velocity over time');

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
                
% figure;
% plot(avg_velocity,'k-', 'LineWidth', 1);
% xlim([0 10]);  ylim([0 3]); yticks([0:0.2:3]);
% xlabel('Time (min)'); ylabel('Mean Velocity (\mum/min)'); title('Mean Velocity Of All Cells Over Time');
end