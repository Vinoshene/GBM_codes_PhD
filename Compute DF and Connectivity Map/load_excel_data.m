function [output,metadata] = load_data(method,URL,varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
if exist('URL','var')
else
    URL='';
end
[selection,path_in] = uigetfile ('*.*','Load Data',URL);
selectedpath=[path_in selection];
%% Read in metadata from xml file
metafile = dir ([path_in '/*.xml']);
text = fileread([path_in '/' metafile.name]);
metadata.filename = selection;
metadata.path = path_in;
metadata.xdim = str2double(regexp(text, 'key="pixelsPerLine".*?value="(\d*)"', 'tokens','once'));
metadata.ydim = str2double(regexp(text, 'key="linesPerFrame".*?value="(\d*)"', 'tokens','once'));
metadata.micronpixel = str2double(regexp(text, 'key="micronsPerPixel_YAxis".*?value="(\d+\.\d*)"', 'tokens','once'));
pointerToTime = strfind(text,'absoluteTime=');
% pointerToTime = pointerToTime + 13;     % Array of pointers to the beginning of the time stamp string
pointerToIndex = strfind(text,'index=');
pointerToIndex(1)=[];
nframes = length (pointerToTime);
for i=1:nframes
    shortText = text(pointerToTime(i):pointerToIndex(i));
    shorterText = extractBetween(string(shortText),'"','"');
    % remove '"' from start and end of string
    %shorterText = shorterText(2:end-1);
    metadata.tpoints(i) = str2double(shorterText);
end
metadata.frames = nframes;
metadata.meanSP = (metadata.tpoints(end)-metadata.tpoints(1))/(nframes-1);
%[xyct_img metadata] = import_PrairieTimeSequence(selectedpath);
if strcmp(method,'excel')
    timeseries=xlsread(selectedpath,1);
    try
        centroids=xlsread(selectedpath,2);
    catch
        centroids=[];
    end
    output.timeseries=timeseries;
    output.centroids=centroids;
end

