function [numSubjs, uniqueVar] = getRunEfficiency(trialData, timingData)

%% compute the theoretical efficiency of a run in terms of unique variance in the BOLD
%  response that would result from a given session. 


infoData=getInfoValueFromBlock(trialData);


%  WILL NEED THIS STUFF:  (trialData,totTime,totDetTime,infoChoiceTime,firstInfoTime,sideChoiceTime,feedbackTime,maxDrawTime,allPCJitter,allFIJitter,allETJitter,infRespTime)

%modTrialInfValue; % info value
%modExpMutInfGain; % info quantity
%modTrialStateValue; %overall value of current state
%modDrawActualMutInfoGain; % how much info is actually received at feedback
%modDrawActualValueGain; % how much actual value is realized?
%modDrawActualKLdivergence;

choiceNames={'modTrialInfValue' 'modExpMutInfGain' 'modTrialStateValue'};
infoNames={'modDrawActualMutInfoGain' 'modDrawActualValueGain' 'modDrawActualKLdivergence'};

choicePhaseVars=zscore([infoData.modTrialInfValue infoData.modExpMutInfGain infoData.modTrialStateValue]);
infoPhaseVars=[infoData.modDrawActualMutInfoGain infoData.modDrawActualValueGain infoData.modDrawActualKLdivergence];

% mean center choice phase modulator regressors:
choicePhaseVars=choicePhaseVars-repmat(nanmean(choicePhaseVars), length(choicePhaseVars), 1); 
% info phase regressors can only be mean centered after we determine which
% info phases will be observed.

%  corr(choicePhaseVars)
%keyboard
% 
% sel1=trialData.hiValue==170
% sel2=trialData.hiValue==70
% 
% hold on
% plot(infoData.modTrialStateValue(sel1), infoData.modTrialInfValue(sel1), '.')
% plot(infoData.modTrialStateValue(sel2), infoData.modTrialInfValue(sel2), '.r')
% ylabel('info value')
% xlabel('state value')
% aa=legend('70 10 0', '7 1 0')
% set(aa, 'box', 'off')
% set(gca, 'box', 'off')
% saveas(gcf, 'scaleManipulation.eps', 'epsc2')
% close all


% corr(choicePhaseVars)



% run through a bunch of "subject types" ie drawers and non-drawers

% compute bead difference for each trial.
if ~unique(trialData.hiValSide)
    beadDifference=trialData.startLeft-trialData.startRight;
else
    disp('put high value on left')
end
    
    
ll=length(infoData.modTrialInfValue);
t=0; 


%modExpMutInfGain; % info quantity
%modTrialStateValue; %overall value of current state
%modDrawActualMutInfoGain; % how much info is actually received at feedback
%modDrawActualValueGain; % how much actual value is realized?
%modDrawActualKLdivergence;

choiceNames={'modTrialInfValue' 'modExpMutInfGain' 'modTrialStateValue'};
infoNames={'modDrawActualMutInfoGain' 'modDrawActualValueGain' 'modDrawActualKLdivergence'};

choicePhaseVars=zscore([infoData.modTrialInfValue infoData.modExpMutInfGain infoData.modTrialStateValue]);
infoPhaseVars=[infoData.modDrawActualMutInfoGain infoData.modDrawActualValueGain infoData.modDrawActualKLdivergence];

% mean center choice phase modulator regressors:
choicePhaseVars=choicePhaseVars-repmat(nanmean(choicePhaseVars), length(choicePhaseVars), 1); 
% info phase regressors can only be mean centered after we determine which
% info phases will be observed.

%  corr(choicePhaseVars)
%keyboard
% 
% sel1=trialData.hiValue==170
% sel2=trialData.hiValue==70
% 
% hold on
% plot(infoData.modTrialStateValue(sel1), infoData.modTrialInfValue(sel1), '.')
% plot(infoData.modTrialStateValue(sel2), infoData.modTrialInfValue(sel2), '.r')
% ylabel('info value')
% xlabel('state value')
% aa=legend('70 10 0', '7 1 0')
% set(aa, 'box', 'off')
% set(gca, 'box', 'off')
% saveas(gcf, 'scaleManipulation.eps', 'epsc2')
% close all


corr(choicePhaseVars)



% run through a bunch of "subject types" ie drawers and non-drawers

% compute bead difference for each trial.
if ~unique(trialData.hiValSide)
    beadDifference=trialData.startLeft-trialData.startRight;
else
    disp('put high value on left')
end
    
    
ll=length(infoData.modTrialInfValue)
t=0; 








allTrialDraws=nan(ll, 1);
infoOn=timingData.infoOn; 
choiceOn=timingData.choiceOn; 
feedbackOn=timingData.feedbackOn; 
infoOff=timingData.infoOff;
choiceOff=timingData.choiceOff;
feedbackOff=timingData.feedbackOff;
expDuration=timingData.feedbackOff-timingData.trialStart;

%keyboard


%% mean center info modulator values JUST on info trials
infoTrials=isfinite(infoOn);
infoPhaseVars(infoTrials,:)=(infoPhaseVars(infoTrials,:)-repmat(nanmean(infoPhaseVars(infoTrials,:)), sum(infoTrials), 1) );



t=600;
tr=1.5;  % how long will it take to scan the entire brain once
numTrs=ceil(t./tr)+5 ; % how many TRs will we need total to cover the entire task block
allTrs=tr/2:tr:numTrs.*tr;  %lets list them.
inc=.5;

