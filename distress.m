%% SUDS rating

clear all;

name_id = input('Partiticpant initials ? ','s');
subnum = input('Which participant number ? ');
ratingnum= input('Which rating is this ? '); %2 for precond2, 4 for postcond2

cgloadlib
cgopen(1,0,0,1)

gsd = cggetdata('gsd') ;
gpd = cggetdata('gpd') ;

ScrWid = gsd.ScreenWidth ;
ScrHgh = gsd.ScreenHeight ;

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
pause(4);

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
distressed_preCond2 = 50 + (rating / 4);
%%%%%%end of rating

dmat = 'C:\My Experiments\Wen_Li\OCF\Data';
cd(dmat);
eval(['save OCF_distress_sub' num2str(subnum) '_' name_id '_' num2str(ratingnum) ';']);
dm = 'C:\My Experiments\Wen_Li\OCF'; %make sure to create this folder in the scanner computer
cd(dm);

pause off;
cgshut;