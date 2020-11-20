A = full(A1);
A = reshape(A,480,752,size(A1,2));
A = sum(A,3);
imagesc(A);
cmap = gray(256);
colormap(cmap);




