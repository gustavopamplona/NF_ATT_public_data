% Writes coefficients of variation for PVT in a xls file to be later analyzed 
% via an ANOVA
% 
% Gustavo Pamplona, 10/2019

% Parameters:
% - group
% - subj
% - day
% - cv

clear

table_total=[];

for group=1:2
    
    for subj=1:15
        
        if nnz(num2str(subj))==1
            if group==1
                path=['G:\Backup NF Experiment - PUK\A00' num2str(subj) '\AttentionTests'];
            else
                path=['G:\Backup NF Experiment - PUK\C00' num2str(subj)];
            end
        else
            if group==1
                path=['G:\Backup NF Experiment - PUK\A0' num2str(subj) '\AttentionTests'];
            else
                path=['G:\Backup NF Experiment - PUK\C0' num2str(subj)];
            end
        end
        
        for day=1:2
            if day==1
                if group==1
                    daypath='1_before_training';
                else
                    daypath='Day1';
                end
            else
                if group==1
                    daypath='2_after_training';
                else
                    daypath='Day2';
                end
            end
            
            fullpath=[path '\' daypath '\3-pvt\'];
            testfile = dir([fullpath '*.csv']); 
            
            if ~isempty(testfile)
                
                data=readtable([fullpath testfile.name]);
                
                len=size(data,1);
                
                if group==1
                    group_cell=cellstr('NF');
                else
                    group_cell=cellstr('CTRL');
                end
                
                if group==1
                    subj_cell=num2cell(subj);
                else
                    subj_cell=num2cell(subj+15);
                end
                
                if day==1
                    day_cell=cellstr('Day1');
                else
                    day_cell=cellstr('Day2');
                end
                
                % Defining variables
                rt=table2array(data(:,7));
                
                n_std=3;
                [rt,m,sd]=rec_outlier_removal(rt,n_std);
                
                mean_rt=nanmean(rt);
                std_rt=nanstd(rt);
                
                cv_cell=num2cell(std_rt*100/mean_rt);
                
            else
                cv_cell=nan;
            end
            
            table=[group_cell subj_cell day_cell cv_cell];
            table_total=[table_total;table];
            
        end
    end
end

names={'group','subj','day','cv'};
table2write=[names;table_total];

xlswrite('CV_PVT',table2write)