% spm_preprocess_all.m
% Preprocessing of multiple fMRI subject data using SPM processing
% commands.  This scrpit brings together importing, slice-time correction,
% realignment, censor listing, and fieldmap correction.
%
% Data must first be unpacked before they can be used here; this will be
% done using other commands, probably outside of MATLAB.
%
%



%% SETUP: Preparation for preprocessing
% This part will take in some inputs so it can properly and consistently
% set up your preprocessing directories.  Note that it is currently set up
% so that it recognizes two runs; this can be amended later to take in a
% variable number of runs, but for our purposes it will suffice as is.

% These are preset so that the rest of the lines will run properly.
sublist = ['empty'];
arraylist = [];
goodpath = 0;

% Input the subjects that are to be preprocessed.  This looks for a number
% or number array, and will not allow strings or other types of inputs.
% This should help prevent some potential errors.
while ~isnumeric(sublist)
    sublist = input('Input subject numbers for preprocessing: '); % Type in the subject numbers here in this format, eg: [7:14]/[7 8 9 10 11...]
    if ~isnumeric(sublist)
        sublist = [];
        warning('You must input a number or number array.');
    else
    end
end

subs = sublist;

% Input the filepath of the master directory.  This should be the directory
% where all subject folders are stored, not going into individual subject
% folders here.  If the input directory doesn't exist, this will pop out a
% warning and ask for a new input - again, should forestall some errors.
while goodpath == 0
    mainpath = input('Input filepath of master directory: ','s'); % eg: /study/sweat/mri/preprocess/yan
    check = exist(mainpath,'dir');
    if check == 0
        warning('That directory does not exist.');
    else
        goodpath = 1;
    end
end

% Here input the names of the directories which will store the different
% types of files within the subject folders.  They aren't being created
% just yet, but this will help to make them when the time comes and also
% keep them static for all participants.  Don't worry if you've already
% made them; nothing will be overwritten.
epi1name = input('enter folder name for first EPI run: ','s'); % EPI1
epi2name = input('enter folder name for second EPI run: ','s'); % EPI2
dum1name = input('enter folder name for first EPI dummies: ','s');
dum2name = input('enter folder name for second EPI dummies: ','s');
fm1name = input('enter folder name for first run fieldmap: ','s');
fm2name = input('enter folder name for second run fieldmap: ','s');
T1name = input('enter folder name for T1: ','s');


%% STEP 1: Importing Dicoms
% Check if you have a folder named unpack in each subject's folder: 
% in this folder, you should not have the packed files
% eg: /yan/006/unpacked/epi_run1(epi_run2/T1/fm_run1/fm_run2).
% Water__3D images should also be put into Feildmap folder -- fm_run1/2)
% You need to change all the "dicomdir" path to your own path:
% eg: Line 110--dicomdir = strcat('/study1/sweat/mri/preprocess/rita/00',num2str(subs(i)),'/unpacked/epi_run',num2str(runs));

