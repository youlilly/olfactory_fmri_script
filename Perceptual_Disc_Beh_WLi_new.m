% Set up script variables.

clear all
cd c:\pdl_cond\m_scripts

log_file_name = input('Log file name ?','s') ;

% Start log file using low level functions.
log_init (log_file_name) ;
global nAbsoluteLogTimerStart ;

name_id = input('Subjects initials ? ','s');
gender=input('subjects gender ?', 's');
age=input('subjects age ?');
eth=input('subjects ethnicity?-African, Caucasian, Asian, Hispanic, others', 's');
cs=input('(+)-2-butanol, (-)-2-butanol, (+)-rose oxide, (-)-rose oxide, (1,2,3,4) ?');


sub  = 150;
while sub>100
    sub = input('Which subject number ? ');
end

subinfo = sprintf('name_id = %s, sub no. = %d, age=%d, cs=%d, gender=%s, eth=%s', name_id,sub,age, cs, gender, eth);

% cs = 0 ;
% while (cs == 0)
%     cs=input('CS odor?');
%     if ((cs < 1) || (cs > 4))
%         'Enter a CS odor value between 1 and 4'
%         cs = 0 ;
%
%     end
% end

%cs = 3;  %***************  Delete this when moving to working version ****
rand('state',100*sub+3);
switch cs
    case {1}
        stimordA=[1 3 8 2 4];
        stimordB = repmat([1, 2, 3, 4 ,8],3,1); stimordB = stimordB(randperm(15));
        stimordC=[1 4 2 8 3];
        stimordD = repmat([1, 2, 3, 4 ,8],3,1); stimordD = stimordD(randperm(15));
        stimordE=[1 8 3 4 2];
        stimordF = repmat([1, 2, 3, 4 ,8],3,1); stimordF = stimordF(randperm(15));
    case {2}
        stimordA=[2 3 8 1 4];
        stimordB = repmat([1, 2, 3, 4 ,8],3,1); stimordB = stimordB(randperm(15));
        stimordC=[2 4 1 8 3];
        stimordD = repmat([1, 2, 3, 4 ,8],3,1); stimordD = stimordD(randperm(15));
        stimordE=[2 8 3 4 1];
        stimordF = repmat([1, 2, 3, 4 ,8],3,1); stimordF = stimordF(randperm(15));
    case {3}
        stimordA=[3 1 8 2 4];
        stimordB = repmat([1, 2, 3, 4 ,8],3,1); stimordB = stimordB(randperm(15));
        stimordC=[3 4 2 8 1];
        stimordD = repmat([1, 2, 3, 4 ,8],3,1); stimordD = stimordD(randperm(15));
        stimordE=[3 8 1 4 2];
        stimordF = repmat([1, 2, 3, 4 ,8],3,1); stimordF = stimordF(randperm(15));
    case {4}
        stimordA=[4 3 8 2 1];
        stimordB = repmat([1, 2, 3, 4 ,8],3,1); stimordB = stimordB(randperm(15));
        stimordC=[4 1 2 8 3];
        stimordD = repmat([1, 2, 3, 4 ,8],3,1); stimordD = stimordD(randperm(15));
        stimordE=[4 8 3 1 2];
        stimordF = repmat([1, 2, 3, 4 ,8],3,1); stimordF = stimordF(randperm(15));
end
stimord=[stimordA'; stimordB'; stimordC'; stimordD';  stimordE'; stimordF';];


SOA = 12000;

stimindex=[];
condindex=[];

odoronTimes  = [];
odordurTimes = [];


shocktimes=[];
odoronTimes_ind  = cell(1,5);
odordurTimes_ind = cell(1,5);

yes_odoronTimes  = cell(1,5);
yes_odordurTimes = cell(1,5);

no_odoronTimes  = [];
no_odordurTimes = [];

miss_onTimes  = [];
miss_durTimes = [];

fa_onTimes  = [];
fa_durTimes = [];

