%the excel sheet must contain Cell id(first column),frames(second column),
%x-position(third column) & y-position(fourth column)

[output,metadata]=load_mig_data('excel');

[xyt]=tracked_ROIs(output);

[velocity]=ROI_velocity(xyt,metadata);

[meanMSD,msd]=ROI_MSD_1(xyt,metadata);