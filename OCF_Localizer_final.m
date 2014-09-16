%LocTask.m
%Task for localizer scan after palatability tasks

%Pre-clearing the workspace ensures that no values are accidentally carried
%over that should not be.
clear all

%The Waisman Brain Imaging Lab computers put all experiments into a folder
%labeled "My Experiments."  Because of the space in the file name, just
%putting the line into cd does not work, because cd does not like spaces.
%However, setting the file path to a pre-established string variable
%removes this problem, hence the use of dm and later dmat.
clear all

dm = 'C:\My Experiments\Wen_Li\OCF'; %make sure to create this folder in the scanner computer
cd (dm);
%
log_file_name = input('Log file name ?','s');
log_init(log_file_name) ;
name_id = input('Partiticpant initials ? ','s');
subnum = input('Subject number? ');
subinfo = sprintf('name_id = %s, sub no. = %d', name_id,subnum); %The above inputs are taken and set into a single variable which is saved later in the script
sess = subnum+4; %Used just below

%****Removed cell break here for behavioral****
%% Create matrix of randomized odor ID information.

rand('state',100+(sess*3)); 
%The rand command uses pseudo-random generation; it returns a number based
%on an internal state that resets every time MATLAB is reset.  Needs to be
%kept in mind when writing randomization.

%4 localizer odors * 15 trials + 30 no odor trials = 90 trials
stimordA = repmat([1 2 3 4 5 5],1,1); stimordA = stimordA(randperm(6));  % 1-4 are odors, 5 is air
stimorda = [3 5 1 4 2 5];
stimordB = repmat([1 2 3 4 5 5],1,1); stimordB = stimordB(randperm(6));  
stimordb = [1 5 4 5 3 2];
stimordC = repmat([1 2 3 4 5 5],1,1); stimordC = stimordC(randperm(6));

stimordD = repmat([1 2 3 4 5 5],1,1); stimordD = stimordD(randperm(6));  % 1-4 are odors, 5 is air
stimordd = [4 1 3 5 2 5];
stimordE = repmat([1 2 3 4 5 5],1,1); stimordE = stimordE(randperm(6)); 
stimorde = [5 2 1 5 3 4];
stimordF = repmat([1 2 3 4 5 5],1,1); stimordF = stimordF(randperm(6));

stimordG = repmat([1 2 3 4 5 5],1,1); stimordG = stimordG(randperm(6));  % 1-4 are odors, 5 is air
stimordg = [1 4 5 3 5 2];
stimordH = repmat([1 2 3 4 5 5],1,1); stimordH = stimordH(randperm(6));
stimordh = [2 1 5 4 5 3];
stimordI = repmat([1 2 3 4 5 5],1,1); stimordI = stimordI(randperm(6));

%All stimord* sets are put into one array, the easier to be called later on
%in the presentation loop.
StimR =[stimordA, stimorda, stimordB, stimordb, stimordC, stimordD, stimordd, stimordE, stimorde, stimordF, stimordG, stimordg, stimordH, stimordh, stimordI];

%% Configure options for fMRI

%These variables are input manually at the start of the program.  They are
%used to indicate where the program is being used.  This is because set-up
%for the scanner and the lab are different and some options won't be
%available at one of the locations.
whichplace = 3;
while whichplace>2
    whichplace = input('At the Scanner (1) or Lab/Office (2) ? ');
end

whichkeys = 3;
while whichkeys>2
    whichkeys = input('Using MRI keypad (1) or Other (2) ? ');
end

% Experimental variables


TR = 2.35; %This is the time it takes for the scanner to run through one slice, or one full view of the brain.  Knowing the TR can help ensure proper timing between the script and the MRI.
ndummies = 6; %The number of slices to run through before starting the real scan.  The first few slices have faulty responses due to needing time to calibrate and settle in; discarding the first six slices removes possibly faulty responses early in the scan.

SOA = TR*6000 ; %Each trial is 14.1 seconds long (TR=2.35 * 6 = 14.1 s)changed to allow for clear of odor
%% Set up olfactometer, triggers & Cogent.
%Configure equipment

usb2_config ; %This is a program that allows configuration of the olfactometer, so that channels can be turned on and off
parallel_config ; %For reading trigger on the parallel port; this is one method of communication between the scanner and the program, and critical for proper timing 
%parallel_config_lab; %If the program is being tested in the lab, this allows it to run through without hanging

