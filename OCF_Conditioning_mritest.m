%% Conditiong block of OCF (olfactory conditioning fMRI) study
% Created by YY
% **** indicates places that need discussion
% Last update: 8/24/14

clear all

dm = 'C:\My Experiments\Wen_Li\OCF'; %make sure to create this folder in the scanner computer
cd (dm);
%
log_file_name = input('Log file name ?','s');
log_init(log_file_name) ;
name_id = input('Partiticpant initials ? ','s');
subnum = input('Subject number? ');
subinfo = sprintf('name_id = %s, sub no. = %d, ', name_id,subnum);

%% Stimulus matrix
%7 trials for CS+, CS- (counterbalanced across participants, odorid = 1/5), no odor (odorid = 8), respectively
switch rem(subnum,2)
    case 0
        StimR = [5	19	19
            8   99  99
            1	9	9
            5	21	21
            8   99  99
            1	12	12
            5 	20	20
            8	99	99
            1	13	13
            5	15	15
            1	14	14
            8	99	99
            1	10	10
            8	99	99
            5	18	18
            1	11	11
            8	99	99
            1	8	8
            5	17	17
            8   99  99
            5	16	16];
        
        
    case 1
        StimR = [5	11	11
            8   99  99
            1	15	15
            8	99	99
            5	13	13
            5	14	14
            1	17	17
            8   99  99
            1	20	20
            5	9	9
            8	99	99
            1	18	18
            5 	10	10
            8	99	99
            1	21	21
            8	99	99
            5	8	8
            1	16	16
            8	99	99
            5	12	12
            1	19	19
            ];
        
        
end


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

%disgust pics
cgloadbmp(8,'9301_300.bmp');%F
cgloadbmp(9,'9321_300.bmp');%M
cgloadbmp(10,'9351_300.bmp');%M
cgloadbmp(11,'9322_300.bmp');%F
cgloadbmp(12,'9352_300.bmp');%M
cgloadbmp(13,'9354_300.bmp');%F
cgloadbmp(14,'vomit_300.bmp');%M

%neutral pics
cgloadbmp(15,'7021_300.bmp');%
cgloadbmp(16,'7025_300.bmp');%
cgloadbmp(17,'7035_300.bmp');%
cgloadbmp(18,'7041_300.bmp');%
cgloadbmp(19,'7090_300.bmp');%
cgloadbmp(20,'7190_300.bmp');%
cgloadbmp(21,'7224_300.bmp');%

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
cgtext('Press the BLUE button if you think',0,1.2*ScrHgh / 6 - 15);
cgtext('it smells like odor A',0,0.6*ScrHgh/6 - 15);
cgtext('Press the YELLOW button if you think',0,0*ScrHgh/6 - 15);
cgtext('it smells like odor B',0,-0.6*ScrHgh/6 - 15);
cgtext('Press the GREEN button if you think',0,-1.2*ScrHgh/6 - 15);
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

%% Stimulus presentation loop- 3 trials/cond * 3 cond = 21 trials

for i = 1:5%length(StimR)
    
    odorid=StimR(i,1);
    voiceid = StimR(i,2);
    picid=StimR(i,3) ; %Specifies which of the emo conditions is presented
    
    odorindex = [odorindex odorid];
    
    trialtime = cogstd('sGetTime', -1) * 1000 ;
    if (i == 1)
        scanon_7th = trialtime;
        starttime  = trialtime;  %this is the 1st 53 input after the 6th dummy
        parallel_acquire; %equivalent of dio_acquire here for 7th dummy
    end
    
    startTimes=[startTimes trialtime];%log the beginning of each trial
    
    %** need to figure out the Port and Odor ID assignment here - done;
    %testing required
    switch odorid
        case (1)
            portid = 2; %on PortB
        case (2)
            portid = 7; %on PortB
        case (3)
            portid = 4; %on PortB
        case (4)
            portid = 14; %on PortA
        case (5)
            portid = 5; %on PortB
<<<<<<< HEAD
=======

>>>>>>> parent of b71d1e8... Merge branch 'master' of github.com:youlilly/olfactory_fmri_script
    end
    
    if odorid ~=8
        %Get ready cues **** need to discuss the reason for a word/count-down
        %selection vs. a plain cross
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
<<<<<<< HEAD

=======
>>>>>>> parent of b71d1e8... Merge branch 'master' of github.com:youlilly/olfactory_fmri_script
%         if portid > 8
%             usb2_line_on(portid-8,0); %Use PortA, Channel No.odorid
%         else
            usb2_line_on(0,portid);
      %  end
<<<<<<< HEAD

