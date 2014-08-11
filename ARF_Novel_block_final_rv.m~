%MRIOdorDetect.m
%This program tests the MRI olfactometer.
%Original Created by JL 7/15/09, based on PSABlock1Even.m and
%Perceptual_Disc_Beh_WLi_new.m

%6/11/2014 fMRI version- block 1
clear all

dm = 'C:\My Experiments\Wen_Li\Sweat\m_scripts';
cd (dm);
%
log_file_name = input('Log file name ?','s');
log_init(log_file_name) ;
name_id = input('Partiticpant initials ? ','s');
gender=input('Participant gender ?', 's');
age=input('Participant age ?');
eth=input('Participant ethnicity?-African, Caucasian, Asian, Hispanic, others', 's');
subnum = input('Which participant number ? ');
block = input('Which block?');

subinfo = sprintf('name_id = %s, sub no. = %d, ethnicity=%s, age = %d, gender=%s', name_id,subnum, eth, age, gender);

%****Removed cell break here for behavioral****
%% Create matrix of randomized odor ID information.
%stimordA:
% col 1= odorid (1-13);(1~3=Sweat N; 4~6=Sweat D; 7~9=Odor N;10~12=Ordor D; 13=null;)
% col 2= picid (14-26);(14~16=Face N; 17~19=Face D; 20~22=Scene N; 23~25=Scene D; 26=null;)
% col 3= odor valence(1-5)? (1=sweat N; 2=sweat D;3=ordor N;4=ordor D; 5=no)
% col 4 = pic valence?(1-5)? (1=Face N; 2=Face D;3=Scene N;4=Scene D; 5=no)
% col 5 = odor presence? (0=N/pic trial; 1=Y/ordor trial);
% col 6 = pic pres? (0=Y/ordor trial; 1=N/pic trial);
% col 7 = greeble ID; (99=Null;)
% col 8 = greeble size(0-3): (1=2; 2=15; 3=18; 4=22)
% col 9 = condition(1-9)
% col 10 = trialid(1-108)

%Updated Stimord A&B - June/17th
stimordA=[
    11	26	4	5	1	0	101	4	4	1
    5	26	2	5	1	0	112	4	2	2
    13	21	5	3	0	1	211	4	7	3
    13	17	5	2	0	1	206	4	6	4
    13	20	5	3	0	1	209	4	7	5
    7	26	3	5	1	0	109	4	3	6
    13	22	5	3	0	1	212	4	7	7
    13	24	5	4	0	1	210	4	8	8
    12	26	4	5	1	0	108	4	4	9
    7	26	3	5	1	0	111	4	3	10
    13	26	5	5	0	0	308	4	9	11
    13	26	5	5	0	0	311	4	9	12
    6	26	2	5	1	0	109	4	2	13
    9	26	3	5	1	0	104	4	3	14
    12	26	4	5	1	0	102	4	4	15
    13	15	5	1	0	1	206	4	5	16
    13	21	5	3	0	1	205	4	7	17
    13	26	5	5	0	0	302	4	9	18
    12	26	4	5	1	0	111	4	4	19
    5	26	2	5	1	0	105	4	2	20
    13	15	5	1	0	1	205	4	5	21
    7	26	3	5	1	0	103	4	3	22
    1	26	1	5	1	0	104	4	1	23
    13	16	5	1	0	1	210	4	5	24
    13	19	5	2	0	1	211	4	6	25
    10	26	4	5	1	0	106	4	4	26
    13	23	5	4	0	1	201	4	8	27
    8	26	3	5	1	0	106	4	3	28
    13	18	5	2	0	1	206	4	6	29
    13	21	5	3	0	1	209	4	7	30
    13	26	5	5	0	0	304	4	9	31
    13	14	5	1	0	1	203	4	5	32
    10	26	4	5	1	0	107	4	4	33
    13	17	5	2	0	1	203	4	6	34
    13	24	5	4	0	1	204	4	8	35
    10	26	4	5	1	0	108	4	4	36
    13	18	5	2	0	1	205	4	6	37
    13	18	5	2	0	1	210	4	6	38
    13	15	5	1	0	1	204	4	5	39
    3	26	1	5	1	0	102	4	1	40
    6	26	2	5	1	0	101	4	2	41
    13	21	5	3	0	1	208	4	7	42
    8	26	3	5	1	0	112	4	3	43
    13	18	5	2	0	1	202	4	6	44
    13	20	5	3	0	1	203	4	7	45
    2	26	1	5	1	0	110	4	1	46
    9	26	3	5	1	0	104	4	3	47
    13	26	5	5	0	0	307	4	9	48
    1	26	1	5	1	0	108	4	1	49
    13	23	5	4	0	1	209	4	8	50
    11	26	4	5	1	0	105	4	4	51
    13	14	5	1	0	1	207	4	5	52
    2	26	1	5	1	0	111	4	1	53
    3	26	1	5	1	0	106	4	1	54
    13	26	5	5	0	0	306	4	9	55
    13	26	5	5	0	0	310	4	9	56
    8	26	3	5	1	0	107	4	3	57
    4	26	2	5	1	0	111	4	2	58
    13	14	5	1	0	1	212	4	5	59
    8	26	3	5	1	0	102	4	3	60
    11	26	4	5	1	0	106	4	4	61
    13	22	5	3	0	1	208	4	7	62
    13	17	5	2	0	1	204	4	6	63
    4	26	2	5	1	0	110	4	2	64
    13	23	5	4	0	1	212	4	8	65
    13	19	5	2	0	1	207	4	6	66
    7	26	3	5	1	0	107	4	3	67
    6	26	2	5	1	0	103	4	2	68
    10	26	4	5	1	0	107	4	4	69
    13	25	5	4	0	1	212	4	8	70
    13	15	5	1	0	1	205	4	5	71
    1	26	1	5	1	0	104	4	1	72
    13	26	5	5	0	0	301	4	9	73
    13	24	5	4	0	1	202	4	8	74
    1	26	1	5	1	0	101	4	1	75
    13	14	5	1	0	1	208	4	5	76
    13	25	5	4	0	1	202	4	8	77
    13	26	5	5	0	0	312	4	9	78
    13	19	5	2	0	1	211	4	6	79
    13	16	5	1	0	1	204	4	5	80
    9	26	3	5	1	0	103	4	3	81
    13	26	5	5	0	0	309	4	9	82
    2	26	1	5	1	0	108	4	1	83
    13	20	5	3	0	1	210	4	7	84
    4	26	2	5	1	0	109	4	2	85
    13	23	5	4	0	1	208	4	8	86
    3	26	1	5	1	0	105	4	1	87
    13	25	5	4	0	1	207	4	8	88
    5	26	2	5	1	0	105	4	2	89
    12	26	4	5	1	0	102	4	4	90
    9	26	3	5	1	0	110	4	3	91
    13	20	5	3	0	1	209	4	7	92
    11	26	4	5	1	0	112	4	4	93
    13	17	5	2	0	1	206	4	6	94
    3	26	1	5	1	0	103	4	1	95
    13	19	5	2	0	1	211	4	6	96
    13	16	5	1	0	1	201	4	5	97
    4	26	2	5	1	0	109	4	2	98
    13	26	5	5	0	0	305	4	9	99
    2	26	1	5	1	0	112	4	1	100
    5	26	2	5	1	0	101	4	2	101
    13	22	5	3	0	1	203	4	7	102
    6	26	2	5	1	0	110	4	2	103
    13	24	5	4	0	1	207	4	8	104
    13	22	5	3	0	1	201	4	7	105
    13	25	5	4	0	1	202	4	8	106
    13	16	5	1	0	1	201	4	5	107
    13	26	5	5	0	0	303	4	9	108
    ];