% Necessary for callback function to operate properly.  This is for the
% serial input from the button box to the MATLAB computer.
global button_pressed ;

% Load and configure Cogent
cgloadlib
cgopen(1,0,0,1)
log_start_timer ;
log_header ;

gsd = cggetdata('gsd') ;
gpd = cggetdata('gpd') ;

ScrWid = gsd.ScreenWidth ;
ScrHgh = gsd.ScreenHeight ;

%Setting up variables for later use

stimindex=[]; %Matrix of which odor was used in each trial--should match column 1 of stimord
startTimes = [];
odorindex = [];
odorpresindex = [];

odoronTimes  = []; %Index of all odor onset times in order of occurrence
odordurTimes = []; %Index of all odor duration times in order of occurrence
odoronMRtimes = []; %Index of all odor onset times in order of occurrence corrected for scanner time
odoronTimes_present  = cell(1,2);
odordurTimes_present  = cell(1,2);
odoronMRtimes_present = cell(1,2);

odoronTimes_indodorind  = cell(1,5); %Index of all odor onset times sorted by odor condition
odordurTimes_indodorind = cell(1,5); %Index of all odor duration times sorted by odor condition
odoronMRtimes_indodorind = cell(1,5); %Index of all odor onset times sorted by odor condition corrected for scanner time
yes_odoronTimes  = cell(1,5); %Index of all odor onset times with correct responses sorted by odor condition
yes_odordurTimes  = cell(1,5); %Index of all odor duration times with correct responses sorted by odor condition
yes_odoronMRtimes  = cell(1,5); %Index of all odor onset times with correct responses sorted by odor condition and corrected for scanner time
yes_odoronTimes_present  = cell(1,2); %Index of all odor onset times correctly answered sorted by presence of odor
yes_odordurTimes_present  = cell(1,2); %Index of all odor duration times correctly answered sorted by presence of odor
yes_odoronMRtimes_present  = cell(1,2); %Index of all odor onset times correctly answered sorted by presence of odor and corrected for scanner time
no_odoronTimes = []; %Index of all control air onset times correctly answered
no_odordurTimes = []; %Index of all control air duration times correctly answered
no_odoronMRtimes = []; %Index of all control air onset times correctly answered corrected for scanner time
miss_onTimes = cell(1,5); %Index of all onset times where odor was present but answer indicated it wasn't
miss_durTimes = cell(1,5); %Index of all duration times where odor was present but answer indicated it wasn't
miss_onMRtimes =  cell(1,5); %Index of all onset times where odor was present but answer indicated it wasn't, corrected for scanner time
fa_onTimes = []; %Index of all onset times where odor was absent but answer indicated it was
fa_durTimes = []; %Index of all duration times where odor was absent but answer indicated it was
fa_onMRtimes = []; %Index of all onset times where odor was absent but answer indicated it was, corrected for scanner time
noresp_onTimes  = []; %Index of all onset times where no answer was given
noresp_durTimes = []; %Index of all duration times where no answer was given
noresp_onMRtimes = []; %Index of all onset times where no answer was given corrected for scanner times

allRTs_odorind = cell(1,5); %Index of all response times sorted by condition

RTs_odorid  = cell(1,5); %Index of correct response times sorted by condition (with 5 being no odor, a correct rejection)
missRTs  = []; %Index of miss response times (no odor detected during odor condition)
faRTs = []; %Index of false alarm response times (odor detected during control air condition)

allButtOns_MRtimes = [];%***for fMRI version**** 

acc = zeros(1,5); %Accuracy rate for odors by given condition
cr = 0; %Accuracy rate for control air
miss = zeros(1,5); %Inaccuracy rate for odors
fa = 0; %Inaccuray rate for control air
noresp = 0; %Number of trials for which no response was given

presses = 0;%added back in for allButtOns resp 3/29

%For checking the responses recorded by the button box and ensuring their
%accuracy
resp=[]; %For a single trial
resp_all =[]; %Cumulative for all trials
resp_r = []; %For checking

rtypes = [];
rtype = 0;

trialtime_log=[]; %need this here???


log_string(subinfo);

%% SUDS rating