=======
>>>>>>> parent of b71d1e8... Merge branch 'master' of github.com:youlilly/olfactory_fmri_script
        
        odor_on = cogstd('sGetTime', -1) * 1000 ;
        parallel_acquire; % send trigger to Physio
        
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
            
            if (voiceid ~= 99)&& ((cogstd('sGetTime', -1) * 1000) > (odor_on + 1000)) && ((cogstd('sGetTime', -1) * 1000) < (odor_on + 1400))
                cgsound('open');
                
                %Disgust sounds
                cgsound('WavFilSND', 8, 'D6.wav');%F
                cgsound('WavFilSND', 9, 'D7M_s.wav');%M
                cgsound('WavFilSND', 10, 'D8M_s.wav');%M
                cgsound('WavFilSND', 11, 'D9F_s.wav');%F
                cgsound('WavFilSND', 12, 'D10M_s.wav');%M
                cgsound('WavFilSND', 13, 'D11F_s.wav');%F
                cgsound('WavFilSND', 14, 'D12M.wav');%M
                %Neutral sounds
                cgsound('WavFilSND', 15, 'N1.wav');%tone - neutral
                cgsound('WavFilSND', 16, 'N2.wav');%tone - neutral
                cgsound('WavFilSND', 17, 'N3.wav');%tone - neutral
                cgsound('WavFilSND', 18, 'N4.wav');%tone - neutral
                cgsound('WavFilSND', 19, 'N2.wav');%tone - neutral
                cgsound('WavFilSND', 20, 'N3.wav');%tone - neutral
                cgsound('WavFilSND', 21, 'N4.wav');%tone - neutral
                
                
                %followed by the presentation of UCS
                cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to black
                cgdrawsprite(picid,0,0);
                cgflip(0,0,0)
                picon = cogstd('sGetTime', -1) * 1000 ; %Log pic onset time
                parallel_acquire;
                
                while ((cogstd('sGetTime', -1) * 1000) < (picon + 1497))%play sound for 1.5s along with picture
                    cgsound('play', voiceid)
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

            elseif (voiceid == 99)&& ((cogstd('sGetTime', -1) * 1000) > (odor_on + 1800))

=======
            elseif (voiceid == 99)&& ((cogstd('sGetTime', -1) * 1000) > (odor_on + 1800))
>>>>>>> parent of b71d1e8... Merge branch 'master' of github.com:youlilly/olfactory_fmri_script
                % Draw the green cross to signal response window
                cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
                cgfont('Arial',60);
                cgpencol(0,1,0); %green
                cgtext('+',0,0);
                cgflip
            end
            
<<<<<<< HEAD

            if ((cogstd('sGetTime', -1) * 1000) > (odor_on + 1800))

=======
            if ((cogstd('sGetTime', -1) * 1000) > (odor_on + 1800))
>>>>>>> parent of b71d1e8... Merge branch 'master' of github.com:youlilly/olfactory_fmri_script
                
                % *** ODOR AND SNIFF CUE OFF ***
                % turn off the smell
                usb2_line_on(0,0);
                
                % log the odor off time
                odoroff = (cogstd('sGetTime', -1) * 1000) ;
                odorofftrue = 1;
            end
        end
        %     ** Response Logging: done; need testing
        while ((cogstd('sGetTime', -1) * 1000) < (odoroff + 5242))
            response_time = 0;
=======
            portid = 11; %on PortA
        case (8)
            portid = 16; %on PortA
    end
    
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
    while ((cogstd('sGetTime', -1) * 1000) < (t1 + 992)) end
    cgflip
    
    while ((cogstd('sGetTime', -1) * 1000) < (t1 + 1292)) end
    
    % *** TURN ODOR #1 ON ***
    if portid > 8
        usb2_line_on(portid-8,0); %Use PortA, Channel No.odorid
    else
        usb2_line_on(0,portid);
    end
    
    odor_on = cogstd('sGetTime', -1) * 1000 ;
    parallel_acquire; % send trigger to Physio
    
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
        
        if (voiceid ~= 99)&& ((cogstd('sGetTime', -1) * 1000) > (odor_on + 1000)) && ((cogstd('sGetTime', -1) * 1000) < (odor_on + 1400))
            cgsound('open');
            
            %Disgust sounds
            cgsound('WavFilSND', 8, 'D6.wav');%F
            cgsound('WavFilSND', 9, 'D7M_s.wav');%M
            cgsound('WavFilSND', 10, 'D8M_s.wav');%M
            cgsound('WavFilSND', 11, 'D9F_s.wav');%F
            cgsound('WavFilSND', 12, 'D10M_s.wav');%M
            cgsound('WavFilSND', 13, 'D11F_s.wav');%F
            cgsound('WavFilSND', 14, 'D12M.wav');%M
            %Neutral sounds
            cgsound('WavFilSND', 15, 'N1.wav');%tone - neutral
            cgsound('WavFilSND', 16, 'N2.wav');%tone - neutral
            cgsound('WavFilSND', 17, 'N3.wav');%tone - neutral
            cgsound('WavFilSND', 18, 'N4.wav');%tone - neutral
            cgsound('WavFilSND', 19, 'N2.wav');%tone - neutral
            cgsound('WavFilSND', 20, 'N3.wav');%tone - neutral
            cgsound('WavFilSND', 21, 'N4.wav');%tone - neutral