noresp_onTimes  = [];
noresp_durTimes = [];

allRTs     = cell(1,5); %regardless of response accuracy
RTs     = cell(1,5); % only records correct responses (hits and CR)
missRTs = [];
faRTs   = [];
acc = zeros(1,4);
cr     = 0;
miss   = 0;
fa     = 0;
noresp = 0;
presses  = 0;
trialtime_log=[];
shocktimes_new=[];
% Configuring Hardware
usb_config ; %olfactometer
dio_config ; %shocker

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


% Clear back page
cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])

cgfont('Arial',36)
cgpencol(0,0,0)
% Write out Sniff Text
cgtext('Sniff when you see the words',0, 3 * ScrHgh / 6 - 15);
cgpencol(1, 0, 0); % red
strSniff = '"SNIFF NOW"' ;
cgtext(strSniff,0,2 * ScrHgh / 6 - 15);
cgpencol(0,0,0); %black
cgtext('Press the RIGHT button if you think',0,ScrHgh / 6 - 15);
cgtext('there IS a smell',0,-15);
cgtext('Press the LEFT button if you think',0,-1*ScrHgh/6 - 15);
cgtext('there is NO smell',0,-2 * ScrHgh/6 - 15);
cgflip

pause on
pause(8);

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

ykey = 77;    % from cgKeyMap this equals the R ARROW key
nkey = 75;    % from cgKeyMap this equals the L ARROW key

