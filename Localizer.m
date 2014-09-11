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
dm = 'C:\My Experiments\Wen_Li\Delish\m_scripts';
dmat = 'C:\My Experiments\Wen_Li\Delish\mat_files';
cd (dm); %Goes to the specified directory

%11/12/10 LK Recoded for Channel 8 to account for damaged channel 6 in 2nd AnxInd
%group-cells had to be changed to account for conditions up to 8

%A log file is set up for later use if needed.  This can help check the
%results if something looks strange.
log_file_name = input('Log file name ?','s'); %This is set by manual input at the start of the program
log_init (log_file_name) ;

%All these variables are set by manual input.
name_id = input('Subjects initials ? ','s');
subnum = input('Which subject number ? ');

subinfo = sprintf('name_id = %s, sub no. = %d', name_id,subnum); %The above inputs are taken and set into a single variable which is saved later in the script
sess = subnum+4; %Used just below

%****Removed cell break here for behavioral****
%% Create matrix of randomized odor ID information.

rand('state',100+(sess*3)); 
%The rand command uses pseudo-random generation; it returns a number based
%on an internal state that resets every time MATLAB is reset.  Needs to be
%kept in mind when writing randomization.

%Six iterations of 15 are done instead of one iteration of 90 to ensure
%that every so often a full group of 3 iterations of each odor is run
%through.  This is to prevent such a case as 7 iterations of an odor
%occurring consecutively; though unlikely, it could lead to saturation in
%the participant, so it should be avoided.  Randperm calls rand's state,
%which is why that is called first.
stimordA = repmat([1 2 3 4 5 5 5 5],2,1); stimordA = stimordA(randperm(16));  % 1-4 are odors, 5 is air
stimordB = repmat([1 2 3 4 5 5 5 5],1,1); stimordB = stimordB(randperm(8));  % 5: mixture new; 6: mixture2 new; 7: air
stimordC = repmat([1 2 3 4 5 5 5 5],2,1); stimordC = stimordC(randperm(16));

%All stimord* sets are put into one array, the easier to be called later on
%in the presentation loop.
stimord=[stimordA, stimordB, stimordC];

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
SOA = TR*6000 ; %Each trial is 14.1 seconds long (TR=2.35 * 6 = 14.1 s)changed to allow for clear of odor

stimindex=[]; %Matrix of which odor was used in each trial--should match column 1 of stimord

odoronTimes  = []; %Index of all odor onset times in order of occurrence
odordurTimes = []; %Index of all odor duration times in order of occurrence
odoronMRtimes = []; %Index of all odor onset times in order of occurrence corrected for scanner time
odoronTimes_present  = [];
odordurTimes_present  = [];
odoronMRtimes_present = [];

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



% Scanner- need to edit for 4 possible buttons, get codes!

if whichplace == 1  %***for fMRI version**** 
    yesodor = 1; %needs to be in left hand box (blue 1 response) key
    noodor =  2; %needs to be in left hand box (yellow 2 response) key
   
else %Labcomputer
  yesodor = 30;
   noodor = 32;
     
end


log_string(subinfo);


%% Present general instructions

% Clear back page
cgrect(0, 0, ScrWid, ScrHgh, [0.6 0.6 0.6]) %Creates a screen-sized white rectangle, effectively "clearing" the screen.
cgfont('Arial',36) %Font and size of the text
cgpencol(0,0,0) %This is the black color for text
% Write out Sniff Text
cgtext('Sniff when you see ',0, 3 * ScrHgh / 6 - 15); %The text to input, the lateral location on the screen, the vertical location on the screen; all text will be oriented centrally around this point
cgpencol(1, 0, 0); % This is the red color for text
strSniff = '"SNIFF NOW"' ; %Another way of inputting text; set the string beforehand and call it instead of writing the actual string in the cgtext command
cgtext(strSniff,0,2 * ScrHgh / 6 - 15);
cgpencol(0,0,0);
cgtext('Press the INDEX FINGER button if you think',0,ScrHgh / 6 - 15);%should be the blue button
cgtext('there IS a smell',0,-15);
cgtext('Press the MIDDLE FINGER button if you think',0,-1*ScrHgh/6 - 15);%this should be the yellow/fuzzy button
cgtext('there is NO smell',0,-2 * ScrHgh/6 - 15);
cgflip %This puts everything up on the screen.  Until this is called, all of the above is stored for use.


