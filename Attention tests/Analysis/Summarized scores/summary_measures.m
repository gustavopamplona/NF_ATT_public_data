clear

load('behav_results_day1.mat')
load('behav_results_day4.mat')
% load('behav_results_day1ctrl.mat')
% load('behav_results_day2ctrl.mat')

scoresDay1=table2array(data1stDay);
scoresDay2=table2array(data4thDay);
% scoresDay1=table2array(data1stDayCtrl);
% scoresDay2=table2array(data2ndDayCtrl);

% inc=[3 5 7 9 11 13 14]; % ROI1 best learners
% inc=[1 2 4 6 10 12 15]; % ROI1 sub-learners
% scoresDay1=scoresDay1(:,inc);
% scoresDay2=scoresDay2(:,inc);

exc=[]; % pay attention to excluded subjects
scoresDay1(:,exc)=[]; 
scoresDay2(:,exc)=[];

CPT(1,:)=[-scoresDay1(1,:) -scoresDay2(1,:)];
CPT(2,:)=[-scoresDay1(2,:) -scoresDay2(2,:)];
CPT(3,:)=[-scoresDay1(3,:) -scoresDay2(3,:)];
CPT(4,:)=[scoresDay1(5,:) scoresDay2(5,:)];
CPT(5,:)=[scoresDay1(6,:) scoresDay2(6,:)];
CPT(6,:)=[scoresDay1(7,:) scoresDay2(7,:)];

Switcher(1,:)=[-scoresDay1(18,:) -scoresDay2(18,:)];
Switcher(2,:)=[-scoresDay1(19,:) -scoresDay2(19,:)];
Switcher(3,:)=[-scoresDay1(20,:) -scoresDay2(20,:)];
Switcher(4,:)=[100-scoresDay1(25,:) 100-scoresDay2(25,:)];
Switcher(5,:)=[100-scoresDay1(26,:) 100-scoresDay2(26,:)];
Switcher(6,:)=[100-scoresDay1(27,:) 100-scoresDay2(27,:)];

Switcher_random(1,:)=[-scoresDay1(20,:) -scoresDay2(20,:)];
Switcher_random(2,:)=[100-scoresDay1(27,:) 100-scoresDay2(27,:)];

switchingCostIndex=[21];
switchingCost=[-scoresDay1(switchingCostIndex,:) -scoresDay2(switchingCostIndex,:)];

% PVT(1,:)=[-scoresDay1(32,:) -scoresDay2(32,:)];
% PVT(2,:)=[(120-scoresDay1(37,:))/120 (120-scoresDay2(37,:))/120]; % old measure

PVT(1,:)=[scoresDay1(32,:) scoresDay2(32,:)];

Rot(1,:)=[-scoresDay1(50,:) -scoresDay2(50,:)];
Rot(2,:)=[scoresDay1(60,:) scoresDay2(60,:)];

DiffRot(1,:)=[-scoresDay1(42,:) -scoresDay2(42,:)];
DiffRot(2,:)=[scoresDay1(52,:) scoresDay2(52,:)];

ANT(1,:)=[-scoresDay1(69,:) -scoresDay2(69,:)];
ANT(2,:)=[scoresDay1(77,:) scoresDay2(77,:)];

% susAttIndex=[17 40 38 39 4 32]; % old index
susAttIndex=[17 40 38 39]; % new index
susAtt=[-scoresDay1(susAttIndex,:) -scoresDay2(susAttIndex,:)];

attCtrlIndex=[8 80 83 21];
attCtrl=[scoresDay1(attCtrlIndex,:) scoresDay2(attCtrlIndex,:)];
attCtrl(2,:)=-attCtrl(2,:);
attCtrl(4,:)=-attCtrl(4,:);

phasicAlertIndex=[78];
phasicAlert=[scoresDay1(phasicAlertIndex,:) scoresDay2(phasicAlertIndex,:)];

mixingCostIndex=[22];
mixingCost=[-scoresDay1(mixingCostIndex,:) -scoresDay2(mixingCostIndex,:)];

orientingIndex=[79];
orienting=[scoresDay1(orientingIndex,:) scoresDay2(orientingIndex,:)];

conflictIndex=[80];
conflict=[-scoresDay1(conflictIndex,:) -scoresDay2(conflictIndex,:)];

PVT_mean_Index=[32];
PVT_mean=[scoresDay1(PVT_mean_Index,:) scoresDay2(PVT_mean_Index,:)];

PVT_fastest_Index=[39];
PVT_fastest=[scoresDay1(PVT_fastest_Index,:) scoresDay2(PVT_fastest_Index,:)];

PVT_slowest_Index=[38];
PVT_slowest=[scoresDay1(PVT_slowest_Index,:) scoresDay2(PVT_slowest_Index,:)];

PVT_lapses_Index=[37];
PVT_lapses=[scoresDay1(PVT_lapses_Index,:) scoresDay2(PVT_lapses_Index,:)];

overall=[CPT;Switcher;PVT;Rot;ANT];

vec_groups=susAtt; % line to change

L=size(vec_groups,1);

for i=1:L
    Z(i,:)=(vec_groups(i,:)-nanmean(vec_groups(i,:)))/nanstd(vec_groups(i,:));
end

% Z2(1,:)=nanmean(Z(1:6,:)); % only for overall
% Z2(2,:)=nanmean(Z(7:12,:));
% Z2(3,:)=nanmean(Z(13:14,:));
% Z2(4,:)=nanmean(Z(15:16,:));
% Z2(5,:)=nanmean(Z(17:18,:));
% Z=Z2;

n_subj1=size(scoresDay1,2); % number of subjects
n_subj2=size(scoresDay2,2);

day1Z=nanmean(Z(:,1:n_subj1));
day2Z=nanmean(Z(:,(n_subj1+1):(n_subj1+n_subj2)));
% day1Z=vec_groups(:,1:n_subj1);                         % when only one variable
% day2Z=vec_groups(:,(n_subj1+1):(n_subj1+n_subj2));

preMean=nanmean(day1Z) 
postMean=nanmean(day2Z)
preStd=nanstd(day1Z)
postStd=nanstd(day2Z)

figure
hold on
bar(1:2,[preMean postMean])
errorbar(1:2,[preMean postMean],[preStd/sqrt(length(day1Z)) postStd/sqrt(length(day2Z))],'.')

[h,p,ci,stats]=ttest(day2Z,day1Z,'tail','right')

for i=1:n_subj1
    diff(i)=day2Z(i)-day1Z(i);
end

% plot_brain_behav(diff,'Overall',exc) % change graph title

effSize=(postMean-preMean)/stats.sd

% day1Z=day1Z';
% x1=day1Z([1 2 6 8 14]);
% day2Z=day2Z';
% x2=day2Z([1 2 6 8 14]);