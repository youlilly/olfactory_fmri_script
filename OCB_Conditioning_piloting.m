%% Olfactory conditioning fMRI (OCF) study - behavioral piloting version
%% Conditioning block
%Created by YY, 7/22/14

log_file_name = input('Log file name ?','s');
log_init(log_file_name) ;
name_id = input('Partiticpant initials ? ','s');

subnum = input('Subject number? ');

subinfo = sprintf('name_id = %s, sub no. = %d, ', name_id,subnum);

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


SOA = 14100;

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

    odorid=StimR(i,1);
    voiceid = StimR(i,2);
    picid=StimR(i,3) ; %Specifies which of the emo conditions is presented   
    cgkeymap;
    
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
        
            if (voiceid ~= 99)&& ((cogstd('sGetTime', -1) * 1000) > (post_odor_on + 1000)) && ((cogstd('sGetTime', -1) * 1000) < (post_odor_on + 1400))
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
                %dio_acquire;

                    while ((cogstd('sGetTime', -1) * 1000) < (picon + 1497))%play sound for 1.5s along with picture
                        cgsound('play', voiceid)
                    end
                    
                cgsound('shut');
                cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
%                 cgtext('L: Odor A',0,60);
%                 cgtext('M: No Odor',0,0);
%                 cgtext('R: Odor B',0,-60);
                cgflip   
                
            elseif (voiceid == 99)&& ((cogstd('sGetTime', -1) * 1000) > (post_odor_on + 2000)) 
                cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
%                 cgtext('L: Odor A',0,60);
%                 cgtext('M: No Odor',0,0);
%                 cgtext('R: Odor B',0,-60);
                cgflip   
            end
        
        if ((cogstd('sGetTime', -1) * 1000) > (post_odor_on + 2000))

            % *** ODOR AND SNIFF CUE OFF ***
            % turn off the smell
            usb_line_on(0);

            % log the odor off time
            odoroff = (cogstd('sGetTime', -1) * 1000) ;
            
        end
        
            
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
    %log_string(buttstr);
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

cd C:\OCB\Data;
eval(['save OCB_beh_cond_sub' num2str(subnum) '_' name_id ';']);
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
