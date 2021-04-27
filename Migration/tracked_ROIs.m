function [xyt]=tracked_ROIs(output)
%ROIs = cells of interest

num_ROIs=unique(output(:,1));
tlength=zeros(size(num_ROIs));
xyt=cell(size(num_ROIs));

%calculate total number of frames each cell is tracked
    for i = 1:length(num_ROIs)
        row=output(:,1)==num_ROIs(i);
        tlength(i)=sum(row);
    end

%place individual ROIs in a cell array containing xy position over time

    for k= 1:length(num_ROIs)
        row_1=output(:,1)==num_ROIs(k);
        temp=output(row_1,1:end);
        temp=temp(1:tlength,3:end);
        xyt{k}=temp;
    end
end
