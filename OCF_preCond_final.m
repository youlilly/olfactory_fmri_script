%% preConditiong task of OCF (olfactory conditioning fMRI) study
% Created by YY
% **** indicates places that need discussion
% Last update: 8/27/14

clear all

dm = 'C:\My Experiments\Wen_Li\OCF'; %make sure to create this folder in the scanner computer
cd (dm);
%
log_file_name = input('Log file name ?','s');
log_init(log_file_name) ;
name_id = input('Partiticpant initials ? ','s');
gender=input('Participant gender ?', 's');
age=input('Participant age ?');
eth=input('Participant ethnicity?-African, Caucasian, Asian, Hispanic, others', 's');
subnum = input('Which participant number ? ');
block = input('Which block?');

subinfo = sprintf('name_id = %s, sub no. = %d, ethnicity=%s, age = %d, gender=%s', name_id,subnum, eth, age, gender);

%% Make stimulus matrix, odorid = 1 (A80%), 2 (A65%), 3 (A50%), 4 (A35%), 5 (A20%), 8 (air trials: 7)
%15 trials/odor condition;
rand('state',100*subnum+3); %ensure true randomization for each run

stimordA = [3,1,4,8,5,2];
stimordB = repmat([1,2,3,4,5],1,1); stimordB = stimordB(randperm(5)); %guarantees no more than 2 same odors in a role
stimordC = [3,8,5,2,4,1];
stimordD = repmat([1,2,3,4,5],1,1); stimordD = stimordD(randperm(5));
stimordE = [2,4,3,1,8,5];

stimordF = repmat([1,2,3,4,5],1,1); stimordF = stimordF(randperm(5));
stimordG = [2,1,3,8,5,4];
stimordH = repmat([1,2,3,4,5],1,1); stimordH = stimordH(randperm(5));
stimordI = [4,3,5,2,1,8];
stimordJ = repmat([1,2,3,4,5],1,1); stimordJ = stimordJ(randperm(5));

stimordK = [8,3,2,4,1,5];
stimordL = repmat([1,2,3,4,5],1,1); stimordL = stimordL(randperm(5));
stimordM = [4,5,3,1,2,8];
stimordN = repmat([1,2,3,4,5],1,1); stimordN = stimordN(randperm(5));
stimordO = [5,1,3,4,2];

% the final stimR has 15trials/condition that specifies odor ID for each
% trial
StimR = [stimordA'; stimordB'; stimordC'; stimordD';  stimordE'; stimordF'; stimordG'; stimordH'; stimordI'; stimordJ'; stimordK'; stimordL'; stimordM'; stimordN'; stimordO'];

%% Configure options for fMRI
whichplace = 3;
while whichplace>2
    whichplace = input('At the Scanner (1) or Lab/Office (2) ? ');
end

whichkeys = 3;
while whichkeys>2
    whichkeys = input('Using MRI keypad (1) or Other (2) ? ');
end

% Experimental variables
SOA = 14100;%Set for fMRI study
TR = 2.35;
nslices = 48; %changed from 32 to 48 by Wen on June/17th/2014
ndummies = 6;
%% Set up olfactometer, triggers & Cogent.
%Configure equipment

% Configuring Hardware
usb2_config ; %Olfactometer configuration
parallel_config ;  % For reading trigger on the parallel port

% %For the parallel port
global base_state;
global parport_out;
global parport_in;
%

%Prepare variables for later use
odoronTimes  = [];
odordurTimes = [];
startTimes = [];
odorindex = [];

rtypes = [];
allresp = [];
noresp_trials = [];

noresp = 0;
presses = 0;


% Load and configure Cogent
cgloadlib
cgopen(1,0,0,1)
log_start_timer ;
log_header ;

% Need a timing variable here
% This will be a relative timer from the start of Cogent.
% Use the
log_string('COGENT_START') ;
log_string(subinfo) ;

gsd = cggetdata('gsd') ;
gpd = cggetdata('gpd') ;

ScrWid = gsd.ScreenWidth ;
ScrHgh = gsd.ScreenHeight ;

%% SUDS rating

cgloadbmp(1,'OCF_rating.bmp');

cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
cgdrawsprite(1,0,0);
cgfont('Arial',36);
cgpencol(0,0,0);
cgtext('Rate your feelings using the button box',0, 2.4 * ScrHgh / 6 - 15);
cgflip(0,0,0)

%Which buttons have the function of increase, decrease, or finishing the
%question
r_inc = 3; %green button
r_dec = 2; %yellow button
r_sel = 1; %blue button
but_resp=0;

pause on;
pause(3);

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
    cgrect(0, 0, ScrWid, ScrHgh, [1 1 1]);
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
                cgrect(0, 0, ScrWid, ScrHgh, [1 1 1]);
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
                cgrect(0, 0, ScrWid, ScrHgh, [1 1 1]);
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
distressed_preCond1 = 50 + (rating / 4);
%%%%%%end of rating

%% Present Instructions
% Clear back page
cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])
cgfont('Arial',36)
cgpencol(0,0,0)

% Intructions **** needs to be further modified YY. 8/12/14
cgtext('Sniff when you see the words',0, 2.4 * ScrHgh / 6 - 15);
cgpencol(1, 0, 0); % red
strSniff = '"SNIFF NOW"' ;
cgtext(strSniff,0,1.8 * ScrHgh / 6 - 15);
cgpencol(0,0,0); %black
cgtext('Press the GREEN button if you think',0,1.2*ScrHgh / 6 - 15);
cgtext('it smells like odor A',0,0.6*ScrHgh/6 - 15);
cgtext('Press the YELLOW button if you think',0,0*ScrHgh/6 - 15);
cgtext('it smells like odor B',0,-0.6*ScrHgh/6 - 15);
cgtext('Make NO response during black frames',0,-1.2*ScrHgh/6 - 15);
cgflip

