clearvars -except statusData backup
clc
statusData = backup;

timetable = {'startTime', 'trialStartTime', 'preChoiceOn', 'preChoiceOff','infChoiceTime','infChoiceMade',...
            'drawBegTime', 'realInfoOn','infoJitter','infoOn','postinfojitter' ,'infoOff', 'freeDrawOn', 'extraDrawTime','forceChoiceTime',...
            'enterDecTime', 'freeDrawOff', 'betOn', 'betchoicetime', ...
            'tooSlowOnTime', 'tooSlowOffTime','preITItime','ITI','postITItime'};

for x = 1:length(statusData)
    temp = {statusData(x).startTime, statusData(x).trialStartTime, statusData(x).preChoiceOn, statusData(x).preChoiceOff,...
        statusData(x).infChoiceTime, statusData(x).infChoiceMade, statusData(x).drawBegTime, statusData(x).realInfoOn,statusData(x).curr_PostChoiceIs,...
        statusData(x).infoOn, statusData(x).curr_PostIinfoIs, statusData(x).infoOff, statusData(x).freeDrawOn, statusData(x).extraDrawTime,statusData(x).forceChoiceTime,...
        statusData(x).enterDecTime, statusData(x).freeDrawOff, statusData(x).betOn, statusData(x).betchoicetime,...
        statusData(x).tooSlowOnTime, statusData(x).tooSlowOffTime, statusData(x).preITItime, statusData(x).curr_InterTrialIs,statusData(x).postITItime};
    timetable = [timetable;temp];
end

removablefields = {'startTime', 'trialStartTime', 'preChoiceOn', 'preChoiceOff','infChoiceTime','infChoiceMade',...
            'drawBegTime', 'realInfoOn','infoOn','infoOff', 'freeDrawOn', 'extraDrawTime','infChoiceOn',...
            'forceChoiceTime','enterDecTime', 'freeDrawOff', 'betOn', 'betchoicetime','tooSlowOnTime', 'tooSlowOffTime',...
            'preITItime','postITItime','fdbkOn','fdbkOff','endofDarkAge','curr_PostIinfoIs','curr_PostChoiceIs','curr_InterTrialIs',...
            'maxAllDrawTime','all_start_tokensLeft','all_start_tokensRight','all_rewCorrLeft','all_rewCorrRight','all_penErrLeft',...
            'all_penErrRight','all_infCost','all_maxUrnProb','all_urnType','allInterTrialDelays','allPostChoiceDelays','allPostInfoDelays',...
            'maxChoiceTime','maxTime','dataDir','dataFileName','fileNameBase','InterTrialIs','PostChoiceIs','PostIinfoIs','name','randSeed',...
            'time','preChoiceTime','blockNum','trialsPerBlock','benchmarks','isBlockShuffle','nBlocks','numConds','infoPhase','badTrialFlag',...
            'trialData','sideChoiceTime','decTime','addedDecTime'};
        
statusData = rmfield(statusData,removablefields);
