% Odor Triangular test

%Notes to subjects:
%1. Constant Sniffs by pacing breaths (hold breath at "GET READY", sniff in
%during "SNIFF NOW", breath out at the offset of "SNIFF NOW". Breath
%normally during "WHich Sniff"
%Make a choice carefully, you have 5 seconds to make a decision.


global nAbsoluteLogTimerStart ;

log_file_name = input('Log file name ?','s');
log_init(log_file_name) ;
name_id = input('Partiticpant initials ? ','s');

subnum = input('Subject number? ');

switch rem(subnum,2)
    case 0
        csp = 1;
        StimR = [2 1 2; 2 1 1; 1 2 2; 1 1 2; 2 2 1; ];
        cor_resp = [2 1 1 3 3];
    case 1
        csp = 5;
        StimR = [4 5 4; 5 4 5; 5 5 4; 5 4 4; 4 4 5; ];
        cor_resp = [2 2 3 1 3];
end

subinfo = sprintf('name_id = %s, sub no. = %d, CS=%d', name_id,subnum);

SOA=20000;

resp=[];
rt=[];
rt_cond=cell(1,2);
acc=0;
presses=0;
odoronTimes_ind=cell(1,3);
odoronTimes=cell(1,16);
all_odoronTimes=[];
noresp_onTimes=[];
noresp=0;
odor_off_time=[];
rtypes = [];

% Configuring Hardware
usb_config ; %olfactometer
dio_config_bb ;

% Load and configure Cogent
cgloadlib
cgopen(1,0,0,1)
log_start_timer ;
log_header;

% Need a timing variable here
% This will be a relative timer from the start of Cogent.
% Use the
log_string('COGENT_START') ;
log_string(subinfo) ;

gsd = cggetdata('gsd') ;
gpd = cggetdata('gpd') ;

ScrWid = gsd.ScreenWidth ;
ScrHgh = gsd.ScreenHeight ;

% Clear back page
cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])

cgfont('Arial',30)
cgpencol(0,0,0)
% Write out Sniff Text
cgtext('Sniff when you see the words',0, 3 * ScrHgh / 6 - 15);
cgpencol(1, 0, 0); % red
strSniff = '"SNIFF NOW"' ;
cgtext(strSniff,0,2 * ScrHgh / 6 - 15);
cgpencol(0,0,0); %black
cgtext('After three sniffs, compare among these sniffs.',0,ScrHgh / 6 - 15);
cgtext('If Sniff 1 differs from the others,press Button 1.',0,-15);
cgtext('Or press Button 2 or 3, ',0,-1*ScrHgh/6 - 15);
cgtext('if Sniff 2 or 3 differs from the rest, respectively',0,-2 * ScrHgh/6 - 15);
cgflip

pause on
pause(10);

% present crosshair
cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])
cgfont('Arial',60);
cgpencol(1,0,0); %red
cgtext('+',0,0);
cgflip

%cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])
pause(5)

timectr=[];

count = 0;

%Assing bottonbox presses for input
Lkey = 7;  %Number7 assigned to "Bottle1" response
Mkey = 8;  %Number8 assigned to "Bottle2" response
Rkey = 9;  %Number9 assigned to "Bottle3" response

