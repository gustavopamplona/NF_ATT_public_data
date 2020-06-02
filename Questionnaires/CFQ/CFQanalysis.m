% clear
% 
% load('slope');
% load('transfer');

path=cd;

for i=1:15
    table(:,:,i)=xlsread([path '\Cognitives Failures Questionnaire.xlsx'],i);
end

for subj=1:15
    for day=1:3
        cfq(subj,day)=nanmean(table(:,day+2,subj));
    end
%     cfq(subj,:)=zscore(cfq(subj,:));
end

meanDay1=mean(cfq(:,1));
stdDay1=std(cfq(:,1))/sqrt(15);

meanDay4=mean(cfq(:,2));
stdDay4=std(cfq(:,2))/sqrt(15);

meanDay5=mean(cfq(:,3));
stdDay5=std(cfq(:,3))/sqrt(15);
% 
% figure
% hold on
% bar(1:3,[meanDay1 meanDay4 meanDay5]);
% errorbar(1:3,[meanDay1 meanDay4 meanDay5],[stdDay1 stdDay4 stdDay5],'.');

% [r1,p1]=corrcoef(transfer,cfq(:,2)-cfq(:,1))
% [r2,p2]=corrcoef(slope,cfq(:,2)-cfq(:,1))
[r2,p2]=corrcoef(slope,cfq(:,1))
