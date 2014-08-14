%% preConditiong task of OCF (olfactory conditioning fMRI) study
% Created by YY 
% **** indicates places that need discussion
% Last update: 8/12/14

clear all

dm = 'C:\My Experiments\Wen_Li\OCF\m_scripts'; %make sure to create this folder in the scanner computer
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

%% Make stimulus matrix, odorid = 1 (A80%), 2 (A65%), 3 (A50%), 4 (A35%), 5 (A20%), 8 (air? double check)
%15 trials/condition;
stimordA = [3,1,4,8,5,2];
stimordB = repmat([1,2,3,4,5,8],1,1); stimordB = stimordB(randperm(6)); %guarantees no more than 2 same odors in a role
stimordC = [3,8,5,2,4,1];
stimordD = repmat([1,2,3,4,5,8],1,1); stimordD = stimordD(randperm(6));
stimordE = [2,4,3,1,8,5];

stimordF = repmat([1,2,3,4,5,8],1,1); stimordF = stimordF(randperm(6));
stimordG = [2,1,3,8,5,4];
stimordH = repmat([1,2,3,4,5,8],1,1); stimordH = stimordH(randperm(6));
stimordI = [4,3,5,2,1,8];
stimordJ = repmat([1,2,3,4,5,8],1,1); stimordJ = stimordJ(randperm(6));

stimordK = [8,3,2,4,1,5];
stimordL = repmat([1,2,3,4,5,8],1,1); stimordL = stimordL(randperm(6));
stimordM = [4,8,5,3,1,2];
stimordN = repmat([1,2,3,4,5,8],1,1); stimordN = stimordN(randperm(6));
stimordO = [5,1,3,8,4,2];

% the final stimR has 10trials/condition that specifies odor ID for each
% trial
StimR = [stimordA'; stimordB'; stimordC'; stimordD';  stimordE'; stimordF'; stimordG'; stimordH'; stimordI'; stimordJ'; stimordK'; stimordL'; stimordM'; stimordN';]; 

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
cgtext('Press the XX button if you think',0,1.2*ScrHgh / 6 - 15);
cgtext('it smells like odor A',0,0.6*ScrHgh/6 - 15);
cgtext('Press the XX button if you think',0,0*ScrHgh/6 - 15);
cgtext('it smells like odor B',0,-0.6*ScrHgh/6 - 15);
cgtext('Press the XX button if you think',0,-1.2*ScrHgh/6 - 15);
cgtext('there is NO smell',0,-1.8 * ScrHgh/6 - 15);
cgflip

pause on
pause(12);

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
    
    %**** need to figure out the Port and Odor ID assignment here
    airid = 8;
    
    %Get ready cues **** need to discuss the reason for a word/count-down
    %selection vs. a plain cross
    readycue='GET READY !';
    cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
    cgpencol(0,0,0)  % Black
    cgtext(readycue,0,0);
    cgflip
    pause(2);  % Wait for two seconds
%         
%     readycue='+';
%     cgrect(0, 0, ScrWid, ScrHgh, [0.6 0.6 0.6])  % Clear back screen to white
%     cgpencol(0.3,0.3,0.3)  % Mid-grey fixation for 2 seconds
%     cgfont('Arial',48)
%     cgtext(readycue,0,0.15);
%     cgflip
%     pause(2);  % Wait for two seconds
%     

    cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
    cgtext('3',0,0);
    pause(1);  % Countdown "3"!!! (t = -2250 ms)
    cgflip
    t1 = cogstd('sGetTime', -1) * 1000 ;

    cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
    cgtext('2',0,0);
    while ((cogstd('sGetTime', -1) * 1000) < (t1 + 742)) end
    cgflip

    cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
    cgtext('1',0,0);
    while ((cogstd('sGetTime', -1) * 1000) < (t1 + 1492)) end  
    cgflip
    
    % *** TURN ODOR #1 ON ***
    while ((cogstd('sGetTime', -1) * 1000) < (t1 + 2092)) end  
    usb2_line_on(odorid,0); %Use PortA, Channel No.odorid
    odor_on = cogstd('sGetTime', -1) * 1000 ;
    parallel_acquire; % send trigger to Physio
    
    % *** SNIFF CUE #1 ON ***
    cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
    cgtext('SNIFF NOW',0,0);
    cgflip
    
    while ((cogstd('sGetTime', -1) * 1000) < (odor_on + 150)) end
    
    while ((cogstd('sGetTime', -1) * 1000) < (odor_on + 7000))
        if ((cogstd('sGetTime', -1) * 1000) > (odor_on + 2000))

            % *** ODOR AND SNIFF CUE OFF ***
            % turn off the smell
            usb2_line_on(0,0);

            % log the odor off time
            odoroff = (cogstd('sGetTime', -1) * 1000) ;
            
            cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
            cgflip

        end
%         cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
%         cgtext('L: Odor A',0,60);
%         cgtext('M: No Odor',0,0);
%         cgtext('R: Odor B',0,-60);
%         cgflip

