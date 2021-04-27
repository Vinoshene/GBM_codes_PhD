function[output,metadata]=load_mig_data(method,varargin)
[selection,path_in] = uigetfile ('*.*','Load Data');
selectedpath=[path_in selection];
%% Read in metadata from xml file
metafile = dir ([path_in '/*.xml']);
text = fileread([path_in '/' metafile.name]);
metadata.filename = selection;
metadata.path = path_in;
metadata.xdim = str2double(regexp(text, 'key="pixelsPerLine".*?value="(\d*)"', 'tokens','once'));
metadata.ydim = str2double(regexp(text, 'key="linesPerFrame".*?value="(\d*)"', 'tokens','once'));
metadata.micronpixel = str2double(regexp(text, 'key="micronsPerPixel_XAxis".*?value="(\d+\.\d*)"', 'tokens','once'));
pointerToTime = strfind(text,'absoluteTime=');
pointerToIndex = strfind(text,'index=');
pointerToIndex(1)=[];
nframes = length (pointerToTime);
for i=1:nframes
    shortText = text(pointerToTime(i):pointerToIndex(i));
    shorterText = extractBetween(string(shortText),'"','"');
    metadata.tpoints(i) = str2double(shorterText);
end
metadata.frames = nframes;
metadata.meanSP = (metadata.tpoints(end)-metadata.tpoints(1))/(nframes-1);
if strcmp(method,'excel')
    xyt=xlsread(selectedpath,1); 
end
output=xyt;
   
end