for i=1:5

    count  = count + 1;

    odors=StimR(i,:);


    trialtime = cogstd('sGetTime', -1) * 1000 ;
    timectr=[timectr trialtime];

    cgKeyMap
    if (count == 1)  % Record times/slices at start of expt...
        starttime  = trialtime;
    else
    end

    %Setting up response variables
    response_time = 0 ; %
    response_key = 0 ;
    a = getvalue(resp7); %number 7, Bottle1 response
    b = getvalue(resp8); %number 8, Bottle2 response
    c = getvalue(resp9); %number 9, Bottle3 response
    ansset = 0;

    readycue='GET READY !';
    cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
    cgpencol(0,0,0)  % Black
    cgtext(readycue,0,0);
    cgflip
    pause(2.5);  % Wait for two seconds

    cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
    t0=cgflip * 1000 ;
    timectr=[timectr t0] ;  % toc is the matlab command which gives the
    % elapsed time since toc command.


    % *** TURN ODOR #1 ON ***
    usb_line_on(odors(1));
    post_odor_on(i,1) = cogstd('sGetTime', -1) * 1000 ;

    % *** SNIFF CUE #1 ON ***
    cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])% Clear back screen to white
    cgpencol(1,0,0)  % red
    cgtext('SNIFF NOW-Sniff 1',0,0);
    while ((cogstd('sGetTime', -1) * 1000) < (post_odor_on(i,1) + 150)) end
    timectr= cgflip * 1000 ;
    tS1 = cogstd('sGetTime', -1) * 1000 ;
    dio_acquire ;

    bSniffTurnedOff = false ;
    while ((bSniffTurnedOff == false) && ((cogstd('sGetTime', -1) * 1000) <(post_odor_on(i,1) + 2000)))end;

    % *** ODOR AND SNIFF CUE OFF ***
    % turn off the smell
    usb_line_on(0);
    % log the odor off time
    toff1 = (cogstd('sGetTime', -1) * 1000) ;
    odor_off_time(i,1)= toff1;

    % sniff command OFF, background ON
    cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
    %     cgtext('', 0, 0);
    cgflip


    % *** TURN ODOR #2 ON ***
    %    pause(4); %wait 4 seconds

    while ((cogstd('sGetTime', -1) * 1000) < (post_odor_on(i,1) + 6000)) end ;
    usb_line_on(odors(2));
    post_odor_on(i,2) = cogstd('sGetTime', -1) * 1000 ;

    % *** SNIFF CUE #2 ON ***
    cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
    cgpencol(1,0,0); %red
    cgtext('SNIFF NOW-Sniff 2',0,0);
    while ((cogstd('sGetTime', -1) * 1000) < (post_odor_on(i,2) + 150)) end
    timectr= cgflip * 1000 ;
    tS2 = cogstd('sGetTime', -1) * 1000 ;
    dio_acquire ;

    bSniffTurnedOff = false ;
    while ((bSniffTurnedOff == false) && ((cogstd('sGetTime', -1) * 1000) < (post_odor_on(i,2) + 2000)))end;

    % *** ODOR AND SNIFF CUE OFF ***
    % turn off the smell
    usb_line_on(0);
    toff2 = cogstd('sGetTime', -1) * 1000 ;
    odor_off_time(i,2)= toff2;

    % sniff command OFF, background ON
    cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
    cgflip




    % *** TURN ODOR #3 ON ***
    %wait 4 seconds

    while ((cogstd('sGetTime', -1) * 1000) <(post_odor_on(i,2) + 6000)) end

    usb_line_on(odors(3));
    post_odor_on(i,3) = cogstd('sGetTime', -1) * 1000 ;

    % *** SNIFF CUE #3 ON ***

    cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
    cgpencol(1,0,0); %red
    cgtext('SNIFF NOW-Sniff 3',0,0);

    timectr= cgflip * 1000 ;
    tS3 = cogstd('sGetTime', -1) * 1000 ;
    dio_acquire ;

    bSniffTurnedOff = false ;

    response_time = 0 ;
    response_key = 0 ;

    while ((cogstd('sGetTime', -1) * 1000) < (post_odor_on(i,3) + 6000))

        if ((bSniffTurnedOff == false) && ((cogstd('sGetTime', -1) * 1000) > (post_odor_on(i,3) + 2000)))

            % *** ODOR AND SNIFF CUE OFF ***
            % turn off the smell
            usb_line_on(0);

            % log the odor off time
            toff3 = cogstd('sGetTime', -1) * 1000 ;
            odor_off_time(i,3)= toff3;

            % sniff command OFF, background ON
            cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
            cgpencol(0,0,0); %red
            cgtext('Which Sniff?',0,0);
            cgflip

            bSniffTurnedOff = true ;

        end

        rt_current = cogstd('sGetTime', -1) * 1000 ;

        if getvalue(resp7) ~= a
            response_key = Lkey;
            ansset = 1;
            rt_current = (cogstd('sGetTime', -1) * 1000) ;
            response_time = rt_current - post_odor_on(i,3);

        elseif getvalue(resp8) ~= b
            response_key = Mkey;
            ansset = 1;
            rt_current = (cogstd('sGetTime', -1) * 1000) ;
            response_time = rt_current - post_odor_on(i,3);

        elseif getvalue(resp9) ~= c
            response_key = Rkey;
            ansset = 1;
            rt_current = (cogstd('sGetTime', -1) * 1000) ;
            response_time = rt_current - post_odor_on(i,3);

        end

    end

    if (response_time ~= 0)
        key_str = sprintf ('Key\t%d\tDOWN\tat\t%0.1f\n', response_key, response_time) ;
        log_string(key_str) ;
    end

    if ansset > 0 % i.e., if button press occurred
        presses = presses + 1;
        rt = [rt response_time]; % rt based on 1st button press, from the onset of Sniff 3
        rtypes = [rtypes; i response_key];

        %    Collate data

        if (cor_resp(i)==1 && (response_key == Lkey)) % i.e. correct to press 'yes' right button
            %             RTs{odorcond}  = [RTs{odorcond} rt];   % cond-specific correct odour RTs
            buttstr = 'HIT';
            acc = acc + 1;
        elseif (cor_resp(i)==2 && (response_key == Mkey)) % i.e. correct to press 'yes' right button
            %             RTs{odorcond}  = [RTs{odorcond} rt];   % cond-specific correct odour RTs
            buttstr = 'HIT';
            acc = acc + 1;
        elseif (cor_resp(i)==3 && (response_key == Rkey)) % i.e. correct to press 'yes' right button
            %             RTs{odorcond}  = [RTs{odorcond} rt];   % cond-specific correct odour RTs
            buttstr = 'HIT';
            acc = acc + 1;

        else
            buttstr='MISS';
        end
    else

        buttstr = 'NO BUTTON PRESS';
        response_key = NaN;
        noresp = noresp + 1;
        noresp_onTimes  = [noresp_onTimes; post_odor_on(i,:)];
    end



    odoronTimes{1,i} = [odoronTimes{1,i}; post_odor_on(i,:)];
    all_odoronTimes=[all_odoronTimes; post_odor_on(i,:)'];


    log_string(buttstr);
    log_string(num2str(response_key));
    log_string('');


    % clearkeys;
    cgKeyMap;

    while ((cogstd('sGetTime', -1) * 1000) < (trialtime + SOA))
        if i == 2
            test = sprintf('cogstd(%d) * 1000 < trialtime(%d) + SOA)',...
                (cogstd('sGetTime', -1) * 1000), trialtime) ;

        end
        cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
        cgflip
    end
    % waituntil(trialtime + (SOA*1000) - 1000); % the real SOA is 12 sec
    %}

