% Writes Switcher parameters in a xls file for all subjects for a linear mixed 
% models computation
% 
% Gustavo Pamplona, 08/2019

% Parameters:
% - group
% - subj
% - day
% - type
% - try
% - correct
% - rt

clear

table_total=[];

for group=1:2
    
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
            
            fullpath=[path '\' daypath '\2-switcher\'];
            testfile = dir([fullpath 'switch-3.csv']);
            

            

            
            
            
            
            if ~isempty(testfile)
                
                data=readtable([fullpath testfile.name]);
                
                len=size(data,1);
                
                if group==1
                    group_vec=cellstr(repmat('NF',[len 1]));
                else
                    group_vec=cellstr(repmat('CTRL',[len 1]));
                end
                
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
                
                try_vec=num2cell((1:len)');
            
                % Defining variables
                type_vec=num2cell(table2array(data(:,3)));
                
                correct_vec=num2cell(table2array(data(:,10)));
                
                rt=table2array(data(:,30));
                
                n_std=3;
                [rt,m,sd]=rec_outlier_removal(rt,n_std);
                
                rt_vec=num2cell(rt);
                
            else
                type_vec=num2cell(nan(len,1));
                correct_vec=num2cell(nan(len,1));
                rt=nan(len,1);
            end
            
            table=[group_vec subj_vec day_vec type_vec try_vec correct_vec rt_vec];
            table_total=[table_total;table];
            
        end
    end
end

names={'group','subj','day','type','try','corr','rt'};
table2write=[names;table_total];

xlswrite('MM_Switcher',table2write)