%% postConditiong task of OCF (olfactory conditioning fMRI) study
% Created by YY
% **** indicates places that need discussion
% Last update: 8/24/14

clear all

dm = 'C:\My Experiments\Wen_Li\OCF'; %make sure to create this folder in the scanner computer
cd (dm);

log_file_name = input('Log file name ?','s');
log_init(log_file_name) ;
name_id = input('Partiticpant initials ? ','s');
subnum = input('Subject number? ');
subinfo = sprintf('name_id = %s, sub no. = %d', name_id,subnum);

%% Make stimulus matrix, odorid = 1 (A80%), 2 (A65%), 3 (A50%), 4 (A35%), 5 (A20%), 8 (air; 7 trials)
%15 trials/condition; plus 5 reinforcement trials = 80 trials

switch rem(subnum,2)
    case 0
        csp = 1;
    case 1
        csp = 5;
end

%Specify the location of reinforcement trials
csp_trials = [3,28,38,59,76];
picid = [13, 10, 9, 11, 14];
voiceid = [13, 10, 9, 11, 14];

rand('state',100*subnum+3); %ensure true randomization for each run

stimordA = [2,4,csp,3,1,8,5];
stimordB = repmat([1,2,3,4,5],1,1); stimordB = stimordB(randperm(5)); %guarantees no more than 2 same odors in a role
stimordC = [3,2,4,1,5];
stimordD = repmat([1,2,3,4,5],1,1); stimordD = stimordD(randperm(5));
stimordE = [5,1,3,8,4,csp,2];

stimordF = repmat([1,2,3,4,5],1,1); stimordF = stimordF(randperm(5));
stimordG = [2,1,3,csp,8,5,4];
stimordH = repmat([1,2,3,4,5],1,1); stimordH = stimordH(randperm(5));
stimordI = [4,3,5,2,1,8];
stimordJ = repmat([1,2,3,4,5],1,1); stimordJ = stimordJ(randperm(5));

stimordK = [3,csp,8,5,2,4,1];
stimordL = repmat([1,2,3,4,5],1,1); stimordL = stimordL(randperm(5));
stimordM = [4,8,5,3,1,2, csp];
stimordN = repmat([1,2,3,4,5],1,1); stimordN = stimordN(randperm(5));
stimordO = [3,1,4,8,5,2];

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

%Other images
cgloadbmp(2,'OCF_instruction.bmp');
cgloadbmp(3, 'rectangle.bmp');

%disgust pics
cgloadbmp(8,'9301_300.bmp');%F
cgloadbmp(9,'9321_300.bmp');%M
cgloadbmp(10,'9351_300.bmp');%M
cgloadbmp(11,'9322_300.bmp');%F
cgloadbmp(12,'9352_300.bmp');%M
cgloadbmp(13,'9354_300.bmp');%F
cgloadbmp(14,'vomit_300.bmp');%M

pause on