end

% Save variables

results.onsets.starttime    = starttime;
results.onsets.odoronTimes       = odoronTimes;
results.onsets.all_odoronTimes       = all_odoronTimes;
results.onsets.odoronTimes_ind     = odoronTimes_ind;
results.onsets.post_odor_on =post_odor_on;
results.onsets.odor_off_time= odor_off_time;

results.behav.rt      = rt;
results.behav.rt_cond     = rt_cond;

results.behav.acc     = acc;
results.behav.noresp  = noresp;

results.checks.subinfo         = subinfo;
%results.checks.CS         = CS;
results.checks.Presses         = presses;
results.checks.SOA             = SOA;
results.checks.stimlist       = StimR;
%
% wait (80000)
startwait = cogstd('sGetTime', -1) * 1000 ;
while ((cogstd('sGetTime', -1) * 1000) < startwait +3000) end ;


% Clear back page
% clearpict(2)
cgrect(0, 0, ScrWid, ScrHgh, [1 1 1]) ;
cgflip ;

cgrect(0, 0, ScrWid, ScrHgh, [1 1 1]) ;
cgpencol(0,0,0) ;

% prepare string
cgtext('Well done ! Take a break',0,ScrHgh / 6 - 15);
cgflip ;

startwait = cogstd('sGetTime', -1) * 1000 ;
while ((cogstd('sGetTime', -1) * 1000) < (startwait + 2000)) end

cd C:\OCB\Data;
eval(['save OCB_post_triangular_sub' num2str(subnum) '_' name_id ';']);
cd C:\OCB;
%
pause off
log_finish ;
usb_finish ;
dio_finish_bb ;

cgshut



