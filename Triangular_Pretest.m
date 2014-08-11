% Odor Triangular test

%Notes to subjects: 
%1. Constant Sniffs by pacing breaths (hold breath at "GET READY", sniff in
%during "SNIFF NOW", breath out at the offset of "SNIFF NOW". Breath
%normally during "WHich Sniff"
%Make a choice carefully, you have 5 seconds to make a decision.

% Nov. 10, 2008
clear all
cd c:\pdl_cond\m_scripts
log_file_name = input('Log file name ?','s') ;

% Start log file using low level functions.
log_init (log_file_name) ;
global nAbsoluteLogTimerStart ;

%records subject's name first:
name_id=input('Enter your name/initials (no spaces): ','s');
subjno=input('Enter subject number (1,2,3,...): ');
CS=input('CS odor--1,2,3,4?');

subinfo = sprintf('name_id = %s, sub no. = %d, CS=%d', name_id,subjno,CS);

%Step One: RANDOMIZE LIST
% [(+)-2-butanol, (-)-2-butanol, (+)-rose oxide, (-)-rose oxide ]= [1,2,3,4]
stimorda=[1 1 2]; % (+)-2-butanol,  (+)-2-butanol, 
stimordb=[2 1 1]; %(-)-2-butanol, (+)-2-butanol,  (+)-2-butanol
stimordc=[1 2 1]; %(+)-2-butanol,(-)-2-butanol, (+)-2-butanol
stimorda1=[2 2 1];
stimordb1=[1 2 2];
stimordc1=[2 1 2];
stimordA=[3 3 4]; % (+)-rose oxide,(+)-rose oxide,(-)-rose oxide
stimordB=[4 3 3];
stimordC=[3 4 3];
stimordA1=[4 4 3]; %(-)-rose oxide, (-)-rose oxide, (+)-rose oxide
stimordB1=[3 4 4];
stimordC1=[4 3 4];

SOA=20000;

stimlist=[stimordA; stimordb1; stimordC; stimordB1; stimordc1; stimordC1; stimorda; stimorda1; stimordb; stimordc; stimordA1; stimordB; stimordC1; stimordb1; stimordc; stimordB];
cor_resp=[3, 1, 2, 1, 2, 2, 3, 3 2 1 2 3 1 2 1 1];
% repeated stim: C1 C B b1
    
resp=[];
rt=[];
rt_cond=cell(1,2);
acc=zeros(1,2);
presses=0;
odoronTimes_ind=cell(1,3);
odoronTimes=cell(1,16);
all_odoronTimes=[];
noresp_onTimes=[];
noresp=0;
odor_off_time=[];
% Configuring Hardware
usb_config ; %olfactometer
dio_config ;

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

S1key = 51;    % from cgKeyMap this equals the <,
S2key = 52;
S3key = 53;

for i=1:16
    
    count  = count + 1;
   
    odors=stimlist(i,:);
   zz=find(odors==CS);
   snfs=[];
   % coding sniff type: tgCS+=1, chCS+=2, CS-=3;
   if zz>0
       for xx=1:3
           if odors(xx)==CS
               snfs=[snfs,1];
           else
               snfs=[snfs,2];

           end
       end
   else
       snfs=[3 3 3];
   end
       
  
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
    pause(1.85);  % Wait for two seconds
    
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
     cgpencol(0,0,0); %red
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
    
    while ((cogstd('sGetTime', -1) * 1000) < (post_odor_on(i,3) + 8000))     
    
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

        if (response_time == 0)

            % Read the keyboard       
            [k_current, k_previous] = cgKeyMap ;

            % Get the current time. 
            rt_old = rt_current ;
            rt_current = cogstd('sGetTime', -1) * 1000 ;


            % Check to see if S1 key press has occured.
            if (k_previous(S1key) == 1)
                response_time = (rt_old + rt_current)/2 - post_odor_on(i,3);
                response_key = S1key ;

            end

            if (k_current(S1key) == 1)
                response_time = rt_current - post_odor_on(i,3);                
                response_key = S1key ;
            end

            % Check to see if S2 key press has occured.
            if (k_previous(S2key) == 1)
                response_time = (rt_old + rt_current)/2 - post_odor_on(i,3);
                response_key = S2key ;
            end

            if (k_current(S2key) == 1)
                response_time = rt_current - post_odor_on(i,3); 
                response_key = S2key ;
            end
            
            
            % Check to see if S3 key press has occured.
            if (k_previous(S3key) == 1)
                response_time = (rt_old + rt_current)/2 - post_odor_on(i,3);
                response_key = S3key ;
            end

            if (k_current(S3key) == 1)
                response_time = rt_current - post_odor_on(i,3); 
                response_key = S3key ;
            end

            if (response_time ~= 0)

                key_str = sprintf ('Key\t%d\tDOWN\tat\t%0.1f\n', response_key, response_time) ;
                log_string(key_str) ;

            end
        end
    end

    if response_time > 0 % i.e., if button press occurred
        presses = presses + 1;
        rt = [rt response_time]; % rt based on 1st button press, from the onset of Sniff 3
        if zz>0
            cond=1;
            rt_cond{1,1}  = [rt_cond{1,1} response_time];   % collates all RTs in order by cond CS+/CS-.
        else
            cond=2;
            rt_cond{1,2}=[rt_cond{1,2} response_time];
        end

        %    Collate data

        if (cor_resp(i)==1 && (response_key == S1key)) % i.e. correct to press 'yes' right button
            %             RTs{odorcond}  = [RTs{odorcond} rt];   % cond-specific correct odour RTs
            buttstr = 'HIT';
            acc(cond) = acc(cond) + 1;
        elseif (cor_resp(i)==2 && (response_key == S2key)) % i.e. correct to press 'yes' right button
            %             RTs{odorcond}  = [RTs{odorcond} rt];   % cond-specific correct odour RTs
            buttstr = 'HIT';
            acc(cond) = acc(cond) + 1;
        elseif (cor_resp(i)==3 && (response_key == S3key)) % i.e. correct to press 'yes' right button
            %             RTs{odorcond}  = [RTs{odorcond} rt];   % cond-specific correct odour RTs
            buttstr = 'HIT';
            acc(cond) = acc(cond) + 1;

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
    
    for jj=1:3
        odorcond=snfs(jj); %three odor conditions (tgCS+, chCS+, CS-);
        odoronTimes_ind{odorcond} = [odoronTimes_ind{odorcond} post_odor_on(i,jj)];
    end
    
   y=sprintf('Odor Cond %d sniffed at %d ms',...
    odorcond,post_odor_on(i,:));
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
results.checks.CS         = CS;
results.checks.Presses         = presses;
results.checks.SOA             = SOA;
results.checks.stimlist       = stimlist;
%
% wait (80000)
startwait = cogstd('sGetTime', -1) * 1000 ;
while ((cogstd('sGetTime', -1) * 1000) < startwait +8000) end ;


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

cd C:\PDL_Cond\Mat_files;
eval(['save ' deblank(name_id) '_sub' num2str(subjno) '_Trig_Pre results'])

cd c:\pdl_cond\m_scripts
% 
pause off
log_finish ;
usb_finish ;
dio_finish ;

cgshut