%    ****Response Logging

       
    end
    
    if (response_time ~= 0)
                key_str = sprintf ('Key\t%d\tDOWN\tat\t%0.1f\n', response_key, response_time) ;
                log_string(key_str) ;
    end
    
    odoronTimes = [odoronTimes odor_on];
    odordurTimes = [odordurTimes odoroff-odor_on];
    
    
    if ansset > 0 %if button press occurred
    allresp = [allresp response_time]; 
    presses = presses + 1;
    
    rtypes = [rtypes; i odorid response_key response_time]; %collate all responses in the rtypes matrix
    
    else    
    buttstr = 'NO BUTTON PRESS';
    response_key = NaN;
    allresp = [allresp response_key] ; %#ok<AGROW>
    noresp = noresp + 1;
    noresp_trials = [noresp_trials i] ;  %#ok<AGROW>        
    end
    
    y=sprintf('Odor Cond %d sniffed at %d ms for %d ms duration',...
    odorid,odor_on,odoroff-odor_on);
    log_string(y);
   % log_string(buttstr);
    log_string(num2str(response_key));
    log_string('');

    while ((cogstd('sGetTime', -1) * 1000) < (trialtime + SOA))

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
while ((cogstd('sGetTime', -1) * 1000) < (startwait + 3000)) end %blank screen for 3 sec

%SUDS 1 rating
%Cursor image
CursorImage = [0 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; ...
               0 0 0; 0 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; ...
               0 0 0; 1 1 1; 0 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; ...
               0 0 0; 1 1 1; 1 1 1; 0 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; ...
               0 0 0; 1 1 1; 1 1 1; 1 1 1; 0 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; ...
               0 0 0; 1 1 1; 1 1 1; 1 1 1; 1 1 1; 0 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; ...
               0 0 0; 1 1 1; 1 1 1; 1 1 1; 1 1 1; 1 1 1; 0 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; ...
               0 0 0; 1 1 1; 1 1 1; 1 1 1; 1 1 1; 1 1 1; 1 1 1; 0 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; ...
               0 0 0; 1 1 1; 1 1 1; 1 1 1; 1 1 1; 1 1 1; 1 1 1; 1 1 1; 0 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; ...
               0 0 0; 1 1 1; 1 1 1; 1 1 1; 1 1 1; 1 1 1; 1 1 1; 1 1 1; 1 1 1; 0 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; ...
               0 0 0; 1 1 1; 1 1 1; 1 1 1; 1 1 1; 1 1 1; 1 1 1; 1 1 1; 1 1 1; 1 1 1; 0 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; ...
               0 0 0; 1 1 1; 1 1 1; 1 1 1; 1 1 1; 1 1 1; 1 1 1; 0 0 0; 0 0 0; 0 0 0; 0 0 0; 0 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; ...
               0 0 0; 1 1 1; 1 1 1; 1 1 1; 0 0 0; 1 1 1; 1 1 1; 0 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; ...
               0 0 0; 1 1 1; 1 1 1; 0 0 0; 0 0 0; 1 1 1; 1 1 1; 0 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; ...
               0 0 0; 1 1 1; 0 0 0; 1 0 0; 1 0 0; 0 0 0; 1 1 1; 1 1 1; 0 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; ...
               0 0 0; 0 0 0; 1 0 0; 1 0 0; 1 0 0; 0 0 0; 1 1 1; 1 1 1; 0 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; ...
               0 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 0 0 0; 1 1 1; 1 1 1; 0 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; ...
               1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 0 0 0; 1 1 1; 1 1 1; 0 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; ...
               1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 0 0 0; 1 1 1; 1 1 1; 0 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; ...
               1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 0 0 0; 1 1 1; 1 1 1; 0 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; ...
               1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 0 0 0; 0 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; ...
              ];
%
% Load up the cursor into sprite 40
%
cgloadarray(20,16,21,CursorImage)
cgtrncol(20,'r')

    cgkeymap;
    cgmouse;
    bprevious=0;
    k_previous(28) = 0;
    c=0;
    riskindex = 999;
    
    while ~k_previous(28)
    [k_current, k_previous] = cgkeymap ;
    [x2,y2,bs,bprevious]=cgmouse;
    
        if ~bprevious && c==0
        cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])
        cgfont('Arial',25)
        cgpencol(0,0,0) %white letters
        cgtext('How distressed and anxious are you right now?', 0, 3* ScrHgh / 9 - 15);
        cgtext('Click anywhere on the line and press ENTER to confirm',0,2*ScrHgh/9-15);
        cgtext('Not anxious                                                   Extremely',0,-1 * ScrHgh/9 - 6);
        cgtext('At all                                                           Anxious',0,-1.5 * ScrHgh/9 - 6);
   
        %Draw the cursor
        cgalign('l','t')
        cgdrawsprite(20, x2+2.5,y2-2)
        cgalign('c','c')
        
        cgpenwid(3);
        cgdraw (-250,0,250,0);
        
        cgflip(1,1,1)
  
        elseif bprevious
        cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])
        cgfont('Arial',25)
        cgpencol(0,0,0) %white letters
        cgtext('How distressed and anxious are you right now?', 0, 3* ScrHgh / 9 - 15);
        cgtext('Click anywhere on the line and press ENTER to confirm',0,2*ScrHgh/9-15);
        cgtext('Not anxious                                                   Extremely',0,-1 * ScrHgh/9 - 6);
        cgtext('At all                                                           Anxious',0,-1.5 * ScrHgh/9 - 6);
   
        %Draw the cursor
        cgalign('l','t')
        cgdrawsprite(20, x2+2.5,y2-2)
        cgalign('c','c')
        
        cgpenwid(3);   
        cgdraw (-250,0,250,0);
        
        cgpencol(1,0,0)
        cgpenwid(4);
        cgdraw (x2,y2-10,x2,y2+10);
        cgflip
        pause(1.5);
        
        SUDS1 = (x2+250)/500*100;
        
        bprevious = 0;
        c = 0;
        
        end
    
    end

cd C:\OCB\Data;
eval(['save OCB_beh_precond_sub' num2str(subnum) '_' name_id ';']);
cd C:\OCB;

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
dio_finish_bb ;
cgshut
