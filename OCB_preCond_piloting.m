%% Olfactory conditioning fMRI (OCF) study - behavioral piloting version
%% PreConditioning block
%Created by YY, 7/17/14

log_file_name = input('Log file name ?','s');
log_init(log_file_name) ;
name_id = input('Partiticpant initials ? ','s');
gender=input('Participant gender ?', 's');
age=input('Participant age ?');
eth=input('Participant ethnicity?-African, Caucasian, Asian, Hispanic, others', 's');


subnum = input('Subject number? ');

subinfo = sprintf('name_id = %s, sub no. = %d, ethnicity=%s, age = %d, gender=%s', name_id,subnum, eth, age, gender);

rand('state',100*subnum+3); %ensure true randomization for each run

%Make stimulus matrix, odorid = 1 (A80%), 2 (A62.5%), 3 (A50%), 4 (A37.5%), 5 (A20%), 8 (air? double check)

stimordA = [3,1,4,8,5,2];
stimordB = repmat([1,2,3,4,5,8],2,1); stimordB = stimordB(randperm(12)); %guarantees no more than 2 same odors in a role
stimordC = [3,8,5,2,4,1];
stimordD = repmat([1,2,3,4,5,8],1,1); stimordD = stimordD(randperm(6));
stimordE = [2,4,3,1,8,5];
stimordF = repmat([1,2,3,4,5,8],2,1); stimordF = stimordF(randperm(12));
stimordG = [2,1,3,8,5,4];
stimordH = repmat([1,2,3,4,5,8],1,1); stimordH = stimordH(randperm(6));

% the final stimR has 10trials/condition that specifies odor ID for each
% trial
StimR = [stimordA'; stimordB'; stimordC'; stimordD';  stimordE'; stimordF'; stimordG'; stimordH']; 


SOA = 12000;

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

% Configuring Hardware
usb_config ; %olfactometer
dio_config_bb ; %shocker

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

%Assing bottonbox presses for input
Lkey = 7;  %Number7 assigned to "left" response
Mkey = 8;  %Number8 assigned to "middle" response
Rkey = 9;  %Number9 assigned to "right" response

% Clear back page
cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])

cgfont('Arial',36)
cgpencol(0,0,0)
% Write out Sniff Text
cgtext('Sniff when you see the words',0, 2.4 * ScrHgh / 6 - 15);
cgpencol(1, 0, 0); % red
strSniff = '"SNIFF NOW"' ;
cgtext(strSniff,0,1.8 * ScrHgh / 6 - 15);
cgpencol(0,0,0); %black
cgtext('Press the LEFT button if you think',0,1.2*ScrHgh / 6 - 15);
cgtext('it smells like odor A',0,0.6*ScrHgh/6 - 15);
cgtext('Press the RIGHT button if you think',0,0*ScrHgh/6 - 15);
cgtext('it smells like odor B',0,-0.6*ScrHgh/6 - 15);
cgtext('Press the MIDDLE button if you think',0,-1.2*ScrHgh/6 - 15);
cgtext('there is NO smell',0,-1.8 * ScrHgh/6 - 15);
cgflip

pause on
pause(8);

% present crosshair
cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])
cgfont('Arial',60);
cgpencol(1,0,0); %red
cgtext('+',0,0);
cgflip

pause(5)


for i = 1:length(StimR)


    odorid=StimR(i);
    if odorid < 6
        odorcond=odorid;
    else
        odorcond=6; %condition 6 coded for air trials
    end
    
    odorindex = [odorindex odorcond];
    
    trialtime = cogstd('sGetTime', -1) * 1000 ;
    startTimes=[startTimes trialtime];%log the beginning of each trial
    
    %Setting up response variables    
    response_time = 0 ; %
    response_key = 0 ;  
    a = getvalue(resp7); %number 7, odor A response
    b = getvalue(resp8); %number 8, no odor response
    c = getvalue(resp9); %number 9, odor B response
    ansset = 0; 
    
    %Get ready cues
    readycue='GET READY !';
    cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
    cgpencol(0,0,0)  % Black
    cgtext(readycue,0,0);
    cgflip
    pause(2);  % Wait for two seconds

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
    usb_line_on(odorid);
    post_odor_on = cogstd('sGetTime', -1) * 1000 ;

    % *** SNIFF CUE #1 ON ***
    cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
    cgtext('SNIFF NOW',0,0);
    cgflip
    
    while ((cogstd('sGetTime', -1) * 1000) < (post_odor_on + 150)) end
    
    while ((cogstd('sGetTime', -1) * 1000) < (post_odor_on + 7000))
        if ((cogstd('sGetTime', -1) * 1000) > (post_odor_on + 2000))

            % *** ODOR AND SNIFF CUE OFF ***
            % turn off the smell
            usb_line_on(0);

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
            
        if getvalue(resp7) ~= a 
            response_key = Lkey;
            ansset = 1;
            rt_current = (cogstd('sGetTime', -1) * 1000) ;
            response_time = rt_current - post_odor_on;
            
        elseif getvalue(resp8) ~= b
            response_key = Mkey;
            ansset = 1;
            rt_current = (cogstd('sGetTime', -1) * 1000) ;
            response_time = rt_current - post_odor_on;  
            
        elseif getvalue(resp9) ~= c
            response_key = Rkey;
            ansset = 1;
            rt_current = (cogstd('sGetTime', -1) * 1000) ;
            response_time = rt_current - post_odor_on;
            
        end            
    end
    
    if (response_time ~= 0)
                key_str = sprintf ('Key\t%d\tDOWN\tat\t%0.1f\n', response_key, response_time) ;
                log_string(key_str) ;
    end
    
    odoronTimes = [odoronTimes post_odor_on];
    odordurTimes = [odordurTimes odoroff-post_odor_on];
    
    
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
    odorid,post_odor_on,odoroff-post_odor_on);
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
