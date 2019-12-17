n = 1000;
y1 = rand(1,n)';
y2 = 5*randn(1,n)';
num_bins = 60;

figure
colmat = bivariate_colors(y1,y2,'Smooth',true);
scatter(y1,y2,100,colmat,'filled','Marker','sq')

figure
colmat = bivariate_colors(y1,y2,'Smooth',false,'colormap',cool);
scatter(y1,y2,[],colmat,'filled','Marker','o')

figure
colmat = bivariate_colors(y1,y2,'Smooth',true,'colormap',hot,'n_pts',200);
scatter(y1,y2,30,colmat,'filled','Marker','^')