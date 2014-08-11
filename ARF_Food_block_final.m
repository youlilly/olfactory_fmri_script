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
 
stimorda=[
11	26	4	5	1	0	702	2	4	1
5	26	2	5	1	0	503	1	2	2
13	21	5	3	0	1	601	1	7	3
13	17	5	2	0	1	607	1	6	4
13	20	5	3	0	1	405	1	7	5
7	26	3	5	1	0	805	2	3	6
13	22	5	3	0	1	506	1	7	7
13	24	5	4	0	1	903	2	8	8
12	26	4	5	1	0	803	2	4	9
7	26	3	5	1	0	508	1	3	10
13	26	5	5	0	0	915	1	9	11
13	26	5	5	0	0	916	1	9	12
6	26	2	5	1	0	904	2	2	13
9	26	3	5	1	0	402	1	3	14
12	26	4	5	1	0	508	1	4	15
13	15	5	1	0	1	607	1	5	16
13	21	5	3	0	1	408	1	7	17
13	26	5	5	0	0	913	1	9	18
12	26	4	5	1	0	403	1	4	19
5	26	2	5	1	0	604	1	2	20
13	15	5	1	0	1	404	1	5	21
7	26	3	5	1	0	803	2	3	22
1	26	1	5	1	0	704	2	1	23
13	16	5	1	0	1	902	2	5	24
13	19	5	2	0	1	804	2	6	25
10	26	4	5	1	0	901	2	4	26
13	23	5	4	0	1	601	1	8	27
8	26	3	5	1	0	608	1	3	28
13	18	5	2	0	1	404	1	6	29
13	21	5	3	0	1	903	2	7	30
13	26	5	5	0	0	912	1	9	31
13	14	5	1	0	1	603	1	5	32
10	26	4	5	1	0	602	1	4	33
13	17	5	2	0	1	902	2	6	34
13	24	5	4	0	1	808	2	8	35
10	26	4	5	1	0	502	1	4	36
13	18	5	2	0	1	406	1	6	37
13	18	5	2	0	1	603	1	6	38
13	15	5	1	0	1	801	2	5	39
3	26	1	5	1	0	407	1	1	40
6	26	2	5	1	0	802	2	2	41
13	21	5	3	0	1	505	1	7	42
8	26	3	5	1	0	901	2	3	43
13	18	5	2	0	1	706	2	6	44
13	20	5	3	0	1	705	2	7	45
2	26	1	5	1	0	401	1	1	46
9	26	3	5	1	0	403	1	3	47
13	26	5	5	0	0	919	2	9	48
1	26	1	5	1	0	503	1	1	49
13	23	5	4	0	1	705	2	8	50
11	26	4	5	1	0	608	1	4	51
13	14	5	1	0	1	907	2	5	52
2	26	1	5	1	0	501	1	1	53
3	26	1	5	1	0	904	2	1	54
13	26	5	5	0	0	918	2	9	55
13	26	5	5	0	0	917	2	9	56
8	26	3	5	1	0	708	2	3	57
4	26	2	5	1	0	501	1	2	58
13	14	5	1	0	1	406	1	5	59
8	26	3	5	1	0	906	2	3	60
11	26	4	5	1	0	708	2	4	61
13	22	5	3	0	1	808	2	7	62
13	17	5	2	0	1	703	2	6	63
4	26	2	5	1	0	407	1	2	64
13	23	5	4	0	1	408	1	8	65
13	19	5	2	0	1	504	1	6	66
7	26	3	5	1	0	602	1	3	67
6	26	2	5	1	0	905	2	2	68
10	26	4	5	1	0	402	1	4	69
13	25	5	4	0	1	506	1	8	70
13	15	5	1	0	1	804	2	5	71
1	26	1	5	1	0	605	1	1	72
13	26	5	5	0	0	921	2	9	73
13	24	5	4	0	1	606	1	8	74
1	26	1	5	1	0	807	2	1	75
13	14	5	1	0	1	507	1	5	76
13	25	5	4	0	1	908	2	8	77
13	26	5	5	0	0	920	2	9	78
13	19	5	2	0	1	507	1	6	79
13	16	5	1	0	1	504	1	5	80
9	26	3	5	1	0	502	1	3	81
13	26	5	5	0	0	914	1	9	82
2	26	1	5	1	0	802	2	1	83
13	20	5	3	0	1	908	2	7	84
4	26	2	5	1	0	401	1	2	85
13	23	5	4	0	1	405	1	8	86
3	26	1	5	1	0	701	2	1	87
13	25	5	4	0	1	707	2	8	88
5	26	2	5	1	0	701	2	2	89
12	26	4	5	1	0	906	2	4	90
9	26	3	5	1	0	702	2	3	91
13	20	5	3	0	1	806	2	7	92
11	26	4	5	1	0	805	2	4	93
13	17	5	2	0	1	907	2	6	94
3	26	1	5	1	0	604	1	1	95
13	19	5	2	0	1	801	2	6	96
13	16	5	1	0	1	706	2	5	97
4	26	2	5	1	0	605	1	2	98
13	26	5	5	0	0	922	2	9	99
2	26	1	5	1	0	905	2	1	100
5	26	2	5	1	0	807	2	2	101
13	22	5	3	0	1	606	1	7	102
6	26	2	5	1	0	704	2	2	103
13	24	5	4	0	1	505	1	8	104
13	22	5	3	0	1	707	2	7	105
13	25	5	4	0	1	806	2	8	106
13	16	5	1	0	1	703	2	5	107
13	26	5	5	0	0	911	1	9	108
];

