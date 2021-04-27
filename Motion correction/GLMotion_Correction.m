function [corrected_data] = GLMotion_Correction(raw_data,algorithm)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
T = size(raw_data,ndims(raw_data));
raw_data = raw_data - min(raw_data(:));
%% set parameters (first try out rigid motion correction)

options_rigid = NoRMCorreSetParms('d1',size(raw_data,1),'d2',size(raw_data,2),'bin_width',200,'max_shift',15,'us_fac',50,'init_batch',200);

%% perform motion correction
if strcmp(algorithm,'rigid')
    tic; [corrected_data,shifts,template,options_rigid] = normcorre(raw_data,options_rigid); toc
    p=1;
elseif strcmp(algorithm,'nonrigid')
    %% now try non-rigid motion correction (also in parallel)
    options_nonrigid = NoRMCorreSetParms('d1',size(raw_data,1),'d2',size(raw_data,2),'grid_size',[32,32],'mot_uf',4,'bin_width',200,'max_shift',15,'max_dev',3,'us_fac',50,'init_batch',200);
    tic; [corrected_data,shifts,template,options_nonrigid] = normcorre_batch(raw_data,options_nonrigid); toc
else
    error(message('Choose an algorithm: rigid or non-rigid'));
end
%% plot metrics
% [cY,mY,vY] = motion_metrics(raw_data,10);
% [cM1,mM1,vM1] = motion_metrics(corrected_data,10);
% T = length(cY);
% figure;
% subplot(2,2,1); plot(1:T,cY,1:T,cM1); legend('Raw data','Corrected','FontSize',7,'Location','southeast');legend('boxoff'); title('Correlation Coefficients','fontsize',11,'fontweight','bold');
% xlabel('Time','fontsize',10,'fontweight','bold'); ylabel('CC','fontsize',10,'fontweight','bold');
% subplot(2,2,2); scatter(cY,cM1); hold on; plot([0.9*min(cY),1.05*max(cM1)],[0.9*min(cY),1.05*max(cM1)],'--r'); axis square;
% xlabel('raw data','fontsize',10,'fontweight','bold'); ylabel('rigid corrected','fontsize',10,'fontweight','bold');
% subplot(2,2,3);imagesc(max(raw_data,[],3));title('Pre Motion Correction ','fontsize',11,'fontweight','bold');axis off;subplot(2,2,4);imagesc(max(corrected_data,[],3));title('Post Motion Correction','fontsize',11,'fontweight','bold');axis off;colormap hot

% plot a movie with the results
% nnY = quantile(raw_data(:),0.005);
% mmY = quantile(raw_data(:),0.995);
% figure;
% for t= 1:1:T
%     subplot(121);imagesc(raw_data(:,:,t),[nnY,mmY]); xlabel('raw data','fontsize',14,'fontweight','bold'); axis equal; axis tight;
%     title(sprintf('Frame %i out of %i',t,T),'fontweight','bold','fontsize',14); colormap('bone')
%     subplot(122);imagesc(corrected_data(:,:,t),[nnY,mmY]); xlabel('corrected','fontsize',14,'fontweight','bold'); axis equal; axis tight;
%     title(sprintf('Frame %i out of %i',t,T),'fontweight','bold','fontsize',14); colormap('bone')
%     set(gca,'XTick',[],'YTick',[]);
%     drawnow;
%     pause(0.02);
% end

end