pause on
pause(7);

cgloadbmp(2,'OCF_instruction.bmp');

cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
cgdrawsprite(2,0,0);
cgflip
pause on
pause(5);

% present crosshair
cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])
cgfont('Arial',60);
cgpencol(1,0,0); %red
cgtext('+',0,0);
cgflip

cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])

if whichplace == 1  % i.e., scanning study with scanner pulses
    %    clearserialbytes(PC);
    
    % Wait here for the first bold rep trigger to occur.
    parallel_wait;
    
    % Grab the time
    scanon = cogstd('sGetTime', -1) * 1000;
    
else  % i.e., pilot study in absence of scanner pulses
    scanon = cogstd('sGetTime', -1) * 1000;
    pause(5)
end

% Change crosshair color to yellow.  This is to indicate to the experimenters
% that the parallel port received the trigger and is now getting baseline
% information.  This crosshairs will stay up for 30? seconds, the
% recommended length of baseline data gathering.
cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])
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
resp_list=[];
rt_list=[];


%% Stimulus presentation loop- 15 trials/cond * 6 cond = 90 trials

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
    
    %** need to figure out the Port and Odor ID assignment here - done;
    %testing required
    switch odorid
        case (1)
            portid = 1; %on PortB
        case (2)
            portid = 2; %on PortB
        case (3)
            portid = 3; %on PortB
        case (4)
            portid = 4; %on PortB
        case (5)
            portid = 5; %on PortB

    end
    
    if odorid ~=8
        %Get ready cues
        %selection vs. a plain cross
        readycue='GET READY !';
        cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
        cgpencol(0,0,0)  % Black
        cgtext(readycue,0,0);
        cgflip
        pause(3);  % Wait for two seconds
        
        cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
        cgtext('3',0,0);
        cgflip
        t1 = cogstd('sGetTime', -1) * 1000 ;
        while ((cogstd('sGetTime', -1) * 1000) < (t1 + 992)) end
        
        cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
        cgtext('2',0,0);
        cgflip
        t2 = cogstd('sGetTime', -1) * 1000 ;
        while ((cogstd('sGetTime', -1) * 1000) < (t2 + 992)) end
        
        
        cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
        cgtext('1',0,0);
        cgflip
        t3 = cogstd('sGetTime', -1) * 1000 ;
        while ((cogstd('sGetTime', -1) * 1000) < (t3 + 992)) end
        
        
        % *** TURN ODOR #1 ON ***
      %  if portid > 8
       %     usb2_line_on(portid-8,0); %Use PortA, Channel No.odorid
      %  else
            usb2_line_on(0,portid);
      %  end
        
        odor_on = cogstd('sGetTime', -1) * 1000 ;
        parallel_acquire; % send trigger to Physio
        
        % *** SNIFF CUE ON ***
        cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
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
        
        cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])
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
                
                if  key=='g' % Odor A
                    but_resp=7;
                    allresp = [allresp; but_resp response_time];
                    button_pressed = true;
                elseif key=='y' % Odor B
                    but_resp=9;
                    allresp = [allresp; but_resp response_time];
                    button_pressed = true;
                else
                    but_resp=NaN;
                    allresp = [allresp; but_resp response_time];
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
        
        
        if button_pressed % ****if button press occurred
            presses = presses + 1;
            
            rtypes = [rtypes; i odorid but_resp response_time]; %collate all responses in the rtypes matrix
            
        else
            but_resp = NaN;
            noresp = noresp + 1;
            noresp_trials = [noresp_trials i] ;  %#ok<AGROW>
        end
        
        y=sprintf('Odor Cond %d sniffed at %d ms for %d ms duration',...
            odorid,odor_on,odoroff-odor_on);
        log_string(y);
        % log_string(buttstr);
        log_string(num2str(but_resp));
        log_string('');
        
        
        while ((cogstd('sGetTime', -1) * 1000) < (trialtime + SOA))
            
        end
        
    else %for no odor trials, present cross and rectangle
        cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])
        cgfont('Arial',60);
        cgpencol(0,0,0); %black cross
        cgtext('+',0,0);
        cgflip
        pause (2);
        
        cgloadbmp(3,'rectangle.bmp');
        
        cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
        cgdrawsprite(3,0,0);
        cgflip
        parallel_acquire;
        
        while ((cogstd('sGetTime', -1) * 1000) < (trialtime + 9400)) %4 TRs instead of 6
            
        end
        
    end
    
end

results.onsets.starttime = startTimes;
results.onsets.odoronTimes = odoronTimes;
results.onsets.odordurTimes = odordurTimes;

results.behav.allresp = allresp;
results.behav.rtypes = rtypes;
results.behav.noresp = noresp_trials;
results.behav.presses = presses;
% Clear back page

cgrect(0, 0, ScrWid, ScrHgh, [1 1 1]) ;
cgpencol(0,0,0) ;
cgflip ;

startwait = cogstd('sGetTime', -1) * 1000 ;
while ((cogstd('sGetTime', -1) * 1000) < (startwait + 5000))
end %blank screen 

%% Saving data
dmat = 'C:\My Experiments\Wen_Li\OCF\Data';
cd(dmat);
eval(['save OCF_precond_sub' num2str(subnum) '_' name_id ';']);
cd(dm);

% Clear back page
cgrect(0, 0, ScrWid, ScrHgh, [1 1 1]) ;
cgflip ;

cgrect(0, 0, ScrWid, ScrHgh, [1 1 1]) ;
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
