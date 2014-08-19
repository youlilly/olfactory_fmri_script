%DCR2SigmoidFitter.m
%Created October 2011 by ECF, based on Wen Li's getting_params.m
%This program takes DCR2 behavioral or EEG data for multiple fear
%percentages and fits sigmoid functions to the responses.  Before it can be
%run, the PSignifit Classic package must be installed and the psignifit folder
%added to the Matlab path.  The package can be obtained from
%http://www.bootstrap-software.org/psignifit.  PSignifit Classic will only
%work on computers running Windows XP.

clear all
%totaltrialsnofull = [98 98 98 98 98 98 98]'; %# of trials per condition (no full-fear)
%totaltrialswithfull = [98 98 98 98 98 98 98 98]'; %# of trials per condition (with full-fear)
nofullcoded = [1 3 4 5 6 7 8]'; %Coded fear percentages, no full-fear
nofullactual = [2 15 21 27 33 39 45]'; %Actual fear percentages, no full-fear
load  DCR2CorrectHitPercentagebyCondition_all45subs_2013.mat feardet  %call up variable "feardet." Col 1 = subj #, cols %2-8 (or 2-9 for full-fear) = % of trials correct for each level of fear.
%Has all 4 batches!
mean_acc = mean(feardet(:,2:8),1);
load DCR2all45subsbehavtotaltrials3SD_2013.mat totaltrials %This is good to do, instead of assuming 98 trials/condition. Has all subjs in it!
%Batch of subjects
allparameters = [];

full = 'nofull';
howlong = 2:8; %Want cols 2 (neutral) through 8 (45% fear)
allsubs = [1:16 53:81]; %For behavioral (batches 1, 3 and 4)
%allsubs = [1:14 16 18:21 23 25:30 33:35 37:39 41:46 48:52]; %For N170

wantcoded = input('Type 1 to use actual fear percentages; type 2 to use coded levels');
switch wantcoded
    case(1) %Actual fear percentages
        levels = 'actual';
    case(2) %Coded fear levels
        levels = 'coded';
end

eval(['levelname = ' full levels ';']); %Grab correct level codes: with/without full-fear, actual/coded levels
for subno = 1:length(allsubs) %For each subject
    s = allsubs(subno);
    totaltrials2 = totaltrials(subno,2:8)'; %for behavioral
    dat = [levelname feardet(subno,howlong)' totaltrials2]; %Put correct level codes, subj data, & total trials/cond into 1 input matrix
    pfit(dat,'#fix_gamma NaN','#fix_lambda NaN') %Do the fitting! Allows both gamma and lambda to vary (no idea why this is important)
    D = ans.stats.deviance.D; %#ok<NOANS> %Grab D-value: larger = less sigmoidy
    p = 1 - ans.stats.deviance.cpe; %#ok<NOANS> %Appears to be the p-value for D: sig = crappy fit
    inflection = ans.params.est(1); %#ok<NOANS> %Grabs inflection point (on scale given by levels)
    line = [s D p inflection]; %Col 1 = subj #, col 2 = D-value, col 3 = p-value, col 4 = inflection point
    allparameters = [allparameters; line]; %#ok<AGROW> %Add to big matrix of them
    eval(['saveas(gcf,''DCR2sub' num2str(s) 'behavsigfit' levels '.fig'');']); %Save figure for this subj
end
%eval(['save DCR2N170PO8sigmoid' full levels '.mat allparameters;']); %For N170
eval(['save DCR2_behav_45subs' full levels '.mat allparameters;']); %For behavioral (batches 1, 3, and 4)


%% For averaged 45 subjects - Added on 10-7-2013
%This cell is created, for some subjects don't have good sigmoid fit, so
%use an average to determine a general inflection point
%Run on Aquarius

clear all
%allsubs = [1:16 53:64 65:81];%For behavioral (batches 1, 3 and 4)
%totaltrialsnofull = [98 98 98 98 98 98 98]'; %# of trials per condition (no full-fear)
%totaltrialswithfull = [98 98 98 98 98 98 98 98]'; %# of trials per condition (with full-fear)
nofullcoded = [1 3 4 5 6 7 8]'; %Coded fear percentages, no full-fear
%withfullcoded = [1 3 4 5 6 7 8 17]'; %Coded fear percentages, with full-fear
nofullactual = [2 15 21 27 33 39 45]'; %Actual fear percentages, no full-fear
%withfullactual = [2 15 21 27 33 39 45 98]'; %Actual fear percentages, with full-fear
load  DCR2CorrectHitPercentagebyCondition_mean_2013.mat meanfeardet  %call up variable "feardet." Col 1 = subj #, cols %2-8 (or 2-9 for full-fear) = % of trials correct for each level of fear.
%Has all 4 batches!
%mean_acc = mean(feardet(:,2:8),1);
load DCR2all45subsbehavtotaltrials3SD_mean_integer_2013.mat meantotaltrials %This is good to do, instead of assuming 98 trials/condition. Has all subjs in it!

%Batch of subjects
allparameters = [];
full = 'nofull';
howlong = 2:8; %Want cols 2 (neutral) through 8 (45% fear)
wantcoded = input('Type 1 to use actual fear percentages; type 2 to use coded levels');
switch wantcoded
    case(1) %Actual fear percentages
        levels = 'actual';
    case(2) %Coded fear levels
        levels = 'coded';
end

eval(['levelname = ' full levels ';']); %Grab correct level codes: with/without full-fear, actual/coded levels

totaltrials2 = meantotaltrials(1,2:8)'; %for behavioral
dat = [levelname meanfeardet(1,howlong)' totaltrials2]; %Put correct level codes, subj data, & total trials/cond into 1 input matrix
pfit(dat,'#fix_gamma NaN','#fix_lambda NaN') %Do the fitting! Allows both gamma and lambda to vary (no idea why this is important)

% fix lamda and gamma March 14th 2014
D = ans.stats.deviance.D; %#ok<NOANS> %Grab D-value: larger = less sigmoidy
p = 1 - ans.stats.deviance.cpe; %#ok<NOANS> %Appears to be the p-value for D: sig = crappy fit
inflection = ans.params.est(1); %#ok<NOANS> %Grabs inflection point (on scale given by levels)
line = [1 D p inflection]; %Col 1 = subj #, col 2 = D-value, col 3 = p-value, col 4 = inflection point
allparameters = [allparameters; line];  %Add to big matrix of them
eval(['saveas(gcf,''DCR2_behav_45subs_mean_sigfit' levels '.fig'');']); %Save figure for this subj

%eval(['save DCR2N170PO8sigmoid' full levels '.mat allparameters;']); %For N170
eval(['save DCR2_behav_45subs_mean' full levels '.mat allparameters;']); %For behavioral (batches 1, 3, and 4)

eval(['save DCR2_sigmoid_avg_' full levels '_allparameters.mat']);