%% SUDS rating
% 
<<<<<<< HEAD
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
distressed_postCond1 = 50 + (rating / 4);
%%%%%%end of rating
=======
% cgloadbmp(1,'OCF_rating.bmp');
% 
% cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
% cgdrawsprite(1,0,0);
% cgfont('Arial',36);
% cgpencol(0,0,0);
% cgtext('Rate your feelings using the button box',0, 2.4 * ScrHgh / 6 - 15);
% cgflip(0,0,0)
% 
% %Which buttons have the function of increase, decrease, or finishing the
% %question
% r_inc = 3; %green button
% r_dec = 2; %yellow button
% r_sel = 1; %blue button
% but_resp=0;
% 
% pause on;
% pause(3);
% 
% FlushEvents();
% rating = 0;
% ok_trig = 0;
% keyStrings = {'b','y','g','r'};
% 
% keyExists = 0;
% keyReg = 0;
% 
% for i = 1
%     rating = 0; %The current position of the selection line
%     ok_trig = 0; %The key value for finishing the question
%     
%     %Draw the question, rating line, current position, and instructions
%     cgrect(0, 0, ScrWid, ScrHgh, [1 1 1]);
%     cgtext('How distressed/anxious are you feeling now?',0, 100);
%     cgdraw([-200],[-50],[200],[-50]);
%     cgdraw([rating],[-40],[rating],[-60]);
%     cgdraw([-200 0 200],[-55 -55 -55],[-200 0 200],[-45 -45 -45])
%     
%     cgtext('Moderately',0, -115);
%     cgtext('Not at all',-200, -115);
%     cgtext('Extremely',200, -115);
%     cgflip;
%     pause(.5); %The script waits half a second before allowing any inputs - ensures that early button presses aren't registered
%     FlushEvents();
%     while ok_trig == 0
%         
%         [keyIsDown,press_time,keyArr] = KbCheck(); %Check the button box for inputs
%         
%         %Everything from here on is nested in if loops.  This is so the
%         %only thing that is continuously being run is KbCheck.  There will
%         %be trigger values to move on to every subsequent loop.  This is
%         %not graceful but it should work.
%         
%         if keyIsDown == 1 && keyExists == 0
%             %This just enusres that we're looking only for the correct keys
%             keyListCoded = zeros(size(keyArr));
%             if nargin<1 || isempty(keyStrings)
%                 keyListCoded = 1-keyListCoded;
%             else
%                 keyListCoded(KbName(keyStrings)) = 1;
%             end
%             
%             key = KbName(find(keyArr)); %Finds the identity of the keys that are pressed
%             keyExists = 1;
%         else
%         end
%         
%         %This loop only runs if the previous loop runs.  This ensures that
%         %everything properly runs sequentially (having keyIsDown here may
%         %not ensure this since it is the dependency of the previous loop as
%         %well).
%         if keyExists == 1 && keyReg==0
%             % if ~iscell(key) && key == 't' %Filters out TTL values when they are the only things there
%             %     key=[];
%             %    keyExists = 0;
%             % else
%             % resp_length=length(key); %If there are two simultaneous inputs, key will be a cell; this must be filtered.
%             %                 for i=1:(resp_length+1)
%             %                     keycell={'l'};
%             %                     keycell(1,i+1)={key};
%             button=key;
%             if button=='b'
%                 but_resp=1;
%                 keyReg = 1; %The reason this is here is so it only reads the first correct button press.  Just in case there are two button presses that correspond to functional keys, rather than 't'.
%             elseif button=='y'
%                 but_resp=2;
%                 keyReg = 1;
%             elseif button=='g'
%                 but_resp=3;
%                 keyReg = 1;
%             else
%             end
%             %  end
%             % end
%         end
%         
%         %This loop only runs if one of the buttons above has been pressed.
%         %This is where the actual visual change takes place.
%         if keyReg == 1
%             if but_resp == r_dec
%                 %First, registor the rating change.  The screen has to be
%                 %redrawn - unfortunately it cannot be done in a simpler way
%                 %at this time.
%                 rating = rating - 8;
%                 if rating < -200
%                     rating = -200;
%                 end
%                 cgrect(0, 0, ScrWid, ScrHgh, [1 1 1]);
%                 cgtext('How distressed/anxious are you feeling now?',0, 100);
%                 cgdraw([-200],[-50],[200],[-50]);
%                 cgdraw([rating],[-40],[rating],[-60]);
%                 cgdraw([-200 0 200],[-55 -55 -55],[-200 0 200],[-45 -45 -45])
%                 
%                 cgtext('Moderately',0, -115);
%                 cgtext('Not at all',-200, -115);
%                 cgtext('Extremely',200, -115);
%                 cgflip;
%                 
%                 %Now clear things out.  Reset all trigger variables to
%                 %their starting state and flush the inputs.  The pause
%                 %makes sure that participants can move up and down in
%                 %controlled increments - without the pause the marker would
%                 %move too quickly.
%                 FlushEvents;
%                 but_resp=0;
%                 keyExists = 0;
%                 keyReg = 0;
%                 pause(.05)
%             elseif but_resp == r_inc
%                 rating = rating + 8;
%                 if rating > 200
%                     rating = 200;
%                 end
%                 cgrect(0, 0, ScrWid, ScrHgh, [1 1 1]);
%                 cgtext('How distressed/anxious are you feeling now?',0, 100);
%                 cgdraw([-200],[-50],[200],[-50]);
%                 cgdraw([rating],[-40],[rating],[-60]);
%                 cgdraw([-200 0 200],[-55 -55 -55],[-200 0 200],[-45 -45 -45])
%                 
%                 cgtext('Moderately',0, -115);
%                 cgtext('Not at all',-200, -115);
%                 cgtext('Extremely',200, -115);
%                 cgflip;
%                 
%                 FlushEvents;
%                 but_resp=0;
%                 keyExists = 0;
%                 keyReg = 0;
%                 pause(.05)
%                 
%             elseif but_resp == r_sel
%                 ok_trig = 1;
%                 
%                 %Put this here just in case this script needs to loop for
%                 %other ratings.  It should have no impact on the single
%                 %rating.
%                 FlushEvents;
%                 but_resp=0;
%                 keyExists = 0;
%                 keyReg = 0;
%             else
%                 FlushEvents;
%             end
%             
%         end
%     end
% end
% distressed_postCond1 = 50 + (rating / 4);
% %%%%%%end of rating
>>>>>>> FETCH_HEAD

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


