function [dFtimeseries,ROIs,metadata] = dFcomp_stats(timeseries,sp,nstd,mindur,centroids,metadata,varargin)
%   Summary of this function goes here...
%   Timeseries:Rows:fluo fluctuaton over time;Columns:ROIs
%   Sp: sampling period in seconds
%   Centroid : n-by-2 matrix where n=ROIS; column:XY coordinate
%   Nstd: degree of standard deviations, used in order to find distrete calcium events
%   Mindur: min duration required for a discrete event in oder to be
%   considered interesting

if exist('centroids','var')
else
    centroids=zeros(size(timeseries,2),2);
end
mindur=ceil(mindur./sp);
nstd=1;
% This can be either quantile or min
dFMode = 'min';
switch dFMode
    case 'min'
        Fmin=min(movmean(timeseries,3,1),[],1); %similar to smoothing the timeseries to obtain Fmean
        dFtimeseries=(timeseries-Fmin)./Fmin;   %deltaf/F computation
    case '10thquant'
        Fmin=quantile(timeseries,0.1,1);
        dFtimeseries=(timeseries-Fmin)./Fmin;
    case '20thquant'
        Fmin=quantile(timeseries,0.05,1);
        dFtimeseries=(timeseries-Fmin)./Fmin;
end
[dFmean,dFstdev] = normfit(dFtimeseries);   %normal distribution of deltaF fluctuation for each ROI. We need this for timeseries binarization based of std. Remember that this is done for each ROI separately, in this way we don't make any bad assumption. 
threshold=dFmean+(nstd.*dFstdev);       %threshold decision. Check the matrix, is not a unique number, but each ROI has its own threshold
timeseries_IO=dFtimeseries>=threshold;
i=1;
for j=size(timeseries_IO,2):-1:1       %backward for loop! / To preallocate a structure, with the inverse for loop with start from the end and we go backward. In this way at the first iteration we also preallocate the structure
    if nnz(timeseries_IO(:,j))
    stats=regionprops3(timeseries_IO(:,j),dFtimeseries(:,j),'Volume','MaxIntensity','MeanIntensity','MinIntensity'); %the two entries are the two representations of the same vector (ROI).Volume of a binary event is the duration of the event. Similar for max and mean event. Computing the features of each calcium event.
    stats=table2array(stats);
    stats=stats(stats(:,1)>=mindur,:); %filtering for the min event duration
    if size(stats,1)>0    %in order to account also for the timeseries with no interesting events. Timeseries like this, should be very few thanks to the particular ROI selection that we use
        ROIs(i).DeltaF=dFtimeseries(:,i);
        ROIs(i).Space=centroids(i,:);
        ROIs(i).Durations=stats(:,1).*sp;
        ROIs(i).MeanDuration=(mean(stats(:,1),'all')).*sp;
        ROIs(i).MeanInt=stats(:,2);
        ROIs(i).MeanMeanInt=mean(stats(:,2),'all'); %Mean of overall event in a single Roi
        ROIs(i).MinInt=stats(:,3);
        ROIs(i).MeanMinInt=mean(stats(:,3),'all'); %Mean of the max intensity of a single Roi
        ROIs(i).NofEvents_sec=size(stats,1)./(size(timeseries,1).*sp); %Frequency in Hz
        ROIs(i).MaxInt=stats(:,4);
        ROIs(i).MeanMaxInt=mean(stats(:,4),'all');
        ROIs(i).Amplitude=findpeaks(dFtimeseries(:,i),'MinPeakHeight',0.2,'MinPeakDistance',20);
        ROIs(i).MeanAmplitude=mean((ROIs(i).Amplitude),'all');
%         ROIs(i).RealDuration=findchangepts(smooth(smooth(smooth(dFtimeseries(:,i)))),'Statistic','rms','MinThreshold',50);
        ROIs(i).ChangePts=findchangepts(smooth(movmean(dFtimeseries(:,i),3)),'Statistic','rms','MinThreshold',50);
        ROIs(i).MeanIntegral=mean(dFtimeseries(:,i));
        ROIs(i).MaxAmplitude=max(ROIs(i).Amplitude);
    end
    end
    i=i+1;
end
end
