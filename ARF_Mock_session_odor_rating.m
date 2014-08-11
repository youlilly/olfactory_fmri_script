%Odor & picture ratings script for ARF study -- on Mock scan day
% Edited June 2014-YZ
%Flow of program:

%1. Odor ratings (including pic/odor combinations)
%a. Valence rating (-0 to 10)
%b. Arousal rating (0 to 10)
%c. Disgust emotion (0 to 10)
%d. Odor qualities:
  %i. Familiarity (-0 to 10)
  %ii. Pungency (-0 to 10)
  %iii. Intensity (-0 to 10)
clear all
%Collect basic subject info
date=input('6-digit date: ');
subjno=input('Enter subject number (1,2,3,...): ');
subname = input('Enter subject name initials: ','s');
gray = imread('Gray.bmp'); %Makes an image that is the same gray as the background (used as a placeholder so odor ratings display correctly)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Rita: Please update file names between ''
% Odor ratings (including pic/odor combinations)
odorlist = randperm(6); %Scrambles odor order
odorqualityseq = []; %Keeps track of the order in which odor-quality ratings were done
odorvalues = zeros(6,6); %1 row for each odor.  Col1=valence, col2=arousal, col3=disgusting, col4=familiarity, col5=pungency, col6=intensity
for k = 1:6 %For each of the 6 odors
    odorid = odorlist(k);
    qualitylist = randperm(3); %Scrambles odor quality order
    odorqualityseq = [odorqualityseq; odorid qualitylist]; %#ok<AGROW> %Adds odor quality sequence to matrix of them
    %a. Valence rating (0 to 10)
    close; figure(2) %Opens up a new Matlab figure window
    subplot(3,1,1:2); %Tells where to display picture
    imshow(gray);%Displays "invisible" gray picture (keeps placement of other objects consistent)
    bottlenum = strcat('Please smell bottle No. ',num2str(odorlist(k)),'');
    title(bottlenum, 'FontSize', 18) %Displays title
    subplot(3,1,3);%subplot allows for both scale and pic to be presented simultaneously. 1st 2 = "make 2 plots", 1 = "with 1 column", 2nd 2 = "and 2 rows"
    x=linspace(-10,10,100); % generates 100 points between -10 and 10
    y=0*x+1; % draws the blue ticker line horizontally
    plot(x,y,'LineWidth',2,'Color','k') % plots the blue ticker line
    whitebg('w') % sets the axes background color to white
    axis([-12 12 -3 3]); axis off % AXIS([XMIN XMAX YMIN YMAX]) sets scaling for the x- and y-axes on the current plot, then makes them invisible
    set(2,'Units', 'centimeters') % Set units for this figure to centimeters
    set(2,'Position',[3 2 24.5 15])	% 20-cm length line % 28 cm = 1058.267716535 pixel
    %Label endpoints of ratings scale
    text(-13.5,1.6,'Extremely','FontSize', 16, 'Color', 'k')
    text(-13.5,0.46,'Pleasant','FontSize', 16, 'Color', 'k')
    text(-1.3,1.6,'Neutral','FontSize', 16, 'Color', 'k')
    text(10.3,1.6,'Extremely','FontSize', 16, 'Color', 'k')
    text(10.3,0.46,'Unpleasant','FontSize', 16, 'Color', 'k')
    hold on % Lets you plot more stuff in this same window
    %Plot midpoint vert line
    yy=linspace(-0.2,0.2,100)+1;
    xx=0*yy;
    plot(xx,yy,'LineWidth',2,'Color','k')
    hslid=uicontrol(2, 'style', 'slider', 'position', [164 100 633 20],  'min', -10, 'max', 10, 'sliderstep', [0.01 0.015]); %Displays slider bar from -10 to 10
    hok=uicontrol(2, 'style', 'pushbutton', 'string', 'Click HERE when done', 'position', [382 40 200 40], 'enable', 'inactive', 'buttondownfcn', 'delete (hok)'); %Displays "press here when done" clicky button
    waitfor(hok) %Wait until user clicks "done" button
    odorvalues(k,1) = get(hslid, 'value'); %Assign rating to column 1 in preallocated results matrix
    set(hslid, 'value', 0) %Reset slider bar to 0
    
    %b. Arousal rating
    close; figure(2) %Opens up a new Matlab figure window
    subplot(3,1,1:2); %Tells where to display picture
    imshow(gray); %Displays "invisible" gray picture (keeps placement of other objects consistent)
    title('How pleasant is this odor', 'FontSize', 18) %Displays title
    subplot(3,1,3);%subplot allows for both scale and pic to be presented simultaneously. 1st 2 = "make 2 plots", 1 = "with 1 column", 2nd 2 = "and 2 rows"
    x=linspace(-10,10,100); % generates 100 points between -10 and 10
    y=0*x+1; % draws the blue ticker line horizontally
    plot(x,y,'LineWidth',2,'Color','k') % plots the blue ticker line
    whitebg('w') % sets the axes background color to white
    axis([-12 12 -3 3]); axis off % AXIS([XMIN XMAX YMIN YMAX]) sets scaling for the x- and y-axes on the current plot, then makes them invisible
    set(2,'Units', 'centimeters') % Set units for this figure to centimeters
    set(2,'Position',[3 2 24.5 15])	% 20-cm length line % 28 cm = 1058.267716535 pixel
    %Label endpoints of ratings scale
    text(-13.5,1.6,'Not at all','FontSize', 16, 'Color', 'k')
    text(-13.5,0.46,'Arousing','FontSize', 16, 'Color', 'k')
    text(-1.7,1.6,'Moderately','FontSize', 16, 'Color', 'k')
    text(-1.3,0.46,'Arousing','FontSize', 16, 'Color', 'k')
    text(10.3,1.6,'Extremely','FontSize', 16, 'Color', 'k')
    text(10.3,0.46,'Arousing','FontSize', 16, 'Color', 'k')
    hold on % Lets you plot more stuff in this same window
    %Plot midpoint vert line
    yy=linspace(-0.2,0.2,100)+1;
    xx=0*yy;
    plot(xx,yy,'LineWidth',2,'Color','k')
    hslid=uicontrol(2, 'style', 'slider', 'position', [164 100 633 20],  'min', -10, 'max', 10, 'sliderstep', [0.01 0.015]); %Displays slider bar from -10 to 10
    hok=uicontrol(2, 'style', 'pushbutton', 'string', 'Click HERE when done', 'position', [382 40 200 40], 'enable', 'inactive', 'buttondownfcn', 'delete (hok)'); %Displays "press here when done" clicky button
    waitfor(hok) %Wait until user clicks "done" button
    odorvalues(k,2) = get(hslid, 'value'); %Assign rating to column 1 in preallocated results matrix
    set(hslid, 'value', 0) %Reset slider bar to 0
    
    %c. Affective rating (0 to 10)
    close; figure(2) %Opens up a new Matlab figure window
    subplot(3,1,1:2); %Tells where to display picture
    imshow(gray); %Displays "invisible" gray picture (keeps placement of other objects consistent)
    title('How disgusting is this odor', 'FontSize', 18) %Displays title
    subplot(3,1,3);%subplot allows for both scale and pic to be presented simultaneously. 1st 2 = "make 2 plots", 1 = "with 1 column", 2nd 2 = "and 2 rows"
    x=linspace(-10,10,100); % generates 100 points between -10 and 10
    y=0*x+1; % draws the blue ticker line horizontally
    plot(x,y,'LineWidth',2,'Color','k') % plots the blue ticker line
    whitebg('w') % sets the axes background color to white
    axis([-12 12 -3 3]); axis off % AXIS([XMIN XMAX YMIN YMAX]) sets scaling for the x- and y-axes on the current plot, then makes them invisible
    set(2,'Units', 'centimeters') % Set units for this figure to centimeters
    set(2,'Position',[3 2 24.5 15])	% 20-cm length line % 28 cm = 1058.267716535 pixel
    %Label endpoints of ratings scale
    text(-13.5,1.6,'Not at all','FontSize', 16, 'Color', 'k')
    text(-13.5,0.46,'Disgusting','FontSize', 16, 'Color', 'k')
    text(-1.7,1.6,'Moderately','FontSize', 16, 'Color', 'k')
    text(-1.5,0.46,'Disgusting','FontSize', 16, 'Color', 'k')
    text(10.3,1.6,'Extremely','FontSize', 16, 'Color', 'k')
    text(10.3,0.46,'Disgusting','FontSize', 16, 'Color', 'k')
    hold on % Lets you plot more stuff in this same window
    %Plot midpoint vert line
    yy=linspace(-0.2,0.2,100)+1;
    xx=0*yy;
    plot(xx,yy,'LineWidth',2,'Color','k')
    hslid=uicontrol(2, 'style', 'slider', 'position', [164 100 633 20],  'min', 0, 'max', 10, 'sliderstep', [0.01 0.015]); %Displays slider bar from -10 to 10
    hok=uicontrol(2, 'style', 'pushbutton', 'string', 'Click HERE when done', 'position', [382 40 200 40], 'enable', 'inactive', 'buttondownfcn', 'delete (hok)'); %Displays "press here when done" clicky button
    waitfor(hok) %Wait until user clicks "done" button
    odorvalues(k,3) = get(hslid, 'value'); %Assign rating to column 1 in preallocated results matrix
    set(hslid, 'value', 5) %Reset slider bar to 0
    
    %*d. Odor qualities:
    %i. Familiarity (-10 to 10)
    %ii. Pungency (-10 to 10)
    %iii. Intensity (-10 to 10)
    for n = 1:3 %For each of the 3 odor qualities
        switch qualitylist(n)
            case(1) %2di. Familiarity (-10 to 10)
                close; figure(2) %Opens up a new Matlab figure window
                subplot(3,1,1:2); %Tells where to display picture
                imshow(gray); %Displays "invisible" gray picture (keeps placement of other objects consistent)
                title('How familiar is this odor', 'FontSize', 18) %Displays title
                subplot(3,1,3);%subplot allows for both scale and pic to be presented simultaneously. 1st 2 = "make 2 plots", 1 = "with 1 column", 2nd 2 = "and 2 rows"
                x=linspace(-10,10,100); % generates 100 points between -10 and 10
                y=0*x+1; % draws the blue ticker line horizontally
                plot(x,y,'LineWidth',2,'Color','k') % plots the blue ticker line
                whitebg('w') % sets the axes background color to white
                axis([-12 12 -3 3]); axis off % AXIS([XMIN XMAX YMIN YMAX]) sets scaling for the x- and y-axes on the current plot, then makes them invisible
                set(2,'Units', 'centimeters') % Set units for this figure to centimeters
                set(2,'Position',[3 2 24.5 15])	% 20-cm length line % 28 cm = 1058.267716535 pixel
                %Label endpoints of ratings scale
                text(-13.5,1.6,'Extremely','FontSize', 16, 'Color', 'k')
                text(-13.5,0.46,'Unfamiliar','FontSize', 16, 'Color', 'k')
                text(-1.9,1.6,'Moderately','FontSize', 16, 'Color', 'k')
                text(-1.5,0.46,'Familiar','FontSize', 16, 'Color', 'k')
                text(10.3,1.6,'Extremely','FontSize', 16, 'Color', 'k')
                text(10.3,0.46,'Familiar','FontSize', 16, 'Color', 'k')
                hold on % Lets you plot more stuff in this same window
                %Plot midpoint vert line
                yy=linspace(-0.2,0.2,100)+1;
                xx=0*yy;
                plot(xx,yy,'LineWidth',2,'Color','k')
                hslid=uicontrol(2, 'style', 'slider', 'position', [164 100 633 20],  'min', -10, 'max', 10, 'sliderstep', [0.01 0.015]); %Displays slider bar from -10 to 10
                hok=uicontrol(2, 'style', 'pushbutton', 'string', 'Click HERE when done', 'position', [382 40 200 40], 'enable', 'inactive', 'buttondownfcn', 'delete (hok)'); %Displays "press here when done" clicky button
                waitfor(hok) %Wait until user clicks "done" button
                odorvalues(k,4) = get(hslid, 'value'); %Assign rating to column 1 in preallocated results matrix
                set(hslid, 'value', 0) %Reset slider bar to 0
                
            case(2) %2dii. Pungency (-10 to 10)
                close; figure(2) %Opens up a new Matlab figure window
                subplot(3,1,1:2); %Tells where to display picture
                imshow(gray); %Displays "invisible" gray picture (keeps placement of other objects consistent)
                title('How pungent is this odor', 'FontSize', 18) %Displays title
                subplot(3,1,3);%subplot allows for both scale and pic to be presented simultaneously. 1st 2 = "make 2 plots", 1 = "with 1 column", 2nd 2 = "and 2 rows"
                x=linspace(-10,10,100); % generates 100 points between -10 and 10
                y=0*x+1; % draws the blue ticker line horizontally
                plot(x,y,'LineWidth',2,'Color','k') % plots the blue ticker line
                whitebg('w') % sets the axes background color to white
                axis([-12 12 -3 3]); axis off % AXIS([XMIN XMAX YMIN YMAX]) sets scaling for the x- and y-axes on the current plot, then makes them invisible
                set(2,'Units', 'centimeters') % Set units for this figure to centimeters
                set(2,'Position',[3 2 24.5 15])	% 20-cm length line % 28 cm = 1058.267716535 pixel
                %Label endpoints of ratings scale
                text(-13.5,1.6,'Not at all','FontSize', 16, 'Color', 'k')
                text(-13.5,0.46,'Pungent','FontSize', 16, 'Color', 'k')
                text(-1.9,1.6,'Moderately','FontSize', 16, 'Color', 'k')
                text(-1.5,0.46,'Pungent','FontSize', 16, 'Color', 'k')
                text(10.3,1.6,'Extremely','FontSize', 16, 'Color', 'k')
                text(10.3,0.46,'Pungent','FontSize', 16, 'Color', 'k')
                hold on % Lets you plot more stuff in this same window
                %Plot midpoint vert line
                yy=linspace(-0.2,0.2,100)+1;
                xx=0*yy;
                plot(xx,yy,'LineWidth',2,'Color','k')
                hslid=uicontrol(2, 'style', 'slider', 'position', [164 100 633 20],  'min', -10, 'max', 10, 'sliderstep', [0.01 0.015]); %Displays slider bar from -10 to 10
                hok=uicontrol(2, 'style', 'pushbutton', 'string', 'Click HERE when done', 'position', [382 40 200 40], 'enable', 'inactive', 'buttondownfcn', 'delete (hok)'); %Displays "press here when done" clicky button
                waitfor(hok) %Wait until user clicks "done" button
                odorvalues(k,5) = get(hslid, 'value'); %Assign rating to column 1 in preallocated results matrix
                set(hslid, 'value', 0) %Reset slider bar to 0
                
            case(3) %2diii. Intensity (-10 to 10)
                close; figure(2) %Opens up a new Matlab figure window
                subplot(3,1,1:2); %Tells where to display picture
                imshow(gray); %Displays "invisible" gray picture (keeps placement of other objects consistent)
                title('How intense is this odor', 'FontSize', 18) %Displays title
                subplot(3,1,3);%subplot allows for both scale and pic to be presented simultaneously. 1st 2 = "make 2 plots", 1 = "with 1 column", 2nd 2 = "and 2 rows"
                x=linspace(-10,10,100); % generates 100 points between -10 and 10
                y=0*x+1; % draws the blue ticker line horizontally
                plot(x,y,'LineWidth',2,'Color','k') % plots the blue ticker line
                whitebg('w') % sets the axes background color to white
                axis([-12 12 -3 3]); axis off % AXIS([XMIN XMAX YMIN YMAX]) sets scaling for the x- and y-axes on the current plot, then makes them invisible
                set(2,'Units', 'centimeters') % Set units for this figure to centimeters
                set(2,'Position',[3 2 24.5 15])	% 20-cm length line % 28 cm = 1058.267716535 pixel
                %Label endpoints of ratings scale
                text(-13.5,1.6,'Extremely','FontSize', 16, 'Color', 'k')
                text(-13.5,0.46,'Weak','FontSize', 16, 'Color', 'k')
                text(-1.9,1.6,'Moderately','FontSize', 16, 'Color', 'k')
                text(-1.5,0.46,'Strong','FontSize', 16, 'Color', 'k')
                text(10.3,1.6,'Extremely','FontSize', 16, 'Color', 'k')
                text(10.3,0.46,'Strong','FontSize', 16, 'Color', 'k')
                hold on % Lets you plot more stuff in this same window
                %Plot midpoint vert line
                yy=linspace(-0.2,0.2,100)+1;
                xx=0*yy;
                plot(xx,yy,'LineWidth',2,'Color','k')
                hslid=uicontrol(2, 'style', 'slider', 'position', [164 100 633 20],  'min', -10, 'max', 10, 'sliderstep', [0.01 0.015]); %Displays slider bar from -10 to 10
                hok=uicontrol(2, 'style', 'pushbutton', 'string', 'Click HERE when done', 'position', [382 40 200 40], 'enable', 'inactive', 'buttondownfcn', 'delete (hok)'); %Displays "press here when done" clicky button
                waitfor(hok) %Wait until user clicks "done" button
                odorvalues(k,6) = get(hslid, 'value'); %Assign rating to column 1 in preallocated results matrix
                set(hslid, 'value', 0) %Reset slider bar to 0
        end %Of switch loop for odor quality ratings
    end %Of odor quality ratings
    close;
end %Of each odor's ratings

%Build save structure
results.odors.odornumbers = odorlist'; %List of odor #s in order presented
results.odors.odorratings = odorvalues; %Ratings for each odor
results.odors.odorqseq = odorqualityseq; %Odor #s, plus odor quality order presented for each odor
%results.sweats.sweatqseq = qualityseq; %Odor #s, plus sweat quality order presented for each sweat

eval(['save ARF_sub' num2str(subjno) '_' num2str(subname) '_Mock_Scan_Odor_Rating.mat results']);
