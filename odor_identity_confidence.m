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
%date=input('6-digit date: ');
%subjno=input('Enter subject number (1,2,3,...): ');
subname = input('Enter subject name initials: ','s');
gray = imread('Gray.bmp'); %Makes an image that is the same gray as the background (used as a placeholder so odor ratings display correctly)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Rita: Please update file names between ''
% Odor ratings (including pic/odor combinations)
odorlist = [];

% for i = 1:4%6
% once = randperm(5);
% odorlist = [odorlist once]; %Scrambles odor order
% end 
%odorlist = [2,3,4,1,5,3,4,5,2,1,4,2,3,1,5,2,3,1,5,4;];%odor list for the first 3 subjects in pilot3
%odorlist = [4,3,2,1,5,4,5,2,3,1,2,4,3,1,5,3,2,5,4,1;];%odor list for sub4
%odorlist = [2,3,4,1,5,2,5,4,3,1,3,4,2,1,5,1,2,5,4,3;];%odor list for sub5
odorlist = [3,1,4,5,2,3,5,2,4,1,2,4,3,1,5,2,1,3,5,4;];%odor list for sub6


odorqualityseq = []; %Keeps track of the order in which odor-quality ratings were done
odorvalues = zeros(length(odorlist),1); %1 row for each odor.  
for k = 1:length(odorlist) %For each of the 6 odors
    odorid = odorlist(k);
    
    %a. Valence rating (0 to 10)
    close; figure(2) %Opens up a new Matlab figure window
    subplot(3,1,1:2); %Tells where to display picture
    imshow(gray);%Displays "invisible" gray picture (keeps placement of other objects consistent)
    bottlenum = strcat('Please smell bottle No. '); %',num2str(odorlist(k)),'
    title(bottlenum, 'FontSize', 18) %Displays title
    subplot(3,1,3);%subplot allows for both scale and pic to be presented simultaneously. 1st 2 = "make 2 plots", 1 = "with 1 column", 2nd 2 = "and 2 rows"
    x=linspace(-10,10,100); % generates 100 points between -10 and 10
    
    y=0*x+1; % draws the blue ticker line horizontally
    plot(x,y,'LineWidth',2,'Color','k') % plots the blue ticker line
    whitebg('w') % sets the axes background color to white
    
    axis([-12 12 -3 3]); axis off % AXIS([XMIN XMAX YMIN YMAX]) sets scaling for the x- and y-axes on the current plot, then makes them invisible
    set(2,'Units', 'centimeters') % Set units for this figure to centimeters
    set(2,'Position',[3 2 26 15])	% 20-cm length line % 28 cm = 1058.267716535 pixel %% third number: length of line; 4th number: distance btw line and sliding bar
    %Label endpoints of ratings scale
    text(-12.5,1.6,'Odor A','FontSize', 16, 'Color', 'k')
    text(10.3,1.6,'Odor B','FontSize', 16, 'Color', 'k')
    hold on % Lets you plot more stuff in this same window
    %Plot midpoint vert line
    yy=linspace(-0.2,0.2,100)+1;
    xx=0*yy;
    plot(xx,yy,'LineWidth',2,'Color','k')
    hslid=uicontrol(2, 'style', 'slider', 'position', [164 100 633 15],  'min', -10, 'max', 10, 'sliderstep', [0.01 0.015]); %Displays slider bar from -10 to 10
    hok=uicontrol(2, 'style', 'pushbutton', 'string', 'Click HERE when done', 'position', [382 40 200 40], 'enable', 'inactive', 'buttondownfcn', 'delete (hok)'); %Displays "press here when done" clicky button
    waitfor(hok) %Wait until user clicks "done" button
    odorvalues(k,1) = get(hslid, 'value'); %Assign rating to column 1 in preallocated results matrix
    set(hslid, 'value', 0) %Reset slider bar to 0
    
end %Of each odor's ratings

combined = [odorlist' odorvalues];
combined_sorted = sortrows(combined, 1);

%Build save structure
results.odors.odornumbers = odorlist'; %List of odor #s in order presented
results.odors.odorratings = odorvalues; %Ratings for each odor
results.odors.combined = combined_sorted;
%results.sweats.sweatqseq = qualityseq; %Odor #s, plus sweat quality order presented for each sweat

eval(['save Odor_PCblend_sub' subname '_Pilot3.mat results']);

%% compute individual's ratings
namelist = {'WL';'LN';'VP';'YZ';'KC'};
allsubrat = [];

for i = 4%1:5
subname = namelist{i,:};
eval(['load Odor_PCblend_sub' subname '_Pilot3.mat results']);
ratings = results.odors.combined(:,2);
rat1 = mean(ratings(1:4,1));
rat2 = mean(ratings(5:8,1));
rat3 = mean(ratings(9:12,1));
rat4 = mean(ratings(13:16,1));
rat5 = mean(ratings(17:20,1));

allsubrat = [allsubrat; rat1 rat2 rat3 rat4 rat5];
end

%% play with individual odor orders
%odorlist = [2,3,4,1,5,3,4,5,2,1,4,2,3,1,5,2,3,1,5,4;];%odor list for the first 3 subjects in pilot3
%odorlist = [4,3,2,1,5,4,5,2,3,1,2,4,3,1,5,3,2,5,4,1;];%odor list for sub4
%odorlist = [2,3,4,1,5,2,5,4,3,1,3,4,2,1,5,1,2,5,4,3;];%odor list for sub5
%odorlist = [3,1,4,5,2,3,5,2,4,1,2,4,3,1,5,2,1,3,5,4;];%odor list for sub6
odorlist = [4,3,5,2,1,3,2,4,1,5,4,5,3,1,2,5,1,3,4,2];

odorbf1 = [];
odorbf2 = [];
odorbf3 = [];
odorbf4 = [];
odorbf5 = [];

odordiff = odorlist(1:end-1) - odorlist(2:end);

for i = 1:15
    switch odorlist(i+1)
        case (1)
            odorbf1 = [odorbf1 odordiff(i)];
        case (2)
            odorbf2 = [odorbf2 odordiff(i)];
        case (3)
            odorbf3 = [odorbf3 odordiff(i)];
        case (4)
            odorbf4 = [odorbf4 odordiff(i)];
        case (5)
            odorbf5 = [odorbf5 odordiff(i)];            
    end
end

odorbf1ave = mean(odorbf1);
odorbf2ave = mean(odorbf2);
odorbf3ave = mean(odorbf3);
odorbf4ave = mean(odorbf4);
odorbf5ave = mean(odorbf5);

line =[odorbf1ave-2.5 odorbf2ave-1.25 odorbf3ave odorbf4ave+1.25 odorbf5ave+2.5];