stimordb = [
11	26	4	5	1	0	503	1	4	1
5	26	2	5	1	0	702	2	2	2
13	21	5	3	0	1	607	1	7	3
13	17	5	2	0	1	903	2	6	4
13	20	5	3	0	1	404	1	7	5
7	26	3	5	1	0	704	2	3	6
13	22	5	3	0	1	902	2	7	7
13	24	5	4	0	1	607	1	8	8
12	26	4	5	1	0	904	2	4	9
7	26	3	5	1	0	407	1	3	10
13	26	5	5	0	0	915	1	9	11
13	26	5	5	0	0	916	1	9	12
6	26	2	5	1	0	803	2	2	13
9	26	3	5	1	0	401	1	3	14
12	26	4	5	1	0	604	1	4	15
13	15	5	1	0	1	601	1	5	16
13	21	5	3	0	1	603	1	7	17
13	26	5	5	0	0	913	1	9	18
12	26	4	5	1	0	802	2	4	19
5	26	2	5	1	0	508	1	2	20
13	15	5	1	0	1	405	1	5	21
7	26	3	5	1	0	503	1	3	22
1	26	1	5	1	0	805	2	1	23
13	16	5	1	0	1	506	1	5	24
13	19	5	2	0	1	601	1	6	25
10	26	4	5	1	0	501	1	4	26
13	23	5	4	0	1	804	2	8	27
8	26	3	5	1	0	501	1	3	28
13	18	5	2	0	1	808	2	6	29
13	21	5	3	0	1	801	2	7	30
13	26	5	5	0	0	912	1	9	31
13	14	5	1	0	1	408	1	5	32
10	26	4	5	1	0	407	1	4	33
13	17	5	2	0	1	705	2	6	34
13	24	5	4	0	1	404	1	8	35
10	26	4	5	1	0	905	2	4	36
13	18	5	2	0	1	408	1	6	37
13	18	5	2	0	1	506	1	6	38
13	15	5	1	0	1	903	2	5	39
3	26	1	5	1	0	508	1	1	40
6	26	2	5	1	0	403	1	2	41
13	21	5	3	0	1	907	2	7	42
8	26	3	5	1	0	904	2	3	43
13	18	5	2	0	1	606	1	6	44
13	20	5	3	0	1	406	1	7	45
2	26	1	5	1	0	402	1	1	46
9	26	3	5	1	0	605	1	3	47
13	26	5	5	0	0	919	2	9	48
1	26	1	5	1	0	803	2	1	49
13	23	5	4	0	1	902	2	8	50
11	26	4	5	1	0	401	1	4	51
13	14	5	1	0	1	505	1	5	52
2	26	1	5	1	0	608	1	1	53
3	26	1	5	1	0	901	2	1	54
13	26	5	5	0	0	918	2	9	55
13	26	5	5	0	0	917	2	9	56
8	26	3	5	1	0	807	2	3	57
4	26	2	5	1	0	901	2	2	58
13	14	5	1	0	1	705	2	5	59
8	26	3	5	1	0	802	2	3	60
11	26	4	5	1	0	701	2	4	61
13	22	5	3	0	1	804	2	7	62
13	17	5	2	0	1	908	2	6	63
4	26	2	5	1	0	602	1	2	64
13	23	5	4	0	1	406	1	8	65
13	19	5	2	0	1	405	1	6	66
7	26	3	5	1	0	701	2	3	67
6	26	2	5	1	0	502	1	2	68
10	26	4	5	1	0	605	1	4	69
13	25	5	4	0	1	603	1	8	70
13	15	5	1	0	1	808	2	5	71
1	26	1	5	1	0	403	1	1	72
13	26	5	5	0	0	921	2	9	73
13	24	5	4	0	1	706	2	8	74
1	26	1	5	1	0	708	2	1	75
13	14	5	1	0	1	908	2	5	76
13	25	5	4	0	1	703	2	8	77
13	26	5	5	0	0	920	2	9	78
13	19	5	2	0	1	707	2	6	79
13	16	5	1	0	1	806	2	5	80
9	26	3	5	1	0	604	1	3	81
13	26	5	5	0	0	914	1	9	82
2	26	1	5	1	0	906	2	1	83
13	20	5	3	0	1	507	1	7	84
4	26	2	5	1	0	608	1	2	85
13	23	5	4	0	1	504	1	8	86
3	26	1	5	1	0	602	1	1	87
13	25	5	4	0	1	507	1	8	88
5	26	2	5	1	0	708	2	2	89
12	26	4	5	1	0	807	2	4	90
9	26	3	5	1	0	905	2	3	91
13	20	5	3	0	1	504	1	7	92
11	26	4	5	1	0	704	2	4	93
13	17	5	2	0	1	505	1	6	94
3	26	1	5	1	0	502	1	1	95
13	19	5	2	0	1	806	2	6	96
13	16	5	1	0	1	606	1	5	97
4	26	2	5	1	0	402	1	2	98
13	26	5	5	0	0	922	2	9	99
2	26	1	5	1	0	702	2	1	100
5	26	2	5	1	0	906	2	2	101
13	22	5	3	0	1	706	2	7	102
6	26	2	5	1	0	805	2	2	103
13	24	5	4	0	1	907	2	8	104
13	22	5	3	0	1	703	2	7	105
13	25	5	4	0	1	801	2	8	106
13	16	5	1	0	1	707	2	5	107
13	26	5	5	0	0	911	1	9	108
];