stimordB = [
    11	26	4	5	1	0	207	4	4	1
    5	26	2	5	1	0	203	4	2	2
    13	21	5	3	0	1	108	4	7	3
    13	17	5	2	0	1	101	4	6	4
    13	20	5	3	0	1	110	4	7	5
    7	26	3	5	1	0	208	4	3	6
    13	22	5	3	0	1	103	4	7	7
    13	24	5	4	0	1	104	4	8	8
    12	26	4	5	1	0	205	4	4	9
    7	26	3	5	1	0	204	4	3	10
    13	26	5	5	0	0	312	4	9	11
    13	26	5	5	0	0	306	4	9	12
    6	26	2	5	1	0	205	4	2	13
    9	26	3	5	1	0	206	4	3	14
    12	26	4	5	1	0	201	4	4	15
    13	15	5	1	0	1	104	4	5	16
    13	21	5	3	0	1	109	4	7	17
    13	26	5	5	0	0	303	4	9	18
    12	26	4	5	1	0	203	4	4	19
    5	26	2	5	1	0	204	4	2	20
    13	15	5	1	0	1	101	4	5	21
    7	26	3	5	1	0	206	4	3	22
    1	26	1	5	1	0	212	4	1	23
    13	16	5	1	0	1	106	4	5	24
    13	19	5	2	0	1	111	4	6	25
    10	26	4	5	1	0	206	4	4	26
    13	23	5	4	0	1	108	4	8	27
    8	26	3	5	1	0	210	4	3	28
    13	18	5	2	0	1	102	4	6	29
    13	21	5	3	0	1	105	4	7	30
    13	26	5	5	0	0	304	4	9	31
    13	14	5	1	0	1	109	4	5	32
    10	26	4	5	1	0	211	4	4	33
    13	17	5	2	0	1	110	4	6	34
    13	24	5	4	0	1	105	4	8	35
    10	26	4	5	1	0	210	4	4	36
    13	18	5	2	0	1	105	4	6	37
    13	18	5	2	0	1	103	4	6	38
    13	15	5	1	0	1	112	4	5	39
    3	26	1	5	1	0	201	4	1	40
    6	26	2	5	1	0	206	4	2	41
    13	21	5	3	0	1	101	4	7	42
    8	26	3	5	1	0	211	4	3	43
    13	18	5	2	0	1	109	4	6	44
    13	20	5	3	0	1	111	4	7	45
    2	26	1	5	1	0	210	4	1	46
    9	26	3	5	1	0	209	4	3	47
    13	26	5	5	0	0	302	4	9	48
    1	26	1	5	1	0	204	4	1	49
    13	23	5	4	0	1	111	4	8	50
    11	26	4	5	1	0	208	4	4	51
    13	14	5	1	0	1	110	4	5	52
    2	26	1	5	1	0	205	4	1	53
    3	26	1	5	1	0	211	4	1	54
    13	26	5	5	0	0	305	4	9	55
    13	26	5	5	0	0	301	4	9	56
    8	26	3	5	1	0	205	4	3	57
    4	26	2	5	1	0	202	4	2	58
    13	14	5	1	0	1	107	4	5	59
    8	26	3	5	1	0	203	4	3	60
    11	26	4	5	1	0	212	4	4	61
    13	22	5	3	0	1	106	4	7	62
    13	17	5	2	0	1	112	4	6	63
    4	26	2	5	1	0	207	4	2	64
    13	23	5	4	0	1	101	4	8	65
    13	19	5	2	0	1	104	4	6	66
    7	26	3	5	1	0	212	4	3	67
    6	26	2	5	1	0	102	4	2	68
    10	26	4	5	1	0	209	4	4	69
    13	25	5	4	0	1	109	4	8	70
    13	15	5	1	0	1	102	4	5	71
    1	26	1	5	1	0	203	4	1	72
    13	26	5	5	0	0	308	4	9	73
    13	24	5	4	0	1	103	4	8	74
    1	26	1	5	1	0	209	4	1	75
    13	14	5	1	0	1	103	4	5	76
    13	25	5	4	0	1	107	4	8	77
    13	26	5	5	0	0	307	4	9	78
    13	19	5	2	0	1	107	4	6	79
    13	16	5	1	0	1	108	4	5	80
    9	26	3	5	1	0	202	4	3	81
    13	26	5	5	0	0	311	4	9	82
    2	26	1	5	1	0	201	4	1	83
    13	20	5	3	0	1	104	4	7	84
    4	26	2	5	1	0	211	4	2	85
    13	23	5	4	0	1	110	4	8	86
    3	26	1	5	1	0	208	4	1	87
    13	25	5	4	0	1	106	4	8	88
    5	26	2	5	1	0	208	4	2	89
    12	26	4	5	1	0	204	4	4	90
    9	26	3	5	1	0	207	4	3	91
    13	20	5	3	0	1	107	4	7	92
    11	26	4	5	1	0	202	4	4	93
    13	17	5	2	0	1	106	4	6	94
    3	26	1	5	1	0	207	4	1	95
    13	19	5	2	0	1	108	4	6	96
    13	16	5	1	0	1	105	4	5	97
    4	26	2	5	1	0	201	4	2	98
    13	26	5	5	0	0	309	4	9	99
    2	26	1	5	1	0	202	4	1	100
    5	26	2	5	1	0	210	4	2	101
    13	22	5	3	0	1	112	4	7	102
    6	26	2	5	1	0	212	4	2	103
    13	24	5	4	0	1	112	4	8	104
    13	22	5	3	0	1	209	4	7	105
    13	25	5	4	0	1	102	4	8	106
    13	16	5	1	0	1	111	4	5	107
    13	26	5	5	0	0	310	4	9	108
    ];

