% Writes ANT parameters in a xls file for all subjects for a linear mixed
% models computation
%
% Gustavo Pamplona, 08/2019

% Parameters:
% - Group
% - Subject
% - Day
% - Trial (exclude practice trials)
% - correct (cues 1-4, coherent, neutral, and incoherent)
% - RT (cues 1-4, coherent, neutral, and incoherent)

clear

table_total=[];
len=312-24;

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
            
            fullpath=[path '\' daypath '\5-ant\'];
            testfile = dir([fullpath 'ANT-5.csv']);
            
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
                
%                 practice=table2array(data(:,4));
                cue=table2array(data(25:end,5));
                coherence=table2array(data(25:end,8));
                corr=table2array(data(25:end,13));
                rt=table2array(data(25:end,14));
                
                % defining preliminary variables
                err_cue=zeros(1,4);
                n_cue=zeros(1,4);
                n_coh=zeros(1,4);
                err_coh=zeros(1,3);
                err=0;
                n_trials=0;
                
                % indexing
                for i=1:len
                        if cue(i)==1 && ~isnan(rt(i))
                            index_cue(i)=1;
                            n_cue(1)=n_cue(1)+1;
                            if corr(i)~=1
                                err_cue(1)=err_cue(1)+1;
                            end
                        elseif cue(i)==2 && ~isnan(rt(i))
                            index_cue(i)=2;
                            n_cue(2)=n_cue(2)+1;
                            if corr(i)~=1
                                err_cue(2)=err_cue(2)+1;
                            end
                        elseif cue(i)==3 && ~isnan(rt(i))
                            index_cue(i)=3;
                            n_cue(3)=n_cue(3)+1;
                            if corr(i)~=1
                                err_cue(3)=err_cue(3)+1;
                            end
                        elseif cue(i)==4 && ~isnan(rt(i))
                            index_cue(i)=4;
                            n_cue(4)=n_cue(4)+1;
                            if corr(i)~=1
                                err_cue(4)=err_cue(4)+1;
                            end
                        end
                        if coherence(i)==1 && ~isnan(rt(i)) % coherent
                            index_coh(i)=1;
                            n_coh(1)=n_coh(1)+1;
                            if corr(i)~=1
                                err_coh(1)=err_coh(1)+1;
                            end
                        elseif coherence(i)==0 && ~isnan(rt(i)) % normal
                            index_coh(i)=2;
                            n_coh(2)=n_coh(2)+1;
                            if corr(i)~=1
                                err_coh(2)=err_coh(2)+1;
                            end
                        elseif coherence(i)==-1 && ~isnan(rt(i)) % incoherent
                            index_coh(i)=3;
                            n_coh(3)=n_coh(3)+1;
                            if corr(i)~=1
                                err_coh(3)=err_coh(3)+1;
                            end
                        end
                        if ~isnan(rt(i)) && corr(i)~=1
                            err=err+1;
                        end
                        if ~isnan(rt(i))
                            n_trials=n_trials+1;
                        end
                end
                
                % Defining variables
                cue_vec=num2cell(cue); % cor
                coh_vec=num2cell(coherence); % coherence
                corr_vec=num2cell(corr); % corr
                
            else
                cue_vec=num2cell(nan(len,1));
                coh_vec=num2cell(nan(len,1));
                corr_vec=num2cell(nan(len,1));
                rt=nan(len,1);
            end
            
            n_std=3;
            [rt,m,sd]=rec_outlier_removal(rt,n_std);
            
            rt_vec=num2cell(rt);
            
            table=[group_vec subj_vec day_vec trial_vec cue_vec coh_vec corr_vec rt_vec];
            table_total=[table_total;table];
            
        end
    end
end

names={'group','subj','day','trial','cue','coherence','corr','rt'};
table2write=[names;table_total];

xlswrite('MM_ANT',table2write)