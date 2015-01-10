% spm_preprocess_all.m

% This script does preprocessing steps for OCF fMRI data, steps including:
% DICOM IMPORTS 
% Slice-Time Correction

% Before running this script, make sure all individual's epi/T1 data are unzipped
% and saved in their corresponding folders under
% /study/ocf/mri/preprocess/subN0(e.g. 001)

%% SETUP: Preparation for preprocessing
% This part will take in some inputs so it can properly and consistently
% set up your preprocessing directories.  Note that it is currently set up
% so that it recognizes two runs; this can be amended later to take in a
% variable number of runs, but for our purposes it will suffice as is.

% These are preset so that the rest of the lines will run properly.

%% Run this cell to set up initial parameters

%mainpath = '/study/ocf/mri/preprocess/Prep';
mainpath = '/Users/bhu/Documents/OCF_fmri/preprocess/Prep';
epi1name = 'PreCond';
epi2name = 'Cond';
epi3name = 'PostCond';
epi4name = 'PostCond2';
epi5name = 'Olocalizer';
epi6name = 'Resting';
epi7name = 'PostCond2_p2';
%epi7name = 'PostCond2_p2';
% dum1name = 'Dummy1';
% dum2name = 'Dummy2';
% dum3name = 'Dummy3';
% dum4name = 'Dummy4';
% dum5name = 'Dummy5';
% dum6name = 'Dummy6';
%dum7name = 'Dummy7';
fm1name = 'Fieldmap1';
fm2name = 'Fieldmap2';
fm3name = 'Fieldmap3';
fm4name = 'Fieldmap4';
T1name = 'T1';

%save ARF_sub019_setup_directory_parameters_082514.mat
%% change directory and making folders 
subs = [31 32 33];

cd(mainpath);

for i = 1:length(subs)%1:5
subfol = strcat('sub',num2str(subs(i))); % subfol = 'sub6'
fullfol = strcat(mainpath,'/',subfol); % fullfol = '/study/sweat/mri/preprocess/Prep/sub6'
if ~exist(subfol,'dir')
    mkdir(strcat(mainpath,'/',subfol));
else
end
cd(fullfol);
mkdir(strcat(fullfol,'/',epi1name)); % folder: /study/ocf/mri/preprocess/Prep/sub6/PreCond
mkdir(strcat(fullfol,'/',epi2name));
mkdir(strcat(fullfol,'/',epi3name));
mkdir(strcat(fullfol,'/',epi4name));
mkdir(strcat(fullfol,'/',epi5name));
mkdir(strcat(fullfol,'/',epi6name));
% mkdir(strcat(fullfol,'/',dum1name));
% mkdir(strcat(fullfol,'/',dum2name));
% mkdir(strcat(fullfol,'/',dum3name));
% mkdir(strcat(fullfol,'/',dum4name));
% mkdir(strcat(fullfol,'/',dum5name));
% mkdir(strcat(fullfol,'/',dum6name));
mkdir(strcat(fullfol,'/',fm1name));
mkdir(strcat(fullfol,'/',fm2name));
mkdir(strcat(fullfol,'/',fm3name));
mkdir(strcat(fullfol,'/',fm4name));
mkdir(strcat(fullfol,'/',T1name));
end

%% dicom import T1 to each individual's folder 
%make sure .json file is removed
subs = [33];
cd(mainpath);

for i = 1:length(subs)
subfol = strcat('sub',num2str(subs(i))); % subfol = 'sub6'
fullfol = strcat(mainpath,'/',subfol); % fullfol = '/study/ocf/mri/preprocess/Prep/subX'
cd(fullfol);

dicomdir = strcat('/study1/ocf/mri/preprocess/0',num2str(subs(i)),'/T1');
Filter = 'BRAVO';
stfiles = spm_select('FPList',dicomdir,Filter);
outdir = strcat(fullfol,'/',T1name);
cd(outdir);

stfilesh = spm_dicom_headers(stfiles);
spm_dicom_convert(stfilesh,'all','flat','img');

end

%% MEG T1 import; make sure .json file is removed

dicomdir = strcat('/study1/ocf/mri/MEG/008Jake');
Filter = 'BRAVO';
stfiles = spm_select('FPList',dicomdir,Filter);
outdir = strcat('/study1/ocf/mri/MEG/008Jake/T1');
cd(outdir);

stfilesh = spm_dicom_headers(stfiles);
spm_dicom_convert(stfilesh,'all','flat','img');


%% dicom import Feildmap to individual's folder

subs = 28:31;
mainpath = '/study/ocf/mri/preprocess/Prep';
cd(mainpath);

for i = 1:length(subs)
    
subfol = strcat('sub',num2str(subs(i))); % subfol = 'sub6'
fullfol = strcat(mainpath,'/',subfol); % fullfol = '/study/ocf/mri/preprocess/Prep/sub6'
cd(fullfol);

    for run =3:4
        sffiles = [];
        swfiles = [];
        
        if run == 1 || run == 2
        dicomdir = strcat('/study1/ocf/mri/preprocess/0',num2str(subs(i)),'/Fieldmap',num2str(run));
        elseif run == 3 || run == 4
        dicomdir = strcat('/study1/ocf/mri/preprocess/0',num2str(subs(i)),'_2/Fieldmap',num2str(run-2));   
        end
        
        Filter = 'Map__3D';% import fieldmaps
        sffiles = spm_select('FPList',dicomdir,Filter);

        %Specify output directory
        outdir = strcat(fullfol,'/Fieldmap',num2str(run));
        
        cd(outdir);
        
        sffilesh = spm_dicom_headers(sffiles);
        spm_dicom_convert(sffilesh,'all','flat','img');
        
        Filter = 'WATER__3D'; % import water maps
        swfiles = spm_select('FPList',dicomdir,Filter);
        cd(outdir);
        
        swfilesh = spm_dicom_headers(swfiles);
        spm_dicom_convert(swfilesh,'all','flat','img');
        
    end
end

%% dicom import EPI images

subs = 17:24;
%mainpath = '/study/ocf/mri/preprocess/Prep';
cd(mainpath);

for i = 1:length(subs)
    subfol = strcat('sub',num2str(subs(i))); % subfol = 'sub6'
    fullfol = strcat(mainpath,'/',subfol); % fullfol = '/study/ocf/mri/preprocess/Prep/sub6'
    cd(fullfol);
    
    for runs = 1:3
        sfiles = [];
        
        %If you want to strcat path from local computer, use the backward
        %slash, but check your computer first.
        %dicomdir = strcat('C:\SweatStudy\PreprocessPipeline\00',num2str(subs(i)),'\unpacked\epi_run',num2str(runs));
        % If you want to stract path from server, use the forward slash
        if runs == 1
            dicomdir = strcat('/Users/bhu/Documents/OCF_fmri/preprocess/0',num2str(subs(i)),'/Precond');
            outdir = strcat(fullfol,'/',epi1name);
            Filter = 'precond';
        elseif runs == 2
            dicomdir = strcat('/Users/bhu/Documents/OCF_fmri/preprocess/0',num2str(subs(i)),'/Cond');
            outdir = strcat(fullfol,'/',epi2name);
            Filter = 'cond';
        elseif runs == 3
            dicomdir = strcat('/Users/bhu/Documents/OCF_fmri/preprocess/0',num2str(subs(i)),'/Postcond');
            outdir = strcat(fullfol,'/',epi3name);
            Filter = 'postcond';
