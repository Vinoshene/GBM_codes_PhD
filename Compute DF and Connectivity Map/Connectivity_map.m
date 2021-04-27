function [SI_triangle,Coor_pair,Coor_pair1,SI,SI_vector] = Connectivity_map(dFtimeseries, ROIs,metadata,Corr_Thr)
   % dFtimseries : dF/F of ROIs
   % ROIs : regions of the interest/cells 
   
    avg=dFtimeseries;
    SI=[];
    Rw = [];
    Col = [];

    for k=1:size(avg,2)-1
        for j=1:k+1
            if(k<j)
%         for j=k+1:size(avg,2)
            a=avg(:,k);
            b=avg(:,j:end);
            temp=abs(corr(a,b));
            SI=[SI;{temp}];
            end
        end
    end

    for i = 1:size(SI,1)
        [row,col] = find(cell2mat(SI(i))>= Corr_Thr);
        Rw = [Rw; {row}];
        Col = [Col; {col}];
    end

    for i = 1: size(Rw,1)
        emptyCells = cellfun(@isempty,Rw(i)); % check if the cell is empty
        if  emptyCells ~=0 
           Rw(i) = {[0,0]}; % replace the empty cells with vector of zeros 
           Col(i) = {[0,0]};
        else
            Rw(i) ={i*cell2mat(Rw(i))}; %multiply the indexes with its respective number of rows
            Col(i) ={cell2mat(Col(i))+i};% to respect the number of correlated cells
        end
    end

    % Vectorize all the cell set
    NewRw = [Rw{:}];
    NewCol = [Col{:}];
    New_matrix = [NewRw; NewCol]'; %create a matrix with corelated paired idx
    Coor_pair = []; 
    Coor_pair1 = [];
    for k = 1 : size(New_matrix,1)
        %for l = 1 : size(New_matrix,1)
         idx_col1 = New_matrix(k,1); % select indexes
         idx_col2 = New_matrix(k,2);
         if (idx_col1  ~=0 &&  idx_col2~=0)
           Coor_pair  = [Coor_pair ;{ROIs(idx_col1).Space}]; %extract the coordinated of the paired cells
           Coor_pair1 = [Coor_pair1;{ROIs(idx_col2).Space}];
         end
    end
     %Below: To obtain ALL the original cell coordinates (correlated &
     %uncorrelated in order to draw the map
    R = [];
    for j = 1:size(avg,2)
        R =[R; {ROIs(j).Space}];
    end
    [x2,y2] = Create_coordinates(R);
    x2 = x2.*metadata.micronpixel;
    y2 = y2.*metadata.micronpixel;
     %%
    % [z,t] = Create_coordinates(Coor_pair ); %coordinates of first column of correlated cells
    % [x,y] = Create_coordinates(Coor_pair1); %coordinates of second column of correlated cells
    % % 
    Vector_matrix=cell2mat(Coor_pair);
    Vector_matrix1=cell2mat(Coor_pair1);
    Vector_matrix = Vector_matrix.*metadata.micronpixel;
    Vector_matrix1 = Vector_matrix1.*metadata.micronpixel;
    S=[Vector_matrix(:,1),Vector_matrix1(:,1)]; %combine the x-axis 
    Y=[Vector_matrix(:,2),Vector_matrix1(:,2)]; %combine two y-axis
    
    figure; % hold all connected cells 
    for k = 1:length(S)
         plot(S(k,:),(Y(k,:)),'ro-', 'LineWidth', 0.5, 'MarkerSize', 8); xlim([0 metadata.xdim*metadata.micronpixel]);  ylim([0 metadata.ydim*metadata.micronpixel]);
         xlabel('x-coordinates (\mum)'); ylabel('y-coordinates (\mum)'); title('R:0.8')
         set(gca,'Ydir','reverse','Fontsize',15)
         hold on
    end
    % original cells 
    sz=20;
    scatter(x2,y2,sz,'filled','b')
    
%     SI_flip = flip(SI); 
%     %SI has the format 'double' that cant be used for the argument below; so convert to cell format
%     % Transform each double vector of SI to cell format
%     SI_cellformat = [] ; % prelocate
%     for j = 1 :numel(SI)
%          SI_cellformat = [SI_cellformat;{num2cell(SI_flip{j})}];
%     end
%     
%     M = max(cellfun(@numel,SI_cellformat));
%     SI_triangle = cellfun(@(row)[row (cell(1,M-numel(row)))],SI_cellformat , 'uni', 0);
%     for idx = 1:numel(SI_triangle)
%         SI_triangle{idx}(cellfun(@isempty, SI_triangle{idx})) = {0};
%     end
%     SI_triangle=flip(vertcat(SI_triangle{:}));
% %     SI_table= cell2mat(SI_triangle);
% %     f = figure;
% %     uit = uitable(f,'Data',SI_table);
% %     uit.Position = [20 20 1000 700];
%     
%     SI_vector=nonzeros(cell2mat(SI_triangle(:)));
% % save data in excel sheet
% [filename, pathname] = uiputfile( ...       
%                  {'*.xlsx',  'excel files (*.xlsx)'; ...
%                    '*.xls','excel file (*.xls)'}, ...             
%                    'save Similarity Index','Similarity Index.xlsx');
%                
% %sheet 1 and 2 of the excel workspace                
% xlswrite([pathname,filename],[SI_vector],'similarity index');
% 
% %delete the empty first sheet since its automatically generated
% newExcel = actxserver('excel.application');
% excelWB = newExcel.Workbooks.Open([pathname,filename],0,false);
% newExcel.Visible = true;
% newExcel.DisplayAlerts = false;
% excelWB.Sheets.Item(1).Delete;
% excelWB.Save();
% excelWB.Close();
% newExcel.Quit();
% delete(newExcel);

end