count = 0;

%% Stimulus presentation loop

for i = 1:7%length(StimR)
    
    trialtime = cogstd('sGetTime', -1) * 1000 ;
    if (i == 1)
        scanon_7th = trialtime;
        starttime  = trialtime;  %this is the 1st 53 input after the 6th dummy
        parallel_acquire; %equivalent of dio_acquire here for 7th dummy
    end
    
    odorid=StimR(i);
    odorindex = [odorindex odorid];
    
    trialtime = cogstd('sGetTime', -1) * 1000 ;
    startTimes=[startTimes trialtime];%log the beginning of each trial
    
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
<<<<<<< HEAD
            portid = 5; %on PortB
=======
            portid = 11; %on PortA
>>>>>>> FETCH_HEAD
            %         case (8)
            %             portid = 16; %on PortA
    end
    if odorid ~=8
        
        %Get ready cues
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
<<<<<<< HEAD
      %  if portid > 8
      %      usb2_line_on(portid-8,0); %Use PortA, Channel No.odorid
     %   else
            usb2_line_on(0,portid);
     %   end
=======
        if portid > 8
            usb2_line_on(portid-8,0); %Use PortA, Channel No.odorid
        else
            usb2_line_on(0,portid);
        end
>>>>>>> FETCH_HEAD
        
        odor_on = cogstd('sGetTime', -1) * 1000 ;
        parallel_acquire;
        
        % *** SNIFF CUE #1 ON ***
        cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
        cgtext('SNIFF NOW',0,0);
        cgflip
        
        
        % Prepare for response logging
        
        button_pressed=false;
        odorofftrue = 0;
        key=[];
        keyStrings = {'b','y','g','r'};
        
        while ((cogstd('sGetTime', -1) * 1000) < (odor_on + 2500))
            
            if ismember(i,csp_trials)&& ((cogstd('sGetTime', -1) * 1000) > (odor_on + 1000)) && ((cogstd('sGetTime', -1) * 1000) < (odor_on + 1400))
                count = count + 1;
                cgsound('open');
                
                %Disgust sounds
                cgsound('WavFilSND', 8, 'D6.wav');%F
                cgsound('WavFilSND', 9, 'D7M_s.wav');%M
                cgsound('WavFilSND', 10, 'D8M_s.wav');%M
                cgsound('WavFilSND', 11, 'D9F_s.wav');%F
                cgsound('WavFilSND', 12, 'D10M_s.wav');%M
                cgsound('WavFilSND', 13, 'D11F_s.wav');%F
                cgsound('WavFilSND', 14, 'D12M.wav');%M
                
                %followed by the presentation of UCS
                cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to black
                cgdrawsprite(picid(count),0,0);
                cgflip(0,0,0)
                picon = cogstd('sGetTime', -1) * 1000 ; %Log pic onset time
                parallel_acquire;
                
                while ((cogstd('sGetTime', -1) * 1000) < (picon + 1497))%play sound for 1.5s along with picture
                    cgsound('play', voiceid(count))
                    parallel_acquire;
                end
                
                cgsound('shut');
                % Draw the green cross to signal response window
                cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
                cgfont('Arial',60);
                cgpencol(0,1,0); %green
                cgtext('+',0,0);
                cgflip
                
                
<<<<<<< HEAD
            elseif ~ismember(i,csp_trials) && ((cogstd('sGetTime', -1) * 1000) > (odor_on + 1800))
=======
            elseif ~ismember(i,csp_trials) && ((cogstd('sGetTime', -1) * 1000) > (odor_on + 2000))
