%Odor risk rating - behavioral version - olfactometer
clear all

initials = input('Subject Initials?','s');

%Valid subject number has to be less than 100
sub  = 150;
while sub>100
    sub = input('Subject number? ');
end

% Pre-randomized stimulus matrix; same for each subject;
% Col 1 = picture id (1-50),
% Col 2 = emotion condition(1=fear,2=disgust,3=neutral)
% Col 3 = spatial frequency (1=low,2=high)

odorlist = repmat([1 2 3 4 5],1,3);
odorlist = odorlist(randperm(15)'); % produces a list named "odlist" which randomizes the numbers from 1 to 80

% Load and configure Cogent
cgloadlib
cgopen(1,0,0,1)% starts Cogent
%%%log_start_timer ;
%%%log_header ;

gsd = cggetdata('gsd') ; %requests the GScnd Data structure
gpd = cggetdata('gpd') ; %requests the GPrim Data structure

ScrWid = gsd.ScreenWidth ;
ScrHgh = gsd.ScreenHeight ;

cgkeymap;%clear keymap
k_previous(28) = 0;

cgmouse(0,0);

while ~k_previous(28)
    [k_current, k_previous] = cgkeymap ;
    % Clear back page
    cgrect(0, 0, ScrWid, ScrHgh, [0 0 0]) %changed background page of black

    %Experiment instructions
    cgfont('Arial',28)%changed from 36 pt to 28 pt
    cgpencol(1,1,1) %white letters
    cgtext('Sniff odor after countdown',0,1.5 * ScrHgh / 9 + 12);
    cgtext('And rate the your perception of each odor',0,1 * ScrHgh/9 );
    cgtext('By clicking the corresponding location on a line',0,0.5 * ScrHgh/9 - 12);
    cgtext('Press Enter to continue',0,-1.5 * ScrHgh/9 - 6);
    cgflip

end

%Set up more variables: counter, timecounter
timectr=[]; %Matrix of times for when each trial began
noresp = 0 ;
presses = 0 ;
count = 0;
OdorRatings = [];


cgpencol(1,1,1)
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

usb_config

%Trial loop for each of the 150 trials
for i = 1:15;

    odorid = odorlist(i);
    %Get ready cues
    readycue='GET READY !';
    cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  % Clear back screen to white
    cgpencol(0,0,0)  % Black
    cgtext(readycue,0,0);
    cgflip
    pause on
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

    pause on
    pause(3);

    % *** ODOR AND SNIFF CUE OFF ***
    % turn off the smell
    usb_line_on(0);

    %%%%%%%% Valence rating starts here

    cgkeymap;
    cgmouse;
    bprevious=0;
    k_previous(28) = 0;
    c=0;
    visindex = 999;

    while ~k_previous(28)
        [k_current, k_previous] = cgkeymap ;
        [x2,y2,bs,bprevious]=cgmouse;

        if ~bprevious && c==0
            cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])
            cgfont('Arial',25)
            cgpencol(0,0,1) %red letters
            cgtext('How do you like this odor?',0, 4 * ScrHgh / 9 - 15);
            cgpencol(0,0,0) %white letters
            cgtext('Click anywhere on the line and press ENTER to confirm',0,2.2*ScrHgh/9-15);
            cgtext('Extremely                                                      Extremely',0,-1 * ScrHgh/9 - 6);
            cgtext('Unpleasant                                                      Pleasant',0,-1.5 * ScrHgh/9 - 6);

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
            cgpencol(0,0,1) %red letters
            cgtext('How do you like this odor?',0, 4 * ScrHgh / 9 - 15);
            cgpencol(0,0,0) %white letters
            cgtext('Click anywhere on the line and press ENTER to confirm',0,2.2*ScrHgh/9-15);
            cgtext('Extremely                                                      Extremely',0,-1 * ScrHgh/9 - 6);
            cgtext('Unpleasant                                                      Pleasant',0,-1.5 * ScrHgh/9 - 6);

            %Draw the cursor
            cgalign('l','t')
            cgdrawsprite(20, x2+2.5,y2-2)
            cgalign('c','c')

            cgpenwid(3);
            cgdraw (-250,0,250,0);
            cgpencol(1,0,0)
            cgpenwid(4);
            cgdraw (x2,y2-10,x2,y2+10);
            cgflip(1,1,1)
            pause(1.5)

            visindex = (x2+250)/500*100;
            bprevious = 0;
            c = 0;
        end

    end

    %%%%%%%% Intesnity rating starts here

    cgkeymap;
    cgmouse;
    bprevious=0;
    k_previous(28) = 0;
    c=0;
    intensityindex = 999;

    while ~k_previous(28)
        [k_current, k_previous] = cgkeymap ;
        [x2,y2,bs,bprevious]=cgmouse;

        if ~bprevious && c==0
            cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])
            cgfont('Arial',25)
            cgpencol(0,0,1) %red letters
            cgtext('How intense is this odor?',0, 4 * ScrHgh / 9 - 15);
            cgpencol(0,0,0) %white letters
            cgtext('Click anywhere on the line and press ENTER to confirm',0,2.2*ScrHgh/9-15);
            cgtext('Extremely                                                      Extremely',0,-1 * ScrHgh/9 - 6);
            cgtext('Weak                                                            Strong',0,-1.5 * ScrHgh/9 - 6);
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
            cgpencol(0,0,1) %red letters
            cgtext('How intense is this odor?',0, 4 * ScrHgh / 9 - 15);
            cgpencol(0,0,0) %white letters
            cgtext('Click anywhere on the line and press ENTER to confirm',0,2.2*ScrHgh/9-15);
            cgtext('Extremely                                                      Extremely',0,-1 * ScrHgh/9 - 6);
            cgtext('Weak                                                            Strong',0,-1.5 * ScrHgh/9 - 6);
            %Draw the cursor
            cgalign('l','t')
            cgdrawsprite(20, x2+2.5,y2-2)
            cgalign('c','c')

            cgpenwid(3);
            cgdraw (-250,0,250,0);
            cgpencol(1,0,0)
            cgpenwid(4);
            cgdraw (x2,y2-10,x2,y2+10);
            cgflip(1,1,1)
            pause(1.5)

            intensityindex = (x2+250)/500*100;
            bprevious = 0;
            c = 0;
        end

    end


    %%%%%%%% Familiarity rating starts here

    cgkeymap;
    cgmouse;
    bprevious=0;
    k_previous(28) = 0;
    c=0;
    familiarityindex = 999;

    while ~k_previous(28)
        [k_current, k_previous] = cgkeymap ;
        [x2,y2,bs,bprevious]=cgmouse;

        if ~bprevious && c==0
            cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])
            cgfont('Arial',25)
            cgpencol(0,0,1) %red letters
            cgtext('How familiar is this odor?',0, 4 * ScrHgh / 9 - 15);
            cgpencol(0,0,0) %white letters
            cgtext('Click anywhere on the line and press ENTER to confirm',0,2.2*ScrHgh/9-15);
            cgtext('Not familiar                                                      Extremely',0,-1 * ScrHgh/9 - 6);
            cgtext('At all                                                              Familiar',0,-1.5 * ScrHgh/9 - 6);
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
            cgpencol(0,0,1) %red letters
            cgtext('How familiar is this odor?',0, 4 * ScrHgh / 9 - 15);
            cgpencol(0,0,0) %white letters
            cgtext('Click anywhere on the line and press ENTER to confirm',0,2.2*ScrHgh/9-15);
            cgtext('Not familiar                                                      Extremely',0,-1 * ScrHgh/9 - 6);
            cgtext('At all                                                              Familiar',0,-1.5 * ScrHgh/9 - 6);
            %Draw the cursor
            cgalign('l','t')
            cgdrawsprite(20, x2+2.5,y2-2)
            cgalign('c','c')

            cgpenwid(3);
            cgdraw (-250,0,250,0);
            cgpencol(1,0,0)
            cgpenwid(4);
            cgdraw (x2,y2-10,x2,y2+10);
            cgflip(1,1,1)
            pause(1.5)

            familiarityindex = (x2+250)/500*100;
            bprevious = 0;
            c = 0;
        end

    end

    %%%%%%%% Pungency rating starts here

    cgkeymap;
    cgmouse;
    bprevious=0;
    k_previous(28) = 0;
    c=0;
    pungencyindex = 999;

    while ~k_previous(28)
        [k_current, k_previous] = cgkeymap ;
        [x2,y2,bs,bprevious]=cgmouse;

        if ~bprevious && c==0
            cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])
            cgfont('Arial',25)
            cgpencol(0,0,1) %red letters
            cgtext('How pungent is this odor?',0, 4 * ScrHgh / 9 - 15);
            cgpencol(0,0,0) %white letters
            cgtext('Click anywhere on the line and press ENTER to confirm',0,2.2*ScrHgh/9-15);
            cgtext('Not pungent                                               Extremely',0,-1 * ScrHgh/9 - 6);
            cgtext('At all                                                              Pungent',0,-1.5 * ScrHgh/9 - 6);
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
            cgpencol(0,0,1) %red letters
            cgtext('How pungent is this odor?',0, 4 * ScrHgh / 9 - 15);
            cgpencol(0,0,0) %white letters
            cgtext('Click anywhere on the line and press ENTER to confirm',0,2.2*ScrHgh/9-15);
            cgtext('Not pungent                                               Extremely',0,-1 * ScrHgh/9 - 6);
            cgtext('At all                                                              Pungent',0,-1.5 * ScrHgh/9 - 6);
            %Draw the cursor
            cgalign('l','t')
            cgdrawsprite(20, x2+2.5,y2-2)
            cgalign('c','c')

            cgpenwid(3);
            cgdraw (-250,0,250,0);
            cgpencol(1,0,0)
            cgpenwid(4);
            cgdraw (x2,y2-10,x2,y2+10);
            cgflip(1,1,1)
            pause(1.5)

            pungencyindex = (x2+250)/500*100;
            bprevious = 0;
            c = 0;
        end

    end

    OdorRatings = [OdorRatings; odorid visindex intensityindex familiarityindex pungencyindex];

    cgmouse;
    cgkeymap;%clear keymap

    %%%%%%%%%%%%%%%%% Pic Rating ends here

end% of each trial

%Save variables/
odor_sorted = sortrows(OdorRatings,1);%changed this number to 1- 1st column sorted

% wait 5 sec. after last trial w/black screen
cgrect(0, 0, ScrWid, ScrHgh, [0 0 0]) ;
cgflip
startwait = cogstd('sGetTime', -1) * 1000 ;
while ((cogstd('sGetTime', -1) * 1000) < startwait + 1000) end ; %#ok<SEPEX>

%Display "all done" message
cgrect(0, 0, ScrWid, ScrHgh, [0 0 0]) ;
cgpencol(1,1,1) ;
cgtext('You are finished with this task!',0,ScrHgh / 6 - 15);
cgflip
startwait = cogstd('sGetTime', -1) * 1000 ;
while ((cogstd('sGetTime', -1) * 1000) < (startwait + 1000)) end %#ok<SEPEX>

%Save data in mat_files folder, then come back to run folder
cd C:\OCB\Data;
eval(['save OCB_pre_rating_olf_sub' num2str(sub) '_' initials '_3times;']);
cd C:\OCB;


pause off
%%%log_finish ;
%%%dio_finish ;
cgshut
