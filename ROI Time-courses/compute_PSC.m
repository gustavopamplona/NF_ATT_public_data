clear

% specifying ROIs
roi_files(1)={'D:\Gustavo\Google Drive\NF_PUK\Mask_backup\roi_1_2_14_47_roi.mat'};
roi_files(2)={'D:\Gustavo\Google Drive\NF_PUK\Mask_backup\roi_2_47_7_34_roi.mat'};
roi_files(3)={'D:\Gustavo\Google Drive\NF_PUK\Mask_backup\roi_3_61_-34_14_roi.mat'};
roi_files(4)={'D:\Gustavo\Google Drive\NF_PUK\Mask_backup\roi_4_44_-46_47_roi.mat'};

for subj=1:15
    
    subj
    
    if length(num2str(subj))==1
        D=dir(['D:\Gustavo\Google Drive\NF_PUK\A00' num2str(subj) '\ICA\ROIs\*.mat']);
    else
        D=dir(['D:\Gustavo\Google Drive\NF_PUK\A0' num2str(subj) '\ICA\ROIs\*.mat']);
    end
    
    for i=1:4
        roi_files(i+4)={[D(i).folder '\' D(i).name]};
    end
    
    % specifying SPM file
    if length(num2str(subj))==1
        des_path = ['D:\Gustavo\Google Drive\NF_PUK\A00' num2str(subj) '\Neurofeedback\3rdDay\Nifti\5-run5\SPM.mat']; % last training run
%         des_path = ['D:\Gustavo\Google Drive\NF_PUK\A00' num2str(subj) '\Neurofeedback\2ndDay\Nifti\2-run1\SPM.mat']; % first training run
    else
        des_path = ['D:\Gustavo\Google Drive\NF_PUK\A0' num2str(subj) '\Neurofeedback\3rdDay\Nifti\5-run5\SPM.mat']; % last training run
%         des_path = ['D:\Gustavo\Google Drive\NF_PUK\A0' num2str(subj) '\Neurofeedback\2ndDay\Nifti\2-run1\SPM.mat']; % first training run
    end
    
    
    % extracting time courses
    des = mardo(des_path); % make mardo design object
    for i=1:8
        rois = maroi('load_cell', roi_files(i)); % make maroi ROI objects
        mY = get_marsy(rois{:}, des, 'mean'); % extract data into marsy data object
        y(:,i) = summary_data(mY); % get summary time course(s)
    end
    
    % design parameters
    o_bas=[6 43 80 117 154];
    o_task=[21 58 95 132 169];
    d_bas=15;
    d_task=20;
    show_pos=11;
    n_blocks=5;
    PSC=nan(d_task+show_pos,n_blocks);
    
    % computing PSC for each block
    for roi=1:8
        for i=1:n_blocks
            bas(i,roi)=mean(y(o_bas(i)+5:o_bas(i)+d_bas-1,roi));
            if i ~= n_blocks
                PSC(:,i,roi)=(y(o_task(i):o_task(i)+d_task-1+show_pos,roi)-bas(i,roi))/bas(i,roi)*100;
            else
                PSC(1:22,i,roi)=(y(o_task(i):o_task(i)+d_task-1+2,roi)-bas(i,roi))/bas(i,roi)*100; % the last one is a bit shorter because it doesn't have the last three volumes
            end
        end
        
        
        % computing mean and standard deviation over blocks
        for i=1:d_task+show_pos
            m_PSC(i,roi)=nanmean(PSC(i,:,roi));
%             s_PSC(i,roi)=nanstd(PSC(i,:,roi));
        end
    end
    m_PSC=m_PSC';
    
    m_all_PSC(:,:,subj)=m_PSC;
    
    clear m_PSC
    
end

mean_all_PSC=mean(m_all_PSC,3);
for i=1:d_task+show_pos
    for roi=1:8
        std_all_PSC(i,roi)=std(m_all_PSC(roi,i,:))/sqrt(subj);
    end
end

% plotting results
x = 0:d_task+show_pos-1;
for roi=8:8
    yu = mean_all_PSC(roi,:)+std_all_PSC(:,roi)';
    yu_f = mean_all_PSC_f(roi,:)+std_all_PSC_f(:,roi)';
    yl = mean_all_PSC(roi,:)-std_all_PSC(:,roi)';
    yl_f = mean_all_PSC_f(roi,:)-std_all_PSC_f(:,roi)';
    figure;
    ylim([-1 .4])
    patch([0 20 20 0], [max(ylim) max(ylim) min(ylim) min(ylim)], [1 1 1])
    patch([20 22 22 20], [max(ylim) max(ylim) min(ylim) min(ylim)], [.9 .9 .9])
    patch([22 30 30 22], [max(ylim) max(ylim) min(ylim) min(ylim)], [.8 .8 .8])
    hold on
    fill([x fliplr(x)], [yu_f fliplr(yl_f)], [.9 .9 1], 'linestyle', 'none')
    fill([x fliplr(x)], [yu fliplr(yl)], [.8 .8 1], 'linestyle', 'none')
    h1=plot(x,mean_all_PSC(roi,:),'b');
    h2=plot(x,mean_all_PSC_f(roi,:),'--b');
    legend([h1 h2],{'Last training run','First training run'},'Location','northeast');
    line([min(xlim),max(xlim)],[0,0],'color','k','HandleVisibility','off')
    xlabel('Time [TR] (from regulation block onset)')
    ylabel('Signal change (%)')
end