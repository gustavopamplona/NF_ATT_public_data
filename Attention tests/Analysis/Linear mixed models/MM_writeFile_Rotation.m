% Writes Rotation parameters in a xls file for all subjects for a linear mixed 
% models computation
% 
% Gustavo Pamplona, 08/2019

% Parameters:
% - Group
% - Subject
% - Day
% - Trial
% - cond (same or different)
% - stimulus id
% - rot (orientation)
% - correct
% - RT

clear

table_total=[];
len=128;

for group=1:2
    
    if group==1
        group_vec=cellstr(repmat('NF',[len 1]));
    else
        group_vec=cellstr(repmat('CTRL',[len 1]));
    end
    
    for subj=1:15
        
        subj
        
        if nnz(num2str(subj))==1
            if group==1
                path=['C:\Experiment_PUK\A00' num2str(subj) '\AttentionTests'];
            else
                path=['C:\Experiment_PUK\C00' num2str(subj)];
            end
        else
            if group==1
                path=['C:\Experiment_PUK\A0' num2str(subj) '\AttentionTests'];
            else
                path=['C:\Experiment_PUK\C0' num2str(subj)];
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
            
            fullpath=[path '\' daypath '\4-rotation\'];
            testfile = dir([fullpath '*.csv']);
            
            if group==1
                subj_vec=subj*ones(len,1);
            else
                subj_vec=(subj+15)*ones(len,1);
            end
            subj_vec=num2cell(subj_vec);
            
            if day==1
                day_vec=cellstr(repmat('Day1',[len 1]));
            else
                day_vec=cellstr(repmat('Day2',[len 1]));
            end
            
            trial_vec=num2cell((1:len)');
            
            if ~isempty(testfile)
                
                data=readtable([fullpath testfile.name]);
            
                % Defining variables
                cond_vec=num2cell(table2array(data(:,3))); % cond
                stimid_vec=num2cell(table2array(data(:,4))); % stimid
                
                rot=abs(table2array(data(:,5))); % rotation
                rot_vec=num2cell(rot);
                
                cor_vec=num2cell(table2array(data(:,7))); % cor
                
                rt=table2array(data(:,8)); % rt
                
            else
                cond_vec=num2cell(nan(len,1));
                stimid_vec=num2cell(nan(len,1));
                rot_vec=num2cell(nan(len,1));
                cor_vec=num2cell(nan(len,1));
                rt=nan(len,1);
            end
            
            n_std=3;
            [rt,m,sd]=rec_outlier_removal(rt,n_std);
            
            rt_vec=num2cell(rt);
            
            table=[group_vec subj_vec day_vec trial_vec cond_vec stimid_vec rot_vec cor_vec rt_vec];
            table_total=[table_total;table];
            
        end
    end
end

names={'group','subj','day','trial','cond','stimid','rot','corr','rt'};
table2write=[names;table_total];

xlswrite('MM_Rotation',table2write)