%   for i=1:2;
for i = 1:length(stimord);


    count  = count + 1;

    odorid=stimord(i);
    if odorid < 5
        odorcond=odorid;
    else
        odorcond=5;
    end


    stimindex = [stimindex odorcond];

    trialtime = cogstd('sGetTime', -1) * 1000 ;
    timectr=[timectr trialtime];

    cgKeyMap
    if (count == 1)  % Record times/slices at start of expt...
        starttime  = trialtime;
    else
    end

    readycue='GET READY !';
    cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
    cgpencol(0,0,0)  % Black
    cgtext(readycue,0,0);
    cgflip
    pause(2);  % Wait for two seconds

    cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
    t0=cgflip * 1000 ;
    timectr=[timectr t0] ;

    %************Sniff*********
    cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
    cgtext('3',0,0);
    pause(1);  % Countdown "3"!!! (t = -2250 ms)
    cgflip
    t1 = cogstd('sGetTime', -1) * 1000 ;


    cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
    cgtext('2',0,0);
    while ((cogstd('sGetTime', -1) * 1000) < (t1 + 750)) end
    cgflip

    cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
    cgtext('1',0,0);
    while ((cogstd('sGetTime', -1) * 1000) < (t1 + 1500)) end  % Countdown "1"!!! (t = -750 ms)
    cgflip

    % *** TURN ODOR #1 ON ***
    while ((cogstd('sGetTime', -1) * 1000) < (t1 + 2100)) end  % Countdown "1"!!! (t = -750 ms)
    usb_line_on(odorid);
    post_odor_on = cogstd('sGetTime', -1) * 1000 ;

    % *** SNIFF CUE #1 ON ***
    cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
    cgtext('SNIFF NOW',0,0);
    while ((cogstd('sGetTime', -1) * 1000) < (post_odor_on + 150)) end
    timectr= cgflip * 1000 ;
    tS1 = cogstd('sGetTime', -1) * 1000 ;
    dio_acquire ;
    bSniffTurnedOff = false ;

    bShockSubject = false ;
    if odorid==cs;
        rantime=rand(1)*500-200;
        tLogShockNow = post_odor_on + 3150 + rantime ;
        bShockSubject = true ;
    end

    bSubjectShockLogged = false ;

    response_time = 0 ;
    response_key = 0 ;

    while ((cogstd('sGetTime', -1) * 1000) < (post_odor_on + 6500))

        if ((bSniffTurnedOff == false) && ((cogstd('sGetTime', -1) * 1000) > (post_odor_on + 2000)))

            % *** ODOR AND SNIFF CUE OFF ***
            % turn off the smell
            usb_line_on(0);

            % log the odor off time
            toff1 = (cogstd('sGetTime', -1) * 1000) ;
            cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white

            % sniff command OFF, background ON
            cgflip

            bSniffTurnedOff = true ;

        end


        if (bSubjectShockLogged == false)

            if ((cogstd('sGetTime', -1) * 1000) > tLogShockNow)
                if (bShockSubject == true)
                    dio_trigger;

                    stime=cogstd('sGetTime', -1) * 1000 - nAbsoluteLogTimerStart ;
                    stime_new=cogstd('sGetTime', -1) * 1000;
                    shocktimes=[shocktimes stime];
                    shocktimes_new=[shocktimes_new stime_new];
                    log_string('Shock');

                else

                    log_string('No shock');

                end

                bSubjectShockLogged = true ;

            end

        end % if (bSubjectShockLogged == false))


        rt_current = cogstd('sGetTime', -1) * 1000 ;

        if (response_time == 0)

            % Read the keyboard
            [k_current, k_previous] = cgKeyMap ;

            % Get the current time.
            rt_old = rt_current ;
            rt_current = cogstd('sGetTime', -1) * 1000 ;


            % Check to see if left arrow key press has occured.
            if (k_previous(nkey) == 1)
                response_time = (rt_old + rt_current)/2 - post_odor_on;
                response_key = nkey ;

            end

            if (k_current(nkey) == 1)
                response_time = rt_current - post_odor_on;
                response_key = nkey ;
            end

            % Check to see if right arrow key press has occured.
            if (k_previous(ykey) == 1)
                response_time = (rt_old + rt_current)/2 - post_odor_on;
                response_key = ykey ;
            end

            if (k_current(ykey) == 1)
                response_time = rt_current - post_odor_on;
                response_key = ykey ;
            end
            
            if (response_time ~= 0)

                key_str = sprintf ('Key\t%d\tDOWN\tat\t%0.1f\n', response_key, response_time) ;
                log_string(key_str) ;

            end

        end

    end
    %   logkeys;
    %    [byte_in, t_in, n_in]=getkeydown([13,14]);  %used byte_in rather than keyout just to simplify the script below.

    % first collate odor times
    odoronTimes = [odoronTimes post_odor_on];
    odordurTimes = [odordurTimes toff1-post_odor_on];

    odoronTimes_ind{odorcond} = [odoronTimes_ind{odorcond} post_odor_on];
    odordurTimes_ind{odorcond} = [odordurTimes_ind{odorcond} toff1-post_odor_on];

    % now collate times according to button response



% now collate times according to button response


if response_time > 0 % i.e., if button press occurred
    presses = presses + 1;
    rt = response_time; % rt based on 1st button press, measured from onset of 2nd sniff
    allRTs{odorcond}  = [allRTs{odorcond} rt];   % collates all RTs in order by cond.


    % ykey=77;    % from cgKeyMap this equals the right arrow key
    % nkey=75;    % from cgKayMap this equals the left arrow key

    if ((odorid < 5) && (response_key == ykey)) % i.e. correct to press 'yes' right button
        RTs{odorcond}  = [RTs{odorcond} rt];   % cond-specific correct odour RTs
        buttstr = 'HIT: odor present';

        acc(odorcond) = acc(odorcond) + 1;
        yes_odoronTimes{odorcond}  = [yes_odoronTimes{odorcond} post_odor_on];
        yes_odordurTimes{odorcond} = [yes_odordurTimes{odorcond} toff1-post_odor_on];


    elseif ((odorid == 8) && (response_key == nkey)) % i.e. correct to press 'no' left button
        RTs{odorcond}  = [RTs{odorcond} rt];   % cond-specific correct no-odour RTs
        buttstr = 'CORR REJ: odor absent';
        cr = cr + 1;
        no_odoronTimes  = [no_odoronTimes post_odor_on];
        no_odordurTimes = [no_odordurTimes toff1-post_odor_on];


    elseif ((odorid < 5) && (response_key == nkey)) % i.e. incorrect to press 'no' left button
        missRTs  = [missRTs rt]; % incorrect missed-odour RTs
        buttstr = 'MISS: odor MISS trial';
        miss = miss + 1;
        miss_onTimes  = [miss_onTimes post_odor_on];
        miss_durTimes = [miss_durTimes toff1-post_odor_on];


    elseif ((odorid == 8) && (response_key == ykey)) % i.e. incorrect to press 'yes' right button
        faRTs  = [faRTs rt]; % false alarm RTs
        buttstr = 'FA: false alarm trial';
        fa = fa + 1;
        fa_onTimes  = [fa_onTimes post_odor_on];
        fa_durTimes = [fa_durTimes toff1-post_odor_on];


    else
    end