% cgloadbmp(1,'OCF_rating.bmp');
% 
% cgrect(0, 0, ScrWid, ScrHgh, [0.6 0.6 0.6])  % Clear back screen to white
% cgdrawsprite(1,0,0);
% cgfont('Arial',36);
% cgpencol(0,0,0);
% cgtext('Rate your feelings using the button box',0, 2.4 * ScrHgh / 6 - 15);
% cgflip(0,0,0)

%Which buttons have the function of increase, decrease, or finishing the
%question
r_inc = 3; %green button
r_dec = 2; %yellow button
r_sel = 1; %blue button
but_resp=0;

% pause on;
% pause(3);

FlushEvents();
rating = 0;
ok_trig = 0;
keyStrings = {'b','y','g','r'};

keyExists = 0;
keyReg = 0;

for i = 1
    rating = 0; %The current position of the selection line
    ok_trig = 0; %The key value for finishing the question
    
    %Draw the question, rating line, current position, and instructions
    cgrect(0, 0, ScrWid, ScrHgh, [0.6 0.6 0.6]);
    cgtext('How distressed/anxious are you feeling now?',0, 100);
    cgdraw([-200],[-50],[200],[-50]);
    cgdraw([rating],[-40],[rating],[-60]);
    cgdraw([-200 0 200],[-55 -55 -55],[-200 0 200],[-45 -45 -45])
    
    cgtext('Moderately',0, -115);
    cgtext('Not at all',-200, -115);
    cgtext('Extremely',200, -115);
    cgflip;
    pause(.5); %The script waits half a second before allowing any inputs - ensures that early button presses aren't registered
    FlushEvents();
    while ok_trig == 0
        
        [keyIsDown,press_time,keyArr] = KbCheck(); %Check the button box for inputs
        
        %Everything from here on is nested in if loops.  This is so the
        %only thing that is continuously being run is KbCheck.  There will
        %be trigger values to move on to every subsequent loop.  This is
        %not graceful but it should work.
        
        if keyIsDown == 1 && keyExists == 0
            %This just enusres that we're looking only for the correct keys
            keyListCoded = zeros(size(keyArr));
            if nargin<1 || isempty(keyStrings)
                keyListCoded = 1-keyListCoded;
            else
                keyListCoded(KbName(keyStrings)) = 1;
            end
            
            key = KbName(find(keyArr)); %Finds the identity of the keys that are pressed
            keyExists = 1;
        else
        end
        
        %This loop only runs if the previous loop runs.  This ensures that
        %everything properly runs sequentially (having keyIsDown here may
        %not ensure this since it is the dependency of the previous loop as
        %well).
        if keyExists == 1 && keyReg==0
            % if ~iscell(key) && key == 't' %Filters out TTL values when they are the only things there
            %     key=[];
            %    keyExists = 0;
            % else
            % resp_length=length(key); %If there are two simultaneous inputs, key will be a cell; this must be filtered.
            %                 for i=1:(resp_length+1)
            %                     keycell={'l'};
            %                     keycell(1,i+1)={key};
            button=key;
            if button=='b'
                but_resp=1;
                keyReg = 1; %The reason this is here is so it only reads the first correct button press.  Just in case there are two button presses that correspond to functional keys, rather than 't'.
            elseif button=='y'
                but_resp=2;
                keyReg = 1;
            elseif button=='g'
                but_resp=3;
                keyReg = 1;
            else
            end
            %  end
            % end
        end
        
        %This loop only runs if one of the buttons above has been pressed.
        %This is where the actual visual change takes place.
        if keyReg == 1
            if but_resp == r_dec
                %First, registor the rating change.  The screen has to be
                %redrawn - unfortunately it cannot be done in a simpler way
                %at this time.
                rating = rating - 8;
                if rating < -200
                    rating = -200;
                end
                cgrect(0, 0, ScrWid, ScrHgh, [0.6 0.6 0.6]);
                cgtext('How distressed/anxious are you feeling now?',0, 100);
                cgdraw([-200],[-50],[200],[-50]);
                cgdraw([rating],[-40],[rating],[-60]);
                cgdraw([-200 0 200],[-55 -55 -55],[-200 0 200],[-45 -45 -45])
                
                cgtext('Moderately',0, -115);
                cgtext('Not at all',-200, -115);
                cgtext('Extremely',200, -115);
                cgflip;
                
                %Now clear things out.  Reset all trigger variables to
                %their starting state and flush the inputs.  The pause
                %makes sure that participants can move up and down in
                %controlled increments - without the pause the marker would
                %move too quickly.
                FlushEvents;
                but_resp=0;
                keyExists = 0;
                keyReg = 0;
                pause(.05)
            elseif but_resp == r_inc
                rating = rating + 8;
                if rating > 200
                    rating = 200;
                end
                cgrect(0, 0, ScrWid, ScrHgh, [0.6 0.6 0.6]);
                cgtext('How distressed/anxious are you feeling now?',0, 100);
                cgdraw([-200],[-50],[200],[-50]);
                cgdraw([rating],[-40],[rating],[-60]);
                cgdraw([-200 0 200],[-55 -55 -55],[-200 0 200],[-45 -45 -45])
                
                cgtext('Moderately',0, -115);
                cgtext('Not at all',-200, -115);
                cgtext('Extremely',200, -115);
                cgflip;
                
                FlushEvents;
                but_resp=0;
                keyExists = 0;
                keyReg = 0;
                pause(.05)
                
            elseif but_resp == r_sel
                ok_trig = 1;
                
                %Put this here just in case this script needs to loop for
                %other ratings.  It should have no impact on the single
                %rating.
                FlushEvents;
                but_resp=0;
                keyExists = 0;
                keyReg = 0;
            else
                FlushEvents;
            end
            
        end
    end