pause on %Allows use of the pause command.
pause(10); %Set everything to pause for ten seconds (all pause values are in seconds; make sure you don't use milliseconds here); this allows time for the participant to read the instructions on the screen.

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
    parallel_wait_trigger ;
    
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
cgpencol(0,0,1); %blue
cgtext('+',0,0);
cgflip

mrigo = sprintf('MRI scanner ON time at %d ms',scanon); %Creates a string for the log file recording the start of the scan
log_string(mrigo); %Logs the onset string in the log file
mristarttime = cogstd('sGetTime', -1) * 1000; %Gets the current time in Cogent
mristarttimes = sprintf('MRI scanner first trigger ON time at %d ms',mristarttime); %Creates a string for the log file recording the first trigger of the scan
log_string(mristarttimes); %Logs the first trigger string in the log file


%Starts recording at the proper time, on the seventh TR (first 6 TRs are
%dummies, used to get scanner to equilibrium)
if whichplace == 1  % scanner
    % wait until get close to all dummy volumes = TR 2s * 6 vol

    while ((cogstd('sGetTime', -1) * 1000) < mristarttime + (ndummies * TR * 1000) - 1000)

        % this way, by subtr. 1000, there is one sec before next '53'
        % thus, the first timestamp will occur at start of 7th dummy
    end

else
    pause(11); %If not at the scanner, wait a for 11 seconds instead, to keep timing similar during testing
end

timectr=[];



%% Run each trial with instructions, using "for" loop
%Instructions go here
for i=1:length(stimord) %1:105
%for i=1:6
    
    serial_async_config ; % Preparing the button box for taking in a response
    
    tsar_start = cogstd('sGetTime', -1) * 1000 ;  %time of the sniff now sign    
    serial_async_read ; %For reasing the button box
    tsar_end = cogstd('sGetTime', -1) * 1000 ;  %time of the sniff now sign    
    
    odorid=stimord(i); %Gets the ith value in stimord to determine which odor is to be presented during the trial
   
    if odorid < 5 %All numbers before this are odor channels
        odorpres=1;
    else %For the control air channel and every other channel
        odorpres=2; %Odor present = no
    end

        stimindex = [stimindex odorid]; %Records the actual channel being used for the stimulus presentation; timestamps for odor onset times should not contradict the order of the stimulus presentation
        
       if whichplace == 1  % i.e., scanning study with scanner pulses
            % Wait here for a new bold rep trigger to occur.
            parallel_wait_trigger ;

            % Grab the time
            trialtime = cogstd('sGetTime', -1) * 1000 ;

        else  % i.e., pilot study in absence of scanner pulses
            trialtime = cogstd('sGetTime', -1) * 1000 ;
        end
    %trialtime = cogstd('sGetTime', -1) * 1000 ; %returns current time in milliseconds
    timectr=[timectr trialtime]; %#ok<AGROW> %Adds time this trial began to timectr matrix
    % Record time experiment began
    if (i == 1)
        scanon_7th = trialtime;
        starttime  = trialtime;  %this is the 1st parallel input after the 6th dummy
        parallel_acquire; %equivalent of dio_acquire here for 7th dummy, sends a trigger to the Acqknowledge file recording physiological information
    else
    end

%This cue lets participants know that a sniff cue is coming soon.  This
%allows them to prepare for the sniff.
    
    readycue='GET READY !';
    cgrect(0, 0, ScrWid, ScrHgh, [0.6 0.6 0.6])  % Clear back screen to grey (grey is used in the scanner because it helps reduce background distractions, as the viewer in the scanner is somewhat old and worn)
    cgpencol(0,0,0)  % Black
    cgtext(readycue,0,0);
    cgflip
    pause(2);  % Wait for two seconds, enough time for participant to prepare.
    
    
    cgrect(0, 0, ScrWid, ScrHgh, [0.6 0.6 0.6])  % Clear back screen to grey
    cgtext('SNIFF NOW',0,0);
    timectr= cgflip * 1000 ; %cgflip activates even though it is part of a variable-setting equation.
    pause(0.2); %Waits for a short time before activating the olfactometer line - should maybe be the other way around?
    tS1 = cogstd('sGetTime', -1) * 1000 ;  %time of the sniff now sign
     % *** TURN ODOR ON ***
    usb2_line_on(0,odorid); %Turns on the line of the olfactometer corresponding to the correct odor.
    odor_on = cogstd('sGetTime', -1) * 1000 ; %This is the odor onset time, used in multiple variables later in the script
    parallel_acquire ; %Sends a trigger to the Acqknowledge output on the scanner computer.  Does not work with lab computers; use dio_acquire instead.
    bSniffTurnedOff = false ; %This variable is used to turn off the sniff now cue in a later loop.  It is set so that the command to turn off the cue is called only once; if this is not done, cgflip will activate multiple times, creating a flashing display rather than the desired blank one.


      % If you ever want to check to see if the subject has responded early,
    % this is the place to do it.  It would look something like this.
    % If button_pressed == true
    %    early_response = true 
    % Else
    %    early_response = false
    % End
    if (s.BytesAvailable() == 1) %s.BytesAvailable is a property of the serial port used to read the responses.  If the value is 1 here, that means an input has been made using the button box.
        fread(s, 1) ; %This reads the response stored in the serial input.
        button_pressed = true ; %Prevents a second input from being entered for the trial, which could cause potential errors in organizing the data.
    else
        button_pressed = false ; %If no button has been pressed, this should be set to false.
    end
    
    %Setting up serial port
    
    byte_in = 0; %The initial value of byte_in is set to 0; this is the same as no input, and is not used by any of the buttons.
    
    bSniffTurnedOff = false ;
    
    resp = []; %added 3/29 to reset resp for every trial; this checks the responses given using the button box.  It is most important when more than one response is needed per trial, to ensure that the responses are being recorded accurately.  If only one response is needed, the byte_in value should be sufficient, but this can be left in if extra information is desired.
    
   % Check the (odor_on + <time>) <time> value to the duration in milliseconds
% That the subject has to respond.
    while ((cogstd('sGetTime', -1) * 1000) < (odor_on + 9850))
        
        % Read the button response from the serial port and get the time of
        % the response and the value of the button.  For more than one
        % response, use the flushinput code.
        if ((s.BytesAvailable() == 1) && (button_pressed == false))%***for fMRI version****  
                byte_in = fread(s, 1) ; %Reads the button response and sets it into a variable.
                t_in = (cogstd('sGetTime', -1) * 1000) ; %Gets the time of the response.
                 button_pressed = true; %This is set so that only one response can be made; while there are other measures taken to guard against extra inputs, this is easy and works even if other measures are forgotten.
%                 res_start = cogstd('sGetTime', -1) * 1000 ;
%                 flushinput(s); %Flushes the input buffer in the serial port; requires the buffer to be initialized to a value greater than 1.        
%                 button_pressed = false;
%                 res_end = cogstd('sGetTime', -1) * 1000 ;   
                resp = [resp; [byte_in t_in]]; %Used to check the responses.
                resp_all = [resp_all; [byte_in t_in]]; %Loads in all responses recorded by resp.  This can be checked later on to see the entire course of responses input into the serial port.
        end
    
   
        if ((bSniffTurnedOff == false) && ((cogstd('sGetTime', -1) * 1000) > (odor_on + 2000)))

            % *** ODOR AND SNIFF CUE OFF ***
            % turn off the smell
            usb2_line_on(0,0); %usb_line_on(0) turns off all channels on the olfactometer.
            cgrect(0, 0, ScrWid, ScrHgh, [0.6 0.6 0.6])  % Clear back screen to grey
            cgpencol(0,0,0)  % black fixation for rest of trial
            cgfont('Arial',48)
            cgtext('+',0,0.15);
            toff1 = cgflip*1000; %cgflip activates despite being part of an equation
            parallel_acquire ; %send trigger to the Acqknowledge output in the scanner.
            bSniffTurnedOff = true ; %Ensures that the loop does not run for more than one iteration.

        end
        
    end    

    %  This section closes the serial port gracefully.
    if (button_pressed == false) 
        stopasync(s) ;
    end
    
    % End of serial port clean up.
    fclose(s) ;
    clear s ;            
    


     % first collate odor times
    odoronTimes = [odoronTimes tS1]; %Collects the odor onset time; this should increase consistently through trials.
    odordurTimes = [odordurTimes toff1-odor_on]; %Collects the odor duration time; this should be roughly the same for all trials.
    odoronMRtimes = [odoronMRtimes tS1-starttime]; %Collects the odor onset time and corrects it for the MRI scanner time; this should increase consistently through trials.

    odoronTimes_indodorind{odorid} = [odoronTimes_indodorind{odorid} tS1]; %Collects the odor onset time and sorts it into the specific odor condition
    odordurTimes_indodorind{odorid} = [odordurTimes_indodorind{odorid} toff1-odor_on]; %Collects the odor duration time and sorts it into the specific odor condition
    odoronMRtimes_indodorind{odorid} = [odoronMRtimes_indodorind{odorid} tS1-starttime]; %Collects the odor onset time, corrects it for the MRI scanner time, and sorts it into the specific odor condition
    
    
    % now collate responses
    if byte_in > 0    % If any button response was recorded, byte_in should be greater than 0.
        response = byte_in ; %Response is the value that everything will be compared to.
        presses = presses + 1; %Records if a button was pressed during the trial; this should be equal to the number of trials
        rt = t_in(1) - odor_on; % The response time is the time from the odor onset to the time of the button press.
        allRTs_odorind{odorid}  = [allRTs_odorind{odorid} rt]; %Collates response times by condition
        allButtOns_MRtimes(presses) = t_in(1) - starttime; %Collates all response times and corrects them for scanner times

        if (odorid < 5 && response == 1) % i.e. correct to press 'yes' right button
            RTs_odorid{odorid}  = [RTs_odorid{odorid} rt];  %Sorts the reaction time into an array for correct responses only
            buttstr = 'HIT: odor present';
            acc(odorid) = acc(odorid) + 1; %Marks an accurate response for the particular odor given in the trial
            rtype = 1; %hit
            yes_odoronTimes{odorid}  = [yes_odoronTimes{odorid} tS1]; %Records odor onset time for the correct response
            yes_odordurTimes{odorid}  = [yes_odordurTimes{odorid} toff1-odor_on]; %Records odor duration time for the correct response
            yes_odoronMRtimes{odorid}  = [yes_odoronMRtimes{odorid} tS1-starttime]; %Records odor onset time for the correct response corrected for scanner time
            yes_odoronTimes_present{odorpres} = [yes_odoronTimes_present{odorpres} tS1]; %Records odor onset time for the correct response of any odor
            yes_odordurTimes_present{odorpres} = [yes_odordurTimes_present{odorpres} toff1-odor_on]; %Records odor duration time for the correct response of any odor
            yes_odoronMRtimes_present{odorpres} = [yes_odoronMRtimes_present{odorpres} tS1-starttime]; %Records odor onset time for the correct response of any odor corrected for scanner time

        elseif (odorid == 5 && response == 2) % i.e. correct to press 'no' left button
            RTs_odorid{odorid}  = [RTs_odorid{odorid} rt];   % Sorts the reaction time into an array for correct responses only
            buttstr = 'CORR REJ: odor absent';
            cr = cr + 1; %Marks an accurate response for a control air condition
            rtype = 2; % correct rejection
            no_odoronTimes  = [no_odoronTimes tS1]; %Records odor onset time for the correct rejection
            no_odordurTimes = [no_odordurTimes toff1-odor_on]; %Records odor duration time for the correct rejection
            no_odoronMRtimes    = [no_odoronMRtimes tS1-starttime]; %Records odor onset time for the correct rejection corrected for scanner time
            yes_odoronTimes_present{odorpres} = [yes_odoronTimes_present{odorpres} tS1]; %Records odor onset time for the correct response of any odor
            yes_odordurTimes_present{odorpres} = [yes_odordurTimes_present{odorpres} toff1-odor_on]; %Records odor duration time for the correct response of any odor
            yes_odoronMRtimes_present{odorpres} = [yes_odoronMRtimes_present{odorpres} tS1-starttime]; %Records odor onset time for the correct response of any odor corrected for scanner time

        elseif (odorid < 5 && response == 2) % i.e. incorrect to press 'no' left button
            missRTs  = [missRTs rt]; % incorrect missed-odour RTs
            buttstr = 'MISS: odor MISS trial';
            miss(odorid) = miss(odorid) + 1; %Marks an inaccurate response for an odor condition
            rtype = 3; %miss/ odor present, response abs
            miss_onTimes  = [miss_onTimes tS1]; %Records the odor onset times for the missed odors
            miss_durTimes = [miss_durTimes toff1-odor_on]; %Records the odor duration times for the missed odors
            miss_onMRtimes = [miss_onMRtimes tS1-starttime]; %Records the odor onset times for the missed odors corrected for scanner time

        elseif (odorid == 5 && response == 1) % i.e. incorrect to press 'yes' right button
            faRTs  = [faRTs rt]; % false alarm RTs
            buttstr = 'FA: false alarm trial';
            fa = fa + 1; %Marks an inaccurate response for a control air condition
            rtype = 4; %false alarm
            fa_onTimes  = [fa_onTimes tS1]; %Records the onset times for the false alarms
            fa_durTimes = [fa_durTimes toff1-odor_on]; %Records the duration times for the false alarms
            fa_onMRtimes    = [fa_onMRtimes tS1-starttime]; %Records the onset times for the false alarms corrected for scanner time

        end
    else
        buttstr = 'NO BUTTON PRESS';
        response = NaN; %For a no response trial, the response value is set to something different from the other responses; either NaN or 0 works here
        noresp = noresp + 1; %Records the number of trials in which no response was given
        rtype = 5;%no response
        noresp_onTimes  = [noresp_onTimes tS1]; %Records the trial onset time for no response trials
        noresp_durTimes = [noresp_durTimes toff1-odor_on]; %Records the trial duration time for no response trials
        noresp_onMRtimes    = [noresp_onMRtimes tS1-starttime]; %Records the trial onset time for no response trials corrected for scanner time
    end
rtypes = [rtypes rtype]; 

%This records information to the log file.  The log file can be used to
%find problems in the data or as a back-up if something goes wrong in
%saving.
    y=sprintf('Odor Id %d sniffed at %d ms for %d ms duration, Odor on MRTime %d',...
        odorid,odor_on,toff1-odor_on,odor_on-starttime); %The desired information is saved to a variable
    log_string(y); %The variable is saved to the log file.
%    log_string(buttstr);
%     log_string(num2str(response_key));
%     log_string('');




%The trial continues until the end of the SOA, ensuring that the trial
%lasts the proper amount of time.
    while ((cogstd('sGetTime', -1) * 1000) < (trialtime + SOA))
        if i == 2
            test = sprintf('cogstd(%d) * 1000 < trialtime(%d) + SOA)',...
                (cogstd('sGetTime', -1) * 1000), trialtime) ;

        end
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
results.checks.stiminfo     = stimord;
results.checks.stimindex = stimindex;

%At the end of the program, wait ten seconds.
startwait = cogstd('sGetTime', -1) * 1000 ;
while ((cogstd('sGetTime', -1) * 1000) < startwait + 10000) end ;


% Clear back page
cgrect(0, 0, ScrWid, ScrHgh, [1 1 1]) ;
cgflip ;

%Write the string that signifies the end of the program and leave it up for
%six seconds.
cgrect(0, 0, ScrWid, ScrHgh, [1 1 1]) ;
cgpencol(0,0,0) ;
cgtext('Well done ! Take a break',0,ScrHgh / 6 - 15);
cgflip ;

startwait = cogstd('sGetTime', -1) * 1000 ;
while ((cogstd('sGetTime', -1) * 1000) < (startwait + 6000)) end

cd(dmat);
eval(['save Localizer_' deblank(name_id) '_sub' num2str(subnum)  ' results']);
cd(dm);

%Finish the program by stopping still-running ports and closing cogent.
pause off
log_finish ;
usb2_finish ;
parallel_finish ;

cgshut