% ok, lets loop through trials
choiceReg=zeros(size(allTrs))';
infoReg=zeros(size(allTrs))';
trialFeedbackReg=zeros(size(allTrs))';
feedbackRegs=zeros(length(allTrs), size(infoPhaseVars, 2));
choiceModRegs=zeros(length(allTrs), size(choicePhaseVars, 2));

infoPhaseVars(~isfinite(infoPhaseVars))=0;


for i = 1:(ll)
    
    % run through choice phase (by steps of inc) and simulate BOLD responses
    trialReg=zeros(size(allTrs))';
    for j = choiceOn(i):inc:choiceOff(i)
        ts=allTrs-j;
        newResponse = fast_fslgamma(ts,6,3);
        choiceReg=choiceReg+newResponse;
        trialReg=trialReg+newResponse;  % regressor for this phase of the trial
    end
    
    trialReg=trialReg./length(choiceOn(i):inc:choiceOff(i));
    
    %    plot(repmat(choicePhaseVars(i,:), length(allTrs), 1).*repmat(trialReg, 1, size(choicePhaseVars, 2)))
    
    
    choiceModRegs=choiceModRegs+repmat(choicePhaseVars(i,:), length(allTrs), 1).* ...
        repmat(trialReg, 1, size(choicePhaseVars, 2));   % Modulator terms (ie Trial time regressor * trial variable regressor)
    
    
    % now do the exact same process, but run through the info phase
    trialReg=zeros(size(allTrs))';
    for j = infoOn(i):inc:infoOff(i)
        ts=allTrs-j;
        newInfoResponse=fast_fslgamma(ts,6,3);
        infoReg=infoReg+newInfoResponse;
        trialReg=trialReg+newInfoResponse; % compute an info phase BOLD response
        
    end
    trialReg=trialReg./length(choiceOn(i):inc:choiceOff(i));
    feedbackRegs=feedbackRegs+repmat(infoPhaseVars(i,:), length(allTrs), 1).* ...
        repmat(trialReg, 1, size(infoPhaseVars, 2)); % multiply it by trial variables to get info phase modulator resopnses


   % now do the exact same process, Feedback
    for j = feedbackOn(i):inc:feedbackOff(i)
        ts=allTrs-j;
        newFdbkResponse=fast_fslgamma(ts,6,3);
        trialFeedbackReg=trialFeedbackReg+newFdbkResponse;
    end
end


%allNames=[{'ChoiceReg', 'infoReg', 'feedbackOn'}, choiceNames, infoNames];
allConvRegs=[(choiceReg) (infoReg) trialFeedbackReg (choiceModRegs) (feedbackRegs)];
zAllConvRegs=zscore(allConvRegs);



% keyboard

%keyboard
% %Diagnostics.
% % look at timing regressors:
% hold on
% plot(allTrs, (choiceReg), 'g')
% plot(allTrs, infoReg, 'r')
% plot(allTrs, trialFeedbackReg, 'b')
% xlim([0 100])
% set(gca, 'box', 'off')
% saveas(gcf, 'allRegsOverTime.eps', 'epsc2')
% close all
% % % 
% rrr=corr([choiceReg(5:end) infoReg(5:end) trialFeedbackReg(5:end)])
% a=imagesc(rrr)
% set(gca, 'clim', [-1 1])
% colorbar
% saveas(gcf, 'corrMatForArthur.eps', 'epsc2')
% close all
% 
% 
% 
% plot(choiceReg(10:end), trialFeedbackReg(10:end), '.')
% ylabel('FeedbackTimingReg')
% xlabel('choiceTimingReg')
% set(gca, 'box', 'off')
% % saveas(gcf, 'fdbk_choice_corr.eps', 'epsc2')
% close all
% % 
% %keyboard
% [C,LAGS]=xcov(zscore(choiceReg), zscore(trialFeedbackReg), 10, 'unbiased')
% 
% hold on
% plot(LAGS.*tr, C)
% plot([min(LAGS.*tr) max(LAGS.*tr)], [0 0], '--k')
% plot([0 0], [-1 1], '--k')
% ylim([-1 1])
% ylabel('correlation')
% xlabel('time lag (sec)')
% set(gca, 'box', 'off')
% saveas(gcf, 'crossCovariogram.eps', 'epsc2')
% close all
% 



%keyboard

for i = 1: size(allConvRegs, 2)
    ys=false(size(allConvRegs, 2),1);
    ys(i)=true;
    
    [~,~,R,~,STATS] = regress(allConvRegs(:,ys),[ones(size(allConvRegs,1),1) allConvRegs(:,~ys)]);
    uniqueVar(i)=nanstd(R).^2;  % ie unique variance is just the variance in each regressor that can't be explained by the other regressors!
    
    [~,~,R,~,STATS] = regress(zAllConvRegs(:,ys),[ones(size(allConvRegs,1),1) zAllConvRegs(:,~ys)]);
    zUniqueVar(i)=nanstd(R).^2; % while we really want
    % to maximize unique variance, it is useful to look at unique variance with z-scored inputs so all variable are on the same scale
    % but remember: its really the
    % un-normalized term that will matter for
    % our analysis!
    
    VIF(i)=1./(1-STATS(1));  % compute variance inflation factor.
    
end

numSubjs  = (VIF.* 1./(1./11))+1;
end