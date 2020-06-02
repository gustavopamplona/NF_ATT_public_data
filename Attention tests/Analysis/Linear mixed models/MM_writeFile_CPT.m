% Writes CPT parameters in a xls file for all subjects for a linear mixed 
% models computation
% 
% Gustavo Pamplona, 07/2019

% Parameters:
% - Group
% - Subject
% - Day
% - Trial
% - Condition (ISI)
% - Correct
% - RT

clear

table_total=[];
len=360;

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
            
            fullpath=[path '\' daypath '\1-cpt\'];
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
                targ=table2array(data(:,5));
                go=~strcmp(targ,'X');
                go_str=repmat('go   ',[len 1]);
                for i=1:360
                    if go(i)==0
                        go_str(i,:)='no go';
                    end
                end
                go_vec=cellstr(go_str);
                
                cond_vec=num2cell(table2array(data(:,4)));
                corr_vec=num2cell(table2array(data(:,7)));
                rt=table2array(data(:,9));
                for i=1:360
                    if rt(i)==-1
                        rt(i)=NaN;
                    end
                end
            else
                cond_vec=num2cell(nan(len,1));
                corr_vec=num2cell(nan(len,1));
                rt=nan(len,1);
            end
            
            n_std=3;
            [rt,m,sd]=rec_outlier_removal(rt,n_std);
            
            rt_vec=num2cell(rt);
            
            table=[group_vec subj_vec day_vec trial_vec go_vec cond_vec corr_vec rt_vec];
            table_total=[table_total;table];
            
        end
    end
end

names={'group','subj','day','trial','go/no-go','cond','corr','rt'};
table2write=[names;table_total];

xlswrite('MM_CPT',table2write)