%         if runs == 4
%             dicomdir = strcat('/Users/bhu/Documents/OCF_fmri/preprocess/0',num2str(subs(i)),'_2/Postcond2');
%             outdir = strcat(fullfol,'/',epi4name);
%             Filter = 'postcond';
%         elseif runs == 5
%             dicomdir = strcat('/Users/bhu/Documents/OCF_fmri/preprocess/0',num2str(subs(i)),'_2/Olocalizer');
%             outdir = strcat(fullfol,'/',epi5name);
%             Filter = 'odor';
%         elseif runs == 6
%             dicomdir = strcat('/Users/bhu/Documents/OCF_fmri/preprocess/0',num2str(subs(i)),'_2/Resting');
%             outdir = strcat(fullfol,'/',epi6name);
%             Filter = 'resting';
%         else
%             % dicomdir = strcat('/study1/ocf/mri/preprocess/0',num2str(subs(i)),'_2/Olocalizer2');
%             dicomdir = '/Volumes/Elements/Sub28_PostCond_2_unzipped/Postcond2';
%             outdir = strcat(fullfol,'/',epi7name);
%             Filter = 'postcond';        
        end

        
        sfiles = spm_select('FPList',dicomdir,Filter);
       
        cd(outdir);
        
        % Running the import step actually requires two processes.  This is
        % because spm_dicom_convert needs header information, and it can't
        % just take that from the file itself.  So first we run
        % spm_dicom_headers to create a cell array of header information,
        % and the output from that will be used in spm_dicom_convert to
        % create our output images.
        sfilesh = spm_dicom_headers(sfiles);
        spm_dicom_convert(sfilesh,'all','flat','img');
        
    end
end

%%
%% STEP 2: Slice-Time Correction
% This step performs slice-time correction, which resolves the signal
% values according to the time they were collected.  Because each image is
% really a vision of the brain over the course of time of one TR (in our
% case, 2.35 seconds), this step makes sure that the signal is accurate
% according to the timing of collection.
% 

subs = 38% [35 36 38];%:34;%[28:34]; %34];
% These values are preset according to our needs.  If there is variation in
% any of these, do not use the batch script for that participant; instead,
% use the individual script.
nslices = 48;
TR = 2.35;
TA = 2.301;

% The inputs for the slice-timing command don't use the straight TR and TA
% but two particular timing variables based around them.  These
% calculations are taken directly from spm_slice_timing and correspond to
% what the script would do if given a TR and TA input.
timing = zeros(1,2);
timing(2) = TR - TA;
timing(1) = TA / (nslices -1);

% The slice ordering is specified here.  The current algorithm corresponds
% to an alt-minus/top-down acquisition, with the reference slice being
% close to the middle (this is the slice that others will be corrected to).
sliord = [48:-2:2, 47:-2:1];
refslice = 2;

%mainpath = '/study/ocf/mri/preprocess/Prep';
cd(mainpath);

for i = 1:length(subs)
    subfol = strcat('sub',num2str(subs(i))); % subfol = 'sub6'
    fullfol = strcat(mainpath,'/',subfol); % fullfol = '/study/ocf/mri/preprocess/Prep/sub6'
    cd(fullfol);
    
    for runs = 4:6
        sfiles = [];
        
        %If you want to strcat path from local computer, use the backward
        %slash, but check your computer first.
        %dicomdir = strcat('C:\SweatStudy\PreprocessPipeline\00',num2str(subs(i)),'\unpacked\epi_run',num2str(runs));
        % If you want to stract path from server, use the forward slash
        if runs == 1
            impdir  = strcat(fullfol,'/',epi1name);
        elseif runs == 2
            impdir  = strcat(fullfol,'/',epi2name);
        elseif runs == 3
            impdir  = strcat(fullfol,'/',epi3name);
        elseif runs == 4
            impdir  = strcat(fullfol,'/',epi4name);
        elseif runs == 5
            impdir  = strcat(fullfol,'/',epi5name);
        elseif runs == 6
            impdir  = strcat(fullfol,'/',epi6name);
        else
            impdir  = strcat(fullfol,'/',epi7name);
        end
        
    cd(impdir);
    Filter = 'sRM';
    afiles = spm_select('FPList',impdir,Filter);
    afiles2 = [];
    mm = size(afiles(1,:),2);
    
    for crct = 1:size(afiles,1)
        if strcmp(afiles(crct,mm-2:mm),'img') == 1
            afiles2 = [afiles2; afiles(crct,:)];
        else
        end
    end
    
    afiles = afiles2;
    afiles = afiles(7:length(afiles),:); %This automatically excludes the dummy scans, meaning you don't have to actively remove them before running this step
    
    spm_slice_timing(afiles,sliord,refslice,timing);        
        
    end
    
end

%% STEP 3: Realignment - Session1
% This step aligns all the EPI files so that they don't vary in position
% from one image to another.  This is vital for proper analysis and also
% gives us the motion parameters for the model.

% These flags are the inputs to the realign and reslice commands.  They
% should not vary between subjects; if they do, use the individual script
% for that subject.
subs = 26:31%:34;%:6;

estflag.quality = 0.9;
estflag.sep = 4;
estflag.fwhm = 5;
estflag.rtm = 0;
estflag.interp = 4;

resflag.which = [2 1];
resflag.interp = 4;
resflag.wrap = [0 0 0];
resflag.mask = 1;
resflag.prefix = 'r';

for i = 1:length(subs)
    subfol = strcat('sub',num2str(subs(i)));
    fullfol = strcat(mainpath,'/',subfol);
    
% For realignment we want both sessions in the same run (not all files
% together in one session but two sessions being run in the same call) so
% that they are realigned to each other.  The code is formatted here to
% make sure both sessions are included.
stdir = strcat(fullfol,'/',epi1name); %strcat('C:/SweatStudy/Pilot_fMRI/EPI_files/Realigned');
Filter = 'as';
rfiles1 = spm_select('FPList',stdir,Filter);
rfiles1a = [];
    mm = size(rfiles1(1,:),2);
    
    for crct = 1:size(rfiles1,1)
        if strcmp(rfiles1(crct,mm-2:mm),'img') == 1
            rfiles1a = [rfiles1a; rfiles1(crct,:)];
        else
        end
    end
    
    rfiles1 = rfiles1a;

stdir2 = strcat(fullfol,'/',epi2name); %strcat('C:/SweatStudy/Pilot_fMRI/EPI_files/Realigned');
Filter = 'as';
rfiles2 = spm_select('FPList',stdir2,Filter);
rfiles2a = [];
    mm = size(rfiles2(1,:),2);
    
    for crct = 1:size(rfiles2,1)
        if strcmp(rfiles2(crct,mm-2:mm),'img') == 1
            rfiles2a = [rfiles2a; rfiles2(crct,:)];
        else
        end
    end
    
    rfiles2 = rfiles2a;
    