end
distressed_preLocalizer = 50 + (rating / 4);
%%%%%%end of rating

%% Present general instructions

% Clear back page
cgrect(0, 0, ScrWid, ScrHgh, [0.6 0.6 0.6]) %Creates a screen-sized white rectangle, effectively "clearing" the screen.
cgfont('Arial',36) %Font and size of the text
cgpencol(0,0,0) %This is the black color for text
% Write out Sniff Text
cgtext('Sniff when you see ',0, 2.4 * ScrHgh / 6 - 15); %The text to input, the lateral location on the screen, the vertical location on the screen; all text will be oriented centrally around this point
cgpencol(1, 0, 0); % This is the red color for text
strSniff = '"SNIFF NOW"' ; %Another way of inputting text; set the string beforehand and call it instead of writing the actual string in the cgtext command
cgtext(strSniff,0,1.8 * ScrHgh / 6 - 15);
cgpencol(0,0,0);
cgtext('Press the GREEN button if you think',0,1.2*ScrHgh / 6 - 15);%should be the blue button
cgtext('there IS a smell',0,0.6*ScrHgh / 6 - 15);
cgtext('Press the YELLOW button if you think',0,0*ScrHgh/6 - 15);%this should be the yellow/fuzzy button
cgtext('there is NO smell',0,-0.6 * ScrHgh/6 - 15);
cgflip %This puts everything up on the screen.  Until this is called, all of the above is stored for use.


