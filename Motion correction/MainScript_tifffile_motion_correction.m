clear all
clc

%load tiff file for motion correction
%a xml file containing the metadata should be in the folder of the tiff
%file

[raw_data,metadata] = load_data('tiff'); %calls the load function
disp('file loaded');

%rigid or nonrigid method can be done for motion correction
%for further details read NoRMCorre README file
[corrected_data] = GLMotion_Correction(raw_data,'rigid');
save_output(corrected_data,metadata,'data_MC');

%saves corrected file in tiff format
res = saveastiff(corrected_data, 'corrected_data.tif');