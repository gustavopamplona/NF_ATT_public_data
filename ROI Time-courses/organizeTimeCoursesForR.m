% subj, time, psc

clear

table_total=[];
actRoi=4;
ext=7:23;
len=length(ext);

load('results_time_courses_first_training_run.mat')
tc1=squeeze(m_all_PSC(actRoi,ext,:));

load('results_time_courses_last_training_run.mat')
tc2=squeeze(m_all_PSC(actRoi,ext,:));

for i=1:2
    
    if i==1
        tc=tc1;
        day_vec=cellstr(repmat('before',[len 1]));
    else
        tc=tc2;
        day_vec=cellstr(repmat('after',[len 1]));
    end
    
    for subj=1:15
        
        subj2=subj*ones(len,1);
        subj_vec=num2cell(subj2);
        
        time_vec=num2cell((1:len)');
        
        psc=tc(:,subj);
        psc_vec=num2cell(psc);
        
        table=[day_vec subj_vec time_vec psc_vec];
        table_total=[table_total;table];
        
    end
end

names={'day','subj','time','psc'};
table2write=[names;table_total];

xlswrite(['TimeCourseTable' num2str(actRoi)],table2write)