pause on %Allows use of the pause command.
pause(7); %Set everything to pause for ten seconds (all pause values are in seconds; make sure you don't use milliseconds here); this allows time for the participant to read the instructions on the screen.

cgloadbmp(2,'OCF_localizer.bmp');

cgrect(0, 0, ScrWid, ScrHgh, [0.6 0.6 0.6])  % Clear back screen to white
cgdrawsprite(2,0,0);
cgflip
pause on
pause(3);

%A red fixation cross is drawn on the screen, giving the participant a
%place to focus their eyes.
% present crosshair
cgrect(0, 0, ScrWid, ScrHgh, [0.6 0.6 0.6])
cgfont('Arial',60);
cgpencol(1,0,0);
cgtext('+',0,0);
cgflip

cgrect(0, 0, ScrWid, ScrHgh, [0.6 0.6 0.6])


if whichplace == 1  %If the study is in the scanner, as indicated in the set-up
    
    % Wait here for the first bold rep trigger to occur.
    parallel_wait;
    
    % Grab the time 
    scanon = cogstd('sGetTime', -1) * 1000;
    
else  %If the study is not in the scanner
    scanon = cogstd('sGetTime', -1) * 1000;%Acquires the time
    pause(5) %A five second pause
end



% Change crosshair color to blue.  This is to indicate to the experimenters
% that the parallel port received the trigger and is now getting baseline
% information.  This crosshairs will stay up for 30 seconds, the
% recommended length of baseline data gathering.
cgrect(0, 0, ScrWid, ScrHgh, [0.6 0.6 0.6])
cgfont('Arial',60);
cgpencol(1,1,0); %yellow
cgtext('+',0,0);
cgflip

mrigo = sprintf('MRI scanner ON time at %d ms',scanon);
log_string(mrigo);
mristarttime = scanon;
mristarttimes = sprintf('MRI scanner first trigger ON time at %d ms',mristarttime);
log_string(mristarttimes);

%Starts recording at the proper time, on the seventh TR (first 6 TRs are
%dummies, used to get scanner to equilibrium)
if whichplace == 1  % scanner
    % wait until get close to all dummy volumes = TR 2s * 6 vol
    
    while ((cogstd('sGetTime', -1) * 1000) < mristarttime + (ndummies * TR * 1000))
        
        % this way, by subtr. 1000, there is one sec before next '53'
        % thus, the first timestamp will occur at start of 7th dummy
    end
    
else
    pause(11);
end

timectr=[];



%% Run each trial with instructions, using "for" loop
%Instructions go here
for i = 1:length(StimR) 

    
    trialtime = cogstd('sGetTime', -1) * 1000 ;
    if (i == 1)
        scanon_7th = trialtime;
        starttime  = trialtime;  %this is the 1st 53 input after the 6th dummy
        parallel_acquire; %equivalent of dio_acquire here for 7th dummy
    end
    
    startTimes=[startTimes trialtime];%log the beginning of each trial
    
    odorid=StimR(i);
    odorindex = [odorindex odorid];
    
    switch odorid
        case (1)
            portid = 1; %on PortA
            odorpres = 1;
        case (2)
            portid = 6; %on PortA
            odorpres = 1;
        case (3)
            portid = 3; %on PortA
            odorpres = 1;
        case (4)
            portid = 8; %on PortA
            odorpres = 1;
        case (5)
            portid = 4; %on PortA
            odorpres = 2;

    end    
%This cue lets participants know that a sniff cue is coming soon.  This
%allows them to prepare for the sniff.
    
        readycue='GET READY !';
        cgrect(0, 0, ScrWid, ScrHgh, [0.6 0.6 0.6])  % Clear back screen to white
        cgpencol(0,0,0)  % Black
        cgtext(readycue,0,0);
        cgflip
        pause(3);  % Wait for two seconds
        
        cgrect(0, 0, ScrWid, ScrHgh, [0.6 0.6 0.6])  % Clear back screen to white
        cgtext('3',0,0);
        cgflip
        t1 = cogstd('sGetTime', -1) * 1000 ;
        while ((cogstd('sGetTime', -1) * 1000) < (t1 + 992)) end
        
        cgrect(0, 0, ScrWid, ScrHgh, [0.6 0.6 0.6])  % Clear back screen to white
        cgtext('2',0,0);
        cgflip
        t2 = cogstd('sGetTime', -1) * 1000 ;
        while ((cogstd('sGetTime', -1) * 1000) < (t2 + 992)) end
        
        
        cgrect(0, 0, ScrWid, ScrHgh, [0.6 0.6 0.6])  % Clear back screen to white
        cgtext('1',0,0);
        cgflip
        t3 = cogstd('sGetTime', -1) * 1000 ;
        while ((cogstd('sGetTime', -1) * 1000) < (t3 + 992)) end
        
        
            usb2_line_on(portid,0);
        
        odor_on = cogstd('sGetTime', -1) * 1000 ;
        parallel_acquire; % send trigger to Physio
        
        % *** SNIFF CUE ON ***
        cgrect(0, 0, ScrWid, ScrHgh, [0.6 0.6 0.6])  % Clear back screen to white
        cgtext('SNIFF NOW',0,0);
        cgflip
        
        
        % Prepare for response logging
        
        button_pressed=false;
        odorofftrue = 0;
        key=[];
        keyStrings = {'b','y','g','r'};
        
        
        while ((cogstd('sGetTime', -1) * 1000) < (odor_on + 1800)) end
        
        % *** SNIFF CUE OFF ***
        usb2_line_on(0,0);
        
        % log the odor off time
        odoroff = (cogstd('sGetTime', -1) * 1000) ;
        odorofftrue = 1;
        
        cgrect(0, 0, ScrWid, ScrHgh, [0.6 0.6 0.6])
        cgfont('Arial',60);
        cgpencol(0,1,0); %green
        cgtext('+',0,0);
        % Clear back screen to white
        cgflip
                
        
        while ((cogstd('sGetTime', -1) * 1000) < (odoroff + 5242))
            
            %    ** Response Logging: done; need testing
            response_time = 0;
            
            while isempty(key) && (odorofftrue == 1)
                [key,rtptb] = GetKey(keyStrings,5,GetSecs,-1);
                t_in_cog = (cogstd('sGetTime', -1) * 1000);
            end
            
            response_time = t_in_cog - odor_on;
            
            if ~isempty(key) && button_pressed == false
                
                if iscell(key)
                    if key{1,1} == 'b' || key{1,1} == 'y' || key{1,1} == 'g' || key{1,1} == 'r'
                        key = key{1,1};
                    else
                        key = key{1,2};
                    end
                end
                
                if  key=='g' % odor present
                    but_resp=1;%1 for odor presence 
                    resp_all = [resp_all; i but_resp response_time];
                    button_pressed = true;
                elseif key=='y' % odor absent
                    but_resp=0; %0 for odor absence
                    resp_all = [resp_all; i but_resp response_time];
                    button_pressed = true;
                else
                    but_resp=NaN;
                    resp_all = [resp_all; i but_resp response_time];
                    button_pressed = true;
                end
            end
            
        end
        
        if (response_time ~= 0)
            key_str = sprintf ('Key\t%d\tDOWN\tat\t%0.1f\n', but_resp, response_time) ;
            log_string(key_str) ;
        end        

        
        odoronTimes = [odoronTimes odor_on];
        odordurTimes = [odordurTimes odoroff-odor_on];

    odoronTimes_indodorind{odorid} = [odoronTimes_indodorind{odorid} odor_on]; %Collects the odor onset time and sorts it into the specific odor condition
    odordurTimes_indodorind{odorid} = [odordurTimes_indodorind{odorid} odoroff-odor_on]; %Collects the odor duration time and sorts it into the specific odor condition
    odoronMRtimes_indodorind{odorid} = [odoronMRtimes_indodorind{odorid} odor_on-starttime]; %Collects the odor onset time, corrects it for the MRI scanner time, and sorts it into the specific odor condition
    
    odoronTimes_present{odorpres}  = [odoronTimes_present{odorpres} odor_on];
    odordurTimes_present{odorpres}  = [odordurTimes_present{odorpres} odoroff-odor_on];
    odoronMRtimes_present{odorpres} = [odoronMRtimes_present{odorpres} odor_on-starttime];
    
    rtype = 0;
    % now collate responses
    if button_pressed    % If any button response was recorded, byte_in should be greater than 0.
        response = but_resp ; %Response is the value that everything will be compared to.
        presses = presses + 1; %Records if a button was pressed during the trial; this should be equal to the number of trials
        rt = response_time; % The response time is the time from the odor onset to the time of the button press.
        allRTs_odorind{odorid}  = [allRTs_odorind{odorid} rt]; %Collates response times by condition

        if (odorid < 5 && response == 1) % i.e. correct to press 'yes' right button
            RTs_odorid{odorid}  = [RTs_odorid{odorid} rt];  %Sorts the reaction time into an array for correct responses only
            buttstr = 'HIT: odor present';
            acc(odorid) = acc(odorid) + 1; %Marks an accurate response for the particular odor given in the trial
            rtype = 1; %hit
            yes_odoronTimes{odorid}  = [yes_odoronTimes{odorid} odor_on]; %Records odor onset time for the correct response
            yes_odordurTimes{odorid}  = [yes_odordurTimes{odorid} odoroff-odor_on]; %Records odor duration time for the correct response
            yes_odoronMRtimes{odorid}  = [yes_odoronMRtimes{odorid} odor_on-starttime]; %Records odor onset time for the correct response corrected for scanner time
            yes_odoronTimes_present{odorpres} = [yes_odoronTimes_present{odorpres} odor_on]; %Records odor onset time for the correct response of any odor
            yes_odordurTimes_present{odorpres} = [yes_odordurTimes_present{odorpres} odoroff-odor_on]; %Records odor duration time for the correct response of any odor
            yes_odoronMRtimes_present{odorpres} = [yes_odoronMRtimes_present{odorpres} odor_on-starttime]; %Records odor onset time for the correct response of any odor corrected for scanner time

        elseif (odorid == 5 && response == 0) % i.e. correct to press 'no' left button
            RTs_odorid{odorid}  = [RTs_odorid{odorid} rt];   % Sorts the reaction time into an array for correct responses only
            buttstr = 'CORR REJ: odor absent';
            cr = cr + 1; %Marks an accurate response for a control air condition
            rtype = 2; % correct rejection
            no_odoronTimes  = [no_odoronTimes odor_on]; %Records odor onset time for the correct rejection
            no_odordurTimes = [no_odordurTimes odoroff-odor_on]; %Records odor duration time for the correct rejection
            no_odoronMRtimes    = [no_odoronMRtimes odor_on-starttime]; %Records odor onset time for the correct rejection corrected for scanner time
            yes_odoronTimes_present{odorpres} = [yes_odoronTimes_present{odorpres} odor_on]; %Records odor onset time for the correct response of any odor
            yes_odordurTimes_present{odorpres} = [yes_odordurTimes_present{odorpres} odoroff-odor_on]; %Records odor duration time for the correct response of any odor
            yes_odoronMRtimes_present{odorpres} = [yes_odoronMRtimes_present{odorpres} odor_on-starttime]; %Records odor onset time for the correct response of any odor corrected for scanner time

        elseif (odorid < 5 && response == 0) % i.e. incorrect to press 'no' left button
            missRTs  = [missRTs rt]; % incorrect missed-odour RTs
            buttstr = 'MISS: odor MISS trial';
            miss(odorid) = miss(odorid) + 1; %Marks an inaccurate response for an odor condition
            rtype = 3; %miss/ odor present, response abs
            miss_onTimes  = [miss_onTimes odor_on]; %Records the odor onset times for the missed odors
            miss_durTimes = [miss_durTimes odoroff-odor_on]; %Records the odor duration times for the missed odors
            miss_onMRtimes = [miss_onMRtimes odor_on-starttime]; %Records the odor onset times for the missed odors corrected for scanner time

        elseif (odorid == 5 && response == 1) % i.e. incorrect to press 'yes' right button
            faRTs  = [faRTs rt]; % false alarm RTs
            buttstr = 'FA: false alarm trial';
            fa = fa + 1; %Marks an inaccurate response for a control air condition
            rtype = 4; %false alarm
            fa_onTimes  = [fa_onTimes odor_on]; %Records the onset times for the false alarms
            fa_durTimes = [fa_durTimes odoroff-odor_on]; %Records the duration times for the false alarms
            fa_onMRtimes    = [fa_onMRtimes odor_on-starttime]; %Records the onset times for the false alarms corrected for scanner time

        end
    else
        buttstr = 'NO BUTTON PRESS';
        response = NaN; %For a no response trial, the response value is set to something different from the other responses; either NaN or 0 works here
        noresp = noresp + 1; %Records the number of trials in which no response was given
        rtype = 5;%no response
        noresp_onTimes  = [noresp_onTimes odor_on]; %Records the trial onset time for no response trials
        noresp_durTimes = [noresp_durTimes odoroff-odor_on]; %Records the trial duration time for no response trials
        noresp_onMRtimes    = [noresp_onMRtimes odor_on-starttime]; %Records the trial onset time for no response trials corrected for scanner time
    end
    
        rtypes = [rtypes; i odorid rtype response_time]; %collate all responses in the rtypes matrix

%This records information to the log file.  The log file can be used to
%find problems in the data or as a back-up if something goes wrong in
%saving.
        y=sprintf('Odor Cond %d sniffed at %d ms for %d ms duration',...
            odorid,odor_on,odoroff-odor_on);
        log_string(y);
        % log_string(buttstr);
        log_string(num2str(but_resp));
        log_string('');


%The trial continues until the end of the SOA, ensuring that the trial
%lasts the proper amount of time.
        while ((cogstd('sGetTime', -1) * 1000) < (trialtime + SOA))
            
        end

end




%% Save Responses and End Program

%The results are saved in a structure with four classes: onsets,
%demographics, behav, and check.

%Onsets has all the onset times for various conditions and responses.
results.onsets.scanon       = scanon; %first wait trigger time (formerly TIME=0)
results.onsets.scanon_7th       = scanon_7th;
results.onsets.starttime    = starttime;
results.onsets.mristarttime    = mristarttime;
results.onsets.allButtOns_MRtimes = allButtOns_MRtimes;%**

results.onsets.odoronTimes       = odoronTimes;
results.onsets.odordurTimes      = odordurTimes;
results.onsets.odoronMRtimes     = odoronMRtimes;%***for fMRI version**** 

results.onsets.odoronTimes_indodorind = odoronTimes_indodorind;
results.onsets.odordurTimes_indodorind = odordurTimes_indodorind;
results.onsets.odoronMRtimes_indodorind = odoronMRtimes_indodorind;

results.onsets.odoronTimes_present     = odoronTimes_present ;
results.onsets.odordurTimes_present    = odordurTimes_present ;
results.onsets.odoronMRtimes_present   = odoronMRtimes_present ;

results.onsets.yes_odoronTimes       = yes_odoronTimes;
results.onsets.yes_odordurTimes      = yes_odordurTimes;
results.onsets.yes_odoronMRtimes     = yes_odoronMRtimes;

results.onsets.yes_odoronTimes_present       = yes_odoronTimes_present;
results.onsets.yes_odordurTimes_present      = yes_odordurTimes_present;
results.onsets.yes_odoronMRtimes_present     = yes_odoronMRtimes_present;

results.onsets.no_odoronTimes       = no_odoronTimes;
results.onsets.no_odordurTimes      = no_odordurTimes;
results.onsets.no_odoronMRtimes     = no_odoronMRtimes;

results.onsets.miss_onTimes     = miss_onTimes;
results.onsets.miss_durTimes    = miss_durTimes;
results.onsets.miss_onMRtimes   = miss_onMRtimes;

results.onsets.fa_onTimes     = fa_onTimes;
results.onsets.fa_durTimes    = fa_durTimes;
results.onsets.fa_onMRtimes   = fa_onMRtimes;

results.onsets.noresp_onTimes     = noresp_onTimes;
results.onsets.noresp_durTimes    = noresp_durTimes;
results.onsets.noresp_onMRtimes   = noresp_onMRtimes;

%Behav has the responses and response times for all the trials.
results.behav.resp_all    = resp_all; %**
results.behav.resp             = resp;%**
results.behav.RTs_odorid      = RTs_odorid;
results.behav.allButtOns_MRtimes  = allButtOns_MRtimes;
results.behav.allRTs_odorind     = allRTs_odorind;
results.behav.missRTs = missRTs;
results.behav.faRTs   = faRTs;
results.behav.acc     = acc;
results.behav.cr      = cr;
results.behav.miss    = miss;
results.behav.fa      = fa;
results.behav.noresp  = noresp;
results.behav.rtypes  = rtypes;

%Checks has extra information that can be used to troubleshoot or look back
%at events during the run.
results.checks.subinfo         = subinfo;
results.checks.presses         = presses;%added back in 3/29
results.checks.SOA             = SOA;
results.checks.resp           = resp;%**
results.checks.resp_all    = resp_all;
results.checks.resp_r     = resp_r;%
results.checks.stiminfo     = StimR;
%results.checks.stimindex = stimindex;

%At the end of the program, wait ten seconds.
startwait = cogstd('sGetTime', -1) * 1000 ;
while ((cogstd('sGetTime', -1) * 1000) < startwait + 5000) end ;


%% Saving data
dmat = 'C:\My Experiments\Wen_Li\OCF\Data';
cd(dmat);
eval(['save OCF_localizer_sub' num2str(subnum) '_' name_id ';']);
cd(dm);

% Clear back page
cgrect(0, 0, ScrWid, ScrHgh, [0.6 0.6 0.6]) ;
cgflip ;

cgrect(0, 0, ScrWid, ScrHgh, [0.6 0.6 0.6]) ;
cgpencol(0,0,0) ;

cgtext('Well done ! Take a break',0,ScrHgh / 6 - 15);
cgflip ;

startwait = cogstd('sGetTime', -1) * 1000 ;
while ((cogstd('sGetTime', -1) * 1000) < (startwait + 7000)) end


pause off
log_finish;
usb2_finish ;
parallel_finish ;
cgshut