for i = 1:length(subs)
    %Create directories or subject folders if they don't already exist
    cd(mainpath);
    subfol = strcat('sub',num2str(subs(i))); % subfol = 'sub6'
    fullfol = strcat(mainpath,'/',subfol); % fullfol = '/study/sweat/mri/preprocess/yan/sub6'
    if ~exist(subfol,'dir')
        mkdir(strcat(mainpath,'/',subfol));
    else
    end
    cd(fullfol);
    
    %Now create the subdirectories within the main directory.  Note that if
    %these already exist, a warning will be output, but the directory will not
    %be remade and nothing will be overwritten.  If it becomes routine to
    %do this before doing any preprocessing here then this will be removed.
    mkdir(strcat(fullfol,'/',epi1name)); % folder: /study/sweat/mri/preprocess/yan/sub6/EP1
    mkdir(strcat(fullfol,'/',epi2name));
    mkdir(strcat(fullfol,'/',dum1name));
    mkdir(strcat(fullfol,'/',dum2name));
    mkdir(strcat(fullfol,'/',fm1name));
    mkdir(strcat(fullfol,'/',fm2name));
    mkdir(strcat(fullfol,'/',T1name));
    
    
    % Import the dicoms for the EPI images.  This will be big so make sure
    % there is enough available space on whatever platform you're using and
    % enough available memory in MATLAB.  If it starts throwing errors
    % about being out of memory, this step may have to be broken up into
    % stages for each run.
    for runs = 2
        sfiles = [];
        
        %If you want to strcat path from local computer, use the backward
        %slash, but check your computer first. 
        %dicomdir = strcat('C:\SweatStudy\PreprocessPipeline\00',num2str(subs(i)),'\unpacked\epi_run',num2str(runs));
        % If you want to stract path from server, use the forward slash
        dicomdir = strcat('/study1/sweat/mri/preprocess/yan/005/unpacked/epi_run2'); % change this path to your path
        Filter = 'SAG_EPI';
        sfiles = spm_select('FPList',dicomdir,Filter);
        
            outdir = strcat(fullfol,'/',epi2name);
       
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
    
    
    % Import the T1 dicoms.  This creates the anatomical image.  We will
    % work on and with these later.
    %dicomdir = strcat('C:/SweatStudy/PreprocessPipeline/00',num2str(subs(i)),'/unpacked/T1'); %strcat('C:/SweatStudy/Pilot_fMRI/EPI_files/Realigned');
    dicomdir = strcat('/study1/sweat/mri/preprocess/yan/00',num2str(subs(i)),'/unpacked/T1'); 
    Filter = 'BRAVO';
    stfiles = spm_select('FPList',dicomdir,Filter);
    outdir = strcat(fullfol,'/',T1name);
    cd(outdir);
    
    stfilesh = spm_dicom_headers(stfiles);
    spm_dicom_convert(stfilesh,'all','flat','img');
    
    
    % Import the fieldmap and watermap dicoms; only applies for those subjects where a
    % good fieldmap was collected.  Those with bad filedmaps, we will not
    % import or use them.
    % Make sure you've put the unpacked Water__3D images into the Fieldmap!!!!!!!!!!!!!
    % folder: /study1/sweat/mri/preprocess/yan/006/unpacked/fm_run1(2)
    
    if subs(i) > 5
        for run = 1:2
            sffiles = [];
            swfiles = [];
            %dicomdir = strcat('C:/SweatStudy/PreprocessPipeline/00',num2str(subs(i)),'/unpacked/fm_run',num2str(run)); 
            dicomdir = strcat('/study1/sweat/mri/preprocess/yan/00',num2str(subs(i)),'/unpacked/fm_run',num2str(run)); 
            Filter = 'Map__3D';% import fieldmaps
            sffiles = spm_select('FPList',dicomdir,Filter);
            
            if run == 1
                outdir = strcat(fullfol,'/',fm1name);
            else
                outdir = strcat(fullfol,'/',fm2name);
            end
            cd(outdir);
            
            sffilesh = spm_dicom_headers(sffiles);
            spm_dicom_convert(sffilesh,'all','flat','img');
            
            %dicomdir = strcat('C:/SweatStudy/PreprocessPipeline/00',num2str(subs(i)),'/unpacked/fm_run',num2str(run)); 
            dicomdir = strcat('/study1/sweat/mri/preprocess/yan/00',num2str(subs(i)),'/unpacked/fm_run',num2str(run));
            Filter = 'WATER__3D'; % import water maps
            swfiles = spm_select('FPList',dicomdir,Filter);
            cd(outdir);
            
            swfilesh = spm_dicom_headers(swfiles);
            spm_dicom_convert(swfilesh,'all','flat','img');
        end
    end
    
end



%% STEP 2: Slice-Time Correction
% This step performs slice-time correction, which resolves the signal
% values according to the time they were collected.  Because each image is
% really a vision of the brain over the course of time of one TR (in our
% case, 2.35 seconds), this step makes sure that the signal is accurate
% according to the timing of collection.

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

