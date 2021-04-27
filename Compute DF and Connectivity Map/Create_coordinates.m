function [x,y] = Create_coordinates(A)
 % This function allows us to create the coordinates of X and Y
x = zeros(size(A,1),1);
y = zeros(size(A,1),1);

 for j = 1:size(A,1)
      B = cell2mat(A(j));
      x(j) = x(j)+B(1);
      y(j) = y(j)+B(2);
 end
end