stdir3 = strcat(fullfol,'/',epi3name); %strcat('C:/SweatStudy/Pilot_fMRI/EPI_files/Realigned');
Filter = 'as';
rfiles3 = spm_select('FPList',stdir3,Filter);
rfiles3a = [];
    mm = size(rfiles3(1,:),2);
    
    for crct = 1:size(rfiles3,1)
        if strcmp(rfiles3(crct,mm-2:mm),'img') == 1
            rfiles3a = [rfiles3a; rfiles3(crct,:)];
        else
        end
    end
    
    rfiles3 = rfiles3a;

rfiles = {rfiles1 rfiles2 rfiles3};


cd(stdir);
%Realignment is a two-step process - actually doing the realignment, and
%then reslicing the images to create the actual output files.  Since we'll
%need those later, we'll be using both commands.
spm_realign(rfiles,estflag);
spm_reslice(rfiles,resflag);
end

%% STEP 3: Realignment - Session2
% This step aligns all the EPI files so that they don't vary in position
% from one image to another.  This is vital for proper analysis and also
% gives us the motion parameters for the model.

% These flags are the inputs to the realign and reslice commands.  They
% should not vary between subjects; if they do, use the individual script
% for that subject.
subs = 9%:6;

estflag.quality = 0.9;
estflag.sep = 4;
estflag.fwhm = 5;
estflag.rtm = 0;
estflag.interp = 4;

resflag.which = [2 1];
resflag.interp = 4;
resflag.wrap = [0 0 0];
resflag.mask = 1;
resflag.prefix = 'r';

for i = 1:length(subs)
    subfol = strcat('sub',num2str(subs(i)));
    fullfol = strcat(mainpath,'/',subfol);
    
% For realignment we want both sessions in the same run (not all files
% together in one session but two sessions being run in the same call) so
% that they are realigned to each other.  The code is formatted here to
% make sure both sessions are included.
stdir = strcat(fullfol,'/',epi4name); %strcat('C:/SweatStudy/Pilot_fMRI/EPI_files/Realigned');
Filter = 'as';
rfiles1 = spm_select('FPList',stdir,Filter);
rfiles1a = [];
    mm = size(rfiles1(1,:),2);
    
    for crct = 1:size(rfiles1,1)
        if strcmp(rfiles1(crct,mm-2:mm),'img') == 1
            rfiles1a = [rfiles1a; rfiles1(crct,:)];
        else
        end
    end
    
    rfiles1 = rfiles1a;

stdir2 = strcat(fullfol,'/',epi5name); %strcat('C:/SweatStudy/Pilot_fMRI/EPI_files/Realigned');
Filter = 'as';
rfiles2 = spm_select('FPList',stdir2,Filter);
rfiles2a = [];
    mm = size(rfiles2(1,:),2);
    
    for crct = 1:size(rfiles2,1)
        if strcmp(rfiles2(crct,mm-2:mm),'img') == 1
            rfiles2a = [rfiles2a; rfiles2(crct,:)];
        else
        end
    end
    
    rfiles2 = rfiles2a;
    

stdir3 = strcat(fullfol,'/',epi6name); %strcat('C:/SweatStudy/Pilot_fMRI/EPI_files/Realigned');
Filter = 'as';
rfiles3 = spm_select('FPList',stdir3,Filter);
rfiles3a = [];
    mm = size(rfiles3(1,:),2);
    
    for crct = 1:size(rfiles3,1)
        if strcmp(rfiles3(crct,mm-2:mm),'img') == 1
            rfiles3a = [rfiles3a; rfiles3(crct,:)];
        else
        end
    end
    
    rfiles3 = rfiles3a;

rfiles = {rfiles1 rfiles2 rfiles3};


cd(stdir);
%Realignment is a two-step process - actually doing the realignment, and
%then reslicing the images to create the actual output files.  Since we'll
%need those later, we'll be using both commands.
spm_realign(rfiles,estflag);
spm_reslice(rfiles,resflag);
end


%% STEP 3b: Realignment - Session2 for sub1&2
% This step aligns all the EPI files so that they don't vary in position
% from one image to another.  This is vital for proper analysis and also
% gives us the motion parameters for the model.

% These flags are the inputs to the realign and reslice commands.  They
% should not vary between subjects; if they do, use the individual script
% for that subject.
subs = 2%:6;

estflag.quality = 0.9;
estflag.sep = 4;
estflag.fwhm = 5;
estflag.rtm = 0;
estflag.interp = 4;

resflag.which = [2 1];
resflag.interp = 4;
resflag.wrap = [0 0 0];
resflag.mask = 1;
resflag.prefix = 'r';

for i = 1:length(subs)
    subfol = strcat('sub',num2str(subs(i)));
    fullfol = strcat(mainpath,'/',subfol);
    
% For realignment we want both sessions in the same run (not all files
% together in one session but two sessions being run in the same call) so
% that they are realigned to each other.  The code is formatted here to
% make sure both sessions are included.
stdir = strcat(fullfol,'/',epi4name); %strcat('C:/SweatStudy/Pilot_fMRI/EPI_files/Realigned');
Filter = 'as';
rfiles1 = spm_select('FPList',stdir,Filter);
rfiles1a = [];
    mm = size(rfiles1(1,:),2);
    
    for crct = 1:size(rfiles1,1)
        if strcmp(rfiles1(crct,mm-2:mm),'img') == 1
            rfiles1a = [rfiles1a; rfiles1(crct,:)];
        else
        end
    end
    
    rfiles1 = rfiles1a;

stdir2 = strcat(fullfol,'/',epi5name); %strcat('C:/SweatStudy/Pilot_fMRI/EPI_files/Realigned');
Filter = 'as';
rfiles2 = spm_select('FPList',stdir2,Filter);
rfiles2a = [];
    mm = size(rfiles2(1,:),2);
    
    for crct = 1:size(rfiles2,1)
        if strcmp(rfiles2(crct,mm-2:mm),'img') == 1
            rfiles2a = [rfiles2a; rfiles2(crct,:)];
        else
        end
    end
    
    rfiles2 = rfiles2a;
    

stdir3 = strcat(fullfol,'/',epi6name); %strcat('C:/SweatStudy/Pilot_fMRI/EPI_files/Realigned');
Filter = 'as';
rfiles3 = spm_select('FPList',stdir3,Filter);
rfiles3a = [];
    mm = size(rfiles3(1,:),2);
    
    for crct = 1:size(rfiles3,1)
        if strcmp(rfiles3(crct,mm-2:mm),'img') == 1
            rfiles3a = [rfiles3a; rfiles3(crct,:)];
        else
        end
    end
    
    rfiles3 = rfiles3a;
    
stdir4 = strcat(fullfol,'/',epi7name); %strcat('C:/SweatStudy/Pilot_fMRI/EPI_files/Realigned');
Filter = 'as';
rfiles4 = spm_select('FPList',stdir4,Filter);
rfiles4a = [];
    mm = size(rfiles4(1,:),2);
    
    for crct = 1:size(rfiles4,1)
        if strcmp(rfiles4(crct,mm-2:mm),'img') == 1
            rfiles4a = [rfiles4a; rfiles4(crct,:)];
        else
        end
    end
    
    rfiles4 = rfiles4a;    
    

rfiles = {rfiles1 rfiles2 rfiles3 rfiles4};