% This collects the images and performs the slice-timing operation.  It
% makes no difference whether the files are run in one session or two as
% neither session is dependent on the other for anything; a two-run
% operation is performed here to reduce memory load.
for i = 1:length(subs)
    subfol = strcat('sub',num2str(subs(i)));
    fullfol = strcat(mainpath,'/',subfol);
for run = 1:2
    if run == 1
        impdir = strcat(fullfol,'/',epi1name); %strcat('C:/SweatStudy/Pilot_fMRI/EPI_files/Realigned');
    else
        impdir = strcat(fullfol,'/',epi2name); %strcat('C:/SweatStudy/Pilot_fMRI/EPI_files/Realigned');
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


%% STEP 3: Realignment
% This step aligns all the EPI files so that they don't vary in position
% from one image to another.  This is vital for proper analysis and also
% gives us the motion parameters for the model.

% These flags are the inputs to the realign and reslice commands.  They
% should not vary between subjects; if they do, use the individual script
% for that subject.
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

rfiles = {rfiles1 rfiles2};



cd(stdir);
%Realignment is a two-step process - actually doing the realignment, and
%then reslicing the images to create the actual output files.  Since we'll
%need those later, we'll be using both commands.
spm_realign(rfiles,estflag);
spm_reslice(rfiles,resflag);
end

%% STEP 4: Censor List
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
%         rpfile = strcat(fullfol,'/',epi1name,'/rp_asRMRRFSWT001-0004-00001-000336-01');
%     else
%         rpfile = strcat(fullfol,'/',epi2name,'/rp_asRMRRFSWT001-0008-00001-000336-01');
%     end
%     rps = importdata(rpfile);
%     
%     cd(fullfol);
%     
%     % Set up some variables to ensure they're cleared from one subject to the
%     % next.
%     diffs = [];
%     mocalc = [];
%     clist = [];
%     clistn = [];
%     
%     % Calculate the motion across images.  This finds the difference in the
%     % realignment parameters between each pair of images, corresponding to the
%     % amount of motion from one image to the next.  These values are placed
%     % into their own array.  The square root of the sum of squares is also
%     % caluclated and put into a separate array.  These two arrays are saved
%     % with the rps for the purpose of validation.
%     for ir = 1:length(rps)-1
%         diffs = [diffs; rps(ir+1,:) - rps(ir,:)];
%         mocalc = [mocalc; sqrt(diffs(ir,1).^2 + diffs(ir,2).^2 + diffs(ir,3).^2 + diffs(ir,4).^2 + diffs(ir,5).^2 + diffs(ir,6).^2)];
%     end
%     
%     % This finds the images that need to be censored.  The first part finds
%     % where the motion was high and the second accounts for the images
%     % surrounding the aberrant valume.
%     clist = find(mocalc > 2);
%     if ~isempty(clist)
%         for cs = 1:length(clist)
%             clistn = [clistn; clist(cs); clist(cs)+1; clist(cs)+2];
%         end
%     end
%     
%     % Save the motion parameters and censor list for later use in the model.
%     
%     eval(['save mps_sub' num2str(sub) '_b' num2str(run) ' rps diffs mocalc']);
%     eval(['save censorlist_sub' num2str(sub) '_b' num2str(run) ' clistn']);
%     
%     
% end
% end


%% STEP 5: Prepare Fieldmaps
% Here the fieldmaps are prepared for the upcoming correction step.  In
% order to use our fieldmaps we first need to makes the brain out.  This
% calls for a skull-stripped mask, which can be accomplished with a
% segmented water-based image, helpfully output by the fieldmap collection
% step.  The relevant dicoms should already be imported earlier.

% Prepare the mask

