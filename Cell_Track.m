clear all
clc
%load excel file where the 1st-col:total number of rois, 2nd-col:cell id,
%3rd-col:x-coor & 4th-col:y-coor
[selection,path_in] = uigetfile ('*.*','Load Data'); 
selectedpath=[path_in selection];
cell_traj=importdata(selectedpath);
cell_traj=cell_traj.data;
cell_traj=cell_traj(:,2:end);

zoom1_um = 1.18823529411765;
zoom1_sp = 10;
% zoom2_um = 0.59401583497498;
% zoom2_sp = 60;

divide_traj=[];
num_ROIs=length(cell_traj)/zoom1_sp;
traj_coorxTemp = reshape(cell_traj(:,3),zoom1_sp,num_ROIs);
traj_coorxTemp = zoom1_um.*traj_coorxTemp;
traj_coorx = traj_coorxTemp - traj_coorxTemp(1,:);
traj_cooryTemp = reshape(cell_traj(:,4),zoom1_sp,num_ROIs);
traj_cooryTemp = zoom1_um.*traj_cooryTemp;
traj_coory = traj_cooryTemp - traj_cooryTemp(1,:);
traj_coory = -(traj_coory);


% figure;
% plot(traj_coorx,traj_coory,'k-', 'LineWidth', 0.5);
% grid on
% xlim([-15 15])
% ylim([-15 15])
% hold on
% plot(traj_coorx(end,:),traj_coory(end,:),'ko','MarkerSize', 4,'MarkerFaceColor','r')
% xlabel('x-axis(\mum)');ylabel('y-axis(\mum)');
% set(gca,'Fontsize',15)
%Center of mass
centerOfMassX = mean(traj_coorx(end,:));
centerOfMassY = mean(traj_coory(end,:));
centerOfMassX_start = mean(traj_coorx(1,:));
centerOfMassY_start = mean(traj_coory(1,:)); 
% plot(centerOfMassX,centerOfMassY,'o','MarkerSize', 5,'MarkerFaceColor','b')
% plot(centerOfMassX_start,centerOfMassY_start,'o','MarkerSize', 5,'MarkerFaceColor','g')

length_COM = sqrt(centerOfMassX^2 + centerOfMassY^2);

% Euclidean distance
EuclDist = sqrt(traj_coorx(end,:).^2 + traj_coory(end,:).^2);
max_EuclDist = max(EuclDist);
min_EuclDist = min(EuclDist);
mean_EuclDist = mean(EuclDist);
std_EuclDist = std(EuclDist,[],2);

% Accumulated distance.
% This is the sum of all Euclidean distances between each time point and
% the next.
AccDist = sum(sqrt(diff(traj_coorx,[],1).^2 + diff(traj_coory,[],1).^2),1);
max_AccDist = max(AccDist);
min_AccDist = min(AccDist);
mean_AccDist = mean(AccDist);
std_AccDist = std(AccDist,[],2);

%for start_end cell track
traj_coorx_start_end=traj_coorx([1 10],:);
traj_coory_start_end=traj_coory([1 10],:);
%%
figure; 
plot(traj_coorx_start_end,traj_coory_start_end,'k-','Color',[0.75 0.75 0.75],'LineWidth', 0.5);
grid on
xlim([-10 10])
ylim([-10 10])
% axis equal
hold on
plot(traj_coorx(end,:),traj_coory(end,:),'ko','MarkerSize', 4,'MarkerEdgeColor',[0.75 0.75 0.75],'MarkerFaceColor',[0.75 0.75 0.75])
plot([0,centerOfMassX],[0,centerOfMassY],'-','Color',[0.1 0.1 0.6],'LineWidth',3)
plot(centerOfMassX,centerOfMassY,'ko','MarkerSize', 8,'MarkerEdgeColor',[0.1 0.1 0.6],'MarkerFaceColor',[0.1 0.1 0.6])
xlabel('x-axis(\mum)');ylabel('y-axis(\mum)');
set(gca,'Fontsize',15)