cd(stdir);
%Realignment is a two-step process - actually doing the realignment, and
%then reslicing the images to create the actual output files.  Since we'll
%need those later, we'll be using both commands.
spm_realign(rfiles,estflag);
spm_reslice(rfiles,resflag);
end

%% STEP 4: Censor List
% Run a loop to calculate every volume motion; cutoff 2mm
% This finds points where the motion from one image to another is large
% enough that it can potentially create artifact.  A list is made of images
% where this applies.  This precrocessing scrpit ensures that all relevant
% images are put in the censor list, including images surronding the
% aberrant volumes.

% for i = 1:length(subs)
%     subfol = strcat('sub',num2str(subs(i)));
%     fullfol = strcat(mainpath,subfol);
% for run = 1:2
%     % Import the mation parameters from the text file output by SPM after
%     % realignment.
%     if run == 1
%         rpfile = strcat(fullfol,'\',epi1name,'\rp_asRMRRFSWT001-0004-00001-000336-01');
%     else
%         rpfile = strcat(fullfol,'\',epi2name,'\rp_asRMRRFSWT001-0008-00001-000336-01');
%     end
% rps = importdata(rpfile);
% sub = [2 3 5:18];
sub = 4;
mainpath = '/Volumes/Elements/OCF';
cd(mainpath);

for i = 1:length(sub)
    subfol = strcat('sub',num2str(sub(i)));
    fullfol = strcat(mainpath,'/',subfol);
    
    for run = 1:6
        if run == 1
            impdir = strcat(fullfol,'/',epi1name); %strcat('C:/SweatStudy/Pilot_fMRI/EPI_files/Realigned');
        elseif run == 2
            impdir = strcat(fullfol,'/',epi2name); %strcat('C:/SweatStudy/Pilot_fMRI/EPI_files/Realigned');
        elseif run == 3
            impdir = strcat(fullfol,'/',epi3name);   
        elseif run == 4
            impdir = strcat(fullfol,'/',epi4name); %strcat('C:/SweatStudy/Pilot_fMRI/EPI_files/Realigned');
        elseif run == 5
            impdir = strcat(fullfol,'/',epi5name); %strcat('C:/SweatStudy/Pilot_fMRI/EPI_files/Realigned');
        elseif run == 6
            impdir = strcat(fullfol,'/',epi6name);      
        else
            impdir = strcat(fullfol,'/',epi7name);
        end
        
        cd(impdir);
        Filter = 'rp_asRMR';
        rpfile = spm_select('FPList',impdir,Filter);
        rps = importdata(rpfile);
        %     rps = uiimport('-file');
        %     rps = rps.rps;
        %save ARF_sub
        eval(['save OCF_sub' num2str(sub) '_epi' num2str(run) '_rp.txt rps']);
        
        diffs = [];
        mocalc = [];
        clist = [];
        clistn = [];
        
        % Calculate the motion across images.  This finds the difference in the
        % realignment parameters between each pair of images, corresponding to the
        % amount of motion from one image to the next.  These values are placed
        % into their own array.  The square root of the sum of squares is also
        % caluclated and put into a separate array.  These two arrays are saved
        % with the rps for the purpose of validation.
        for ir = 1:length(rps)-1
            diffs = [diffs; rps(ir+1,:) - rps(ir,:)];
            mocalc = [mocalc; sqrt(diffs(ir,1).^2 + diffs(ir,2).^2 + diffs(ir,3).^2 + diffs(ir,4).^2 + diffs(ir,5).^2 + diffs(ir,6).^2)];
        end
        
        % This finds the images that need to be censored.  The first part finds
        % where the motion was high and the second accounts for the images
        % surrounding the aberrant valume.
        clist = find(mocalc > 2);
        if ~isempty(clist)
            for cs = 1:length(clist)
                clistn = [clistn; clist(cs); clist(cs)+1; clist(cs)+2];
            end
        end
        
        % Save the motion parameters and censor list for later use in the model.
        eval(['save mps_sub' num2str(sub) '_epi' num2str(run) ' rps diffs mocalc']);
        eval(['save censorlist_sub' num2str(sub) '_epi' num2str(run) ' clistn']);
        
        figure; 
        hold on; plot(rps(:,1),'k');
        hold on; plot(rps(:,2),'b');
        hold on; plot(rps(:,3),'g');
        hold on; plot(rps(:,4),'c');
        hold on; plot(rps(:,5),'m');
        hold on; plot(rps(:,6),'y');
        legend('X','Y','Z','r','?','?','Coordinate');
        
        title('Visual inspection');
        
        eval(['saveas(gcf,''OCF_sub' num2str(sub) '_epi' num2str(run) '_rp.jpeg'');']); %Save graph to an Illustrator file
    end
    
end

%% Visual inspection -- plot the motion rp

% figure; plot
% hold on; plot(rps(:,1),'k');
% hold on; plot(rps(:,2),'b');
% hold on; plot(rps(:,3),'g');
% hold on; plot(rps(:,4),'c');
% hold on; plot(rps(:,5),'m');
% hold on; plot(rps(:,6),'y');
% legend('X','Y','Z','r','?','?','Coordinate');
% % figure; plot(horz, F45allresp, 'm'); hold on; plot(horz, F39allresp, 'r'); plot(horz, F33allresp, 'y'); plot(horz, F27allresp, 'c');  plot(horz, F21allresp, 'g'); plot(horz, F15allresp, 'b'); plot(horz, F2allresp, 'k');
% % legend('45%','39%','33%','27%','21%','15%','2%','Location','NorthWest');
% title('Visual inspection');
% 
% eval(['saveas(gcf,''ARF_sub' num2str(sub) '_block' num2str(run) '_rp.ai'');']); %Save graph to an Illustrator file  
% eval(['saveas(gcf,''ARF_sub' num2str(sub) '_block' num2str(run) '_rp.ai'');']);


%% STEP 5: Prepare Fieldmaps - FM1,2
% Here the fieldmaps are prepared for the upcoming correction step.  In
% order to use our fieldmaps we first need to makes the brain out.  This
% calls for a skull-stripped mask, which can be accomplished with a
% segmented water-based image, helpfully output by the fieldmap collection
% step.  The relevant dicoms should already be imported earlier.

% Prepare the mask
subs = 34;

for i = 1:length(subs)
    subfol = strcat('sub',num2str(subs(i)));
    fullfol = strcat(mainpath,'/',subfol);
    for run = 1:2
        switch run
            case 1
                fm_name = fm1name;
                Filter = '-0005';
            case 2
                fm_name = fm2name;
                Filter = '-0011';
            case 3
                fm_name = fm3name;
                Filter = '-0006';
            case 4
                fm_name = fm4name;
                Filter = '-0009';
        end
        
        SetDirectory = strcat(fullfol,'/',fm_name);
        
        
        if subs(i) == 1 && run ==1
            Filter = '-0006'; %This is the image (water map) that we'll be segmenting to make the mask.  WE have tested using this image and it works wery well, and it's certain to properly be in line with the filedmap, while the T1 may be slightly off.
        elseif subs(i) ==1 && run == 3
            Filter = '-0007';
        elseif subs(i) ==1 && run == 4
            Filter = '-0013';
        elseif subs(i) ==2 && run == 1
            Filter = '-0007';
        elseif subs(i) ==2 && run == 2
            Filter = '-0013';
        elseif subs(i) ==2 && run == 3
            Filter = '-0007';
        elseif subs(i) ==2 && run == 4
            Filter = '-0010';
        elseif subs(i) ==3 && run == 2
            Filter = '-0012';
        elseif subs(i) ==4 && run == 2
            Filter = '-0012';
        elseif subs(i) ==10 && run == 1
            Filter = '-0006';
        elseif subs(i) ==10 && run == 2
            Filter = '-0012';
        elseif subs(i) ==10 && run == 3
            Filter = '-0005';
        elseif subs(i) ==10 && run == 4
            Filter = '-0008';
        elseif subs(i) ==15 && run == 4
            Filter = '-0013';  
        elseif subs(i) ==17 && run == 3
            Filter = '-0008';
        elseif subs(i) ==17 && run == 4      
            Filter = '-0011';  
        elseif subs(i) ==18 && run == 3
            Filter = '-0008';
        elseif subs(i) ==18 && run == 4
            Filter = '-0011';           
        elseif subs(i) ==19 && run == 1
            Filter = '-0005';     
        elseif subs(i) ==20 && run == 4
            Filter = '-0006';    
        elseif subs(i) ==24 && run == 3
            Filter = '-0005';
        elseif subs(i) ==24 && run == 4
            Filter = '-0008';  
        elseif subs(i) ==28 && run == 1
            Filter = '-0006';
        elseif subs(i) ==28 && run == 2
            Filter = '-0013';    
        elseif subs(i) ==29 && run == 2
            Filter = '-0013';            
        end
        
        watim = spm_select('FPList',SetDirectory,Filter);
        watim2 = [];
        mm = size(watim(1,:),2);
        
        for crct = 1:size(watim,1)
            if strcmp(watim(crct,mm-2:mm),'img') == 1
                watim2 = [watim2; watim(crct,:)];
            else
            end
        end
        
        watim = watim2;
        cd(SetDirectory);
        
        % The first structure makes sure we get grey matter, white
        % matter, and CSF probability maps, important for making a
        % complete mask.  The second is just the default inputs for
        % image segcmentation.
        output.GM = [0 0 1];
        output.WM = [0 0 1];
        output.CSF = [0 0 1];
        output.biascor = 1;
        output.cleanup = 0;
        opts.tpm = {
            %                     'C:/Program Files/MATLAB/Added_Toolboxes/spm8/spm8/tpm/grey.nii'   % change the directory to your own directory
            %                     'C:/Program Files/MATLAB/Added_Toolboxes/spm8/spm8/tpm/white.nii'  % Eg: mine is C:/Users/YAN/Desktop/Hope's ducuments/Hope files/Apps/Research Software/spm8/tpm/white.nii
            %                     'C:/Program Files/MATLAB/Added_Toolboxes/spm8/spm8/tpm/csf.nii'
            '/apps/spm8-5236/noarch/spm8/tpm/grey.nii'
            '/apps/spm8-5236/noarch/spm8/tpm/white.nii'
            '/apps/spm8-5236/noarch/spm8/tpm/csf.nii'
            };
        opts.ngaus = [2
            2
            2
            4];
        opts.regtype = 'mni';
        opts.warpreg = 1;
        opts.warpco = 25;
        opts.biasreg = 0.0001;
        opts.biasfwhm = 60;
        opts.samp = 3;
        opts.msk = {''};
        
        opts2.cleanup = 0;
        opts2.biascor = 1;
        opts2.GM = [0 0 1];
        opts2.WM = [0 0 1];
        opts2.CSF = [0 0 1];
        
        % This is the function that actually does segmentation.
        % Despite being labeled suspiciously like "preprocess" it
        % is only the segmentation step.
        segmath = spm_preproc(watim,output,opts);
        [sn_a,sn_b] = spm_prep2sn(segmath);
        spm_preproc_write(sn_a,opts2);
        
        
        % Now grab the segmented images and use ImCalc to create
        % the mask.
        SetDirectory = strcat(fullfol,'/',fm_name);
        Filter2 = 'c*';
        
        csegs = spm_select('FPList',SetDirectory,Filter2);
        csegs2 = [];
        mm = size(csegs(1,:),2);
        
        for crct = 1:size(csegs,1)
            if strcmp(csegs(crct,mm-2:mm),'img') == 1
                csegs2 = [csegs2; csegs(crct,:)];
            else
            end
        end
        
        csegs = csegs2;
        csegsdat = spm_vol(csegs);
        
        % To choose the name of your output, make sure to have this
        % set.
        
        info = spm_vol(csegs(1,:));
        info.fname = 'fm_mask.img';
        
        % These are parameters for doing the image calculation.
        % You shouldn't need to change any of them.
        mkflag.dmtx = 0;
        mkflag.mask = 0;
        mkflag.hold = 4;
        
        mflag = {0;0;4};
        
        % The threshold of 0.2 was determined from testing.  It may
        % be a good idea to look at the masks for multiple subjects
        % and vary the threshold a bit to see what's best.
        spm_imcalc(csegsdat,info,'(i1+i2+i3)>0.2',mflag);
        
        % Finally we will mask the fieldmaps.  We must grab both
        % the mask and the fieldmap image.
        
        SetDirectory = strcat(fullfol,'/',fm_name);
        
        Filter3 = num2str(abs(str2num(Filter)*100)+1);% the fieldmap image No. is 100*water image No. + 1
         
        orig1 = spm_select('FPList',SetDirectory,Filter3);
        orig1a = [];
        mm = size(orig1(1,:),2);
        
        for crct = 1:size(orig1,1)
            if strcmp(orig1(crct,mm-2:mm),'img') == 1
                orig1a = [orig1a; orig1(crct,:)];
            else
            end
        end
        
        orig1 = orig1a;
        
        Filter4 = 'mask';
        
        orig2 = spm_select('FPList',SetDirectory,Filter4);
        orig2a = [];
        mm = size(orig2(1,:),2);
        
        for crct = 1:size(orig2,1)
            if strcmp(orig2(crct,mm-2:mm),'img') == 1
                orig2a = [orig2a; orig2(crct,:)];
            else
            end
        end
        
        orig2 = orig2a;
        
        orig = [spm_vol(orig1);spm_vol(orig2)];
        
        fflag.dmtx = 0;
        fflag.mask = 0;
        fflag.hold = 4;
        
        fmflag = {0;0;4};
        
        info2 = spm_vol(orig1);
        info2.fname = 'fpm_maskedFM.img';
        
        % Order is important in this equation.  Here, the binary
        % mask is being made with the mask file, because the mask
        % file is the second image in the input array.  That mask
        % os then being applied to the first image, the fieldmap.
        % If you switch around the order you won't get a fieldmap
        % output, so be careful!  If you input the mask as the
        % first image, then you would have to switch the values.
        % Let's just keep it consistent here for everyone's safety.
        spm_imcalc(orig,info2,'i1.* (i2>0)',fmflag);
        
        
    end
    
end

%% STEP 5b: Prepare Fieldmaps - FM3,4
% Here the fieldmaps are prepared for the upcoming correction step.  In
% order to use our fieldmaps we first need to makes the brain out.  This
% calls for a skull-stripped mask, which can be accomplished with a
% segmented water-based image, helpfully output by the fieldmap collection
% step.  The relevant dicoms should already be imported earlier.

% Prepare the mask
subs = 33%[17:18 20 22:31];

for i = 1:length(subs)
    subfol = strcat('sub',num2str(subs(i)));
    fullfol = strcat(mainpath,'/',subfol);
    for run = 3:4
        switch run
            case 1
                fm_name = fm1name;
                Filter = '-0005';
            case 2
                fm_name = fm2name;
                Filter = '-0011';
            case 3
                fm_name = fm3name;
                Filter = '-0006';
            case 4
                fm_name = fm4name;
                Filter = '-0009';
        end
        
        SetDirectory = strcat(fullfol,'/',fm_name);
        
        if subs(i) == 1 && run ==1
            Filter = '-0006'; %This is the image (water map) that we'll be segmenting to make the mask.  WE have tested using this image and it works wery well, and it's certain to properly be in line with the filedmap, while the T1 may be slightly off.
        elseif subs(i) ==1 && run == 3
            Filter = '-0007';
        elseif subs(i) ==1 && run == 4
            Filter = '-0013';
        elseif subs(i) ==2 && run == 1
            Filter = '-0007';
        elseif subs(i) ==2 && run == 2
            Filter = '-0013';
        elseif subs(i) ==2 && run == 3
            Filter = '-0007';
        elseif subs(i) ==2 && run == 4
            Filter = '-0010';
        elseif subs(i) ==3 && run == 2
            Filter = '-0012';
        elseif subs(i) ==4 && run == 2
            Filter = '-0012';
        elseif subs(i) ==10 && run == 1
            Filter = '-0006';
        elseif subs(i) ==10 && run == 2
            Filter = '-0012';
        elseif subs(i) ==10 && run == 3
            Filter = '-0005';
        elseif subs(i) ==10 && run == 4
            Filter = '-0008';
        elseif subs(i) ==15 && run == 4
            Filter = '-0013';  
        elseif subs(i) ==17 && run == 3
            Filter = '-0008';
        elseif subs(i) ==17 && run == 4      
            Filter = '-0011';  
        elseif subs(i) ==18 && run == 3
            Filter = '-0008';
        elseif subs(i) ==18 && run == 4
            Filter = '-0011';           
        elseif subs(i) ==19 && run == 1
            Filter = '-0005';     
        elseif subs(i) ==20 && run == 4
            Filter = '-0006';    
        elseif subs(i) ==24 && run == 3
            Filter = '-0005';
        elseif subs(i) ==24 && run == 4
            Filter = '-0008';            
        end
        
        watim = spm_select('FPList',SetDirectory,Filter);
        watim2 = [];
        mm = size(watim(1,:),2);
        
        for crct = 1:size(watim,1)
            if strcmp(watim(crct,mm-2:mm),'img') == 1
                watim2 = [watim2; watim(crct,:)];
            else
            end
        end
        
        watim = watim2;
        cd(SetDirectory);
        
        % The first structure makes sure we get grey matter, white
        % matter, and CSF probability maps, important for making a
        % complete mask.  The second is just the default inputs for
        % image segcmentation.
        output.GM = [0 0 1];
        output.WM = [0 0 1];
        output.CSF = [0 0 1];
        output.biascor = 1;
        output.cleanup = 0;
        opts.tpm = {
            %                     'C:/Program Files/MATLAB/Added_Toolboxes/spm8/spm8/tpm/grey.nii'   % change the directory to your own directory
            %                     'C:/Program Files/MATLAB/Added_Toolboxes/spm8/spm8/tpm/white.nii'  % Eg: mine is C:/Users/YAN/Desktop/Hope's ducuments/Hope files/Apps/Research Software/spm8/tpm/white.nii
            %                     'C:/Program Files/MATLAB/Added_Toolboxes/spm8/spm8/tpm/csf.nii'
            '/Volumes/Elements/OCF/tpm/grey.nii'
            '/Volumes/Elements/OCF/tpm/white.nii'
            '/Volumes/Elements/OCF/tpm/csf.nii'
            };
        opts.ngaus = [2
            2
            2
            4];
        opts.regtype = 'mni';
        opts.warpreg = 1;
        opts.warpco = 25;
        opts.biasreg = 0.0001;
        opts.biasfwhm = 60;
        opts.samp = 3;
        opts.msk = {''};
        
        opts2.cleanup = 0;
        opts2.biascor = 1;
        opts2.GM = [0 0 1];
        opts2.WM = [0 0 1];
        opts2.CSF = [0 0 1];
        
        % This is the function that actually does segmentation.
        % Despite being labeled suspiciously like "preprocess" it
        % is only the segmentation step.
        segmath = spm_preproc(watim,output,opts);
        [sn_a,sn_b] = spm_prep2sn(segmath);
        spm_preproc_write(sn_a,opts2);
        
        
        % Now grab the segmented images and use ImCalc to create
        % the mask.
        SetDirectory = strcat(fullfol,'/',fm_name);
        Filter2 = 'c*';
        
        csegs = spm_select('FPList',SetDirectory,Filter2);
        csegs2 = [];
        mm = size(csegs(1,:),2);
        
        for crct = 1:size(csegs,1)
            if strcmp(csegs(crct,mm-2:mm),'img') == 1
                csegs2 = [csegs2; csegs(crct,:)];
            else
            end
        end
        
        csegs = csegs2;
        csegsdat = spm_vol(csegs);
        
        % To choose the name of your output, make sure to have this
        % set.
        
        info = spm_vol(csegs(1,:));
        info.fname = 'fm_mask.img';
        
        % These are parameters for doing the image calculation.
        % You shouldn't need to change any of them.
        mkflag.dmtx = 0;
        mkflag.mask = 0;
        mkflag.hold = 4;
        
        mflag = {0;0;4};
        
        % The threshold of 0.2 was determined from testing.  It may
        % be a good idea to look at the masks for multiple subjects
        % and vary the threshold a bit to see what's best.
        spm_imcalc(csegsdat,info,'(i1+i2+i3)>0.2',mflag);
        
        % Finally we will mask the fieldmaps.  We must grab both
        % the mask and the fieldmap image.
        
        SetDirectory = strcat(fullfol,'/',fm_name);
        
        Filter3 = num2str(abs(str2num(Filter)*100)+1);% the fieldmap image No. is 100*water image No. + 1
         
        orig1 = spm_select('FPList',SetDirectory,Filter3);
        orig1a = [];
        mm = size(orig1(1,:),2);
        
        for crct = 1:size(orig1,1)
            if strcmp(orig1(crct,mm-2:mm),'img') == 1
                orig1a = [orig1a; orig1(crct,:)];
            else
            end
        end
        
        orig1 = orig1a;
        
        Filter4 = 'mask';
        
        orig2 = spm_select('FPList',SetDirectory,Filter4);
        orig2a = [];
        mm = size(orig2(1,:),2);
        
        for crct = 1:size(orig2,1)
            if strcmp(orig2(crct,mm-2:mm),'img') == 1
                orig2a = [orig2a; orig2(crct,:)];
            else
            end
        end
        
        orig2 = orig2a;
        
        orig = [spm_vol(orig1);spm_vol(orig2)];
        
        fflag.dmtx = 0;
        fflag.mask = 0;
        fflag.hold = 4;
        
        fmflag = {0;0;4};
        
        info2 = spm_vol(orig1);
        info2.fname = 'fpm_maskedFM.img';
        
        % Order is important in this equation.  Here, the binary
        % mask is being made with the mask file, because the mask
        % file is the second image in the input array.  That mask
        % os then being applied to the first image, the fieldmap.
        % If you switch around the order you won't get a fieldmap
        % output, so be careful!  If you input the mask as the
        % first image, then you would have to switch the values.
        % Let's just keep it consistent here for everyone's safety.
        spm_imcalc(orig,info2,'i1.* (i2>0)',fmflag);
        
        
    end
    
end
%% Fieldmap correction
% need to add /apps/spm8-5236/noarch/spm8/toolbox/FieldMap  to path

%path('/apps/spm8-5236/noarch/spm8/toolbox/FieldMap')

mainpath = '/Volumes/Elements/OCF';

subs = 3:16;

shortTE = 7;
longTE = 10;

readtime = 17.92;
direction = -1;

for i = 1:length(subs)

        subfol = strcat('sub',num2str(subs(i)));
        fullfol = strcat(mainpath,'/',subfol);
        for run = 1:3
            
            fmap = [];
            files = [];
            
            %For each subject, the fieldmaps will need to be loaded in.  Here you
            %will call for the masked fieldmap that was just made.
            if run == 1
                FMDirectory        = strcat(fullfol,'/',fm1name);
            elseif run == 2
                FMDirectory        = strcat(fullfol,'/',fm2name);
            else run == 3
                FMDirectory        = strcat(fullfol,'/FM2_Postcond');
            end
            Filter            = 'fpm_maskedFM.img';
            
            fmap           = spm_select('FPList',FMDirectory,Filter);
            
            fmap2 = [];
            mm = length(fmap(1,:));
            
            for crct = 1:size(fmap,1)
                if strcmp(fmap(crct,mm-2:mm),'img') == 1
                    fmap2 = [fmap2; fmap(crct,:)];
                else
                end
            end
            
            fmap = fmap2;
            
            
            %For each subject, each EPI must be loaded in and written with the fieldmap
            %correction.  The written files will be prefixed with a u.  Because of the
            %way the files are currently formatted, the last number will increment by
            %48, and the starting number will be 7 (or n + 6) because the first six
            %scans were thrown out.
            if run == 1
                EPIDirectory          = strcat(fullfol,'/',epi1name);
            elseif run == 2
                EPIDirectory          = strcat(fullfol,'/',epi2name);
            elseif run == 3
                EPIDirectory          = strcat(fullfol,'/',epi3name);                
            end
            Filter            = 'ras*';
            files             = spm_select('FPList',EPIDirectory,Filter);
            
            files2 = [];
            mm = length(files(1,:));
            
            for crct = 1:size(files,1)
                if strcmp(files(crct,mm-2:mm),'img') == 1
                    files2 = [files2; files(crct,:)];
                else
                end
            end
            
            files = files2;
            
            % DO NOT MAKE ANY FURTHER CHANGES PAST THIS POINT.  This is taken from
            % the Fieldmap toolbox and does the actual correction; it should run
            % automatically.  There are no visual cues from MATLAB that the
            % correction is running, but you should be able to see the files as
            % they are output by looking at the folder (they will be prefixed with
            % a u and will be made one by one - it goes pretty quickly though).
            
            %=======================================================================
            %
            % Create and initialise parameters for FieldMap toolbox
            %
            %=======================================================================
            
            %
            % Initialise parameters
            %
            ID = cell(4,1);
            IP.P = cell(1,4);
            IP.pP = [];
            IP.fmagP = [];
            IP.wfmagP = [];
            IP.epiP = [];
            IP.uepiP = [];
            IP.nwarp = [];
            IP.fm = [];
            IP.vdm = [];
            IP.et = cell(1,2);
            IP.epifm = [];
            IP.blipdir = [];
            IP.ajm = [];
            IP.tert = [];
            IP.vdmP = []; %% Check that this should be there %%
            IP.maskbrain = [];
            IP.uflags = struct('iformat','','method','','fwhm',[],'bmask',[],'pad',[],'etd',[],'ws',[]);
            IP.mflags = struct('template',[],'fwhm',[],'nerode',[],'ndilate',[],'thresh',[],'reg',[],'graphics',0);
            
            % Initially set brain mask to be empty
            IP.uflags.bmask = [];
            
            % Set parameter values according to defaults
            FieldMap('SetParams');
            
            
            
            %=======================================================================
            %
            % Sets parameters according to the defaults file that is being passed
            %
            %=======================================================================
            
            pm_defaults;        % "Default" default file
            
            
            % Define parameters for fieldmap creation
            IP.et{1} = shortTE;
            IP.et{2} = longTE;
            IP.maskbrain = pm_def.MASKBRAIN;
            
            % Set parameters for unwrapping
            IP.uflags.iformat = pm_def.INPUT_DATA_FORMAT;
            IP.uflags.method = pm_def.UNWRAPPING_METHOD;
            IP.uflags.fwhm = pm_def.FWHM;
            IP.uflags.pad = pm_def.PAD;
            IP.uflags.ws = pm_def.WS;
            IP.uflags.etd = longTE - shortTE;
            
            % Set parameters for brain masking
            IP.mflags.template = pm_def.MFLAGS.TEMPLATE;
            IP.mflags.fwhm = pm_def.MFLAGS.FWHM;
            IP.mflags.nerode = pm_def.MFLAGS.NERODE;
            IP.mflags.ndilate = pm_def.MFLAGS.NDILATE;
            IP.mflags.thresh = pm_def.MFLAGS.THRESH;
            IP.mflags.reg = pm_def.MFLAGS.REG;
            IP.mflags.graphics = pm_def.MFLAGS.GRAPHICS;
            
            % Set parameters for unwarping
            IP.ajm = pm_def.DO_JACOBIAN_MODULATION;
            IP.blipdir = direction;
            IP.tert = readtime;
            IP.epifm = pm_def.EPI_BASED_FIELDMAPS;
            
            
            %=======================================================================
            %
            % Load already prepared fieldmap (in Hz).
            %
            %=======================================================================
            
            %
            % Select field map
            %
            % 24/03/04 - Chloe change below to spm_get(1,'fpm_*.img')...
            % IP.pP = spm_vol(spm_get(1,'fpm_*.img','Select field map'));
            % SPM5 Update
            IP.pP = spm_vol(fmap);
            
            IP.fm.fpm = spm_read_vols(IP.pP);
            IP.fm.jac = pm_diff(IP.fm.fpm,2);
            if isfield(IP,'P') && ~isempty(IP.P{1})
                IP.P = cell(1,4);
            end
            varargout{1} = IP.fm;
            varargout{2} = IP.pP;
            
            
            
            
            % %=======================================================================
            % %
            % % Scale a phase map so that max = pi and min =-pi radians.
            % %
            % %=======================================================================
            %
            %    F=varargin{2};
            %    V=spm_vol(F);
            %    vol=spm_read_vols(V);
            %    mn=min(vol(:));
            %    mx=max(vol(:));
            %    vol=-pi+(vol-mn)*2*pi/(mx-mn);
            %    V.dt(1)=4;
            %    varargout{1} = FieldMap('Write',V,vol,'sc',V.dt(1),V.descrip);
            
            
            
            
            
            %=======================================================================
            %
            % Convert field map to voxel displacement map and
            % do necessary inversions of displacement fields.
            %
            %=======================================================================
            
            %IP=varargin{2};
            %
            % If we already have memory mapped image pointer to voxel
            % displacement map let's reuse it (so not to void possible
            % realignment). If field-map is non-EPI based the previous
            % realignment (based on different parameters) will be non-
            % optimal and we should advice user to redo it.
            %
            % If no pointer already exist we'll make one.
            %
            if isfield(IP,'vdmP') && ~isempty(IP.vdmP)
                msgbox({'Changing this parameter means that if previously',...
                    'you matched VDM to EPI, this result may no longer',...
                    'be optimal. In this case we recommend you redo the',...
                    'Match VDM to EPI.'},...
                    'Coregistration notice','warn','modal');
            else
                if ~isempty(IP.pP)
                    IP.vdmP = struct('dim',    IP.pP.dim(1:3),...
                        'dt',[4 spm_platform('bigend')],...
                        'mat',    IP.pP.mat);
                    IP.vdmP.fname=fullfile(spm_str_manip(IP.pP.fname, 'h'),['vdm5_' deblank(spm_str_manip(IP.pP.fname,'t'))]);
                else
                    IP.vdmP = struct('dim',    IP.P{1}.dim(1:3),...
                        'dt',[4 spm_platform('bigend')],...
                        'mat',    IP.P{1}.mat);
                    IP.vdmP.fname=fullfile(spm_str_manip(IP.P{1}.fname, 'h'),['vdm5_' deblank(spm_str_manip(IP.P{1}.fname,'t'))]);
                end
            end
            
            % Scale field map and jacobian by total EPI readout time
            IP.vdm.vdm = IP.blipdir*IP.tert*1e-3*IP.fm.fpm;
            IP.vdm.jac = IP.blipdir*IP.tert*1e-3*IP.fm.jac;
            
            % Chloe added this: 26/02/05
            % Put fieldmap parameters in descrip field of vdm
            
            vdm_info=sprintf('Voxel Displacement Map:echo time difference=%2.2fms, EPI readout time=%2.2fms',IP.uflags.etd, IP.tert);
            if IP.epifm ==1
                spm_progress_bar('Init',3,'Inverting displacement map','');
                spm_progress_bar('Set',1);
                % Invert voxel shift map and multiply by -1...
                IP.vdm.ivdm = pm_invert_phasemap(-1*IP.vdm.vdm);
                IP.vdm.ijac = pm_diff(IP.vdm.ivdm,2);
                spm_progress_bar('Set',2);
                spm_progress_bar('Clear');
                FieldMap('Write',IP.vdmP,IP.vdm.ivdm,'',IP.vdmP.dt(1),vdm_info);
            else
                FieldMap('Write',IP.vdmP,IP.vdm.vdm,'',IP.vdmP.dt(1),vdm_info);
            end
            varargout{1} = IP.vdm;
            varargout{2} = IP.vdmP;
            
            
            %=======================================================================
            %
            % Load sample EPI image - NO gui
            %
            %=======================================================================
            
            ns = size(files,1);
            %ns = 5; %test value
            
            for i = 1:ns
                %
                % Select EPI
                %
                %IP.epiP = spm_vol(spm_get(1,'*.img','Select sample EPI image'));
                % SPM5 Update
                IP.epiP = spm_vol(files(i,:));
                %IP.epiP = spm_vol(spm_select(1,'image','Select sample EPI image'));
                
                %    varargout{1} = IP.epiP;
                
                %=======================================================================
                %
                % Create unwarped epi - NO gui
                %
                %=======================================================================
                
                %
                % Update unwarped EPI
                %
                %       IP=varargin{2};
                IP.uepiP = struct('fname',   'Image in memory',...
                    'dim',     IP.epiP.dim,...
                    'dt',[64 spm_platform('bigend')],...
                    'pinfo',   IP.epiP.pinfo(1:2),...
                    'mat',     IP.epiP.mat);
                
                % Need to sample EPI and voxel shift map in space of EPI...
                [x,y,z] = ndgrid(1:IP.epiP.dim(1),1:IP.epiP.dim(2),1:IP.epiP.dim(3));
                xyz = [x(:) y(:) z(:)];
                
                % Space of EPI is IP.epiP{1}.mat and space of
                % voxel shift map is IP.vdmP{1}.mat
                tM = inv(IP.epiP.mat\IP.vdmP.mat);
                
                x2 = tM(1,1)*x + tM(1,2)*y + tM(1,3)*z + tM(1,4);
                y2 = tM(2,1)*x + tM(2,2)*y + tM(2,3)*z + tM(2,4);
                z2 = tM(3,1)*x + tM(3,2)*y + tM(3,3)*z + tM(3,4);
                xyz2 = [x2(:) y2(:) z2(:)];
                
                %
                % Make mask since it is only meaningful to calculate undistorted
                % image in areas where we have information about distortions.
                %
                msk = reshape(double(xyz2(:,1)>=1 & xyz2(:,1)<=IP.vdmP.dim(1) &...
                    xyz2(:,2)>=1 & xyz2(:,2)<=IP.vdmP.dim(2) &...
                    xyz2(:,3)>=1 & xyz2(:,3)<=IP.vdmP.dim(3)),IP.epiP.dim(1:3));
                
                % Read in voxel displacement map in correct space
                tvdm = reshape(spm_sample_vol(spm_vol(IP.vdmP.fname),xyz2(:,1),...
                    xyz2(:,2),xyz2(:,3),1),IP.epiP.dim(1:3));
                
                % Voxel shift map must be added to the y-coordinates.
                uepi = reshape(spm_sample_vol(IP.epiP,xyz(:,1),...
                    xyz(:,2)+tvdm(:),xyz(:,3),1),IP.epiP.dim(1:3));% TEMP CHANGE
                
                % Sample Jacobian in correct space and apply if required
                if IP.ajm==1
                    if IP.epifm==1 % If EPI, use inverted jacobian
                        
                        IP.jim = reshape(spm_sample_vol(IP.vdm.ijac,xyz2(:,1),...
                            xyz2(:,2),xyz2(:,3),1),IP.epiP.dim(1:3));
                    else
                        IP.jim = reshape(spm_sample_vol(IP.vdm.jac,xyz2(:,1),...
                            xyz2(:,2),xyz2(:,3),1),IP.epiP.dim(1:3));
                    end
                    uepi = uepi.*(1+IP.jim);
                end
                
                IP.uepiP.dat=uepi.*msk;
                varargout{1}=IP.uepiP;
                
                
                %=======================================================================
                %
                % Write out unwarped EPI
                %
                %=======================================================================
                
                unwarp_info=sprintf('Unwarped EPI:echo time difference=%2.2fms, EPI readout time=%2.2fms, Jacobian=%d',IP.uflags.etd, IP.tert,IP.ajm);
                IP.uepiP = FieldMap('Write',IP.epiP,IP.uepiP.dat,'u',IP.epiP.dt(1),unwarp_info);
                
            end
            
        end

    
end
