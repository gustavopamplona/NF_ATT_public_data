% Writes DSSQ scores parameters in a xls file for all subjects for a
% repeated measures ANOVA computation
%
% Gustavo Pamplona, 10/2019

% Parameters:
% - subject
% - score
% - time
% - group

clear

include_NF_subjs=[9 10 11 12 13 14 15]; % change here
subj_vec=[];
score_vec=[];
day_vec=[];
group_vec=[];

load('DSSQ_results_NF.mat')
score1=motivation; % change here
load('DSSQ_results_TR.mat')
score2=motivation; % change here

for day=1:2
    
    subj_idx=1;
    
    for group=1:2
        
        % subjects
        for subj=1:15
            if group==1
                if nnz(include_NF_subjs==subj)
                    subj_vec=[subj_vec subj_idx];
                    score_vec=[score_vec score1(include_NF_subjs(subj_idx),day)];
                    
                    if day==1
                        day_vec=[day_vec;'Day1'];
                    else
                        day_vec=[day_vec;'Day2'];
                    end
                    
                    if group==1
                        group_vec=[group_vec;'NF'];
                    else
                        group_vec=[group_vec;'TR'];
                    end
                    
                    subj_idx=subj_idx+1;
                end
            else
                subj_vec=[subj_vec subj_idx];
                score_vec=[score_vec score2(subj,day)];
                subj_idx=subj_idx+1;
                
                if day==1
                    day_vec=[day_vec;'Day1'];
                else
                    day_vec=[day_vec;'Day2'];
                end
                
                if group==1
                    group_vec=[group_vec;'NF'];
                else
                    group_vec=[group_vec;'TR'];
                end
            end
        end
    end
end

table=[num2cell(subj_vec') num2cell(score_vec') cellstr(day_vec) cellstr(group_vec)];

names={'subj','score','time','group'};
table2write=[names;table];

xlswrite('DSSQ_anova_motivation',table2write) % change here