>>>>>>> FETCH_HEAD
                % Draw the green cross to signal resposne window
                cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
                cgfont('Arial',60);
                cgpencol(0,1,0); %green
                cgtext('+',0,0);
                cgflip
                
<<<<<<< HEAD
=======
            end
            
            if ((cogstd('sGetTime', -1) * 1000) > (odor_on + 2000))
                
                % *** ODOR AND SNIFF CUE OFF ***
                % turn off the smell
                usb2_line_on(0,0);
                
                % log the odor off time
                odoroff = (cogstd('sGetTime', -1) * 1000) ;
                odorofftrue = 1;
>>>>>>> FETCH_HEAD
            end
        end
        %    ** Response Logging: done; need testing
        while ((cogstd('sGetTime', -1) * 1000) < (odoroff + 5242))
            
<<<<<<< HEAD
            if ((cogstd('sGetTime', -1) * 1000) > (odor_on + 1800))
                
                % *** ODOR AND SNIFF CUE OFF ***
                % turn off the smell
                usb2_line_on(0,0);
                
                % log the odor off time
                odoroff = (cogstd('sGetTime', -1) * 1000) ;
                odorofftrue = 1;
            end
        end
        %    ** Response Logging: done; need testing
        while ((cogstd('sGetTime', -1) * 1000) < (odoroff + 5242))
            
            response_time = 0;
            
            while isempty(key) && (odorofftrue == 1)
                [key,rtptb] = GetKey(keyStrings,5,GetSecs,-1);
                t_in_cog = (cogstd('sGetTime', -1) * 1000);
            end
            
            response_time = t_in_cog - odor_on;
            
=======
            response_time = 0;
            
            while isempty(key) && (odorofftrue == 1)
                [key,rtptb] = GetKey(keyStrings,5,GetSecs,-1);
                t_in_cog = (cogstd('sGetTime', -1) * 1000);
            end
            
            response_time = t_in_cog - odor_on;
            
>>>>>>> FETCH_HEAD
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
        
        
        if button_pressed %if button press occurred
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
        %log_string(buttstr);
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
        pause (3);
        
        cgloadbmp(3,'rectangle.bmp');
        
        cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
        cgdrawsprite(3,0,0);
        cgflip
        parallel_acquire;
        
        while ((cogstd('sGetTime', -1) * 1000) < (trialtime + 9400)) %4 TRs
            
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

%% SUDS rating

<<<<<<< HEAD
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
distressed_postCond2 = 50 + (rating / 4);
%%%%%%end of rating
%% Risk rating

odorlist1 = randperm(5);
odorlist2 = randperm(5);
odorlist3 = randperm(5);
odorlist = [odorlist1 odorlist2 odorlist3];
odorrisk = [];

cgfont('Arial',32);
cgpencol(0,0,0);
% Write out Sniff Text
cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
cgtext('Sniff when you see the words',0, 2.4 * ScrHgh / 6 - 15);
cgpencol(1, 0, 0); % red
strSniff = '"SNIFF NOW"' ;
cgtext(strSniff,0,1.8 * ScrHgh / 6 - 15);
cgpencol(0,0,0); %black
cgtext('Rate the odor according to',0,1.2*ScrHgh / 6 - 15);
cgtext('how likely it will be ',0,0.6*ScrHgh/6 - 15);
cgtext('followed by unpleasant pic/sound',0,0*ScrHgh/6 - 15);
cgflip

pause on
pause(6);

cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
cgdrawsprite(1,0,0);
cgflip
pause on
pause(3);

%Which buttons have the function of increase, decrease, or finishing the
%question
r_inc = 3; %green button
r_dec = 2; %yellow button
r_sel = 1; %blue button
but_resp=0;



