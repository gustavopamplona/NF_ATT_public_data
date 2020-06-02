% It extracts the average of the contrasts from PUK NF experiment,
% including training and transfers runs.
% Gustavo Pamplona, 18.04.19

% update: consider normalized space for ROIs (instead of coregistered contrast images)

clear

path0='C:\Experiment_PUK\';

pathDayRun{1}='2ndDay\Nifti\1-transfer';
pathDayRun{2}='2ndDay\Nifti\2-run1';
pathDayRun{3}='2ndDay\Nifti\3-run2';
pathDayRun{4}='2ndDay\Nifti\4-run3';
pathDayRun{5}='2ndDay\Nifti\5-run4';
pathDayRun{6}='2ndDay\Nifti\6-run5';
pathDayRun{7}='3rdDay\Nifti\1-run1';
pathDayRun{8}='3rdDay\Nifti\2-run2';
pathDayRun{9}='3rdDay\Nifti\3-run3';
pathDayRun{10}='3rdDay\Nifti\4-run4';
pathDayRun{11}='3rdDay\Nifti\5-run5';
pathDayRun{12}='3rdDay\Nifti\6-transfer';
pathDayRun{13}='5thDay\Nifti\Transfer1';
pathDayRun{14}='5thDay\Nifti\Transfer2';

for subj=1:15
    
    subj
    
    for run=1:14
        
        if length(num2str(subj))==1
            spm_name=['C:\Experiment_PUK\A00' num2str(subj) '\Neurofeedback\' char(pathDayRun{run}) '\SPM.mat'];
            roi_file=['C:\Experiment_PUK\A00' num2str(subj) '\ICA\ROIs\roi_8.mat'];
        else
            spm_name=['C:\Experiment_PUK\A0' num2str(subj) '\Neurofeedback\' char(pathDayRun{run}) '\SPM.mat'];
            roi_file=['C:\Experiment_PUK\A0' num2str(subj) '\ICA\ROIs\roi_8.mat'];
        end
%         roi_file='C:\Experiment_PUK\Mask_backup\Normalized_space\roi_4_44_-46_47_roi.mat';
        
        if exist(spm_name)==0
            con(run,subj)=NaN;
            break
        end
        
        % Make marsbar design object
        D  = mardo(spm_name);
        % Make marsbar ROI object
        R  = maroi(roi_file);
        % Fetch data into marsbar data object
        Y  = get_marsy(R, D, 'mean');
        % Get contrasts from original design
        xCon = get_contrasts(D);
        % Estimate design on ROI data
        E = estimate(D, Y);
        % Put contrasts from original design back into design object
        E = set_contrasts(E, xCon);
        % get design betas
        b = betas(E);
        % get stats and stuff for all contrasts into statistics structure
        marsS = compute_contrasts(E, 1:length(xCon));

        con(run,subj)=marsS.con;
        
    end
end

con=con';

% for i=1:15;a=polyfit([1:10],con(i,2:11),1);b(i,1)=a(1);end