if subnum == 1 || subnum == 2 || subnum == 3 || subnum == 4 || subnum == 9 || subnum == 10 || subnum == 11 || subnum == 12 % Subject list A
    stimscramb = stimordA;
elseif  subnum == 5 || subnum == 6 || subnum == 7 || subnum == 8 || subnum == 13 || subnum == 14 || subnum == 15 || subnum == 16 % Subject list B
    stimscramb = stimordB;
end
stimord=stimscramb;

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
TR = 2.35;
nslices = 48; %changed from 32 to 48 by Wen on June/17th/2014
ndummies = 6;
%% Set up olfactometer, triggers & Cogent.
%Configure equipment

usb2_config ; %Olfactometer configuration
parallel_config ;  % For reading trigger on the parallel port

% %For the parallel port
global base_state;
global parport_out;
global parport_in;
%
% % Necessary for callback function to operate properly.

% Load and configure Cogent
cgloadlib
cgopen(1,0,0,1)
log_start_timer ;
%log_header ;

gsd = cggetdata('gsd') ;
gpd = cggetdata('gpd') ;

ScrWid = gsd.ScreenWidth ;
ScrHgh = gsd.ScreenHeight ;

%Load 6 face stimuli, 6 scene pics, 1 placeholder, and 36 Greebles into Cogent.
cgloadbmp(002,'Greeble_instruction_page.bmp');
cgloadbmp(14,'F1N.bmp');
cgloadbmp(15,'F5N.bmp');
cgloadbmp(16,'F8N.bmp');
cgloadbmp(17,'F1D.bmp');
cgloadbmp(18,'F5D.bmp');
cgloadbmp(19,'F8D.bmp');
cgloadbmp(20,'S1N.bmp');
cgloadbmp(21,'S2N.bmp');
cgloadbmp(22,'S4N.bmp');
cgloadbmp(23,'S1D.bmp');
cgloadbmp(24,'S2D.bmp');
cgloadbmp(25,'S6D.bmp');
cgloadbmp(26,'NullRect.bmp'); % Empty black frame
%Load 3 sets of greebles
cgloadbmp(101,'f1111.bmp');%Affective set 1 greebles of original size
cgloadbmp(102,'f1141.bmp');
cgloadbmp(103,'f1161.bmp');
cgloadbmp(104,'f2241.bmp');
cgloadbmp(105,'f2251.bmp');
cgloadbmp(106,'f2261.bmp');
cgloadbmp(107,'m1121.bmp');
cgloadbmp(108,'m1141.bmp');
cgloadbmp(109,'m1191.bmp');
cgloadbmp(110,'m2241.bmp');
cgloadbmp(111,'m2271.bmp');
cgloadbmp(112,'m3321.bmp');
cgloadbmp(201,'f3321.bmp'); %Affective set 2 greebles of original size
cgloadbmp(202,'f3331.bmp');
cgloadbmp(203,'f3391.bmp');
cgloadbmp(204,'f4441.bmp');
cgloadbmp(205,'f4451.bmp');
cgloadbmp(206,'f4461.bmp');
cgloadbmp(207,'m3341.bmp');
cgloadbmp(208,'m3361.bmp');
cgloadbmp(209,'m4431.bmp');
cgloadbmp(210,'m4461.bmp');
cgloadbmp(211,'m4491.bmp');
cgloadbmp(212,'m5521.bmp');
cgloadbmp(301,'f5521.bmp'); %Affective set 3 greebles of original size
cgloadbmp(302,'f5531.bmp');
cgloadbmp(303,'f5551.bmp');
cgloadbmp(304,'f3341.bmp');
cgloadbmp(305,'f3351.bmp');
cgloadbmp(306,'f3361.bmp');
cgloadbmp(307,'m5551.bmp');
cgloadbmp(308,'m5561.bmp');
cgloadbmp(309,'m22101.bmp');
cgloadbmp(310,'m2261.bmp');
cgloadbmp(311,'m2281.bmp');
cgloadbmp(312,'m2291.bmp');

%Setting up variables for later use
% = 14100 ; %Each trial is 14.1 seconds long (TR=2.35 * 6 = 14.1 s)changed to allow for clear of odor

odorindex=[]; %Matrix of which odor was used in each trial--should match column 1 of stimord
odorvalindex = []; % Matrix after recoding in cogent to classify all 8 odors as 3 valences
picindex=[]; %Matrix of which face was used in each trial--should match column 2 of stimord
picvalindex=[];
greebleindex = [];
greeblevalindex = [];
greeblecondindex = [];

odoronTimes  = [];
odordurTimes = [];
odoronMRtimes = [];
piconTimes = [];
picdurTimes = [];
piconMRtimes = [];
greebleonTimes = [];
greebledurTimes = [];
greebleonMRtimes = [];

jitter1times = [];
jitter2times = [];

odoronTimes_greeval = cell(1,4);
odordurTimes_greeval = cell(1,4);
odoronMRtimes_greeval = cell(1,4);

odoronTimes_odorval  = cell(1,5);  %Matrix of odor onset times (when odor reaches participant)indexed by odor condition
odordurTimes_odorval = cell(1,5);
odoronMRtimes_odorval = cell(1,5);%***for fMRI version****

