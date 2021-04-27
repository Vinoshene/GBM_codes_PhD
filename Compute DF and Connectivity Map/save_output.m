function save_output(file,metadata,string)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
matfile = strcat(metadata.path,'\GL_struct_',metadata.filename,'.mat');
save(matfile,'file'); 
message = strcat(string,'/',metadata.filename,'saved in',metadata.path);
disp(message);
end