>>>>>>> parent of 2338b6f... Changed odor on duration to 1.8s
            
            
            %followed by the presentation of UCS
            cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to black
            cgdrawsprite(picid,0,0);
            cgflip(0,0,0)
            picon = cogstd('sGetTime', -1) * 1000 ; %Log pic onset time
            parallel_acquire;
            
            while ((cogstd('sGetTime', -1) * 1000) < (picon + 1497))%play sound for 1.5s along with picture
                cgsound('play', voiceid)
                parallel_acquire;
            end
            
            cgsound('shut');
            % Draw the green cross to signal response window
            cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
            cgfont('Arial',60);
            cgpencol(0,1,0); %green
            cgtext('+',0,0);
            cgflip
            
        elseif (voiceid == 99)&& ((cogstd('sGetTime', -1) * 1000) > (odor_on + 2000))
            % Draw the green cross to signal response window
            cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
            cgfont('Arial',60);
            cgpencol(0,1,0); %green
            cgtext('+',0,0);
            cgflip
        end
        
<<<<<<< HEAD
        if (response_time ~= 0)
            key_str = sprintf ('Key\t%d\tDOWN\tat\t%0.1f\n', but_resp, response_time) ;
            log_string(key_str) ;
        end
        
        odoronTimes = [odoronTimes odor_on];
        odordurTimes = [odordurTimes odoroff-odor_on];
<<<<<<< HEAD

=======
        
        
>>>>>>> parent of b71d1e8... Merge branch 'master' of github.com:youlilly/olfactory_fmri_script
        if button_pressed % ****if button press occurred
            presses = presses + 1;
=======
        if ((cogstd('sGetTime', -1) * 1000) > (odor_on + 2000))
>>>>>>> parent of 2338b6f... Changed odor on duration to 1.8s
            
            % *** ODOR AND SNIFF CUE OFF ***
            % turn off the smell
            usb2_line_on(0,0);
            
            % log the odor off time
            odoroff = (cogstd('sGetTime', -1) * 1000) ;
            odorofftrue = 1;
        end
    end
    %     ** Response Logging: done; need testing
    while ((cogstd('sGetTime', -1) * 1000) < (odor_on + 5250))
        response_time = 0;
        
        while isempty(key)  && odorofftrue == 1
            [key,rtptb] = GetKey(keyStrings,5,GetSecs,-1);
            t_in_cog = (cogstd('sGetTime', -1) * 1000);
        end
        
<<<<<<< HEAD
        y=sprintf('Odor Cond %d sniffed at %d ms for %d ms duration',...
            odorid,odor_on,odoroff-odor_on);
        log_string(y);
        %log_string(buttstr);
        log_string(num2str(but_resp));
        log_string('');
<<<<<<< HEAD

        while ((cogstd('sGetTime', -1) * 1000) < (trialtime + SOA))
=======
        response_time = t_in_cog - odor_on;
=======
>>>>>>> parent of b71d1e8... Merge branch 'master' of github.com:youlilly/olfactory_fmri_script
        
        if ~isempty(key) && button_pressed == false
            
            if iscell(key)
                if key{1,1} == 'b' || key{1,1} == 'y' || key{1,1} == 'g' || key{1,1} == 'r'
                    key = key{1,1};
                else
                    key = key{1,2};
                end
            end
>>>>>>> parent of 2338b6f... Changed odor on duration to 1.8s
            
            if key=='b' % Odor A
                but_resp=1;
                allresp = [allresp; but_resp response_time];
                button_pressed = true;
            elseif key=='y' % Odor B
                but_resp=2;
                allresp = [allresp; but_resp response_time];
                button_pressed = true;
            elseif key=='g' % No odor
                but_resp=3;
                allresp = [allresp; but_resp response_time];
                button_pressed = true;
                
            else
                but_resp=NaN;
                allresp = [allresp; but_resp response_time];
                button_pressed = true;
            end
        end
        
<<<<<<< HEAD
    else %for no odor trials, present cross and rectangle
        cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])
        cgfont('Arial',60);
        cgpencol(0,0,0); %black cross
        cgtext('+',0,0);
        cgflip
        pause on
        pause (3);
        
<<<<<<< HEAD

=======
>>>>>>> parent of b71d1e8... Merge branch 'master' of github.com:youlilly/olfactory_fmri_script
        cgloadbmp(3,'rectangle.bmp');
=======
    end
    
    if (response_time ~= 0)
        key_str = sprintf ('Key\t%d\tDOWN\tat\t%0.1f\n', but_resp, response_time) ;
        log_string(key_str) ;
    end
    
    odoronTimes = [odoronTimes odor_on];
    odordurTimes = [odordurTimes odoroff-odor_on];
    
    
    if button_pressed % ****if button press occurred
        presses = presses + 1;
>>>>>>> parent of 2338b6f... Changed odor on duration to 1.8s
        
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
    
end

results.onsets.starttime = startTimes;
results.onsets.odoronTimes = odoronTimes;
results.onsets.odordurTimes = odordurTimes;

results.behav.allresp = allresp;
results.behav.rtypes = rtypes;
results.behav.noresp = noresp_trials;
results.behav.presses = presses;


%% Saving data

dmat = 'C:\My Experiments\Wen_Li\OCF\Data';
cd(dmat);
eval(['save OCF_beh_cond_sub' num2str(subnum) '_' name_id ';']);
cd(dm)

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