stimordc = [
11	26	4	5	1	0	903	2	4	1
5	26	2	5	1	0	607	1	2	2
13	21	5	3	0	1	805	2	7	3
13	17	5	2	0	1	503	1	6	4
13	20	5	3	0	1	508	1	7	5
7	26	3	5	1	0	601	1	3	6
13	22	5	3	0	1	402	1	7	7
13	24	5	4	0	1	702	2	8	8
12	26	4	5	1	0	601	1	4	9
7	26	3	5	1	0	405	1	3	10
13	26	5	5	0	0	915	1	9	11
13	26	5	5	0	0	916	1	9	12
6	26	2	5	1	0	804	2	2	13
9	26	3	5	1	0	506	1	3	14
12	26	4	5	1	0	808	2	4	15
13	15	5	1	0	1	704	2	5	16
13	21	5	3	0	1	803	2	7	17
13	26	5	5	0	0	913	1	9	18
12	26	4	5	1	0	705	2	4	19
5	26	2	5	1	0	404	1	2	20
13	15	5	1	0	1	407	1	5	21
7	26	3	5	1	0	408	1	3	22
1	26	1	5	1	0	607	1	1	23
13	16	5	1	0	1	401	1	5	24
13	19	5	2	0	1	904	2	6	25
10	26	4	5	1	0	408	1	4	26
13	23	5	4	0	1	803	2	8	27
8	26	3	5	1	0	903	2	3	28
13	18	5	2	0	1	604	1	6	29
13	21	5	3	0	1	608	1	7	30
13	26	5	5	0	0	912	1	9	31
13	14	5	1	0	1	503	1	5	32
10	26	4	5	1	0	506	1	4	33
13	17	5	2	0	1	802	2	6	34
13	24	5	4	0	1	508	1	8	35
10	26	4	5	1	0	606	1	4	36
13	18	5	2	0	1	501	1	6	37
13	18	5	2	0	1	407	1	6	38
13	15	5	1	0	1	501	1	5	39
3	26	1	5	1	0	404	1	1	40
6	26	2	5	1	0	902	2	2	41
13	21	5	3	0	1	901	2	7	42
8	26	3	5	1	0	505	1	3	43
13	18	5	2	0	1	905	2	6	44
13	20	5	3	0	1	403	1	7	45
2	26	1	5	1	0	902	2	1	46
9	26	3	5	1	0	705	2	3	47
13	26	5	5	0	0	919	2	9	48
1	26	1	5	1	0	603	1	1	49
13	23	5	4	0	1	403	1	8	50
11	26	4	5	1	0	908	2	4	51
13	14	5	1	0	1	904	2	5	52
2	26	1	5	1	0	801	2	1	53
3	26	1	5	1	0	907	2	1	54
13	26	5	5	0	0	918	2	9	55
13	26	5	5	0	0	917	2	9	56
8	26	3	5	1	0	808	2	3	57
4	26	2	5	1	0	406	1	2	58
13	14	5	1	0	1	605	1	5	59
8	26	3	5	1	0	908	2	3	60
11	26	4	5	1	0	405	1	4	61
13	22	5	3	0	1	708	2	7	62
13	17	5	2	0	1	401	1	6	63
4	26	2	5	1	0	603	1	2	64
13	23	5	4	0	1	901	2	8	65
13	19	5	2	0	1	701	2	6	66
7	26	3	5	1	0	806	2	3	67
6	26	2	5	1	0	706	2	2	68
10	26	4	5	1	0	707	2	4	69
13	25	5	4	0	1	602	1	8	70
13	15	5	1	0	1	807	2	5	71
1	26	1	5	1	0	406	1	1	72
13	26	5	5	0	0	921	2	9	73
13	24	5	4	0	1	502	1	8	74
1	26	1	5	1	0	804	2	1	75
13	14	5	1	0	1	802	2	5	76
13	25	5	4	0	1	608	1	8	77
13	26	5	5	0	0	920	2	9	78
13	19	5	2	0	1	605	1	6	79
13	16	5	1	0	1	701	2	5	80
9	26	3	5	1	0	606	1	3	81
13	26	5	5	0	0	914	1	9	82
2	26	1	5	1	0	507	1	1	83
13	20	5	3	0	1	906	2	7	84
4	26	2	5	1	0	703	2	2	85
13	23	5	4	0	1	708	2	8	86
3	26	1	5	1	0	504	1	1	87
13	25	5	4	0	1	402	1	8	88
5	26	2	5	1	0	504	1	2	89
12	26	4	5	1	0	505	1	4	90
9	26	3	5	1	0	707	2	3	91
13	20	5	3	0	1	602	1	7	92
11	26	4	5	1	0	806	2	4	93
13	17	5	2	0	1	807	2	6	94
3	26	1	5	1	0	706	2	1	95
13	19	5	2	0	1	704	2	6	96
13	16	5	1	0	1	604	1	5	97
4	26	2	5	1	0	507	1	2	98
13	26	5	5	0	0	922	2	9	99
2	26	1	5	1	0	703	2	1	100
5	26	2	5	1	0	907	2	2	101
13	22	5	3	0	1	502	1	7	102
6	26	2	5	1	0	801	2	2	103
13	24	5	4	0	1	906	2	8	104
13	22	5	3	0	1	702	2	7	105
13	25	5	4	0	1	805	2	8	106
13	16	5	1	0	1	905	2	5	107
13	26	5	5	0	0	911	1	9	108
];

