clear all
clc

%load excel file with the first sheet containing raw dF/F signals obtained
%from ImageJ (every column contains signal for 1 ROI): number of columns
%corresponds to the number of ROIs (cells) & second sheet containing
%centroids of ROIs (first column:x-coordinates;second column:y-coordinates)
%a xml file containing the metadata should be in the folder of the excel file

[raw_data,metadata] = load_data('excel'); %calls the load function
disp('file loaded');

nstd=1;
mindur=3;
[dFtimeseries,ROIs] = dFcomp(raw_data.timeseries,metadata.meanSP,nstd,mindur,raw_data.centroids); %computes dF/F
disp('dF computation complete');
figure;imagesc(dFtimeseries');colormap turbo; %generates a rastor plot

Corr_Thr=0.8; % correlation threshold between two traces
Connectivity_map(dFtimeseries,ROIs,metadata,Corr_Thr);

save_output(ROIs,metadata,'ROIs'); %saves data 
disp('Data saved');