else
    buttstr = 'NO BUTTON PRESS';
    response_key = NaN;
    noresp = noresp + 1;
    noresp_onTimes  = [noresp_onTimes post_odor_on];
    noresp_durTimes = [noresp_durTimes toff1-post_odor_on];

end




y=sprintf('Odor Cond %d sniffed at %d ms for %d ms duration',...
    odorid,post_odor_on,toff1-post_odor_on);
log_string(y);
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
end
% waituntil(trialtime + (SOA*1000) - 1000); % the real SOA is 12 sec
%}

end

%{
clearpict(1);clearpict(2);clearpict(3); clearpict(4); clearpict(5); clearpict(6);
drawpict(1);
%}

%Save variables


results.onsets.starttime    = starttime;
results.onsets.odoronTimes       = odoronTimes;
results.onsets.odordurTimes      = odordurTimes;

results.onsets.odoronTimes_ind       = odoronTimes_ind ;
results.onsets.odordurTimes_ind    = odordurTimes_ind ;

results.onsets.yes_odoronTimes       = yes_odoronTimes;
results.onsets.yes_odordurTimes      = yes_odordurTimes;

results.onsets.no_odoronTimes       = no_odoronTimes;
results.onsets.no_odordurTimes      = no_odordurTimes;

results.onsets.miss_onTimes     = miss_onTimes;
results.onsets.miss_durTimes    = miss_durTimes;

results.onsets.fa_onTimes     = fa_onTimes;
results.onsets.fa_durTimes    = fa_durTimes;

results.onsets.noresp_onTimes     = noresp_onTimes;
results.onsets.noresp_durTimes    = noresp_durTimes;

results.onsets.post_odor_on =post_odor_on;

results.onsets.shocktimes=shocktimes;
results.onsets.shocktimes_new=shocktimes_new;

results.behav.allRTs      = allRTs;
results.behav.RTs     = RTs;
results.behav.missRTs = missRTs;
results.behav.faRTs   = faRTs;
results.behav.acc     = acc;
results.behav.cr      = cr;
results.behav.miss    = miss;
results.behav.fa      = fa;
results.behav.noresp  = noresp;

results.checks.subinfo         = subinfo;
results.checks.CS         = cs;
results.checks.Presses         = presses;
results.checks.SOA             = SOA;
results.checks.stimindex       = stimindex;
%
% wait (10000)
startwait = cogstd('sGetTime', -1) * 1000 ;
while ((cogstd('sGetTime', -1) * 1000) < startwait + 10000) end ;


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
while ((cogstd('sGetTime', -1) * 1000) < (startwait + 6000)) end


% stop_cogent
%## dio_finish
%## usb_finish

% if subtype == 'c'
%     subgrp = 'CTL';
% elseif subtype == 'p'
%     subgrp = 'AD';
% else
% end
cd C:\PDL_Cond\Mat_files;
eval(['save ' deblank(name_id) '_sub' num2str(sub)  '_PDL_Cond_data results']);
cd c:\pdl_cond\m_scripts

%}

pause off
log_finish ;
usb_finish ;
dio_finish ;
cgshut