stimordd = [
11	26	4	5	1	0	607	1	4	1
5	26	2	5	1	0	903	2	2	2
13	21	5	3	0	1	704	2	7	3
13	17	5	2	0	1	702	2	6	4
13	20	5	3	0	1	407	1	7	5
7	26	3	5	1	0	607	1	3	6
13	22	5	3	0	1	401	1	7	7
13	24	5	4	0	1	503	1	8	8
12	26	4	5	1	0	804	2	4	9
7	26	3	5	1	0	404	1	3	10
13	26	5	5	0	0	915	1	9	11
13	26	5	5	0	0	916	1	9	12
6	26	2	5	1	0	601	1	2	13
9	26	3	5	1	0	902	2	3	14
12	26	4	5	1	0	404	1	4	15
13	15	5	1	0	1	805	2	5	16
13	21	5	3	0	1	503	1	7	17
13	26	5	5	0	0	913	1	9	18
12	26	4	5	1	0	902	2	4	19
5	26	2	5	1	0	808	2	2	20
13	15	5	1	0	1	508	1	5	21
7	26	3	5	1	0	603	1	3	22
1	26	1	5	1	0	601	1	1	23
13	16	5	1	0	1	402	1	5	24
13	19	5	2	0	1	803	2	6	25
10	26	4	5	1	0	406	1	4	26
13	23	5	4	0	1	904	2	8	27
8	26	3	5	1	0	801	2	3	28
13	18	5	2	0	1	508	1	6	29
13	21	5	3	0	1	501	1	7	30
13	26	5	5	0	0	912	1	9	31
13	14	5	1	0	1	803	2	5	32
10	26	4	5	1	0	603	1	4	33
13	17	5	2	0	1	403	1	6	34
13	24	5	4	0	1	604	1	8	35
10	26	4	5	1	0	706	2	4	36
13	18	5	2	0	1	901	2	6	37
13	18	5	2	0	1	602	1	6	38
13	15	5	1	0	1	608	1	5	39
3	26	1	5	1	0	405	1	1	40
6	26	2	5	1	0	705	2	2	41
13	21	5	3	0	1	904	2	7	42
8	26	3	5	1	0	907	2	3	43
13	18	5	2	0	1	502	1	6	44
13	20	5	3	0	1	605	1	7	45
2	26	1	5	1	0	506	1	1	46
9	26	3	5	1	0	406	1	3	47
13	26	5	5	0	0	919	2	9	48
1	26	1	5	1	0	408	1	1	49
13	23	5	4	0	1	802	2	8	50
11	26	4	5	1	0	703	2	4	51
13	14	5	1	0	1	901	2	5	52
2	26	1	5	1	0	903	2	1	53
3	26	1	5	1	0	505	1	1	54
13	26	5	5	0	0	918	2	9	55
13	26	5	5	0	0	917	2	9	56
8	26	3	5	1	0	804	2	3	57
4	26	2	5	1	0	408	1	2	58
13	14	5	1	0	1	403	1	5	59
8	26	3	5	1	0	507	1	3	60
11	26	4	5	1	0	504	1	4	61
13	22	5	3	0	1	807	2	7	62
13	17	5	2	0	1	608	1	6	63
4	26	2	5	1	0	506	1	2	64
13	23	5	4	0	1	501	1	8	65
13	19	5	2	0	1	708	2	6	66
7	26	3	5	1	0	504	1	3	67
6	26	2	5	1	0	606	1	2	68
10	26	4	5	1	0	507	1	4	69
13	25	5	4	0	1	407	1	8	70
13	15	5	1	0	1	708	2	5	71
1	26	1	5	1	0	705	2	1	72
13	26	5	5	0	0	921	2	9	73
13	24	5	4	0	1	905	2	8	74
1	26	1	5	1	0	808	2	1	75
13	14	5	1	0	1	906	2	5	76
13	25	5	4	0	1	401	1	8	77
13	26	5	5	0	0	920	2	9	78
13	19	5	2	0	1	402	1	6	79
13	16	5	1	0	1	602	1	5	80
9	26	3	5	1	0	706	2	3	81
13	26	5	5	0	0	914	1	9	82
2	26	1	5	1	0	908	2	1	83
13	20	5	3	0	1	802	2	7	84
4	26	2	5	1	0	908	2	2	85
13	23	5	4	0	1	701	2	8	86
3	26	1	5	1	0	806	2	1	87
13	25	5	4	0	1	605	1	8	88
5	26	2	5	1	0	405	1	2	89
12	26	4	5	1	0	907	2	4	90
9	26	3	5	1	0	703	2	3	91
13	20	5	3	0	1	701	2	7	92
11	26	4	5	1	0	801	2	4	93
13	17	5	2	0	1	906	2	6	94
3	26	1	5	1	0	606	1	1	95
13	19	5	2	0	1	805	2	6	96
13	16	5	1	0	1	502	1	5	97
4	26	2	5	1	0	707	2	2	98
13	26	5	5	0	0	922	2	9	99
2	26	1	5	1	0	707	2	1	100
5	26	2	5	1	0	505	1	2	101
13	22	5	3	0	1	604	1	7	102
6	26	2	5	1	0	806	2	2	103
13	24	5	4	0	1	807	2	8	104
13	22	5	3	0	1	905	2	7	105
13	25	5	4	0	1	704	2	8	106
13	16	5	1	0	1	702	2	5	107
13	26	5	5	0	0	911	1	9	108
];


if subnum == 1 || subnum == 2 || subnum == 3 || subnum == 4% Subject list a
    stimscramb = stimorda;
elseif  subnum == 5 || subnum == 6 || subnum == 7 || subnum == 8 % Subject list b
    stimscramb = stimordb;
elseif  subnum == 9 || subnum == 10 || subnum == 11 || subnum == 12 % Subject list c
    stimscramb = stimordc;
elseif  subnum == 13 || subnum == 14 || subnum == 15 || subnum == 16 % Subject list d
    stimscramb = stimordd;
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
nslices = 48; %changed by Wen on June/17th/2014
ndummies = 6;
%% Set up olfactometer, triggers & Cogent.
%Configure equipment
 
 usb2_config ; %Olfactometer
 parallel_config ;  % For reading trigger on the parallel port
 
% %For the parallel port
 global base_state;
 global parport_out;
 global parport_in;
% 
% % Necessary for callback function to operate properly.
% global button_pressed ;
 
% Load and configure Cogent
cgloadlib
cgopen(1,0,0,1)
log_start_timer ;
%log_header ;
 
gsd = cggetdata('gsd') ;
gpd = cggetdata('gpd') ;
 
ScrWid = gsd.ScreenWidth ;
ScrHgh = gsd.ScreenHeight ;
 
%Load 6 face stimuli, 6 scene pics, 1 placeholder, and 60 Foods into Cogent.
cgloadbmp(001,'Food_instruction_picture.bmp');
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
cgloadbmp(26,'NullRect.bmp'); 
%Load 5 sets of foods
cgloadbmp(401,'FH_A_1.bmp');
cgloadbmp(402,'FH_A_2.bmp');
cgloadbmp(403,'FH_A_3.bmp');
cgloadbmp(404,'FH_A_4.bmp');
cgloadbmp(405,'FH_A_5.bmp');
cgloadbmp(406,'FH_A_6.bmp');
cgloadbmp(407,'FH_A_7.bmp');
cgloadbmp(408,'FH_A_8.bmp');
cgloadbmp(501,'FH_J_1.bmp');
cgloadbmp(502,'FH_J_2.bmp');
cgloadbmp(503,'FH_J_3.bmp');
cgloadbmp(504,'FH_J_4.bmp');
cgloadbmp(505,'FH_J_5.bmp');
cgloadbmp(506,'FH_J_6.bmp');
cgloadbmp(507,'FH_J_7.bmp');
cgloadbmp(508,'FH_J_8.bmp');
cgloadbmp(601,'FH_B_1.bmp');
cgloadbmp(602,'FH_B_2.bmp');
cgloadbmp(603,'FH_B_3.bmp');
cgloadbmp(604,'FH_B_4.bmp');
cgloadbmp(605,'FH_B_5.bmp');
cgloadbmp(606,'FH_B_6.bmp');
cgloadbmp(607,'FH_B_7.bmp');
cgloadbmp(608,'FH_B_8.bmp');
cgloadbmp(701,'FUH_D_1.bmp');
cgloadbmp(702,'FUH_D_2.bmp');
cgloadbmp(703,'FUH_D_3.bmp');
cgloadbmp(704,'FUH_D_4.bmp');
cgloadbmp(705,'FUH_D_5.bmp');
cgloadbmp(706,'FUH_D_6.bmp');
cgloadbmp(707,'FUH_D_7.bmp');
cgloadbmp(708,'FUH_D_8.bmp');
cgloadbmp(801,'FUH_CO_1.bmp');
cgloadbmp(802,'FUH_CO_2.bmp');
cgloadbmp(803,'FUH_CO_3.bmp');
cgloadbmp(804,'FUH_CO_4.bmp');
cgloadbmp(805,'FUH_CO_5.bmp');
cgloadbmp(806,'FUH_CO_6.bmp');
cgloadbmp(807,'FUH_CO_7.bmp');
cgloadbmp(808,'FUH_CO_8.bmp');
cgloadbmp(901,'FUH_CA_1.bmp');
cgloadbmp(902,'FUH_CA_2.bmp');
cgloadbmp(903,'FUH_CA_3.bmp');
cgloadbmp(904,'FUH_CA_4.bmp');
cgloadbmp(905,'FUH_CA_5.bmp');
cgloadbmp(906,'FUH_CA_6.bmp');
cgloadbmp(907,'FUH_CA_7.bmp');
cgloadbmp(908,'FUH_CA_8.bmp');
cgloadbmp(911,'FH_BL_1.bmp');
cgloadbmp(912,'FH_BL_2.bmp');
cgloadbmp(913,'FH_BL_3.bmp');
cgloadbmp(914,'FH_BL_4.bmp');
cgloadbmp(915,'FH_BL_5.bmp');
cgloadbmp(916,'FH_BL_6.bmp');
cgloadbmp(917,'FUH_BL_7.bmp');
cgloadbmp(918,'FUH_BL_8.bmp');
cgloadbmp(919,'FUH_BL_9.bmp');
cgloadbmp(920,'FUH_BL_10.bmp');
cgloadbmp(921,'FUH_BL_11.bmp');
cgloadbmp(922,'FUH_BL_12.bmp');