for n = 1:length(odorlist)
    odorid = odorlist(n);
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
    
    %Get ready cues
    readycue='GET READY !';
    cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
    cgpencol(0,0,0)  % Black
    cgtext(readycue,0,0);
    cgflip
    pause(3);  % Wait for two seconds
    %
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
   % if portid > 8
   %     usb2_line_on(portid-8,0); %Use PortA, Channel No.odorid
   % else
        usb2_line_on(0,portid);
   % end
    
    odor_on = cogstd('sGetTime', -1) * 1000 ;
    
    % *** SNIFF CUE #1 ON ***
    cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
    cgtext('SNIFF NOW',0,0);
    cgflip
    while ((cogstd('sGetTime', -1) * 1000) > (odor_on + 2000))end
    
    % *** SNIFF CUE OFF ***
    usb2_line_on(0,0);
    
    cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
    cgflip
    
    
    %responsel logging
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
        cgtext('How likely will this odor be followed by unpleasant pic/sound?',0, 100);
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
                    cgtext('How likely will this odor be followed by unpleasant pic/sound?',0, 100);
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
                    cgtext('How likely will this odor be followed by unpleasant pic/sound?',0, 100);
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
    risk = 50 + (rating / 4);
    odorrisk = [odorrisk; odorid risk];
    
end

