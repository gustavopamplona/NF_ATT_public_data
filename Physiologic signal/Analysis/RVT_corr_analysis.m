% Test whether correlations between betas and self-report scores are 
% higher than zero

% Gustavo Pamplona, 20.09.19

clear

load('betas.mat')
load('results.mat')

rvt_rest=rvt_rest_average(:,2:11);
rvt_task=rvt_task_average(:,2:11);

for i=1:15
    for j=1:10
        rvt_diff(i,j)=(rvt_task(i,j)-rvt_rest(i,j))/rvt_rest(i,j); % control, ease, or concentration
    end
end

for i=1:15
    a=corrcoef(betas(i,:),rvt_diff(i,:));
    r(i)=a(1,2);
end

z = atanh(r);

mean_r = nanmean(tanh(z))

[h,p,~,stats]=ttest(z)