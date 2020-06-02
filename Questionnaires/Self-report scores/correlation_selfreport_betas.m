clear

load('selfreport.mat')
load('betas_complete.mat')

self=concentration;

for i=1:15
    c1(i)=corr(self(:,1),roi1(1,:)','Rows','pairwise');
    c2(i)=corr(self(:,1),roi2(1,:)','Rows','pairwise');
    c3(i)=corr(self(:,1),roi3(1,:)','Rows','pairwise');
    c4(i)=corr(self(:,1),roi4(1,:)','Rows','pairwise');
    
    c5(i)=corr(self(:,1),san(1,:)','Rows','pairwise');
    c6(i)=corr(self(:,1),dmn(1,:)','Rows','pairwise');
    
    c7(i)=corr(self(:,1),diff(1,:)','Rows','pairwise');
end
m=[mean(c1);mean(c2);mean(c3);mean(c4);mean(c5);mean(c6);mean(c7)]