for i = 1:length(subs)
    subfol = strcat('sub',num2str(subs(i)));
    fullfol = strcat(mainpath,subfol);
    if subs(i) > 5
        for run = 1:2
            if run == 1
                SetDirectory = strcat(fullfol,'/',fm1name);
                Filter = '0005'; %This is the image that we'll be segmenting to make the mask.  WE have tested using this image and it works wery well, and it's certain to properly be in line with the filedmap, while the T1 may be slightly off.
                
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
                SetDirectory = strcat(fullfol,'/',fm1name);
                Filter = 'c*';
                
                csegs = spm_select('FPList',SetDirectory,Filter);
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
                
                SetDirectory = strcat(fullfol,'/',fm1name);
                Filter = '0501';
                
                orig1 = spm_select('FPList',SetDirectory,Filter);
                orig1a = [];
                mm = size(orig1(1,:),2);
                
                for crct = 1:size(orig1,1)
                    if strcmp(orig1(crct,mm-2:mm),'img') == 1
                        orig1a = [orig1a; orig1(crct,:)];
                    else
                    end
                end
                
                orig1 = orig1a;
                
                Filter = 'mask';
                
                orig2 = spm_select('FPList',SetDirectory,Filter);
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
            else % Since we have two runs and two fieldmaps, this just does over what was done before, with the second fieldmap.
                SetDirectory = strcat(fullfol,'/',fm2name);
                Filter = '0009'; %This is the image that we'll be segmenting to make the mask.  WE have tested using this image and it works wery well, and it's certain to properly be in line with the filedmap, while the T1 may be slightly off.
                
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
%                     'C:/Program Files/MATLAB/Added_Toolboxes/spm8/spm8/tpm/grey.nii'
%                     'C:/Program Files/MATLAB/Added_Toolboxes/spm8/spm8/tpm/white.nii'
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
                SetDirectory = strcat(fullfol,'/',fm2name);
                Filter = 'c*';
                
                csegs = spm_select('FPList',SetDirectory,Filter);
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
                
                SetDirectory = strcat(fullfol,'/',fm2name);
                Filter = '0901';
                
                orig1 = spm_select('FPList',SetDirectory,Filter);
                orig1a = [];
                mm = size(orig1(1,:),2);
                
                for crct = 1:size(orig1,1)
                    if strcmp(orig1(crct,mm-2:mm),'img') == 1
                        orig1a = [orig1a; orig1(crct,:)];
                    else
                    end
                end
                
                orig1 = orig1a;
                
                Filter = 'mask';
                
                orig2 = spm_select('FPList',SetDirectory,Filter);
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
                spm_imcalc(orig,info2,'i1 * (i2>0)',fmflag);
            end
        end
    end
end





%% STEP 6: Fieldmap Correction
% Here we actually perform the correction for the inhomogeneity in the
% magnetic fields.  This is important for getting less distorted values and
% reducing dropout.  Unfortunately we can't do this for all subjects, but
% we will do it for the ones where we have good fieldmaps.

% Only subs with valid fieldmaps will undergo the correction.  All that
% needs to be loaded in are the masked fieldmap and the EPI files;
% everything else in this section will not need adjustment.


%Fieldmap Parameters - CHECK ON THESE AND MAKE SURE THEY'RE ACCURATE.  The
%TE values might net be needed since the fieldmap is premade, but the
%readtime and direction are specified during the unwarping phase.
shortTE = 7;
longTE = 10;

readtime = 17.92;
direction = -1;

for i = 1:length(subs)
    if subs(i) > 5
        subfol = strcat('sub',num2str(subs(i)));
        fullfol = strcat(mainpath,subfol);
        for run = 1:2
            
            fmap = [];
            files = [];
            
            %For each subject, the fieldmaps will need to be loaded in.  Here you
            %will call for the masked fieldmap that was just made.
            if run == 1
                FMDirectory        = strcat(fullfol,'/',fm1name);
            else
                FMDirectory        = strcat(fullfol,'/',fm2name);
            end
            Filter            = 'fpm*';
            
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
            else
                EPIDirectory          = strcat(fullfol,'/',epi2name);
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
                tM = inv(IP.epiP.mat/IP.vdmP.mat);
                
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
    
end