%Setting up variables for later use
% = 14100 ; %Each trial is 14.1 seconds long (TR=2.35 * 6 = 14.1 s)changed to allow for clear of odor
 
odorindex=[]; %Matrix of which odor was used in each trial--should match column 1 of stimord
odorvalindex = []; % Matrix after recoding in cogent to classify all 8 odors as 3 valences
picindex=[]; %Matrix of which face was used in each trial--should match column 2 of stimord
picvalindex=[];
foodindex = [];
foodvalindex = [];
foodcondindex = [];
 
odoronTimes  = [];
odordurTimes = [];
odoronMRtimes = [];
piconTimes = [];
picdurTimes = [];
piconMRtimes = [];
foodonTimes = [];
fooddurTimes = [];
foodonMRtimes = [];
 
jitter1times = [];
jitter2times = [];
 
odoronTimes_foodval = cell(1,2);
odordurTimes_foodval = cell(1,2);
odoronMRtimes_foodval = cell(1,2);
 
odoronTimes_odorval  = cell(1,5);  %Matrix of odor onset times (when odor reaches participant)indexed by odor condition
odordurTimes_odorval = cell(1,5); 
odoronMRtimes_odorval = cell(1,5);%***for fMRI version****
 
piconTimes_foodval = cell(1,2);
picdurTimes_foodval = cell(1,2);
piconMRtimes_foodval = cell(1,2);
 
piconTimes_picval = cell(1,5);
picdurTimes_picval = cell(1,5);
piconMRtimes_picval  = cell(1,5);
 
foodonTimes_foodval = cell(1,2);
fooddurTimes_foodval = cell(1,2);
foodonMRtimes_foodval = cell(1,2);
 
foodonTimes_odorval = cell(1,5);
fooddurTimes_odorval = cell(1,5);
foodonMRtimes_odorval = cell(1,5);%***for fMRI version****
 
foodonTimes_picval = cell(1,5);
fooddurTimes_picval = cell(1,5);
foodonMRtimes_picval = cell(1,5);%***for fMRI version****
 
noresp_onTimes  = []; % Above matrix for trials where no response was given
noresp_durTimes = []; % Above matrix for trials where no response was given
noresp_onMRtimes = [];
 
allRTs = [];
RTs_foodval = cell(1,2);
RTs_odorval = cell(1,5);
RTs_picval = cell(1,5);
 
allButtOns_MRtimes = [];%***for fMRI version**** 
 
FoodResp = cell(1,5);
OdorResp = cell(1,13);
PicResp = cell(1,13);
yesresp = 0;
noresp = 0;
 
presses = 0;%added back in for allButtOns resp 3/29
 
resp=[]; %3/24
resp_all =[]; %3/24
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
cgpencol(0,0,1); % blue
cgfont('Arial',24)
cgpencol(0,0,0)%black text
 
cgtext('Watch the screen when you see Watch Now',0,2.05 * ScrHgh/6-15);
cgpencol(0,0,1); % blue
cgfont('Arial',24)
cgpencol(0,0,0)%black text
 
cgtext('Categorize foods as HEALTHY or UNHEALTHY using the button box',0,1.45 * ScrHgh/6-15); %Convert to use of one button box
cgloadbmp(001,'Food_instruction_picture.bmp');

%loadpict(cell2mat(foodinstruc(1),1));
cgdrawsprite(001,-30,-100);
cgflip
pause on
pause(16);
 
% present crosshair
cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])
cgfont('Arial',60);
cgpencol(1,0,0); %red
cgtext('+',0,0);
cgflip
 
cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])
% picture buffer(5) is now blank (no response buttons displayed
 
%stime = cogstd('sGetTime', -1) * 1000;%change this TIME = 0 to typical cogent time stamp
 
if whichplace == 1  % i.e., scanning study with scanner pulses
%    clearserialbytes(PC);
    
    % Wait here for the first bold rep trigger to occur.
    parallel_wait;
    
    % Grab the time 
    scanon = cogstd('sGetTime', -1) * 1000;
    
else  % i.e., pilot study in absence of scanner pulses
    scanon = cogstd('sGetTime', -1) * 1000;%not sure if this is correct
    pause(5)
end
 
% Change crosshair color to blue.  This is to indicate to the experimenters
% that the parallel port received the trigger and is now getting baseline
% information.  This crosshairs will stay up for 30 seconds, the
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
    
    
    %odor conditions (1-13) and control (13)
    if odorpres == 1 %Odor present = yes
        odorval = stimord(i,3);
        if (odorid > 0) && (odorid < 4) %for odor IDs 1,2,3 (Neutral Sweat)
            Port = 1; % Left port B on olfactometer
            PortBid = odorid; % PortB 0-2 on olfactometer
        elseif (odorid > 3) && (odorid < 7) %for odor IDs 4,5,6 (Disgust Sweat)
            Port = 1; % Left port B on olfactometer
            PortBid = odorid; % PortB 3-5 on olfactometer
        elseif (odorid > 6) && (odorid < 10) %for odor IDs 7,8,9 (Neutral Odor)
            Port = 2; % Right port on A olfactometer
            PortAid = odorid-6; % PortA 0-2 on olfactometer
        elseif (odorid > 9) && (odorid < 13) %for odor IDs 10,11,12 (Disgust Odor)
            Port = 2; % Right port on A olfactometer
            PortAid = odorid-6; % PorA 3-5 on olfactometer
        elseif odorid == 13 %For odor ID 13 (no odor)
            airid = 7; % PortB 6 on olfactometer
        end
        odorvalindex = [odorvalindex odorval];
    else
        airid = 7;
    end
    
    %pic conditions (14-26) and control (26)
    if picpres == 1 %Pic present = yes
        picval = stimord(i,4);
        picvalindex = [picvalindex picval];
    else
    end
    
    foodid = stimord(i,7);
    if foodid == 0
        foodid = 99;
    end
    foodval = stimord(i,8); % Will be orginal size in this block
    foodindex = [foodindex, foodid];
    foodvalindex = [foodvalindex, foodval];
    
    if foodval == 0
        foodcond = 5;
    else
        foodcond = foodval;
    end
    foodcondindex = [foodcondindex foodcond];
    
    readycue='+';
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
        tO=cgflip*1000 ; %time of the sniff now sign/odor onset
        pause(.3); % foon cross on for 0.2 second
        timectr = [timectr tO]; % YZ Confused. use tO/odor_on as odor onset time?
        
        % *** TURN ODOR ON ***
        if Port == 1
            usb2_line_on(PortBid , 0); % Deliver the odor according to the ID number
        elseif Port == 2
            usb2_line_on(0,PortAid );
        end
        odor_on = cogstd('sGetTime', -1) * 1000;
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
        cgpencol(0,0,1) %  turns to blue to signal pic cue
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
        cgpencol(0,0,1) %  turns to blue to signal sniff cue
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
        pause(2);
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

    
   % *** FOOD ON ***
    cgrect(0, 0, ScrWid, ScrHgh, [0.6 0.6 0.6])  % Clear back screen to white
    cgdrawsprite(foodid,0,0) ; %Prepare food 
    food_on = cgflip * 1000 ;
    parallel_acquire ; %send trigger to Physio
    
    FlushEvents();
    
    %dio_acquire ;
    bFoodOff = false ;
    
    resp = []; %added 3/29 to reset resp for every trial
    resp_key = [];
    button_pressed=false;
    key=[];
    keyStrings = {'b','y','g','r'};
    
    
    % Check the (odor_on + <time>) <time> value to the duration in milliseconds
    % That the subject has to respond.
    while ((cogstd('sGetTime', -1) * 1000) < (food_on + (700 + ((8.1)*1000))))
        
        
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
                resp_key = key;
                t_in_cog = (cogstd('sGetTime', -1) * 1000);
                %  t_in_ptb = rt;
                button_pressed = true;
                resp_length=length(key);
                resp_list=[];
                rt_list=[];
                keycell={'l'};
                if iscell(key)
                    for i = 1:resp_length
                        keycell(1,i+1)=(key(1,i));
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
        
        if ((bFoodOff == false) && ((cogstd('sGetTime', -1) * 1000) > (food_on + 700)))
            % log the greeble time
            cgrect(0, 0, ScrWid, ScrHgh, [0.6 0.6 0.6])  % Clear back screen to white
            cgpencol(0,0,0)  % black fixation for rest of trial
            cgfont('Arial',48)
            cgtext('+',0,0.15);
            tFoodoff = cgflip*1000; % Greeble off time
            
            parallel_acquire ; %send trigger to Physio
            bFoodOff = true ;
        end
        
    end
    
    if odorpres == 1 && picpres == 0
        % first collate odor times
        odoronTimes = [odoronTimes tO]; % ?????? tO/odor_on
        odordurTimes = [odordurTimes tOoff-odor_on];
        odoronMRtimes = [odoronMRtimes tO-starttime];
        % odor onset
        odoronTimes_foodval{foodcond} = [odoronTimes_foodval{foodcond} tO];
        odordurTimes_foodval{foodcond} = [odordurTimes_foodval{foodcond} tOoff-odor_on];
        odoronMRtimes_foodval{foodcond} = [odoronMRtimes_foodval{foodcond} tO-starttime];
        
        odoronTimes_odorval{odorval} = [odoronTimes_odorval{odorval} tO];
        odordurTimes_odorval{odorval} = [odordurTimes_odorval{odorval} tOoff-odor_on];
        odoronMRtimes_odorval{odorval} = [odoronMRtimes_odorval{odorval} tO-starttime];
        
        %  jitter1times_odorval{odorval} = [jitter1times_odorval{odorval} jitter1];
        % jitter2times_odorval{odorval} = [jitter2times_odorval{odorval} jitter2];
        
        foodonTimes_odorval{odorval} = [foodonTimes_odorval{odorval} food_on];
        fooddurTimes_odorval{odorval} = [fooddurTimes_odorval{odorval} tFoodoff - food_on];
        foodonMRtimes_odorval{odorval} = [foodonMRtimes_odorval{odorval} food_on-starttime];
        
    elseif odorpres == 0 && picpres == 1
        piconTimes = [piconTimes tPon];
        picdurTimes = [picdurTimes tPoff-tPon];
        piconMRtimes = [piconMRtimes tPon-starttime];
        % Pic onset
        piconTimes_foodval{foodcond} = [piconTimes_foodval{foodcond} tPon];
        picdurTimes_foodval{foodcond} = [picdurTimes_foodval{foodcond} tPoff-tPon];
        piconMRtimes_foodval{foodcond} = [piconMRtimes_foodval{foodcond} tPon-starttime];
        
        piconTimes_picval{picval} = [piconTimes_picval{picval} tPon];
        picdurTimes_picval{picval} = [picdurTimes_picval{picval} tPoff-tPon];
        piconMRtimes_picval{picval} = [piconMRtimes_picval{picval} tPon-starttime];
        
        %jitter1times_picval{picval} = [jitter1times_picval{picval} jitter1];
        %jitter2times_picval{picval} = [jitter2times_picval{picval} jitter2];
        
        foodonTimes_picval{picval} = [foodonTimes_picval{picval} food_on];
        fooddurTimes_picval{picval} = [fooddurTimes_picval{picval} tFoodoff-food_on];
        foodonMRtimes_picval{picval} = [foodonMRtimes_picval{picval} food_on-starttime];
        
    elseif odorpres == 0 && picpres == 0
        
    end
    % jitter time
    %jitter1times = [jitter1times jitter1];
    %jitter2times = [jitter2times jitter2];
    
    foodonTimes = [foodonTimes food_on];
    fooddurTimes = [fooddurTimes tFoodoff-food_on];
    foodonMRtimes = [foodonMRtimes  food_on-starttime];
    % food onset
    foodonTimes_foodval{foodcond} = [foodonTimes_foodval{foodcond} food_on];
    fooddurTimes_foodval{foodcond} = [fooddurTimes_foodval{foodcond} tFoodoff-food_on];
    foodonMRtimes_foodval{foodcond} = [foodonMRtimes_foodval{foodcond} food_on-starttime];
   
    PICID=picid-13;
    if button_pressed == true    % If any button response was recorded, byte_in should be greater than 0.
        response = resp_list_f; %Response is the value that everything will be compared to.
        presses = presses + 1; %Records if a button was pressed during the trial; this should be equal to the number of trials
        rt = rt_list_f - food_on; % The response time is the time from the greeble onset to the time of the button press.
        % rtPTB=t_in_ptb(1) - gree_on;
        allRTs = [allRTs rt];
        allButtOns_MRtimes(presses) = rt_list_f - starttime; %Collates all response times and corrects them for scanner times
        %
        if odorpres == 1 && picpres == 0 % Odor condition
            if response == 1
                RTs_foodval{foodcond} = [RTs_foodval{foodcond} rt];
                RTs_odorval{odorval} = [RTs_odorval{odorval} rt];
                % RTsptb_foodval{foodcond} = [RTs_foodval{foodcond} rtPTB];
                %RTsptb_odorval{odorval} = [RTs_odorval{odorval} rtPTB];
                respval = 1;
                responsevaluesall = [responsevaluesall respval];
                FoodResp{foodcond} = [FoodResp{foodcond} respval];
                OdorResp{odorid} = [OdorResp{odorid} respval];
               % PicResp{PICID} = [OdorResp{PICID} respval];
            elseif response == 2
                RTs_foodval{foodcond} = [RTs_foodval{foodcond} rt];
                RTs_odorval{odorval} = [RTs_odorval{odorval} rt];
                %RTsptb_foodval{foodcond} = [RTs_foodval{foodcond} rtPTB];
                %RTsptb_odorval{odorval} = [RTs_odorval{odorval} rtPTB];
                respval = 2;
                responsevaluesall = [responsevaluesall respval];
                FoodResp{foodcond} = [FoodResp{foodcond} respval];
                OdorResp{odorid} = [OdorResp{odorid} respval];
                %PicResp{PICID} = [OdorResp{PICID} respval];
            elseif response == 3
                RTs_foodval{foodcond} = [RTs_foodval{foodcond} rt];
                RTs_odorval{odorval} = [RTs_odorval{odorval} rt];
                %RTsptb_foodval{foodcond} = [RTs_foodval{foodcond} rtPTB];
                %RTsptb_odorval{odorval} = [RTs_odorval{odorval} rtPTB];
                respval = 3;
                responsevaluesall = [responsevaluesall respval];
                FoodResp{foodcond} = [FoodResp{foodcond} respval];
                OdorResp{odorid} = [OdorResp{odorid} respval];
                %PicResp{PICID} = [OdorResp{PICID} respval];
            elseif response == 4
                RTs_foodval{foodcond} = [RTs_foodval{foodcond} rt];
                RTs_odorval{odorval} = [RTs_odorval{odorval} rt];
                %RTsptb_foodval{foodcond} = [RTs_foodval{foodcond} rtPTB];
                %RTsptb_odorval{odorval} = [RTs_odorval{odorval} rtPTB];
                respval = 4;
                responsevaluesall = [responsevaluesall respval];
                FoodResp{foodcond} = [FoodResp{foodcond} respval];
                OdorResp{odorid} = [OdorResp{odorid} respval];
                %PicResp{PICID} = [OdorResp{PICID} respval];
            else
                RTs_foodval{foodcond} = [RTs_foodval{foodcond} NaN];
                RTs_odorval{odorval} = [RTs_odorval{odorval} NaN];
                %RTsptb_foodval{foodcond} = [RTs_foodval{foodcond} NaN];
                %RTsptb_odorval{odorval} = [RTs_odorval{odorval} NaN];
                respval = 0;
                responsevaluesall = [responsevaluesall respval];
                FoodResp{foodcond} = [FoodResp{foodcond} respval];
                OdorResp{odorid} = [OdorResp{odorid} respval];
                
            end
        elseif odorpres == 0 && picpres == 1 % Pic condition
            if response == 1
                RTs_foodval{foodcond} = [RTs_foodval{foodcond} rt];
                RTs_picval{picval} = [RTs_picval{picval} rt];
                %RTsptb_foodval{foodcond} = [RTs_foodval{foodcond} rtPTB];
                %RTsptb_picval{picval} = [RTs_picval{picval} rtPTB];
                respval = 1;
                responsevaluesall = [responsevaluesall respval];
                FoodResp{foodcond} = [FoodResp{foodcond} respval];
                OdorResp{odorid} = [OdorResp{odorid} respval];
                PicResp{PICID} = [PicResp{PICID} respval];
            elseif response == 2
                RTs_foodval{foodcond} = [RTs_foodval{foodcond} rt];
                RTs_picval{picval} = [RTs_picval{picval} rt];
                %RTsptb_foodval{foodcond} = [RTs_foodval{foodcond} rtPTB];
                %RTsptb_picval{picval} = [RTs_picval{picval} rtPTB];
                respval = 2;
                responsevaluesall = [responsevaluesall respval];
                FoodResp{foodcond} = [FoodResp{foodcond} respval];
                OdorResp{odorid} = [OdorResp{odorid} respval];
                PicResp{PICID} = [PicResp{PICID} respval];
            elseif response == 3
                RTs_foodval{foodcond} = [RTs_foodval{foodcond} rt];
                RTs_picval{picval} = [RTs_picval{picval} rt];
                %RTsptb_foodval{foodcond} = [RTs_foodval{foodcond} rtPTB];
                %RTsptb_picval{picval} = [RTs_picval{picval} rtPTB];
                respval = 3;
                responsevaluesall = [responsevaluesall respval];
                FoodResp{foodcond} = [FoodResp{foodcond} respval];
                OdorResp{odorid} = [OdorResp{odorid} respval];
                PicResp{PICID} = [PicResp{PICID} respval];
            elseif response == 4
                RTs_foodval{foodcond} = [RTs_foodval{foodcond} rt];
                RTs_picval{picval} = [RTs_picval{picval} rt];
                %RTsptb_foodval{foodcond} = [RTs_foodval{foodcond} rtPTB];
                %RTsptb_picval{picval} = [RTs_picval{picval} rtPTB];
                respval = 4;
                responsevaluesall = [responsevaluesall respval];
                FoodResp{foodcond} = [FoodResp{foodcond} respval];
                OdorResp{odorid} = [OdorResp{odorid} respval];
                PicResp{PICID} = [PicResp{PICID} respval];
            else
                RTs_foodval{foodcond} = [RTs_foodval{foodcond} NaN];
                RTs_picval{picval} = [RTs_picval{picval} NaN];
                %RTsptb_foodval{foodcond} = [RTs_foodval{foodcond} NaN];
                %RTsptb_picval{picval} = [RTs_picval{picval} NaN];
                respval = 0;
                responsevaluesall = [responsevaluesall respval];
                FoodResp{foodcond} = [FoodResp{foodcond} respval];
                OdorResp{odorid} = [OdorResp{odorid} respval];
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
            PicResp{PICID} = [OdorResp{PICID} 0];
        end
        RTs_foodval{foodcond} = [RTs_foodval{foodcond} NaN];
        respval = 0;
        responsevaluesall = [responsevaluesall respval];
        FoodResp{foodcond} = [FoodResp{foodcond} respval];
        
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
        str1 = sprintf('Trial %d : Odor ID %d and Food ID %d', i, odorid, foodid);
        str2 = sprintf('Odor On at %d ms (MRTime %d ms) sniffed for %d ms duration', odor_on, odor_on-starttime, tOoff-odor_on);
        str3 = sprintf('Food On at %d ms (MRTime %d ms) for %d ms duration', food_on, food_on-starttime, tFoodoff-food_on);
        str4 = sprintf('Response: %d', respval);
        log_string(str1);
        log_string(str2);
        log_string(str3);
        log_string(str4);
    elseif odorpres == 0 && picpres == 1 % Pic condition
        str5 = sprintf('Trial %d : Pic ID %d and Food ID %d', i, picid, foodid);
        str6 = sprintf('Pic On at %d ms (MRTime %d ms) watch for %d ms duration', tPon, tPon-starttime, tPoff-tPon);
        str7 = sprintf('Food On at %d ms (MRTime %d ms) for %d ms duration', food_on, food_on-starttime, tFoodoff-food_on);
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
 
results.onsets.foodonTimes = foodonTimes;
results.onsets.fooddurTimes = fooddurTimes;
results.onsets.foodonMRtimes = foodonMRtimes;
 
results.onsets.odoronTimes_foodval = odoronTimes_foodval;
results.onsets.odordurTimes_foodval = odordurTimes_foodval;
results.onsets.odoronMRtimes_foodval = odoronMRtimes_foodval;
results.onsets.odoronTimes_odorval     = odoronTimes_odorval ;
results.onsets.odordurTimes_odorval    = odordurTimes_odorval ;
results.onsets.odoronMRtimes_odorval   = odoronMRtimes_odorval ;%***for fMRI version****
results.onsets.foodonTimes_odorval = foodonTimes_odorval;
results.onsets.fooddurTimes_odorval = fooddurTimes_odorval;
results.onsets.foodonMRtimes_odorval = foodonMRtimes_odorval;
 
results.onsets.piconTimes_foodval = piconTimes_foodval;
results.onsets.picdurTimes_foodval = picdurTimes_foodval;
results.onsets.piconMRtimes_foodval = piconMRtimes_foodval;
results.onsets.piconTimes_picval = piconTimes_picval ;
results.onsets.picdurTimes_picval = picdurTimes_picval ;
results.onsets.piconMRtimes_picval = piconMRtimes_picval ;
results.onsets.foodonTimes_picval = foodonTimes_picval;
results.onsets.fooddurTimes_picval = fooddurTimes_picval;
results.onsets.foodonMRtimes_picval = foodonMRtimes_picval;
 
results.onsets.noresp_onTimes       = noresp_onTimes;
results.onsets.noresp_durTimes      = noresp_durTimes;
results.onsets.noresp_onMRtimes      = noresp_onMRtimes;
 
results.demographics.age = age ;
results.demographics.gender = gender ;
results.demographics.ethnicity = eth ;
 
results.behav.resp_all    = resp_all; %**
results.behav.resp             = resp;%**
results.behav.allRTs = allRTs;
%results.behav.RTsptb_foodval = RTsptb_foodval;
results.behav.RTs_foodval = RTs_foodval;
results.behav.RTs_odorval = RTs_odorval;
%results.behav.RTsptb_odorval = RTsptb_odorval;
results.behav.RTs_picval = RTs_picval;
%results.behav.RTsptb_picval = RTsptb_picval;
results.behav.FoodResp = FoodResp;
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
results.checks.foodcond = foodcondindex;
results.checks.stiminfo     = stimord;
results.checks.odorcheck    = stimord(:,1) ; %should match results.checks.odorid
results.checks.piccheck     = stimord(:,2) ; %should match results.checks.picid
results.checks.odvalcheck   = stimord(:,3);
results.checks.picvalcheck   = stimord(:,4);
results.checks.odorprescheck    = stimord(:,5);
results.checks.picprescheck    = stimord(:,6);
results.checks.foodcheck = stimord(:,7);
results.checks.foodvalcheck = stimord(:,8);
 
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
eval(['save  ARF_Sweat_Foodblock_' deblank(name_id) '_sub' num2str(subnum)  ' results']);
cd(dm);
 
%}
 
pause off
log_finish ;
usb2_finish ;
parallel_finish ;
 
cgshut


