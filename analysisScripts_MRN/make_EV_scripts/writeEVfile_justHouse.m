function [regNames]=writeEVfile_justHouse(timingData, allRegModVars, evFileName);

%% make beads task EV files.  MRN 2-12-14
% send in timing and model based data for a run... this function will write
% an EV file for each regressor and save it as "evFileName".

% timingData already has the scan onset time subtracted, meaning it should
% be perfectly aligned for FSL.

% however, we may want to drop a few frames at the beginning of the scan.
dropFrames=5;
TR=1.5;
timeDropped=dropFrames.*TR;


% In this model we will include the house/face modulator but NOT the other
% outcome modulators. The goal here is to identify activations in PPA and
% FFA that may represent the sensory evidence.

% so the first thing to do is remove the other regressors from the
% allRegModVars matrix.
allRegModVars.info.vals=(allRegModVars.info.vals(:,end))
allRegModVars.info.names=allRegModVars.info.names(end);







% timing variables require an "on" timestamp and a duration. In order to
% use modulator regressors, each timing variable must be matched in name to
% the fieldnames of the allRegModVars structure.

timings(1).on          =timingData.choiceOn;
timings(1).duration    =nanmedian(timingData.choiceOff-timingData.choiceOn);
timings(1).name        ='choice';

timings(2).on          =timingData.infoOn;
timings(2).duration    =nanmedian(timingData.infoOff-timingData.infoOn);
timings(2).name        ='info';

timings(3).on           =timingData.betOn;
timings(3).duration     =nanmedian  (timingData.feedbackOn- timingData.betOn);
timings(3).name        ='bet';

timings(4).on           =timingData.tooSlow;
timings(4).duration     =1;
timings(4).name         ='tooSlow';


% % model extra button pushes. 
% timings(5).duration     =.1;
% timings(5).name         ='extraInfButtonPress';
% timings(5).on           =[]
% for i = 1:ll
%     trialExPush=timingData.extraButtonPush{i};
%     timings(5).on=[ timings(5).on; trialExPush'];
% end
% timings(5).on=timings(5).on(isfinite(timings(5).on));


k=1;

modTimes=fieldnames(allRegModVars);
clear regNames
for i = 1:length(timings)
    
    sel=isfinite(timings(i).on);
    
    % create 3 column matrix
    featTxt=[timings(i).on(sel)-timeDropped, ...                    % onset
        ones(sum(sel),1).*timings(i).duration, ... % duration
        ones(sum(sel),1)];                         % height
    
    if isempty(featTxt)
        featTxt=[0 1 0]; % send in some bullshit if its empty.  Maybe fsl will know what to do...
    end


    % write text file
    dlmwrite([evFileName  '_reg_' num2str(k)], featTxt, ' ')
    regNames{k}=[timings(i).name '_timing']; % store regressor name
    k=k+1; % increment regressor number.
    
    % if there are modulators, we'll want to make EV files for them too.
    if ~isempty(strmatch(timings(i).name, fieldnames(allRegModVars)))

        % get the modulators of this particular epoch.
        eval(sprintf('timeMods=allRegModVars.%s', timings(i).name))
        
        % check to make sure that timing and modulator arrays are same
        % length:
         
        if length(timeMods.vals)~=length(timings(i).on)
            disp('houston, we have a problem');
            keyboard;
        end

        % run through each modulator of this epoch and create a file.
        for j = 1:length(timeMods.names)
            featTxt=[timings(i).on(sel)-timeDropped, ...              % onset
                ones(sum(sel),1).*timings(i).duration, ...  %duration                  % duration
                ones(sum(sel),1).*timeMods.vals(sel,j)];                   % height
            
            dlmwrite([evFileName  '_reg_' num2str(k)], featTxt, ' ')
            regNames{k}=[timings(i).name timeMods.names{j}]; % store regressor name
            k=k+1;
        end
    end
end


