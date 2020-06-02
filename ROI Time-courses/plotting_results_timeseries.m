% plotting results

clear

load('results_time_courses_first_training_run.mat')
mean_all_PSC_f=mean_all_PSC;
std_all_PSC_f=std_all_PSC;
m_all_PSC_f=m_all_PSC;
load('results_time_courses_last_training_run.mat')

x = 0:d_task+show_pos-1;
roi=1;

yu = mean_all_PSC(roi,:)+std_all_PSC(:,roi)';
yu_f = mean_all_PSC_f(roi,:)+std_all_PSC_f(:,roi)';
yl = mean_all_PSC(roi,:)-std_all_PSC(:,roi)';
yl_f = mean_all_PSC_f(roi,:)-std_all_PSC_f(:,roi)';
figure;
ylim([-.4 1])
%     ylim([-1 .4])
patch([0 20 20 0], [max(ylim) max(ylim) min(ylim) min(ylim)], [1 1 1])
patch([20 22 22 20], [max(ylim) max(ylim) min(ylim) min(ylim)], [.9 .9 .9])
patch([22 30 30 22], [max(ylim) max(ylim) min(ylim) min(ylim)], [.8 .8 .8])
hold on
fill([x fliplr(x)], [yu_f fliplr(yl_f)], [1 .9 .9], 'linestyle', 'none')
fill([x fliplr(x)], [yu fliplr(yl)], [1 .8 .8], 'linestyle', 'none')
%     fill([x fliplr(x)], [yu_f fliplr(yl_f)], [.9 .9 1], 'linestyle', 'none')
%     fill([x fliplr(x)], [yu fliplr(yl)], [.8 .8 1], 'linestyle', 'none')
h1=plot(x,mean_all_PSC(roi,:),'r');
h2=plot(x,mean_all_PSC_f(roi,:),'--r');
%     h1=plot(x,mean_all_PSC(roi,:),'b');
%     h2=plot(x,mean_all_PSC_f(roi,:),'--b');
legend([h1 h2],{'Last training run','First training run'},'Location','northeast');
line([min(xlim),max(xlim)],[0,0],'color','k','HandleVisibility','off')
xlabel('Time [TR] (from regulation block onset)')
ylabel('PSC (%)')

% testing for timepoint differences
for t=1:size(m_all_PSC,2)
    [h(t),p(t)]=ttest(m_all_PSC_f(roi,t,:),m_all_PSC(roi,t,:))
end
[adj_h, ~, ~, adj_p]=fdr_bh(p)