risk_sorted = sortrows(odorrisk,1);
=======
% cgloadbmp(1,'OCF_rating.bmp');
% 
% cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
% cgdrawsprite(1,0,0);
% cgfont('Arial',36);
% cgpencol(0,0,0);
% cgtext('Rate your feelings using the button box',0, 2.4 * ScrHgh / 6 - 15);
% cgflip(0,0,0)
% 
% %Which buttons have the function of increase, decrease, or finishing the
% %question
% r_inc = 3; %green button
% r_dec = 2; %yellow button
% r_sel = 1; %blue button
% but_resp=0;
% 
% pause on;
% pause(3);
% 
% FlushEvents();
% rating = 0;
% ok_trig = 0;
% keyStrings = {'b','y','g','r'};
% 
% keyExists = 0;
% keyReg = 0;
% 
% for i = 1
%     rating = 0; %The current position of the selection line
%     ok_trig = 0; %The key value for finishing the question
%     
%     %Draw the question, rating line, current position, and instructions
%     cgrect(0, 0, ScrWid, ScrHgh, [1 1 1]);
%     cgtext('How distressed/anxious are you feeling now?',0, 100);
%     cgdraw([-200],[-50],[200],[-50]);
%     cgdraw([rating],[-40],[rating],[-60]);
%     cgdraw([-200 0 200],[-55 -55 -55],[-200 0 200],[-45 -45 -45])
%     
%     cgtext('Moderately',0, -115);
%     cgtext('Not at all',-200, -115);
%     cgtext('Extremely',200, -115);
%     cgflip;
%     pause(.5); %The script waits half a second before allowing any inputs - ensures that early button presses aren't registered
%     FlushEvents();
%     while ok_trig == 0
%         
%         [keyIsDown,press_time,keyArr] = KbCheck(); %Check the button box for inputs
%         
%         %Everything from here on is nested in if loops.  This is so the
%         %only thing that is continuously being run is KbCheck.  There will
%         %be trigger values to move on to every subsequent loop.  This is
%         %not graceful but it should work.
%         
%         if keyIsDown == 1 && keyExists == 0
%             %This just enusres that we're looking only for the correct keys
%             keyListCoded = zeros(size(keyArr));
%             if nargin<1 || isempty(keyStrings)
%                 keyListCoded = 1-keyListCoded;
%             else
%                 keyListCoded(KbName(keyStrings)) = 1;
%             end
%             
%             key = KbName(find(keyArr)); %Finds the identity of the keys that are pressed
%             keyExists = 1;
%         else
%         end
%         
%         %This loop only runs if the previous loop runs.  This ensures that
%         %everything properly runs sequentially (having keyIsDown here may
%         %not ensure this since it is the dependency of the previous loop as
%         %well).
%         if keyExists == 1 && keyReg==0
%             % if ~iscell(key) && key == 't' %Filters out TTL values when they are the only things there
%             %     key=[];
%             %    keyExists = 0;
%             % else
%             % resp_length=length(key); %If there are two simultaneous inputs, key will be a cell; this must be filtered.
%             %                 for i=1:(resp_length+1)
%             %                     keycell={'l'};
%             %                     keycell(1,i+1)={key};
%             button=key;
%             if button=='b'
%                 but_resp=1;
%                 keyReg = 1; %The reason this is here is so it only reads the first correct button press.  Just in case there are two button presses that correspond to functional keys, rather than 't'.
%             elseif button=='y'
%                 but_resp=2;
%                 keyReg = 1;
%             elseif button=='g'
%                 but_resp=3;
%                 keyReg = 1;
%             else
%             end
%             %  end
%             % end
%         end
%         
%         %This loop only runs if one of the buttons above has been pressed.
%         %This is where the actual visual change takes place.
%         if keyReg == 1
%             if but_resp == r_dec
%                 %First, registor the rating change.  The screen has to be
%                 %redrawn - unfortunately it cannot be done in a simpler way
%                 %at this time.
%                 rating = rating - 8;
%                 if rating < -200
%                     rating = -200;
%                 end
%                 cgrect(0, 0, ScrWid, ScrHgh, [1 1 1]);
%                 cgtext('How distressed/anxious are you feeling now?',0, 100);
%                 cgdraw([-200],[-50],[200],[-50]);
%                 cgdraw([rating],[-40],[rating],[-60]);
%                 cgdraw([-200 0 200],[-55 -55 -55],[-200 0 200],[-45 -45 -45])
%                 
%                 cgtext('Moderately',0, -115);
%                 cgtext('Not at all',-200, -115);
%                 cgtext('Extremely',200, -115);
%                 cgflip;
%                 
%                 %Now clear things out.  Reset all trigger variables to
%                 %their starting state and flush the inputs.  The pause
%                 %makes sure that participants can move up and down in
%                 %controlled increments - without the pause the marker would
%                 %move too quickly.
%                 FlushEvents;
%                 but_resp=0;
%                 keyExists = 0;
%                 keyReg = 0;
%                 pause(.05)
%             elseif but_resp == r_inc
%                 rating = rating + 8;
%                 if rating > 200
%                     rating = 200;
%                 end
%                 cgrect(0, 0, ScrWid, ScrHgh, [1 1 1]);
%                 cgtext('How distressed/anxious are you feeling now?',0, 100);
%                 cgdraw([-200],[-50],[200],[-50]);
%                 cgdraw([rating],[-40],[rating],[-60]);
%                 cgdraw([-200 0 200],[-55 -55 -55],[-200 0 200],[-45 -45 -45])
%                 
%                 cgtext('Moderately',0, -115);
%                 cgtext('Not at all',-200, -115);
%                 cgtext('Extremely',200, -115);
%                 cgflip;
%                 
%                 FlushEvents;
%                 but_resp=0;
%                 keyExists = 0;
%                 keyReg = 0;
%                 pause(.05)
%                 
%             elseif but_resp == r_sel
%                 ok_trig = 1;
%                 
%                 %Put this here just in case this script needs to loop for
%                 %other ratings.  It should have no impact on the single
%                 %rating.
%                 FlushEvents;
%                 but_resp=0;
%                 keyExists = 0;
%                 keyReg = 0;
%             else
%                 FlushEvents;
%             end
%             
%         end
%     end
% end
% distressed_postCond2 = 50 + (rating / 4);
% %%%%%%end of rating
% %% Risk rating
% 
% odorlist1 = randperm(5);
% odorlist2 = randperm(5);
% odorlist3 = randperm(5);
% odorlist = [odorlist1 odorlist2 odorlist3];
% odorrisk = [];
% 
% cgfont('Arial',32);
% cgpencol(0,0,0);
% % Write out Sniff Text
% cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
% cgtext('Sniff when you see the words',0, 2.4 * ScrHgh / 6 - 15);
% cgpencol(1, 0, 0); % red
% strSniff = '"SNIFF NOW"' ;
% cgtext(strSniff,0,1.8 * ScrHgh / 6 - 15);
% cgpencol(0,0,0); %black
% cgtext('Rate the odor according to',0,1.2*ScrHgh / 6 - 15);
% cgtext('how likely it will be ',0,0.6*ScrHgh/6 - 15);
% cgtext('followed by unpleasant pic/sound',0,0*ScrHgh/6 - 15);
% cgflip
% 
% pause on
% pause(6);
% 
% cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
% cgdrawsprite(1,0,0);
% cgflip
% pause on
% pause(3);
% 
% %Which buttons have the function of increase, decrease, or finishing the
% %question
% r_inc = 3; %green button
% r_dec = 2; %yellow button
% r_sel = 1; %blue button
% but_resp=0;
% 
% 
% 
% for n = 1:length(odorlist)
%     odorid = odorlist(n);
%     switch odorid
%         case (1)
%             portid = 2; %on PortB
%         case (2)
%             portid = 7; %on PortB
%         case (3)
%             portid = 4; %on PortB
%         case (4)
%             portid = 14; %on PortA
%         case (5)
%             portid = 11; %on PortA
%             
%     end
%     
%     %Get ready cues
%     readycue='GET READY !';
%     cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
%     cgpencol(0,0,0)  % Black
%     cgtext(readycue,0,0);
%     cgflip
%     pause(3);  % Wait for two seconds
%     %
%     cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
%     cgtext('3',0,0);
%     cgflip
%     t1 = cogstd('sGetTime', -1) * 1000 ;
%     while ((cogstd('sGetTime', -1) * 1000) < (t1 + 992)) end
%     
%     cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
%     cgtext('2',0,0);
%     cgflip
%     t2 = cogstd('sGetTime', -1) * 1000 ;
%     while ((cogstd('sGetTime', -1) * 1000) < (t2 + 992)) end
%     
%     
%     cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
%     cgtext('1',0,0);
%     cgflip
%     t3 = cogstd('sGetTime', -1) * 1000 ;
%     while ((cogstd('sGetTime', -1) * 1000) < (t3 + 992)) end
%     
%     
%     % *** TURN ODOR #1 ON ***
%     if portid > 8
%         usb2_line_on(portid-8,0); %Use PortA, Channel No.odorid
%     else
%         usb2_line_on(0,portid);
%     end
%     
%     odor_on = cogstd('sGetTime', -1) * 1000 ;
%     
%     % *** SNIFF CUE #1 ON ***
%     cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
%     cgtext('SNIFF NOW',0,0);
%     cgflip
%     while ((cogstd('sGetTime', -1) * 1000) > (odor_on + 2000))end
%     
%     % *** SNIFF CUE OFF ***
%     usb2_line_on(0,0);
%     
%     cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
%     cgflip
%     
%     
%     %responsel logging
%     FlushEvents();
%     rating = 0;
%     ok_trig = 0;
%     keyStrings = {'b','y','g','r'};
%     
%     keyExists = 0;
%     keyReg = 0;
%     
%     for i = 1
%         rating = 0; %The current position of the selection line
%         ok_trig = 0; %The key value for finishing the question
%         
%         %Draw the question, rating line, current position, and instructions
%         cgrect(0, 0, ScrWid, ScrHgh, [1 1 1]);
%         cgtext('How likely will this odor be followed by unpleasant pic/sound?',0, 100);
%         cgdraw([-200],[-50],[200],[-50]);
%         cgdraw([rating],[-40],[rating],[-60]);
%         cgdraw([-200 0 200],[-55 -55 -55],[-200 0 200],[-45 -45 -45])
%         
%         cgtext('Moderately',0, -115);
%         cgtext('Not at all',-200, -115);
%         cgtext('Extremely',200, -115);
%         cgflip;
%         pause(.5); %The script waits half a second before allowing any inputs - ensures that early button presses aren't registered
%         FlushEvents();
%         while ok_trig == 0
%             
%             [keyIsDown,press_time,keyArr] = KbCheck(); %Check the button box for inputs
%             
%             %Everything from here on is nested in if loops.  This is so the
%             %only thing that is continuously being run is KbCheck.  There will
%             %be trigger values to move on to every subsequent loop.  This is
%             %not graceful but it should work.
%             
%             if keyIsDown == 1 && keyExists == 0
%                 %This just enusres that we're looking only for the correct keys
%                 keyListCoded = zeros(size(keyArr));
%                 if nargin<1 || isempty(keyStrings)
%                     keyListCoded = 1-keyListCoded;
%                 else
%                     keyListCoded(KbName(keyStrings)) = 1;
%                 end
%                 
%                 key = KbName(find(keyArr)); %Finds the identity of the keys that are pressed
%                 keyExists = 1;
%             else
%             end
%             
%             %This loop only runs if the previous loop runs.  This ensures that
%             %everything properly runs sequentially (having keyIsDown here may
%             %not ensure this since it is the dependency of the previous loop as
%             %well).
%             if keyExists == 1 && keyReg==0
%                 % if ~iscell(key) && key == 't' %Filters out TTL values when they are the only things there
%                 %     key=[];
%                 %    keyExists = 0;
%                 % else
%                 % resp_length=length(key); %If there are two simultaneous inputs, key will be a cell; this must be filtered.
%                 %                 for i=1:(resp_length+1)
%                 %                     keycell={'l'};
%                 %                     keycell(1,i+1)={key};
%                 button=key;
%                 if button=='b'
%                     but_resp=1;
%                     keyReg = 1; %The reason this is here is so it only reads the first correct button press.  Just in case there are two button presses that correspond to functional keys, rather than 't'.
%                 elseif button=='y'
%                     but_resp=2;
%                     keyReg = 1;
%                 elseif button=='g'
%                     but_resp=3;
%                     keyReg = 1;
%                 else
%                 end
%                 %  end
%                 % end
%             end
%             
%             %This loop only runs if one of the buttons above has been pressed.
%             %This is where the actual visual change takes place.
%             if keyReg == 1
%                 if but_resp == r_dec
%                     %First, registor the rating change.  The screen has to be
%                     %redrawn - unfortunately it cannot be done in a simpler way
%                     %at this time.
%                     rating = rating - 8;
%                     if rating < -200
%                         rating = -200;
%                     end
%                     cgrect(0, 0, ScrWid, ScrHgh, [1 1 1]);
%                     cgtext('How likely will this odor be followed by unpleasant pic/sound?',0, 100);
%                     cgdraw([-200],[-50],[200],[-50]);
%                     cgdraw([rating],[-40],[rating],[-60]);
%                     cgdraw([-200 0 200],[-55 -55 -55],[-200 0 200],[-45 -45 -45])
%                     
%                     cgtext('Moderately',0, -115);
%                     cgtext('Not at all',-200, -115);
%                     cgtext('Extremely',200, -115);
%                     cgflip;
%                     
%                     %Now clear things out.  Reset all trigger variables to
%                     %their starting state and flush the inputs.  The pause
%                     %makes sure that participants can move up and down in
%                     %controlled increments - without the pause the marker would
%                     %move too quickly.
%                     FlushEvents;
%                     but_resp=0;
%                     keyExists = 0;
%                     keyReg = 0;
%                     pause(.05)
%                 elseif but_resp == r_inc
%                     rating = rating + 8;
%                     if rating > 200
%                         rating = 200;
%                     end
%                     cgrect(0, 0, ScrWid, ScrHgh, [1 1 1]);
%                     cgtext('How likely will this odor be followed by unpleasant pic/sound?',0, 100);
%                     cgdraw([-200],[-50],[200],[-50]);
%                     cgdraw([rating],[-40],[rating],[-60]);
%                     cgdraw([-200 0 200],[-55 -55 -55],[-200 0 200],[-45 -45 -45])
%                     
%                     cgtext('Moderately',0, -115);
%                     cgtext('Not at all',-200, -115);
%                     cgtext('Extremely',200, -115);
%                     cgflip;
%                     
%                     FlushEvents;
%                     but_resp=0;
%                     keyExists = 0;
%                     keyReg = 0;
%                     pause(.05)
%                     
%                 elseif but_resp == r_sel
%                     ok_trig = 1;
%                     
%                     %Put this here just in case this script needs to loop for
%                     %other ratings.  It should have no impact on the single
%                     %rating.
%                     FlushEvents;
%                     but_resp=0;
%                     keyExists = 0;
%                     keyReg = 0;
%                 else
%                     FlushEvents;
%                 end
%                 
%             end
%         end
%     end
%     risk = 50 + (rating / 4);
%     odorrisk = [odorrisk; odorid risk];
%     
% end
% 
% risk_sorted = sortrows(odorrisk,1);
>>>>>>> FETCH_HEAD

%% Saving data
dmat = 'C:\My Experiments\Wen_Li\OCF\Data';
cd(dmat);
eval(['save OCF_postcond_sub' num2str(subnum) '_' name_id ';']);
cd(dm);

% Clear back page
cgrect(0, 0, ScrWid, ScrHgh, [1 1 1]) ;
cgflip ;

cgrect(0, 0, ScrWid, ScrHgh, [1 1 1]) ;
cgpencol(0,0,0) ;
cgtext('Well done ! Take a break',0,ScrHgh / 6 - 15);
cgflip ;

startwait = cogstd('sGetTime', -1) * 1000 ;
while ((cogstd('sGetTime', -1) * 1000) < (startwait + 6000)) end



pause off
log_finish;
usb2_finish ;
parallel_finish ;
cgshut