piconTimes_greeval = cell(1,4);
picdurTimes_greeval = cell(1,4);
piconMRtimes_greeval = cell(1,4);

piconTimes_picval = cell(1,5);
picdurTimes_picval = cell(1,5);
piconMRtimes_picval  = cell(1,5);

greebleonTimes_greeval = cell(1,4);
greebledurTimes_greeval = cell(1,4);
greebleonMRtimes_greeval = cell(1,4);

greebleonTimes_odorval = cell(1,5);
greebledurTimes_odorval = cell(1,5);
greebleonMRtimes_odorval = cell(1,5);%***for fMRI version****

greebleonTimes_picval = cell(1,5);
greebledurTimes_picval = cell(1,5);
greebleonMRtimes_picval = cell(1,5);%***for fMRI version****

noresp_onTimes  = []; % Above matrix for trials where no response was given
noresp_durTimes = []; % Above matrix for trials where no response was given
noresp_onMRtimes = [];

allRTs = [];
RTs_greeval = cell(1,4);
RTs_odorval = cell(1,5);
RTs_picval = cell(1,5);

allButtOns_MRtimes = [];%***for fMRI version****

GreeResp = cell(1,5);
OdorResp = cell(1,13);
PicResp = cell(1,13);
yesresp = 0;
noresp = 0;

presses = 0;%added back in for allButtOns resp 3/29

resp=[];
resp_all =[];
respval = 0;
responsevaluesall = [];

trialtime_log=[];

buttstr = '';

log_string(subinfo);
%% Present general instructions
cgrect(0, 0, ScrWid, ScrHgh, [1 1 1]) %changed background page of white
cgfont('Arial',28)
cgpencol(0,0,0)%black text

cgtext('Sniff when you see Sniff Now',0,2.65 * ScrHgh/6-15);
cgpencol(0,0,1);
cgfont('Arial',24)
cgpencol(0,0,0)%black text

cgtext('Watch the screen when you see Watch Now',0,2.05 * ScrHgh/6-15);
cgpencol(0,0,1);
cgfont('Arial',24)
cgpencol(0,0,0)%black text

cgtext('Indicate greeble VALENCE using the button box',0,1.45 * ScrHgh/6-15);
cgloadbmp(002,'Greeble_instruction_page.bmp');

cgdrawsprite(002,-25,-100);
cgflip
pause on
pause(16);

% present crosshair
cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])
cgfont('Arial',60);
cgpencol(1,0,0); %red crosshair here; meaning the scanner can now be turned on
cgtext('+',0,0);
cgflip

cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])
% picture buffer(5) is now blank (no response buttons displayed

%stime = cogstd('sGetTime', -1) * 1000;%change this TIME = 0 to typical cogent time stamp

if whichplace == 1  % i.e., scanning study with scanner pulses
    %    clearserialbytes(PC);
    
    % Wait here for the first bold rep trigger to occur.
    parallel_wait; %this function waits until the scan is started
    
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
mristarttime = cogstd('sGetTime', -1) * 1000;
mristarttimes = sprintf('MRI scanner first trigger ON time at %d ms',mristarttime);
log_string(mristarttimes);

%Starts (what?) recording at the proper time, on the seventh TR (first 6 TRs are
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

%% Run each trial with instructions, using "for" loop
%Instructions go here
for i=1:length(stimord)
    
    if whichplace == 1  % i.e., scanning study with scanner pulses
        %clearserialbytes(PC);
        
        % Wait here for the first bold rep trigger to occur.
        %         parallel_wait;
        
        % Grab the time
        trialtime = cogstd('sGetTime', -1) * 1000 ;
        
    else  % i.e., pilot study in absence of scanner pulses
        trialtime = cogstd('sGetTime', -1) * 1000 ;
        
    end
    
    if (i == 1)
        scanon_7th = trialtime;  
        starttime  = trialtime;  %this is the 1st 53 input after the 6th dummy
        parallel_acquire; %equivalent of dio_acquire here for 7th dummy
    else
    end
    
    odorid=stimord(i,1);
    picid=stimord(i,2);
    
    odorpres = stimord(i,5); % col 5 = odor presence? (0=N/pic trial; 1=Y/ordor trial);
    picpres = stimord(i,6); % col 6 = face pres? (0=Y/ordor trial; 1=N/pic trial);
        
    %odor conditions (1-12) and No odor (13)
    if odorpres == 1 %Odor present = yes
        odorval = stimord(i,3);
        if (odorid > 0) && (odorid < 4) %for odor IDs 1,2,3 (Neutral Sweat)%are three ids point to the same odor? Need to change back
            Port = 1; % Port A on olfactometer %On the olfactormeter, top row is Port B, 
            PortAid = odorid; % PortA 0-2 on olfactometer
        elseif (odorid > 3) && (odorid < 7) %for odor IDs 4,5,6 (Disgust Sweat)
            Port = 1; % Port A on olfactometer
            PortAid = odorid; % PortA 3-5 on olfactometer
        elseif (odorid > 6) && (odorid < 10) %for odor IDs 7,8,9 (Neutral Odor)
            Port = 2; % Port B olfactometer
            PortBid = odorid-6; % PortB 0-2 on olfactometer
        elseif (odorid > 9) && (odorid < 13) %for odor IDs 10,11,12 (Disgust Odor)
            Port = 2; % Port B olfactometer
            PortBid = odorid-6; % PortB 3-5 on olfactometer
        elseif odorid == 13 %For odor ID 13 (no odor)
            airid = 7; % Port A6 on olfactometer
        end
        odorvalindex = [odorvalindex odorval];
    else
        airid = 7;
    end
    
    %pic conditions (14-25) and No pic (26)
    if picpres == 1 %Pic present = yes
        picval = stimord(i,4);
        picvalindex = [picvalindex picval];
    else
    end
    
    greeid = stimord(i,7);
    greebleindex = [greebleindex, greeid];
        
    readycue='+'; %get rid of this cross
    cgrect(0, 0, ScrWid, ScrHgh, [0.6 0.6 0.6])  % Clear back screen to white
    cgpencol(0.3,0.3,0.3)  % Mid-grey fixation for 2 seconds
    cgfont('Arial',48)
    cgtext(readycue,0,0.15);
    cgflip
    pause(2);  % Wait for two seconds
    
    if odorpres == 1 && picpres == 0
        % ******** Sniff cue ********
        cgrect(0, 0, ScrWid, ScrHgh, [0.6 0.6 0.6])  % Clear back screen to white
        cgpencol(0,0,1) % turns to blue to signal sniff cue
        cgfont('Arial',48)
        cgtext('Sniff Now',0,0.15);
        tO=cgflip*1000 ; %time of the sniff now sign/odor onset% doe this serve the same function as cgflip?
        pause(.3); % foon cross on for 0.2 second
        timectr = [timectr tO]; % YZ Confused. use tO/odor_on as odor onset time?
        
        % *** TURN ODOR ON ***
        if Port == 1
            usb2_line_on(PortAid, 0); % Deliver the odor according to the ID number; first number PortA, second number PortB
        elseif Port == 2
            usb2_line_on(0, PortBid);
        end
        
        odor_on = cogstd('sGetTime', -1) * 1000; %how long is odor presentation duration?
        parallel_acquire; % send trigger to Physio
        bSniffTurnedOff = false;
        
        % *** Blank screen ***
        cgrect(0, 0, ScrWid, ScrHgh, [0.6 0.6 0.6]) %changed background page of white
        tOb= cgflip * 1000;
        pause(2); % Odor duration = 2 seconds (Including 0.2s signal cue)
        
        % *** Blank screen on ***
        cgrect(0, 0, ScrWid, ScrHgh, [0.6 0.6 0.6]) %changed background page of white
        usb2_line_on(0, 0); % Air on
        tOoff = cgflip*1000; % Odor off
        
        % *** Fixation cross ***
        cgrect(0, 0, ScrWid, ScrHgh, [0.6 0.6 0.6])
        cgfont('Arial',48);
        cgpencol(0,0,0); %black
        cgtext('+',0,0);
        cgflip
        pause(0.5);  % Wait for two seconds
        
    elseif odorpres == 0 && picpres == 1
        % ********  FACE cue ********
        cgrect(0, 0, ScrWid, ScrHgh, [0.6 0.6 0.6])  % Clear back screen to white
        cgpencol(0,0,1) % turn blue to signal pic cue
        cgfont('Arial',48)
        cgtext('Watch Now',0,0.15);
        tP=cgflip*1000 ; %time of the pic now sign/pic onset
        pause(.3); % black cross on for 0.2 second
        
        % *** TURN PIC ON ***
        cgrect(0, 0, ScrWid, ScrHgh, [0.6 0.6 0.6])  % Clear back screen to white
        tPon= cgflip * 1000; % Pic on time
        cgdrawsprite(picid,0,0) ; %Prepare facepic
        timectr = [timectr tPon];
        parallel_acquire ; %send trigger to Physio
        cgflip % Pic off time
        pause(2); 
        tPoff = cogstd('sGetTime', -1) * 1000 ;
        
        % *** Fixation cross ***
        cgrect(0, 0, ScrWid, ScrHgh, [0.6 0.6 0.6])
        cgfont('Arial',48);
        cgpencol(0,0,0); %black
        cgtext('+',0,0);
        cgflip
        pause(0.5);  % Wait for two seconds
        
    elseif  odorpres == 0 && picpres == 0  % Only save odor-related times for Null trials
        % ******** Sniff cue ********
        cgrect(0, 0, ScrWid, ScrHgh, [0.6 0.6 0.6])  % Clear back screen to white
        cgpencol(0,0,1) % turn blue to signal sniff cue
        cgfont('Arial',48)
        cgtext('Sniff Now',0,0.15);
        tO=cgflip*1000 ; %time of the sniff now sign/odor onset
        pause(.3); % foon cross on for 0.2 second
        timectr = [timectr tO]; % YZ Confused. use tO/odor_on as odor onset time?
        
        % *** TURN ODOR ON ***
        usb2_line_on(airid, 0);
        odor_on = cogstd('sGetTime', -1) * 1000;
        parallel_acquire; % send trigger to Physio
        bSniffTurnedOff = false;
        
        % *** TURN PIC ON ***
        cgrect(0, 0, ScrWid, ScrHgh, [0.6 0.6 0.6])  % Clear back screen to white
        %tPon= cgflip * 1000; % Pic on time
        cgflip
        cgdrawsprite(picid,0,0) ; %Prepare facepic
        %timectr = [timectr tPon];
        parallel_acquire ; %send trigger to Physio
        cgflip % Pic off time
        pause(2); % Pic duration = 0.8 second ???
        %tPoff = cogstd('sGetTime', -1) * 1000 ;
        
        % *** Fixation cross ***
        cgrect(0, 0, ScrWid, ScrHgh, [0.6 0.6 0.6])
        cgfont('Arial',48);
        cgpencol(0,0,0); %black
        cgtext('+',0,0);
        usb2_line_on(0, 0); % Air on
        tOoff = cgflip*1000;
        pause(0.5);  % Wait for two seconds
        
    end
    
    
    % *** GREEBLE ON ***
    cgrect(0, 0, ScrWid, ScrHgh, [0.6 0.6 0.6])  % Clear back screen to white
    cgdrawsprite(greeid,0,0) ; %Prepare greeble
    gree_on = cgflip * 1000 ;
    parallel_acquire ; %send trigger to Physio
    
    FlushEvents();
    
    %dio_acquire ;
    bGreebleOff = false ;
    
    resp = []; %added 3/29 to reset resp for every trial
    button_pressed=false;
    key=[];
    keyStrings = {'b','y','g','r'};
    
    
    % Check the (odor_on + <time>) <time> value to the duration in milliseconds
    % That the subject has to respond.
    while ((cogstd('sGetTime', -1) * 1000) < (gree_on + (700 + ((8.1)*1000))))
        
        
        %[key,rt] = GetKey(keyStrings,(2),[],-1);
        [keyIsDown,press_time,keyArr] = KbCheck();
        %            t_in_cog = (cogstd('sGetTime', -1) * 1000);
        %
        %         % Rest of trial duration
        
        
        if keyIsDown == 1 && button_pressed == false
            keyListCoded = zeros(size(keyArr));
            if nargin<1 || isempty(keyStrings)
                keyListCoded = 1-keyListCoded;
            else
                keyListCoded(KbName(keyStrings)) = 1;
            end
            
            key = KbName(find(keyArr));
            if ~iscell(key) && key == 't'
                key=[];
            else
                t_in_cog = (cogstd('sGetTime', -1) * 1000); % this time point is far from Line739, where a key is actually pressed; need to be changed
                %  t_in_ptb = rt;
                button_pressed = true;
                resp_length=length(key);
                resp_list=[];
                rt_list=[];
                keycell={'l'};
                if iscell(key)
                    for i = 1:resp_length
                        keycell(1,i+1)=(key(1,i)); %add a scalar to an existing cell
                    end
                elseif ~iscell(key)
                    for i = 1:resp_length
                        keycell(1,i+1)={key(1,i)};
                    end
                end
                for   i=1:(resp_length+1)
                    %                  keys='l';
                    %clear button
                    button=keycell{i};
                    %button=cell2mat(buttoncell);
                    if button=='b'
                        but_resp=1;
                        cogrt=t_in_cog;
                    elseif button=='y'
                        but_resp=2;
                        cogrt=t_in_cog;
                    elseif button=='g'
                        but_resp=3;
                        cogrt=t_in_cog;
                    elseif button=='r'
                        but_resp=4;
                        cogrt=t_in_cog;
                    else
                        but_resp=[];
                        cogrt=NaN;
                    end
                    resp_list=[resp_list; but_resp];
                    rt_list=[rt_list; cogrt];
                    
                    if isempty(resp_list)
                        resp_list = [];
                        rt_list=[];
                    else
                        resp_list = resp_list;
                        rt_list= cogrt;
                    end
                end
                if ~isempty(resp_list)
                    resp_list_f=resp_list(1);
                    rt_list_f=rt_list(1);
                    
                    resp_all = [resp_all; [resp_list_f rt_list_f]];
                end
            end
        end
        %         if ~isempty(key)
        %
        %
        %             %t_in_ptb = rt;
        % %             button_pressed = true;
        %             resp_length=length(key);
        %             resp_list=[];
        %             rt_list=[];
        %            % timetest=(cogstd('sGetTime', -1) * 1000);
        %             for i=1:(resp_length+1)
        %                 keys='l';
        %                 keycell={'l'};
        %                 keycell(1,i+1)={key};
        %                 button=keycell{i+1};
        %
        %
        %
        %                 resp_list_f=resp_list(1);
        %                 rt_list_f=rt_list(1);
        %             end
        %
        %
        %
        %             timetest2=(cogstd('sGetTime', -1) * 1000);
        %         end
        
        if ((bGreebleOff == false) && ((cogstd('sGetTime', -1) * 1000) > (gree_on + 700)))
            % log the greeble time
            cgrect(0, 0, ScrWid, ScrHgh, [0.6 0.6 0.6])  % Clear back screen to white
            cgpencol(0,0,0)  % black fixation for rest of trial
            cgfont('Arial',48)
            cgtext('+',0,0.15);
            tgoff = cgflip*1000; % Greeble off time
            
            parallel_acquire; %send trigger to Physio
            bGreebleOff = true;
        end
        
        % ***  Greeble off *** Greeble duration = 0.5 second
        %         if ((bGreebleOff == false) && ((cogstd('sGetTime', -1) * 1000) > (gree_on + 500)))
        %             % log the greeble time
        %             cgrect(0, 0, ScrWid, ScrHgh, [0.6 0.6 0.6])  % Clear back screen to white
        %             cgpencol(0,0,0)  % black fixation for rest of trial
        %             cgfont('Arial',48)
        %             cgtext('+',0,0.15);
        %             tgoff = cgflip*1000; % Greeble off time
        %
        %             parallel_acquire ; %send trigger to Physio
        %             bGreebleOff = true ;
        %         end
        %The rest of the trial would be blank white screen with a black fixation cross
    end
    
    %  This section closes the serial port gracefully.
    %     if (button_pressed == false)
    %         stopasync(s) ;
    %     end
    
    % End of serial port clean up.
    %     fclose(s) ;
    %     clear s ;
    if odorpres == 1 && picpres == 0
        % first collate odor times
        odoronTimes = [odoronTimes tO]; % ?????? tO/odor_on
        odordurTimes = [odordurTimes tOoff-odor_on];
        odoronMRtimes = [odoronMRtimes tO-starttime];
        % odor onset
        
        odoronTimes_odorval{odorval} = [odoronTimes_odorval{odorval} tO];
        odordurTimes_odorval{odorval} = [odordurTimes_odorval{odorval} tOoff-odor_on];
        odoronMRtimes_odorval{odorval} = [odoronMRtimes_odorval{odorval} tO-starttime];
        
        greebleonTimes_odorval{odorval} = [greebleonTimes_odorval{odorval} gree_on];
        greebledurTimes_odorval{odorval} = [greebledurTimes_odorval{odorval} tgoff - gree_on];
        greebleonMRtimes_odorval{odorval} = [greebleonMRtimes_odorval{odorval} gree_on-starttime];
        
    elseif odorpres == 0 && picpres == 1
        piconTimes = [piconTimes tPon];
        picdurTimes = [picdurTimes tPoff-tPon];
        piconMRtimes = [piconMRtimes tPon-starttime];

        
        piconTimes_picval{picval} = [piconTimes_picval{picval} tPon];
        picdurTimes_picval{picval} = [picdurTimes_picval{picval} tPoff-tPon];
        piconMRtimes_picval{picval} = [piconMRtimes_picval{picval} tPon-starttime];
        
        greebleonTimes_picval{picval} = [greebleonTimes_picval{picval} gree_on];
        greebledurTimes_picval{picval} = [greebledurTimes_picval{picval} tgoff-gree_on];
        greebleonMRtimes_picval{picval} = [greebleonMRtimes_picval{picval} gree_on-starttime];
        
    elseif odorpres == 0 && picpres == 0
        
    end
     
    greebleonTimes = [greebleonTimes gree_on];
    greebledurTimes = [greebledurTimes tgoff-gree_on];
    greebleonMRtimes = [greebleonMRtimes  gree_on-starttime];
    % greeble onset

    % now collate responses
    %    if !isempty(byte_in) == 1 % i.e., if button press occurred
    %byte_in;
    
    %GREEBLE RESPONSES WILL BE EXTREMELY UNPLEASANT (1), SOMEWHAT UNPLEASANT (2), SOMEWHAT
    %PLEASANT (4), EXTREMELY PLEASANT (8)
    % if byte_in > 100
    %    byte_in = byte_in - 128;
    % else
    % end
    %
    %     %now collate responses
    
    PICID=picid-13;
    if button_pressed == true    % If any button response was recorded, byte_in should be greater than 0.
        response = resp_list_f; %Response is the value that everything will be compared to.
        presses = presses + 1; %Records if a button was pressed during the trial; this should be equal to the number of trials
        rt = rt_list_f - gree_on; % The response time is the time from the greeble onset to the time of the button press.
        % rtPTB=t_in_ptb(1) - gree_on;
        allRTs = [allRTs rt];
        allButtOns_MRtimes(presses) = rt_list_f - starttime; %Collates all response times and corrects them for scanner times
        %
        if odorpres == 1 && picpres == 0 % Odor condition
            if response == 1
                RTs_odorval{odorval} = [RTs_odorval{odorval} rt];
                respval = 1;
                responsevaluesall = [responsevaluesall respval];
                OdorResp{odorid} = [OdorResp{odorid} respval];
            elseif response == 2
                RTs_odorval{odorval} = [RTs_odorval{odorval} rt];
                respval = 2;
                responsevaluesall = [responsevaluesall respval];
                OdorResp{odorid} = [OdorResp{odorid} respval];
            elseif response == 3
                RTs_odorval{odorval} = [RTs_odorval{odorval} rt];
                respval = 3;
                responsevaluesall = [responsevaluesall respval];
                OdorResp{odorid} = [OdorResp{odorid} respval];
            elseif response == 4
                RTs_odorval{odorval} = [RTs_odorval{odorval} rt];
                respval = 4;
                responsevaluesall = [responsevaluesall respval];
                OdorResp{odorid} = [OdorResp{odorid} respval];
            else
                RTs_odorval{odorval} = [RTs_odorval{odorval} NaN];
                respval = 0;
                responsevaluesall = [responsevaluesall respval];
                OdorResp{odorid} = [OdorResp{odorid} respval];
                
            end
        elseif odorpres == 0 && picpres == 1 % Pic condition
            if response == 1
                RTs_picval{picval} = [RTs_picval{picval} rt];
                respval = 1;
                responsevaluesall = [responsevaluesall respval];
                PicResp{PICID} = [PicResp{PICID} respval];
            elseif response == 2
                RTs_picval{picval} = [RTs_picval{picval} rt];
                respval = 2;
                responsevaluesall = [responsevaluesall respval];
                PicResp{PICID} = [PicResp{PICID} respval];
            elseif response == 3
                RTs_picval{picval} = [RTs_picval{picval} rt];
                respval = 3;
                responsevaluesall = [responsevaluesall respval];
                PicResp{PICID} = [PicResp{PICID} respval];
            elseif response == 4
                RTs_picval{picval} = [RTs_picval{picval} rt];
                respval = 4;
                responsevaluesall = [responsevaluesall respval];
                PicResp{PICID} = [PicResp{PICID} respval];
            else
                RTs_picval{picval} = [RTs_picval{picval} NaN];
                respval = 0;
                responsevaluesall = [responsevaluesall respval];
                PicResp{PICID} = [PicResp{PICID} respval];
            end
        end
        yesresp = yesresp + 1;
        
    else
        buttstr = 'NO BUTTON PRESS';
        response = NaN;
        if odorpres == 1 && picpres == 0 % Odor condition
            RTs_odorval{odorval} = [RTs_odorval{odorval} NaN];
            OdorResp{odorid} = [OdorResp{odorid} 0];
        elseif odorpres == 0 && picpres == 1 % Pic condition
            RTs_picval{picval} = [RTs_picval{picval} NaN];
            PicResp{PICID} = [PicResp{PICID} 0];
        end
        respval = 0;
        responsevaluesall = [responsevaluesall respval];
        
        if odorpres == 1 && picpres == 0
            noresp = noresp + 1; %Records the number of trials in which no response was given
            noresp_onTimes = [noresp_onTimes tO]; %Records the trial onset time for no response trials
            noresp_durTimes = [noresp_durTimes tOoff-odor_on]; %Records the trial duration time for no response trials
            noresp_onMRtimes = [noresp_onMRtimes tO-starttime]; %Records the trial onset time for no response trials corrected for scanner time
            
        elseif odorpres == 0 && picpres == 1          
            noresp = noresp + 1; %Records the number of trials in which no response was given
            noresp_onTimes = [noresp_onTimes tPon]; %Records the trial onset time for no response trials
            noresp_durTimes = [noresp_durTimes tPoff-tPon]; %Records the trial duration time for no response trials
            noresp_onMRtimes = [noresp_onMRtimes tPon-starttime]; %Records the trial onset time for no response trials corrected for scanner time
        end
    end
    
    if odorpres == 1 && picpres == 0 % Odor condition
        str1 = sprintf('Trial %d : Odor ID %d and Greeble ID %d', i, odorid, greeid);
        str2 = sprintf('Odor On at %d ms (MRTime %d ms) sniffed for %d ms duration', odor_on, odor_on-starttime, tOoff-odor_on);
        str3 = sprintf('Greeble On at %d ms (MRTime %d ms) for %d ms duration', gree_on, gree_on-starttime, tgoff-gree_on);
        str4 = sprintf('Response: %d', respval);
        log_string(str1);
        log_string(str2);
        log_string(str3);
        log_string(str4);
    elseif odorpres == 0 && picpres == 1 % Pic condition
        str5 = sprintf('Trial %d : Pic ID %d andGreeble ID %d', i, picid, greeid);
        str6 = sprintf('Pic On at %d ms (MRTime %d ms) watch for %d ms duration', tPon, tPon-starttime, tPoff-tPon);
        str7 = sprintf('Greeble On at %d ms (MRTime %d ms) for %d ms duration', gree_on, gree_on-starttime, tgoff-gree_on);
        str8 = sprintf('Response: %d', respval);
        log_string(str5);
        log_string(str6);
        log_string(str7);
        log_string(str8);
    else
    end
    
    while ((cogstd('sGetTime', -1) * 1000) < (trialtime + ((14.1)*1000)))
        if i == 2
            test = sprintf('cogstd(%d) * 1000 < trialtime(%d) + SOA)',...
                (cogstd('sGetTime', -1) * 1000), trialtime) ;
            
        end
    end
    
end

%% Save Responses and End Program
results.onsets.scanon       = scanon; %first wait trigger time (formerly TIME=0)
results.onsets.scanon_7th       = scanon_7th;
results.onsets.starttime    = starttime;
results.onsets.mristarttime    = mristarttime;
results.onsets.allButtOns_MRtimes = allButtOns_MRtimes;%**

results.onsets.odoronTimes       = odoronTimes;
results.onsets.odordurTimes      = odordurTimes;
results.onsets.odoronMRtimes     = odoronMRtimes;%***for fMRI version****

results.onsets.picronTimes       = piconTimes;
results.onsets.picrdurTimes      = picdurTimes;
results.onsets.picronMRtimes    = piconMRtimes;

results.onsets.greebleonTimes = greebleonTimes;
results.onsets.greebledurTimes = greebledurTimes;
results.onsets.greebleonMRtimes = greebleonMRtimes;

results.onsets.odoronTimes_greeval = odoronTimes_greeval;
results.onsets.odordurTimes_greeval = odordurTimes_greeval;
results.onsets.odoronMRtimes_greeval = odoronMRtimes_greeval;
results.onsets.odoronTimes_odorval     = odoronTimes_odorval ;
results.onsets.odordurTimes_odorval    = odordurTimes_odorval ;
results.onsets.odoronMRtimes_odorval   = odoronMRtimes_odorval ;%***for fMRI version****
results.onsets.greebleonTimes_odorval = greebleonTimes_odorval;
results.onsets.greebledurTimes_odorval = greebledurTimes_odorval;
results.onsets.greebleonMRtimes_odorval = greebleonMRtimes_odorval;

results.onsets.piconTimes_greeval = piconTimes_greeval;
results.onsets.picdurTimes_greeval = picdurTimes_greeval;
results.onsets.piconMRtimes_greeval = piconMRtimes_greeval;
results.onsets.piconTimes_picval = piconTimes_picval ;
results.onsets.picdurTimes_picval = picdurTimes_picval ;
results.onsets.piconMRtimes_picval = piconMRtimes_picval ;
results.onsets.greebleonTimes_picval = greebleonTimes_picval;
results.onsets.greebledurTimes_picval = greebledurTimes_picval;
results.onsets.greebleonMRtimes_picval = greebleonMRtimes_picval;

results.onsets.noresp_onTimes       = noresp_onTimes;
results.onsets.noresp_durTimes      = noresp_durTimes;
results.onsets.noresp_onMRtimes      = noresp_onMRtimes;

results.demographics.age = age ;
results.demographics.gender = gender ;
results.demographics.ethnicity = eth ;

results.behav.resp_all    = resp_all; %**
results.behav.resp             = resp;%**
results.behav.allRTs = allRTs;
%results.behav.RTsptb_greeval = RTsptb_greeval;
results.behav.RTs_greeval = RTs_greeval;
results.behav.RTs_odorval = RTs_odorval;
%results.behav.RTsptb_odorval = RTsptb_odorval;
results.behav.RTs_picval = RTs_picval;
%results.behav.RTsptb_picval = RTsptb_picval;
results.behav.GreeResp = GreeResp;
results.behav.PicResp = PicResp;
results.behav.OdorResp = OdorResp;
results.behav.yesresp = yesresp;
results.behav.noresp = noresp;
results.behav.all_responses  = responsevaluesall;

results.checks.subinfo         = subinfo;
results.checks.block           = block;
results.checks.presses         = presses;%added back in 3/29
% results.checks.SOA             = SOA;
results.checks.resp           = resp;%**
results.checks.resp_all    = resp_all;
results.checks.odorval = odorvalindex;
results.checks.picval       = picvalindex;
results.checks.greecond = greeblecondindex;
results.checks.stiminfo     = stimord;
results.checks.odorcheck    = stimord(:,1) ; %should match results.checks.odorid
results.checks.piccheck     = stimord(:,2) ; %should match results.checks.picid
results.checks.odvalcheck   = stimord(:,3);
results.checks.picvalcheck   = stimord(:,4);
results.checks.odorprescheck    = stimord(:,5);
results.checks.picprescheck    = stimord(:,6);
results.checks.greecheck = stimord(:,7);
results.checks.greevalcheck = stimord(:,8);

% wait (10000)
startwait = cogstd('sGetTime', -1) * 1000 ;
while ((cogstd('sGetTime', -1) * 1000) < startwait + 10000) end ;

% Clear back page
cgrect(0, 0, ScrWid, ScrHgh, [1 1 1]) ;
cgflip ;

cgrect(0, 0, ScrWid, ScrHgh, [1 1 1]) ;
cgpencol(0,0,0) ;

% prepare string
cgtext('Well done ! Take a break',0,ScrHgh / 6 - 15);
cgflip ;

startwait = cogstd('sGetTime', -1) * 1000 ;
while ((cogstd('sGetTime', -1) * 1000) < (startwait + 6000)) end

% if subtype == 'c'
%     subgrp = 'CTL';
% elseif subtype == 'p'
%     subgrp = 'AD';
% else
% end

dm = 'C:\My Experiments\Wen_Li\Sweat\m_scripts';
dmat = 'C:\My Experiments\Wen_Li\Sweat\mat_files';

cd(dmat);
eval(['save ARF_Sweat_Greebleblock_' deblank(name_id) '_sub' num2str(subnum)  ' results']);
cd(dm);

%}

pause off
log_finish ;
usb2_finish ;
parallel_finish ;

cgshut


